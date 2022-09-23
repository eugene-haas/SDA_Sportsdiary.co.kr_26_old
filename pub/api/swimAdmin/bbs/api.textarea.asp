<%
'#############################################
'대진표 리그 화면 준비 
'#############################################

'request
idx = oJSONoutput.IDX

Set db = new clsDBHelper

SQL = "Select bigo from tblRGameLevel where RGameLevelIdx = " & idx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

 If Not rs.eof Then
	contents = htmlDecode(rs(0))
 End if
%>
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'>공지</h3>
  </div>

	<textarea name="notice" id="notice" rows="10" cols="80" style="width:98%;height:600px;margin:10px;padding:5px;"><%=contents%></textarea>

<div id="rtbtnarea" style="width:98%;margin:auto;height:40px;overflow:auto;text-align:center;padding-top:5px;font-size:18px;">
<a href="javascript:mx.writeNoticeOK(<%=idx%>)" class="btn btn_func">글쓰기</a>
</div>


<%
db.Dispose
Set db = Nothing
%>
