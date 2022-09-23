<%
 'Controller ################################################################################################

	'request 처리##############
	page = chkInt(chkReqMethod("page", "GET"), 1)
	search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
	search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

	page = iif(search_first = "1", 1, page)
	'request 처리##############

	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	strTableName = " sd_TennisTitle "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " GameTitleIDX,gameTitleName   " ',GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,viewState,stateNo
	strSort = "  order by GameTitleIDX desc"
	strWhere = " DelYN = 'N' "'  and stateNo = 0"

	SQL = "Select top 40 " & strFieldName & " from " & strTableName & " where " & strWhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRT = rs.GetRows()
	End if
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>

		<form name="frm" method="post">
		<div class="top-navi-inner">

			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>예선편성표 등록</strong>
				</h3>
			</div>

			<div class="top-navi-btm">
				<table class="navi-tp-table">
					<caption>대회정보 기본정보</caption>
					<colgroup>
						<col width="200px">
						<col width="*">
					</colgroup>
					<tbody>
						<tr id="level_form">					
						<!-- #include virtual = "/pub/html/tennisAdmin/datauploadform.asp" -->
						</tr>
					</tbody>
				</table>


<!-- 				<div class="btn-left-list" style> -->
<!-- 					<a href="#" id="btnsave" class="btn" onclick="mx.input_frm();" accesskey="i">예선대진표등록</a> -->
<!-- 				</div> -->
			</div>

		</div>
		</form>


<div style="color:red;width:95%;margin:auto;">* 3일 이내 올린 파일만 표시   >>> 파일업로드</div>
<%
 Sub GetFileList(strPath)
  Dim FSO, Folder, Files, FilePath,filecolor
  Set FSO = Server.CreateObject( "Scripting.FileSystemObject" )
  Set Folder = FSO.GetFolder(strPath) 
  '하위 폴더명을 붙이면서 Folder개채를 생성한다.
  Set Files = Folder.Files
  'Folder개채로 File개채를 생성한다.

For Each file In Files
		'lapse = DateDiff("h",CDate(File.dateCreated),now) '3시간
		'If CDbl(lapse)  < 3 Then
		'filecolor = ";color:red;"
		'End if	

		'Response.write Date - 1 & "<br>"
		'If CDbl(lapse)  < 2 Then
		If CDate(File.dateCreated) > Date - 300  then
		'FilePath = strPath&"\"& "<span style='"&filecolor&"'>" & File.Name & "</span>"
		%><div style="width:95%;margin:auto;height:25px;margin-top:1px;padding-left:5px;;border: 1px solid #73AD21;"><%=File.Name%>  <a href="javascript:mx.SetSheet(0,'<%=File.Name%>')" class="btn_a">1번 쉬트 내용 선택</a></div><%
		End if
		'File개채들을 출력한다.
Next

  Set Files = Nothing
  Set Folder = Nothing
  Set FSO = Nothing
 End Sub


  set fs = createobject("scripting.filesystemobject")
  '-------------------------
  '폴더객체 구하기
  '-------------------------
  set folder = fs.GetFolder("D:\sportsdiary.co.kr\\xls\")

Call GetFileList(folder)
%>


<div id="updatelog" style="width:95%;margin:auto;height:100px;overflow:auto;border: 1px solid #73AD21;"></div><!-- 쉬트뷰 -->


<span id="sheetview"></span><!-- 쉬트뷰 -->


