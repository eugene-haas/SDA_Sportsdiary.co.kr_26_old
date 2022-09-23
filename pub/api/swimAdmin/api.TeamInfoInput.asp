<%
    SportsGb= "tennis"
    PTeamGb= ""
    Team= oJSONoutput.Team
    TeamNm= oJSONoutput.TeamNm
    TeamEnNm= ""
    ShortNm= ""
    Sex= "3"
    sido= oJSONoutput.sido
    ZipCode= oJSONoutput.ZipCode
    Address= oJSONoutput.Address
    AddrDtl= oJSONoutput.AddrDtl
    TeamTel= oJSONoutput.TeamTel
    'TeamRegDt= " convert(nvarchar,GETDATE(),112) "
    TeamEdDt= ""
    EnterType= "A"
    TeamLoginPwd= oJSONoutput.TeamLoginPwd
    SvcStartDt= ""
    SvcEndDt= ""
    WriteDate= " GETDATE() "
    WorkDt= " GETDATE() "
    DelYN= "N"
    NowRegYN=  "Y"

	Set db = new clsDBHelper
     
		SQL = "Select Team from tblTeamInfo where SportsGb = 'tennis' and TeamNm = '"&Replace(Trim(TeamNm)," ","")&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		If rs.eof Then
			'등록 후 정보
			SQL = "Select top 1 convert(nvarchar,SUBSTRING(Team,4,LEN(Team))+1) teamLast,len(Team)TeamLen from  tblTeamInfo where SportsGb = 'tennis'  ORDER BY Team desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			Team = "ATE000" & rs(0)

		    insertfield = " SportsGb,PTeamGb,Team,TeamNm,TeamEnNm,ShortNm,Sex,sido,ZipCode,Address,AddrDtl,TeamTel,TeamRegDt,TeamEdDt,EnterType,TeamLoginPwd,SvcStartDt,SvcEndDt,WriteDate,WorkDt,DelYN,NowRegYN "
		    insertvalue = " '"&SportsGb&"','"&PTeamGb&"','"&Team&"','"&TeamNm&"','"&TeamEnNm&"','"&ShortNm&"','"&Sex&"','"&sido&"','"&ZipCode&"','"&Address&"','"&AddrDtl&"','"&TeamTel&"','"&TeamRegDt&"','"&TeamEdDt&"','"&EnterType&"','"&TeamLoginPwd&"','"&SvcStartDt&"','"&SvcEndDt&"',"&WriteDate&","&WorkDt&",'"&DelYN&"','"&NowRegYN&"' "
		    SQL = "SET NOCOUNT ON INSERT INTO tblTeamInfo ( "&insertfield&" ) VALUES " 'confirm 확인여부
		    SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		    TeamIDX = rs(0)
		Else
			TeamIDX = rs(0)
            
		End If 
        num = TeamIDX
  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
<!-- #include virtual = "/pub/html/swimAdmin/Teaminfolist.asp" -->