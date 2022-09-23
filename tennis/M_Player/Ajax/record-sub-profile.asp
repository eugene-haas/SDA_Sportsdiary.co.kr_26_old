<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()

	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))

	iPlayerIDX = decode(iPlayerIDX,0)

 '2017-06-26 �߰� (�Ƹ��߾� / ���� ���� �߰� )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType")

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 �߰�

  'iPlayerIDX = "7902"

  'response.Write "SDate="&SDate&"<br>"
  'response.Write "EDate="&EDate&"<br>"
  'response.Write "GameTitleIDX="&GameTitleIDX&"<br>"
  'response.Write "iPlayerIDX="&iPlayerIDX&"<br>"
  'response.End

  'response.Write retext

  Dim iUserName, iBirthday, iTeamNm, iTall, iLevelName, iBloodType, iPhotoPath, iUserEnName

  iType = "1"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

      iUserName = LRs("UserName")
      iUserEnName = LRs("UserEnName")
      iBirthday = LRs("Birthday")
      iTeamNm = LRs("TeamNm")
      iTall = LRs("Tall")
      iLevelName = LRs("LevelName")
      iBloodType = LRs("BloodType")
      iPhotoPath = LRs("PhotoPath")

    LRs.MoveNext
		Loop
  else

	End If

  LRs.close


  if iBirthday <> "" then
    iBirthdaya = Split(iBirthday, "-")
    iBirthday = iBirthdaya(0)&"."&iBirthdaya(1)&"."&iBirthdaya(2)
    iBirthday = Mid(iBirthday,3)
  end if


  Dbclose()

  %>

<div class="profile-img">
  <% if iPhotoPath = "" then %>
  <img src="http://img.sportsdiary.co.kr/sdapp/gnb/profile@3x.png" alt="">
  <% else %>
  <img src="../<%=MID(iPhotoPath,4) %>" alt="">
  <% end if %>
</div>
<h3><%=iUserName %> <span>(<%=iTeamNm %>)</span></h3>
