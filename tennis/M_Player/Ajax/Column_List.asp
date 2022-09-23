<!--#include file="../Library/ajax_config.asp"-->
<%

  Dim iTotalCount, iTotalPage, LCnt0 '페이징
  LCnt0 = 0

  Dim LCnt, NowPage, PagePerData '리스트
  LCnt = 0

  iDivision = fInject(Request("iDivision"))

  If Len(iDivision) = 0 Then
    iDivision = "13"
  End If

  'iLoginID = decode(fInject(Request.cookies("UserID")),0)
  iLoginID = Request.Cookies("UserID")
  iLoginID = decode(iLoginID,0)

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  
  'Request Data
  iSubType = fInject(Request("iSubType"))
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))
  iNoticeYN = fInject(Request("iNoticeYN"))

  iSearchCol1 = fInject(Request("iSearchCol1")) ' S2Y : 최신순, S2C : 많이본순

  ieSearchCol2 = fInject(Request("iSearchCol2")) ' ColumnistIDX
  iSearchCol2 = decode(ieSearchCol2,0)

  If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSubType) = 0) Then iSubType = "" ' 구분
  if(Len(iNoticeYN) = 0) Then iNoticeYN = "" ' 구분
  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' 검색 구분자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

  if(Len(iSearchCol1) = 0) Then iSearchCol1 = "S2Y"

  if(Len(iSearchCol2) = 0) Then iSearchCol2 = ""

  iType = "1"                      ' 1:조회, 2:총갯수

  ipdsgroup = ""        ' 마이페이지>게시글관리 : 게시판구분
  'iSearchCol2 = ""   ' tblColumnist 컬럼리스트 그룹 IDX
  iDayGubun = ""        ' 랭킹시상식>년간,월간

  LSQL = "EXEC Community_Board_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','" & global_MainCLCnt & "','" & ipdsgroup & "','" & iDayGubun & "','" & iSearchCol2 & "','" & iSearchCol1 & "','','','','',''"
  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon4.Execute(LSQL)
                    
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        LCnt = LCnt + 1

        iColumnistIDXNm = LRs("ColumnistIDXNm")
%>
<li>
  <a href="javascript:;" onclick="javascript:ReadListLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>','<%=iColumnistIDXNm %>');">
    <% 
      if LRs("Link") <> "" then 
      ImgSum = global_filepathImgUrl&"\"&LRs("Link")
    %>
    <!-- <div class="img">
      <img src='<%=ImgSum %>' alt='' />
    </div> -->
    <% else %>
    <!--<div class="img">
      <img src='<%'=ImgCLDefault %>' alt='' />
    </div>-->
    <% end if %>
    <div class="bt_con">
      <div class="txt">
        <p class="name"><%=LRs("Subject") %></p>
				<% if LRs("NewYN") = "Y" then %>
        <span class="ic-new">N</span>
        <% end if %>
				<p class="date_con">
          <span class="date"><%=LRs("InsDateCv") %></span>
          <span class="division_line"></span>
          <span class="views_number"><span><%=LRs("ViewCnt") %></span> 읽음</span>
          <span class="view_arrow"><i class="fa fa-arrow-right"></i></span>
        </p>
      </div>
    </div>
  </a>
</li>
<%
    LRs.MoveNext
  Loop

End If
  
LRs.close
  
DBClose4()
%>