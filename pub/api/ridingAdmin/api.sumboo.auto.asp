<%
'   ===============================================================================     
'    Purpose : 자동 종목 합치기 
'    Make    : 2019.03.25
'    Author  :                                                       By Aramdry
'    util    : /pub/fn/riding/fn.auto.merge.asp
'   ===============================================================================  
%>

<%
    Set db = new clsDBHelper
%>

<%
    If hasown(oJSONoutput, "DETAIL") = "ok" Then 
        strRDetail = oJSONoutput.DETAIL                 ' List Array
        aryRDetail = uxGet2DimAryFromStr(strRDetail, "|", ",")
    End If

    If hasown(oJSONoutput, "LIMIT") = "ok" Then 
        strBLimit = oJSONoutput.LIMIT                   ' 부별 Limit Array - 
        aryBLimit = uxGet2DimAryFromStr(strBLimit, "|", ",")
    End If

    If hasown(oJSONoutput, "GYEAR") = "ok" Then 
        nowgameyear = oJSONoutput.GYEAR                   ' GameYear
    End If

    If hasown(oJSONoutput, "TIDX") = "ok" Then 
        tidx = oJSONoutput.TIDX                   ' GameTitleIDX
    End If

'    Call uxPrintDetailList(aryRDetail)
'    Response.Write "<br>----------------------------------------------------------------------------<br>"
    Call uxAutoMergeBoo(aryRDetail, aryBLimit)
'   Response.Write "<br>----------------------------------------------------------------------------<br>"
'   Call uxPrintDetailList(aryRDetail)

    aryRegInfo = uxExtractRegInfo(aryRDetail, tidx)
'  Call uxPrintRegInfo(aryRegInfo)

    ' ---------------------------------------------------------------------------------------------
    ' 게임이 2라운드 이상(대회 같은 부명칭) 진행하면 부 해체를 할수 없다. 
    If CONST_CHECK = true Then 
        If IsArray(arrR) Then 
            rgTitleIdx       = aryRegInfo(0, 0)
            rgbIdx           = aryRegInfo(1, 0)
            
            SQL = "Select Round From sd_TennisMember where gametitleidx = '"&rgTitleIdx&"' and gamekey3 = '"&rgbIdx&"' Round > 1"
            Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

            If Not (rs.Eof Or rs.Bof) Then                      
                Call oJSONoutput.Set("result", "90" )     
                strjson = JSON.stringify(oJSONoutput)
                Response.Write strjson
                Response.write "`##`"
                rs.Close 
                db.Dispose

                Set db = Nothing
                Set rs = Nothing
                Response.end
            End if 
        End If
    End if
    ' ---------------------------------------------------------------------------------------------

    ' aryRegInfo : titalIdx,gbIdx, strPubCodes, strGLevelIdxs, strDelIdxs
    If(IsArray(aryRegInfo)) Then 
        rul = UBound(aryRegInfo, 2)
        
        For rIdx = 0 To rul 
            rgTitleIdx       = aryRegInfo(0, rIdx)
            rgbIdx           = aryRegInfo(1, rIdx)
            mpCode          = aryRegInfo(2, rIdx)
            meCode          = aryRegInfo(3, rIdx)
            mpName          = aryRegInfo(4, rIdx)
            strPubCodes     = aryRegInfo(5, rIdx)
            strGLevelIdxs   = aryRegInfo(6, rIdx)
            strDelIdxs      = aryRegInfo(7, rIdx)

            If ( strDelIdxs <> "") Then             
                ' regist to db
                '통합하기
                '종목 내용 통합으로 변경 앞에꺼는 delYN = Y            
                WhereStr = " RGameLevelidx in ("&strGLevelIdxs&")"
                SQL = "Update tblRGameLevel Set orgpubcode = case when orgpubcode is null then pubcode else orgpubcode end, "
                SQL = SQL & " orgengcode = case when orgengcode is null then engcode else orgengcode end, "
                SQL = SQL & " orgpubname = case when orgpubname is null then pubname else orgpubname end, pubcode = '"&mpCode&"', engcode = '"&meCode&"' , pubname = '"&mpName&"' where " &  whereStr

'                Call DbgLog(SAMALL_LOG1, "autosum1 SQL = "& SQL)            
                Call db.execSQLRs(SQL , null, ConStr)
                
                SQL = "Update tblRgameLevel Set delYN = 'Y' where RGameLevelidx in (" & strDelIdxs & ") "
'                Call DbgLog(SAMALL_LOG1, "autosum2 SQL = "& SQL)
                Call db.execSQLRs(SQL , null, ConStr)

                '참가 내역 통합으로 변경
                reqwherestr = " gametitleidx = '"&rGTitleIdx&"' and gbidx = '"&rGbIdx&"' and pubcode in ("&strPubCodes&") "
                SQL = "Update tblGameRequest Set orgpubcode = case when orgpubcode is null then pubcode else orgpubcode end, "
                SQL = SQL & " orgengcode = case when orgengcode is null then engcode else orgengcode end, "
                SQL = SQL & " orgpubname = case when orgpubname is null then pubname else orgpubname end, pubcode = '"&mpCode&"', engcode = '"&meCode&"' , pubname = '"&mpName&"' where " &  reqwherestr
                Call db.execSQLRs(SQL , null, ConStr)
'                Call DbgLog(SAMALL_LOG1, "autosum3 SQL = "& SQL)


                '대회 진행 통합으로 변경
                memwherestr  = " gametitleidx = '"&rGTitleIdx&"' and gamekey3 = '"&rGbIdx&"' and pubcode in ("&strPubCodes&") "
                SQL = "Update sd_tennisMember Set orgpubcode = case when orgpubcode is null then pubcode else orgpubcode end, "
                SQL = SQL & " orgengcode = case when orgengcode is null then engcode else orgengcode end, "
                SQL = SQL & " orgpubname = case when orgpubname is null then pubname else orgpubname end, pubcode = '"&mpCode&"', engcode = '"&meCode&"' , pubname = '"&mpName&"' where " &  memwherestr
'                Call DbgLog(SAMALL_LOG1, "autosum4 SQL = "& SQL)
                Call db.execSQLRs(SQL , null, ConStr)
            End If
        Next 
    End If

    %>
        <!-- #include virtual = "/pub/html/riding/boocontrollist.asp" -->
    <%
%>

<%
    Set rs = Nothing

	Call db.Dispose
    Set db = Nothing
    ' Call writeLog(SAMALL_LOG1, "api.cpn.db.cate.asp --. end")
%>
