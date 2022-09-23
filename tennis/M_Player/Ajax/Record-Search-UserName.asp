<!--#include file="../Library/ajax_config.asp"-->
<%
  	Check_Login()

	SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
	Schgubun = fInject(Request("Schgubun"))
	Fnd_KeyWord 	= fInject(Request("Fnd_KeyWord"))


 '2017-06-26 �߰� (�Ƹ��߾� / ���� ���� �߰� )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  fInject(Request("EnterType"))

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 �߰�


	iType = "3"
	'iSportsGb = "judo"

  Dim iPIDX, iPhotoPath

  LSQL = "EXEC Record_Search '" & iType & "','" & iSportsGb & "','" & iEnterType & "','" & SDate & "','" & EDate & "','" & Schgubun & "','" & Fnd_KeyWord & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = Dbcon.Execute(LSQL)


  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

    if Schgubun = "schuser" then
    iPIDX = LRs("SearchIDX")
    iPIDX = encode(iPIDX,0)
    end if

    if LRs("PhotoPath") = "N"  then
      iPhotoPath = "http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png"
    else
      iPhotoPath = "../"&Mid(LRs("PhotoPath"),4)
    end if

%>
      <li>
        <a href="javascript:input_KeyWord('<%=LRs("SearchText")%>','<%=iPIDX%>');">
          <% if Schgubun = "schuser" then %>
          <span class="srch-img default-img img-round">
            <img src="<%=iPhotoPath%>">
          </span>
          <span>
            (<%

              dim ibd, ibdlen

              'ibd = replace(LRs("Birthday"),"-","")
              'ibdlen = Len(ibd) - 2
              'ibd = Mid(ibd, 3, ibdlen)

              ibd = LRs("TeamNm")

              response.Write ibd

              %>)
          </span>
          <% end if %>
          <span><%=replace(LRs("SearchText"),Fnd_KeyWord, "<strong>"&Fnd_KeyWord&"</strong>")%></span>
        </a>
      </li>
<%
	    LRs.MoveNext
		Loop
	End If

  LRs.Close
	SET LRs = Nothing
  Dbclose()

%>
