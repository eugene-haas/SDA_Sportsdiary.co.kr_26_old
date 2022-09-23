<%

'  ksmmeberidx = Request.Cookies(SportsGb)("MemberIDX")
'
'  if ksmmeberidx <> "" then
'
'    iType = "1"
'
'    dksmmeberidx = decode(ksmmeberidx,0)
'    
'    LSQL = "EXEC Favor_R '" & iType & "','" & dksmmeberidx & "','','','','',''"
'    'response.Write "LSQL="&LSQL&"<br>"
'    'response.End
'    
'    Set LRs = DBCon3.Execute(LSQL)
'    If Not (LRs.Eof Or LRs.Bof) Then
'      Do Until LRs.Eof
'      
'        FavorYN = LRs("FavorYN")
'
'      LRs.MoveNext
'      Loop
'    End If
'    LRs.close
'
'    'if FavorYN = "N" then
'    '
'    '  response.Redirect("http://sdmain.sportsdiary.co.kr/sdmain/interested_category.asp")
'    '  response.End
'    '
'    'end if
'
'  end if
'
%>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-137374003-2"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-137374003-2');
</script>
