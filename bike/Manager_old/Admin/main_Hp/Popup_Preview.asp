<!--#include file="../dev/dist/config.asp"-->
<HTML>
 <HEAD>
  <TITLE> 팝업 미리보기 </TITLE>
 </HEAD>
<%
	dim CIDX			: CIDX   		= fInject(Request("CIDX"))
	
	dim CSQL, CRs
	dim Subject, PWidth, PHeight, PLeft, PTop, PZindex
	dim PSDate, PEDate, PContents, PUseYN, PDailyUseYN
	dim PDailyBgColor, PDailyTxtColor, PBackground, PBgColor, PBorder, PBorderColor
		
	IF CIDX <> "" Then
		CSQL = "		SELECT * "
		CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblPopupManage]"
		CSQL = CSQL & " WHERE DelYN = 'N'"
		CSQL = CSQL & " 	AND PopIDX = '"&CIDX&"'"
		
		SET CRs = DBCon.Execute(CSQL)   
		IF Not(CRs.eof or CRs.bof) Then
			Subject = CRs("Subject")
			PWidth = CRs("PWidth")
			PHeight = CRs("PHeight")
			PLeft = CRs("PLeft")
			PTop = CRs("PTop")
			PSDate = CRs("SDate")
			PEDate = CRs("EDate")
			PContents = CRs("PContents")
			PUseYN = CRs("PUseYN")
			PDailyUseYN = CRs("PDailyUseYN")
			PZindex	= CRs("PZindex")
			PDailyBgColor = CRs("PDailyBgColor")
			PDailyTxtColor = CRs("PDailyTxtColor")
			PBackground	= CRs("PBackground")
			PBgColor = CRs("PBgColor")
			PBorder	= CRs("PBorder")
			PBorderColor = CRs("PBorderColor")
		End IF
			CRs.Close
		SET CRs = Nothing
	Else
		
		response.Write "<script>"
		response.Write "	alert('잘못된 접근입니다. 확인 후 이용하세요.');"
		response.Write "	window.close();"
		response.Write "</script>"
		response.End()
	End IF
	
	DBClose()	
%>

<BODY>
<!-- S : content -->
    <div title="<%=Subject%>" style="position:absolute; border:<%=PBorder%>px solid #<%=PBorderColor%>;  
		<%
		IF PZindex <> "" Then response.Write "z-index:"&PZindex&";"
		IF PHeight <> "" Then response.Write "height:"&PHeight&"px;"
		IF PWidth <> "" Then response.Write "width:"&PWidth&"px;"
		IF PLeft <> "" Then response.Write "left:"&PLeft&"px;"
		IF PTop <> "" Then response.Write "top:"&PTop&"px;" 	
		IF PBgColor <> "" Then response.Write "background-color:#"&PBgColor&";" 
		IF PBackground <> "" Then response.Write "background-image:url(../FileTemp/"&PBackground&"); background-repeat:no-repeat;" 		
	%>">
        <%=PContents%>
        
		
        <div style="font-weight:normal; position:absolute;bottom:0;width:100%;padding:8px 0; font-size:12px;<%
			IF PDailyBgColor <> "" Then response.Write "background-color:#"&PDailyBgColor&";" 
			IF PDailyTxtColor <> "" Then response.Write "color:#"&PDailyTxtColor&";"
        %>">
        		
				
			<%IF PDailyUseYN = "Y" Then%>
            <input id="CHK_Day<%=CIDX%>" name="CHK_Day<%=CIDX%>" type="checkbox" onClick="window.close();" style="float:left;margin-right:3px;margin-left:10px;" />
            <span style="float:left;margin-top:2px;">오늘 하루 보지 않기</span>         
            <%End IF%>
            <span onClick="window.close();" style="float:right;margin-right:10px;">닫기</span>
        
            
        </div>    
        
    </div>
    
<!-- E : content -->
</BODY>
</HTML>