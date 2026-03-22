# BroadcastHub Migration Checklist

## Task 6 - App migration completion state

- [x] Todo broadcasting migrated to `BroadcastHub::Broadcaster`.
- [x] Legacy `Broadcaster` runtime usage disabled.
- [x] Generic `BroadcastHub::StreamChannel` contract validated.
- [x] JavaScript subscription wiring switched to BroadcastHub.

## Deferred cleanup policy

- [x] Legacy `Broadcaster` files are retained temporarily for migration traceability and safe rollback.
- [ ] Remove retained legacy broadcaster files in a dedicated follow-up cleanup task after migration stability window.

## Final verification used

- [x] `bundle exec rspec spec/engines/broadcast_hub spec/models spec/controllers spec/channels spec/javascripts/jasmine_runner_spec.rb`
