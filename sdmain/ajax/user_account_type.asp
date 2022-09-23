<!--#include file="../Library/ajax_config.asp"-->
<%
	'=========================================================================================
	'종목메인 계정설정
	'=========================================================================================
	'로그인하지 않았다면 login.asp로 이동
	Check_Login()	
	
	dim SportsType	: SportsType 	= fInject(Trim(Request("SportsType")))
	dim join_IDX	: join_IDX		= fInject(Trim(Request("join_IDX")))
	dim UserID	 	: UserID		= Request.Cookies("SD")("UserID")
			
	dim CSQL, CRs

	
	IF join_IDX = "" OR UserID = "" OR SportsType =  "" Then 
		Response.Write "FALSE|200"
		Response.End
	Else
		On Error Resume Next			
   
		DBCon.BeginTrans()
		DBCon3.BeginTrans()
   
		
		SELECT CASE SportsType
   			CASE "judo" 
		 		
				DBCon.Execute("UPDATE [SportsDiary].[dbo].[tblMember] SET SD_GameIDSET='N', WriteDate=GETDATE() WHERE DelYN='N' AND SD_UserID='"&UserID&"'")
				ErrorNum = ErrorNum + DBCon.Errors.Count

				DBCon.Execute("UPDATE [SportsDiary].[dbo].[tblMember] SET SD_GameIDSET='Y', WriteDate=GETDATE() WHERE DelYN='N' AND SD_UserID='"&UserID&"' AND MemberIDX='"&join_IDX&"'")
				ErrorNum = ErrorNum + DBCon.Errors.Count

				IF ErrorNum > 0 Then
					DBCon.RollbackTrans()
					Response.Write "FALSE|66"			
				Else				
					DBCon.CommitTrans()
					Response.Write "TRUE|"
				End IF

				DBClose()

		 	CASE "tennis" 	
				DBCon3.Execute("UPDATE [SD_Tennis].[dbo].[tblMember] SET SD_GameIDSET='N', WriteDate=GETDATE() WHERE DelYN='N' AND SD_UserID='"&UserID&"'")
				ErrorNum = ErrorNum + DBCon3.Errors.Count																
				
				DBCon3.Execute("UPDATE [SD_Tennis].[dbo].[tblMember] SET SD_GameIDSET='Y', WriteDate=GETDATE() WHERE DelYN='N' AND SD_UserID='"&UserID&"' AND MemberIDX='"&join_IDX&"'")
				ErrorNum = ErrorNum + DBCon3.Errors.Count	
   
				IF ErrorNum > 0 Then
					DBCon3.RollbackTrans()			
					Response.Write "FALSE|66"			
				Else				
					DBCon3.CommitTrans()			
					Response.Write "TRUE|"
				End IF

				DBClose3()
	
			CASE "bike"
				DBCon3.Execute("UPDATE [SD_Tennis].[dbo].[tblMember] SET SD_GameIDSET='N', WriteDate=GETDATE() WHERE DelYN='N' AND SD_UserID='"&UserID&"'")
				ErrorNum = ErrorNum + DBCon3.Errors.Count																
				
				DBCon3.Execute("UPDATE [SD_Tennis].[dbo].[tblMember] SET SD_GameIDSET='Y', WriteDate=GETDATE() WHERE DelYN='N' AND SD_UserID='"&UserID&"' AND MemberIDX='"&join_IDX&"'")
				ErrorNum = ErrorNum + DBCon3.Errors.Count	
   
				IF ErrorNum > 0 Then
					DBCon3.RollbackTrans()			
					Response.Write "FALSE|66"			
				Else				
					DBCon3.CommitTrans()			
					Response.Write "TRUE|"
				End IF

				DBClose3()

   		END SELECT
	End IF 
%>