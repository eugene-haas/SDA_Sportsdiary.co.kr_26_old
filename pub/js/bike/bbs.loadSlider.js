// S:Slider 관련 스크립트
var images, lastImage, sliders
images = JSON.parse(localStorage.gameImages);
lastImage = images.length - 1;
sliders = [];

var saveImageList = function () {
	var slidersContents = $(".slider-content");
	for (var i=0; i<slidersContents.length; i++) {
		var rownum = slidersContents[i].attributes["rownum"].value;
		sliders.push(rownum);
		sliders.sort();
		console.log(sliders);
	}
}

var startSlide = function () {
	if($(".bxslider").length > 0) {
		$('.bxslider').bxSlider({
			startSlide: 1,
			captions: true,
			slideWidth: 600,
			controls: false,
			pager: false,
			infiniteLoop: false,
			mode: 'horizontal',
			onSlideNext: function($slideElement, oldIndex, newIndex) {
				var rownum = $slideElement[0].attributes["rownum"].value;
				if (rownum < lastImage) {
					if ($.inArray(rownum, sliders) === -1) {
					  addSlider(rownum, "next");
					}
				}
			},
			onSlidePrev: function($slideElement, oldIndex, newIndex) {
				var rownum = $slideElement[0].attributes["rownum"].value;
				if (rownum > 0) {
					if ($.inArray(rownum, sliders) === -1) {
					  addSlider(rownum, "prev");
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
      console.log(data);
			$(".bxslider").append(data);
			startSlide();
    },
    error:function (jqXHR, textStatus, errorThrown) {
      alert("에러 발생~~ \n" + textStatus + " : " + errorThrown);
			console.log(jqXHR);
    }
  });
}

var addSlider = function (rownum, direction) {
	var addImage;
	rownum = Number(rownum);
	if (direction === "prev") {
		addImage = images[rownum - 1];
	} else if (direction === "next") {
		addImage = images[rownum + 1]
	}
  console.log(addImage);
}

// E:Slider 관련 스크립트
