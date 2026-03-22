const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const indexPath = path.join(
  __dirname,
  '..',
  '..',
  'engines',
  'broadcast_hub',
  'app',
  'javascript',
  'broadcast_hub',
  'index.js'
);

test('webpack entry defines BroadcastHub namespace aliases', () => {
  const source = fs.readFileSync(indexPath, 'utf8');

  assert.match(source, /root\.BroadcastHub\s*=\s*root\.BroadcastHub\s*\|\|\s*\{\s*\}/);
  assert.match(source, /root\.BroadcastHub\.JQueryController\s*=\s*root\.BroadcastHubJQueryController/);
  assert.match(source, /root\.BroadcastHub\.Subscription\s*=\s*root\.BroadcastHubSubscription/);
});

test('webpack entry uses deterministic global assignments', () => {
  const source = fs.readFileSync(indexPath, 'utf8');

  assert.doesNotMatch(
    source,
    /root\.BroadcastHubJQueryController\s*=\s*root\.BroadcastHubJQueryController\s*\|\|/
  );
  assert.doesNotMatch(
    source,
    /root\.BroadcastHubSubscription\s*=\s*root\.BroadcastHubSubscription\s*\|\|/
  );
});
