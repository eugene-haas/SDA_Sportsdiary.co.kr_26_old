function popupOpen (btn,btn2,msg)
{
	if (btn != "") {
		parent.fPage.document.getElementById(btn).disabled = true;
	}
	
	if (btn2 != "") {
		parent.fPage.document.getElementById(btn2).disabled = true;
	}
		
	document.getElementById("popup").style.display = "block";
	document.getElementById("popmsg").innerText=msg;	
}

function popupClose (btn,btn2,msg)
{
	if (btn != "") {
		parent.fPage.document.getElementById(btn).disabled = false;
	}
	
	if (btn2 != "") {
  	parent.fPage.document.getElementById(btn2).disabled = false;
  }
  
	document.getElementById("popup").style.display = "none"; 
	document.getElementById("popmsg").innerText=msg;		
	
}