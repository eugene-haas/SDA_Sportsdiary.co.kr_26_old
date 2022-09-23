<!-- #include virtual = "/pub/header.ridingadmin.asp" -->
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=3">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge, chrome=1">
    <title>Tournament Tree</title>
    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css" />
    <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>
  </head>
  <body>

    <h3>tournament tree default</h3>
    <div class="tournament"></div>

	
	

	



<%
		Set db = new clsDBHelper

	SQL = " Select min(attdates), max(attdatee) from tblRGameLevel where DelYN='N' and GameTitleIDX = 41"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

Response.write rs(0) & "<br>"
Response.write rs(1) & "<br>"

attdates = "2019-06-25"
attdatee = "2019-06-25"

	If isnull(rs(0)) = True  Then

	Else
		If CDate(rs(0)) < CDate(attdates) Then
			atts = Left(rs(0),10)
		Else
			atts = attdates
		End If
		If CDate(rs(1)) > CDate(attdatee) Then
			atte = Left(rs(1),10)
		Else
			atte = attdatee
		End if		
	End if

Response.write atte & "<br>"




%>

  </body>
</html>

