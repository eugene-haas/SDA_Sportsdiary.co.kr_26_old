<% 
'   ===============================================================================     
'    Purpose : badminton Sql Query를 모아 놨다. 
'    Make    : 2019.05.01
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%>

<% 
'   **********************************************************************************
'   **********************************************************************************
'       실시간 점수 
'   ===============================================================================     
'         실시간 점수 Data Select
'         levelIdx,teamGNum,gameNum로 insert한 Data가 있는지 검사한다. 
'   =============================================================================== 
    Function sqlSelRealTimeGame(levelIdx,teamGNum,gameNum) 
        Dim strSql, strTable, strWhere, strField 

    ' ================================================================================================        
        strTable = "tblRealTimeGame With (NoLock)"
    ' ================================================================================================
        strField = "IDX"

    ' ================================================================================================
        ' where
        strWhere = strPrintf("DelYN = 'N' And GameLevelDtlIDX = '{0}' And TeamGameNum = '{1}' And GameNum = '{2}'", _
                        array(levelIdx,teamGNum,gameNum))

        If (levelIdx <> "" And teamGNum <> "" And gameNum <> "" ) Then 
            strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))        
        End If

		  strLog = sprintf("sqlSelRealTimeGame = {0}",Array(strSql))
		' Call TraceLog(SAMALL_LOG1, strLog)

        sqlSelRealTimeGame = strSql
    End Function  

'   ===============================================================================     
'         실시간 점수 Data Select  - Game End전용
'         levelIdx,teamGNum,gameNum로 insert한 Data가 있는지 검사한다. 
'   =============================================================================== 
    Function sqlSelRealTimeGameEx(levelIdx,teamGNum,gameNum) 
        Dim strSql, strTable, strWhere, strField 

    ' ================================================================================================        
        strTable = "tblRealTimeGame With (NoLock)"
    ' ================================================================================================
        strField = "L_1SetScore,L_2SetScore,L_3SetScore,L_4SetScore,L_5SetScore,R_1SetScore,R_2SetScore,R_3SetScore,R_4SetScore,R_5SetScore"

    ' ================================================================================================
        ' where
        strWhere = strPrintf("DelYN = 'N' And GameLevelDtlIDX = '{0}' And TeamGameNum = '{1}' And GameNum = '{2}'", _
                        array(levelIdx,teamGNum,gameNum))

        If (levelIdx <> "" And teamGNum <> "" And gameNum <> "" ) Then 
            strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))        
        End If

		  strLog = sprintf("sqlSelRealTimeGameEx = {0}",Array(strSql))
		' Call TraceLog(SAMALL_LOG1, strLog)

        sqlSelRealTimeGameEx = strSql
    End Function  

'   ===============================================================================     
'         실시간 점수 Data Delete
'         levelIdx,teamGNum,gameNum로 insert한 Data가 있으면 Delete
'         GameStart시점에 호출 : 새로 입력할때 기존 데이터가 있으면 삭제한다. 
'   =============================================================================== 
    Function sqlDeleteRealTimeGame(levelIdx,teamGNum,gameNum) 
        Dim strSql, strTable, strWhere, strField 

    ' ================================================================================================        
        strTable = "tblRealTimeGame"
    ' ================================================================================================
        ' where
        strWhere = strPrintf("DelYN = 'N' And GameLevelDtlIDX = '{0}' And TeamGameNum = '{1}' And GameNum = '{2}'", _
                        array(levelIdx,teamGNum,gameNum))

        If (levelIdx <> "" And teamGNum <> "" And gameNum <> "" ) Then 
            strSql = strPrintf("Delete From {0} Where {1}", Array(strTable, strWhere))        
        End If

		  strLog = sprintf("sqlDeleteRealTimeGame = {0}",Array(strSql))
		' Call TraceLog(SAMALL_LOG1, strLog)

        sqlDeleteRealTimeGame = strSql
    End Function  

'   ===============================================================================     
'         실시간 점수 Data Insert
'         levelIdx,teamGNum,gameNum, setNum, left, score
'   =============================================================================== 
   Function sqlInsertRealTimeGame(levelIdx,teamGNum,gameNum, IsLeft, score, setInfo) 
      Dim strSql, strTable, strValue, strField , strField1, strField2

   ' ================================================================================================        
      strTable = "tblRealTimeGame"
   ' ================================================================================================
   ' Field
      strField1 = "GameLevelDtlIDX,TeamGameNum,GameNum,L_1SetScore,SetInfo"
      strField = "GameLevelDtlIDX,TeamGameNum,GameNum,R_1SetScore,SetInfo"
      If( IsLeft = 1 ) Then strField = strField1 End If
   ' ================================================================================================
      ' value
      strValue = strPrintf(" '{0}', '{1}', '{2}', '{3}', '{4}'", Array(levelIdx,teamGNum,gameNum, score, setInfo ) )

      If (levelIdx <> "" And teamGNum <> "" And gameNum <> "" ) Then 
         strSql = strPrintf(" Insert Into {0} ( {1} ) values( {2} )",  Array(strTable, strField, strValue) )       
      End If

		strLog = sprintf("sqlInsertRealTimeGame = {0}",Array(strSql))
		' Call TraceLog(SAMALL_LOG1, strLog)

      sqlInsertRealTimeGame = strSql
   End Function  

'   ===============================================================================     
'         실시간 점수 Data update
'         levelIdx,teamGNum,gameNum, setNum, left, score
'   =============================================================================== 
   Function sqlUpdateRealTimeGame(levelIdx,teamGNum,gameNum, IsLeft, setNum, score, setInfo) 
      Dim strSql, strTable, strValue, strSet

   ' ================================================================================================        
      strTable = "tblRealTimeGame"
   ' ================================================================================================
      ' Set Data        
      If(isLeft = 1) Then 
         strSet = strPrintf("L_{0}SetScore = L_{0}SetScore + {1}, SetInfo = {2}", Array(setNum, score, setInfo))
      Else 
         strSet = strPrintf("R_{0}SetScore = R_{0}SetScore + {1}, SetInfo = {2}", Array(setNum, score, setInfo))
      End If

   ' ================================================================================================
        ' where
      strWhere = strPrintf("DelYN = 'N' And GameLevelDtlIDX = '{0}' And TeamGameNum = '{1}' And GameNum = '{2}'", _
                     array(levelIdx,teamGNum,gameNum))

      If (levelIdx <> "" And teamGNum <> "" And gameNum <> "" ) Then 
         strSql = strPrintf(" Update {0} Set {1} Where {2}",  Array(strTable, strSet, strWhere) )       
      End If

		strLog = sprintf("sqlUpdateRealTimeGame = {0}",Array(strSql))
		' Call TraceLog(SAMALL_LOG1, strLog)

      sqlUpdateRealTimeGame = strSql
   End Function  

'   ===============================================================================     
'         실시간 점수 Data update - client로 부터 l_score, r_score를 받아서 업데이트 한다. 
'         간혹 클라이언트와 싱크가 깨져도 점수를 복구할수 있다. 
'         levelIdx,teamGNum,gameNum, setNum, left, score
'   =============================================================================== 
   Function sqlUpdateRealTimeGameEx(levelIdx,teamGNum,gameNum, setNum, l_score, r_score, setInfo) 
      Dim strSql, strTable, strValue, strSet 

   ' ================================================================================================        
      strTable = "tblRealTimeGame"
   ' ================================================================================================
      ' Set Data        
      strSet = strPrintf("L_{0}SetScore = {1}, R_{0}SetScore = {2}, SetInfo = {3}", Array(setNum, l_score, r_score, setInfo))

   ' ================================================================================================
        ' where
      strWhere = strPrintf("DelYN = 'N' And GameLevelDtlIDX = '{0}' And TeamGameNum = '{1}' And GameNum = '{2}'", _
                     array(levelIdx,teamGNum,gameNum))

      If (levelIdx <> "" And teamGNum <> "" And gameNum <> "" ) Then 
         strSql = strPrintf(" Update {0} Set {1} Where {2}",  Array(strTable, strSet, strWhere) )       
      End If

		strLog = sprintf("sqlUpdateRealTimeGameEx = {0}",Array(strSql))
			' Call TraceLog(SAMALL_LOG1, strLog)

      sqlUpdateRealTimeGameEx = strSql
   End Function  

'   ===============================================================================     
'         실시간 점수 Data update
'         levelIdx,teamGNum,gameNum, setNum, left, score
'   =============================================================================== 
   Function sqlUpdateRealTimeGameEnd(levelIdx,teamGNum,gameNum) 
      Dim strSql, strTable, strValue, strSet

   ' ================================================================================================        
      strTable = "tblRealTimeGame"
   ' ================================================================================================
      ' Set Data        
      strSet = "GameStatus = 1, SetInfo = ''"

   ' ================================================================================================
        ' where
      strWhere = strPrintf("DelYN = 'N' And GameLevelDtlIDX = '{0}' And TeamGameNum = '{1}' And GameNum = '{2}'", _
                     array(levelIdx,teamGNum,gameNum))

      If (levelIdx <> "" And teamGNum <> "" And gameNum <> "" ) Then 
         strSql = strPrintf(" Update {0} Set {1} Where {2}",  Array(strTable, strSet, strWhere) )       
      End If

		strLog = sprintf("sqlUpdateRealTimeGameEnd = {0}",Array(strSql))
			' Call TraceLog(SAMALL_LOG1, strLog)

      sqlUpdateRealTimeGameEnd = strSql
   End Function  


'   ===============================================================================     
'         실시간 점수 Data Reset
'         levelIdx,teamGNum,gameNum로 insert한 Data가 있으면 Reset
'         GameStart시점에 호출 : 새로 입력할때 기존 데이터가 있으면 삭제한다. 
'   =============================================================================== 
    Function sqlResetRealTimeGame(levelIdx,teamGNum,gameNum) 
        Dim strSql, strTable, strWhere, strField 

        If (levelIdx <> "" And teamGNum <> "" And gameNum <> "" ) Then 
            strSql = "Update tblRealTimeGame "
				strSql = strSql & " Set L_1SetScore = 0, L_2SetScore = 0, L_3SetScore = 0, L_4SetScore = 0, L_5SetScore = 0, "
				strSql = strSql & " R_1SetScore = 0, R_2SetScore = 0, R_3SetScore = 0, R_4SetScore = 0, R_5SetScore = 0, "
				strSql = strSql & " SetInfo = '', LResult = '', GameStatus = NULL, EndRealTimeTransYN = 'N', "
				strSql = strSql & " L_ChallengeCnt = 2, R_ChallengeCnt = 2 "
				strSql = strSql & strPrintf(" Where DelYN = 'N' And GameLevelDtlIDX = '{0}' And TeamGameNum = '{1}' And GameNum = '{2}'", _
                        array(levelIdx,teamGNum,gameNum))
        End If

		  strLog = sprintf("sqlResetRealTimeGame = {0}",Array(strSql))
			' Call TraceLog(SAMALL_LOG1, strLog)

        sqlResetRealTimeGame = strSql
    End Function  
%>