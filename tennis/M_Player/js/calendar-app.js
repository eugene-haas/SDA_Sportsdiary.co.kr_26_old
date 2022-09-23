requirejs.config({
  baseUrl : '../js',
  paths: {
    'jquery': './library/jquery-1.12.2.min',
    'moment': './library/moment.min',
    'fullcalendar': './library/fullcalendar',
    'fullcalendarMin': './library/fullcalendar.min',
    'ko': './library/ko',
  }
});

requirejs([
  'jquery',
  ],
  function ($) {
    $(document).ready(function(){
      loadCalendar();
    });

    function loadCalendar() {
      var $head = $('head');
      var momentSrc = '../js/library/moment.min.js';
      var fullCalendarSrc = '../js/library/fullcalendar.js';
      var fullCalendarMinSrc = '../js/library/fullcalendar.min.js';
      var koSrc = '../js/library/ko.js';
      var loadCalendarSrc = '../js/loadCalendar.js';
      $head.append('<script src='+ momentSrc +'></script>');
      $head.append('<script src='+ fullCalendarSrc +'></script>');
      $head.append('<script src='+ fullCalendarMinSrc +'></script>');
      $head.append('<script src='+ koSrc +'></script>');
      $head.append('<script src='+ loadCalendarSrc +'></script>');

      $('#calendar').fullCalendar();
    };
  }
);