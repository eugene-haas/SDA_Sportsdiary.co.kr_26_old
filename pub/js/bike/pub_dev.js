//////////////////////////////////
//공통으로 사용할 스크립트
//예시: mp.goPage(null, '/bike/M_Player/Board/gameIMG.asp')
//////////////////////////////////
var mp =  mp || {};

$(document).ready ( function () {
  var rownum = $("#rownum").val()
  if (rownum) {
    loadImage(rownum);
	}
  //t-img에 touchmove event listener 추가
  touchSlide();

});


mp.goPage = function(packet, gourl){
	if( document.sform == undefined){
		document.body.innerHTML = "<form method='post' name='sform'><input type='hidden' name='p'></form>";
	}

	if (packet != null)	{
		document.sform.p.value =   JSON.stringify( packet  );
	}
	document.sform.action = gourl;
	document.sform.submit();
};


mp.getYoutubeTitle = function (videoID, titleID) {
		var key, url
		key = "AIzaSyCd7b044KUd09iNRw-IVJZ8eYhQV73vrvY";
		url = "https://www.googleapis.com/youtube/v3/videos?id="+videoID+"&key="+key+"&fields=items(id,snippet(channelId,title))&part=snippet";
  	$.ajax({
			url: url,
			dataType:'json',
			success:function(data){
				var result, videoTitle;
				result = data;
				videoTitle = result.items[0].snippet.title;
				$("#" + titleID).text(videoTitle);
			}
	  });
}

mp.changeTitle = function () {
	var titleCnt;
	titleCnt = $(".p-name").length;

	for ( i = 0; i < titleCnt; i++ ) {
		var id, e
		//video ID
		videoID = $("p[name=vTitle]").eq(i).attr("videoID");
		// title element ID
		titleID = $("p[name=vTitle]").eq(i).attr("id");
		mp.getYoutubeTitle(videoID, titleID);
	}
};

if ( $("div.player_video_list").length > 1 ) {
	$(document).ready ( function () {
		mp.changeTitle();
	});
};


mp.download = function (image) {
	var x=new XMLHttpRequest();
		x.open("GET", image, true);
		x.responseType = 'blob';
		x.onload=function(e){download(x.response, "test.jpg", "image/jpg" ); }
		x.send();
};

// S:Slider 관련 스크립트
var gameImages, lastImage, sliders
gameImages = JSON.parse(localStorage.gameImages);
lastImage = gameImages.length - 1;
sliders = [];


var loadImage = function (rownum) {
  var gameImage, filename, gameImageUrl;
  gameImage = gameImages[rownum];
  idx = gameImage.idx;
  filename = gameImage.filename;
  gameImageUrl = "http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/" + filename;
  document.getElementById("gameImage").src = gameImageUrl;
  document.getElementById("downImage").href = gameImageUrl;
  document.getElementById("downImage").download = filename;
  // 조회수 업데이트
  updateReadnum(idx, gameImage);
}

var changeImage = function (direction) {
  var rownum
  rownum = $("#rownum").val();
  if (direction == "prev") {
    if (rownum == 0) {
      alert("첫페이지 입니다.");
    } else {
      rownum = Number(rownum) - 1;
    }
  } else if (direction == "next") {
    if (rownum == lastImage) {
      alert("마지막페이지 입니다.");
    } else {
      rownum = Number(rownum) + 1  ;
    }
  }
  loadImage(rownum);
  $("#rownum").val(rownum);
}

var touchSlide = function () {
  var $imageElement = $(".t-img");
  var touchPointStart = 0;
  var touchPointEnd = 0;

  $imageElement.on('touchstart', function (evt) {
    touchPoint = evt.touches[0].clientX;
  });
  $imageElement.on('touchmove', function (evt) {
    touchPointEnd = evt.touches[0].clientX;
  });
  $imageElement.on('touchend', function (evt) {
    if (Math.abs(touchPoint - touchPointEnd) < 50) return;
    if(touchPoint - touchPointEnd > 0){
      $imageElement.find('img').fadeOut('100');
      // $imageElement.css({'transition':'opacity 0s'});
      // $imageElement.css({'opacity':'0'});
      setTimeout(function(){
        changeImage('next');
      },500);
      // console.log('right');
    } else {
      $imageElement.find('img').fadeOut('100');
      // $imageElement.css({'transition':'opacity 0s'});
      // $imageElement.css({'opacity':'0'});
      setTimeout(function(){
        changeImage('prev');
      },100);
      // console.log('left');
    }
  });
  $imageElement.find('img').load(function(e) {
    // $imageElement.css({'transition':'opacity 0.4s'});
    // setTimeout(function(){
    //    $imageElement.css({'opacity':'1'});
    //  },500)
    $imageElement.find('img').fadeIn('100');
    var imageHeight = $(".t-img").find("img").height();
    $(".t-img").css("min-height", imageHeight);
  });
}

// E:Slider 관련 스크립트
var updateReadnum = function (idx, gameImage) {
  // console.log(gameImage);
  $.ajax({
    type : "GET",
    data: "idx=" + idx,
    url: "/pub/api/bike/board/image/api.updateReadnum.asp",
    dataType:'text',
    success:function (data) {
      gameImage.readnum = data;
      document.getElementsByClassName("view-number")[0].innerHTML = "조회수<span> " + gameImage.readnum + " </span>회"
    },
    error:function (jqXHR, textStatus, errorThrown) {
      // alert("에러 발생~~ \n" + textStatus + " : " + errorThrown);
			console.log(jqXHR);
    }
  });
}










// S:bxSlider 활용해서 만들려다가 망함(안씀)

var saveImageList = function () {
	var slidersContents = $(".slider-content");
	for (var i=0; i<slidersContents.length; i++) {
		var rownum = slidersContents[i].attributes["rownum"].value;
		sliders.push(rownum);
		sliders.sort();
		// console.log(sliders);
	}
}


var addSlider = function (rownum, direction, newIndex) {
	var sliderContent;
	sliderContent = images[rownum];
	sliderContent.direction = direction;
  console.log(1);
	$.ajax({
    type : "GET",
    data: "data=" + JSON.stringify(sliderContent),
    url: "/pub/api/bike/board/image/api.addSliderImage.asp",
    dataType:'html',
    success:function (data) {
			if (direction == "prev") {
				$(".bxslider").prepend(data);
        console.log("p");
			} else if (direction == "next") {
				$(".bxslider").append(data);
        console.log("n");
			}
			saveImageList();
      $("#reload-slider").trigger("click");
    },
    error:function (jqXHR, textStatus, errorThrown) {
      alert("에러 발생~~ \n" + textStatus + " : " + errorThrown);
			console.log(jqXHR);
    }
  });
}

var startSlide = function () {
	if($(".bxslider").length > 0) {
		$('.bxslider').bxSlider({
			startSlide: 1,
			captions: true,
			slideWidth: 600,
			controls: false,
			pager: false,
			infiniteLoop: true,
			mode: 'fade',
			onSlideNext: function($slideElement, oldIndex, newIndex) {
				var rownum = $slideElement[0].attributes["rownum"].value;
				var nextRownum = Number(rownum) + 1;
				if (rownum < lastImage) {
					if ($.inArray(String(nextRownum), sliders) === -1) {
					  addSlider(nextRownum, "next", newIndex);
					}
				}
			},
			onSlidePrev: function($slideElement, oldIndex, newIndex) {
				var rownum = $slideElement[0].attributes["rownum"].value;
				var prevRownum = Number(rownum) - 1;
				if (rownum > 0) {
					if ($.inArray(String(prevRownum), sliders) === -1) {
					  addSlider(prevRownum, "prev", newIndex);
					}
				}
			}
		});
	}
	saveImageList();
};

var loadSlider = function (rownum) {
	rownum = Number(rownum);
  var currentImage, prevImage, nextImage;
  currentImage = images[rownum];
  prevImage = images[rownum - 1];
  nextImage = images[rownum + 1];
  if (rownum === 0) {
    prevImage = "";
  } else if (rownum === lastImage) {
    nextImage = "";
  }

  var sliderContents = {};
  sliderContents.currentImage = currentImage;
  sliderContents.prevImage = prevImage;
  sliderContents.nextImage = nextImage;
	// console.log(nextImage);
	// console.log(JSON.stringify(sliderContents));

  $.ajax({
    type : "GET",
    data: "data=" + JSON.stringify(sliderContents),
    url: "/pub/api/bike/board/image/api.loadSliderImage.asp",
    dataType:'html',
    success:function (data) {
			$(".bxslider").append(data);
			startSlide();
    },
    error:function (jqXHR, textStatus, errorThrown) {
      alert("에러 발생~~ \n" + textStatus + " : " + errorThrown);
			console.log(jqXHR);
    }
  });
}

var reload = function (e) {
  e.preventDefault();
  $('.bxslider').bxSlider({
    startSlide: 1,
    captions: true,
    slideWidth: 600,
    controls: false,
    pager: false,
    infiniteLoop: true,
    mode: 'fade',
    onSlideNext: function($slideElement, oldIndex, newIndex) {
      var rownum = $slideElement[0].attributes["rownum"].value;
      var nextRownum = Number(rownum) + 1;
      if (rownum < lastImage) {
        if ($.inArray(String(nextRownum), sliders) === -1) {
          addSlider(nextRownum, "next", newIndex);
        }
      }
    },
    onSlidePrev: function($slideElement, oldIndex, newIndex) {
      var rownum = $slideElement[0].attributes["rownum"].value;
      var prevRownum = Number(rownum) - 1;
      if (rownum > 0) {
        if ($.inArray(String(prevRownum), sliders) === -1) {
          addSlider(prevRownum, "prev", newIndex);
        }
      }
    }
  }).reloadSlider();
}

// E:bxSlider 활용해서 만들려다가 망함(안씀)
