<% 
'   ===============================================================================     
'    Purpose : ridding . 참가 선수 자동 Merging
'    Make    : 2019.03.25
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%> 

<!-- #include virtual = "/pub/fn/riding/res.pubcode.asp" -->  

<% 
'   ===============================================================================     
'       PubCode	engCode	PubName  
'       pubCode를 입력받아 endCode를 반환한다. 
'   ===============================================================================    
    Function uxGetPubEngCodeByCode(nCode)
        Dim pul, pai , ret

        pul = UBound(gAryPubCode)
        ret = ""

        For pai = 1 To pul
            If(nCode = gAryPubCode(pai)(0) ) Then 
                ret = gAryPubCode(pai)(1)
                Exit For
            End If
        Next

        uxGetPubEngCodeByCode = ret
    End Function 

'   ===============================================================================     
'       PubCode	engCode	PubName  
'       pubName를 입력받아 endCode를 반환한다. 
'   ===============================================================================    
    Function uxGetPubEngCodeByName(pName)
        Dim pul, pai , ret

        pul = UBound(gAryPubCode)
        ret = ""

        For pai = 1 To pul
            If(pName = gAryPubCode(pai)(2) ) Then 
                ret = gAryPubCode(pai)(1)
                Exit For
            End If
        Next

        uxGetPubEngCodeByName = ret
    End Function 

'   ===============================================================================     
'       PubCode	engCode	PubName  
'       pubCode를 입력받아 PubName를 반환한다. 
'   ===============================================================================    
    Function uxGetPubNameByCode(nCode)
        Dim pul, pai , ret

        pul = UBound(gAryPubCode)
        ret = ""

        For pai = 1 To pul
            If(nCode = gAryPubCode(pai)(0) ) Then 
                ret = gAryPubCode(pai)(2)
                Exit For
            End If
        Next

        uxGetPubNameByCode = ret
    End Function 

'   ===============================================================================     
'       PubCode	engCode	PubName  
'       engCode를 입력받아 PubName를 반환한다. 
'   ===============================================================================    
    Function uxGetPubNameByEngCode(eCode)
        Dim pul, pai , ret

        pul = UBound(gAryPubCode)
        ret = ""

        For pai = 1 To pul
            If(eCode = gAryPubCode(pai)(1) ) Then 
                ret = gAryPubCode(pai)(2)
                Exit For
            End If
        Next

        uxGetPubNameByEngCode = ret
    End Function 

'   ===============================================================================     
'       PubCode	engCode	PubName  
'       engCode를 입력받아 pubCode를 반환한다. 
'   ===============================================================================    
    Function uxGetPubCodeByName(pName)
        Dim pul, pai , ret

        pul = UBound(gAryPubCode)
        ret = 0

        For pai = 1 To pul
            If(pName = gAryPubCode(pai)(2) ) Then 
                ret = gAryPubCode(pai)(0)
                Exit For
            End If
        Next

        uxGetPubCodeByName = ret
    End Function 

'   ===============================================================================     
'       PubCode	engCode	PubName  
'       engCode를 입력받아 pubCode를 반환한다. 
'   ===============================================================================    
    Function uxGetPubCodeByEngCode(eCode)
        Dim pul, pai , ret

        pul = UBound(gAryPubCode)
        ret = ""

        For pai = 1 To pul
            If(eCode = gAryPubCode(pai)(1) ) Then 
                ret = gAryPubCode(pai)(0)
                Exit For
            End If
        Next

        uxGetPubCodeByEngCode = ret
    End Function 

'   ===============================================================================     
'       PubCode	engCode	PubName  
'       engCode1, engCode2를 입력받아 Merge하여 반환한다. ( Or 연산 )
'   ===============================================================================    
    Function uxMergeEngCode(eCode1, eCode2)
        Dim eai , ret, eLen, ch1, ch2
        eLen = Len(eCode1)
        For eai = 1 To eLen 
            ch1 = Mid(eCode1, eai,1)
            ch2 = Mid(eCode2, eai,1)

            If( ch1 = "X" ) Then 
                ret = ret&ch2 
            Else 
                ret = ret&ch1 
            End If
        Next        

        uxMergeEngCode = ret
    End Function 

'   ===============================================================================     
'      Detail List를 Print한다. 
'      사용 데이터 : fUse, gameNo, GbIdx, RealCnt, TeamGb, gameLevelIdx, pcode, mpcode, meCode, mpName, orgPCode, orgECode, orgPName
'   ===============================================================================    
    Function uxPrintDetailList(rAryList)        
        Dim ul2, ii
        ul2 = UBound(rAryList, 2)

        Response.Write "<br>============================================================================<br>"
        for ii = 0 to ul2
            strLog1 = strPrintf("fUse = {0}, no = {1}, Gb = {2}, cnt = {3}, TeamGb = {4}, glIdx = {5}", _
                Array(rAryList(0, ii), rAryList(1, ii), rAryList(2, ii), rAryList(3, ii), rAryList(4, ii), rAryList(5, ii)) )

            strLog2 = strPrintf("pcode = {0}, mpcode = {1}, meCode = {2}, mpName = {3}, orgPCode = {4}, orgECode = {5}, orgPName = {6}", _
                Array(rAryList(6, ii), rAryList(7, ii), rAryList(8, ii), rAryList(9, ii), rAryList(10, ii), rAryList(11, ii), rAryList(12, ii)) )

            strLog = strPrintf("{0}, {1}<br>", Array(strLog1, strLog2) )
            Response.Write strLog
        Next
        Response.Write "<br>============================================================================<br>"
    End Function 

'   ===============================================================================     
'      regInfo List를 Print한다. 
'      사용 데이터 : strPubCodes, strGLevelIdxs, strDelIdxs
'   ===============================================================================    
    Function uxPrintRegInfo(rAryInfo)        
        Dim ul2, ii
        ul2 = UBound(rAryInfo, 2)

        Response.Write "<br>============================================================================<br>"
        for ii = 0 to ul2
            strLog1 = strPrintf("titalIdx = {0}, gbIdx = {1}, mPCode = {2}, mECode = {3},  mPName = {4}", _
                Array(rAryInfo(0, ii), rAryInfo(1, ii), rAryInfo(2, ii), rAryInfo(3, ii), rAryInfo(4, ii)) )

            strLog2 = strPrintf("strPubCodes = ({0}), strGLevelIdxs = ({1}),  strDelIdxs = ({2})<br>", _
                Array(rAryInfo(5, ii), rAryInfo(6, ii), rAryInfo(7, ii)) )

            strLog = strPrintf("{0}, {1}", Array(strLog1, strLog2))

            Response.Write strLog
        Next
        Response.Write "<br>============================================================================<br>"
    End Function 

'   ===============================================================================     
'       세부종목 부별조정 List Array에서 자동 Merge를 할 데이터를 뽑아서 String Data를 만든다. 
'      사용 데이터 : fUse, gameNo, GbIdx, RealCnt, TeamGb, gameLevelIdx, pcode, mpcode, meCode, mpName, orgPCode, orgECode, orgPName
'   ===============================================================================    
    Function uxGetStrDetailList(rAryList)
        Dim strData, dai, dul, strLine
                
        dul = UBound(rAryList, 2)
        For dai = 0 To dul 
            strLine = strPrintf("0,{0},{1},{2},{3},{4},{5},{6},0,0,{7},0,0", _ 
                        Array(rAryList(1, dai), rAryList(3, dai), rAryList(26, dai), rAryList(18, dai), rAryList(0, dai), rAryList(4, dai), rAryList(4, dai), rAryList(28, dai) ))

            strData = strAddStr(strData, strLine, "{0}|{1}")
        Next        

        uxGetStrDetailList = strData
    End Function 

'   ===============================================================================     
'       부별성립 인원수 List Array에서 String Data를 만든다. 
'      TeamGb	realcnt	TeamGbNm
'      사용 데이터 : TeamGb	realcnt
'   ===============================================================================    
    Function uxGetStrLimitList(rAryList)
        Dim strData, dai, dul, strLine
                
        If isarray(rAryList) then
		dul = UBound(rAryList, 2)
        For dai = 0 To dul 
            strLine = strPrintf("{0},{1}", _ 
                        Array(rAryList(0, dai), rAryList(1, dai)))

            strData = strAddStr(strData, strLine, "{0}|{1}")
        Next 
		End if
        uxGetStrLimitList = strData

    End Function 

'   ===============================================================================     
'       부별성립 인원수 List Array에서 String Data를 만든다. 
'      TeamGb	realcnt	TeamGbNm
'      사용 데이터 : TeamGb	realcnt
'   ===============================================================================    
    Function uxGetLimitBoo(rAry, cBoo)
        Dim aIdx, aul, ret
        ret = 0

        If( Not IsArray(rAry) ) Then 
            uxGetLimitBoo = ret
            Exit Function 
        End If

        aul = UBound(rAry, 2)
        For aIdx = 0 To aul 
            If(rAry(0,aIdx) = cBoo) Then 
                ret = rAry(1,aIdx)
                Exit For
            End If
        Next        

        uxGetLimitBoo = ret
    End Function 

'   ===============================================================================     
'      auto merge
'        rAryDetail : fUse, gameNo, GbIdx, RealCnt, TeamGb, gameLevelIdx, pcode, mpcode, meCode, mpName, orgPCode, orgECode, orgPName
'        rAryLimit  : TeamGb	realcnt
'
'        1. rAryDetail을 gameNo를 기준으로 데이터를 분리한다. 
'        2. 분리된 데이터를 종별 최소 인원을 만족할때까지 합친다. 
'        3. 최소 인원을 만족하면 그 갯수만큼 pubCode를 merge한다. 
'        4. 마지막까지 합쳤는데 최소인원을 충족하지 못하면 그 이전 데이터와 합친다. 
'   ===============================================================================    
    Function uxAutoMergeBoo(rAryDetail, rAryLimit)
        Dim aIdx, aul, ret, sPos, ePos, dCnt 
        ret = 0
        sPos = 0
        ePos = 0
        gNum = 0
        dCnt = 0

        aul = UBound(rAryDetail, 2)

        For aIdx = 0 To aul 
            If( gNum = rAryDetail(1, aIdx) ) Then 
                dCnt = dCnt + 1
            Else 
                If(dCnt > 0 ) Then 
                    Call uxPartMergeBoo(rAryDetail, rAryLimit, sPos, dCnt)
                End If 
                gNum = rAryDetail(1, aIdx)
                sPos = aIdx                
                dCnt = 1
            End If
        Next    

        If(dCnt > 0 ) Then 
            Call uxPartMergeBoo(rAryDetail, rAryLimit, sPos, dCnt) 
        End If
        
    End Function 

'   ===============================================================================     
'      auto merge
'        rAryDetail : fUse, gameNo, GbIdx, RealCnt, TeamGb, gameLevelIdx, pcode, mpcode, meCode, mpName, orgPCode, orgECode, orgPName
'        rAryLimit  : TeamGb	realcnt
'
'        1. gameNo를 기준으로 분리된 데이터를 Merge한다. 
'   ===============================================================================    
    Function uxPartMergeBoo(rAryDetail, rAryLimit, sIdx, cntIdx )
        Dim eIdx, aIdx , nLimit, nCntUser, sPos, ePos, cntMerge, gNum 
        eIdx = (sIdx + cntIdx) - 1
        nLimit = uxGetLimitBoo(rAryLimit, rAryDetail(4, sIdx))
        nLimit = CDbl(nLimit)
        gNum   = rAryDetail(1,sIdx)
        nCntUser = 0
        sPos = sIdx
        cntMerge = 0 + (gNum * 10)

    '    strLog = strPrintf("uxPartMergeBoo In sIdx = {0},cntMerge = {1},nLimit = {2}<br>", _
    '            Array(sIdx, cntMerge, nLimit))
    '    Response.write strLog

        For aIdx = sIdx To eIdx             

            nCntUser = nCntUser + rAryDetail(3, aIdx)
            If( nCntUser >= nLimit ) Then 
                ePos = aIdx
                cntMerge = cntMerge + 1

    '            strLog = strPrintf("Call uxPartMergePubCode11 In sPos = {0},ePos = {1},cntMerge = {2}<br>", _
    '            Array(sPos, ePos, cntMerge))
    '            Response.write strLog
                Call uxPartMergePubCode(rAryDetail, sPos, ePos, cntMerge )

                sPos = aIdx + 1
                nCntUser = 0
            End If  
        Next    

        If( nCntUser > 0 ) Then 
            ePos = eIdx            
            sPos = uxGetPrevMergePos(rAryDetail, sIdx, eIdx)
            cntMerge = cntMerge + 1

            If( sPos >= 0 ) Then 
    '            strLog = strPrintf("Call uxPartMergePubCode22 In sPos = {0},ePos = {1},cntMerge = {2}<br>", _
    '            Array(sPos, ePos, cntMerge))
    '            Response.write strLog
                Call uxPartMergePubCode(rAryDetail, sPos, ePos, cntMerge )
            End If
        End If
        
    End Function 

'   ===============================================================================     
'      auto merge
'        rAryDetail : fUse, gameNo, GbIdx, RealCnt, TeamGb, gameLevelIdx, pcode, mpcode, meCode, mpName, orgPCode, orgECode, orgPName
'        rAryLimit  : TeamGb	realcnt
'
'        1. merge할 데이터에 값을 할당한다. 
'        2. merge Group Idx를 넣는다. 
'        3. pub Code로 engName을 구한다. 
'        4. pub Code로 pubName을 구한다. 
'        5. engName을 merge한다. 
'        6. merge가 끝난 engName으로 최종 pubCode를 구한다. 
'        7. merge가 끝난 engName으로 최종 pubName를 구한다. 
'   ===============================================================================   
    Function uxPartMergePubCode(rAryDetail, sIdx, eIdx, nUseIdx )
        Dim rstECode, rstPCode, rstPName, eCode, mCode, aIdx, pCode
        Dim orgPCode, orgECode, orgPName
        rstECode = "XXXXXX"
        mCode = 0

        

        ' original pub data를 구한다. 
        ' orgPubCode != 0이면 orgPubCode = orgPubCode / 아니면 orgPubCode = pubCode
        For aIdx = sIdx To eIdx 
            rAryDetail(0, aIdx) = nUseIdx      ' merge group idx - 이것으로 동일 데이터 구분 

            pCode = CDbl(rAryDetail(6, aIdx))         ' pub Code            
            orgPCode = CDbl(rAryDetail(10, aIdx))         ' orginal pub Code            

            If(orgPCode = 0) Then orgPCode = pCode End If

            orgECode = uxGetPubEngCodeByCode(orgPCode) ' pub Code로 engName을 구한다. 
            orgPName = uxGetPubNameByCode(orgPCode) ' pub Code로 pubName을 구한다. 

            rAryDetail(10, aIdx)     = orgPCode ' original pub Code
            rAryDetail(11, aIdx)    = orgECode ' original engName
            rAryDetail(12, aIdx)    = orgPName ' original pubName

            ' merge engCode 
            rstECode = uxMergeEngCode(rstECode, orgECode)
        Next

        rstPCode = uxGetPubCodeByEngCode(rstECode)
        rstPName = uxGetPubNameByEngCode(rstECode)

        ' merge한 결과를 pubcode, engname, pubname에 채워준다. 
        For aIdx = sIdx To eIdx                       
            rAryDetail(7, aIdx) = rstPCode   ' mergePubCode
            rAryDetail(8, aIdx) = rstECode                       ' mergeEngName
            rAryDetail(9, aIdx) = rstPName    ' mergePubName
        Next 
        
    End Function 

'   ===============================================================================     
'      바로 이전의 Merge Data의 시작Pos을 찾는다. 
'       rAryDetail : fUse, gameNo, GbIdx, RealCnt, TeamGb, gameLevelIdx, pcode, mpcode, meCode, mpName, orgPCode, orgECode, orgPName
'      1. sIdx, eIdx Block에서 찾는 것이기 때문에 gameNo은 같다. 
'   ===============================================================================    
    Function uxGetPrevMergePos(rAry, sPos, ePos)
        Dim aIdx, aul, ret, useIdx, sIdx
        useIdx = 0
        sIdx = -1

    '    strLog = strPrintf("uxGetPrevMergePos In sPos = {0},ePos = {1}<br>", _
    '            Array(sPos, ePos))
    '            Response.write strLog

    '   fUse > 0인 것이 하나 이상이면 제일 마직막것을 찾는다.
        For aIdx = sPos To ePos 
            If(rAry(0,aIdx) > 0 And rAry(0,aIdx) <> useIdx) Then 
                useIdx = rAry(0,aIdx)
                sIdx = aIdx
                Exit For
            End If
        Next 

    '    strLog = strPrintf("uxGetPrevMergePos222 In sPos = {0},ePos = {1}<br>", _
    '            Array(sPos, ePos))
    '            Response.write strLog
    
    ' 4. sIdx = -1이면 sPos이 시작점이다. 
        If( sIdx = -1 ) Then sIdx = sPos End If 
        uxGetPrevMergePos = sIdx
    End Function 

'   ===============================================================================     
'      DB Registry에 필요한 정보를 추출한다. 
'      rAryDetail : fUse, gameNo, GbIdx, RealCnt, TeamGb, gameLevelIdx, pcode, mpcode, meCode, mpName, orgPCode, orgECode, orgPName
'      array 반환 : strRGameLevelidxs, strDelRGameLevelidxs, strPubCodes, 
'   ===============================================================================    
    Function uxExtractRegInfo(rAry, titleIdx)
        Dim aIdx, aul, ret, useIdx, sIdx, cntInfo, prevUseIdx, gameNum
        Dim aryInfo, sPos, ePos, cntPos, infoIdx 

        cntInfo = 0
        prevUseIdx = 0
        gameNum = 0
        cntPos = 0
        infoIdx = 0

        aul = UBound(rAry, 2)

        ' 일단 Merge되는 Count를 센다. 
        For aIdx = 0 To aul 
            If(rAry(0,aIdx) > 0 And rAry(0,aIdx) <> useIdx) Then 
                useIdx = rAry(0,aIdx)
                cntInfo = cntInfo + 1
            End If
        Next 

        ' array Info를 재할당 한다. 
        Redim aryInfo(7, cntInfo-1)

        useIdx = 0
        cntPos = 0
        ' merge block을 구한후 그 Block에서 infomation을 구한다. 
        For aIdx = 0 To aul 
            If(rAry(0,aIdx) > 0) Then  
                If( rAry(0,aIdx) = useIdx) Then 
                    cntPos = cntPos + 1                    
                Else
                    If( cntPos > 0) Then 
                        Call uxExtractRegPargInfo(rAry, aryInfo, titleIdx, sPos, cntPos, infoIdx)
                        infoIdx = infoIdx + 1
                    End If
                    sPos = aIdx
                    cntPos = 1
                    useIdx = rAry(0,aIdx)
                End If
            End If                 
        Next

        If( cntPos > 0 ) Then 
            Call uxExtractRegPargInfo(rAry, aryInfo, titleIdx, sPos, cntPos, infoIdx)
        End If

        uxExtractRegInfo = aryInfo
    End Function 

'   ===============================================================================     
'      Merge Block에서 실제로 DB Registry에 필요한 정보를 추출한다. 
'      rAryDetail : fUse, gameNo, GbIdx, RealCnt, TeamGb, gameLevelIdx, pcode, mpcode, meCode, mpName, orgPCode, orgECode, orgPName
'      array 반환 : strRGameLevelidxs, strDelRGameLevelidxs, strPubCodes, 
'   ===============================================================================  
    Function uxExtractRegPargInfo(rAry, aryInfo, titleIdx, sPos, cntPos, infoIdx)
        Dim aIdx, ePos, strGLevelIdxs, strDelIdxs, strPubCodes
        Dim fPos 
        ePos = sPos + cntPos - 1

        strGLevelIdxs = ""
        strPubCodes = ""

        For aIdx = sPos To ePos
            If( strGLevelIdxs = "") Then 
                strGLevelIdxs   = rAry(5, aidx)
                strPubCodes     = rAry(6, aidx)
            Else 
                strGLevelIdxs   = strPrintf("{0}, {1}", Array(strGLevelIdxs,rAry(5, aidx)))
                strPubCodes     = strPrintf("{0}, {1}", Array(strPubCodes,rAry(6, aidx)))
            End If
        Next

        ' strDelIdxs는 strGLevelIdxs에서 , 구분된 string에서 제일 마지막 요소를 제외한 것이다. 
        fPos = InStrRev(strGLevelIdxs, ",")
        If(fPos <> 0) Then ' 찾았다. 
            strDelIdxs = Left(strGLevelIdxs, fPos-1)
        End If

        aryInfo(0,infoIdx) = titleIdx
        aryInfo(1,infoIdx) = rAry(2, sPos)
        aryInfo(2,infoIdx) = rAry(7, sPos)
        aryInfo(3,infoIdx) = rAry(8, sPos)
        aryInfo(4,infoIdx) = rAry(9, sPos)
        aryInfo(5,infoIdx) = strPubCodes
        aryInfo(6,infoIdx) = strGLevelIdxs
        aryInfo(7,infoIdx) = strDelIdxs        
    End Function 
%> 