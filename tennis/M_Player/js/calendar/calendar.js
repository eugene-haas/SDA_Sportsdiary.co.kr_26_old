requirejs.config({
  baseUrl : '../js/library',
  paths : {
    jquery : './jquery-1.12.2.min',
    easing : './jquery.easing.1.3.min',
    fullcalendar : './fullcalendar',
    fullcalendarMin : './fullcalendar.min',
    moment : './moment.min',
    locale : './locale-all'
  },
});

define(['jquery', 'easing', 'fullcalendar', 'fullcalendarMin', 'locale', 'moment'], function($, easing, fullcalendar, fullcalendarMin, locale, moment){

  var url = window.location.toString();

  if (url.match('institute-search'))
    callCalendar(NowDate,defidx);
  if (url.match('sche-calendar')) {
//    $('#calendar').fullCalendar({
//      locale: 'ko',
//      header: {
//          // left: 'prev,prevYear,nextYear,next, custom1, custom2',
//          // center: 'title',
//          // right: 'month,agendaWeek,agendaDay,listWeek'
//          left: '',
//          center: '',
//          right: ''
//      },
//      defaultDate: NowDate,
//      fixedWeekCount: false,
//      navLinks: false, // can click day/week names to navigate views
//      editable: false,
//      eventLimit: false, // allow "more" link when too many events 더보기 메뉴 비활성화 
//      eventOrder: ["propA", "-title"],
//      loading: function () {
//          //$(".fc-sat").css('background-color', '#eeefF9');
//          $(".fc-sat").css('border-color', '#ddd4F9');
//          $(".fc-sat").css('color', 'blue');

//          //$(".fc-sun").css('background-color', '#FFF9F7');
//          $(".fc-sun").css('border-color', '#ffd8F8');
//          $(".fc-sun").css('color', 'red');
//      },
//      eventClick: function (calEvent, jsEvent, view) {
//          var checkDay =calEvent.start.format();      
//          
//          console.log(calEvent.start);   
//          document.cookie = "GameTitleIDX=" + calEvent.id + "; path=/;";
//          document.cookie = "SearchDate=" + checkDay + "; path=/;";
//          
//          history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + checkDay);
//          $.ajax({
//              url: "sche-calendar-select.asp",
//              type: 'POST',
//              dataType: 'html',
//              data: {
//                  checkDay: checkDay
//                  , idx: calEvent.id
//                  , Crs_color: calEvent.color
//              },
//              success: function (retDATA) {
//                  $(this).css('border-color', 'red');
//                  $("#sche-dialog").html(retDATA);
//              }, error: function (xhr, status, error) {
//                  alert("오류발생! - 시스템관리자에게 문의하십시오!");
//              }
//          });
//          $('.fc-day-grid-event').attr('data-toggle', 'modal');
//          $('.fc-day-grid-event').attr('data-target', '#sche-list');
//      }
//  });

    callCalendar(NowDate);
  }
});