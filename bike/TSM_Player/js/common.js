axios.defaults.headers.get["Cache-Control"] = 'no-cache';

// 이미지 프리로드
function preload() {
  let images = [];
  for(i=0; i<preload.arguments.length; i++) {
    images[i] = new Image()
    images[i].src = preload.arguments[i]
  }
}

// debounce
function debounce(fn, delay){
  let timer
  return function(){
    clearTimeout(timer)
    timer = setTimeout(()=>{
      fn.apply(this, arguments);
    }, delay)
  }
}

function getQueryStringObject(){
  var a = window.location.search.substr(1).split('&');
  if(a == "") return {};
  var b = {};
  for(var i = 0; i < a.length; ++i) {
    var p = a[i].split('=', 2);
    if (p.length == 1) b[p[0]] = "";
    else b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
  }
  return b;
}
