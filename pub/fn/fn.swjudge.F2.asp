<%
    '####################################################
    '부가 종료되었다면 결과끝 저장 / 오늘끝났니 체크
    '####################################################    
    sub setBooEnd(grouplevelidx,lidxs,lidx,midx,judgeCnt,jno,roundno, ByRef db, ConStr)
        dim fld,tbl,i,infldstr,invaluestr,updatefldstr,booend,gamedate1,gamedate2,cdc, judge_endchkno,endstate
        dim SQL,rs,rss

				SQL = "select cdc,tryoutgamedate,finalgamedate  from tblRGameLevel where RgameLevelidx = " & lidx
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If rs.eof Then
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "여기 올일이 있으면 안되겠지" ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end
				Else
					cdc = rs(0)
					gamedate1 = rs(1)
					gamedate2 = rs(2)
				end if

			fld = " a.gameMemberIDX "
			'a.tryoutsortno > 0 순서번호가 설정된 값만 가져오자
			tbl = " SD_gameMember as a inner join tblRGameLevel as b  ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and b.delYN = 'N'  inner join sd_gameMember_roundRecord as c on a.gamememberidx = c.midx "

				Select Case CDC '테크니컬
				Case "04","06","12"		

					'관리자 날짜와 상관없이 써야해서
					if CDate(gamedate1) = CDate(gamedate2) then
						If  Cdbl(jno) > judgeCnt / 3 * 2 Then
						SQL = "select " & fld & "  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.gameround in (1,2,3,4,5,6) and c.jumsu"&jno&"	 is Null "
						else
						SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.gameround in (1,6) and c.jumsu"&jno&"	 is Null "							
						end if
					Else 
						if Cdbl(roundno) = 6 then '프리
							SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.gameround = 6 and c.jumsu"&jno&"	 is Null "
							endstate = "테크프리종료상태"		
						else	'테크					
							If  Cdbl(jno) > judgeCnt / 3 * 2 Then
							SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.gameround in (1,2,3,4,5) and c.jumsu"&jno&"	 is Null "
							else
							SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.gameround = 1 and c.jumsu"&jno&"	 is Null "							
							end if
							endstate = "테크종료상태"
						end if
					End if
				
				'날짜는
				Case "01" '피겨솔로
					if CDate(gamedate1) = CDate(gamedate2) then						
							SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.jumsu"&jno&"	 is Null "		
					Else
						if Cdbl(roundno) = 5 then '프리
							SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.gameround =5 and c.jumsu"&jno&"	 is Null "
							endstate = "피겨프리종료상태"
						else			
							SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.gameround in (1,2,3,4) and c.jumsu"&jno&"	 is Null "	
						end if
							endstate = "피겨종료상태"							
					End if

				Case "02","03" '피겨듀엣 ,'피겨팀
					SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.gameround = 5 and c.jumsu"&jno&"	 is Null "		

				Case Else
					SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.jumsu"&jno&"	 is Null "		
				End Select 
				SQL = SQL & " and a.gubun in (1,3) and a.tryoutsortno > 0 and a.tryoutResult < 'a' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				'Call oJSONoutput.Set("쿼리F2", SQL )

				if CDate(gamedate1) = CDate(gamedate2) then
					judge_endchkno = 1 '심판완료 시작번호 
				else
					judge_endchkno = 2
				end if


			  if rs.eof then '결과가에 Null이 하나도 없다면
            
            '인서트 또는 업데이트 'tblRgameLevel_judgeEndCheck 끝인지 판단해서 1~15까지 
            SQL = "select RGameLevelidx from tblRgameLevel_judgeEndCheck where RGameLevelidx = " & lidx
            Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


				'########################################
						'기권 (전체), 개별심판 각심판번호만
            for i = 1 to judgeCnt
              
              '시작은 2 피겨, 테크가 끝나면 1 , 프리가 끝나면 0
							if Cdbl(jno) = i then 'Cdbl(jno) = 0전체기권이라면XXX 심판수만큼 호출해야할꺼같음...
                booend = judge_endchkno - 1
              else
                booend = judge_endchkno
              end if

						'피겨솔로라면 
						'7번 다음 심사부터는 (프리) 1로시작이다.
              infldstr = infldstr & ",judge_endchk" & i
							if CDC = "01" and i > 7 then
              invaluestr = invaluestr & ",'1' "
							else
              invaluestr = invaluestr & ",'"&booend&"' "
							end if

							if Cdbl(jno) = i then 
									'updatefldstr = "judge_endchk" & i & " = case when  judge_endchk" & i & " = 0 then 0 else judge_endchk" & i & " - 1 end "
									'관리자에서 수정할때 바꾸면 문제가 생김...어떻게 해야하지..
									'피겨,테크 라운드라면 프리라운드 종료여부 체크, 프리라운드라면 피겨,테크종료여부 체크
									if endstate = "" then
											updatefldstr = "judge_endchk"&i&" = case when judge_endchk"&i&" = 2 then 1 when judge_endchk"&i&" = 1 then 0 else 0 end "									
									else
										select case endstate 
										case "피겨종료상태" '프리종료상태확인 확인
											SQL = "select jumsu"&jno&"  from sd_gameMember_roundRecord where  lidx in ( " & lidxs & ") and gameround = 5 and jumsu"&jno&" is Null "									
										case "테크종료상태"	
											SQL = "select jumsu"&jno&"  from sd_gameMember_roundRecord where  lidx in ( " & lidxs & ") and gameround = 6 and jumsu"&jno&" is Null "
										case "피겨프리종료상태" '피겨,테크 종료상태 확인
											SQL = "select jumsu"&jno&"  from sd_gameMember_roundRecord where  lidx in ( " & lidxs & ") and gameround in (1,2,3,4) and jumsu"&jno&" is Null "
										case "테크프리종료상태"									
											SQL = "select jumsu"&jno&"  from sd_gameMember_roundRecord where  lidx in ( " & lidxs & ") and gameround in (1,2,3,4,5) and jumsu"&jno&" is Null "
										end select 
										Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

										if rss.eof then '모두 종료된경기면 0으로
											updatefldstr = "judge_endchk"&i&" = 0 "									
										else
											updatefldstr = "judge_endchk"&i&" = case when judge_endchk"&i&" = 2 then 1 else 1 end "
										end if
									end if

							end if

            next
				'########################################
					'Call oJSONoutput.Set("endstate", endstate )
					'Call oJSONoutput.Set("updatefldstr", updatefldstr )						

            if rs.eof then
              SQL = "insert into tblRgameLevel_judgeEndCheck (RGameLevelidx "&infldstr&") values ( "&lidx&" "&invaluestr&" )"
              Call db.execSQLRs(SQL , null, ConStr)
            else
              SQL = "update tblRgameLevel_judgeEndCheck set " & updatefldstr & " where RGameLevelidx = " & lidx
              Call db.execSQLRs(SQL , null, ConStr)			
            end if

        end if
				'Call oJSONoutput.Set("LOG_"& jno, sql )

    end sub





		'$$$$$$$$$$$$$$$$$$$$$$$$$$$
		'아티스틱 듀엣, 팀 정보 찾아서 가져오기
		'$$$$$$$$$$$$$$$$$$$$$$$$$$$
		Function getArtiGroup(tidx,lidx,gbidx, byref db,Constr,CDA)
			Dim SQL , rs
			Dim lidxs,gbidxs,arrR, ari
			'솔로에서만 조작됨.
			'듀엣과 팀이 있는지 확인 (부서의)
			'듀엣과 팀도 동일하게 설정

			SQL = "Declare @cdb varchar(32) ,@cdcduet varchar(32), @cdcteam varchar(32) "
			SQL = SQL & "Select "
			SQL = SQL & "@cdb = cdb , "
			SQL = SQL & "@cdcduet = case when cdc = '01' then '02' when cdc = '04' then '06' when cdc = '05' then '07' else '0' end, " '듀엣
			SQL = SQL & "@cdcteam = case when cdc = '01' then '03' when cdc = '04' then '12' when cdc = '05' then '11' else '0' end "  '팀
			SQL = SQL & "from tblRGameLevel where RGameLevelidx = " & lidx
			SQL = SQL & "Select RGameLevelidx,gbidx from tblRGameLevel  where GameTitleIDX = "&tidx&" and cda = '"&cda&"' and cdb = @cdb and cdc in (@cdcduet,@cdcteam)  and delyn = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If rs.eof Then
				lidxs = lidx
				gbidxs = gbidx
			Else
				lidxs = lidx
				gbidxs = gbidx
				arrR = rs.GetRows()
				If IsArray(arrR) Then 
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						lidxs = lidxs & "," & arrR(0, ari)
						If gbidx <> "" then
							gbidxs = gbidxs & "," &  arrR(1, ari)
						End if
					Next
				End if			
			End If
			getArtiGroup = Array(lidxs,gbidxs)
		End function




		'%%%%%%%%%%%%%%%%%
			'감점,실격정보 가져오기#####################
			Function getRndDeduction(lidxs ,ByRef db, ConStr)
				Dim SQL, rs,strjson
				SQL = "select midx,a_totaldeduction,a_eletotaldeduction,a_elededuction,gameround,a_tktotaldeduction   from  sd_gameMember_roundRecord  where  lidx in ("&lidxs&") " 
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
						getRndDeduction = rs.GetRows()
				Else
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "라운드 설정이 되어있지 않습니다. 관리자에게 문의하여 주십시오." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.End
				End If
			End Function 

			'사유코드 가져오기#####################
			Function getSaYouCode(cda ,ByRef db, ConStr)
				Dim SQL, rs,strjson
				SQL = "select code,codeNm from tblCode  where gubun = 2 and CDA = '"&cda&"' and delyn = 'N'  order by sortno asc"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
						getSaYouCode = rs.GetRows()
				Else
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "사유코드가 정의되지 않았습니다." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.End
				End If
			End Function 

			'통합된 부들 코드#####################
			'grouplevelidx, RoundCnt, judgeCnt " '라운드수, 심사위원수
			Function getBooInfo(lidx, ByRef db, ByRef  ConStr ,CDA)
				Dim lidxsquery,SQL,rs,arrI,ari,grouplevelidx,RoundCnt,judgeCnt,lidxs
				Dim returnarr(7)
				lidxsquery = "(SELECT  STUFF(( select ','+ cast(RgameLevelidx as varchar) from tblRGameLevel where (grouplevelidx is not null and grouplevelidx = L.grouplevelidx) or  RgameLevelidx = "&lidx&" group by RgameLevelidx for XML path('') ),1,1, '' ))"
				gbidxsquery = "(SELECT  STUFF(( select ','+ cast(gbidx as varchar) from tblRGameLevel where (grouplevelidx is not null and grouplevelidx = L.grouplevelidx) or  RgameLevelidx = "&lidx&" group by gbidx for XML path('') ),1,1, '' ))"
				SQL = "Select top 1 isNull(grouplevelidx, 0) , isnull(RoundCnt,0), isnull(judgeCnt,0) , "&lidxsquery&",cdc,gametitleidx,"&gbidxsquery&"  from tblRGameLevel as L where RgameLevelidx = " & lidx
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrI = rs.GetRows()
				End If

				'Call getrowsdrow(arrI)
				'Response.write sql

				If IsArray(arrI) Then
					For ari = LBound(arrI, 2) To UBound(arrI, 2)

						returnarr(0) = arrI(0,ari) '그룹 묶음 
						returnarr(1) =  arrI(1,ari)  '라운드수
						returnarr(2) =  arrI(2,ari)   '심사위원수
						returnarr(3) = arrI(3,ari) 'lidx 들
						returnarr(4) = arrI(4,ari) 'CDC 상세코드
						returnarr(5) = arrI(5,ari) 
						returnarr(6) = arrI(6,ari) 'gbidx

					Next
				End If
				getBooInfo = returnarr
			End Function

			'##################################################################
			'예외처리
			'##################################################################
			Sub judgeExceptionRnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , ByRef db, ByRef  ConStr ,CDA)
				Dim SQL,rs,strjson
				'라운드
				SQL = "Select count(seq) from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&CDA&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
				If  CDbl(RoundCnt) = 0 Then
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "라운드를 먼저 설정해 주세요." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end
				End If
			End Sub

			'심판배정에서 심판수 미달 판단
			Sub judgeExceptionJcnt(tidx,judgeCnt,RoundCnt,lidxs,chkpass , ByRef db, ByRef  ConStr ,CDA)
				Dim SQL,rs,strjson
				'심판수 체크
				SQL = "Select count(seq) from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&CDA&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
				If CDbl(judgeCnt) = 0 Or  CDbl(rs(0)) < CDbl(judgeCnt) Then
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "심판수가 설정되지 않았거나 또는 심판수가 부족합니다." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end
				End If
			End Sub


			'심사내용이 있는지 확인
			Sub judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , ByRef db, ByRef  ConStr ,CDA)				
				Dim SQL,rs,strjson,i
				'체점된 정보체크

				If judgeCnt = 0 Or judgeCnt = "" Or isnull(judgeCnt) = true Then				
				
				Else
				
					For i = 1 To judgeCnt
						If i = 1 then
							fld = " sum( isnull(jumsu"&judgeCnt&",-1000) "
						Else
							fld = fld & " + isnull(jumsu"&judgeCnt&",-1000) "
						End If
					next
						fld = fld & ") "
					SQL = "select "&fld&" from  sd_gameMember_roundRecord  Where tidx = "&tidx&"  And lidx in  ("& lidxs &") "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

					If isNull(rs(0)) = false then
					If CDbl(rs(0)) >= 0  Then
						Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
						Call oJSONoutput.Set("servermsg", "심사된 기록이 있어 초기화 할수 없습니다." ) '서버에서 메시지 생성 전달
						strjson = JSON.stringify(oJSONoutput)
						Response.Write strjson
						Response.end
					End If
					End if
				End if
			End sub


			'심판배정되었는지 확인 (심판배정에서만 사용)
			Sub judgeException(tidx,judgeCnt,RoundCnt,lidxs,chkpass , ByRef db, ByRef  ConStr ,CDA)				
				Dim SQL,rs,strjson
				If chkpass = "chkpass" then
					'심판배정을 했는지 확인
					SQL = "select top 1 isnull(jidx1,0) from sd_gameMember_roundRecord  Where tidx = "&tidx&"  And lidx in  ("& lidxs &") "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rs.eof Then
						If CDbl(rs(0))  > 0 Then
							Call oJSONoutput.Set("result", 112 ) '서버에서 메시지 생성 전달 confie
							Call oJSONoutput.Set("servermsg", "심판배정이 되어있습니다. 다시 심판배정을 진행하시겠습니까?" ) '서버에서 메시지 생성 전달
							strjson = JSON.stringify(oJSONoutput)
							Response.Write strjson
							Response.end
						End if
					End If
				End if
			End Sub
			'##################################################################


			'변경할 심판들 카운드 리셋
			Sub resetChangeJudgeCnt(tidx, jidx, targetjidx,targetfldno,  ByRef db, ByRef  ConStr ,CDA)
				Dim SQL,i,ari
				If targetfldno = "" Then '같은부에 있지 않다면 카운트 변경
					'jidx  -1 
					'targetjidx +1
					SQL = " update sd_gameTitle_judge Set setcnt = case when setcnt  - 1 < 0 then 0 else setcnt - 1 end where tidx = "&tidx&" and cda = '"&CDA&"' and  jseq in ("&jidx&") "
					SQL = SQL & " update sd_gameTitle_judge Set setcnt = setcnt + 1 where tidx = "&tidx&" and cda = '"&CDA&"' and  jseq in ("&targetjidx&") "
					Call db.execSQLRs(SQL , null, ConStr)
				End if
			End Sub

			'심판리셋	(통합이 있으므로 부별로 각각 리셋)
			Sub resetJudge(tidx, lidxs , ByRef db, ByRef  ConStr ,CDA)
				Dim fld,SQL,rs,in_jidxs,resetfld
				Dim resetstate
				Dim lidxarr,i

				lidxsarr = Split(lidxs,",")
				For i = 0 To ubound(lidxsarr)

					fld = "isnull(jidx1,0),isnull(jidx2,0),isnull(jidx3,0),isnull(jidx4,0),isnull(jidx5,0),isnull(jidx6,0),isnull(jidx7,0),isnull(jidx8,0),isnull(jidx9,0),isnull(jidx10,0),isnull(jidx11,0),isnull(jidx12,0),isnull(jidx13,0),isnull(jidx14,0),isnull(jidx15,0)"
					SQL = "select top 1 "&fld&" from sd_gameMember_roundRecord  Where tidx = "&tidx&"  And lidx in  ("& lidxsarr(i) &") "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rs.EOF Then
						If CDbl(rs(0)) = 0 Then
							resetstate = false
						Else
							resetstate = True '리셋할지 여부			
							in_jidxs = rs(0) & "," & rs(1) & "," & rs(2) & "," & rs(3) & "," & rs(4) & "," & rs(5) & "," & rs(6) & "," & rs(7) & "," & rs(8) & "," & rs(9) & "," & rs(10) & "," & rs(11) & "," & rs(12) & "," & rs(13) & "," & rs(14) 
						End if
					End if
					Set rs = Nothing

					If resetstate = True then
						resetfld = "name1=null,name2=null,name3=null,name4=null,name5=null,name6=null,name7=null,name8=null,name9=null,name10=null,name11=null,name12=null,name13=null,name14=null,name15=null"
						resetfld = resetfld & ",jidx1=null,jidx2=null,jidx3=null,jidx4=null,jidx5=null,jidx6=null,jidx7=null,jidx8=null,jidx9=null,jidx10=null,jidx11=null,jidx12=null,jidx13=null,jidx14=null,jidx15=null"
						resetfld = resetfld & ",jteam1=null,jteam2=null,jteam3=null,jteam4=null,jteam5=null,jteam6=null,jteam7=null,jteam8=null,jteam9=null,jteam10=null,jteam11=null,jteam12=null,jteam13=null,jteam14=null,jteam15=null"

						SQL = "update sd_gameMember_roundRecord Set  "&resetfld&"  Where tidx = "&tidx&"  And lidx in  ("& lidxsarr(i) &")	 "
						SQL = SQL & " update sd_gameTitle_judge Set setcnt = case when setcnt  - 1 < 0 then 0 else setcnt - 1 end where tidx = "&tidx&" and cda = '"&CDA&"' and  jseq in ("&in_jidxs&") "
						Call db.execSQLRs(SQL , null, ConStr)
					End If

				Next
				
			End Sub

			'심판 배정	
			Sub setJudge( tidx, lidxs , ByRef db, ByRef  ConStr ,CDA)
				Dim i , ari, updateseq,updatefld
				Dim u_seq,u_jidx,u_name,u_team,SQL 
				Dim arrR,arrT
				Dim tbl,rs,inteamcode

				'포함된 선수들 팀코드들
				tbl = " SD_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and a.delYN = 'N'  "
				SQL = "Select stuff((		select ''','''+ team  from "&tbl&" where b.delyn = 'N' and a.gubun in (1,3) and a.tryoutsortno > 0 and b.RgameLevelidx in ("& lidxs &")		group by team for XML path('') ),1,1, '' )"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If rs.eof Then
					inteamcode = "'0'"
				else
					inteamcode = Mid(rs(0),2) & "'"
				End if

				'소속이 다른 심판들 가져오자..(배정심판수 만큼만)
				fld = " seq,jseq,name,team,teamnm,setcnt "
				SQL = " Select top "&judgeCnt&" "&fld&" from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&CDA&"' and team not in ("&inteamcode&")  order by setcnt asc" '배정수가 적은순으로
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrR = rs.GetRows()

					If CDbl(ubound(arrR)) < CDbl(judgeCnt) then 
						'부족한 심판수 
							plusejudgecnt = judgeCnt - ubound(arrR)
								SQL = " Select top "&plusejudgecnt&" "&fld&" from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&CDA&"' and team in ("&inteamcode&")  order by setcnt asc" '배정수가 적은순으로
								Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

								If Not rs.EOF Then
									arrT = rs.GetRows()
								End if
					End if
				End If
				
				'심판 명단 저장(업데이트 이미 생성되어있다 라운드 생성시) 라운드 심사지에
				If isArray(arrR) = true Then
					i = 1
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						U_seq = arrR(0,ari)
						u_jidx = arrR(1, ari)
						u_name= arrR(2, ari)
						u_team = arrR(3, ari)

						If ari = 0 Then
							updateseq = u_seq
							updatefld = " jidx" &i& "=" & u_jidx & ", name"&i&" = '"&u_name&"' ,jteam"&i&"= '"&u_team&"' "
						Else
							updateseq = updateseq & "," & u_seq
							updatefld  =  updatefld & ", jidx" &i& "=" & u_jidx & ", name"&i&" = '"&u_name&"' ,jteam"&i&"= '"&u_team&"' "
						End if

					i = i + 1
					Next
				End If
				
				If isArray(arrT) = true then
					For ari = LBound(arrT, 2) To UBound(arrT, 2)
						U_seq = arrT(0,ari)
						u_jidx = arrT(1, ari)
						u_name= arrT(2, ari)
						u_team = arrT(3, ari)

						If updatefld = "" then
							updateseq = u_seq
							updatefld = " jidx" &i& "=" & u_jidx & ", name"&i&" = '"&u_name&"' ,jteam"&i&"= '"&u_team&"' "
						Else
							updateseq = updateseq & "," & u_seq
							updatefld  =  updatefld & ", jidx" &i& "=" & u_jidx & ", name"&i&" = '"&u_name&"' ,jteam"&i&"= '"&u_team&"' "
						End if

					i = i + 1
					Next
				End if
				
				SQL = "update sd_gameMember_roundRecord Set  "&updatefld&"    Where tidx = "&tidx&"  And lidx in  ("& lidxs &")	 "
				SQL = SQL & " update sd_gameTitle_judge Set setcnt = setcnt + 1 where seq in ("&updateseq&") "
				Call db.execSQLRs(SQL , null, ConStr)		
			End Sub

		
			'심판 변경	
			Sub setChangeJudge( tidx,lidxs     ,jidx,targetjidx, myfldno, targetfldno ,cdc, gameround           ,ByRef db,ByRef ConStr,CDA) 
				Dim SQL ,rs, teamp1,teamp2,teamp3,gameroundwhere
				
				'CDC  =  "04"   "06"   "12") And  r = 2,3,4,5 테크 엘리먼트 5까지 하나처럼
				If cdc = "04" Then '솔로만 변경하니까.
					gameroundwhere = " and gameround in (1,2,3,4,5) "
				Else
					gameroundwhere = " and gameround = " & 	gameround				
				End if


				If targetfldno = "" Then '같은부에서의 변경이아니라면
					SQL = " Select top 1 jseq,name,team  from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&CDA&"' and jseq = " & targetjidx
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rs.eof then
						SQL = "update sd_gameMember_roundRecord Set  jidx"&myfldno&"= "&rs(0)&", name"&myfldno&" ='"&rs(1)&"',  jteam"&myfldno&" =  '"&rs(2)&"'    Where tidx = "&tidx&"  And lidx in  ("& lidxs &") " & gameroundwhere
						Call db.execSQLRs(SQL , null, ConStr)
					End if

				Else '같은부서내의 변경

					'변경될곳의 정보 저장해두고
					SQL = " Select top 1 jseq,name,team  from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&CDA&"' and jseq = " & jidx
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rs.eof then
						teamp1 = rs(0)
						teamp2 = rs(1)
						teamp3 = rs(2)
					End if

					
					SQL = " Select top 1 jseq,name,team  from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&CDA&"' and jseq = " & targetjidx
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rs.eof then
						SQL = "update sd_gameMember_roundRecord Set  jidx"&myfldno&"= "&rs(0)&", name"&myfldno&" ='"&rs(1)&"',  jteam"&myfldno&" =  '"&rs(2)&"'    Where tidx = "&tidx&"  And lidx in  ("& lidxs &")  " & gameroundwhere
						SQL = SQL & " update sd_gameMember_roundRecord Set  jidx"&targetfldno&"= "&teamp1&", name"&targetfldno&" ='"&teamp2&"',  jteam"&targetfldno&" =  '"&teamp3&"'    Where tidx = "&tidx&"  And lidx in  ("& lidxs &")  " & gameroundwhere
						Call db.execSQLRs(SQL , null, ConStr)
					End If

				End If
				Set rs = nothing
			End Sub

			'부의 심판들 인덱스리턴
			Function getBooJudge( tidx, lidxs , judgecnt, gameround, ByRef db, ByRef  ConStr)
				Dim i , jidxfld,sql,rs

				For i = 1 To judgecnt
					If i = 1 then
						jidxfld = "Cast(jidx"&i & " as varchar) "
					Else
						jidxfld = jidxfld & " +','+ Cast(jidx"&i & " as varchar) "
					End if
				Next 
				SQL = "select top 1 " & jidxfld & " from sd_gameMember_roundRecord where tidx = "&tidx&" and lidx in ( "&lidxs&") and gameround = "&gameround&" " 
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				getBooJudge = rs(0)
				Set rs = nothing
			End Function

			'라운드완료되었는지 판단.
			Sub judgeExceptionRound(midx,roundno , ByRef db, ByRef  ConStr ,CDA)
				Dim SQL,rs,strjson
				'심판수 체크
				SQL = "Select totalscore from sd_gameMember_roundRecord  where midx = "&midx&" and gameround = "&roundno&" and totalscore > 0 "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
				If rs.eof Then
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "심판 채점이 완료되지 않았습니다." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end
				End If
			End Sub


			'##################################################################
			'점수 소수점으로 반환 합계점수 소수점 2자리 (사용안함 혹사용한곳있으면 빼자)
			Function getE2Value(jumsu)
				Select Case  jumsu
				Case "0",""
					getE2Value = "000.00"
				Case Else
					If isNumeric(jumsu) = True then
							getE2Value = Left(	jumsu, Len(jumsu) - 2) & "." & right(jumsu,2)
					Else
						getE2Value = ""
					End if
				End Select 
			End function

			'점수 소수점으로 반환 (최대 10) 소수점 1자리 
			Function getE2FirstValue(jumsu)
				Select Case  jumsu
				Case "0",""
					getE2FirstValue = "0.0"
				Case Else
					If isNumeric(jumsu) = True then
							getE2FirstValue = Left(	jumsu, Len(jumsu) - 1) & "." & right(jumsu,1)
					Else
						getE2FirstValue = ""
					End if
				End Select 
			End function
			'##################################################################






			'##################################################################
			'라운드 총점 , 전체결과 및 전체 순위 구하기 
			'##################################################################
			Sub setGameResut(lidx, midx, roundno, ByRef db, ConStr)

				'기본정보
				Dim SQL,fld,rs,arrR
				Dim j,ari,r,jumsustartno
				Dim roundcnt,judgecnt,cdb,cdc,tidx,gbidx

				Dim roundidx,gameround,tryoutresult,figuerstotal,rounddeduction,roundout,code1,code2,code3,code4
				Dim jumsuarr(16)			'라운드 심판점수들 담아둘곳
				Dim roundtotalarr(8)		'최대 7라운드 넉넉히 넣어둠
				Dim judgeendcnt(8)		'라운드 심사수
				Dim returnarr
				Dim codearr(4)

				Dim elementarr(4) '엘리먼트경기라운드배열값들
				Dim elementroundarr	'엘리먼트경기 라운드점수
				Dim a_eletotaldeduction '통합엘리먼트 감점
				Dim a_totaldeduction  '토탈감점
				Dim a_elededuction(4)  '각엘리먼트
				Dim a_tktotaldeduction '테크 1라운드 총점에 0.5감점
				a_tktotaldeduction = 0
				a_eletotaldeduction = 0
				a_totaldeduction = 0
				a_elededuction(0) = 0
				a_elededuction(1) = 0
				a_elededuction(2) = 0
				a_elededuction(3) = 0
				a_elededuction(4) = 0				



				SQL = "Select top 1 isnull(RoundCnt,0), isnull(judgeCnt,0) ,cdb,cdc,gametitleidx,gbidx  from tblRGameLevel as L where RgameLevelidx = " & lidx
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					roundcnt = rs(0) '라운드수
					judgecnt = rs(1) '심사위원수

					cdb =  rs(2)	   '부
					cdc =  rs(3)	   '세부종목
					tidx = rs(4)
					gbidx = rs(5)

				Else
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "관련된 정보가 없습니다." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end					
				End If

				'==================================
				'쿼리설명: 선수의 모든라운드 체점점수 + 설정을 가져온다 (최종점수 업데이트 시점확인및 설정으로 순위 업데이트 정보를 생성)
				'==================================
				fld = " b.idx as roundidx"
				For j = 1 To judgeCnt
					fld = fld & "," & " jumsu"&j 
				Next

				fld = fld & " ,gameround , r_deduction , r_out , isNull(totalscore,0) , judgeendcnt  " 'judgeCnt + 1 부터
				fld = fld & " ,c.code1,c.code2,c.code3,   c.code4, codename " '+ 6 부터
				fld = fld & " ,tryoutresult, tryouttotalorder, tryoutorder,figuerstotal " '+ 11부터 최종결과및 전체실격여부 순위 figuerstotal 듀엣, 팀 계산을 위해 추가 
				fld = fld & " ,b.a_eletotaldeduction,b.a_totaldeduction,b.a_elededuction,a_tktotaldeduction " '+ 15

				SQL = "select "&fld&"  from sd_gameMember as a inner join sd_gameMember_roundRecord as b on a.gameMemberIDX = b.midx and a.gameMemberIDX = '"&midx&"' " 
				SQL = SQL &  " left join tblGameCode as c On b.gamecodeseq = c.seq and c.CDA = 'F2' order by  gameround asc "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrR = rs.GetRows()
				Else
					'라운드설정이 안되었다 끝
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "라운드가 설정되지 않았습니다.." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end
				End if

				'Call oJSONoutput.Set("sql", sql ) 'debug
				'Call getrowsdrow(arrR)
				'Response.end

				'===============================
				'선택된 선수의 모든 라운드 총점 처리
				'===============================

				If IsArray(arrR) Then 

					'테크니컬 엘리먼트체점값들#####
					If (CDC  =  "04"  Or CDC  =  "06"  Or CDC  =  "12")  And roundno < 6  Then

						ReDim elementroundarr(judgeCnt/3-1) '엘리먼트경기 라운드점수

						For ari = LBound(arrR, 2) To UBound(arrR, 2)
								gameround = arrR(CDbl(judgeCnt) + 1,ari)						'라운드번호
								Select Case CDbl(gameround)
								Case 1 
									codearr(0) = arrR(CDbl(judgeCnt) + 9 ,ari)							'난이도1
									
									'심판들이 준 점수들
									For j = 0 To judgeCnt/3-1
										elementroundarr(j) = arrR(j+(judgeCnt/3*2+1) ,ari) '엘리먼트 위치를 찾아서..
									Next
									elementarr(0) = elementroundarr
								Case 2 
									codearr(1) = arrR(CDbl(judgeCnt) + 9 ,ari)							'난이도2
									'심판들이 준 점수들
									For j = 0 To judgeCnt/3-1
										elementroundarr(j) = arrR(j+(judgeCnt/3*2+1) ,ari)
									Next
									elementarr(1) = elementroundarr								
								Case 3 
									codearr(2) = arrR(CDbl(judgeCnt) + 9 ,ari)							'난이도3
									'심판들이 준 점수들
									For j = 0 To judgeCnt/3-1
										elementroundarr(j) = arrR(j+(judgeCnt/3*2+1) ,ari)
									Next
									elementarr(2) = elementroundarr
								Case 4 
									codearr(3) = arrR(CDbl(judgeCnt) + 9 ,ari)							'난이도4
									'심판들이 준 점수들
									For j = 0 To judgeCnt/3-1
										elementroundarr(j) = arrR(j+(judgeCnt/3*2+1) ,ari)
									Next
									elementarr(3) = elementroundarr								
								Case 5 
									codearr(4) = arrR(CDbl(judgeCnt) + 9 ,ari)							'난이도5
									'심판들이 준 점수들
									For j = 0 To judgeCnt/3-1
										elementroundarr(j) = arrR(j+(judgeCnt/3*2+1) ,ari)
									Next
									elementarr(4) = elementroundarr
								End Select 
						next
					End If
					'테크니컬 엘리먼트체점값들#####

' Call oJSONoutput.Set("1라운드", elementroundarr ) 'debug
' Call oJSONoutput.Set("1라운드담자", elementarr(0)) 'debug		
' exit sub


					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						roundidx = arrR(0,ari)													'sd_gameMember_roundRecord.idx
						gameround = arrR(CDbl(judgeCnt) + 1,ari)							'라운드번호
						rounddeduction = arrR(CDbl(judgeCnt) + 2,ari)					'감점
						roundout = arrR(CDbl(judgeCnt) + 3,ari)							'실격
						roundtotalarr(gameround) = arrR(CDbl(judgeCnt) + 4 ,ari)	'각라운드 총점들

						judgeendcnt(gameround) = arrR(CDbl(judgeCnt) + 5 ,ari)		'심판판정완료수 0시작전 1~ 끝 심판수

						code1 = arrR(CDbl(judgeCnt) + 6 ,ari)								'난이도번호
						code2 = arrR(CDbl(judgeCnt) + 7 ,ari)								'난이도명
						code4 = arrR(CDbl(judgeCnt) + 9 ,ari)								'난이도
				
						tryoutresult = arrR(CDbl(judgeCnt) + 11 ,ari)						'맴버의 최종결과 (전체적용되는 실격여부도 들어가 있다) ex) D226
						figuerstotal = arrR(CDbl(judgeCnt) + 14 ,ari)						'듀엣, 팀계산을 위해 따로 저장해둔다.
						
						if (cdc = "04" Or cdc = "06" Or cdc = "12") and gameround < 6 then '테크니컬 감점 처리 정보
						a_eletotaldeduction = arrR(CDbl(judgeCnt) + 15 ,ari) '엘리먼트토탈감점
						a_totaldeduction = arrR(CDbl(judgeCnt) + 16 ,ari) '토탈감점
						a_elededuction(gameround-1) = arrR(CDbl(judgeCnt) + 17 ,ari) '각엘리먼트 감점 (5개)
						a_tktotaldeduction = arrR(CDbl(judgeCnt) + 18 ,ari) '테크1 총점 0.5감점

						
						' Call oJSONoutput.Set("테크감점"  , a_eletotaldeduction) 'debug
						' Call oJSONoutput.Set("토탈감점"  , a_totaldeduction) 'debug
						' Call oJSONoutput.Set("엘리먼트각"  , a_elededuction) 'debug
						
						end if
						'===============================
						'선택된 선수의 라운드 처리
						'===============================

							If CStr(roundno) = CStr(gameround) Then '선수의 선택한 라운드
								'심판들이 준 점수들
								jumsustartno = 1
								For j = 1 To judgeCnt
									jumsuarr(j) = arrR(jumsustartno ,ari)
									jumsustartno = jumsustartno + 1
								Next

								'현재라운드총점구하기  (각점수, 심판수, 감점, 실격, 라운드키, 난이율, 부코드,종목코드, 현재라운드)
								returnarr  = getNowRoundTotalScore(tidx,midx,jumsuarr,judgeCnt, rounddeduction, roundout,roundidx,code4,codearr,elementarr,cdb,cdc,gameround,a_eletotaldeduction,a_elededuction,a_tktotaldeduction,   db, ConStr)
								roundtotalarr(gameround)  = returnarr(0)
								judgeendcnt(gameround) = returnarr(1)

								If roundtotalarr(gameround) = 0  Then
									Exit Sub
								End if
							End If
						'===============================
					Next


							'내일 라운드 5가 아니여도 보내서 계산값 넣어두기
							Select Case cdc
							Case "02","03"
							Case "01"
								For j = 1 To 4
									If roundtotalarr(j) = 0 Then
										Exit Sub ''심사 완료 되지 않은 라인이 있다면
									End if
								Next
							case else
								For j = 1 To roundcnt
									If roundtotalarr(j) = 0 Then
										'Call oJSONoutput.Set("라운드" & j, roundtotalarr(j)) 'debug
										Exit Sub ''심사 완료 되지 않은 라인이 있다면
									End if
								Next
							End select
							'Call oJSONoutput.Set("라운드"  , roundtotalarr) 'debug
							'Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
							'Call oJSONoutput.Set("servermsg", "디버깅" ) '서버에서 메시지 생성 전달
							'strjson = JSON.stringify(oJSONoutput)
							'Response.Write strjson
							'Response.End	
							
							'선수의 모든 라운드총점 저장
							Call setMemberScoreTotal(roundtotalarr,judgeendcnt, roundcnt,judgeCnt, midx, tryoutresult,tidx,lidx,cdb,cdc,a_totaldeduction, db, ConStr)

							'순위업데이트
							Call setRankUpdate(tidx,lidx,gbidx, db, ConStr)

				End if

			End Sub


			'@@@@@@@@@@
				'<점수산정 방식>
				'솔로 최종기록: 피겨 점수합+프리루틴 점수합								
				'듀엣 최종기록: 피겨 평균값+프리루틴 점수합								
				'팀 최종기록: 피겨 평균값+프리루틴 점수합

				'피겨 7명심사 : ※ 최저1 - 최고1 제외, 모든 점수 합산 / 5 (제외하고 남은 인원수) * 난이도 = 총 합산 (라운드의 합) / 그룹 난이도 (모든 종목의 난이도 합의 값) * 10 = 전체 점수 결과

				'프리루틴 12, 15 : 
					'1.EXECUTION: (최저1-최고1 제외하고 모든 점수 합산/(제외하고 남은 인원수))*3
					'2.A.I: (최저1-최고1 제외하고 모든 점수 합산/(제외하고 남은 인원수))*4
					'3. Difficulty:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*3
					'-> 1.+2.+3.= 프리루틴 합


				'테크니컬 솔로 최종기록: 테크니컬 점수합+프리루틴 점수합								
				'테크니컬 듀엣 최종기록: 테크니컬 점수합+프리루틴 점수합								
				'테크니컬 팀 최종기록: 테크니컬 점수합+프리루틴 점수합		
				
						'1.EXECUTION: (최저1-최고1 제외하고 모든 점수 합산/(제외하고 남은 인원수))*3																
						'2.IMPRESSION: (최저1-최고1 제외하고 모든 점수 합산/(제외하고 남은 인원수))*3																
						'3-1. ELEMENT1:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT1의 난이도(여기선 2.5)																
						'3-2. ELEMENT2:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT2의 난이도(여기선 2.5)																
						'3-3. ELEMENT3:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT3의 난이도(여기선 3.2)																
						'3-4. ELEMENT4:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT4의 난이도(여기선 1.9)																
						'3-5. ELEMENT5:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT5의 난이도(여기선 2.0)																
						'3-6. [((ELEMENT1~ELEMENT5의 합)*10)/(ELEMENT1~ELEMENT5 난이도의 합:여기선 12.1)]*0.4																			

				'※ 합산결과 값 : 소수 뒷자리 4개까지 표출(5번째 자리에서 반올림)
			'@@@@@@@@@@

			'##################################################################
			'맴버 현재라운드총점구하기 (모든 심사가 되었을때만 들어온다)
			'##################################################################
			Function getNowRoundTotalScore(tidx,midx,jumsuarr,judgeCnt, rounddeduction, roundout ,roundidx, code4,codearr,elementarr, cdb,cdc,gameround,a_eletotaldeduction,a_elededuction,a_tktotaldeduction, ByRef db, ConStr)
				Dim scoreupdate,totalscore,jchkcnt,score,i,j,fld
				Dim sectionscore1, sectionscore2,sectionscore3
				Dim sectionelemnt1,sectionelemnt2,sectionelemnt3,sectionelemnt4,sectionelemnt5,figuerstotal,escorp
				Dim SQL,rs
				Dim arrR ,s_cdc,s_midx,s_membercnt,roundendstr			

				ReDim arr(judgeCnt-1) '심판 1집단 
				Dim arr2
				Dim arr3
				Dim sortarr1,sortarr2,sortarr3
				Dim roundtext
				Dim grouprndno
				Dim grpvalue
				Dim sectioncnt
				Dim memberdeduction '테크 불참감점수
				memberdeduction = 0
				grpvalue = 1
				
				'judgeendcnt = judgeCnt > 라운드실격 에서 처리됨
				scoreupdate = True		'스코어업데이트여부
				totalscore = 0				'라운드 스코어
				jchkcnt = 0					'심판판정수

				sectionscore1 = 0
				sectionscore2 = 0
				sectionscore3 = 0
				sectionelemnt = 0


				'솔로점수를 구한담에 각 듀엣과 팀을 구한다. 
				Select Case cdc
				Case "01","02","03" '피겨 :솔로(Solo) 4:1
					Select Case CDbl(gameround)  '라운드
					Case 1,2,3,4 :	roundtext = "피겨" 
					Case 5 : roundtext = "프리" 
					End Select 
				Case "04","06","12"  '테크니컬 1 : 1
					Select Case CDbl(gameround)
					Case 1,2,3,4,5 : roundtext = "테크니컬"
					Case 6 : roundtext = "프리"
					End Select 
				Case "05","07","11" '프리 : 1
					roundtext = "프리"
				End Select 

				Select Case roundtext
				Case "피겨" '이건 싱글일때만 들어올수 있다.
						'배열갯수로 다시 잘세어서 넣어두고 소팅하자.
						ReDim arr(6)
						For i = 0 To 6 '7명 고정
							arr(i) = isNulldefault(jumsuarr(i+1),"")
							If arr(i) = "" Then
								scoreupdate = False '심판판정전
							Else
								jchkcnt = jchkcnt + 1
							End if
						Next

						If scoreupdate = True Then '모두 판정했다면
							jchkcnt = judgeCnt '모두 판정했다면 설정값으로 저장하자.

							'그룹 난이도 (모든 종목(피겨?)의 난이도 합의 값) 
							SQL = "select sum(cast(code4 as float)) from sd_gameMember_roundRecord as a inner join tblGameCode as b on a.gamecodeseq = seq   where b.delyn= 'N' and   a.midx = "&midx&" and a.gameround in (1,2,3,4) "
							Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
							If rs.eof Then
								grouprndno = 1
							Else
								grouprndno = rs(0)
							End If 

							sortarr1 = sortArray(arr)  'fn_util.asp 	소팅 최저점, 최고점검색을 위해서.
							For i = 0 To ubound(sortarr1) '현재라운드 총점
								If i > 0 And i < ubound(sortarr1) Then '최고 최저 제외 하고
									totalscore = totalscore + (CDbl(sortarr1(i)) / 10) '저장 입력값이 *10되어있음
								End If
							Next

							'Call oJSONoutput.Set("sortarr1", sortarr1 ) 'debug
							'Call oJSONoutput.Set("totalscore", totalscore ) 'debug

							'피겨 7명심사 : ※ 최저1 - 최고1 제외, 모든 점수 합산 / 5 (제외하고 남은 인원수) * 난이도 = (총 합산 (라운드의 합) / (그룹 난이도 (모든 종목(피겨?)의 난이도 합의 값)) * 10) = 전체 점수 결과
							totalscore = FormatNumber(    (((totalscore/ 5) * code4) /  grouprndno)  * 10  ,4 ,0,0,0)  * 10000
						End If

				Case "테크니컬"
							'테크니컬 12, 15 : 
							'배열갯수로 다시 잘세어서 넣어두고 소팅하자. (12심 15심을 3개로 나누자)
							Select Case CDbl(judgeCnt)
							case 12 : sectioncnt = 4 - 1  
							Case 15 : sectioncnt = 5 - 1
							End Select

							ReDim arr(sectioncnt)
							ReDim arr2(sectioncnt)
							ReDim arr3(sectioncnt)

							'EXECUTION **************************************
								For i = 0 To sectioncnt
									arr(i) = isNulldefault(jumsuarr(1 + i),"") '+1 1번부터 배열넣어두었다.
									If arr(i) = "" Then
										scoreupdate = False '심판판정전
									Else
										jchkcnt = jchkcnt + 1
									End if
								Next

								If scoreupdate = True Then
									sortarr1 = sortArray(arr)  'fn_util.asp 	소팅 최저점, 최고점검색을 위해서.
									For i = 0 To ubound(sortarr1) '총점
										If i > 0 And i < ubound(sortarr1) Then '최고 최저 제외 하고
											sectionscore1 = sectionscore1 + (CDbl(sortarr1(i)) / 10) '저장 입력값이 *10되어있음
										End If
									Next
									sectionscore1 = (sectionscore1 / (sectioncnt -1)) * 3
								End if
							'Call oJSONoutput.Set("EXECUTION", sectionscore1)
							'IMPRESSION **************************************
								For i = 0 To sectioncnt
									arr2(i) = isNulldefault(jumsuarr((1 + sectioncnt) + (1+  i)),"")
									If arr2(i) = "" Then
										scoreupdate = False '심판판정전
									Else
										jchkcnt = jchkcnt + 1
									End if
								Next

								If scoreupdate = True Then
									sortarr2 = sortArray(arr2)
									For i = 0 To ubound(sortarr2) 
										If i > 0 And i < ubound(sortarr2) Then
											sectionscore2 = sectionscore2 + (CDbl(sortarr2(i)) / 10)
										End If
									Next
									sectionscore2 = (sectionscore2 / (sectioncnt -1)) * 3
								End if
							'Call oJSONoutput.Set("IMPRESSION", sectionscore2)
							'ELEMENT **************************************
								'엘리먼트 라운드 1 ~ 5
								'심판판정수 체크
'Call oJSONoutput.Set("elementarr", UBound(elementarr) ) '배열								
'getNowRoundTotalScore = Array(0, 0)
'exit function

								escorp = true
								For i = 0 To UBound(elementarr) '이게라운드
									For j= 0 To jchkcnt/3 -1 '심판수이겠지
										If isNull(elementarr(i)(j)) = True Then
											scoreupdate = False '심판판정전
											escorp = False
											'Call oJSONoutput.Set("i-j"&i&"-"&j, elementarr(j)(i))
										End If
									Next
									If escorp = True then
										jchkcnt = jchkcnt + 1
									End if
								Next
		
								If scoreupdate = True Then
									For i = 0 To UBound(elementarr)
										sortarr3 = sortArray(elementarr(i))
										'Call oJSONoutput.Set("엘리먼트배열"& i, sortarr3)
										sectionscore3 = 0
										For j = 0 To ubound(sortarr3) 
											If j > 0 And j < ubound(sortarr3) Then '최저 최고점빼고
												sectionscore3 = sectionscore3 + (CDbl(sortarr3(j)) / 10)  

											End If
										Next
							'Call oJSONoutput.Set("엘리먼트각"& i&j, sectionscore3)										
										sectionelemnt = FormatNumber(   (Cdbl(sectionelemnt) +  (sectionscore3 / (sectioncnt -1)) * codearr(i)) - (a_elededuction(i)/10)   ,4, 0,0,0)  'a_elededuction 각라운드 단계(0.5빼기)
							'Call oJSONoutput.Set("엘리먼트난이도"& i, FormatNumber(   (  (sectionscore3 / (sectioncnt -1)) * codearr(i)) - (a_elededuction(i)/10)   ,4, 0,0,0)   )
									Next 

								End if

							'점수계산법
								'1.EXECUTION: (최저1-최고1 제외하고 모든 점수 합산/(제외하고 남은 인원수))*3																
								'2.IMPRESSION: (최저1-최고1 제외하고 모든 점수 합산/(제외하고 남은 인원수))*3																
								'3-1. ELEMENT1:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT1의 난이도(여기선 2.5)																
								'3-2. ELEMENT2:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT2의 난이도(여기선 2.5)																
								'3-3. ELEMENT3:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT3의 난이도(여기선 3.2)																
								'3-4. ELEMENT4:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT4의 난이도(여기선 1.9)																
								'3-5. ELEMENT5:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*ELEMENT5의 난이도(여기선 2.0)																
								'3-6. [((ELEMENT1~ELEMENT5의 합)*10)/(ELEMENT1~ELEMENT5 난이도의 합:여기선 12.1)]*0.4	
							'점수계산법
							If scoreupdate = True Then
								sectionscore3 =  (sectionelemnt*10) / (Cdbl(codearr(0)) + Cdbl(codearr(1)) + Cdbl(codearr(2)) + Cdbl(codearr(3)) + Cdbl(codearr(4))) * 0.4

								sectionscore3 =  FormatNumber(Cdbl(sectionscore3) - (a_eletotaldeduction/10),4 ,0,0,0) '엘리먼트 총감점
 								'Call oJSONoutput.Set("ELEMENT", sectionscore3)

								if cdc = "12" then '단체(팀)
								SQL = "select count(*) from sd_gameMember_partner where gamememberidx = " & midx
								Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
								memberdeduction  = 8 - Cdbl(rs(0)) * 0.5
								end if
								'1.+2.+3.=  합 (테크니컬 계산)
								totalscore = FormatNumber(  (Cdbl(sectionscore1) + Cdbl(sectionscore2) + Cdbl(sectionscore3)) - Cdbl(memberdeduction) - Cdbl(a_tktotaldeduction/10) , 4   ,0,0,0)  * 10000 '맴버감점 빼기
							End If



				Case "프리"
							'프리루틴 12, 15 : 
							'배열갯수로 다시 잘세어서 넣어두고 소팅하자. (12심 15심을 3개로 나누자)
							Select Case CDbl(judgeCnt)
							case 12 : sectioncnt = 4 - 1  
							Case 15 : sectioncnt = 5 - 1
							End Select

							ReDim arr(sectioncnt)
							ReDim arr2(sectioncnt)
							ReDim arr3(sectioncnt)

							For i = 0 To sectioncnt
								arr(i) = isNulldefault(jumsuarr(1 + i),"") '+1 1번부터 배열넣어두었다.
								If arr(i) = "" Then
									scoreupdate = False '심판판정전
								Else
									jchkcnt = jchkcnt + 1
								End if
							Next

							For i = 0 To sectioncnt
								arr2(i) = isNulldefault(jumsuarr((1 + sectioncnt) + (1+  i)),"")
								If arr2(i) = "" Then
									scoreupdate = False '심판판정전
								Else
									jchkcnt = jchkcnt + 1
								End if
							Next
							For i = 0 To sectioncnt
								arr3(i) = isNulldefault(jumsuarr((1 + sectioncnt) * 2 + (1 +i)),"")
								If arr3(i) = "" Then
									scoreupdate = False '심판판정전
								Else
									jchkcnt = jchkcnt + 1
								End if
							next		

							If scoreupdate = True Then '모두 판정했다면

								sortarr1 = sortArray(arr)  'fn_util.asp 	소팅 최저점, 최고점검색을 위해서.
								sortarr2 = sortArray(arr2)
								sortarr3 = sortArray(arr3)

								'1.EXECUTION: (최저1-최고1 제외하고 모든 점수 합산/(제외하고 남은 인원수))*3
								'2.A.I: (최저1-최고1 제외하고 모든 점수 합산/(제외하고 남은 인원수))*4
								'3. Difficulty:((최저1-최고1 제외하고 모든 점수 합산)/(제외하고 남은 인원수))*3

								For i = 0 To ubound(sortarr1) '총점
									If i > 0 And i < ubound(sortarr1) Then '최고 최저 제외 하고
										sectionscore1 = sectionscore1 + (CDbl(sortarr1(i)) / 10) '저장 입력값이 *10되어있음
									End If
								Next
								sectionscore1 = (sectionscore1 / (sectioncnt -1)) * 3

								For i = 0 To ubound(sortarr2) 
									If i > 0 And i < ubound(sortarr2) Then
										sectionscore2 = sectionscore2 + (CDbl(sortarr2(i)) / 10)
									End If
								Next
								sectionscore2 = (sectionscore2 / (sectioncnt -1)) * 4

								For i = 0 To ubound(sortarr3) 
									If i > 0 And i < ubound(sortarr3) Then 
										sectionscore3 = sectionscore3 + (CDbl(sortarr3(i)) / 10) 
									End If
								Next
								sectionscore3 = (sectionscore3 / (sectioncnt -1)) * 3

								'Call oJSONoutput.Set("sectionscore1",  sectionscore1) 'debug

								if cdc = "12" then '단체(팀)
								SQL = "select count(*) from sd_gameMember_partner where gamememberidx = " & midx
								Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
								memberdeduction  = 8 - Cdbl(rs(0)) * 0.5
								end if
								'-> 1.+2.+3.= 프리루틴 합
								totalscore = FormatNumber(  (sectionscore1 + sectionscore2 + sectionscore3) - memberdeduction , 4   ,0,0,0)  * 10000 '맴버감점 빼기
								
							End if

				End Select 

				'점수다아직안줌
				If scoreupdate = false Then
					totalscore = 0
				'else
				'	roundendstr = ",roundend='Y' "
				End If


				Select Case CDC
				Case "04","06","12"
					If gameround < 6 Then
					SQL = "Update sd_gameMember_roundRecord set judgeendcnt = "&jchkcnt&" , totalscore = " & totalscore  & "  where  midx  = "&midx&"  and gameround in (1,2,3,4,5)  "				
					Call db.execSQLRs(SQL , null, ConStr)
					Else
					SQL = "Update sd_gameMember_roundRecord Set judgeendcnt = "&jchkcnt&" , totalscore = " & totalscore  & "  where idx = " & roundidx
					Call db.execSQLRs(SQL , null, ConStr)
					End If
				Case "01"

						'1. 일딴 솔로 저장
						SQL = "Update sd_gameMember_roundRecord Set judgeendcnt = "&jchkcnt&" , totalscore = " & totalscore  & "  where idx = " & roundidx
						Call db.execSQLRs(SQL , null, ConStr)
						
						If gameround < 5 Then	'듀엣과 팀을 찾아서 같은라운드에다가 ...
							 
							 '듀엣 팀의 멤버 솔로 gamememberidx  (현재 내가 속한 듀엣과 팀을 가져와야한다)
							 SQL = ""
							 SQL = SQL & ";with tbl as (  "
							 SQL = SQL & " Select a.gamememberidx as midx,a.cdc,  "
							 SQL = SQL & "  case when a.cdc = '01' then  "
							 SQL = SQL & "	a.playeridx  "
							 SQL = SQL & " else  "
							 SQL = SQL & "	b.playeridx	 "
							 SQL = SQL & " end as pidx  "
							 SQL = SQL & " from sd_gamemember as a left join sd_gameMember_partner as b on a.gameMemberIDX = b.gameMemberIDX and b.delyn='N'  "
							 SQL = SQL & " where a.GameTitleIDX = "&tidx&" and a.cda = 'F2' and a.cdb = '"&cdb&"' and a.cdc in ('01','02','03')  and a.delyn = 'N'  )  "

							 SQL = SQL & " select cdc,midx from tbl where pidx = (select top 1 pidx from tbl where midx = "&midx&") and cdc in ('02','03')  "
							 Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

							If Not rs.EOF Then
								arrR = rs.GetRows()

								For ari = LBound(arrR, 2) To UBound(arrR, 2)
									s_cdc = arrR(0,ari)
									s_midx = arrR(1,ari) '듀엣 midx, 팀 midx
									
									Select Case  s_cdc
									
									case "02"  '듀엣
										'각맴버결과중 실격이 있다면 그냥 result에 실격처리
										SQL = "select max(membercnt) from sd_gameMember_roundRecord where midx = " & s_midx
										Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
										s_membercnt = rs(0)

										SQL = "SELECT  STUFF(( select ','+ cast(gameMemberIDX as varchar)  from sd_gamemember where  GameTitleIDX = "&tidx&" and cda = 'F2' and cdb = '"&cdb&"' and cdc = '01' and "
										SQL = SQL & " playeridx  in (select playeridx from sd_gameMember_partner where gameMemberIDX = "&s_midx&" ) group by gameMemberIDX for XML path('') ),1,1, '' ) "
										Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
										If isNull(rs(0)) = False Then

											SQL = "select isNull(sum(totalscore), 0 ) ,count(*)  from sd_gameMember_roundRecord where totalscore > 0 and midx in ( "&rs(0)&") and gameround = " & gameround
											Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

											'If CDbl(rs(1)) >= CDbl(s_membercnt) Then '두명이 다 채점시에만 저장(? 0점을 준경우와 점준안준상태로 실격이 있다면 무용지물 )
												SQL = "Update sd_gameMember_roundRecord Set totalscore = " & rs(0) & "  where midx = "&s_midx&" and gameround = " & gameround
												Call db.execSQLRs(SQL , null, ConStr)
											'End if
										End if

									Case "03" '팀
										'개별 맴버의 실격갯수를 가져와야한다.
										SQL = "select max(membercnt) from sd_gameMember_roundRecord where midx = " & s_midx
										Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
										s_membercnt = rs(0)

										SQL = "SELECT  STUFF(( select ','+ cast(gameMemberIDX as varchar)  from sd_gamemember where  GameTitleIDX = "&tidx&" and cda = 'F2' and cdb = '"&cdb&"' and cdc = '01' and "
										SQL = SQL & " playeridx  in (select playeridx from sd_gameMember_partner where gameMemberIDX = "&s_midx&" ) group by gameMemberIDX for XML path('') ),1,1, '' ) "
										Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
										If isNull(rs(0)) = False Then

											SQL = "select isNull(sum(totalscore), 0 ) ,count(*)  from sd_gameMember_roundRecord where totalscore > 0 and midx in ("&rs(0)&") and gameround = " & gameround '솔로의 값들이다 잊지말자.
											Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

											'If CDbl(rs(1)) >= CDbl(s_membercnt) Then 
												SQL = "Update sd_gameMember_roundRecord Set totalscore = " & rs(0) & "  where midx = "&s_midx&" and gameround = " & gameround
												Call db.execSQLRs(SQL , null, ConStr)
											'End if
										End If
										
									End Select 
								Next
							End If

						End If
						
				Case Else

				SQL = "Update sd_gameMember_roundRecord Set judgeendcnt = "&jchkcnt&" , totalscore = " & totalscore  & "  where idx = " & roundidx
				Call db.execSQLRs(SQL , null, ConStr)
				End Select

				'Call oJSONoutput.Set("totalscore", totalscore)
				'Call oJSONoutput.Set("jchkcnt", jchkcnt)

				'Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
				'Call oJSONoutput.Set("servermsg", "디버깅" ) '서버에서 메시지 생성 전달
				'strjson = JSON.stringify(oJSONoutput)
				'Response.Write strjson
				'Response.End

				getNowRoundTotalScore = Array(totalscore, jchkcnt)
			End Function


			'##################################################################
			'맴버의 총 라운드총점 저장 (모든라인이 심사되었다면 넘어온다)   'judgeendcnt 각라운드 심판처리된 횟수배열
			'##################################################################
			Sub setMemberScoreTotal(roundtotalarr, judgeendcnt, roundcnt,judgeCnt, midx, tryoutresult,tidx,lidx,cdb,cdc,a_totaldeduction,  ByRef db, ConStr)
				Dim gametotal, gametotallen,prezero,figuerstotal,freetotal,membercnt,deduction,outmembercnt
				Dim SQL,rs,arrR,ari,i,p
				outmembercnt = 0
				membercnt = 0
				deduction = 0

				'If isNumeric(tryoutresult) = False Then '듀엣이랑 팀집계할려면 패스해야할꺼같은데 > 피겨는 다음에 또하므로 막으면 된다. ㅡㅡ
				'	전체실격임 점수 저장하지 않아...
				'	Exit sub
				'End If

				gametotal = 0
				figuerstotal = 0 '피겨총점
				For i = 1 To roundcnt
					
					If CDC="02" Or cdc="03"   Or  (CDbl(judgeendcnt(i)) =  CDbl(judgeCnt)) then

						Select Case cdc
						Case "01","02","03" '피겨솔로
							gametotal  = gametotal + FormatNumber(roundtotalarr(i),0,0,0,0)
							if i < 5 then
								figuerstotal = figuerstotal + FormatNumber(roundtotalarr(i),0,0,0,0) '피겨 듀스 팀 평균을 구할려면 프리를 뺀값을 따로 저장해두어야할것 같다. (1~4라운드까지)
							Else
								If FormatNumber(roundtotalarr(i),0) = 0 Then
									gametotal = 0
								Else
									freetotal = FormatNumber(roundtotalarr(i),0,0,0,0)
								End if
							End If
						Case "04","06","12"  '테크니컬 1 : 1
							If i = 1 Or i = 6 Then 
								gametotal  = gametotal + FormatNumber(roundtotalarr(i),0,0,0,0)
							End if
						Case Else
							gametotal  = gametotal + FormatNumber(roundtotalarr(i),0,0,0,0)	
						End Select
					Else
						gametotal = 0
						Exit for
					End If
					
				Next

				
				'결과저장
				If isNumeric(tryoutresult) = False Then '실격상태
					SQL = "update SD_gameMember Set tryoutresult  = '"&tryoutresult&"',figuerstotal= '"&figuerstotal&"' , tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx
					Call db.execSQLRs(SQL , null, ConStr)

				
				Else
					Select Case CDC
					Case "02"
						figuerstotal = FormatNumber(CDbl(figuerstotal) / 2, 0,0,0,0) '평균
						gametotal = FormatNumber(CDbl(figuerstotal) + freetotal,0 ,0,0,0)
						SQL = "update SD_gameMember Set tryoutresult  = '"&gametotal&"',figuerstotal= '"&figuerstotal&"' , tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx			
						Call db.execSQLRs(SQL , null, ConStr)

					Case "03"

						'개별 맴버수와 실격갯수를 가져와야한다.
						SQL = " select tryoutresult from sd_gameMember where gameMemberIDX in (select midx from sd_gameMember_roundRecord where tidx = "&tidx&" and cdb = "&cdb&" and cdc = '01' group by midx) "
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						If Not rs.EOF Then
							arrR = rs.GetRows()
						End if

						If IsArray(arrR) Then 
							For ari = LBound(arrR, 2) To UBound(arrR, 2)
								membercnt = membercnt + 1
								If isNumeric(arrR(0,ari)) = false Then '개인전기권
										outmembercnt = outmembercnt + 1
								End If
							Next
						End if

						'1명당 0.5씩 감점
						deduction = (outmembercnt * 0.5) * 10000

						figuerstotal = FormatNumber(CDbl(figuerstotal) / (membercnt -outmembercnt) , 0,0,0,0) '평균
						gametotal = FormatNumber(CDbl(figuerstotal) + CDbl(freetotal) - deduction,0,0,0,0)
						SQL = "update SD_gameMember Set tryoutresult  = '"&gametotal&"',figuerstotal= '"&figuerstotal&"' , tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx			
						Call db.execSQLRs(SQL , null, ConStr)

					
					case "04","06","12" '테크팀
						'총점에서 감점
						SQL = "update SD_gameMember Set tryoutresult  = '"& gametotal-(a_totaldeduction/10*10000) &"',figuerstotal= '"&figuerstotal&"' , tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx			
						Call db.execSQLRs(SQL , null, ConStr)					
					Case else
						SQL = "update SD_gameMember Set tryoutresult  = '"&gametotal&"',figuerstotal= '"&figuerstotal&"' , tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx			
						Call db.execSQLRs(SQL , null, ConStr)
					End Select
				End If


			End Sub


			'##################################################################			
			'부의 랭킹 업데이트 (개인, 단체 , 혼성, 여부를 결정해서 넣어줘야할꺼같다. gbidx만으로 구분이 안된다.
			'##################################################################
			Sub setRankUpdate(tidx,lidx, gbidx,  ByRef  db, ConStr)
				Dim SQL,rs,arrR,wherestr,Selecttbl,rtvalue,rankupdate

				rankupdate = true
				SQL = "select tryoutresult from SD_gameMember  where gametitleidx = " & tidx & " and gbidx = '"&gbidx&"' and delyn = 'N' "  '참여인원...집계여부
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrR = rs.GetRows()
				Else
					rankupdate = false
				End if

' Call oJSONoutput.Set("랭킹", arrR)
' Call oJSONoutput.Set("rankupdate", rankupdate)


				If IsArray(arrR) Then 
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						rtvalue = arrR(0,ari)
						If isNumeric(rtvalue) = True Then '전체 기권이 아니고
							If CDbl(rtvalue)  = 0 Then  '개인점수가 완료되지 않았다면
								'순위 업데이트 하지 않는다.
								rankupdate = false
							End if
						End If
					Next
				End if


				'랭킹업데이트 해야할시점체크
				If rankupdate = True then
					wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"'  and tryoutresult > 0  and tryoutresult < 'a'  " '업데이트 대상
					Selecttbl = "( SELECT tryouttotalorder, RANK() OVER (Order By cast(tryoutresult as int) desc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
					SQL = "UPDATE A  SET A.tryouttotalorder = A.RowNum FROM " & selecttbl
					Call db.execSQLRs(SQL , null, ConStr)
				End if

			End Sub 

		'%%%%%%%%%%%%%%%%%
%>