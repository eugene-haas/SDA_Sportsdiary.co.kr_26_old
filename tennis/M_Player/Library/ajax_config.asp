<% @CODEPAGE="65001" language="vbscript" %>
<%
	Response.Expires = -1
	Response.ExpiresAbsolute = now() - 1
	Response.ContentType = "text/html;charset=utf-8"
	Response.AddHeader "CacheControl", "no-cache"
	Response.AddHeader "CacheControl", "private"
	Response.AddHeader "Pragma", "no-cache"
	Response.CodePage = "65001"
	Session.codepage = "65001"

	
	Const Ref = "GPQRSATWXVYBCHL640MN598OIJKZ12D7EF3U"
	'===============================================================================
	' 암호화
	'===============================================================================
	Function encode(str, chipVal)
		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""
		
		chipVal = CInt(chipVal)
		str = StringToHex(str)
		
		For i = 0 To Len(str) - 1
			TempChar = Mid(str, i + 1, 1)
			Conv = InStr(Ref, TempChar) - 1
			Cipher = Conv Xor chipVal
			Cipher = Mid(Ref, Cipher + 1, 1)
			Temp = Temp + Cipher
		Next

		encode = Temp

	End Function
	'===============================================================================
	' 복호화
	'===============================================================================
	Function decode(str, chipVal)	      
		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""
	
		chipVal = CInt(chipVal)
		
		For i = 0 To Len(str) - 1
		  TempChar = Mid(str, i + 1, 1)
		  Conv = InStr(Ref, TempChar) - 1
		  Cipher = Conv Xor chipVal
		  Cipher = Mid(Ref, Cipher + 1, 1)
		  Temp = Temp + Cipher
		Next
		
		Temp = HexToString(Temp)
		decode = Temp
		
	End Function
	'===============================================================================
	' 문자열 -> 16진수
	'===============================================================================
	Function StringToHex(pStr)
		Dim i, one_hex, retVal
		
		IF pStr<>"" Then
			For i = 1 To Len(pStr)
			  one_hex = Hex(Asc(Mid(pStr, i, 1)))
			  retVal = retVal & one_hex
			Next
		End IF
		
		StringToHex = retVal

	End Function
	'===============================================================================
	' 16진수 -> 문자열
	'===============================================================================
	Function HexToString(pHex)
		Dim one_hex, tmp_hex, i, retVal
		
		For i = 1 To Len(pHex)
		  one_hex = Mid(pHex, i, 1)
		
		  If IsNumeric(one_hex) Then
				  tmp_hex = Mid(pHex, i, 2)
				  i = i + 1
		  Else
				  tmp_hex = Mid(pHex, i, 4)
				  i = i + 3
		  End If
		
		  retVal = retVal & Chr("&H" & tmp_hex)
		
		Next
		
		HexToString = retVal
		
	End Function	
	'===============================================================================
	'인젝션 체크
	'===============================================================================
	Function fInject(argData)
		Dim strCheckArgSQL
		Dim arrSQL
		Dim i
	
		strCheckArgSQL = LCase(Trim(argData))	
		
		arrSQL = Array("exec ","sp_","xp_","insert ","update ","delete ","drop ","select ","union ","truncate ","script","object ","applet","embed ","iframe ","where ","declare ","sysobject","@variable","1=1","null","carrige return","new line","onload","char(","xmp","javascript","script","iframe","document","vbscript","applet","embed","object","frame","frameset","bgsound","alert","onblur","onchange","onclick","ondblclick","onerror","onfocus","onload","onmouse","onscroll","onsubmit","onunload","ptompt","</div>")
	
		For i=0 To ubound(arrSQL) Step 1
			If(InStr(strCheckArgSQL,arrSQL(i)) > 0) Then
				Select Case  arrSQL(i)
				Case "'"
						arrSQL(i) ="홑따옴표"
				Case "char("
					arrSQL(i) ="char"
			  End SELECT
			  
				response.write "<SCRIPT LANGUAGE='JavaScript'>"
				response.write "  alert('허용되지 않은 문자열이 있습니다. [" & arrSQL(i) & "]') ; "
				response.write "  history.go(-1);"
				response.write "</SCRIPT>"
				response.end
			End If
	
			If(InStr(strCheckArgSQL,server.urlencode(arrSQL(i))) > 0) Then
				   Select Case  arrSQL(i)
				   Case "'"
					arrSQL(i) ="홑따옴표"
				   Case "char("
					arrSQL(i) ="char"
				   End SELECT
				response.write "<SCRIPT LANGUAGE='JavaScript'>"
				response.write "  alert('허용되지 않은 문자열이 있습니다. [" & arrSQL(i) & "]') ; "
				response.write "  history.go(-1);"
				response.write "</SCRIPT>"
				response.end
			End If
	
		Next
	
		'Xss 필터링	
		'argData = Replace(argData,"&","&amp;")
		'argData = Replace(argData,"\","&quot;")
		'argData = Replace(argData,"<","&lt;")
		'argData = Replace(argData,">","&gt;")
		'argData = Replace(argData,"'","&#39;")
		'argData = Replace(argData,"""","&#34;")
	
		fInject = argData
	End Function 
	'===============================================================================
  	'Function StrConvert(sData)  
  	'	StrConvert = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(sData, vbNewLine, "ㆍ"), "'", "＇"), "<", "＜"), ">", "＞"), ",", "－"), "&", "＆"), """", "¨"), "|", " | ")

  		'Chr(9)값: 
		'Chr(10)값: 
		'Chr(11)값: 
		'Chr(12)값: 
		'Chr(13)값: 

	'End Function
	'===============================================================================
	
	GLOBAL_DT  = Year(now)&AddZero(Month(now))&AddZero(Day(now))'현재일자 예)20150609

	'===============================================================================
	'RandNumber 랜덤문자, 숫자 추출
	'===============================================================================
	Function random_str()
		str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" '랜덤으로 사용될 문자 또는 숫자
		
		strlen = 6 '랜덤으로 출력될 값의 자릿수 ex)해당 구문에서 10자리의 랜덤 값 출력
		
		Randomize '랜덤 초기화
		
		For i = 1 To strlen '위에 선언된 strlen만큼 랜덤 코드 생성
			r = Int((36 - 1 + 1) * Rnd + 1)  ' 36은 str의 문자갯수
			serialCode = serialCode + Mid(str,r,1)
		Next

		random_str = serialCode

	End Function
	'===============================================================================
	'랜덤숫자
	'===============================================================================
	Function random_Disigt_str()
		Randomize '랜덤 초기화
		'4자리
		bufNum = int(9000 * rnd) + 1000	
		random_Disigt_str = bufNum
	End Function
	'===============================================================================
	'html 태그 변환
	'===============================================================================
	Function ReplaceTagText(str)
		dim txtTag
		
		IF str <> "" Then
			txtTag = replace(str,  "<", "&lt;")
			txtTag = replace(txtTag, ">", "&gt;")
			txtTag = replace(txtTag, "'", "&apos;")
			txtTag = replace(txtTag, chr(39), "&#39;")
			txtTag = replace(txtTag, chr(34), "&quot;")	
			txtTag = replace(txtTag, chr(10), "<br>")	
		
			ReplaceTagText = txtTag
		END IF
	End Function
	
	Function ReplaceTagReText(str)
		dim txtTag
		
		IF str <> "" Then	
			txtTag = replace(str,  "&lt;", "<")
			txtTag = replace(txtTag, "&gt;", ">")
			txtTag = replace(txtTag, "&apos;", "'")
			txtTag = replace(txtTag, "&#39;", chr(39))
			txtTag = replace(txtTag, "&quot;", chr(34))	
			txtTag = replace(txtTag, "<br>", chr(10))	
			ReplaceTagReText = txtTag
		END IF
	End Function

		'===============================================================================
	'Server.URLEncode --> URLDecode
	'===============================================================================
'	FUNCTION URLDecode(sText)
'		dim sDecoded : sDecoded = sText
'		dim oRegExpr, oMatchCollection
'		
'		SET oRegExpr = Server.CreateObject("VBScript.RegExp")
'			oRegExpr.Pattern = "%[0-9,A-F]{2}"
'			oRegExpr.Global = True
'		
'		SET oMatchCollection = oRegExpr.Execute(sText)
'		
'		For Each oMatch In oMatchCollection
'			sDecoded = Replace(sDecoded,oMatch.value,Chr(CInt("&H" & Right(oMatch.Value,2))))
'		Next
'		
'		URLDecode = sDecoded
'		
'	END FUNCTION
%>
<!--#include file="../Library/common_function.asp"-->
<!--#include file="../Library/dbcon.asp"-->
<!-- #include virtual="/pub/class/json2.asp" -->

<%
	DBopen()
	DBOpen3()
	DBOpen4()
  AD_DBOpen()

%>
<%

  ksmmeberidx = Request.Cookies(SportsGb)("MemberIDX")

  if ksmmeberidx <> "" then

    iType = "1"

    dksmmeberidx = decode(ksmmeberidx,0)
    
    LSQL = "EXEC Favor_R '" & iType & "','" & dksmmeberidx & "','','','','',''"
    'response.Write "LSQL="&LSQL&"<br>"
    'response.End
    
    Set LRs = DBCon3.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      
        FavorYN = LRs("FavorYN")

      LRs.MoveNext
      Loop
    End If
    LRs.close

    if FavorYN = "N" then
    
      'response.Redirect("http://sdmain.sportsdiary.co.kr/sdmain/interested_category.asp")
      'response.End
    
    end if

  end if

%>

