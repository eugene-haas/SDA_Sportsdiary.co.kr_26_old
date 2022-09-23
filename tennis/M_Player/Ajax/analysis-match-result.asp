<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	GameTitleIDX = ""
	
	iPlayerIDX = decode(iPlayerIDX,0)
	
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

	'iPlayerIDX = "1403"
	
	'response.Write "SDate="&SDate&"<br>"
	'response.Write "EDate="&EDate&"<br>"
	'response.Write "GameTitleIDX="&GameTitleIDX&"<br>"
	'response.Write "iPlayerIDX="&iPlayerIDX&"<br>"
	'response.End
	
	'response.Write retext
  
  Dim iUserName, iBirthday, iTeamNm, iTall, iLevelName, iBloodType, iPhotoPath, iUserEnName

  iType = "1"
  'iSportsGb = "judo"

  LSQL = "EXEC Analysis_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
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
    if Instr(iBirthday,"-") <> 0 then
      iBirthdaya = Split(iBirthday, "-")
      iBirthday = iBirthdaya(0)&"."&iBirthdaya(1)&"."&iBirthdaya(2)
      iBirthday = Mid(iBirthday,3)
    else
      iBirthday = Left(iBirthday,4)&"-"&Mid(iBirthday,5,2)&"-"&Right(iBirthday,2)
      iBirthdaya = Split(iBirthday, "-")
      iBirthday = iBirthdaya(0)&"."&iBirthdaya(1)&"."&iBirthdaya(2)
      iBirthday = Mid(iBirthday,3)
    end if
  end if



  Dim LRsCnt5, iSpecialtyDtlName5, iJumsu5, iSpecialtyDtl5
  LRsCnt5 = 0

  iType = "51"
  'iSportsGb = "judo"

  LSQL = "EXEC Analysis_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

      LRsCnt5 = LRsCnt5 + 1
      iSpecialtyDtl5 = iSpecialtyDtl5&"^"&LRs("SpecialtyDtl")&""
      iSpecialtyDtlName5 = iSpecialtyDtlName5&"^"&LRs("SpecialtyDtlName")&""
      iJumsu5 = iJumsu5&"^"&LRs("Jumsu")&""

    LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close



  Dbclose()

  %>


<div class="profile-img">
  <img src="<%=iPhotoPath %>" alt="" />
</div>
<!-- S: prof-list -->
<div class="prof-list">
  <h3><%=iUserName %> <span class="en-name"><%=iUserEnName %></span></h3>
  <dl class="prof-belong clearfix">
    <dt>소속</dt>
    <dd>
      <ul>
        <li><%=iTeamNm %></li>
      </ul>
    </dd>
  </dl>
  <dl class="prof-birth clearfix">
    <dt>생년월일</dt>
    <dd><%=iBirthday %></dd>
  </dl>
  <dl class="clearfix">
    <dt>키</dt>
    <dd><%=iTall %><% if iTall <> 0 then %>cm<% end if %></dd>
  </dl>
  <dl class="clearfix">
    <dt>체급</dt>
    <dd><%=iLevelName %></dd>
  </dl>
  <dl class="clearfix">
    <dt>혈액형</dt>
    <dd><%=iBloodType %></dd>
  </dl>
  <dl class="clearfix">
    <dt>다득점기술</dt>
    <dd id="iManyPointNm"></dd>
  <!-- 다득점기술의 표기기준
					대회경기데이터 값에서 자동으로 도출되서 기재되게끔
					ex) 모든 기술득점 중, 가장 득점확률이 높은 (좌우기술 중) 기술
		-->
  </dl>
</div>
<!-- E: prof-list -->

<% if LRsCnt5 > 0 then %>
<script type="text/javascript">

  // 득점
  var LRsCnt5 = '<%=LRsCnt5%>';
  LRsCnt5 = Number(LRsCnt5);

  if (LRsCnt5 > 0) {

    var iSpecialtyDtlName5 = '<%=iSpecialtyDtlName5%>';

    var iSpecialtyDtlName5arr = iSpecialtyDtlName5.split("^");

    var iJumsu5 = '<%=iJumsu5%>';

    var iJumsu5arr = iJumsu5.split("^");

    
    // 최고점수 인덱스 구하기
    var max_index = -1;
    var max_value = Number.MIN_VALUE;
    for (var i = 1; i < iJumsu5arr.length + 1; i++) {
      if (iJumsu5arr[i] > max_value) {
        max_value = iJumsu5arr[i];
        max_index = i;
      }
    }
    //alert(max_index + ',' + max_value);

    $('#iManyPointNm').html(iSpecialtyDtlName5arr[max_index]);

  }

</script>
<% end if %>
