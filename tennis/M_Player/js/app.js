define(function(){
  "use strict";

  var exports = {
    version : "1.0"
  };

  var private1 = "private1";
  var private2 = "private2";

  exports.doSomething = function() {
    console.log('Do Some Thing');
  };
  exports.stopSomething = function(){
    console.log('stop Something');;
  }
  return exports;
})