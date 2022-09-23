<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()

	SDate = fInject(Request("SDate"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	fnd_KeyWord 	= fInject(Request("fnd_KeyWord"))

 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType")

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가

	'- iType
	'1 : 선수분석 검색부분 > 대회명
	'2 : 선수분석 검색부분 > 선수명

	iType = "2"
	'iSportsGb = "judo"

  LSQL = "EXEC Analysis_Search '" & iType & "','" & SDate & "','" & iSportsGb & "','" & GameTitleIDX & "','" & fnd_KeyWord & "'"
	Set LRs = Dbcon.Execute(LSQL)


  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

    iPIDX = LRs("PlayerIDX")
    iPIDX = encode(iPIDX,0)

    if LRs("PhotoPath") = "N"  then
      iPhotoPath = "http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png"
    else
      iPhotoPath = "../"&Mid(LRs("PhotoPath"),4)
    end if

%>
      <li>
        <a href="javascript:input_KeyWord('<%=LRs("UserName")%>','<%=iPIDX%>')">
          <span class="srch-img default-img">

            <img src="<%=iPhotoPath%>">

          </span>
          <span><%=replace(LRs("UserName"),fnd_KeyWord, "<strong>"&fnd_KeyWord&"</strong>")%></span>
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
