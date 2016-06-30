'use strict';

var hooks = require('hooks');

const DELAY = 1000/6.0;
const SECRET_HEADERS = ['Authorization'].map(header => header.toLowerCase());

/** We remove this data every 30 days making it incredibly hard to test.
 *
 * Read https://github.com/contentful/slash-developers/pull/279#issuecomment-222452488
 * for more context
 */
hooks.before(
  "Webhook calls > Webhook call details > Get the webhook call details",
  function (transaction) {
    transaction.skip = true;
  });

hooks.afterEach(function (transaction, done) {
  // Some headers contain private data, we need to censor these
  Object.keys(transaction.request.headers).forEach(function(key) {
    if (SECRET_HEADERS.indexOf(key.toLowerCase()) > -1) {
      transaction.request.headers[key] = "***HIDDEN SECRET DATA***";
    }
  });

  setTimeout(done, DELAY);
});
