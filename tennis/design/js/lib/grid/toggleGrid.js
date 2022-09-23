/*! toggleGrid.js © yamoo9.net, 2016 */
(function(global){
  'use strict';

  var body       = document.body;
  var containers = document.querySelectorAll('.container_body');

  document.onkeydown = function(event) {
    if( event === true || event.keyCode === 71 && event.shiftKey) {
      $(containers).toggleClass('show-leading');
      Array.prototype.forEach.call(containers, function(container) {
        container.classList.toggle('show-grid');
      });
    }
  };

})(this);