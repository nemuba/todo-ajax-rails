# BroadcastHub Engine Design

Date: 2026-03-21
Status: Approved for planning
Scope: Rails mountable engine (gem) to extract broadcaster + Action Cable + jQuery channel logic for reuse across apps.

## 1. Goals

- Extract current app-specific broadcasting logic into a reusable Rails engine.
- Support Rails 5.2+ apps.
- Provide a single generic Action Cable channel.
- Provide frontend JS support for both Sprockets (default) and Webpacker (optional).
- Keep payload format server-rendered HTML so client only applies DOM operations.
- Support apps with and without authentication through flexible stream-key resolution.
- Keep engine APIs framework-neutral for Rails 5.2 baseline (no hard dependency on Turbo APIs).

## 2. Non-Goals

- Replacing Action Cable with another transport.
- Client-side template rendering as default behavior.
- Resource-specific channels as the primary API.

## 3. High-Level Architecture

Monolithic mountable engine named `BroadcastHub` containing:

- Backend concerns/services for lifecycle broadcasting.
- Generic Action Cable channel (`BroadcastHub::StreamChannel`).
- Configurable stream-key strategy (user/session/custom).
- JS subscriber + jQuery controller for `append`, `prepend`, `update`, `remove`.
- Install generator and initializer.

The host app integrates by installing the engine, configuring stream-key policy, and including the broadcaster concern in desired models.

## 4. Approved Decisions

- Packaging: mountable Rails engine gem.
- Compatibility: Rails 5.2+.
- Design style: hybrid architecture goals, implemented as monolithic engine package.
- Channel: single generic channel.
- Stream identity: default strategy `tenant + user`, with fallback support for no-auth scenarios.
- Payload format: HTML-ready payload from server.
- Frontend delivery: Sprockets default + optional Webpacker entrypoint.

## 5. Stream Identity and Security

### 5.1 Requirement

Do not require `current_user` in all apps.

### 5.2 Design

Expose `stream_key_resolver` in configuration:

```ruby
BroadcastHub.configure do |config|
  config.stream_key_resolver = lambda do |context|
    if context.current_user
      "tenant:#{context.tenant_id}:#{context.resource_name}:user:#{context.current_user.id}"
    else
      "tenant:#{context.tenant_id}:#{context.resource_name}:session:#{context.session_id}"
    end
  end
end
```

`context` includes at least: `current_user`, `session_id`, `tenant_id`, `resource_name`, and channel params.

### 5.3 Security Rules

- Never trust raw stream keys from client input.
- Never derive `tenant_id` or `resource_name` from untrusted params without allowlisting.
- Always authorize requested tenant/resource scope against connection identity.
- Resolve stream keys server-side only.
- Reject subscription when resolver cannot safely produce a key.
- Keep publisher and subscriber using the exact same resolver strategy.

### 5.4 Action Cable Context Requirements

- If auth is available, resolver may use `current_user`.
- If auth is not available, resolver may use a signed/verified session identity.
- `session_id` is not assumed by default in Cable context; the engine installer documents how to expose a safe session token in `ApplicationCable::Connection`.

## 6. Broadcast Payload Contract

Canonical payload:

```json
{
  "version": 1,
  "action": "append|prepend|update|remove",
  "target": "todos",
  "content": "<li id='todo_42'>...</li>",
  "id": "todo_42",
  "meta": {
    "resource": "todo",
    "timestamp": "2026-03-21T12:00:00Z",
    "request_id": "..."
  }
}
```

Notes:

- `content` is required for `append`, `prepend`, and `update`.
- `remove` may omit `content`.
- `id` is used when target specificity is needed for update/remove.

Field contract:

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `version` | Integer | Yes | Starts at `1`; must be present for forward compatibility. |
| `action` | String | Yes | One of: `append`, `prepend`, `update`, `remove`. |
| `target` | String | Yes | DOM target key/selector agreed by host app. |
| `content` | String (HTML) | Conditional | Required for `append`, `prepend`, `update`; optional for `remove`. Recommended max payload size: 64KB. |
| `id` | String | Conditional | Optional globally; strongly recommended for `update`/`remove` targeting. |
| `meta` | Object | No | Non-authoritative diagnostics/context only. |

Action semantics:

- `append`: add `content` to end of `target` container.
- `prepend`: add `content` to beginning of `target` container.
- `update`: if `id` exists update by `id`, else update `target`.
- `remove`: if `id` exists remove by `id`, else remove `target` element.

HTML safety rule:

- `content` must come from trusted server rendering paths.
- User-supplied values must be escaped/sanitized by server templates.
- Client must never inject arbitrary external HTML through this pipeline.

## 7. End-to-End Flow

1. Model callback fires (`after_create_commit`, `after_update_commit`, `after_destroy_commit`).
2. Concern asks renderer for HTML partial.
3. Payload builder normalizes action/target/content/id/meta.
4. Stream key is resolved via configured resolver.
5. Engine broadcasts through Action Cable to generic stream channel.
6. JS subscriber receives payload and forwards to jQuery controller.
7. jQuery controller applies DOM operation using `id` first (for `update`/`remove` when present), then `target` fallback.

Terminology mapping:

- `resource_name`: logical domain identifier for stream partitioning (`todo`, `order`).
- `target`: DOM insertion/update/removal destination (`#todos`, `[data-list='todos']`).
- `id`: optional item-level DOM identifier (`todo_42`) used to disambiguate updates/removals.

## 8. Engine Components

### 8.1 Ruby

- `BroadcastHub::Broadcaster` (concern/macros)
- `BroadcastHub::PayloadBuilder`
- `BroadcastHub::StreamKeyResolver`
- `BroadcastHub::Renderer`
- `BroadcastHub::StreamChannel`
- `BroadcastHub::Configuration`

### 8.2 JavaScript

- `broadcast_hub/subscription.js`
- `broadcast_hub/jquery_controller.js`
- `broadcast_hub/index.js`

## 9. Public API (Initial)

```ruby
BroadcastHub.configure do |config|
  config.stream_key_resolver = ->(context) { ... }
  config.update_strategy = :replace_with # or :html
  config.strict_client_validation = false
end
```

Model integration example:

```ruby
class Todo < ApplicationRecord
  include BroadcastHub::Broadcaster

  broadcast_to :todos, partial: "todos/todo", target: "todos"
end
```

Supported server actions:

- `broadcast_append(target)`
- `broadcast_prepend(target)`
- `broadcast_update(target)`
- `broadcast_remove(target)`

Optional adapter methods may be provided for compatibility with existing app naming conventions.

### 9.1 Channel Contract

Subscription input (from client to channel):

- `resource` (required): logical resource key, allowlisted.
- `tenant` (optional): tenant identifier if multi-tenant app.

Server behavior:

- Build resolver context from authenticated/signed connection identity + allowlisted params.
- If params are invalid or unauthorized, reject subscription.
- If resolver cannot produce key, reject subscription.
- On success, `stream_from(resolved_stream_key)`.

Rejection semantics:

- Channel rejects subscription without exposing sensitive authorization details.
- Development logs may include structured reason code (`invalid_resource`, `unauthorized_scope`, `missing_identity`).

## 10. File/Folder Layout

```text
lib/broadcast_hub/engine.rb
lib/broadcast_hub/configuration.rb
app/models/concerns/broadcast_hub/broadcaster.rb
app/services/broadcast_hub/payload_builder.rb
app/services/broadcast_hub/stream_key_resolver.rb
app/services/broadcast_hub/renderer.rb
app/channels/broadcast_hub/stream_channel.rb
vendor/assets/javascripts/broadcast_hub/*
app/javascript/broadcast_hub/*
lib/generators/broadcast_hub/install_generator.rb
```

## 11. Error Handling

- Backend validates required payload fields before broadcast.
- Renderer failures are configurable: log + skip (default) or raise in strict mode.
- Channel subscription failure returns rejection when stream key missing/invalid.
- Client ignores invalid events and logs warnings in development.
- Payload validation failures should include non-sensitive reason codes for diagnostics.

## 12. Testing Strategy

- Unit tests for concern callbacks and payload builder.
- Channel tests for subscription and stream-key enforcement.
- Dummy app integration tests on Rails 5.2 baseline.
- JS behavior tests for jQuery DOM operations.
- Coverage for both auth and no-auth stream resolver modes.
- Tenant isolation tests (cannot subscribe/broadcast across unauthorized tenant).
- Unauthorized subscription attempts (rejection path).
- Malformed payload rejection and no-op behavior on client.
- XSS regression tests for escaped/safe template output.
- Ordering/idempotency tests for repeated or out-of-order events.

## 13. Adoption Plan for Existing Apps

1. Install engine and run generator.
2. Configure resolver (user/session/custom) in initializer.
3. Include concern in one model first.
4. Switch that model/channel traffic to engine generic channel.
5. Validate payload + DOM behavior.
6. Migrate remaining resources incrementally.

## 14. Implementation Phases

1. Core Ruby (config, concern, payload, renderer, resolver).
2. Generic channel.
3. Hybrid JS delivery and jQuery controller.
4. Generator + docs.
5. E2E tests and migration examples.

## 15. Open Questions (to resolve in planning)

- Naming final package (`BroadcastHub` vs project-specific brand).
- Whether `update_strategy` default should be `:replace_with` or `:html` per host app conventions.
- How much metadata to include by default in payload `meta`.
