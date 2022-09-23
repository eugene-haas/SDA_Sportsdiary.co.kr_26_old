<%
'#############################################
' 부 재조회 - 심사기록입력
'#############################################
	Set db = new clsDBHelper

    If hasown(oJSONoutput, "TIDX") = "ok" Then 
        tIdx = oJSONoutput.TIDX                   
    End If

    If hasown(oJSONoutput, "GYEAR") = "ok" Then 
        nowgameyear = oJSONoutput.GYEAR                   ' GameYear
    End If


    If hasown(oJSONoutput, "GBIDX") = "ok" Then 
        find_gbidx = oJSONoutput.GBIDX                   ' GameTitleIDX
    End If

  %><!-- #include virtual = "/pub/html/riding/boocontrollistno.asp" --><%

  db.Dispose
  Set db = Nothing 
%>
