<% 
	tTitleIDX = oJSONoutput.TitleIDX
	tS3KEY = oJSONoutput.S3KEY
	tround = oJSONoutput.round
	tGUBUN = oJSONoutput.GUBUN

    ''라운드 수정 가능 한지 체크
    if tGUBUN = 2 then 
        trGUBUN = 3
    else 
        trGUBUN = 2
    end if 

    Set db = new clsDBHelper

    sql =" update sd_TennisMember "
    sql = sql & " set GUBUN ='"&tGUBUN&"' "
    sql = sql & " where GameTitleIDX = '"&tTitleIDX&"'  "
    sql = sql & " and gamekey3='"&tS3KEY&"' " 
    sql = sql & " and Round='"&tround&"'"
    sql = sql & " and gubun='"&trGUBUN&"'"

    'Response.Write  sql

    Call db.execSQLRs(sql , null, ConStr)

if  tGUBUN = 2 then  
%>
<a  class="btn_a" id="set_Round_a<%=tround %>" onclick="mx.tornGameIn({'CMD':'30044','TitleIDX':'<%=tTitleIDX %>','S3KEY':'<%=tS3KEY %>','round':'<%=tround %>','GUBUN':'3'},'<%=tround %>');" >완료</a> 
<% 
else 
%>
<a  class="btn_a"  id="set_Round_a<%=tround %>" onclick="mx.tornGameIn({'CMD':'30044','TitleIDX':'<%=tTitleIDX %>','S3KEY':'<%=tS3KEY %>','round':'<%=tround %>','GUBUN':'2'},'<%=tround %>');" >재편성</a> 
<% 
end if 


db.Dispose
Set db = Nothing
%>