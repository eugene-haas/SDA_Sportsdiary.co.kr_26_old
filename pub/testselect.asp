<!-- include virtual = "/pub/header.RookieTennisAdmin.asp" -->
<!-- #include virtual = "/pub/header.TennisAdmin.asp" -->

<%
  Set db = new clsDBHelper

'차집합 테스트
  'SQL = "select top 100 a.memberidx,b.username,b.userphone from SD_Member.dbo.tblMember as a INNER JOIN tblPlayer as b ON  a.UserName = b.userName and replace(a.userphone,'-','') = b.userphone "
  'SQL = "select top 100 memberidx,username,userphone from SD_Member.dbo.tblMember where  username + replace(userphone,'-','') in (select username + replace(userphone,'-','') from SD_Member.dbo.tblMember except select username + userphone from tblPlayer)"

  'Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

  'SQL = "select top 100 memberidx,username,userphone from SD_Member.dbo.tblMember  where  username + replace(userphone,'-','') not in (select username + userphone from tblPlayer)"
  'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




SQL = "select top 10 memberidx,username,userphone from SD_Member.dbo.tblMember  where  username + replace(userphone,'-','') not in (select username + userphone from SD_tennis.dbo.tblPlayer)"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


Call rsdrow(rs)

Response.end


'공통사항	
'KATA 참가이력자	SD랭킹대회 대회 참가신청 X
'	
'★랭킹전	
'1회 우승자					SD랭킹포인트 보유 파트너와 페어 X    ---- 신규 참여자만 페어가능하다는 이야기
'2회 우승자					★★랭킹 자동승격 (★랭킹참가신청 X)
'입상자(우승, 준우승, 3위)	입장자와 파트너 X
'준우승, 3위					지속출전 가능
'★★랭킹 자동승격자가			★로 강등시	★랭킹 1회 우승자 조건으로 전환 (SD랭킹포인트 보유 파트너와 페어 X)
'자격박탈자 (전체)				대회현장 조치에 따라 자격박탈 조치 (모든 SD랭킹대회 참가신청 X)
'자격박탈자 (★랭킹)			대회현장 조치에 따라 자격박탈 조치 (★랭킹 참가불가, 단 ★★ 참가신청 가능)
'자격박탈자 (★★랭킹)			-
'	
'★★랭킹전	
'1회 우승자	SD랭킹포인트 보유 파트너와 페어 X
'2회 우승자	SD랭킹대회 출전 X (단, 해당 연도까지는 출전가능)
'입상자(우승, 준우승, 3위)	입장지와 파트너 X
'준우승, 3위	지속출전 가능
'★랭킹 -> ★★승격자 : 2회 이상 예선탈락	★랭킹으로 강등 (★★랭킹 참가신청 X / ★랭킹에 참가신청 가능)
'자격박탈자 (전체)	대회현장 조치에 따라 자격박탈 조치 (모든 SD랭킹대회 참가신청 X)
'자격박탈자 (★랭킹)	 -
'자격박탈자 (★★랭킹)	대회현장 조치에 따라 자격박탈 조치 (★★랭킹 참가불가, 단 ★ 참가신청 가능)

'
'사유
'
'deprivation 
'
'0	'기본
'1	' ★		참가불가
'2	' ★★	참가불가
'3	' 모두 출전불가
'4  ' 1등 1회
'5  ' 2등 2회 박탈
'
'나의 상태 
'1 ★우승 1회
'2 ★우승 2회 (승격)
'3 ★입상자  (우승, 준우승, 3위자와 파트너 안됨 )
'4 자격박탈 (사유)
'
'5 ★ 자격박탈
'1 ★★우승 1회
'2 ★★우승 2회 (당해년도까지 출전가능)
'3 ★★입상자  (우승, 준우승, 3위자와 파트너 안됨 )
'4 자격박탈 (사유)
'5 ★ 자격박탈
'
'
'0 기본
'1 우승 1회
'2 우승 2회 
'
'
'
'
'파트너의 상태




'SQL = "select username ,userphone from SD_tennis.dbo.tblPlayer where username = '' and userphone = '' "

'KATA 선수는 참가신청불가 

'Call rsdrow(rs)


%>