# BroadcastHub Migration Checklist

- [ ] Install the BroadcastHub engine and run the initializer generator.
- [ ] Configure `allowed_resources`, `authorize_scope`, and `stream_key_resolver` in the initializer.
- [ ] Migrate one resource first and validate `create`, `update`, and `destroy` payloads end-to-end.
- [ ] Validate rejection paths for `missing resource` and `unauthorized tenant` subscriptions.
- [ ] Validate cross-tenant broadcast isolation (tenant A cannot receive tenant B events).
- [ ] Validate no-auth mode using a session-based resolver path.
- [ ] Validate there is no runtime dependency on `turbo-rails` for BroadcastHub payload flow.
- [ ] Roll out remaining resources incrementally after the first migration succeeds.
