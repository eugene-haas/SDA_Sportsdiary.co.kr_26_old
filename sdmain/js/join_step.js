(function($){
  class JoinStepNext {
    constructor(tg){  // .form-group
      this.$tg = $(tg);
      this.$step = $(".step", this.$tg);
      this.$stepList = $(".step-list", this.$step);
      this.$btnList = $(".btn-list", this.$stepList);

      this._init();
    }

    _init() {
      console.log(this.$step);
    }
  }

  $.fn.joinStepNext = function(){
    this.each(function(){
      var joinStepNext = new JoinStepNext(this);
    });
    return this;
  }

})(jQuery);