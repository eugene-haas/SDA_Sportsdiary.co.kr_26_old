//쿠키정보 저장
function setCookie (name, value, expires, domain) {
  var todayDate = new Date();
	todayDate.setDate (todayDate.getDate() + expires);
//  document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
  document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + "; domain="+domain+";";
}
// 쿠키 가져오기
function getCookie(cName) {
  cName = cName + '=';

  var cookieData = document.cookie;
  var start = cookieData.indexOf(cName);
  var cValue = '';

  if(start != -1){
    start += cName.length;

    var end = cookieData.indexOf(';', start);

    if(end == -1)end = cookieData.length;

    cValue = cookieData.substring(start, end);
  }
  return unescape(cValue);
}





function Searching(input, searching, keywordList){
  var that = this;
  this.$input = input || {};
  this.$btnSearching = searching || {};
  this.$keywordList = keywordList || {};
  this.data = [];
  this.timer;
  this.eventInput = function(){};
  this.eventListClick = function(){};
  this.eventSearching = function(){};

  if(!input || !searching || !keywordList) return;
  // 검색어 리스트 닫기
  $(document).on('click touchstart', function(evt){ that.closeKeywordList(); });
  this.$keywordList.on('touchstart', 'li', function(evt){ evt.stopPropagation(); });

  //검색어 입력
  // 붙여넣기 시??
  // this.$input.on('input', function(evt){});

  this.$input.on('keyup', function(evt){
    var keycode = evt.keyCode || evt.which;
    var keyword = this.value;

    if(keycode == 13){
      clearTimeout(that.timer);
      var keyword = that.$input.val();
      if(keyword == undefined || keyword == null) return;
      that.closeKeywordList();
      that.eventSearching(evt, that.$input);
      that.$input.blur();
      return;
    }

    if(keyword == '' || keyword == undefined || keyword == null){
      clearTimeout(that.timer);
      that.closeKeywordList();
      return;
    }

    if(that.timer){
      clearTimeout(that.timer);
    }

    that.timer = setTimeout(function(){
      that.eventInput(evt, that.$keywordList, that.$input, that.data);
      that.openKeywordList();
    }, 500);
  });


  //검색어 리스트(자동완성 리스트) 클릭
  this.$keywordList.on('click', 'li, span, div', function(evt){
    evt.preventDefault();
    evt.stopPropagation();
    // 클릭시 input에 value 바인딩
    that.eventListClick(evt, $(this), that.$keywordList, that.$input, that.data);
    that.closeKeywordList();
  });

  // 검색 버튼 클릭
  this.$btnSearching.on('click', function(evt){
    evt.preventDefault();
    var keyword = that.$input.val();
    if(keyword == undefined || keyword == null) return;
    that.eventSearching(evt, that.$input);
  });
}
Searching.prototype = {
  openKeywordList : function(){
    if(!this.$keywordList.hasClass('_on')) this.$keywordList.addClass('_on');
  },
  closeKeywordList : function(){
    if(this.$keywordList.hasClass('_on')){
      this.$keywordList.html('');
      this.$keywordList.removeClass('_on');
    }
  },
  searchingEvent : function(type, callback){
    switch(type){
      case 'input':
        this.eventInput = callback;
        break;
      case 'listClick':
        this.eventListClick = callback;
        break;
      case 'searching':
        this.eventSearching = callback;
        break;
      default:
    }
  },
}

var HistoryManager = (function(){
  function Singleton(){
    var that = this;
    this.callArray = [];
    this.referrer = document.referrer;
    this.addPopEvent = function(callback){
      this.callArray.push(callback);
    }
    this.pushHistory = function(state){
      history.pushState(state, null, null)
    }
    this.replaceHistory = function(state){
      history.replaceState(state, null, null);
    }
    this.setReferrer = function(referrer){
      this.referrer = referrer;
    }

    if (typeof history.pushState === "function"){
      window.onpopstate = function(evt){
        that.callArray.forEach(function(item, index){
          item(evt);
        });
      }
    }
  }

  var instance = new Singleton();
  return function(){ return instance; }
})();

// 텍스트 검색 로직 : S
function DocFinder($input, $findArea, matchedClassname, highlightClassname){
  this.init($input, $findArea, matchedClassname, highlightClassname);
}
DocFinder.prototype = {
  init: function($input, $findArea, matchedClassname, highlightClassname){
    var that = this;
    this.$finder = ($input.jquery) ? $input : $($input);
    this.$findArea = ($findArea.jquery) ? $findArea : $($findArea);
    this.highlightClassname = highlightClassname || 'highlighted';
    this.matchedClassname = matchedClassname || 'matched';
    this.$matched = null;
    this.highlightIndex = -1;
    this.word = '';
    // this.hightlightIndex = 0;
  },
  _hasWord : function($area, word){
    var regEx = new RegExp(word.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), "ig");
    return $area.text().match(regEx);
  },
  _setWord : function(word){
    this.word = word;
  },
  _getWord : function(){
    return this.word;
  },
  _unmapping : function($matched){
    if(!$matched) return;
    $matched.each(function(index, item){
      var $item = $(item);
      var $parent = $item.parent();
      $item.replaceWith($item.html());

      $parent.html($parent.html());

    });
  },
  _mapping : function($area, word, classname){
    var regExp = new RegExp(word.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&').replace(/&/g, '&amp;'), "ig");


    var textNodes = mapping($area[0], regExp, classname);
    function mapping(node){
      for( node=node.firstChild; node; node=node.nextSibling ){
        if( node.nodeType==3 && node.textContent.trim() ){
          if( node.textContent.match(regExp) ){

            var text = node.textContent;
            var temp = document.createElement('div');
            temp.innerHTML = text.replace(regExp, '<span class="'+ classname +'">' + word + '</span>');
            while (temp.firstChild) {
              node.parentNode.insertBefore(temp.firstChild, node);
            }
            node.parentNode.removeChild(node);
          };
        }
        else{
          mapping(node)
        }
      }
    }
    return $area.find('.' + classname);
  },
  _initHighlighting : function(index){
    this.highlightIndex = -1;
  },
  _highlighting: function($matched, highlightIndex){
    if(!this.$matched || !this.$matched.length) return;

    this.$matched.eq(this.highlightIndex).removeClass(this.highlightClassname).addClass(this.matchedClassname);
    if((this.$matched.length - 1) == this.highlightIndex ){ this.highlightIndex = 0; }else{ this.highlightIndex += 1; }
    this.$matched.eq(this.highlightIndex).removeClass(this.matchedClassname).addClass(this.highlightClassname);
  },
  find: function(value){
    if(value == '' || value == undefined || value == null){
      this._unmapping(this.$matched);
      this._setWord('');
      return;
    }
    if(!this._hasWord(this.$findArea, value)){
      this._unmapping(this.$matched);
      alert('검색한 내용이 존재 하지 않습니다.');
    }
    else if(value != this._getWord()){
      this._setWord(value);
      this._unmapping(this.$matched);
      this.$matched = this._mapping(this.$findArea, value, this.matchedClassname);

      this._initHighlighting();
    }
    this._highlighting();

    return this.$matched.eq(this.highlightIndex);
  },
}
// 텍스트 검색 로직 : E


function IsFlicking(obj){
    this.threshold = obj.threshold || 0.25;
    this.$scrollArea = (obj.scrollElement) ? ((obj.scrollElement.jquery) ? obj.scrollElement : $(obj.scrollElement)) : $('._isFilck');
    this.event = {flick:[], end:[]};

    var that = this;
    var count = 0;
    var touchStartPoint = 0;
    var touchEndPoint = 0;

    var touchPoint = 0;
    var touchTime = 0;

    var diffDistance = 0;
    var diffTime = 0;

    var diffDistances = [];
    var diffTimes = [];
    var velocities = [];

    this.$scrollArea.on('touchstart', function(evt){
      touchStartPoint = evt.touches[0].clientY;

      touchPoint = evt.touches[0].clientY;
      touchTime = evt.timeStamp;
    });

    this.$scrollArea.on('touchmove', function(evt){
      touchEndPoint = evt.touches[0].clientY;

      diffDistances[count] = touchPoint - evt.touches[0].clientY;
      diffTimes[count] = touchTime - evt.timeStamp;
      velocities[count] = diffDistances[count] / diffTimes[count]

      touchPoint = evt.touches[0].clientY;
      touchTime = evt.timeStamp;

      count++;
      if(count == 4) count = 0;
    });


    this.$scrollArea.on('touchend', function(evt){
      var diffPoint = touchStartPoint - touchEndPoint;
      var direction = ((diffPoint > 0) - (diffPoint < 0)) || +diffPoint;

      var acceleration = velocities[velocities.length - 1] - velocities[velocities.length - 2] / diffTimes[diffTimes.length - 1];
      var isFlick = Math.abs(acceleration) > that.threshold;

      that.event['end'].forEach(function(item, index){
        item(evt, direction, isFlick);
      });

      if(isFlick){
        that.event['flick'].forEach(function(item, index){
          item(evt, direction);
        });
      }
    });

    this.on = function(eventname, eventfunction){
      switch(eventname){
        case 'flick':
          this.event['flick'].push(eventfunction);
          break;

        case 'end':
          this.event['end'].push(eventfunction);

        default:
          break;
      }
    }
  }


$(function(){

  // mainSection height 셋팅
  var $sdScrollSection = $('._sd-scroll');
  if($sdScrollSection.length) $sdScrollSection.css({'height': 'calc(100vh - ' + $sdScrollSection[0].offsetTop + 'px)'});


  // footerMenu touch show hide
  var $btMenu = $('._bt-menu');
  if($btMenu.length){
    var isflick = new IsFlicking({ scrollElement: $('._sd-scroll') });
    isflick.on('end', function(evt, direction, isFlick){
      if(direction == 1){
        if($btMenu.hasClass('_show')) $btMenu.removeClass('_show');
      }
      else{
        if(/Android/i.test(navigator.userAgent)) $btMenu.addClass('_show');
        else if(/iPhone|iPad|iPod/i.test(navigator.userAgent) && isFlick) $btMenu.addClass('_show');
      }
    });
  }

});
