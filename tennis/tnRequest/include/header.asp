<div class="header">
  <h1>
    <a href="list.asp"><img src="imgs/public/logo_kata.png" alt="KATA Tennis"></a>
  </h1>
</div>  
<div class="wrap-loading display-none" id="LoadingBar">
    <div >
			<p><img src="./imgs/ownageLoader/loader1.gif"  style="max-width:30px;"/></p>
		</div>
</div>    
<style type="text/css" >

.wrap-loading{ /*화면 전체를 어둡게 합니다.*/
    position: fixed;
    left:0;
    right:0;
    top:0;
		margin:auto;
		text-align:center;
    bottom:0;
		z-index:99000;
    background: rgba(0,0,0,0.5); /*not in ie */
    filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */
}

    .wrap-loading div{ /*로딩 이미지*/
        position: fixed;
        top:50%;
        left:50%;
				margin-left:-15px;
				margin-top:-15px;
    }

    .display-none{ /*감추기*/
        display:none;
    }
</style>

 