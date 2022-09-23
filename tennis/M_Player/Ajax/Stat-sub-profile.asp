<!--#include file="../Library/ajax_config_26.asp"-->
<%
	Check_Login()

	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	iGameTitleIDX = fInject(Request("iGameTitleIDX"))

	iPlayerIDX = decode(iPlayerIDX,0)

 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  'SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType")

  iSportsGb = fInject(Request("SportsGb"))
  iEnterType = EnterType
 '2017-06-26 추가

  'iPlayerIDX = "7902"

  'response.Write "SDate="&SDate&"<br>"
  'response.Write "EDate="&EDate&"<br>"
  'response.Write "GameTitleIDX="&GameTitleIDX&"<br>"
  'response.Write "iPlayerIDX="&iPlayerIDX&"<br>"
  'response.End

  'response.Write retext

  Dim iUserName, iBirthday, iTeamNm, iTall, iLevelName, iBloodType, iPhotoPath, iUserEnName, iLRsCnt01

	iLRsCnt01 = 0
  iType = "1"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & iGameTitleIDX & "','','','','',''"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

			iLRsCnt01 = iLRsCnt01 + 1

      iUserName = LRs("UserName")
      'iBirthday = LRs("Birthday")
			iUserEnName = ""
			iTeamNm = LRs("TeamNm")
			iTeam2Nm = LRs("Team2Nm")
      iAgeGroup = LRs("AgeGroup")
			iPlayerYear = LRs("PlayerYear")
      iTall = LRs("Tall")
      iHandUseNm = LRs("HandUseNm")
      iPositionReturnNm = LRs("PositionReturnNm")
			iHandTypeNm = LRs("HandTypeNm")
			iSpecialtyNm = LRs("SpecialtyNm")
      iPhotoPath = LRs("PhotoPath")

    LRs.MoveNext
		Loop
  else

	End If

  LRs.close


  'if iBirthday <> "" then
  '  iBirthdaya = Split(iBirthday, "-")
  '  iBirthday = iBirthdaya(0)&"."&iBirthdaya(1)&"."&iBirthdaya(2)
  '  iBirthday = Mid(iBirthday,3)
  'end if

	'if iSpecialtyNm <> "" then
  '  iSpecialtyNm = Split(iSpecialtyNm, "|")
  '  iSpecialtyNmCnt = uBound(iSpecialtyNm)
  'end if
	iSpecialtyNm = Replace(iSpecialtyNm, "|", ", ")

	iTestID = encode("13580",0)

  Dbclose()

%>



<% if iLRsCnt01 > 0 then %>

<div class="prof flex">
	<div class="profile-img">
		<% if iPhotoPath = "" then %>
		<img src="http://img.sportsdiary.co.kr/sdapp/gnb/profile@3x.png" alt="">
		<% else %>
		<img src="../<%=MID(iPhotoPath,4) %>" alt="">
		<% end if %>
	</div>
	<!-- S: prof-list -->
	<div class="prof-list">
		<h3><%=iUserName %> <span class="en-name"><%=iUserEnName %></span></h3>
		<dl class="prof-belong clearfix">
			<dt>소속</dt>
			<dd>
				<ul>
					<li><%=iTeamNm %><% if iTeam2Nm <> "" then %>, <%=iTeam2Nm %><% end if %></li>
				</ul>
			</dd>
		</dl>
		<dl class="prof-birth clearfix">
			<dt>나이대</dt>
			<dd><%=iAgeGroup %>대</dd>
		</dl>
		<dl class="clearfix">
			<dt>키</dt>
			<dd><% if iTall = "" then %><% else %><%=iTall %>cm<% end if %></dd>
		</dl>
		<dl class="clearfix">
			<dt>사용손</dt>
			<dd><%=iHandUseNm %></dd>
		</dl>
		<dl class="clearfix">
			<dt>복식리턴포지션</dt>
			<dd><%=iPositionReturnNm %></dd>
		</dl>
		<dl class="clearfix">
			<dt>백핸드타입</dt>
			<dd><%=iHandTypeNm %></dd>
		</dl>
		<dl class="clearfix">
			<dt>다득점기술</dt>
			<dd><%=iSpecialtyNm %></dd>
		</dl>
	</div>
	<!-- E: prof-list -->
</div>

<% end if %>
