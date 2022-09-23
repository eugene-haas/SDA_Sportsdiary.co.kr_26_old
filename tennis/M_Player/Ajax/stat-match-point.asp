<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	Sub_Type = fInject(Request("Sub_Type"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	
	iPlayerIDX = decode(iPlayerIDX,0)
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  'Sub_Type = ""
  'Sub_Type = "minuspoint"
  'iPlayerIDX = "1403"
  'SDate = "2016-03-01"
  'EDate = "2017-12-31"

  retext = ""

  retext = retext&"<table>"
	retext = retext&"				<thead>"
	retext = retext&"					<tr>"
	retext = retext&"						<th>기술명</th>"

  '- iType
  '2 : 나의통계>대회득실점>점수별>득점,실점 Y축 명 , 완료
  '21 : 나의통계>대회득실점>점수별>개별 득점 , 완료
  '22 : 나의통계>대회득실점>점수별>개별 실점 , 완료

  iType = "2"
  'iSportsGb = "judo"

  Dim LRsCnt1, Rname1, Rname1_1, LRsCnt2, Rname2, Rname2_1, Rname2_2, Rname2_3, Rname2_4, LRsCnt3, Rname3, Sname, Sname1, Rnamecnt
  LRsCnt1 = 0
  Rname1 = ""
  Rname1_1 = ""
  LRsCnt2 = 0
  Rname2 = ""
  Rname2_1 = ""
  Rname2_2 = ""
  Rname2_3 = ""
  Rname2_4 = ""
  LRsCnt3 = 0
  Rname3 = ""
  Sname = ""
  Sname1 = ""
  Rnamecnt = 0

  Dim mLRsCnt1, mRname1, mRname1_1, mLRsCnt2, mRname2, mRname2_1, mRname2_2, mRname2_3, mRname2_4, mLRsCnt3, mRname3, mSname, mSname1, mRnamecnt
  mLRsCnt1 = 0
  mRname1 = ""
  mRname1_1 = ""
  mLRsCnt2 = 0
  mRname2 = ""
  mRname2_1 = ""
  mRname2_2 = ""
  mRname2_3 = ""
  mRname2_4 = ""
  mLRsCnt3 = 0
  mRname3 = ""
  mSname = ""
  mSname1 = ""
  mRnamecnt = 0

  LSQL = "EXEC Stat_Match_Point_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        LRsCnt1 = LRsCnt1 + 1
        mLRsCnt1 = mLRsCnt1 + 1
        If (Rname1 <> LRs("ResultName")) Then
          'retext = retext&"{""label"": """&LRs("ResultName")&"""},"
          retext = retext&"						<th>"&LRs("ResultName")&"</th>"
          Rname1_1 = Rname1_1&"^"&LRs("ResultName")&""
          mRname1_1 = mRname1_1&"^"&LRs("ResultName")&""
        End if
        Rname1 = LRs("ResultName")
      LRs.MoveNext
		Loop
  else
    retext = retext&"						<th>한판</th>"
    retext = retext&"						<th>절반</th>"
    'retext = retext&"						<th>지도</th>"
	End If

  LRs.close

	retext = retext&"					</tr>"
	retext = retext&"				</thead>"
	retext = retext&"				<tbody>"


  if Sub_Type = "minuspoint" then ' 실점

	  'retext = retext&"		  <tr>"
	  'retext = retext&"			  <th>업어치기</th>"
	  'retext = retext&"			  <td>5</td>"
	  'retext = retext&"			  <td></td>"
	  'retext = retext&"			  <td></td>"
	  'retext = retext&"		  </tr>"

    '한판,절반 등...
    if mRname1_1 <> "" then
      mRname1_1 = Mid(mRname1_1, 2, len(mRname1_1) - 1)
      mRname1_1 = Split(mRname1_1, "^")
    end if

    iType = "22"

    LSQL = "EXEC Stat_Match_Point_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	  Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
		  Do Until LRs.Eof

          mRname2_1 = mRname2_1&"^"&LRs("ResultName")&""
          mRname2_2 = mRname2_2&"^"&LRs("SpecialtyDtlName")&""
          mRname2_3 = mRname2_3&"^"&LRs("RS")&""
          mRname2_4 = mRname2_4&"^"&LRs("Jumsu")&""

          'response.Write mRname2_4

        LRs.MoveNext
		  Loop
    else
      
	  End If

    LRs.close

    '한판,절반 등...
    if mRname2_1 <> "" then
      mRname2_1 = Mid(mRname2_1, 2, len(mRname2_1) - 1)
      mRname2_1a = Split(mRname2_1, "^")
    end if
    
    '업어치기 등...
    if mRname2_2 <> "" then
      'mRname2_2 = Mid(mRname2_2, 2, len(mRname2_2) - 1)
      mRname2_2a = Split(mRname2_2, "^")
      mRnamecnt = uBound(mRname2_2a)
    end if
    
    'Result+e.SpecialtyDtl
    if mRname2_3 <> "" then
      mRname2_3 = Mid(mRname2_3, 2, len(mRname2_3) - 1)
      mRname2_3a = Split(mRname2_3, "^")
    end if

    '점수
    if mRname2_4 <> "" then
      mRname2_4 = Mid(mRname2_4, 2, len(mRname2_4) - 1)
      mRname2_4a = Split(mRname2_4, "^")
    end if

    Dim miRS
    miRS = ""

    Dim mRname2_2c, mRname2_2cacnt
    mRname2_2c = ""
    mRname2_2cacnt = 0

    'response.Write "mRnamecnt="&mRnamecnt
    
    if mRnamecnt <> 0 then
      For i = 1 To mRnamecnt
        if instr(mRname2_2c,mRname2_2a(i)) = 0 then
          mRname2_2c = mRname2_2c&"^"&mRname2_2a(i)
        end if
      Next
    end if

    if mRnamecnt <> 0 then
      '업어치기 등 그룹 묶음
      if mRname2_2c <> "" then
        'mRname2_2c = Mid(mRname2_2c, 2, len(mRname2_2c) - 1)
        mRname2_2ca = Split(mRname2_2c, "^")
        mRname2_2cacnt = uBound(mRname2_2ca)
      end if
    end if

    Response.Write retext

    'response.Write "mRname2_2cacnt="&mRname2_2cacnt

    if mRname2_2cacnt <> 0 then

      Dim marr()
      ReDim marr(mRname2_2cacnt - 1, mLRsCnt1 - 1)   
    
        iType = "22"
    
        LSQL = "EXEC Stat_Match_Point_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	      Set LRs = Dbcon.Execute(LSQL)
    
          If Not (LRs.Eof Or LRs.Bof) Then
	  	        Do Until LRs.Eof
              
                For i = 0 To mRname2_2cacnt - 1
                
                  For j = 0 To mLRsCnt1 - 1
    
    
                    if mRname2_2ca(i+1) = LRs("SpecialtyDtlName") and mRname1_1(j) = LRs("ResultName") then 
                  
                      marr(i,j) = "<td>"&LRs("Jumsu")&"</td>"
                  
                    end if
          
    
                  NEXT
    
                NEXT
      
    
              LRs.MoveNext
	  	      Loop
          end if

        LRs.close
    
        numrows = UBound(marr, 1) '행  
        numcols = UBound(marr, 2) '열  
        cnt = 0  	
	  
        For i = 0 To numrows '행
            Response.Write "<tr>"
            response.Write "<th>"&mRname2_2ca(i+1)&"</th>"
            For j = 0 To numcols '열             
	  		  	
	  		        if marr(i, j) = "" then
                  Response.Write "<td></td>"
                else
                  Response.Write marr(i, j)
                end if
	  		
            Next
            Response.Write "</tr>"
        
        Next

    end if


  else ' 득점
  
    '한판,절반 등...
    if Rname1_1 <> "" then
      Rname1_1 = Mid(Rname1_1, 2, len(Rname1_1) - 1)
      Rname1_1 = Split(Rname1_1, "^")
    end if

    iType = "21"

    LSQL = "EXEC Stat_Match_Point_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	  Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
		  Do Until LRs.Eof

          Rname2_1 = Rname2_1&"^"&LRs("ResultName")&""
          Rname2_2 = Rname2_2&"^"&LRs("SpecialtyDtlName")&""
          Rname2_3 = Rname2_3&"^"&LRs("RS")&""
          Rname2_4 = Rname2_4&"^"&LRs("Jumsu")&""

        LRs.MoveNext
		  Loop
    else
      
	  End If

    LRs.close

    '한판,절반 등...
    if Rname2_1 <> "" then
      Rname2_1 = Mid(Rname2_1, 2, len(Rname2_1) - 1)
      Rname2_1a = Split(Rname2_1, "^")
    end if
    
    '업어치기 등...
    if Rname2_2 <> "" then
      'Rname2_2 = Mid(Rname2_2, 2, len(Rname2_2) - 1)
      Rname2_2a = Split(Rname2_2, "^")
      Rnamecnt = uBound(Rname2_2a)
    end if
    
    'Result+e.SpecialtyDtl
    if Rname2_3 <> "" then
      Rname2_3 = Mid(Rname2_3, 2, len(Rname2_3) - 1)
      Rname2_3a = Split(Rname2_3, "^")
    end if

    '점수
    if Rname2_4 <> "" then
      Rname2_4 = Mid(Rname2_4, 2, len(Rname2_4) - 1)
      Rname2_4a = Split(Rname2_4, "^")
    end if

    Dim iRS
    iRS = ""

    Dim Rname2_2c, Rname2_2cacnt
    Rname2_2c = ""
    Rname2_2cacnt = 0

    'response.Write "Rnamecnt="&Rnamecnt
    
    if Rnamecnt <> 0 then
      For i = 1 To Rnamecnt
        if instr(Rname2_2c,Rname2_2a(i)) = 0 then
          Rname2_2c = Rname2_2c&"^"&Rname2_2a(i)
        end if
      Next
    end if

    if Rnamecnt <> 0 then
      '업어치기 등 그룹 묶음
      if Rname2_2c <> "" then
        'Rname2_2c = Mid(Rname2_2c, 2, len(Rname2_2c) - 1)
        Rname2_2ca = Split(Rname2_2c, "^")
        Rname2_2cacnt = uBound(Rname2_2ca)
      end if
    end if

    Response.Write retext

    'response.Write "Rname2_2cacnt="&Rname2_2cacnt

    if Rname2_2cacnt <> 0 then

      Dim arr()
      ReDim arr(Rname2_2cacnt - 1, LRsCnt1 - 1)   
    
        iType = "21"
    
        LSQL = "EXEC Stat_Match_Point_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	      Set LRs = Dbcon.Execute(LSQL)
    
          If Not (LRs.Eof Or LRs.Bof) Then
	  	        Do Until LRs.Eof
              
                For i = 0 To Rname2_2cacnt - 1
                
                  For j = 0 To LRsCnt1 - 1
    
    
                    if Rname2_2ca(i+1) = LRs("SpecialtyDtlName") and Rname1_1(j) = LRs("ResultName") then 
                  
                      arr(i,j) = "<td>"&LRs("Jumsu")&"</td>"
                  
                    end if
          
    
                  NEXT
    
                NEXT
      
    
              LRs.MoveNext
	  	      Loop
          end if
    
        numrows = UBound(arr, 1) '행  
        numcols = UBound(arr, 2) '열  
        cnt = 0  	
	  
        For i = 0 To numrows '행
            Response.Write "<tr>"
            response.Write "<th>"&Rname2_2ca(i+1)&"</th>"
            For j = 0 To numcols '열             
	  		  	
	  		        if arr(i, j) = "" then
                  Response.Write "<td></td>"
                else
                  Response.Write arr(i, j)
                end if
	  		
            Next
            Response.Write "</tr>"
        
        Next

    end if



  end if

  Response.Write "      </tbody>"
	Response.Write "		</table>"


%>