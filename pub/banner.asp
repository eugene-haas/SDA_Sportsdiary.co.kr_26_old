<!-- #include virtual = "/pub/header.RookieTennis.mobile.asp" -->
<%
  '#################################################
    FUNCTION IPHONEYN()	

        If(Len(Request.ServerVariables("HTTP_USER_AGENT"))=0) Then
            strAgent = "NONE"
        Else
            strAgent = Request.ServerVariables("HTTP_USER_AGENT")
        End if
       
        mobile = Array("iPhone", "ipad", "ipod")

        imb = 0
        
        For Each n In mobile
            If (InStr(LCase(strAgent), LCase(n)) > 0) Then
                imb = imb + 1
            End If
        Next

        IPHONEYN = imb

    END FUNCTION

	M_conKey = "w암호화 비밀키" ' 암호화 비밀키
	'M_conIV = Replace(USER_IP,".","") & "초기화 백터" '초기화 벡터 (결제중 아이피가 변경되면 오류발생가능성 ) 
	'M_conIV = Replace(date,"-","") & "초기화 백터" '초기화 벡터 (자정문제발생)
	M_conIV = year(date) & "초기화 백터" '초기화 벡터 (자정문제발생)


	Function mallEncode(ByVal word, ByVal zero)

		'If chkBlank(word) Then Exit Function
		Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
	 	objEncrypter.Key = M_conKey
		objEncrypter.IV = M_conIV

		' 키 해시 알고리즘 설정. MD5 와 SHA2-256 을 지원합니다.
		' 아래 코드는 해시 크기가 256 비트이기 때문에, AES-256 이 사용됩니다.
		objEncrypter.KeyHashAlgorithm = "SHA2-256"

		' 문자열 암호화
		mallEncode =objEncrypter.Encrypt(word)
		Set objEncrypter = Nothing
	End Function


	Function malldecode(ByVal cipher_word, ByVal zero)
		'Response.write "<script>alert('"&cipher_word&"')</script>"
		'If chkBlank(cipher_word) Then Exit Function
		Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
	 	objEncrypter.Key = M_conKey
		objEncrypter.IV = M_conIV

		' 키 해시 알고리즘 설정. MD5 와 SHA2-256 을 지원합니다.
		' 아래 코드는 해시 크기가 256 비트이기 때문에, AES-256 이 사용됩니다.
		objEncrypter.KeyHashAlgorithm = "SHA2-256"

		' 문자열 복호화
		malldecode = objEncrypter.Decrypt(cipher_word)
		Set objEncrypter = Nothing
	End Function

  iLIMemberIDXG = decode(Request.Cookies("SD")("MemberIDX"),0)
  '#################################################



bntype = fInject(request("bntype"))
bngb = fInject(request("bngb"))
bnidx  = fInject(request("bnidx"))

'################
If request("test") = "t" Then
	bntype = 1
	bngb = "tennis"
	bnidx  = 12
End If
'################

Select Case bngb 
Case "tennis" 
	global_filepathUrl_ADIMG = "http://tennis.sportsdiary.co.kr" & global_filepathUrl_ADIMG
Case Else
	global_filepathUrl_ADIMG = "http://"&bngb&".sportsdiary.co.kr" & global_filepathUrl_ADIMG
End select


Set db = new clsDBHelper


SQL = "EXEC AD_View_S '" & bntype & "','" & bngb & "','" & bnidx & "','','','','',''"
Set rs= db.ExecSQLReturnRS(SQL , null, BN_ConStr)

If Not rs.EOF Then 
	arrRS = rs.getrows()
End if



If IsArray(arrRS) Then
	TypeOutput = arrRS(1, 0)
	LocateGb = arrRS(2, 0)
%>
  <div class="major_banner">
	<div class="banner banner_<%=LocateGb%> carousel">
		<div <% if TypeOutput = "S" then %>class="bxslider"<% end if %>>
	<%
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
			iLink = arrRS(11, ar) 
			iLinkType = arrRS(10, ar) 
			iProductLocateIDX = arrRS(8, ar) 
			ieProductLocateIDX = encode(iProductLocateIDX, 0)
			BColor = arrRS(5, ar) 
			ImgFileNm = arrRS(3, ar) 


			if Len(iLink) = 0 then
				iLink = ""
			else
				if ((instr(iLink,"sdamall") > 0) or (instr(iLink,"sdmembers") > 0)) then
					iSDMallYN = "Y"
				else
					iSDMallYN = "N"
				end If
			end If

			Set mallobj =  JSON.Parse("{}")
			Call mallobj.Set("M_MIDX", iLIMemberIDXG ) '로그인이 필요없이 이동할때 0
			Call mallobj.Set("M_PR", "R" ) 'R: 선수 S:예비후보선수, L:지도자, A,B,Z:보호자, D:일반
			Call mallobj.Set("M_SGB", iLISportsGb )
			Call mallobj.Set("M_BNKEY", iProductLocateIDX ) '베너URL 찾아서 보냄 상품코드가 있을시는 ? ...
			strjson = JSON.stringify(mallobj)
			malljsondata = mallencode(strjson,0)

			MALLURL = "http://www.sdamall.co.kr/pub/"
			%>

			<% if (IPHONEYN() = "0" and iLinkType = "2") then %>
				<% if iLink = "" then %>
				<div style="background-color: #<%=BColor%>"> <img src="<%=global_filepathUrl_ADIMG %><%=ImgFileNm %>" alt="" /> </div>
				<% else %>
				  <% if iSDMallYN = "Y" and iLIMemberIDXG <> "" then %>
				  <div style="background-color: #<%=BColor%>"> <a href="<%=MALLURL%>tube.asp?p=<%=Server.URLEncode(malljsondata)%>" class="banner_area" target="_blank" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"> <img src="<%=global_filepathUrl_ADIMG %><%=ImgFileNm %>" alt="" /> </a> </div>
				  <% elseif iSDMallYN = "Y" and iLIMemberIDXG = "" then %>
				  <div style="background-color: #<%=BColor%>"> <a href="<%=MALLURL%>tube.asp?p=<%=Server.URLEncode(malljsondata)%>" class="banner_area" target="_blank" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"> <img src="<%=global_filepathUrl_ADIMG %><%=ImgFileNm %>" alt="" /> </a> </div>
				  <% else %>
				  <div style="background-color: #<%=BColor%>"> <a href="<%=iLink %>" class="banner_area" target="_blank" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"> <img src="<%=global_filepathUrl_ADIMG %><%=ImgFileNm %>" alt="" /> </a> </div>
				  <% end if %>
				<% end if %>
				<% else %>
				<% if iLink = "" then %>
				<div style="background-color: #<%=BColor%>"> <img src="<%=global_filepathUrl_ADIMG %><%=ImgFileNm %>" alt="" /> </div>
				<% else %>
				  <% if iSDMallYN = "Y" and iLIMemberIDXG <> "" then %>
				  <div style="background-color: #<%=BColor%>"> <a href="javascript:;" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');alert('sportsdiary://urlblank=<%=MALLURL%>tube.asp?p=<%=Server.URLEncode(malljsondata)%>');" class="banner_area"> <img src="<%=global_filepathUrl_ADIMG %><%=ImgFileNm %>" alt="" /> </a> </div>
				  <% elseif iSDMallYN = "Y" and iLIMemberIDXG = "" then %>
				  <div style="background-color: #<%=BColor%>"> <a href="http://sdmain.sportsdiary.co.kr/sdmain/login.asp" class="banner_area"> <img src="<%=global_filepathUrl_ADIMG %><%=ImgFileNm %>" alt="" /> </a> </div>
				  <% else %>
				  <div style="background-color: #<%=BColor%>"> <a href="javascript:;" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');javascript:fn_mclicklink('<%=iLinkType %>','<%=iLink %>');" class="banner_area"> <img src="<%=global_filepathUrl_ADIMG %><%=ImgFileNm %>" alt="" /> </a> </div>
				  <% end if %>
				<% end if %>
			<% end if %>

	
	<%	
	Next
	%>
		</div>
	  </div>
  </div>				
<%
end If
%>