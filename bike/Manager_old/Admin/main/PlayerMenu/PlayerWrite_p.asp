<!--#include file="../../dev/dist/config.asp"-->

<%

	Check_AdminLogin()
	PTeamIDX		=  fInject(Request("PTeamIDX"))			'클럽IDX
	sido			=  fInject(Request("sido"))				'시도 
	sidogugun		=  fInject(Request("sidogugun"))		'시도구군 
	TeamNm			=  fInject(Request("TeamNm"))			'팀명 
	ZIPCODE			=  fInject(Request("ZIPCODE"))			'우편주소 
	ADDRESS			=  fInject(Request("ADDRESS"))			'주소1
	ADDRDTL			=  fInject(Request("ADDRDTL"))			'주소2
	StadiumGb		=  fInject(Request("StadiumGb"))		'주소2
	CourtCnt		=  fInject(Request("CourtCnt"))			'코트수	
	MemberCnt		=  fInject(Request("MemberCnt"))		'멤버수
	TeamContents	=  fInject(Request("TeamContents"))		'클랩내용
	AdminMemberIDX	=  fInject(Request("AdminMemberIDX"))	'관리자 idx	
	AdminName		=  fInject(Request("AdminName"))		'관리자이름
	AdminSex		=  fInject(Request("AdminSex"))			'관리자성별
	AdminPhone		=  fInject(Request("AdminPhone"))		'관리자전화번호
	AdminBirhday	=  fInject(Request("AdminBirhday"))		'관리자생년월일 
	OwnerMemberIDX	=  fInject(Request("OwnerMemberIDX"))	'클럽장 idx	
	OwnerName		=  fInject(Request("OwnerName"))		'클럽장이름	
	OwnerSex		=  fInject(Request("OwnerSex"))			'클럽장성별	
	OwnerPhone		=  fInject(Request("OwnerPhone"))		'클럽장전화번호	
	OwnerBirhday	=  fInject(Request("OwnerBirhday"))		'클럽장생년월일

'Response.write "@PTeamIDX		:"&PTeamIDX			&"<br>"
'Response.write "@sido			:"&sido				&"<br>"
'Response.write "@sidogugun		:"&sidogugun		&"<br>"
'Response.write "@TeamNm			:"&TeamNm			&"<br>"
'Response.write "@ZIPCODE		:"&ZIPCODE			&"<br>"
'Response.write "@ADDRESS		:"&ADDRESS			&"<br>"
'Response.write "@ADDRDTL		:"&ADDRDTL			&"<br>"
'Response.write "@StadiumGb		:"&StadiumGb		&"<br>"
'Response.write "@CourtCnt		:"&CourtCnt			&"<br>"
'Response.write "@MemberCnt		:"&MemberCnt		&"<br>"
'Response.write "@TeamContents	:"&TeamContents		&"<br>"
'Response.write "@AdminMemberIDX	:"&AdminMemberIDX	&"<br>"
'Response.write "@AdminName		:"&AdminName		&"<br>"
'Response.write "@AdminSex		:"&AdminSex			&"<br>"
'Response.write "@AdminPhone		:"&AdminPhone		&"<br>"
'Response.write "@AdminBirhday	:"&AdminBirhday		&"<br>"
'Response.write "@OwnerMemberIDX	:"&OwnerMemberIDX	&"<br>"
'Response.write "@OwnerName		:"&OwnerName		&"<br>"
'Response.write "@OwnerSex		:"&OwnerSex			&"<br>"
'Response.write "@OwnerPhone		:"&OwnerPhone		&"<br>"
'Response.write "@OwnerBirhday	:"&OwnerBirhday		&"<br>"
'Response.End
	
%>
<!--#include file="../../include/CheckRole.asp"-->
<%
  Dim LCnt
  LCnt = 0

  LSQL = "EXEC AdminPlayerTeamInfo_INSERT "
  LSQL = LSQL  & " @PTeamIDX		=	'"&PTeamIDX&"'"
  LSQL = LSQL  & ",@sido			=	'"&sido&"'"
  LSQL = LSQL  & ",@sidogugun		=	'"&sidogugun&"'"
  LSQL = LSQL  & ",@TeamNm			=	'"&TeamNm&"'"
  LSQL = LSQL  & ",@ZIPCODE			=	'"&ZIPCODE&"'"
  LSQL = LSQL  & ",@ADDRESS			=	'"&ADDRESS&"'"
  LSQL = LSQL  & ",@ADDRDTL			=	'"&ADDRDTL&"'"
  LSQL = LSQL  & ",@StadiumGb		=	'"&StadiumGb&"'"
  LSQL = LSQL  & ",@CourtCnt		=	'"&CourtCnt&"'"
  LSQL = LSQL  & ",@MemberCnt		=	'"&MemberCnt&"'"
  LSQL = LSQL  & ",@TeamContents	=	'"&TeamContents&"'"
  LSQL = LSQL  & ",@AdminMemberIDX	=	'"&AdminMemberIDX&"'"
  LSQL = LSQL  & ",@AdminName		=	'"&AdminName&"'"
  LSQL = LSQL  & ",@AdminSex		=	'"&AdminSex&"'"
  LSQL = LSQL  & ",@AdminPhone		=	'"&AdminPhone&"'"
  LSQL = LSQL  & ",@AdminBirhday	=	'"&AdminBirhday&"'"
  LSQL = LSQL  & ",@OwnerMemberIDX	=	'"&OwnerMemberIDX&"'"
  LSQL = LSQL  & ",@OwnerName		=	'"&OwnerName&"'"
  LSQL = LSQL  & ",@OwnerSex		=	'"&OwnerSex&"'"
  LSQL = LSQL  & ",@OwnerPhone		=	'"&OwnerPhone&"'"
  LSQL = LSQL  & ",@OwnerBirhday	=	'"&OwnerBirhday&"'"


  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon.Execute(LSQL)
 
  If Not (LRs.Eof Or LRs.Bof) Then

		Do Until LRs.Eof
      
        LCnt = LCnt + 1
        RETURN_CODE = LRs(0)

      LRs.MoveNext
		Loop

	End If

  LRs.close
  
	Response.WRITE RETURN_CODE
  'Response.End 
  
  If RETURN_CODE = "0" Then 

	  response.Write "<script type='text/javascript'>alert('클럽정보 수정이 잘 돼었습니다.');location.href='PlayerTeaminfo.asp';</script>"
	  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
	  response.End
  
  Else
  	  response.Write "<script type='text/javascript'>alert('Error');location.href='PlayerTeaminfo.asp';</script>"
	  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
	  response.End


  End If 
  DBClose()
%>