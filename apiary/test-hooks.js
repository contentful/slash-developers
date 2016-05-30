'use strict';

var hooks = require('hooks');
var delay = 1000/6.0;

hooks.beforeEach(function (t, done) {
  let webhookCallPath = '/spaces/example/webhooks/hook123/calls/A123FOO';

  if (t.fullPath === webhookCallPath) {
    // Skip GET webhook call test.
    //
    // Read https://github.com/contentful/slash-developers/pull/279#issuecomment-222452488
    // for more context
    t.skip = true;
  }

  done();
});

hooks.afterEach(function (transaction, done) {
  setTimeout(done, delay);
});
