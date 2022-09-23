<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	dim MemberIDX	 	: MemberIDX 		= fInject(Request("MemberIDX"))		
	dim PlayerIDX 		: PlayerIDX 		= fInject(Request("PlayerIDX"))		
	dim UserEnName 		: UserEnName   		= ReplaceTagText(fInject(Request("UserEnName")))
	dim UserPhone 		: UserPhone 		= fInject(Request("UserPhone"))
	dim UserEmail 		: UserEmail 		= ReplaceTagText(fInject(Request("UserEmail")))
	dim UserAddr 		: UserAddr 			= ReplaceTagText(fInject(Request("UserAddr")))
	dim UserAddrDtl 	: UserAddrDtl 		= ReplaceTagText(fInject(Request("UserAddrDtl")))
	dim SEX 			: SEX 				= fInject(Request("SEX"))	
	dim BloodType 		: BloodType 		= fInject(Request("BloodType"))
	dim ZipCode 		: ZipCode 			= fInject(Request("ZipCode"))	
	dim PlayerStartYear : PlayerStartYear 	= fInject(Request("PlayerStartYear"))
	dim PlayerTall 		: PlayerTall 		= fInject(Request("PlayerTall"))
	dim PlayerWeight 	: PlayerWeight 		= fInject(Request("PlayerWeight"))
	dim SmsYn 			: SmsYn 			= fInject(Request("SmsYn"))			'휴대폰 수신동의
	dim EmailYn 		: EmailYn 			= fInject(Request("EmailYn"))		'이메일 수신동의
	dim Hidden_SmsYn 	: Hidden_SmsYn 		= fInject(Request("Hidden_SmsYn"))	'Old 휴대폰 수신동의
	dim Hidden_EmailYn 	: Hidden_EmailYn	= fInject(Request("Hidden_EmailYn"))'Old 이메일 수신동의	
	dim PlayerLevel 	: PlayerLevel 		= fInject(Request("PlayerLevel"))	'체급
	dim PlayerReln 		: PlayerReln 		= fInject(Request("PlayerReln"))	'선수와의 관계
	dim Job		 		: Job		 		= fInject(Request("Job"))			'직업군
	dim Interest 		: Interest 			= fInject(Request("Interest"))		'관심분야

	'PubCode  ex)sd039001[PlayerGb:선수], sd045001[PlayerType:내국인]
	
	
	If MemberIDX = "" Then 	
		Response.Write "FALSE"
		Response.End
	Else 
		'tblMember 가입내역 조회		
		ChkSQL =  	"SELECT * " &_
					"FROM [Sportsdiary].[dbo].[tblMember] " &_
					"WHERE MemberIDX = '"&MemberIDX&"' "	
		
'		response.Write ChkSQL&"<br>"
		
		SET LRs = DBCon.Execute(ChkSQL)	
		IF LRs.eof or LRs.bof Then
			response.Write "FALSE"
			response.End()
		Else
	
			JoinSQL = "UPDATE [SportsDiary].[dbo].[tblMember] " 
			JoinSQL = JoinSQL & " SET " 
			JoinSQL = JoinSQL & "	UserEnName = '"&UserEnName&"', " 
			JoinSQL = JoinSQL & "	UserPhone = '"&UserPhone&"', " 
			JoinSQL = JoinSQL & "	Email = '"&UserEmail&"', " 
			JoinSQL = JoinSQL & "	Address = '"&UserAddr&"', " 
			JoinSQL = JoinSQL & "	AddressDtl = '"&UserAddrDtl&"', " 
			JoinSQL = JoinSQL & "	Sex = '"&SEX&"', " 
			JoinSQL = JoinSQL & "	BloodType = '"&BloodType&"', " 
			JoinSQL = JoinSQL & "	ZipCode = '"&ZipCode&"', " 
			JoinSQL = JoinSQL & "	PlayerStartYear = '"&PlayerStartYear&"', " 
			JoinSQL = JoinSQL & "	PlayerLevel = '"&PlayerLevel&"', " 
			JoinSQL = JoinSQL & "	Tall = '"&PlayerTall&"', " 
			JoinSQL = JoinSQL & "	Weight = '"&PlayerWeight&"', " 
			JoinSQL = JoinSQL & "	Job = '"&Job&"', " 
			JoinSQL = JoinSQL & "	Interest = '"&Interest&"', " 
								
			
			IF SmsYn <> Hidden_SmsYn Then
				JoinSQL = JoinSQL & "	SmsYn = '"&SmsYn&"', "  					
				JoinSQL = JoinSQL & "	SmsYnDt = '"& replace(left(now(),10),"-","")&"', "  					
			End IF
			
			IF EmailYn <> Hidden_EmailYn Then
				JoinSQL = JoinSQL & "	EmailYn = '"&EmailYn&"', "  
				JoinSQL = JoinSQL & "	EmailYnDt = '"& replace(left(now(),10),"-","")&"', "  					
			End IF
			
			JoinSQL = JoinSQL & "	WriteDate = GETDATE() "  					
			JoinSQL = JoinSQL & "WHERE MemberIDX = '"&MemberIDX&"' " 
			
'			response.Write JoinSQL&"<br>"
			DBCon.Execute(JoinSQL)	
			
			Response.Write "TRUE"

		End IF
			LRs.Close
		SET LRs = Nothing
		
		DBClose()
		
	End If 

%>