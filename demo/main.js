define(function(require) {
  var data = require('cson!data');

  $(document).ready(function() {
    alert(data.some_data.y.join(' '));
  });
});