<% @LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
<%
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1
Session.CodePage = 65001
Response.Charset="UTF-8" 

'// UTF-8 파일 읽기
Function fread_utf8(fpath)
    If fpath = "" Then Exit Function
 
    Dim objStream, txt
    Set objStream = Server.CreateObject("ADODB.Stream")
    objStream.Mode = 3
    objStream.Type = 2 ' 텍스트 타입 (1: Bin, 2: Text)
    objStream.CharSet = "UTF-8"
    objStream.Open
    objStream.LoadFromFile Server.MapPath(fpath)
    txt = objStream.ReadText
    objStream.Close
    Set objStream = Nothing
 
    fread_utf8 = txt
End Function
 
'// UTF-8 파일 쓰기
Sub fwrite_utf8(fpath, txt)
    If fpath = "" OR txt = "" Then Exit Sub
 
    Dim objStream
    Set objStream = Server.CreateObject("ADODB.Stream")
    objStream.Mode = 3
    objStream.Type = 2 ' 텍스트 타입 (1: Bin, 2: Text)
    objStream.CharSet = "UTF-8"
    objStream.Open
    objStream.WriteText txt, 1
    objStream.SaveToFile Server.MapPath(fpath), 2
    objStream.Flush
    objStream.Close
    Set objStream = Nothing
End Sub


'util/soundManager2.js 이거까진빼고 뒤에꺼만 우선 검사
'#######################
filearr = Array("util/ajax.js","util/viewport.js","util/userData.js","util/command.js","util/modernizr.js","util/PxLoader.js","util/PxLoaderImage.js","util/WAASound.js","util/PxLoaderSound.js","util/PxLoaderXML.js","src/vxengine.js","src/vxstructure.js","src/vxtag.js","src/vxdefine.js","src/vxglobal.js","src/vxbuffer.js","src/vxskin.js","src/vxresourcemgr.js","src/vxstage.js","src/vximage.js","src/vxobject.js","src/vxdrag.js","src/vxclick.js","src/vxbutton.js","src/vxgroup.js","src/vxstatic.js","src/vxtab.js","src/vxbox.js","src/vxmenu.js","src/vxscrollbar.js","src/vxscrollbox.js","src/vxmodalbox.js","src/vxprogress.js","src/vxslider.js","src/vxtooltip.js","src/vxlistbox.js","src/vxeditbox.js","src/vxlayer.js","debugjs/main.js","debugjs/menu.js","debugjs/dialog.js","debugjs/wolsgf.js","debugjs/mydefine.js","debugjs/myglobal.js","debugjs/owcontrol.js","debugjs/gameclass.js","debugjs/gameeffect.js","debugjs/gamesheet.js","debugjs/layerlobby.js","debugjs/layermap.js","debugjs/layergame.js","debugjs/rankhome.js","debugjs/popupbook.js","debugjs/popupsheet.js","debugjs/popupsheetstore.js","debugjs/popupforge.js","debugjs/popupmission.js","debugjs/popupresult.js","debugjs/popuppubs.js","debugjs/popupranks.js","debugjs/popupwarnotify.js","debugjs/stagetitle.js","util/payment.js" ,"util/dompop.js","util/util.js","src/vxtalkballoon.js","util/itemdefine.js")
'#######################
'Response.write filearr(37)
fullsource = ""
For i = 0 To ubound(filearr)
	readfile = fread_utf8("/" & filearr(i))
	'fullsource = fullsource & "<span style='color:red;'>"+filearr(i)+"</span><br>" & readfile
	fullsource = fullsource & readfile & vbCrLf
next

Response.write fullsource
%>