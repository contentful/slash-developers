'use strict';

var hooks = require('hooks');
var delay = 1000/6.0;

hooks.afterEach(function (transaction, done) {
  setTimeout(done, delay);
});


hooks.before("Synchronization > Pagination and subsequent syncs > Query entries", function (transaction) {
  transaction.skip = true;
});
