/**
 * 스포츠 다이어리 어드민
 * $=jQuery,
 * 토너먼트 모달내 영상보기/기록보기 전환 기능
 */
;(function($){
  'use strict';

  var TransFilmRec = {
    _$tg: null,
    _$btn: null,
    _$filmBox: null,
    _$recordBox: null,
    exec: function(tg){
      this._init(tg);
      this._evt();
    },
    _init: function(tg){
      this._$tg = $(tg);
      this._$btn = $('.btn-list .btn', this._$tg);
      this._$filmBox = $('.film-box', this._$tg);
      this._$recordBox = $('.record-box', this._$tg);
    },
    _evt: function(){
      var that = this;
      this._$btn.on('click', function(){
        if ($(this).hasClass('btn-film')) {
          that._toggleFilm();
        }
        if ($(this).hasClass('btn-record')) {
          that._toggleRecord();
        }
      }); // click end
    },
    _toggleFilm: function(){
      this._$filmBox.show();
      this._$recordBox.hide();
    },
    _toggleRecord: function(){
      this._$recordBox.show();
      this._$filmBox.hide();
    }

  }
  TransFilmRec.exec('.film-modal');
})(jQuery);