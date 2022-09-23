// html, css, javascript 결합 모듈
function OverLayer(obj){
  this.$layer = {},
  this.$title = {},
  this.$wrap = {},
  this.$backdrop = {};

  this.init = function(obj){
    var that = this;
    this.$layer = (obj.overLayer) ? ((obj.overLayer.jquery) ? obj.overLayer : $(obj.overLayer)) : $('._overLayer').eq(0);
    this.$box = this.$layer.find('._overLayer__box');
    this.$wrap = this.$layer.find('._overLayer__wrap');
    this.$backdrop = this.$layer.find('._overLayer__backdrop');

    this.emptyHTML = obj.emptyHTML || '';
    this.errorHTML = obj.errorHTML || '';
    this.$title = this.$layer.find('._overLayer__title');
    this.transition = (obj && typeof obj.transition == 'boolean') ? obj.transition : true;

    this.$layer.on('click', '._overLayer__close', function(evt){
      that.close();
    });
  }
  this.open = function(obj){
    var transition = (obj && typeof obj.transition == 'boolean') ? obj.transition : this.transition;

    if(transition){
      this.$layer.css({'transition':''});
      this.$backdrop.css({'transition':''});
      this.$box.css({'transition':''});
    }
    else{
      this.$layer.css({'transition':'unset'});
      this.$backdrop.css({'transition':'unset'});
      this.$box.css({'transition':'unset'});
    }

    if(!this.$layer.hasClass('_s_on')){
      this.event['beforeOpen'].forEach(function(item, index, array){ item(); });

      if(obj && obj.title) this.$title.html(obj.title);

      this.$layer.addClass('_s_on');
      this.$backdrop.addClass('_s_on');
      this.$box.addClass('_s_on');
    }
  }
  this.close = function(obj){
    if(this.$layer.hasClass('_s_on')){

      var transition = (obj && typeof obj.transition == 'boolean') ? obj.transition : this.transition;

      if(transition){
        this.$layer.css({'transition':''});
        this.$backdrop.css({'transition':''});
        this.$box.css({'transition':''});
      }
      else{
        this.$layer.css({'transition':'unset'});
        this.$backdrop.css({'transition':'unset'});
        this.$box.css({'transition':'unset'});
      }

      this.event['beforeClose'].forEach(function(item, index, array){ item(); });

      this.$layer.removeClass('_s_on');
      this.$backdrop.removeClass('_s_on');
      this.$box.removeClass('_s_on');
    }
  }
  this.innerContent = function(content){
    this.$wrap.html(content);
  }
  this.empty = function(emptyHTML){
    var html = emptyHTML || this.emptyHTML;
    this.$wrap.html(html);
  }
  this.error = function(errorHTML){
    var html = errorHTML || this.errorHTML;
    this.$wrap.html(html);
  }

  this.event = { 'beforeOpen':[], 'beforeClose':[] }
  this.on = function(type, callback){ this.event[type].push(callback); }

  if(obj) this.init(obj);
}




function PaginationWithScroll(obj){
  if(obj){ this.init(obj); }
}
PaginationWithScroll.prototype = {
  init : function(obj){
    var that = this;
    this.$pagination = obj.$pagination || $('._pagination-scroll').eq(0);
    this.$prev = this.$pagination.find('._pagination-scroll__btn-prev');
    this.$next = this.$pagination.find('._pagination-scroll__btn-next');
    this.$pagerWrap = this.$pagination.find('._pagination-scroll__pagerWrap');
    this.pagerClassname = '._pagination-scroll__btn-pager';
    this.pagerStyleClassname = this.$pagination.find(this.pagerClassname).attr('class').replace('_pagination-scroll__btn-pager', '');

    this.scrollWeight = obj.scrollWeight || null;
    this.scrollIncrease = obj.scrollIncrease || 10;
    this.scrollIncreaseTime = obj.scrollIncreaseTime || 10;


    // this.$prev = obj.$prev || $('._pagination-scroll__btn-prev');
    // this.$next = obj.$next || $('._pagination-scroll__btn-next');
    // this.$pagerWrap = obj.$pagerWrap || $('._pagination-scroll__pagerWrap');
    // this.pagerClassname = '.' + obj.pagerClassname || '._pagination-scroll__btn-pager';
    // this.scrollWeight = obj.scrollWeight || null;
    // this.scrollIncrease = obj.scrollIncrease || 10;
    // this.scrollIncreaseTime = obj.scrollIncreaseTime || 10;

    this.$prev.on('click', function(evt){
      var scroll = that.$pagerWrap.scrollLeft();
      var scrollChanged = Number(scroll);
      var scrollWeight = that.scrollWeight || that.$pagerWrap.width();

      var a = setInterval(function(){
        that.$pagerWrap.scrollLeft(scrollChanged -= that.scrollIncrease);
        if(Math.abs(scroll - scrollChanged) >= scrollWeight) clearInterval(a);
      }, that.scrollIncreaseTime);
    });

    this.$next.on('click', function(evt){
      var scroll = that.$pagerWrap.scrollLeft();
      var scrollChanged = Number(scroll);
      var scrollWeight = that.scrollWeight || that.$pagerWrap.width();

      var a = setInterval(function(){
        that.$pagerWrap.scrollLeft(scrollChanged += that.scrollIncrease);
        if(Math.abs(scroll - scrollChanged) >= scrollWeight) clearInterval(a);
      }, that.scrollIncreaseTime);

    });
  },
  updatePager : function(pagerCount){
    // if(typeof pagerCount == 'string'){}
    // else{ throw new Error('The argument value is invalid') }
    pagerCount = pagerCount || 5;
    var pagers = [];
    for(var i=0, ii=pagerCount; i<ii; i++){
      pagers.push('<button class="' + this.pagerStyleClassname +' _pagination-scroll__btn-pager '+ ((i == 0) ? '_s-on' : '') +'">' +  (i+1) + '</button>');
    }
    this.$pagerWrap.html('');
    this.$pagerWrap.html(pagers.join(''));

    // this.$pagerWrap.children().eq(0).addClass('_s-on');
  },
  on : function(eventname, eventCallback){
    switch(eventname){
      case 'pager':
        this.$pagerWrap.on('click', this.pagerClassname, function(evt){
          eventCallback.call(this, evt);
        });
    }
  },
  moveToPager : function(pageNo){
    this.$pagerWrap.children().each(function(index, item){
      var $item = $(item);
      if($item.hasClass('_s-on')) $item.removeClass('_s-on');
    });

    this.$pagerWrap.children().eq(pageNo-1).addClass('_s-on');

    var that = this;
    var $pager = this.$pagerWrap.find(this.pagerClassname).eq(pageNo - 1);
    var scroll = this.$pagerWrap.scrollLeft();

    var scrollChanged = Number(scroll);

    var scrollEnd= this.$pagerWrap.scrollLeft() + $pager.position().left - (this.$pagerWrap.outerWidth()/2) + ($pager.outerWidth(true)/2);
    scrollEnd = (scrollEnd < 0) ? 0 : scrollEnd;

    this.$pagerWrap.scrollLeft(scrollEnd);
  },
}

function MemorizeScroll(obj){
  var timer;
  var key = (obj && obj.key) || 'scrollvalue';
  this.$eventEl = (obj && obj.eventSelector) ? $(obj.eventSelector) : null;
  this.targetSelector = (obj && obj.targetSelector) || '._memorize-scroll';
  this.$targetEl = $(this.targetSelector);
  this.$targetEl.css({'opacity':'0'});
  this.set = function(a){
    if(timer) clearTimeout(timer);
    timer = setTimeout(function(){
      sessionStorage.setItem(key, a);
    }, 300);
  }

  this.get = function(){
    return sessionStorage.getItem(key);
  }

  this.setScroll = function(){
    var $el = (this.$eventEl) ? this.$eventEl.find(this.targetSelector) : this.$targetEl;

    $el.scrollLeft(this.get());
    $el.css({'opacity':'1'});
  }

  this.bindScroll = function(){
    var that = this;

    if(this.$eventEl){
      this.$eventEl.on('scroll', this.targetSelector, function(evt){
        that.set($(this).scrollLeft());
      });
    }
    else if(this.$targetEl){
      this.$targetEl.on('scroll', function(evt){
        that.set($(this).scrollLeft());
      });
    }
  }

  this.clear = function(){
    sessionStorage.setItem(key, 0);
  }
}
