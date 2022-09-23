function Timer(opts){
  this.accuracy;
  this.duration;
  this.el;

  this.timerId = null;
  this.time = 0;
  this.printTime = 0;
  this.remainingTime = 0;
  this.finishTime = 0;
  this.isRunning = false;
  this.status = 'ready';

  this._setOption(opts);
}
Timer.prototype._setOption = function(opts){
  let options = Object.assign(opts,{})
  this.accuracy = options.accuracy || 10;
  this.duration = options.duration || 60000;
  this.el = options.el || null;
};

Timer.prototype.run = function(opts){
  if(this.isRunning) return;
  if(opts) this._setOption(opts);

  this.isRunning = true;
  this.status = 'running'

  this.time = performance.now();
  if(!this.remainingTime) this.remainingTime = this.duration;
  this.finishTime = this.time + this.remainingTime;
  this.timerId = setInterval(this._step.bind(this), this.accuracy);

};
Timer.prototype.clear = function(){
  clearInterval(this.timerId);
  this.isRunning = false;
  this.status = 'ready';
  this.timerId = null;
  this.time = 0;
  this.printTime = 0;
  this.remainingTime = 0;
  this.finishTime = 0;
  this.isRunning = false;

  if(this.el) this.el.innerHTML = this.printTime;

};
Timer.prototype.pause = function(){
  if(!this.isRunning) return;
  this.remainingTime -= (performance.now() - this.time);
  clearInterval(this.timerId);
  this.isRunning = false;
  this.status = 'pause';
};
Timer.prototype._step = function(){
  var time = performance.now();

  this.remainingTime -= (time - this.time);
  this.time = time;
  this.printTime = Math.floor(this.remainingTime/1000) + 1;
  if(this.el) this.el.innerHTML = this.printTime;

  if(this.time >= this.finishTime){ this.clear(); }
};

Timer.prototype.toggle = function(opts){
  if(this.isRunning){ this.pause(); }
  else{ this.run(opts); }
}
