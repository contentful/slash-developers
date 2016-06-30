'use strict';

var hooks = require('hooks');
var delay = 1000/6.0;

hooks.afterEach(function (transaction, done) {
  setTimeout(done, delay);
});
