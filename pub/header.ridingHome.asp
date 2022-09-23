<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	PAGENAME = LCase(Mid(Request.ServerVariables("URL"), InStrRev(Request.ServerVariables("URL"), "/") + 1))

	If Left(PAGENAME, 3) = "req" Then 'ajax 콜파일만 적용되도록
		Response.Expires = -1
		Response.Expiresabsolute = Now() - 1
		Response.AddHeader "pragma","no-cache"
		Response.AddHeader "cache-control","private"
		Response.CacheControl = "no-cache"
	End if

''######################################
'헤더가 두개 잘못 링크됨
'?????? rading riding 두개가 들어가졌다 나중에 고치자 %%%%
%>
<!-- #include virtual = "/pub/cfg/cfg.ridingAdmin.asp" -->

<!-- #include virtual = "/pub/class/db_helper.asp" -->

<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->
<!-- #include virtual = "/pub/fn/fn_riding.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->


<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->


<script language="Javascript" runat="server">
function hasown(obj,  prop){

	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>


<%
sitecode = "RDN01"
SENDPRE = "home_"  '공통스크립트용 req 용  pre
debugmode = True
leftLoad = "load" '왼쪽메뉴 스크립트로 부를건지



Function InjectionChk(str)    '#### injection 확인
	arrSQL = Array("'","#","exec ","sp_","xp_","insert ","update ","delete ","drop ","select ","union ","truncate ","script","object ","applet","embed ","iframe ","where ","declare ","sysobject","@variable","1=1","null","carrige return","new line","onload","char(","xmp ","javascript","script","iframe","document","vbscript","applet","embed","object","frame","frameset","bgsound","alert","onblur","onchange","onclick","ondblclick","onerror","onfocus","onload","onmouse","onscroll","onsubmit","onunload","ptompt","</div>")
	If isEmpty(str) Or isNull(str) Then Exit Function
	str = Trim(str)
	For forNum = 0 To Ubound(arrSQL)
		str = Replace(str, arrSQL(forNum), "")
	Next
	InjectionChk = str
End Function


logininfo = Session("loginOBJ")

If  logininfo = "" Then
	login = false
Else
	login = True
	Set loginobj = JSON.Parse( join(array(logininfo)) )
	session_regtype = loginobj.Get(0).get("REGTYPE")
	session_unm = loginobj.Get(0).Get("UNM")
	session_uid = loginobj.Get(0).Get("UID")
	session_nowyear = loginobj.Get(0).Get("NOWYEAR")
	session_referee = loginobj.Get(0).Get("REFEREE") '1심판  0일반 2(선수나 지도자인데 심판아님)
	session_pidx = loginobj.Get(0).Get("PIDX")
	session_kno = loginobj.Get(0).Get("KNO")
	session_utype = loginobj.Get(0).Get("UTYPE") 'P 선수 T 지도자 ..
	if session_utype <> "P" and session_utype <> "H" and session_utype <> "G" then
		session_utype = "T"
	end if
	session_upno = loginobj.Get(0).Get("UPNO") '전화번호'

	session_team = loginobj.Get(0).Get("TCD")
	session_teamnm = loginobj.Get(0).Get("TNM") '팀명
	session_applyyn = loginobj.Get(0).Get("APPLYYN") '팀소유여부

	session_wseq = loginobj.Get(0).Get("WSEQ") '웹멤버번호

	'변경이나 추가시 사용
	'Call loginobj.Get(0).Set("APPLYYN","Y")'  = "Y"
End if
%>
