mx = {};
mx.ls = null;
mx.canvas = null;
mx.photo = null;
mx.img = null;
mx.x = 0;
mx.y = 0;
mx.color= null;
mx.currentText;
mx.caption;

$(document).ready(function(){

mx.ls = window.localStorage,
    mx.photo = document.getElementById('uploadImage'),
    mx.canvas = document.getElementById('canvas'),
    mx.caption = document.getElementById('caption'),
    colors = document.getElementsByName('color'),
    context = mx.canvas.getContext('2d'),
    fileReader = new FileReader(),
    mx.img = new Image(), lastImgData = mx.ls.getItem('image'),
    mx.x, mx.y, 
    mx.currentText = mx.ls.getItem('text') || "",
    mx.color = mx.ls.getItem('color') || "black", neww = 0, newh = 0;

if (mx.color) {
    Array.prototype.forEach.call(colors, function(el) {
        if (el.value === mx.color) {
             el.checked = true;   
        }
    });
}

if (mx.currentText) {
    mx.caption.value = mx.currentText;   
}

if (lastImgData) {
    mx.img.src = lastImgData;   
}

fileReader.onload = function (e) {
    console.log(typeof e.target.result, e.target.result instanceof Blob);
    mx.img.src = e.target.result;
};

mx.img.onload = function() {
    var rw = mx.img.width / mx.canvas.width; // width and height are maximum thumbnail's bounds
    var rh = mx.img.height / mx.canvas.height;
    
    if (rw > rh)
    {
        newh = Math.round(mx.img.height / rw);
        neww = mx.canvas.width;
    }
    else
    {
        neww = Math.round(mx.img.width / rh);
        newh = mx.canvas.height;
    }
    
    x = (mx.canvas.width - neww) / 2,
        y = (mx.canvas.height - newh) / 2;
    
    drawImage();
};

mx.photo.addEventListener('change', function() {
    var file = this.files[0];  
    return file && fileReader.readAsDataURL(file); 
});

mx.caption.addEventListener('change', function(event) {
    mx.currentText = event.target.value;
    drawImage();
});

//mx.canvas.addEventListener('dragover', function(event) {
//    event.preventDefault();
//});
//
//mx.canvas.addEventListener('drop', function(event) {
//    event.preventDefault();
//    fileReader.readAsDataURL(event.dataTransfer.files[0]);
//});

Array.prototype.forEach.call(colors, function(el) {
    el.addEventListener('change', function(e) {
        mx.color = e.target.value;
        drawImage(mx.currentText);
    });
});	

}); 



function drawImage() {
   var dataUrl;
	
	//console.log(mx.img.width + " " + mx.img.height);

	mx.canvas.width = mx.canvas.width;
   
   if (mx.img.width) context.drawImage(mx.img, x, y, neww, newh);
    
   context.font = 'bold 18pt arial';
   context.fillStyle = mx.color;
   context.fillText(mx.currentText, 150, 100);
    
   dataUrl = mx.canvas.toDataURL();
    
   document.getElementById('imageData').href = dataUrl;
   document.getElementById('preview').src = dataUrl;
    
   mx.ls.setItem('text', mx.currentText);
   mx.ls.setItem('color', mx.color);
   mx.ls.setItem('image', mx.img.src);
}




//mx.uploadCanvasData = function(){
//		var upimgurl = '';
//		
//		var canvas = this.$id('canvasimg');
//		var dataUrl = canvas.toDataURL('image/png'); ////캔버스를 전송하는 방법
//		var blob = this.dataURItoBlob(dataUrl);
//		var formData = new FormData();
//		formData.append("sns_photos[]", blob, 'sns.png');
//
//		var xhr = new XMLHttpRequest();
//		xhr.open('POST', '/sns/upload_img.php', true);
//
//		xhr.upload.onprogress = function(e) {
//			if (e.lengthComputable) {
//			  var percentComplete = (e.loaded / e.total) * 100;
//			  //progress.style.backgroundPosition = percentComplete + "% 0";
//			}
//		};
//
//		xhr.onload = function() {
//			if (xhr.status == 200) {
//				try{
//					var resp = JSON.parse(xhr.response);
//				}
//				catch(e){
//				   //console.log(xhr.response);
//				   return false;
//				}
//				//"{"name":["1449454193.png"],"thumb":["<img src=\"\/ufiles\/home\/1\/1449454193.png\" >"]}"
//				var value = resp.name;
//				var thumb = resp.thumb; //18*18
//				gPage.thumbImg = thumb[0];
//			}
//		};
//		xhr.send(formData);	
//	}
//
//
//	,dataURItoBlob: function(dataURI){
//		var byteString = atob(dataURI.split(',')[1]);
//		var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
//		var ab = new ArrayBuffer(byteString.length);
//		var ia = new Uint8Array(ab);
//		for (var i = 0; i < byteString.length; i++)
//		{
//			ia[i] = byteString.charCodeAt(i);
//		}
//		var bb = new Blob([ab], { "type": mimeString });
//		return bb;
//	}
