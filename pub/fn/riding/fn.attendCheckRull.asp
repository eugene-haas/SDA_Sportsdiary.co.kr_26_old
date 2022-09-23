<%
'####################
'참가신청저장
'####################

sub attendInsert(tidx,gbidx,attpidx,pubcode,engcode,pubname,hidx,teamgb,levelno,TeamGbNm  ,a_username,a_userphone,a_paymentDt,a_paymentNm,a_paymentType,relayteam, atttype)
    dim insertFLD,fld,selectQ,SQL,rs,grouppidx,requestidx
    '1. tblGameRequest 에넣기 (참가신청)

	'같은팀으로 묶일수 있도록 해야한다. 
	' 1. tblPlayer 에 group 만들기 또는 찾기
	' 2. tblGameRequest 그룹저장한 플레이어를 저장
	' 3. tblGameRequest_r 선수들 각각 정보를 넣고 여기 개별 결제 확인 할수 있도록 넣고 (payment 이걸로 체크)
	' 4. sd_TennisMember group 설정된 값넣기
	' 5. 말은 sd_TennisMember_partner 여기다 넣고
	' 6. sd_groupMember 에 선수 정보 넣고 


	if teamgb = "20208" Then '릴레이코스경기   3인 1마로 말중복만 검색하자.
        '참가 팀명칭을 tblplayer에 등록
        'relayteam '팀명칭 tlbplayer에 생성
        selectQ = "select top 1 0,'"&year(date)&"','"&year(date)&"','G','"&relayteam&"' , team,teamnm from tblPlayer where playeridx  in ("&attpidx&") "
        SQL = "SET NOCOUNT ON  insert into tblPlayer (ksportsno,startyear,nowyear,userType,username,team,teamnm) ("&selectQ&") SELECT @@IDENTITY"
	    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        grouppidx = rs(0)

        'tblGameRequest 
        insertFLD = " gametitleidx,gbidx,P1_playeridx,p1_username,p1_team,p1_teamnm,p1_userphone,p1_birthday,p1_sex,  p2_playeridx,p2_username,pubcode,engcode,pubname,payment ,username,userphone,paymentDt,paymentNm,paymentType,PayProposeType " '결제완료'
        fld = " "&tidx&","&gbidx&","&grouppidx&",a.username,a.team,a.teamnm,a.userphone,a.birthday,a.sex,b.playeridx,b.username, '"&pubcode&"','"&engcode&"','"&pubname&"',0 "
        fld = fld & ", '"&a_username&"','"&a_userphone&"','"&a_paymentDt&"','"&a_paymentNm&"','"&a_paymentType&"'  , '"&atttype&"' "
        selectQ = "Select "&fld&" from tblplayer as a inner join tblPlayer as b on b.PlayerIDX  = "&hidx&" where a.PlayerIDX = "&grouppidx&" "
        SQL = "SET NOCOUNT ON  insert Into tblGameRequest ("&insertFLD&")  ("&selectQ&")  SELECT @@IDENTITY"
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        requestidx = rs(0)

        'tblGameRequest_r 선수들 넣고
        selectQ = "select "&requestidx&",playeridx,username,'Y','Y' from tblPlayer where playeridx  in ("&attpidx&") "
        SQL = "insert into tblGameRequest_r (requestidx,playeridx,username,payOK,startMember) ("&selectQ&")"
        Call db.execSQLRs(SQL , null, ConStr)

        '2. sd_TennisMember 에넣기 (경기테이블 선수) gubun 편성전 0 으로 밀어넣자...기타 지구력 어쩌구 0 편성전   1 편성완료 , 릴레이 2 리그 , 3 토너먼트 등이 있을꺼임
        insertFLD = " gubun,gametitleidx,gamekey3,gamekey1,teamgb,gamekey2,key3name, pubcode,engcode,pubname,team,teamAna,ksportsno,playeridx,username,sex,requestIDX"
        fld = " '0',"&tidx&","&gbidx&",'"&left(teamgb,3)&"','"&teamgb&"','"&levelno&"','"&TeamGbNm&"','"&pubcode&"','"&engcode&"','"&pubname&"',team,teamnm,ksportsno, playeridx,username,sex,(select max(requestIDX) from tblGameRequest) "
        selectQ = "Select "&fld&" from tblPlayer where delyn = 'N' and  PlayerIDX = '" & grouppidx  & "'"
        SQL = "SET NOCOUNT ON insert Into sd_TennisMember ("&insertFLD&")  ("&selectQ&") SELECT @@IDENTITY"
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        gamememberidx = rs(0)

        '3. sd_TennisMember_partner
        insertFLD = " gameMemberIDX ,playeridx,username "

        fld = " "&gamememberidx&",playeridx,username "
        selectQ = "Select "&fld&" from  tblPlayer where delyn = 'N' and  PlayerIDX = '" & hidx  & "'"
        SQL = "insert Into sd_TennisMember_partner ("&insertFLD&")  ("&selectQ&")"
        Call db.execSQLRs(SQL , null, ConStr)

        'sd_groupMember 선수들
        selectQ = "select "&gamememberidx&","&requestidx&",playeridx,username,"&hidx&","&tidx&","&gbidx&" from tblPlayer where playeridx  in ("&attpidx&") "
        SQL = "insert into sd_groupMember (gameMemberidx, requestidx,pidx,pnm,hidx,tidx,gbidx) ("&selectQ&")"
        Call db.execSQLRs(SQL , null, ConStr)

    Else

        insertFLD = " gametitleidx,gbidx,P1_playeridx,p1_username,p1_team,p1_teamnm,p1_userphone,p1_birthday,p1_sex,  p2_playeridx,p2_username,pubcode,engcode,pubname,payment ,username,userphone,paymentDt,paymentNm,paymentType,PayProposeType " '결제완료'
        fld = " "&tidx&","&gbidx&","&attpidx&",a.username,a.team,a.teamnm,a.userphone,a.birthday,a.sex,b.playeridx,b.username, '"&pubcode&"','"&engcode&"','"&pubname&"',0 "
        fld = fld & ", '"&a_username&"','"&a_userphone&"','"&a_paymentDt&"','"&a_paymentNm&"','"&a_paymentType&"'  , '"&atttype&"'   "
        selectQ = "Select "&fld&" from tblplayer as a inner join tblPlayer as b on b.PlayerIDX  = "&hidx&" where a.PlayerIDX = "&attpidx&" "
        SQL = "insert Into tblGameRequest ("&insertFLD&")  ("&selectQ&")"
        'response.write sql
        'response.end
        Call db.execSQLRs(SQL , null, ConStr)

        '2. sd_TennisMember 에넣기 (경기테이블 선수) gubun 편성전 0 으로 밀어넣자...기타 지구력 어쩌구 0 편성전   1 편성완료 , 릴레이 2 리그 , 3 토너먼트 등이 있을꺼임
        insertFLD = " gubun,gametitleidx,gamekey3,gamekey1,teamgb,gamekey2,key3name, pubcode,engcode,pubname,team,teamAna,ksportsno,playeridx,username,sex,requestIDX"
        fld = " '0',"&tidx&","&gbidx&",'"&left(teamgb,3)&"','"&teamgb&"','"&levelno&"','"&TeamGbNm&"','"&pubcode&"','"&engcode&"','"&pubname&"',team,teamnm,ksportsno, playeridx,username,sex,(select max(requestIDX) from tblGameRequest) "
        selectQ = "Select "&fld&" from tblPlayer where delyn = 'N' and  PlayerIDX = '" & attpidx  & "'"
        SQL = "insert Into sd_TennisMember ("&insertFLD&")  ("&selectQ&")"
        Call db.execSQLRs(SQL , null, ConStr)

        '3. sd_TennisMember_partner
        insertFLD = " gameMemberIDX ,playeridx,username "

        fld = " (select max(gameMemberIDX) from sd_TennisMember),playeridx,username "
        selectQ = "Select "&fld&" from  tblPlayer where delyn = 'N' and  PlayerIDX = '" & hidx  & "'"
        SQL = "insert Into sd_TennisMember_partner ("&insertFLD&")  ("&selectQ&")"
        Call db.execSQLRs(SQL , null, ConStr)

    end if
    'relayteam  팀선수 등록

end sub

'####################
'코드가져오기
'####################
function getPubInfo(pubcode)
    Dim SQL,rs
    SQL = "select engcode,pubname from tblPubCode where pubcode = '"&pubcode&"' "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    if rs.eof Then
        getPubInfo = array(pubcode,"","")
    Else
        getPubInfo = array(pubcode,rs(0),rs(1))
    end if
end function

'####################
'부에 기본정보 가져오기
'####################
function GameLevelInfo(levelidx)
    Dim strTableName,strfieldA,strfieldB,strFieldName,strWhere,SQL,rs,horsekind
    Dim classstr,i,class_arr

    Dim returnvalarray(12)
    class_arr = array("S","A","B","C","D","D","F")
    '기승제한 개인 /단체' 인당기승마, 기승마인원
    strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
    strfieldA = " a.gameno,a.GameTitleIDX,a.GbIDX  , (case when b.PTeamgb = '201' Then a.horselimit else a.horselimit2 end) as hlimit, (case when b.PTeamgb = '201' Then a.playerlimit else a.playerlimit2 end) as plimit,pubcode,engcode,pubname  "
    strfieldB = " b.TeamGbNm,b.ridingclass,b.ridingclasshelp,b.levelnm,b.Teamgb,b.levelno "
    strFieldName = strfieldA &  "," & strfieldB
    strWhere = " a.RGameLevelidx = "&levelidx&" and a.DelYN = 'N'  "

    SQL = "Select "&strFieldName&" from "&strTableName&" where " & strWhere
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    if not rs.eof Then
        returnvalarray(0) = rs("gbidx")
        returnvalarray(1)  = rs("GameTitleIDX")
        returnvalarray(2) = rs("hlimit") '0 없다면 기본값이 0이다....인당기승마
        returnvalarray(3) = rs("plimit")
        returnvalarray(4) = rs("TeamGbNm") '종목'
        classstr = left(rs("ridingclass"),1) '제한조건 클레스 번호구하기'
        for i = 0 to ubound(class_arr)
            if class_arr(i) = classstr then
                returnvalarray(5) = i
            end if
        Next
        horsekind = rs("levelnm") '조건 말 종류
        select case horsekind
        case "국산마+외산마"
        returnvalarray(6) = "M"
        case "국산마"
        returnvalarray(6) = "K"
        case "외산마"
        returnvalarray(6) = "F"
        end select

        returnvalarray(7) = rs("teamgb")
        returnvalarray(8) = rs("levelno")
        returnvalarray(9) = rs("levelnm")
        returnvalarray(10) = rs("ridingclass")
        returnvalarray(11) = rs("ridingclasshelp")

    end if

    '최소 1로 설정'
    if returnvalarray(2) = 0 Then : returnvalarray(2) = 1
    if returnvalarray(3) = 0 Then : returnvalarray(3) = 1
    GameLevelInfo = returnvalarray
end function

'####################
'기승마 리턴값은 말인덱스 , 또는 선수 인덱스 returntype 말(H) 선수(P)
'####################
function MaxHorseToPerson(tidx,bgidx,limitvalue, ruturntype)
    Dim personSQL,SQL,rs,htopidxs
    '인당기승마  제외할 말playeridx
    personSQL = "select max(gamememberidx)as gamememberidx , PlayerIDX from sd_TennisMember where delyn='N' and GameTitleIDX = "&tidx&" and gamekey3 = "&gbidx&" group by playeridx"
    SQL = ""

    SQL = SQL & "select stuff("
    SQL = SQL & "("

    SQL = SQL & "select ',' + cast(PlayerIDX as varchar) from ( "
    if ruturntype = "H" Then
    SQL = SQL & "select b.PlayerIDX, COUNT(*) as hcnt from (" &personSQL&" ) as A inner join sd_TennisMember_partner as B on A.gamememberidx = B.gamememberidx group by B.PlayerIDX "
    Else
    SQL = SQL & "select Max(A.PlayerIDX) as PlayerIDX, COUNT(*) as hcnt from (" &personSQL&" ) as A inner join sd_TennisMember_partner as B on A.gamememberidx = B.gamememberidx group by B.PlayerIDX "
    end if
    SQL = SQL & "	) as HtoPidx where hcnt >= " & limitvalue & "group by PlayerIDX for XML path('')"

    SQL = SQL & ") ,1,1,'' "
    SQL = SQL & ")"

    Set rs = db.ExecSQLReturnRS(SQL,null, ConStr)
    if rs.eof Then
        htopidxs = ""
    Else
        htopidxs = rs(0)
    end if

    MaxHorseToPerson = htopidxs
end Function

'####################
'기승인 리턴값은 말인덱스 , 또는 선수 인덱스 returntype 말(H) 선수(P)
'####################
function MaxPersonToHorse(tidx,bgidx,limitvalue, ruturntype)
    Dim horseSQL,SQL,rs,ptohidxs
    '기승마인원 말당 사람 (말탈사람수 확인하고 제외할말 playeridx)
    horseSQL = "select max(b.gamememberidx)as gamememberidx, b.PlayerIDX from sd_TennisMember as a inner join sd_TennisMember_partner as b on a.gamememberidx = b.gamememberidx where a.delyn='N' and a.GameTitleIDX = "&tidx&" and a.gamekey3 = "&gbidx&" group by b.playeridx"
    SQL = ""
    SQL = SQL & "select stuff("
    SQL = SQL & "("

    SQL = SQL & "select ',' + cast(hidx as varchar) from ( "
    if returntype = "H" Then '말
    SQL = SQL & "		select max(A.playeridx) as hidx,COUNT(*) as pcnt from ( "&  horseSQL & " ) as A "
    Else
    SQL = SQL & "		select max(B.playeridx) as hidx,COUNT(*) as pcnt from ( "&  horseSQL & " ) as A "
    end if
    SQL = SQL & " 		INNER JOIN sd_TennisMember as B "
    SQL = SQL & " 		ON A.gamememberidx = B.gameMemberIDX and B.DelYN = 'N' group by B.PlayerIDX "
    SQL = SQL & " ) as HtoPnm WHERE pcnt >= " & limitvalue & "group by hidx for xml path('')" 'pcnt : 현재횟수 limitvalue 제한횟수

    SQL = SQL & ") ,1,1,'' "
    SQL = SQL & ")"

    Set rs = db.ExecSQLReturnRS(SQL,null, ConStr)
    if rs.eof Then
        ptohidxs = ""
    Else
        ptohidxs = rs(0)
    end if
    MaxPersonToHorse = ptohidxs
end function

'####################
'참가자격제한  chkHkind : MKF 국+외, 국, 외 (말)  종목 + 클레스 + 말 ( 종목 + 클레스 + 말 당한개씩 존재해야한다.)	'종목명, 클레스번호, 말타입
'####################
function setLimitRule(teamgbnm,classno,wherehorsetype, ruturntype)

    dim strFieldName,strSort,strWhere,SQL,rs,arrR,n,ari,class_arr
    dim chkclassstr,updown,zeropointcnt,chkandor,prizecnt,attokYN,limitTeamgbnm,limitchkClass,chkidxs,gubun
    class_arr = array("S","A","B","C","D","D","F","E","G")

    if ruturntype = "H" Then '말
        gubun = 2
    Else
        gubun = 1
    end if

    strFieldName = " updown,zeropointcnt,chkandor,prizecnt,attokYN,limitTeamgbnm,limitchkClass "
    strSort = "  ORDER By seq Desc"
    strWhere = " DelYN = 'N' and gubun= '"&gubun&"' and chkyear = '"& year(date) &"' and teamgbnm = '"&teamgbnm&"' and chkclass = '"&classno&"' and chkHkind like '%"&wherehorsetype&"%'  "
    SQL = "Select top 1 " & strFieldName & " from tblLimitAtt where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

    If Not rs.EOF Then
        arrR = rs.GetRows()
    End If

    if IsArray(arrR) then
        For ari = LBound(arrR, 2) To UBound(arrR, 2)
            chkclassstr = class_arr(classno)
            updown = arrR(0,ari) ''무감점, 입상실정 이상 또는 이하 UP DOWN
            zeropointcnt = arrR(1,ari) '무감점 횟수'
            chkandor = arrR(2,ari) 'AND OR
            if chkandor = "AND" Then
                chkandor = " intersect "
            Else
                chkandor = " UNION "
            end if

            prizecnt = arrR(3,ari) '입상실적 3위까지
            attokYN = arrR(4,ari) '참여 또는 불참 여부'
            limitTeamgbnm = arrR(5,ari) '제한종목'
            limitchkClass= arrR(6, ari) '클레스'

            if updown = "UP" Then
                updown = ">="
            Else
                updown = "<="
            end if
        Next

        SQL = ""
        if ruturntype = "H" then '말'

            SQL = SQL & "select stuff("
            SQL = SQL & "("

            SQL = SQL & "select ',' + cast(pidx as varchar) from ( "
            '무감점 횟수 체크 (Deduction = '0' )
            SQL = SQL & "select pidx from (select pidx,count(*) as cnt from tblGameRecord where gamedate >= '"&DateAdd("m", -36,date)&"' and Deduction = '0' and CDBNM ='"&teamgbnm&"' and classNM like '%"&chkclassstr&"%' and gameyear > "&year(date)-3&" and delyn='N' group by pidx ) tbldeductionCnt where  cnt "&updown&" " & zeropointcnt

            SQL = SQL & chkandor

            '입상실적 횟수 체크
            SQL = SQL & "select pidx from (select pidx,count(*) as cnt from tblGameRecord where gamedate >= '"&DateAdd("m", -36,date)&"' and gameorder < 4 and CDBNM ='"&teamgbnm&"' and classNM like '%"&chkclassstr&"%' and gameyear > "&year(date)-3&" and delyn='N' group by pidx ) gameorder where  cnt "&updown&" " & prizecnt
            SQL = SQL & " ) as a group by pidx for xml path('') "

            SQL = SQL & ") ,1,1,'' "
            SQL = SQL & ")"

        Else '선수

            SQL = SQL & "select stuff("
            SQL = SQL & "("

            SQL = SQL & "select ',' + cast(playeridx as varchar) from ( "
            '무감점 횟수 체크
            SQL = SQL & "select PlayerIDX from (select PlayerIDX,count(*) as cnt from tblGameRecord where gamedate >= '"&DateAdd("m", -36,date)&"' and Deduction = '0' and CDBNM ='"&teamgbnm&"' and classNM like '%"&chkclassstr&"%' and gameyear > "&year(date)-3&" and delyn='N' group by PlayerIDX ) tbldeductionCnt where  cnt "&updown&" " & zeropointcnt

            SQL = SQL & chkandor

            '입상실적 횟수 체크
            SQL = SQL & "select PlayerIDX from (select PlayerIDX,count(*) as cnt from tblGameRecord where gamedate >= '"&DateAdd("m", -36,date)&"' and gameorder < 4 and CDBNM ='"&teamgbnm&"' and classNM like '%"&chkclassstr&"%' and gameyear > "&year(date)-3&" and delyn='N' group by PlayerIDX ) gameorder where  cnt "&updown&" " & prizecnt
            SQL = SQL & " ) as a group by PlayerIDX for xml path('') "

            SQL = SQL & ") ,1,1,'' "
            SQL = SQL & ")"

        end if

		Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

        '제외 할 말 또는 선수
        if rs.eof Then
            chkidxs = ""
        Else
            chkidxs = mid(rs(0),2)
        end If
    end if

    setLimitRule = array(chkidxs,attokYN)

end Function
%>
