<!--#include virtual="/Manager/Library/config.asp"-->
<%
	GameTitleIDX  = fInject(Request("GameTitleIDX"))
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	Level         = fInject(Request("Level"))
	TeamGb        = fInject(Request("TeamGb"))
	Sex           = fInject(Request("Sex"))
	TotRound      = fInject(Request("TotRound"))
	pair_cnt      = fInject(Request("pair_cnt"))
	R2_Cnt        = fInject(Request("R2_Cnt"))
	R3_Cnt        = fInject(Request("R3_Cnt"))
	R4_Cnt        = fInject(Request("R4_Cnt"))
	R5_Cnt        = fInject(Request("R5_Cnt"))
	R6_Cnt        = fInject(Request("R6_Cnt"))

	'대회 강수 TotRound
'	Response.Write GameTitleIDX&"<br>"
'	Response.Write RGameLevelIDX&"<br>"
'	Response.Write TotRound&"<br>"
'	Response.Write pair_cnt&"<br>"
'	Response.Write R2_Cnt&"<br>"
'	Response.Write R3_Cnt&"<br>"
'	Response.Write R4_Cnt&"<br>"
'	Response.Write R5_Cnt&"<br>"
'	Response.Write R6_Cnt&"<br>"


	Player1  = fInject(Request("Player1"))
	Player2  = fInject(Request("Player2"))
	Player3  = fInject(Request("Player3"))
	Player4  = fInject(Request("Player4"))
	Player5  = fInject(Request("Player5"))
	Player6  = fInject(Request("Player6"))
	Player7  = fInject(Request("Player7"))
	Player8  = fInject(Request("Player8"))
	Player9  = fInject(Request("Player9"))
	Player10 = fInject(Request("Player10"))
	Player11 = fInject(Request("Player11"))
	Player12 = fInject(Request("Player12"))
	Player13 = fInject(Request("Player13"))
	Player14 = fInject(Request("Player14"))
	Player15 = fInject(Request("Player15"))
	Player16 = fInject(Request("Player16"))
	Player17 = fInject(Request("Player17"))
	Player18 = fInject(Request("Player18"))
	Player19 = fInject(Request("Player19"))
	Player20 = fInject(Request("Player20"))
	Player21 = fInject(Request("Player21"))
	Player22 = fInject(Request("Player22"))
	Player23 = fInject(Request("Player23"))
	Player24 = fInject(Request("Player24"))
	Player25 = fInject(Request("Player25"))
	Player26 = fInject(Request("Player26"))
	Player27 = fInject(Request("Player27"))
	Player28 = fInject(Request("Player28"))
	Player29 = fInject(Request("Player29"))
	Player30 = fInject(Request("Player30"))
	Player31 = fInject(Request("Player31"))
	Player32 = fInject(Request("Player32"))
	Player33 = fInject(Request("Player33"))
	Player34 = fInject(Request("Player34"))
	Player35 = fInject(Request("Player35"))
	Player36 = fInject(Request("Player36"))
	Player37 = fInject(Request("Player37"))
	Player38 = fInject(Request("Player38"))
	Player39 = fInject(Request("Player39"))
	Player40 = fInject(Request("Player40"))
	Player41 = fInject(Request("Player41"))
	Player42 = fInject(Request("Player42"))
	Player43 = fInject(Request("Player43"))
	Player44 = fInject(Request("Player44"))
	Player45 = fInject(Request("Player45"))
	Player46 = fInject(Request("Player46"))
	Player47 = fInject(Request("Player47"))
	Player48 = fInject(Request("Player48"))
	Player49 = fInject(Request("Player49"))
	Player50 = fInject(Request("Player50"))
	Player51 = fInject(Request("Player51"))
	Player52 = fInject(Request("Player52"))
	Player53 = fInject(Request("Player53"))
	Player54 = fInject(Request("Player54"))
	Player55 = fInject(Request("Player55"))
	Player56 = fInject(Request("Player56"))
	Player57 = fInject(Request("Player57"))
	Player58 = fInject(Request("Player58"))
	Player59 = fInject(Request("Player59"))
	Player60 = fInject(Request("Player60"))
	Player61 = fInject(Request("Player61"))
	Player62 = fInject(Request("Player62"))
	Player63 = fInject(Request("Player63"))
	Player64 = fInject(Request("Player64"))


	Player65  = fInject(Request("Player65"))
	Player66  = fInject(Request("Player66"))
	Player67  = fInject(Request("Player67"))
	Player68  = fInject(Request("Player68"))
	Player69  = fInject(Request("Player69"))
	Player70  = fInject(Request("Player70"))
	Player71  = fInject(Request("Player71"))
	Player72  = fInject(Request("Player72"))
	Player73  = fInject(Request("Player73"))
	Player74  = fInject(Request("Player74"))
	Player75  = fInject(Request("Player75"))
	Player76  = fInject(Request("Player76"))
	Player77  = fInject(Request("Player77"))
	Player78  = fInject(Request("Player78"))
	Player79  = fInject(Request("Player79"))
	Player80  = fInject(Request("Player80"))
	Player81  = fInject(Request("Player81"))
	Player82  = fInject(Request("Player82"))
	Player83  = fInject(Request("Player83"))
	Player84  = fInject(Request("Player84"))
	Player85  = fInject(Request("Player85"))
	Player86  = fInject(Request("Player86"))
	Player87  = fInject(Request("Player87"))
	Player88  = fInject(Request("Player88"))
	Player89  = fInject(Request("Player89"))
	Player90  = fInject(Request("Player90"))
	Player91  = fInject(Request("Player91"))
	Player92  = fInject(Request("Player92"))
	Player93  = fInject(Request("Player93"))
	Player94  = fInject(Request("Player94"))
	Player95  = fInject(Request("Player95"))
	Player96  = fInject(Request("Player96"))
	Player97  = fInject(Request("Player97"))
	Player98  = fInject(Request("Player98"))
	Player99  = fInject(Request("Player99"))
	Player100 = fInject(Request("Player100"))
	Player101 = fInject(Request("Player101"))
	Player102 = fInject(Request("Player102"))
	Player103 = fInject(Request("Player103"))
	Player104 = fInject(Request("Player104"))
	Player105 = fInject(Request("Player105"))
	Player106 = fInject(Request("Player106"))
	Player107 = fInject(Request("Player107"))
	Player108 = fInject(Request("Player108"))
	Player109 = fInject(Request("Player109"))
	Player110 = fInject(Request("Player110"))
	Player111 = fInject(Request("Player111"))
	Player112 = fInject(Request("Player112"))
	Player113 = fInject(Request("Player113"))
	Player114 = fInject(Request("Player114"))
	Player115 = fInject(Request("Player115"))
	Player116 = fInject(Request("Player116"))
	Player117 = fInject(Request("Player117"))
	Player118 = fInject(Request("Player118"))
	Player119 = fInject(Request("Player119"))
	Player120 = fInject(Request("Player120"))
	Player121 = fInject(Request("Player121"))
	Player122 = fInject(Request("Player122"))
	Player123 = fInject(Request("Player123"))
	Player124 = fInject(Request("Player124"))
	Player125 = fInject(Request("Player125"))
	Player126 = fInject(Request("Player126"))
	Player127 = fInject(Request("Player127"))
	Player128 = fInject(Request("Player128"))




	Hidden_Data1  = fInject(Request("Hidden_Data1"))
	Hidden_Data2  = fInject(Request("Hidden_Data2"))
	Hidden_Data3  = fInject(Request("Hidden_Data3"))
	Hidden_Data4  = fInject(Request("Hidden_Data4"))
	Hidden_Data5  = fInject(Request("Hidden_Data5"))
	Hidden_Data6  = fInject(Request("Hidden_Data6"))
	Hidden_Data7  = fInject(Request("Hidden_Data7"))
	Hidden_Data8  = fInject(Request("Hidden_Data8"))
	Hidden_Data9  = fInject(Request("Hidden_Data9"))
	Hidden_Data10 = fInject(Request("Hidden_Data10"))
	Hidden_Data11 = fInject(Request("Hidden_Data11"))
	Hidden_Data12 = fInject(Request("Hidden_Data12"))
	Hidden_Data13 = fInject(Request("Hidden_Data13"))
	Hidden_Data14 = fInject(Request("Hidden_Data14"))
	Hidden_Data15 = fInject(Request("Hidden_Data15"))
	Hidden_Data16 = fInject(Request("Hidden_Data16"))
	Hidden_Data17 = fInject(Request("Hidden_Data17"))
	Hidden_Data18 = fInject(Request("Hidden_Data18"))
	Hidden_Data19 = fInject(Request("Hidden_Data19"))
	Hidden_Data20 = fInject(Request("Hidden_Data20"))
	Hidden_Data21 = fInject(Request("Hidden_Data21"))
	Hidden_Data22 = fInject(Request("Hidden_Data22"))
	Hidden_Data23 = fInject(Request("Hidden_Data23"))
	Hidden_Data24 = fInject(Request("Hidden_Data24"))
	Hidden_Data25 = fInject(Request("Hidden_Data25"))
	Hidden_Data26 = fInject(Request("Hidden_Data26"))
	Hidden_Data27 = fInject(Request("Hidden_Data27"))
	Hidden_Data28 = fInject(Request("Hidden_Data28"))
	Hidden_Data29 = fInject(Request("Hidden_Data29"))
	Hidden_Data30 = fInject(Request("Hidden_Data30"))
	Hidden_Data31 = fInject(Request("Hidden_Data31"))
	Hidden_Data32 = fInject(Request("Hidden_Data32"))
	Hidden_Data33 = fInject(Request("Hidden_Data33"))
	Hidden_Data34 = fInject(Request("Hidden_Data34"))
	Hidden_Data35 = fInject(Request("Hidden_Data35"))
	Hidden_Data36 = fInject(Request("Hidden_Data36"))
	Hidden_Data37 = fInject(Request("Hidden_Data37"))
	Hidden_Data38 = fInject(Request("Hidden_Data38"))
	Hidden_Data39 = fInject(Request("Hidden_Data39"))
	Hidden_Data40 = fInject(Request("Hidden_Data40"))
	Hidden_Data41 = fInject(Request("Hidden_Data41"))
	Hidden_Data42 = fInject(Request("Hidden_Data42"))
	Hidden_Data43 = fInject(Request("Hidden_Data43"))
	Hidden_Data44 = fInject(Request("Hidden_Data44"))
	Hidden_Data45 = fInject(Request("Hidden_Data45"))
	Hidden_Data46 = fInject(Request("Hidden_Data46"))
	Hidden_Data47 = fInject(Request("Hidden_Data47"))
	Hidden_Data48 = fInject(Request("Hidden_Data48"))
	Hidden_Data49 = fInject(Request("Hidden_Data49"))
	Hidden_Data50 = fInject(Request("Hidden_Data50"))
	Hidden_Data51 = fInject(Request("Hidden_Data51"))
	Hidden_Data52 = fInject(Request("Hidden_Data52"))
	Hidden_Data53 = fInject(Request("Hidden_Data53"))
	Hidden_Data54 = fInject(Request("Hidden_Data54"))
	Hidden_Data55 = fInject(Request("Hidden_Data55"))
	Hidden_Data56 = fInject(Request("Hidden_Data56"))
	Hidden_Data57 = fInject(Request("Hidden_Data57"))
	Hidden_Data58 = fInject(Request("Hidden_Data58"))
	Hidden_Data59 = fInject(Request("Hidden_Data59"))
	Hidden_Data60 = fInject(Request("Hidden_Data60"))
	Hidden_Data61 = fInject(Request("Hidden_Data61"))
	Hidden_Data62 = fInject(Request("Hidden_Data62"))
	Hidden_Data63 = fInject(Request("Hidden_Data63"))
	Hidden_Data64 = fInject(Request("Hidden_Data64"))

	Hidden_Data65  = fInject(Request("Hidden_Data65"))
	Hidden_Data66  = fInject(Request("Hidden_Data66"))
	Hidden_Data67  = fInject(Request("Hidden_Data67"))
	Hidden_Data68  = fInject(Request("Hidden_Data68"))
	Hidden_Data69  = fInject(Request("Hidden_Data69"))
	Hidden_Data70  = fInject(Request("Hidden_Data70"))
	Hidden_Data71  = fInject(Request("Hidden_Data71"))
	Hidden_Data72  = fInject(Request("Hidden_Data72"))
	Hidden_Data73  = fInject(Request("Hidden_Data73"))
	Hidden_Data74  = fInject(Request("Hidden_Data74"))
	Hidden_Data75  = fInject(Request("Hidden_Data75"))
	Hidden_Data76  = fInject(Request("Hidden_Data76"))
	Hidden_Data77  = fInject(Request("Hidden_Data77"))
	Hidden_Data78  = fInject(Request("Hidden_Data78"))
	Hidden_Data79  = fInject(Request("Hidden_Data79"))
	Hidden_Data80  = fInject(Request("Hidden_Data80"))
	Hidden_Data81  = fInject(Request("Hidden_Data81"))
	Hidden_Data82  = fInject(Request("Hidden_Data82"))
	Hidden_Data83  = fInject(Request("Hidden_Data83"))
	Hidden_Data84  = fInject(Request("Hidden_Data84"))
	Hidden_Data85  = fInject(Request("Hidden_Data85"))
	Hidden_Data86  = fInject(Request("Hidden_Data86"))
	Hidden_Data87  = fInject(Request("Hidden_Data87"))
	Hidden_Data88  = fInject(Request("Hidden_Data88"))
	Hidden_Data89  = fInject(Request("Hidden_Data89"))
	Hidden_Data90  = fInject(Request("Hidden_Data90"))
	Hidden_Data91  = fInject(Request("Hidden_Data91"))
	Hidden_Data92  = fInject(Request("Hidden_Data92"))
	Hidden_Data93  = fInject(Request("Hidden_Data93"))
	Hidden_Data94  = fInject(Request("Hidden_Data94"))
	Hidden_Data95  = fInject(Request("Hidden_Data95"))
	Hidden_Data96  = fInject(Request("Hidden_Data96"))
	Hidden_Data97  = fInject(Request("Hidden_Data97"))
	Hidden_Data98  = fInject(Request("Hidden_Data98"))
	Hidden_Data99  = fInject(Request("Hidden_Data99"))
	Hidden_Data100 = fInject(Request("Hidden_Data100"))
	Hidden_Data101 = fInject(Request("Hidden_Data101"))
	Hidden_Data102 = fInject(Request("Hidden_Data102"))
	Hidden_Data103 = fInject(Request("Hidden_Data103"))
	Hidden_Data104 = fInject(Request("Hidden_Data104"))
	Hidden_Data105 = fInject(Request("Hidden_Data105"))
	Hidden_Data106 = fInject(Request("Hidden_Data106"))
	Hidden_Data107 = fInject(Request("Hidden_Data107"))
	Hidden_Data108 = fInject(Request("Hidden_Data108"))
	Hidden_Data109 = fInject(Request("Hidden_Data109"))
	Hidden_Data110 = fInject(Request("Hidden_Data110"))
	Hidden_Data111 = fInject(Request("Hidden_Data111"))
	Hidden_Data112 = fInject(Request("Hidden_Data112"))
	Hidden_Data113 = fInject(Request("Hidden_Data113"))
	Hidden_Data114 = fInject(Request("Hidden_Data114"))
	Hidden_Data115 = fInject(Request("Hidden_Data115"))
	Hidden_Data116 = fInject(Request("Hidden_Data116"))
	Hidden_Data117 = fInject(Request("Hidden_Data117"))
	Hidden_Data118 = fInject(Request("Hidden_Data118"))
	Hidden_Data119 = fInject(Request("Hidden_Data119"))
	Hidden_Data120 = fInject(Request("Hidden_Data120"))
	Hidden_Data121 = fInject(Request("Hidden_Data121"))
	Hidden_Data122 = fInject(Request("Hidden_Data122"))
	Hidden_Data123 = fInject(Request("Hidden_Data123"))
	Hidden_Data124 = fInject(Request("Hidden_Data124"))
	Hidden_Data125 = fInject(Request("Hidden_Data125"))
	Hidden_Data126 = fInject(Request("Hidden_Data126"))
	Hidden_Data127 = fInject(Request("Hidden_Data127"))
	Hidden_Data128 = fInject(Request("Hidden_Data128"))


	R1_Num1   = fInject(Request("R1_Num1"))
	R1_Num2   = fInject(Request("R1_Num2"))
	R1_Num3   = fInject(Request("R1_Num3"))
	R1_Num4   = fInject(Request("R1_Num4"))
	R1_Num5   = fInject(Request("R1_Num5"))
	R1_Num6   = fInject(Request("R1_Num6"))
	R1_Num7   = fInject(Request("R1_Num7"))
	R1_Num8   = fInject(Request("R1_Num8"))
	R1_Num9   = fInject(Request("R1_Num9"))
	R1_Num10  = fInject(Request("R1_Num10"))
	R1_Num11  = fInject(Request("R1_Num11"))
	R1_Num12  = fInject(Request("R1_Num12"))
	R1_Num13  = fInject(Request("R1_Num13"))
	R1_Num14  = fInject(Request("R1_Num14"))
	R1_Num15  = fInject(Request("R1_Num15"))
	R1_Num16  = fInject(Request("R1_Num16"))
	R1_Num17  = fInject(Request("R1_Num17"))
	R1_Num18  = fInject(Request("R1_Num18"))
	R1_Num19  = fInject(Request("R1_Num19"))
	R1_Num20  = fInject(Request("R1_Num20"))
	R1_Num21  = fInject(Request("R1_Num21"))
	R1_Num22  = fInject(Request("R1_Num22"))
	R1_Num23  = fInject(Request("R1_Num23"))
	R1_Num24  = fInject(Request("R1_Num24"))
	R1_Num25  = fInject(Request("R1_Num25"))
	R1_Num26  = fInject(Request("R1_Num26"))
	R1_Num27  = fInject(Request("R1_Num27"))
	R1_Num28  = fInject(Request("R1_Num28"))
	R1_Num29  = fInject(Request("R1_Num29"))
	R1_Num30  = fInject(Request("R1_Num30"))
	R1_Num31  = fInject(Request("R1_Num31"))
	R1_Num32  = fInject(Request("R1_Num32"))
	R1_Num33  = fInject(Request("R1_Num33"))
	R1_Num34  = fInject(Request("R1_Num34"))
	R1_Num35  = fInject(Request("R1_Num35"))
	R1_Num36  = fInject(Request("R1_Num36"))
	R1_Num37  = fInject(Request("R1_Num37"))
	R1_Num38  = fInject(Request("R1_Num38"))
	R1_Num39  = fInject(Request("R1_Num39"))
	R1_Num40  = fInject(Request("R1_Num40"))
	R1_Num41  = fInject(Request("R1_Num41"))
	R1_Num42  = fInject(Request("R1_Num42"))
	R1_Num43  = fInject(Request("R1_Num43"))
	R1_Num44  = fInject(Request("R1_Num44"))
	R1_Num45  = fInject(Request("R1_Num45"))
	R1_Num46  = fInject(Request("R1_Num46"))
	R1_Num47  = fInject(Request("R1_Num47"))
	R1_Num48  = fInject(Request("R1_Num48"))
	R1_Num49  = fInject(Request("R1_Num49"))
	R1_Num50  = fInject(Request("R1_Num50"))
	R1_Num51  = fInject(Request("R1_Num51"))
	R1_Num52  = fInject(Request("R1_Num52"))
	R1_Num53  = fInject(Request("R1_Num53"))
	R1_Num54  = fInject(Request("R1_Num54"))
	R1_Num55  = fInject(Request("R1_Num55"))
	R1_Num56  = fInject(Request("R1_Num56"))
	R1_Num57  = fInject(Request("R1_Num57"))
	R1_Num58  = fInject(Request("R1_Num58"))
	R1_Num59  = fInject(Request("R1_Num59"))
	R1_Num60  = fInject(Request("R1_Num60"))
	R1_Num61  = fInject(Request("R1_Num61"))
	R1_Num62  = fInject(Request("R1_Num62"))
	R1_Num63  = fInject(Request("R1_Num63"))
	R1_Num64  = fInject(Request("R1_Num64"))
	


	R2_Num1   = fInject(Request("R2_Num1"))
	R2_Num2   = fInject(Request("R2_Num2"))
	R2_Num3   = fInject(Request("R2_Num3"))
	R2_Num4   = fInject(Request("R2_Num4"))
	R2_Num5   = fInject(Request("R2_Num5"))
	R2_Num6   = fInject(Request("R2_Num6"))
	R2_Num7   = fInject(Request("R2_Num7"))
	R2_Num8   = fInject(Request("R2_Num8"))
	R2_Num9   = fInject(Request("R2_Num9"))
	R2_Num10  = fInject(Request("R2_Num10"))
	R2_Num11  = fInject(Request("R2_Num11"))
	R2_Num12  = fInject(Request("R2_Num12"))
	R2_Num13  = fInject(Request("R2_Num13"))
	R2_Num14  = fInject(Request("R2_Num14"))
	R2_Num15  = fInject(Request("R2_Num15"))
	R2_Num16  = fInject(Request("R2_Num16"))
	R2_Num17  = fInject(Request("R2_Num17"))
	R2_Num18  = fInject(Request("R2_Num18"))
	R2_Num19  = fInject(Request("R2_Num19"))
	R2_Num20  = fInject(Request("R2_Num20"))
	R2_Num21  = fInject(Request("R2_Num21"))
	R2_Num22  = fInject(Request("R2_Num22"))
	R2_Num23  = fInject(Request("R2_Num23"))
	R2_Num24  = fInject(Request("R2_Num24"))
	R2_Num25  = fInject(Request("R2_Num25"))
	R2_Num26  = fInject(Request("R2_Num26"))
	R2_Num27  = fInject(Request("R2_Num27"))
	R2_Num28  = fInject(Request("R2_Num28"))
	R2_Num29  = fInject(Request("R2_Num29"))
	R2_Num30  = fInject(Request("R2_Num30"))
	R2_Num31  = fInject(Request("R2_Num31"))
	R2_Num32  = fInject(Request("R2_Num32"))


	R3_Num1  = fInject(Request("R3_Num1"))
	R3_Num2  = fInject(Request("R3_Num2"))
	R3_Num3  = fInject(Request("R3_Num3"))
	R3_Num4  = fInject(Request("R3_Num4"))
	R3_Num5  = fInject(Request("R3_Num5"))
	R3_Num6  = fInject(Request("R3_Num6"))
	R3_Num7  = fInject(Request("R3_Num7"))
	R3_Num8  = fInject(Request("R3_Num8"))
	R3_Num9  = fInject(Request("R3_Num9"))
	R3_Num10  = fInject(Request("R3_Num10"))
	R3_Num11  = fInject(Request("R3_Num11"))
	R3_Num12  = fInject(Request("R3_Num12"))
	R3_Num13  = fInject(Request("R3_Num13"))
	R3_Num14  = fInject(Request("R3_Num14"))
	R3_Num15  = fInject(Request("R3_Num15"))
	R3_Num16  = fInject(Request("R3_Num16"))



	R4_Num1  = fInject(Request("R4_Num1"))
	R4_Num2  = fInject(Request("R4_Num2"))
	R4_Num3  = fInject(Request("R4_Num3"))
	R4_Num4  = fInject(Request("R4_Num4"))
	R4_Num5  = fInject(Request("R4_Num5"))
	R4_Num6  = fInject(Request("R4_Num6"))
	R4_Num7  = fInject(Request("R4_Num7"))
	R4_Num8  = fInject(Request("R4_Num8"))


	R5_Num1  = fInject(Request("R5_Num1"))
	R5_Num2  = fInject(Request("R5_Num2"))
	R5_Num3  = fInject(Request("R5_Num3"))
	R5_Num4  = fInject(Request("R5_Num4"))


	R6_Num1  = fInject(Request("R6_Num1"))
	R6_Num2  = fInject(Request("R6_Num2"))

	R7_Num1  = R6_Num2+1





	'Response.Write Hidden_Data1&"<br>"


	'기존 데이터 체크
	ChkSQL = "SELECT "
	ChkSQL = ChkSQL&" Count(RPlayerIDX) AS Cnt"
	ChkSQL = ChkSQL&" From Sportsdiary.dbo.tblRPlayer"
	ChkSQL = ChkSQL&" Where GameTitleIDX='"&GameTitleIDX&"'"
	ChkSQL = ChkSQL&" AND RGameLevelidx='"&RGameLevelidx&"'"
	Set CRs = Dbcon.Execute(chkSQL)

	If CRs("Cnt") > 0 Then 
		DelSQL = "Delete From tblRPlayer Where GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelidx&"'"
		Dbcon.Execute(DelSQL)			
	End If 




	'sd042001 일반전 sd042002 부전승
	'왼쪽오른쪽 sd030001 왼 sd030002 오
	'개인전 'sd040001' 단체전 sd040002

	'=========================================================  왼쪽데이터 ===============================================================================	
	'=========================================================  왼쪽데이터 ===============================================================================
	'=========================================================  왼쪽데이터 ===============================================================================
	If Hidden_Data1 <> "" And Hidden_Data2 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data1&"','judo','"&GameTitleIDX&"','','"&Player1&"','"&Level&"','"&TeamGb&"','"&Sex&"','101','sd042001','sd030001','0','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data2&"','judo','"&GameTitleIDX&"','','"&Player2&"','"&Level&"','"&TeamGb&"','"&Sex&"','102','sd042001','sd030001','0','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data1&"','judo','"&GameTitleIDX&"','','"&Player1&"','"&Level&"','"&TeamGb&"','"&Sex&"','101','sd042002','sd030001','0','"&R1_Num1&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data3 <> "" And Hidden_Data4 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data3&"','judo','"&GameTitleIDX&"','','"&Player3&"','"&Level&"','"&TeamGb&"','"&Sex&"','103','sd042001','sd030001','0','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data4&"','judo','"&GameTitleIDX&"','','"&Player4&"','"&Level&"','"&TeamGb&"','"&Sex&"','104','sd042001','sd030001','0','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data3&"','judo','"&GameTitleIDX&"','','"&Player3&"','"&Level&"','"&TeamGb&"','"&Sex&"','103','sd042002','sd030001','0','"&R1_Num2&"','"&R2_Num1&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data5 <> "" And Hidden_Data6 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data5&"','judo','"&GameTitleIDX&"','','"&Player5&"','"&Level&"','"&TeamGb&"','"&Sex&"','105','sd042001','sd030001','0','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data6&"','judo','"&GameTitleIDX&"','','"&Player6&"','"&Level&"','"&TeamGb&"','"&Sex&"','106','sd042001','sd030001','0','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data5&"','judo','"&GameTitleIDX&"','','"&Player5&"','"&Level&"','"&TeamGb&"','"&Sex&"','105','sd042002','sd030001','0','"&R1_Num3&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data7 <> "" And Hidden_Data8 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data7&"','judo','"&GameTitleIDX&"','','"&Player7&"','"&Level&"','"&TeamGb&"','"&Sex&"','107','sd042001','sd030001','0','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data8&"','judo','"&GameTitleIDX&"','','"&Player8&"','"&Level&"','"&TeamGb&"','"&Sex&"','108','sd042001','sd030001','0','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data7&"','judo','"&GameTitleIDX&"','','"&Player7&"','"&Level&"','"&TeamGb&"','"&Sex&"','107','sd042002','sd030001','0','"&R1_Num4&"','"&R2_Num2&"','"&R3_Num1&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data9 <> "" And Hidden_Data10 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data9&"','judo','"&GameTitleIDX&"','','"&Player9&"','"&Level&"','"&TeamGb&"','"&Sex&"','109','sd042001','sd030001','0','"&R1_Num5&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data10&"','judo','"&GameTitleIDX&"','','"&Player10&"','"&Level&"','"&TeamGb&"','"&Sex&"','110','sd042001','sd030001','0','"&R1_Num5&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data9&"','judo','"&GameTitleIDX&"','','"&Player9&"','"&Level&"','"&TeamGb&"','"&Sex&"','109','sd042002','sd030001','0','"&R1_Num5&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data11 <> "" And Hidden_Data12 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data11&"','judo','"&GameTitleIDX&"','','"&Player11&"','"&Level&"','"&TeamGb&"','"&Sex&"','111','sd042001','sd030001','0','"&R1_Num6&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data12&"','judo','"&GameTitleIDX&"','','"&Player12&"','"&Level&"','"&TeamGb&"','"&Sex&"','112','sd042001','sd030001','0','"&R1_Num6&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data11&"','judo','"&GameTitleIDX&"','','"&Player11&"','"&Level&"','"&TeamGb&"','"&Sex&"','111','sd042002','sd030001','0','"&R1_Num6&"','"&R2_Num3&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data13 <> "" And Hidden_Data14 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data13&"','judo','"&GameTitleIDX&"','','"&Player13&"','"&Level&"','"&TeamGb&"','"&Sex&"','113','sd042001','sd030001','0','"&R1_Num7&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data14&"','judo','"&GameTitleIDX&"','','"&Player14&"','"&Level&"','"&TeamGb&"','"&Sex&"','114','sd042001','sd030001','0','"&R1_Num7&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data13&"','judo','"&GameTitleIDX&"','','"&Player13&"','"&Level&"','"&TeamGb&"','"&Sex&"','113','sd042002','sd030001','0','"&R1_Num7&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data15 <> "" And Hidden_Data16 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data15&"','judo','"&GameTitleIDX&"','','"&Player15&"','"&Level&"','"&TeamGb&"','"&Sex&"','115','sd042001','sd030001','0','"&R1_Num8&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data16&"','judo','"&GameTitleIDX&"','','"&Player16&"','"&Level&"','"&TeamGb&"','"&Sex&"','116','sd042001','sd030001','0','"&R1_Num8&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data15&"','judo','"&GameTitleIDX&"','','"&Player15&"','"&Level&"','"&TeamGb&"','"&Sex&"','115','sd042002','sd030001','0','"&R1_Num8&"','"&R2_Num4&"','"&R3_Num2&"','"&R4_Num1&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 	

	If Hidden_Data17 <> "" And Hidden_Data18 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data17&"','judo','"&GameTitleIDX&"','','"&Player17&"','"&Level&"','"&TeamGb&"','"&Sex&"','117','sd042001','sd030001','0','"&R1_Num9&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data18&"','judo','"&GameTitleIDX&"','','"&Player18&"','"&Level&"','"&TeamGb&"','"&Sex&"','118','sd042001','sd030001','0','"&R1_Num9&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data17&"','judo','"&GameTitleIDX&"','','"&Player17&"','"&Level&"','"&TeamGb&"','"&Sex&"','117','sd042002','sd030001','0','"&R1_Num9&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data19 <> "" And Hidden_Data20 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data19&"','judo','"&GameTitleIDX&"','','"&Player19&"','"&Level&"','"&TeamGb&"','"&Sex&"','119','sd042001','sd030001','0','"&R1_Num10&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data20&"','judo','"&GameTitleIDX&"','','"&Player20&"','"&Level&"','"&TeamGb&"','"&Sex&"','120','sd042001','sd030001','0','"&R1_Num10&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data19&"','judo','"&GameTitleIDX&"','','"&Player19&"','"&Level&"','"&TeamGb&"','"&Sex&"','119','sd042002','sd030001','0','"&R1_Num10&"','"&R2_Num5&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data21 <> "" And Hidden_Data22 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data21&"','judo','"&GameTitleIDX&"','','"&Player21&"','"&Level&"','"&TeamGb&"','"&Sex&"','121','sd042001','sd030001','0','"&R1_Num11&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data22&"','judo','"&GameTitleIDX&"','','"&Player22&"','"&Level&"','"&TeamGb&"','"&Sex&"','122','sd042001','sd030001','0','"&R1_Num11&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data21&"','judo','"&GameTitleIDX&"','','"&Player21&"','"&Level&"','"&TeamGb&"','"&Sex&"','121','sd042002','sd030001','0','"&R1_Num11&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data23 <> "" And Hidden_Data24 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data23&"','judo','"&GameTitleIDX&"','','"&Player23&"','"&Level&"','"&TeamGb&"','"&Sex&"','123','sd042001','sd030001','0','"&R1_Num12&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data24&"','judo','"&GameTitleIDX&"','','"&Player24&"','"&Level&"','"&TeamGb&"','"&Sex&"','124','sd042001','sd030001','0','"&R1_Num12&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data23&"','judo','"&GameTitleIDX&"','','"&Player23&"','"&Level&"','"&TeamGb&"','"&Sex&"','123','sd042002','sd030001','0','"&R1_Num12&"','"&R2_Num6&"','"&R3_Num3&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data25 <> "" And Hidden_Data26 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data25&"','judo','"&GameTitleIDX&"','','"&Player25&"','"&Level&"','"&TeamGb&"','"&Sex&"','125','sd042001','sd030001','0','"&R1_Num13&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data26&"','judo','"&GameTitleIDX&"','','"&Player26&"','"&Level&"','"&TeamGb&"','"&Sex&"','126','sd042001','sd030001','0','"&R1_Num13&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data25&"','judo','"&GameTitleIDX&"','','"&Player25&"','"&Level&"','"&TeamGb&"','"&Sex&"','125','sd042002','sd030001','0','"&R1_Num13&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data27 <> "" And Hidden_Data28 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data27&"','judo','"&GameTitleIDX&"','','"&Player27&"','"&Level&"','"&TeamGb&"','"&Sex&"','127','sd042001','sd030001','0','"&R1_Num14&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data28&"','judo','"&GameTitleIDX&"','','"&Player28&"','"&Level&"','"&TeamGb&"','"&Sex&"','128','sd042001','sd030001','0','"&R1_Num14&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data27&"','judo','"&GameTitleIDX&"','','"&Player27&"','"&Level&"','"&TeamGb&"','"&Sex&"','127','sd042002','sd030001','0','"&R1_Num14&"','"&R2_Num7&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data29 <> "" And Hidden_Data30 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data29&"','judo','"&GameTitleIDX&"','','"&Player29&"','"&Level&"','"&TeamGb&"','"&Sex&"','129','sd042001','sd030001','0','"&R1_Num15&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data30&"','judo','"&GameTitleIDX&"','','"&Player30&"','"&Level&"','"&TeamGb&"','"&Sex&"','130','sd042001','sd030001','0','"&R1_Num15&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data29&"','judo','"&GameTitleIDX&"','','"&Player29&"','"&Level&"','"&TeamGb&"','"&Sex&"','129','sd042002','sd030001','0','"&R1_Num15&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data31 <> "" And Hidden_Data32 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data31&"','judo','"&GameTitleIDX&"','','"&Player31&"','"&Level&"','"&TeamGb&"','"&Sex&"','131','sd042001','sd030001','0','"&R1_Num16&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data32&"','judo','"&GameTitleIDX&"','','"&Player32&"','"&Level&"','"&TeamGb&"','"&Sex&"','132','sd042001','sd030001','0','"&R1_Num16&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data31&"','judo','"&GameTitleIDX&"','','"&Player31&"','"&Level&"','"&TeamGb&"','"&Sex&"','131','sd042002','sd030001','0','"&R1_Num16&"','"&R2_Num8&"','"&R3_Num4&"','"&R4_Num2&"','"&R5_Num1&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 	

	If Hidden_Data33 <> "" And Hidden_Data34 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data33&"','judo','"&GameTitleIDX&"','','"&Player33&"','"&Level&"','"&TeamGb&"','"&Sex&"','133','sd042001','sd030001','0','"&R1_Num17&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data34&"','judo','"&GameTitleIDX&"','','"&Player34&"','"&Level&"','"&TeamGb&"','"&Sex&"','134','sd042001','sd030001','0','"&R1_Num17&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data33&"','judo','"&GameTitleIDX&"','','"&Player33&"','"&Level&"','"&TeamGb&"','"&Sex&"','133','sd042002','sd030001','0','"&R1_Num17&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data35 <> "" And Hidden_Data36 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data35&"','judo','"&GameTitleIDX&"','','"&Player35&"','"&Level&"','"&TeamGb&"','"&Sex&"','135','sd042001','sd030001','0','"&R1_Num18&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data36&"','judo','"&GameTitleIDX&"','','"&Player36&"','"&Level&"','"&TeamGb&"','"&Sex&"','136','sd042001','sd030001','0','"&R1_Num18&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data35&"','judo','"&GameTitleIDX&"','','"&Player35&"','"&Level&"','"&TeamGb&"','"&Sex&"','135','sd042002','sd030001','0','"&R1_Num18&"','"&R2_Num9&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data37 <> "" And Hidden_Data38 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data37&"','judo','"&GameTitleIDX&"','','"&Player37&"','"&Level&"','"&TeamGb&"','"&Sex&"','137','sd042001','sd030001','0','"&R1_Num19&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data38&"','judo','"&GameTitleIDX&"','','"&Player38&"','"&Level&"','"&TeamGb&"','"&Sex&"','138','sd042001','sd030001','0','"&R1_Num19&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data37&"','judo','"&GameTitleIDX&"','','"&Player37&"','"&Level&"','"&TeamGb&"','"&Sex&"','137','sd042002','sd030001','0','"&R1_Num19&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data39 <> "" And Hidden_Data40 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data39&"','judo','"&GameTitleIDX&"','','"&Player39&"','"&Level&"','"&TeamGb&"','"&Sex&"','139','sd042001','sd030001','0','"&R1_Num20&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data40&"','judo','"&GameTitleIDX&"','','"&Player40&"','"&Level&"','"&TeamGb&"','"&Sex&"','140','sd042001','sd030001','0','"&R1_Num20&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data39&"','judo','"&GameTitleIDX&"','','"&Player39&"','"&Level&"','"&TeamGb&"','"&Sex&"','139','sd042002','sd030001','0','"&R1_Num20&"','"&R2_Num10&"','"&R3_Num5&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data41 <> "" And Hidden_Data42 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data41&"','judo','"&GameTitleIDX&"','','"&Player41&"','"&Level&"','"&TeamGb&"','"&Sex&"','141','sd042001','sd030001','0','"&R1_Num21&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data42&"','judo','"&GameTitleIDX&"','','"&Player42&"','"&Level&"','"&TeamGb&"','"&Sex&"','142','sd042001','sd030001','0','"&R1_Num21&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data41&"','judo','"&GameTitleIDX&"','','"&Player41&"','"&Level&"','"&TeamGb&"','"&Sex&"','141','sd042002','sd030001','0','"&R1_Num21&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data43 <> "" And Hidden_Data44 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data43&"','judo','"&GameTitleIDX&"','','"&Player43&"','"&Level&"','"&TeamGb&"','"&Sex&"','143','sd042001','sd030001','0','"&R1_Num22&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data44&"','judo','"&GameTitleIDX&"','','"&Player44&"','"&Level&"','"&TeamGb&"','"&Sex&"','144','sd042001','sd030001','0','"&R1_Num22&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data43&"','judo','"&GameTitleIDX&"','','"&Player43&"','"&Level&"','"&TeamGb&"','"&Sex&"','143','sd042002','sd030001','0','"&R1_Num22&"','"&R2_Num11&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data45 <> "" And Hidden_Data46 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data45&"','judo','"&GameTitleIDX&"','','"&Player45&"','"&Level&"','"&TeamGb&"','"&Sex&"','145','sd042001','sd030001','0','"&R1_Num23&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data46&"','judo','"&GameTitleIDX&"','','"&Player46&"','"&Level&"','"&TeamGb&"','"&Sex&"','146','sd042001','sd030001','0','"&R1_Num23&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data45&"','judo','"&GameTitleIDX&"','','"&Player45&"','"&Level&"','"&TeamGb&"','"&Sex&"','145','sd042002','sd030001','0','"&R1_Num23&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data47 <> "" And Hidden_Data48 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data47&"','judo','"&GameTitleIDX&"','','"&Player47&"','"&Level&"','"&TeamGb&"','"&Sex&"','147','sd042001','sd030001','0','"&R1_Num24&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data48&"','judo','"&GameTitleIDX&"','','"&Player48&"','"&Level&"','"&TeamGb&"','"&Sex&"','148','sd042001','sd030001','0','"&R1_Num24&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data47&"','judo','"&GameTitleIDX&"','','"&Player47&"','"&Level&"','"&TeamGb&"','"&Sex&"','147','sd042002','sd030001','0','"&R1_Num24&"','"&R2_Num12&"','"&R3_Num6&"','"&R4_Num3&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 	

	If Hidden_Data49 <> "" And Hidden_Data50 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data49&"','judo','"&GameTitleIDX&"','','"&Player49&"','"&Level&"','"&TeamGb&"','"&Sex&"','149','sd042001','sd030001','0','"&R1_Num25&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		'Response.Write (InSQL)
		'Response.End
		Dbcon.Execute(InSQL)
		
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data50&"','judo','"&GameTitleIDX&"','','"&Player50&"','"&Level&"','"&TeamGb&"','"&Sex&"','150','sd042001','sd030001','0','"&R1_Num25&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data49&"','judo','"&GameTitleIDX&"','','"&Player49&"','"&Level&"','"&TeamGb&"','"&Sex&"','149','sd042002','sd030001','0','"&R1_Num25&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data51 <> "" And Hidden_Data52 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data51&"','judo','"&GameTitleIDX&"','','"&Player51&"','"&Level&"','"&TeamGb&"','"&Sex&"','151','sd042001','sd030001','0','"&R1_Num26&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data52&"','judo','"&GameTitleIDX&"','','"&Player52&"','"&Level&"','"&TeamGb&"','"&Sex&"','152','sd042001','sd030001','0','"&R1_Num26&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data51&"','judo','"&GameTitleIDX&"','','"&Player51&"','"&Level&"','"&TeamGb&"','"&Sex&"','151','sd042002','sd030001','0','"&R1_Num26&"','"&R2_Num13&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data53 <> "" And Hidden_Data54 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data53&"','judo','"&GameTitleIDX&"','','"&Player53&"','"&Level&"','"&TeamGb&"','"&Sex&"','153','sd042001','sd030001','0','"&R1_Num27&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data54&"','judo','"&GameTitleIDX&"','','"&Player54&"','"&Level&"','"&TeamGb&"','"&Sex&"','154','sd042001','sd030001','0','"&R1_Num27&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data53&"','judo','"&GameTitleIDX&"','','"&Player53&"','"&Level&"','"&TeamGb&"','"&Sex&"','153','sd042002','sd030001','0','"&R1_Num27&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data55 <> "" And Hidden_Data56 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data55&"','judo','"&GameTitleIDX&"','','"&Player55&"','"&Level&"','"&TeamGb&"','"&Sex&"','155','sd042001','sd030001','0','"&R1_Num28&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data56&"','judo','"&GameTitleIDX&"','','"&Player56&"','"&Level&"','"&TeamGb&"','"&Sex&"','156','sd042001','sd030001','0','"&R1_Num28&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data55&"','judo','"&GameTitleIDX&"','','"&Player55&"','"&Level&"','"&TeamGb&"','"&Sex&"','155','sd042002','sd030001','0','"&R1_Num28&"','"&R2_Num14&"','"&R3_Num7&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 


	If Hidden_Data57 <> "" And Hidden_Data58 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data57&"','judo','"&GameTitleIDX&"','','"&Player57&"','"&Level&"','"&TeamGb&"','"&Sex&"','157','sd042001','sd030001','0','"&R1_Num29&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data58&"','judo','"&GameTitleIDX&"','','"&Player58&"','"&Level&"','"&TeamGb&"','"&Sex&"','158','sd042001','sd030001','0','"&R1_Num29&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data57&"','judo','"&GameTitleIDX&"','','"&Player57&"','"&Level&"','"&TeamGb&"','"&Sex&"','157','sd042002','sd030001','0','"&R1_Num29&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	
	If Hidden_Data59 <> "" And Hidden_Data60 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data59&"','judo','"&GameTitleIDX&"','','"&Player59&"','"&Level&"','"&TeamGb&"','"&Sex&"','159','sd042001','sd030001','0','"&R1_Num30&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data60&"','judo','"&GameTitleIDX&"','','"&Player60&"','"&Level&"','"&TeamGb&"','"&Sex&"','160','sd042001','sd030001','0','"&R1_Num30&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data59&"','judo','"&GameTitleIDX&"','','"&Player59&"','"&Level&"','"&TeamGb&"','"&Sex&"','159','sd042002','sd030001','0','"&R1_Num30&"','"&R2_Num15&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 

	If Hidden_Data61 <> "" And Hidden_Data62 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data61&"','judo','"&GameTitleIDX&"','','"&Player61&"','"&Level&"','"&TeamGb&"','"&Sex&"','161','sd042001','sd030001','0','"&R1_Num31&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data62&"','judo','"&GameTitleIDX&"','','"&Player62&"','"&Level&"','"&TeamGb&"','"&Sex&"','162','sd042001','sd030001','0','"&R1_Num31&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data61&"','judo','"&GameTitleIDX&"','','"&Player61&"','"&Level&"','"&TeamGb&"','"&Sex&"','161','sd042002','sd030001','0','"&R1_Num31&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 



	If Hidden_Data63 <> "" And Hidden_Data64 <> "" Then 
		'일반전
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data63&"','judo','"&GameTitleIDX&"','','"&Player63&"','"&Level&"','"&TeamGb&"','"&Sex&"','163','sd042001','sd030001','0','"&R1_Num32&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)

		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data64&"','judo','"&GameTitleIDX&"','','"&Player64&"','"&Level&"','"&TeamGb&"','"&Sex&"','164','sd042001','sd030001','0','"&R1_Num32&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	Else
		'부전승
		InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
		InSQL = InSQL&" VALUES ('"&Hidden_Data63&"','judo','"&GameTitleIDX&"','','"&Player63&"','"&Level&"','"&TeamGb&"','"&Sex&"','163','sd042002','sd030001','0','"&R1_Num32&"','"&R2_Num16&"','"&R3_Num8&"','"&R4_Num4&"','"&R5_Num2&"','"&R6_Num1&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
		Dbcon.Execute(InSQL)
	End If 	
	'=========================================================  왼쪽데이터 ===============================================================================	
	'=========================================================  왼쪽데이터 ===============================================================================
	'=========================================================  왼쪽데이터 ===============================================================================
	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	If Hidden_Data65 <> "" And Hidden_Data66 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data65&"','judo','"&GameTitleIDX&"','','"&Player65&"','"&Level&"','"&TeamGb&"','"&Sex&"','165','sd042001','sd030002','0','"&R1_Num33&"','"&R2_Num17&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			'Response.Write (InSQL)
			'Response.End
			Dbcon.Execute(InSQL)
			
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data66&"','judo','"&GameTitleIDX&"','','"&Player66&"','"&Level&"','"&TeamGb&"','"&Sex&"','166','sd042001','sd030002','0','"&R1_Num33&"','"&R2_Num17&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data65&"','judo','"&GameTitleIDX&"','','"&Player65&"','"&Level&"','"&TeamGb&"','"&Sex&"','165','sd042002','sd030002','0','"&R1_Num33&"','"&R2_Num17&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data67 <> "" And Hidden_Data68 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data67&"','judo','"&GameTitleIDX&"','','"&Player67&"','"&Level&"','"&TeamGb&"','"&Sex&"','167','sd042001','sd030002','0','"&R1_Num34&"','"&R2_Num17&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data68&"','judo','"&GameTitleIDX&"','','"&Player68&"','"&Level&"','"&TeamGb&"','"&Sex&"','168','sd042001','sd030002','0','"&R1_Num34&"','"&R2_Num17&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data67&"','judo','"&GameTitleIDX&"','','"&Player67&"','"&Level&"','"&TeamGb&"','"&Sex&"','167','sd042002','sd030002','0','"&R1_Num34&"','"&R2_Num17&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 



		If Hidden_Data69 <> "" And Hidden_Data70 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data69&"','judo','"&GameTitleIDX&"','','"&Player69&"','"&Level&"','"&TeamGb&"','"&Sex&"','169','sd042001','sd030002','0','"&R1_Num35&"','"&R2_Num18&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data70&"','judo','"&GameTitleIDX&"','','"&Player70&"','"&Level&"','"&TeamGb&"','"&Sex&"','170','sd042001','sd030002','0','"&R1_Num35&"','"&R2_Num18&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data69&"','judo','"&GameTitleIDX&"','','"&Player69&"','"&Level&"','"&TeamGb&"','"&Sex&"','169','sd042002','sd030002','0','"&R1_Num35&"','"&R2_Num18&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data71 <> "" And Hidden_Data72 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data71&"','judo','"&GameTitleIDX&"','','"&Player71&"','"&Level&"','"&TeamGb&"','"&Sex&"','171','sd042001','sd030002','0','"&R1_Num36&"','"&R2_Num18&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data72&"','judo','"&GameTitleIDX&"','','"&Player72&"','"&Level&"','"&TeamGb&"','"&Sex&"','172','sd042001','sd030002','0','"&R1_Num36&"','"&R2_Num18&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data71&"','judo','"&GameTitleIDX&"','','"&Player71&"','"&Level&"','"&TeamGb&"','"&Sex&"','171','sd042002','sd030002','0','"&R1_Num36&"','"&R2_Num18&"','"&R3_Num9&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data73 <> "" And Hidden_Data74 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data73&"','judo','"&GameTitleIDX&"','','"&Player73&"','"&Level&"','"&TeamGb&"','"&Sex&"','173','sd042001','sd030002','0','"&R1_Num37&"','"&R2_Num19&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data74&"','judo','"&GameTitleIDX&"','','"&Player74&"','"&Level&"','"&TeamGb&"','"&Sex&"','174','sd042001','sd030002','0','"&R1_Num37&"','"&R2_Num19&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data73&"','judo','"&GameTitleIDX&"','','"&Player73&"','"&Level&"','"&TeamGb&"','"&Sex&"','173','sd042002','sd030002','0','"&R1_Num37&"','"&R2_Num19&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 

		
		If Hidden_Data75 <> "" And Hidden_Data76 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data75&"','judo','"&GameTitleIDX&"','','"&Player75&"','"&Level&"','"&TeamGb&"','"&Sex&"','175','sd042001','sd030002','0','"&R1_Num38&"','"&R2_Num19&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data76&"','judo','"&GameTitleIDX&"','','"&Player76&"','"&Level&"','"&TeamGb&"','"&Sex&"','176','sd042001','sd030002','0','"&R1_Num38&"','"&R2_Num19&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data75&"','judo','"&GameTitleIDX&"','','"&Player75&"','"&Level&"','"&TeamGb&"','"&Sex&"','175','sd042002','sd030002','0','"&R1_Num38&"','"&R2_Num19&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 

		If Hidden_Data77 <> "" And Hidden_Data78 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data77&"','judo','"&GameTitleIDX&"','','"&Player77&"','"&Level&"','"&TeamGb&"','"&Sex&"','177','sd042001','sd030002','0','"&R1_Num39&"','"&R2_Num20&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data78&"','judo','"&GameTitleIDX&"','','"&Player78&"','"&Level&"','"&TeamGb&"','"&Sex&"','178','sd042001','sd030002','0','"&R1_Num39&"','"&R2_Num20&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data77&"','judo','"&GameTitleIDX&"','','"&Player77&"','"&Level&"','"&TeamGb&"','"&Sex&"','177','sd042002','sd030002','0','"&R1_Num39&"','"&R2_Num20&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 



		If Hidden_Data79 <> "" And Hidden_Data80 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data79&"','judo','"&GameTitleIDX&"','','"&Player79&"','"&Level&"','"&TeamGb&"','"&Sex&"','179','sd042001','sd030002','0','"&R1_Num40&"','"&R2_Num20&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data80&"','judo','"&GameTitleIDX&"','','"&Player80&"','"&Level&"','"&TeamGb&"','"&Sex&"','180','sd042001','sd030002','0','"&R1_Num40&"','"&R2_Num20&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data79&"','judo','"&GameTitleIDX&"','','"&Player79&"','"&Level&"','"&TeamGb&"','"&Sex&"','179','sd042002','sd030002','0','"&R1_Num40&"','"&R2_Num20&"','"&R3_Num10&"','"&R4_Num5&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 	

		If Hidden_Data81 <> "" And Hidden_Data82 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data81&"','judo','"&GameTitleIDX&"','','"&Player81&"','"&Level&"','"&TeamGb&"','"&Sex&"','181','sd042001','sd030002','0','"&R1_Num41&"','"&R2_Num21&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			'Response.Write (InSQL)
			'Response.End
			Dbcon.Execute(InSQL)
			
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data82&"','judo','"&GameTitleIDX&"','','"&Player82&"','"&Level&"','"&TeamGb&"','"&Sex&"','182','sd042001','sd030002','0','"&R1_Num41&"','"&R2_Num21&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data81&"','judo','"&GameTitleIDX&"','','"&Player81&"','"&Level&"','"&TeamGb&"','"&Sex&"','181','sd042002','sd030002','0','"&R1_Num41&"','"&R2_Num21&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data83 <> "" And Hidden_Data84 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data83&"','judo','"&GameTitleIDX&"','','"&Player83&"','"&Level&"','"&TeamGb&"','"&Sex&"','183','sd042001','sd030002','0','"&R1_Num42&"','"&R2_Num21&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data84&"','judo','"&GameTitleIDX&"','','"&Player84&"','"&Level&"','"&TeamGb&"','"&Sex&"','184','sd042001','sd030002','0','"&R1_Num42&"','"&R2_Num21&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data83&"','judo','"&GameTitleIDX&"','','"&Player83&"','"&Level&"','"&TeamGb&"','"&Sex&"','183','sd042002','sd030002','0','"&R1_Num42&"','"&R2_Num21&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 



		If Hidden_Data85 <> "" And Hidden_Data86 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data85&"','judo','"&GameTitleIDX&"','','"&Player85&"','"&Level&"','"&TeamGb&"','"&Sex&"','185','sd042001','sd030002','0','"&R1_Num43&"','"&R2_Num22&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data86&"','judo','"&GameTitleIDX&"','','"&Player86&"','"&Level&"','"&TeamGb&"','"&Sex&"','186','sd042001','sd030002','0','"&R1_Num43&"','"&R2_Num22&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data85&"','judo','"&GameTitleIDX&"','','"&Player85&"','"&Level&"','"&TeamGb&"','"&Sex&"','185','sd042002','sd030002','0','"&R1_Num43&"','"&R2_Num22&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data87 <> "" And Hidden_Data88 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data87&"','judo','"&GameTitleIDX&"','','"&Player87&"','"&Level&"','"&TeamGb&"','"&Sex&"','187','sd042001','sd030002','0','"&R1_Num44&"','"&R2_Num22&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data88&"','judo','"&GameTitleIDX&"','','"&Player88&"','"&Level&"','"&TeamGb&"','"&Sex&"','188','sd042001','sd030002','0','"&R1_Num44&"','"&R2_Num22&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data87&"','judo','"&GameTitleIDX&"','','"&Player87&"','"&Level&"','"&TeamGb&"','"&Sex&"','187','sd042002','sd030002','0','"&R1_Num44&"','"&R2_Num22&"','"&R3_Num11&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data89 <> "" And Hidden_Data90 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data89&"','judo','"&GameTitleIDX&"','','"&Player89&"','"&Level&"','"&TeamGb&"','"&Sex&"','189','sd042001','sd030002','0','"&R1_Num45&"','"&R2_Num23&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data90&"','judo','"&GameTitleIDX&"','','"&Player90&"','"&Level&"','"&TeamGb&"','"&Sex&"','190','sd042001','sd030002','0','"&R1_Num45&"','"&R2_Num23&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data89&"','judo','"&GameTitleIDX&"','','"&Player89&"','"&Level&"','"&TeamGb&"','"&Sex&"','189','sd042002','sd030002','0','"&R1_Num45&"','"&R2_Num23&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 

		
		If Hidden_Data91 <> "" And Hidden_Data92 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data91&"','judo','"&GameTitleIDX&"','','"&Player91&"','"&Level&"','"&TeamGb&"','"&Sex&"','191','sd042001','sd030002','0','"&R1_Num46&"','"&R2_Num23&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data92&"','judo','"&GameTitleIDX&"','','"&Player92&"','"&Level&"','"&TeamGb&"','"&Sex&"','192','sd042001','sd030002','0','"&R1_Num46&"','"&R2_Num23&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data91&"','judo','"&GameTitleIDX&"','','"&Player91&"','"&Level&"','"&TeamGb&"','"&Sex&"','191','sd042002','sd030002','0','"&R1_Num46&"','"&R2_Num23&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 

		If Hidden_Data93 <> "" And Hidden_Data94 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data93&"','judo','"&GameTitleIDX&"','','"&Player93&"','"&Level&"','"&TeamGb&"','"&Sex&"','193','sd042001','sd030002','0','"&R1_Num47&"','"&R2_Num24&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data94&"','judo','"&GameTitleIDX&"','','"&Player94&"','"&Level&"','"&TeamGb&"','"&Sex&"','194','sd042001','sd030002','0','"&R1_Num47&"','"&R2_Num24&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data93&"','judo','"&GameTitleIDX&"','','"&Player93&"','"&Level&"','"&TeamGb&"','"&Sex&"','193','sd042002','sd030002','0','"&R1_Num47&"','"&R2_Num24&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 



		If Hidden_Data95 <> "" And Hidden_Data96 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data95&"','judo','"&GameTitleIDX&"','','"&Player95&"','"&Level&"','"&TeamGb&"','"&Sex&"','195','sd042001','sd030002','0','"&R1_Num48&"','"&R2_Num24&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data96&"','judo','"&GameTitleIDX&"','','"&Player96&"','"&Level&"','"&TeamGb&"','"&Sex&"','196','sd042001','sd030002','0','"&R1_Num48&"','"&R2_Num24&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data95&"','judo','"&GameTitleIDX&"','','"&Player95&"','"&Level&"','"&TeamGb&"','"&Sex&"','195','sd042002','sd030002','0','"&R1_Num48&"','"&R2_Num24&"','"&R3_Num12&"','"&R4_Num6&"','"&R5_Num3&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 	

		If Hidden_Data97 <> "" And Hidden_Data98 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data97&"','judo','"&GameTitleIDX&"','','"&Player97&"','"&Level&"','"&TeamGb&"','"&Sex&"','197','sd042001','sd030002','0','"&R1_Num49&"','"&R2_Num25&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			'Response.Write (InSQL)
			'Response.End
			Dbcon.Execute(InSQL)
			
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data98&"','judo','"&GameTitleIDX&"','','"&Player98&"','"&Level&"','"&TeamGb&"','"&Sex&"','198','sd042001','sd030002','0','"&R1_Num49&"','"&R2_Num25&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data97&"','judo','"&GameTitleIDX&"','','"&Player97&"','"&Level&"','"&TeamGb&"','"&Sex&"','197','sd042002','sd030002','0','"&R1_Num49&"','"&R2_Num25&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data99 <> "" And Hidden_Data100 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data99&"','judo','"&GameTitleIDX&"','','"&Player99&"','"&Level&"','"&TeamGb&"','"&Sex&"','199','sd042001','sd030002','0','"&R1_Num50&"','"&R2_Num25&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data100&"','judo','"&GameTitleIDX&"','','"&Player100&"','"&Level&"','"&TeamGb&"','"&Sex&"','200','sd042001','sd030002','0','"&R1_Num50&"','"&R2_Num25&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data99&"','judo','"&GameTitleIDX&"','','"&Player99&"','"&Level&"','"&TeamGb&"','"&Sex&"','199','sd042002','sd030002','0','"&R1_Num50&"','"&R2_Num25&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 



		If Hidden_Data101 <> "" And Hidden_Data102 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data101&"','judo','"&GameTitleIDX&"','','"&Player101&"','"&Level&"','"&TeamGb&"','"&Sex&"','201','sd042001','sd030002','0','"&R1_Num51&"','"&R2_Num26&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data102&"','judo','"&GameTitleIDX&"','','"&Player102&"','"&Level&"','"&TeamGb&"','"&Sex&"','202','sd042001','sd030002','0','"&R1_Num51&"','"&R2_Num26&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data101&"','judo','"&GameTitleIDX&"','','"&Player101&"','"&Level&"','"&TeamGb&"','"&Sex&"','201','sd042002','sd030002','0','"&R1_Num51&"','"&R2_Num26&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data103 <> "" And Hidden_Data104 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data103&"','judo','"&GameTitleIDX&"','','"&Player103&"','"&Level&"','"&TeamGb&"','"&Sex&"','203','sd042001','sd030002','0','"&R1_Num52&"','"&R2_Num26&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data104&"','judo','"&GameTitleIDX&"','','"&Player104&"','"&Level&"','"&TeamGb&"','"&Sex&"','204','sd042001','sd030002','0','"&R1_Num52&"','"&R2_Num26&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data103&"','judo','"&GameTitleIDX&"','','"&Player103&"','"&Level&"','"&TeamGb&"','"&Sex&"','203','sd042002','sd030002','0','"&R1_Num52&"','"&R2_Num26&"','"&R3_Num13&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data105 <> "" And Hidden_Data106 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data105&"','judo','"&GameTitleIDX&"','','"&Player105&"','"&Level&"','"&TeamGb&"','"&Sex&"','205','sd042001','sd030002','0','"&R1_Num53&"','"&R2_Num27&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data106&"','judo','"&GameTitleIDX&"','','"&Player106&"','"&Level&"','"&TeamGb&"','"&Sex&"','206','sd042001','sd030002','0','"&R1_Num53&"','"&R2_Num27&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data105&"','judo','"&GameTitleIDX&"','','"&Player105&"','"&Level&"','"&TeamGb&"','"&Sex&"','205','sd042002','sd030002','0','"&R1_Num53&"','"&R2_Num27&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 

		
		If Hidden_Data107 <> "" And Hidden_Data108 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data107&"','judo','"&GameTitleIDX&"','','"&Player107&"','"&Level&"','"&TeamGb&"','"&Sex&"','207','sd042001','sd030002','0','"&R1_Num54&"','"&R2_Num27&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data108&"','judo','"&GameTitleIDX&"','','"&Player108&"','"&Level&"','"&TeamGb&"','"&Sex&"','208','sd042001','sd030002','0','"&R1_Num54&"','"&R2_Num27&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data107&"','judo','"&GameTitleIDX&"','','"&Player107&"','"&Level&"','"&TeamGb&"','"&Sex&"','207','sd042002','sd030002','0','"&R1_Num54&"','"&R2_Num27&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 

		If Hidden_Data109 <> "" And Hidden_Data110 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data109&"','judo','"&GameTitleIDX&"','','"&Player109&"','"&Level&"','"&TeamGb&"','"&Sex&"','209','sd042001','sd030002','0','"&R1_Num55&"','"&R2_Num28&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data110&"','judo','"&GameTitleIDX&"','','"&Player110&"','"&Level&"','"&TeamGb&"','"&Sex&"','210','sd042001','sd030002','0','"&R1_Num55&"','"&R2_Num28&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data109&"','judo','"&GameTitleIDX&"','','"&Player109&"','"&Level&"','"&TeamGb&"','"&Sex&"','209','sd042002','sd030002','0','"&R1_Num55&"','"&R2_Num28&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 



		If Hidden_Data111 <> "" And Hidden_Data112 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data111&"','judo','"&GameTitleIDX&"','','"&Player111&"','"&Level&"','"&TeamGb&"','"&Sex&"','211','sd042001','sd030002','0','"&R1_Num56&"','"&R2_Num28&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data112&"','judo','"&GameTitleIDX&"','','"&Player112&"','"&Level&"','"&TeamGb&"','"&Sex&"','212','sd042001','sd030002','0','"&R1_Num56&"','"&R2_Num28&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data111&"','judo','"&GameTitleIDX&"','','"&Player111&"','"&Level&"','"&TeamGb&"','"&Sex&"','211','sd042002','sd030002','0','"&R1_Num56&"','"&R2_Num28&"','"&R3_Num14&"','"&R4_Num7&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 	

		If Hidden_Data113 <> "" And Hidden_Data114 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data113&"','judo','"&GameTitleIDX&"','','"&Player113&"','"&Level&"','"&TeamGb&"','"&Sex&"','213','sd042001','sd030002','0','"&R1_Num57&"','"&R2_Num29&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			'Response.Write (InSQL)
			'Response.End
			Dbcon.Execute(InSQL)
			
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data114&"','judo','"&GameTitleIDX&"','','"&Player114&"','"&Level&"','"&TeamGb&"','"&Sex&"','214','sd042001','sd030002','0','"&R1_Num57&"','"&R2_Num29&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data113&"','judo','"&GameTitleIDX&"','','"&Player113&"','"&Level&"','"&TeamGb&"','"&Sex&"','213','sd042002','sd030002','0','"&R1_Num57&"','"&R2_Num29&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data115 <> "" And Hidden_Data116 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data115&"','judo','"&GameTitleIDX&"','','"&Player115&"','"&Level&"','"&TeamGb&"','"&Sex&"','215','sd042001','sd030002','0','"&R1_Num58&"','"&R2_Num29&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data116&"','judo','"&GameTitleIDX&"','','"&Player116&"','"&Level&"','"&TeamGb&"','"&Sex&"','216','sd042001','sd030002','0','"&R1_Num58&"','"&R2_Num29&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data115&"','judo','"&GameTitleIDX&"','','"&Player115&"','"&Level&"','"&TeamGb&"','"&Sex&"','215','sd042002','sd030002','0','"&R1_Num58&"','"&R2_Num29&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 



		If Hidden_Data117 <> "" And Hidden_Data118 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data117&"','judo','"&GameTitleIDX&"','','"&Player117&"','"&Level&"','"&TeamGb&"','"&Sex&"','217','sd042001','sd030002','0','"&R1_Num59&"','"&R2_Num30&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data118&"','judo','"&GameTitleIDX&"','','"&Player118&"','"&Level&"','"&TeamGb&"','"&Sex&"','218','sd042001','sd030002','0','"&R1_Num59&"','"&R2_Num30&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data117&"','judo','"&GameTitleIDX&"','','"&Player117&"','"&Level&"','"&TeamGb&"','"&Sex&"','217','sd042002','sd030002','0','"&R1_Num59&"','"&R2_Num30&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data119 <> "" And Hidden_Data120 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data119&"','judo','"&GameTitleIDX&"','','"&Player119&"','"&Level&"','"&TeamGb&"','"&Sex&"','219','sd042001','sd030002','0','"&R1_Num60&"','"&R2_Num30&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data120&"','judo','"&GameTitleIDX&"','','"&Player120&"','"&Level&"','"&TeamGb&"','"&Sex&"','220','sd042001','sd030002','0','"&R1_Num60&"','"&R2_Num30&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data119&"','judo','"&GameTitleIDX&"','','"&Player119&"','"&Level&"','"&TeamGb&"','"&Sex&"','219','sd042002','sd030002','0','"&R1_Num60&"','"&R2_Num30&"','"&R3_Num15&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 


		If Hidden_Data121 <> "" And Hidden_Data122 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data121&"','judo','"&GameTitleIDX&"','','"&Player121&"','"&Level&"','"&TeamGb&"','"&Sex&"','221','sd042001','sd030002','0','"&R1_Num61&"','"&R2_Num31&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data122&"','judo','"&GameTitleIDX&"','','"&Player122&"','"&Level&"','"&TeamGb&"','"&Sex&"','222','sd042001','sd030002','0','"&R1_Num61&"','"&R2_Num31&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data121&"','judo','"&GameTitleIDX&"','','"&Player121&"','"&Level&"','"&TeamGb&"','"&Sex&"','221','sd042002','sd030002','0','"&R1_Num61&"','"&R2_Num31&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 

		
		If Hidden_Data123 <> "" And Hidden_Data124 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data123&"','judo','"&GameTitleIDX&"','','"&Player123&"','"&Level&"','"&TeamGb&"','"&Sex&"','223','sd042001','sd030002','0','"&R1_Num62&"','"&R2_Num31&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data124&"','judo','"&GameTitleIDX&"','','"&Player124&"','"&Level&"','"&TeamGb&"','"&Sex&"','224','sd042001','sd030002','0','"&R1_Num62&"','"&R2_Num31&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data123&"','judo','"&GameTitleIDX&"','','"&Player123&"','"&Level&"','"&TeamGb&"','"&Sex&"','223','sd042002','sd030002','0','"&R1_Num62&"','"&R2_Num31&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 

		If Hidden_Data125 <> "" And Hidden_Data126 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data125&"','judo','"&GameTitleIDX&"','','"&Player125&"','"&Level&"','"&TeamGb&"','"&Sex&"','225','sd042001','sd030002','0','"&R1_Num63&"','"&R2_Num32&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data126&"','judo','"&GameTitleIDX&"','','"&Player126&"','"&Level&"','"&TeamGb&"','"&Sex&"','226','sd042001','sd030002','0','"&R1_Num63&"','"&R2_Num32&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data125&"','judo','"&GameTitleIDX&"','','"&Player125&"','"&Level&"','"&TeamGb&"','"&Sex&"','225','sd042002','sd030002','0','"&R1_Num63&"','"&R2_Num32&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 



		If Hidden_Data127 <> "" And Hidden_Data128 <> "" Then 
			'일반전
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data127&"','judo','"&GameTitleIDX&"','','"&Player127&"','"&Level&"','"&TeamGb&"','"&Sex&"','227','sd042001','sd030002','0','"&R1_Num64&"','"&R2_Num32&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)

			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data128&"','judo','"&GameTitleIDX&"','','"&Player128&"','"&Level&"','"&TeamGb&"','"&Sex&"','228','sd042001','sd030002','0','"&R1_Num64&"','"&R2_Num32&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		Else
			'부전승
			InSQL = "Insert Into tblRPlayer (PlayerIDX,SportsGb,GameTitleIDX,SchIDX,UserName,Level,TeamGb,Sex,PlayerNum,UnearnWin,LeftRightGb,GroupGameNum,Game1R,Game2R,Game3R,Game4R,Game5R,Game6R,Game7R,GroupGameGb,RGameLevelIDX,DelYN)"
			InSQL = InSQL&" VALUES ('"&Hidden_Data127&"','judo','"&GameTitleIDX&"','','"&Player127&"','"&Level&"','"&TeamGb&"','"&Sex&"','227','sd042002','sd030002','0','"&R1_Num64&"','"&R2_Num32&"','"&R3_Num16&"','"&R4_Num8&"','"&R5_Num4&"','"&R6_Num2&"','"&R7_Num1&"','sd040001','"&RGameLevelIDX&"','N')"
			Dbcon.Execute(InSQL)
		End If 		


	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	'=========================================================  오른쪽데이터==============================================================================	
	'학교정보 업데이트
	UpSQL = "UPDATE tblRPlayer Set Team=P.Team"
	UpSQL = UpSQL&" From Sportsdiary.dbo.tblRPlayer RP JOIN Sportsdiary.dbo.tblPlayer P On RP.PlayerIDX = P.PlayerIDX "
	UpSQL = UpSQL&" Where RP.GameTitleIDX='"&GameTitleIDX&"' AND RGameLevelidx='"&RGameLevelIDX&"'"
	'Response.Write UpSQL
	Dbcon.Execute(UpSQL)

%>
<script>
 alert('해당 대진표가 저장되었습니다.');
 window.open('/Manager/Ajax/Match128_View.asp?GameTitleIDX=<%=GameTitleIDX%>&TeamGb=<%=TeamGb%>&Level=<%=Level%>&GroupGameGb=sd040001','_blank'); 
 //location.href='TournamentInfo.asp?GameTitleIDX=<%=GameTitleIDX%>&GameType=<%=GameType%>'
</script>
