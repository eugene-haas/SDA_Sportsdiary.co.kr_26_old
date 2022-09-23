<%
    '####################################################
    '부가 종료되었다면 결과끝 저장
    '####################################################    
		Sub setBooEnd(grouplevelidx,lidxs,lidx,midx,judgeCnt,refreeno, ByRef db, ConStr)
        dim tbl,i,infldstr,invaluestr,updatefldstr,booend
        dim SQL,rs

				tbl = " SD_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and b.delYN='N' inner join sd_gameMember_roundRecord as c on a.gamememberidx = c.midx "
				SQL = "select top 1 a.gamememberidx  from "&tbl&" where a.delyn = 'N' and b.RgameLevelidx in ( " & lidxs & ") and c.jumsu"&refreeno&"	 is Null "		
				SQL = SQL & " and a.gubun in (1,3) and a.tryoutsortno > 0 and a.tryoutResult < 'a' "
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				'Call oJSONoutput.Set("쿼리", SQL )



         if rs.eof then '결과가 안나온게 있다면 
            
             '인서트 또는 업데이트 'tblRgameLevel_judgeEndCheck 끝인지 판단해서 1~15까지 N > Y
             SQL = "select RGameLevelidx from tblRgameLevel_judgeEndCheck where RGameLevelidx = " & lidx
             Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

             '기권 (전체), 개별심판 각심판번호만
             for i = 1 to judgeCnt
              
              if Cdbl(refreeno) = i then
                booend = 0
              else
                booend = 1
              end if

              infldstr = infldstr & ",judge_endchk" & i
              invaluestr = invaluestr & ",'"&booend&"' "
							
							if Cdbl(refreeno) = i then 
								updatefldstr = "judge_endchk" & i & " = case when  judge_endchk" & i & " = 0 then 0 else judge_endchk" & i & " - 1 end "
							end if

             next

             if rs.eof then
               SQL = "insert into tblRgameLevel_judgeEndCheck (RGameLevelidx "&infldstr&") values ( "&lidx&" "&invaluestr&" )"
               Call db.execSQLRs(SQL , null, ConStr)
             else
               SQL = "update tblRgameLevel_judgeEndCheck set " & updatefldstr & " where RGameLevelidx = " & lidx
               Call db.execSQLRs(SQL , null, ConStr)			
             end if
Call oJSONoutput.Set("쿼리", SQL )
'Call oJSONoutput.Set("심판번호", SQL )
'Call oJSONoutput.Set("심판수", judgeCnt )
         end if
      
      end sub







		'%%%%%%%%%%%%%%%%%
			'감점,실격정보 가져오기#####################
			Function getRndDeduction(lidxs ,ByRef db, ConStr)
				Dim SQL, rs,strjson
				SQL = "select midx,r_deduction,r_out,gameround,rounding   from  sd_gameMember_roundRecord  where  lidx in ("&lidxs&") " 
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
				Dim returnarr(8)
				lidxsquery = "(SELECT  STUFF(( select ','+ cast(RgameLevelidx as varchar) from tblRGameLevel where (grouplevelidx is not null and grouplevelidx = L.grouplevelidx) or  RgameLevelidx = "&lidx&" group by RgameLevelidx for XML path('') ),1,1, '' ))"
				SQL = "Select top 1 isNull(grouplevelidx, 0) , isnull(RoundCnt,0), isnull(judgeCnt,0) , "&lidxsquery&",cdc,gametitleidx,cdbnm,cdcnm  from tblRGameLevel as L where RgameLevelidx = " & lidx
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrI = rs.GetRows()
				End If

				'Call getrowsdrow(arrI)
				'Response.write sql
				'response.end

				If IsArray(arrI) Then
					For ari = LBound(arrI, 2) To UBound(arrI, 2)

						returnarr(0) = arrI(0,ari) '그룹 묶음 
						returnarr(1) =  arrI(1,ari)  '라운드수
						returnarr(2) =  arrI(2,ari)   '심사위원수
						returnarr(3) = arrI(3,ari) 'lidx 들
						returnarr(4) = arrI(4,ari) 'CDC 상세코드
						returnarr(5) = arrI(5,ari) 

						returnarr(6) = arrI(6,ari) 
						returnarr(7) = arrI(7,ari) 												

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
						Call oJSONoutput.Set("servermsg", "심사된 기록이 있어 초기화 할수 없습니다."  ) '서버에서 메시지 생성 전달
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
				Dim SQL
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
			Sub setChangeJudge( tidx,lidxs     ,jidx,targetjidx, myfldno, targetfldno               ,ByRef db,ByRef ConStr,CDA)
				Dim SQL ,rs, teamp1,teamp2,teamp3
				
				If targetfldno = "" Then '같은부에서의 변경이아니라면
					SQL = " Select top 1 jseq,name,team  from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&CDA&"' and jseq = " & targetjidx
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rs.eof then
						SQL = "update sd_gameMember_roundRecord Set  jidx"&myfldno&"= "&rs(0)&", name"&myfldno&" ='"&rs(1)&"',  jteam"&myfldno&" =  '"&rs(2)&"'    Where tidx = "&tidx&"  And lidx in  ("& lidxs &")	 "
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
						SQL = "update sd_gameMember_roundRecord Set  jidx"&myfldno&"= "&rs(0)&", name"&myfldno&" ='"&rs(1)&"',  jteam"&myfldno&" =  '"&rs(2)&"'    Where tidx = "&tidx&"  And lidx in  ("& lidxs &")	 "
						SQL = SQL & " update sd_gameMember_roundRecord Set  jidx"&targetfldno&"= "&teamp1&", name"&targetfldno&" ='"&teamp2&"',  jteam"&targetfldno&" =  '"&teamp3&"'    Where tidx = "&tidx&"  And lidx in  ("& lidxs &")	 "
						Call db.execSQLRs(SQL , null, ConStr)
					End If

				End If
				Set rs = nothing
			End Sub

			'부의 심판들 인덱스리턴
			Function getBooJudge( tidx, lidxs , judgecnt, ByRef db, ByRef  ConStr)
				Dim i , jidxfld,sql,rs

				For i = 1 To judgecnt
					If i = 1 then
						jidxfld = "Cast(jidx"&i & " as varchar) "
					Else
						jidxfld = jidxfld & " +','+ Cast(jidx"&i & " as varchar) "
					End if
				Next 
				SQL = "select top 1 " & jidxfld & " from sd_gameMember_roundRecord where tidx = "&tidx&" and lidx in ( "&lidxs&")"


				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				getBooJudge = rs(0)
				Set rs = nothing
			End Function



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

				Dim roundidx,gameround,tryoutresult,rounddeduction,roundout,code1,code2,code3,code4
				Dim jumsuarr(16)			'라운드 심판점수들 담아둘곳
				Dim roundtotalarr(8)		'최대 7라운드(다이빙) 넉넉히 넣어둠
				Dim judgeendcnt(8)		'라운드 심사수
				Dim returnarr

				SQL = "Select top 1 isnull(RoundCnt,0), isnull(judgeCnt,0) ,cdb,cdc,gametitleidx,gbidx  from tblRGameLevel as L where RgameLevelidx = " & lidx
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					roundcnt = rs(0) '라운드수
					judgecnt = rs(1) '심사위원수
					cdb =  rs(2)	   '유년부 3라운드까지 난이율고정 (개인전)
					cdc =  rs(3)	   '싱크로다이빙 24,25
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
				'쿼리설명: 선수의 모둔라운드 체점점수 + 설정을 가져온다 (최종점수 업데이트 시점확인및 설정으로 순위 업데이트 정보를 생성)
				'==================================
				fld = " b.idx as roundidx"
				For j = 1 To judgeCnt
					fld = fld & "," & " jumsu"&j 
				Next

				fld = fld & " ,gameround , r_deduction , r_out , isNull(totalscore,0) , judgeendcnt  " 'judgeCnt + 1 부터
				fld = fld & " ,c.code1,c.code2,c.code3,c.code4,codename " '+ 6 부터
				fld = fld & " ,tryoutresult, tryouttotalorder, tryoutorder " '+ 11부터 최종결과및 전체실격여부 순위

				SQL = "select "&fld&"  from sd_gameMember as a inner join sd_gameMember_roundRecord as b on a.gameMemberIDX = b.midx and a.gameMemberIDX = '"&midx&"' " 
				SQL = SQL &  " left join tblGameCode as c On b.gamecodeseq = c.seq and c.CDA = 'E2' order by  gameround asc "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrR = rs.GetRows()
				Else
					'라운드설정이 안되었다 끝
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "라운드가 설정되지 않았습니다." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end
				End if


				'Call getrowsdrow(arrR)
				'Response.end

					'debug print##########################
					'Call oJSONoutput.Set("여기부터", "머쩜" )
					'debug print##########################

				'===============================
				'선택된 선수의 모든 라운드 총점 처리
				'===============================
				If IsArray(arrR) Then 
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						roundidx = arrR(0,ari)													'sd_gameMember_roundRecord.idx
						gameround = arrR(CDbl(judgeCnt) + 1,ari)							'라운드번호
						rounddeduction = arrR(CDbl(judgeCnt) + 2,ari)					'감점
						roundout = arrR(CDbl(judgeCnt) + 3,ari)							'실격
						roundtotalarr(gameround) = arrR(CDbl(judgeCnt) + 4 ,ari)	'각라운드 총점들
						judgeendcnt(gameround) = arrR(CDbl(judgeCnt) + 5 ,ari)		'심판판정완료수 0시작전 1~ 끝 심판수

						code1 = arrR(CDbl(judgeCnt) + 6 ,ari)
						code2 = arrR(CDbl(judgeCnt) + 7 ,ari)
						code3 = arrR(CDbl(judgeCnt) + 8 ,ari)
						code4 = arrR(CDbl(judgeCnt) + 9 ,ari)								'난이율

						tryoutresult = arrR(CDbl(judgeCnt) + 11 ,ari)						'맴버의 최종결과 (전체적용되는 실격여부도 들어가 있다) ex) D226

						
						'===============================
						'선택된 선수의 라운드 처리
						'===============================

					'debug print##########################
					'Call oJSONoutput.Set(ari, roundno & " " & gameround )
					'debug print##########################

							If CStr(roundno) = CStr(gameround) Then '선수의 선택한 라운드
								'심판들이 준 점수들
								jumsustartno = 1
								For j = 1 To judgeCnt
									jumsuarr(j) = arrR(jumsustartno ,ari)
								jumsustartno = jumsustartno + 1
								Next

					'debug print##########################
'					Call oJSONoutput.Set(ari, gameround )
					'debug print##########################

								'현재라운드총점구하기  (각점수, 심판수, 감점, 실격, 라운드키, 난이율, 부코드,종목코드, 현재라운드)
								returnarr  = getNowRoundTotalScore(jumsuarr,judgeCnt, rounddeduction, roundout,roundidx,code4,cdb,cdc,gameround,  db, ConStr)
								roundtotalarr(gameround)  = returnarr(0)
								judgeendcnt(gameround) = returnarr(1)

							End If
						'===============================
					Next

							'선수의 모든 라운드총점 저장
							Call setMemberScoreTotal(roundtotalarr,judgeendcnt, roundcnt,judgeCnt, midx, tryoutresult, db, ConStr)

							'순위업데이트
							Call setRankUpdate(tidx,gbidx, db, ConStr)

				End if

			End Sub




			'<점수산정 방식>
			'1. 개인 5심사		 : 최저1 - 최고1 제외, 모든 점수 합산 * 난이도 = 총 합산 (라운드)
			'2. 개인 7심사		 : 최저1 - 최고1 제외, 모든 점수 합산 * 난이도 = 총 합산 (라운드)

			'3. 단체 9심사		 : 최저2 - 최고2 제외(심사1~4중), 모든 점수 합산 * 난이도 * 0.6 = 총 합산 (라운드)
			'4. 단체 11심사	 : 최저2 - 최고2 제외, 모든 점수 합산 * 난이도 * 0.6 = 총 합산 (라운드)
			'5. 팀경기 9심사	 : 최저2 - 최고2 제외, 모든 점수 합산 * 난이도 * 0.6 = 총 합산 (라운드)
			'6. 팀경기 11심사	 : 최저2 - 최고2 제외, 모든 점수 합산 * 난이도 * 0.6 = 총 합산 (라운드)

			'7. 단체, 팀경기	 : 1,2라운드 종목은 난이도 2.0 고정
			'8. 감점은 각심사점수에서 -2점 해준다.
			'9. 개인전에서 유년부는 1라운드 2라운드 3라운드 난이율 1.0고정
			
			'단체(싱크로다이빙), 팀경기(싱크로다이빙 혼성) 남여

			'맴버 현재라운드총점구하기 
			Function getNowRoundTotalScore(jumsuarr,judgeCnt, rounddeduction, roundout ,roundidx,code4,cdb,cdc,gameround, ByRef db, ConStr)
				Dim scoreupdate,totalscore,jchkcnt,score,i
				Dim SQL,rs
				
				ReDim arr(judgeCnt-1)
				Dim arr2
				Dim arr3
				Dim sortarr1,sortarr2,sortarr3
				Dim grpvalue
				grpvalue = 1
				
				'judgeendcnt = judgeCnt > 라운드실격 에서 처리됨
				scoreupdate = True		'스코어업데이트여부
				totalscore = 0				'라운드 스코어
				jchkcnt = 0					'심판판정수


				Select Case CDbl(judgeCnt)
				Case 5 '개인

					'CDB    S	남자유년부   T	여자유년부 1.0
					If (cdb = "S" Or cdb = "T") and CDbl(gameround) < 4 Then
						code4 = 1
					End if

					'배열갯수로 다시 잘세어서 넣어두고 소팅하자.
					For i = 0 To judgeCnt -1
						arr(i) = isNulldefault(jumsuarr(i+1),"")
						If arr(i) = "" Then
							scoreupdate = False '심판판정전
						End if
					Next

					'값중에 빈값이 있다면
					If scoreupdate = True then
						'소팅 최저점, 최고점검색을 위해서.
						sortarr1 = sortArray(arr)  'fn_util.asp

						For i = 0 To ubound(sortarr1) '현재라운드 총점
							jchkcnt = jchkcnt + 1
							
							' i = 0 , i = ubound(sortarr1) 일때꺼 빼고
							If i > 0 And i < ubound(sortarr1) Then
								score = ( CDbl(sortarr1(i)) - (rounddeduction * 10) )
								If score < 0 Then
									score = 0
								End if
								totalscore = totalscore + score  '각점수에서 감점한다. (-점수이면 0점처리한다)
							End If
						Next
					End if

				Case 7 '개인

					'CDB    S	남자유년부   T	여자유년부 1.0
					If (cdb = "S" Or cdb = "T") and CDbl(gameround) < 4 Then
						code4 = 1
					End if

					'배열갯수로 다시 잘세어서 넣어두고 소팅하자.
					For i = 0 To judgeCnt -1
						arr(i) = isNulldefault(jumsuarr(i+1),"")
						If arr(i) = "" Then
							scoreupdate = False '심판판정전
						End if
					Next

					'값중에 빈값이 있다면
					If scoreupdate = True then
						'소팅 최저점, 최고점검색을 위해서.
						sortarr1 = sortArray(arr)  'fn_util.asp

						For i = 0 To ubound(sortarr1) '현재라운드 총점
							jchkcnt = jchkcnt + 1
							
							' i = 0 , i = ubound(sortarr1) 일때꺼 빼고
							If i > 1 And i < ubound(sortarr1)-1 Then
								score = ( CDbl(sortarr1(i)) - (rounddeduction * 10) )
								If score < 0 Then
									score = 0
								End if
								totalscore = totalscore + score  '각점수에서 감점한다. (-점수이면 0점처리한다)
							End If
						Next
					End if

					'debug print##########################
					'Call oJSONoutput.Set("arr", arr )
					'Call oJSONoutput.Set("scoreupdate", scoreupdate )
					'debug print##########################

				Case 9 '단체 / 팀 (4:5)로 나누고 각각 2명씩제거 4명
					ReDim arr(3)
					ReDim arr2(4)
					grpvalue = 0.6

					'단체, 팀경기	 : 1,2라운드 종목은 난이도 2.0 고정  S	남자유년부   T	여자유년부 1.0
					If cdc = "S" Or cdc = "T" Then
						If CDbl(gameround) < 4 then
						code4 = 1 '난이율고정
						End if
					Else
						If  CDbl(gameround) < 3 Then
							code4 = 2 '난이율고정
						End if					
					End if


					For i = 0 To 3
						arr(i) = isNulldefault(jumsuarr(1 + i),"")
						If arr(i) = "" Then
							scoreupdate = false
						End if
					Next
					For i = 0 To 4
						arr2(i) = isNulldefault(jumsuarr(5 + i),"")
						If arr2(i) = "" Then
							scoreupdate = false
						End if
					next					

					'debug print##########################
					'Call oJSONoutput.Set("arr", arr )
					'Call oJSONoutput.Set("arr2", arr2 )
					'Call oJSONoutput.Set("scoreupdate", scoreupdate )
					'debug print##########################

					'값중에 빈값이 있다면
					If scoreupdate = True then
						sortarr1 = sortArray(arr)  
						sortarr2 = sortArray(arr2)

						For i = 0 To ubound(sortarr1) '앞에 4개
							jchkcnt = jchkcnt + 1
							
							' i = 0 , i = ubound(sortarr1) 일때꺼 빼고
							If i > 0 And i < ubound(sortarr1) then
								score = ( CDbl(sortarr1(i)) - (rounddeduction * 10) )
								If score < 0 Then
									score = 0
								End if
								totalscore = totalscore + score  '각점수에서 감점한다. (-점수이면 0점처리한다)

							End If
						Next
						For i = 0 To ubound(sortarr2) '뒤에5개
							jchkcnt = jchkcnt + 1
							If i > 0 And i < ubound(sortarr2) then
								score = ( CDbl(sortarr2(i)) - (rounddeduction * 10) )
								If score < 0 Then
									score = 0
								End if
								totalscore = totalscore + score  '각점수에서 감점한다. (-점수이면 0점처리한다)

							End If
						Next
					End if

				Case 11'단체 / 팀 (3:3:3)로 나누고 각각 2명씩제거 6명

					ReDim arr(2)
					ReDim arr2(2)
					ReDim arr3(4)
					grpvalue = 0.6 '단체 * 0.6

					'단체, 팀경기	 : 1,2라운드 종목은 난이도 2.0 고정  S	남자유년부   T	여자유년부 1.0
					If cdc = "S" Or cdc = "T" Then
						If CDbl(gameround) < 4 then
						code4 = 1 '난이율고정
						End if
					Else
						If  CDbl(gameround) < 3 Then
							code4 = 2 '난이율고정
						End if					
					End if

					For i = 0 To 2
						arr(i) = isNulldefault(jumsuarr(1 + i),"")
						If arr(i) = "" Then
							scoreupdate = False '심판판정전
						End if
					Next
					For i = 0 To 2
						arr2(i) = isNulldefault(jumsuarr(4 + i),"")
						If arr2(i) = "" Then
							scoreupdate = False '심판판정전
						End if
					Next
					For i = 0 To 4
						arr3(i) = isNulldefault(jumsuarr(7 +i),"")
						If arr3(i) = "" Then
							scoreupdate = False '심판판정전
						End if
					next								

					'값중에 빈값이 있다면
					If scoreupdate = True then
						sortarr1 = sortArray(arr)  
						sortarr2 = sortArray(arr2)
						sortarr3 = sortArray(arr3)

						For i = 0 To ubound(sortarr1) '앞에 3개
								jchkcnt = jchkcnt + 1
								
								If i > 0 And i < ubound(sortarr1) then
									score = ( CDbl(sortarr1(i)) - (rounddeduction * 10) )
									If score < 0 Then
										score = 0
									End if
									totalscore = totalscore + score  '각점수에서 감점한다. (-점수이면 0점처리한다)
								End If
						Next
						For i = 0 To ubound(sortarr2) '중간3개
								jchkcnt = jchkcnt + 1
								If i > 0 And i < ubound(sortarr2) then
									score = ( CDbl(sortarr2(i)) - (rounddeduction * 10) )
									If score < 0 Then
										score = 0
									End if
									totalscore = totalscore + score  '각점수에서 감점한다. (-점수이면 0점처리한다)

								End If
						Next
						For i = 0 To ubound(sortarr3) '뒤에5개
								jchkcnt = jchkcnt + 1
								If i > 0 And i < ubound(sortarr3) then
									score = ( CDbl(sortarr3(i)) - (rounddeduction * 10) )
									If score < 0 Then
										score = 0
									End if
									totalscore = totalscore + score  '각점수에서 감점한다. (-점수이면 0점처리한다)

								End If
						Next
					End if

				End Select				
	
				'점수다아직안줌
				If scoreupdate = false Then
					totalscore = 0
				End If

				If CDbl(roundout) = 1 Then		'라운드 실격이라면
					jchkcnt = judgeCnt				'완료상태로
					totalscore = 0					'현재라운드 반영하지 않는다.
				End if

				'CDB S	남자유년부 'T	여자유년부 1.0
				'단체, 팀경기	 : 1,2라운드 종목은 난이도 2.0 고정
				'위에서 반영 code4변경

				If CDbl(totalscore) >  0 Then '총점 * 난이율
					totalscore = FormatNumber(   (totalscore/10) * code4 * grpvalue  ,2, 0,0,0)  * 100
				End if


				SQL = "Update sd_gameMember_roundRecord Set judgeendcnt = "&jchkcnt&" , totalscore = " & totalscore  & "  where idx = " & roundidx
				Call db.execSQLRs(SQL , null, ConStr)

				getNowRoundTotalScore = Array(totalscore, jchkcnt)
			End Function





			'##################################################################
			'맴버의 총 라운드총점 저장
			'##################################################################
			Sub setMemberScoreTotal(roundtotalarr, judgeendcnt, roundcnt,judgeCnt, midx, tryoutresult,  ByRef db, ConStr) 'judgeendcnt 각라운드 심판처리된 횟수배열
				Dim gametotal, gametotallen,prezero,i
				Dim SQL

				If isNumeric(tryoutresult) = False Then
					'전체실격임 점수 저장하지 않아...
					Exit sub
				End If
				
				gametotal = 0
				For i = 1 To roundcnt

					If CDbl(judgeendcnt(i)) =  CDbl(judgeCnt) then
						gametotal  = gametotal + CDbl(roundtotalarr(i))
					Else
						gametotal = 0
						Exit for
					End if
				Next

				'다셋자리로 앞에 0붙인다...스트링...자리수를 체크하는곳이 있을지도 모르니까
				If CDbl(gametotal) > 0 then
					gametotallen = Len(gametotal)
					If CDbl(gametotallen) < 5 Then
						For i = 1 To (5 - CDbl(gametotallen))
							prezero = prezero & "0"
						next
						gametotal = prezero & gametotal
					End If
				End if

				SQL = "update SD_gameMember Set tryoutresult  = '"&gametotal&"',tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx
				Call db.execSQLRs(SQL , null, ConStr)

			End Sub




			'##################################################################			
			'부의 랭킹 업데이트 (개인, 단체 , 혼성, 여부를 결정해서 넣어줘야할꺼같다. gbidx만으로 구분이 안된다.
			'##################################################################
			Sub setRankUpdate(tidx, gbidx,  ByRef  db, ConStr)
				Dim SQL,rs,arrR,wherestr,Selecttbl,rtvalue,rankupdate,ari

				rankupdate = true
				SQL = "select tryoutresult from SD_gameMember  where gametitleidx = " & tidx & " and gbidx = '"&gbidx&"' and delyn = 'N' "  '참여인원...집계여부
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrR = rs.GetRows()
				Else
					rankupdate = false
				End if

'Call oJSONoutput.Set("랭킹", arrR)


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

'Call oJSONoutput.Set("rankupdate", rankupdate)

				'랭킹업데이트 해야할시점체크
				If rankupdate = True then
					wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"'  and tryoutresult > 0  and tryoutresult < 'a'  " '업데이트 대상
					Selecttbl = "( SELECT tryouttotalorder, RANK() OVER (Order By cast(tryoutresult as int) desc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
					SQL = "UPDATE A  SET A.tryouttotalorder = A.RowNum FROM " & selecttbl
					Call db.execSQLRs(SQL , null, ConStr)
				End if

'Call oJSONoutput.Set("랭킹쿼리", sql)

			End Sub 

		'%%%%%%%%%%%%%%%%%
%>