/*jshint browser:true */
/*global $ */(function()
{
 "use strict";
 /*
   hook up event handlers 
 */
 function register_event_handlers()
 {

	 
     /* button  .uib_w_2 */
    $(".uib_w_2").click(function() {
        var userAgent = navigator.userAgent || navigator.vendor || window.opera;
        if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i) || userAgent.match(/iPod/i)) {
            // IOS DEVICE
            history.go(-1);
        } else if (userAgent.match(/Android/i)) {
            // ANDROID DEVICE
            navigator.app.backHistory();
        } else {
            // EVERY OTHER DEVICE
            history.go(-1);
        }
			
        /* your code goes here */ 
    });

	 
	 

/*       events_source: 'http://www.sportsdiary.co.kr/Training/tblTrainingCalendar.ashx', */
  /*day: '2013-03-12',*/ 
   
   var d = new Date();
   var month = d.getMonth()+1;
   var day = d.getDate();
   var output = d.getFullYear() + '-' +
        (month<10 ? '0' : '') + month + '-' +
        (day<10 ? '0' : '') + day;

   var obj = {};
   /*
   obj.PlayerIDX = localStorage.getItem("PlayerIDX");
   obj.SportsGb = localStorage.getItem("SportsGb");
   obj.SchIDX = localStorage.getItem("NowSchIDX");
   obj.Sex = localStorage.getItem("Sex");
   */

   obj.PlayerIDX = "105";
   obj.SportsGb = "judo";
   obj.SchIDX = "22348";
   obj.Sex = "Man";
   
   var jsonData = JSON.stringify(obj);



   var options = {
    
    events_source: function(start, end) {
		/*
        var events = [];
			
        $.ajax({
			url: 'http://www.sportsdiary.co.kr/Training/tblTrainingCalendar.ashx?YearMonth='+end.getFullYear()+'-'+end.getMonth(),
            dataType: 'json',
            type: 'post',
            data: jsonData,
            async:    false
        }).done(function(json) {

			alert(json);

            if(!json.success) {
              $.error(json.error);
							
            }
            if(json.result) {

			  
              //console.log(json.result);
			

              events = json.result;
            }

        });
          return events;
		*/

			return  [
			   {	
				   "class": "event-inverse",
				   "end": "1479826800000",
				   "gubun": "Training",
				   "id": "2016-11-23",
				   "orderby" : "3",
				   "start" : "1479826800000",
				   "title": "[연습]나쁜놈 (승(지도))",
				   "url": "http://example.com",

				   
			   }
			   
		   ];
      },
    
    /*
		events_source: 'http://www.sportsdiary.co.kr/Training/tblTrainingCalendar.ashx?from='+start.getTime()+'&to='+end.getTime(),
    */
     
		view: 'month',
		tmpl_path: '../tmpls/',
		tmpl_cache: false,
		day: output,
		onAfterEventsLoad: function(events) {
      
			if(!events) {
				return;
			}
      
      $.each(events, function() {
       this['class'] = this['myClass'];
       delete this['myClass'];
      })
      
      
			var list = $('#eventlist');
			list.html('');
      
			$.each(events, function(key, val) {

          //내용이 없는 부분은 목록에서 제외
          if (val.title != ''){
          $(document.createElement('li')).html('<a onclick=calllink("' + val.id + '","' + val.gubun + '")>['+val.id+']' + val.title + '</a>').appendTo(list);
          //console.log(val.gubun);
          }
      });
      
		},
		onAfterViewLoad: function(view) {
      
			$('.page-header h3').text(this.getTitle());
			$('.btn-group button').removeClass('active');
			$('button[data-calendar-view="' + view + '"]').addClass('active');
      
		},
		classes: {
			months: {
				general: 'label'
			}
		}
    
	};

  
  /*칼렌다*/
	var calendar = $('#calendar').calendar(options);
			
				 
	 //alert('1234');
	 

   //이전달 다음달 이벤트
	$('.btn-group button[data-calendar-nav]').each(function() {
		var $this = $(this);
		$this.click(function() {
      calendar.navigate($this.data('calendar-nav'));
			
		});
	});

	$('.btn-group button[data-calendar-view]').each(function() {
		var $this = $(this);
		$this.click(function() {
      calendar.view($this.data('calendar-view'));
		});
	});

	$('#first_day').change(function(){
    var value = $(this).val();
		value = value.length ? parseInt(value) : null;
		calendar.setOptions({first_day: value});
		calendar.view();
	});

	$('#language').change(function(){
		calendar.setLanguage($(this).val());
		calendar.view();
	});

	$('#events-in-modal').change(function(){
		var val = $(this).is(':checked') ? $(this).val() : null;
		calendar.setOptions({modal: val});
	});
	$('#format-12-hours').change(function(){
		var val = $(this).is(':checked') ? true : false;
		calendar.setOptions({format12: val});
		calendar.view();
	});
	$('#show_wbn').change(function(){
		var val = $(this).is(':checked') ? true : false;
		calendar.setOptions({display_week_numbers: val});
		calendar.view();
	});
	$('#show_wb').change(function(){
		var val = $(this).is(':checked') ? true : false;
		calendar.setOptions({weekbox: val});
		calendar.view();
	});

  $('#events-modal .modal-header, #events-modal .modal-footer').click(function(e){
		//e.preventDefault();
		//e.stopPropagation();
    alert("test1");
	});
  /*칼렌다*/
  
  
  $(document).on("click", "#linkday", function(evt)
  {
    alert("test1");
  });

  $('.cal-cell1 cal-cell').click(function(e){ 
    alert("test2");
  });

   
 }

  
  
 //document.addEventListener("app.Ready", register_event_handlers, false);
 document.addEventListener("app.Ready", register_event_handlers, false);
})();
