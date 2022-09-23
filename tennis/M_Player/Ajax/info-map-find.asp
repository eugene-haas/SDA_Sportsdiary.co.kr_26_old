<!--#include file="../Library/ajax_config.asp"-->
<%
	'==============================================================================
	'단체정보 조회페이지
	'==============================================================================
	Check_Login()

	dim fnd_SctGb     	: fnd_SctGb     = fInject(request("fnd_SctGb"))
	dim fnd_KeyWord   	: fnd_KeyWord   = fInject(request("fnd_KeyWord"))
	dim fnd_Type      	: fnd_Type      = fInject(request("fnd_Type"))
	dim fnd_LastID  	: fnd_LastID  	= fInject(request("fnd_LastID"))	'출력된 마지막 row_number()
	dim cnt_board   	: cnt_board   	= fInject(request("cnt_board"))	'출력된 컨텐츠 수

	dim CSearch, CSearch2

	IF cnt_board = "" Then cnt_board = 0

	IF fnd_SctGb <> "" Then	CSearch = " AND SctGb='"&fnd_SctGb&"' "

	dim old_idx	: old_idx = 0

  SELECT CASE fnd_Type

	'검색키워드 자동완성기능
    CASE "WAUTO"
      IF fnd_KeyWord <> "" Then CSearch2 = " AND SctNm like '%"&fnd_KeyWord&"%' "

      IF fnd_KeyWord <>"" Then
        LSQL = "SELECT TOP 5 SctIDX "
        LSQL = LSQL&"   ,SctNm "
        LSQL = LSQL&" FROM [SportsDiary].[dbo].[tblSvcSctInfo] "
        LSQL = LSQL&" WHERE DelYN = 'N'"
        LSQL = LSQL&"   AND SportsGb = '"&SportsGb&"' " &CSearch&CSearch2
        LSQL = LSQL&" ORDER BY SctNm ASC "

        SET LRs = Dbcon.Execute(LSQL)
        IF Not(LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
          %>
            <li><a href="javascript:input_KeyWord('<%=LRs("SctNm")%>')"><%=replace(LRs("SctNm"), fnd_KeyWord, "<strong>"&fnd_KeyWord&"</strong>")%></a></li>
          <%
            LRs.MoveNext
          Loop
        End If

          LRs.Close
        SET LRs = Nothing
      End IF

    '키워드 검색
    CASE "WFIND"

    IF fnd_KeyWord <> "" Then CSearch2 = " AND SctNm like '%"&fnd_KeyWord&"%' "

    '조회정보 전체 카운트(더보기 버튼 출력체크)
      LSQL = "        SELECT COUNT(*) "
      LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblSvcSctInfo] "
      LSQL = LSQL & " WHERE DelYN = 'N' "
      LSQL = LSQL & "     AND SportsGb = '"&SportsGb&"'" &CSearch&CSearch2
    SET LRs = Dbcon.Execute(LSQL)
    TotalCount = LRs(0)

    '조회 테이블 체크필요
      LSQL = "        SELECT TOP 5 SctIDX "
      LSQL = LSQL & "   ,SctNm "
      LSQL = LSQL & "   ,Address "
      LSQL = LSQL & "   ,ISNULL(AddrDtl, '') AddrDtl "
      LSQL = LSQL & "   ,ISNULL(Phone, '') Phone "
	  LSQL = LSQL & "	,NUM "
      LSQL = LSQL & " FROM (SELECT ROW_NUMBER() OVER( ORDER BY SctNm ASC) AS NUM, * FROM [SportsDiary].[dbo].[tblSvcSctInfo]) A "
      LSQL = LSQL & " WHERE DelYN = 'N' "
      LSQL = LSQL & "     AND SportsGb = '"&SportsGb&"'" &CSearch&CSearch2

	  IF fnd_LastID<>"" Then   LSQL = LSQL & "   AND NUM > '"&fnd_LastID&"' "

      LSQL = LSQL & " ORDER BY SctNm "

'   response.Write "LSQL="&LSQL &"<br>"

      SET LRs = Dbcon.Execute(LSQL)
      IF Not(LRs.Eof Or LRs.Bof) Then

        Do Until LRs.Eof
            cnt = cnt + 1

			IF cint(old_idx) < cint(LRs("NUM")) Then idx = LRs("NUM")
        %>
            <div class="map-list panel">
                <section class="info-map location container">
                  <h3><%=LRs("SctNm")%><a href=".map-<%=LRs("SctIDX")%>" class="map-btn icon" data-toggle="collapse" data-parent="#map-box"><span class="deco-txt">지도보기</span><span class="deco-img"><i class="fa fa-map-marker" aria-hidden="true"></i></span></a></span></h3>
                  <p class="addr"><%=LRs("Address")%>&nbsp;&nbsp;<%=LRs("AddrDtl")%></p>
                          <%
						IF LRs("Phone")<>"" Then
						%>
						  <p class="tel"><a href="tel:<%=LRs("Phone")%>"><span class="icon-deco"><img src="http://img.sportsdiary.co.kr/sdapp/sub/icon-tel@3x.png" alt=""></span><%=LRs("Phone")%></a></p>
							  <%
						End IF
						%>
                    <div class="daum-map map-<%=LRs("SctIDX")%>">
                      <div id="map<%=LRs("SctIDX")%>" style="height: 200px;"></div>
                  </div>
                </section>
              </div>

      <script>
                var container<%=LRs("SctIDX")%> = document.getElementById('map<%=LRs("SctIDX")%>'); // 이미지 지도를 표시할 div
                var options<%=LRs("SctIDX")%> = {
                  center: new daum.maps.LatLng(33.450701, 126.570667), // 이미지 지도의 중심좌표
                  level: 4
                };

                var map<%=LRs("SctIDX")%> = new daum.maps.Map(container<%=LRs("SctIDX")%>, options<%=LRs("SctIDX")%>);

                // 주소-좌표 변환 객체를 생성합니다
                var geocoder<%=LRs("SctIDX")%> = new daum.maps.services.Geocoder();

                  geocoder<%=LRs("SctIDX")%>.addr2coord('<%=LRs("Address")%>', function(status, result<%=LRs("SctIDX")%>) {

                    var coords<%=LRs("SctIDX")%> = new daum.maps.LatLng(result<%=LRs("SctIDX")%>.addr[0].lat, result<%=LRs("SctIDX")%>.addr[0].lng);
                    var marker<%=LRs("SctIDX")%> = new daum.maps.Marker({map: map<%=LRs("SctIDX")%>,  position: coords<%=LRs("SctIDX")%>  });
                    var infowindow<%=LRs("SctIDX")%> = new daum.maps.InfoWindow({
                        content: '<div style="width:150px; text-align:center; padding:0px;"><%=LRs("SctNm")%></div>'
                      });

                  //  infowindow<%=LRs("SctIDX")%>.open(map<%=LRs("SctIDX")%>, marker<%=LRs("SctIDX")%>);

                    map<%=LRs("SctIDX")%>.setCenter(coords<%=LRs("SctIDX")%>);


              });
          </script>

          <%

			old_idx = LRs("NUM")

          LRs.MoveNext
        Loop

      End If

        LRs.Close
      SET LRs = Nothing


    response.Write "<script>$('#cnt_board').val('"&cnt+cnt_board&"');</script>"
'   response.Write "idx="&idx &"<br>"

    IF TotalCount > cnt+cnt_board Then
    %>
    <div id="more<%=idx%>" class="more_ar"><a href="#" class="more" id="<%=idx%>">더보기 <span class="ic-deco"><i class="fa fa-plus" aria-hidden="true"></i></span></a></div>
    <%
    End IF

  END SELECT


  DBClose()

%>
