
<%
  tidx = oJSONoutput.TitleIDX 
  gamekey3 =  oJSONoutput.S3KEY
  levelkey = gamekey3
  levelno = levelkey
	gamekey3 = Left(gamekey3,5)

  Set db = new clsDBHelper
	SQL = " Select EntryCnt,attmembercnt,courtcnt,level from   tblRGameLevel  where    DelYN = 'N' and  GameTitleIDX = " & tidx  & " and Level = " & levelno
	'Response.Write SQL
  'rESPONSE.END
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		courtcnt = rs("courtcnt") '코트수
		levelno = rs("level")
	End if

	If IsArray(useCourtRS) = false Then
		SQL = "Select courtno,stateno from sd_TennisResult where delYN = 'N' and GameTitleIDX = " & tidx & " and Level = '"& levelno &"' " 'and preresult = 'ING' "
        
         SQL = " select courtno,stateno ,courtkind,tryoutgroupno , ynChek " & _
               " from (Select courtno,stateno ,courtkind,tryoutgroupno " & _
               " ,isnull((select 1 from sd_TennisMember where (gameMemberIDX = a.gameMemberIDX1) and DelYN='N' ),0) ynChek " & _
               " from sd_TennisResult a where delYN = 'N' and GameTitleIDX = " & tidx & " and Level = '"& levelno &"') a  " & _ 
               " group by  courtno,stateno ,courtkind,tryoutgroupno , ynChek "
		 
         SQL = " select courtno,stateno ,courtkind,tryoutgroupno  " & _
               " ,case ynChek1 when 1 then 1 else case ynChek2 when 1 then 1 else 0 end  end  ynChek " & _
               " from ( " & _
                    " Select courtno,stateno ,courtkind,tryoutgroupno " & _
                    " ,isnull((select 1 from sd_TennisMember where (gameMemberIDX = a.gameMemberIDX1) and DelYN='N' ),0) ynChek1 " & _
                    " ,isnull((select 1 from sd_TennisMember where (gameMemberIDX = a.gameMemberIDX2) and DelYN='N' ),0) ynChek2 " & _
                    " from sd_TennisResult a where delYN = 'N' and GameTitleIDX = " & tidx & " and Level = '"& levelno &"'  " & _ 
               " ) a  " & _ 
               " group by  courtno,stateno ,courtkind,tryoutgroupno  " & _ 
               " , case ynChek1 when 1 then 1 else case ynChek2 when 1 then 1 else 0 end  end "
        'Response.Write "<tr><td>"&SQL&"</td></tr>"

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			useCourtRS = rs.GetRows()
		End If
	End if
	'Response.Write	"코트수 : " & courtcnt & "</br>"
%>

<%
  '타입 석어서 보내기
  Call oJSONoutput.Set("result", "0" )
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
 
<table border="0" width="100%" id="CoutdTb">
<%
  Response.write "<tr>"
  For m = 1 To courtcnt
    %><td align="center"><%=m%>코트<td><%
  next
  Response.write "</tr>"
  Response.write "<tr>"
  For m = 1 To courtcnt
    %><td align="center"><img src="http://tennisadmin.sportsdiary.co.kr/images/tennis/tennis_court.jpg"><td><%
  next
  Response.write "</tr>"

  Response.write "<tr>"
  For m = 1 To courtcnt
    usestr = "빈 코트" 
    usecolor = "style='color:green'"

    If IsArray(useCourtRS) Then

      For c = LBound(useCourtRS, 2) To UBound(useCourtRS, 2) 

        usecourt = useCourtRS(0, c) 
        courtstate =  useCourtRS(1, c) 

        if  useCourtRS(4, c) = 1 then  
            If m = CDbl(usecourt)   then
              If courtstate = "1" Then
                  usestr = "빈 코트"
                  usecolor = " style='color:green'"
              else
                  usestr = "사용 중"			'사용중
                  usecolor = " style='color:orange'"
              End if

            End If
        End If

      Next

    End If
    %><td align="center" <%=usecolor%>><%=usestr%> <td><%
  Next
  Response.write "</tr>"
  %>
</table>

<%
  
Set rs = Nothing
db.Dispose
Set db = Nothing
%>