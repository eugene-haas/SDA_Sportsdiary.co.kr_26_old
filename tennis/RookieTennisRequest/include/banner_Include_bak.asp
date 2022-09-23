  <%

    ' SD몰 로그인 안해도 무조건 보내는데 사용

    Do Until LRs.Eof
    
    iLink = LRs("Link")
    
    if Len(iLink) = 0 then
    
      iLink = ""
    
    else
    
      'if instr(iLink,"?") > 0 then
      '
      '  iLink = iLink&"&"&tpara
      '
      'else
      '
      '  iLink = iLink&"?"&tpara
      '
      'end if

      if ((instr(iLink,"sdamall") > 0) or (instr(iLink,"sdmembers") > 0)) then
    
        iSDMallYN = "Y"
    
      else
    
        iSDMallYN = "N"
    
      end if
    
    end if

    iLinkType = LRs("LinkType")
    iProductLocateIDX = LRs("ProductLocateIDX")
    ieProductLocateIDX = encode(LRs("ProductLocateIDX"), 0)

    Set mallobj =  JSON.Parse("{}")
	  Call mallobj.Set("M_MIDX", iLIMemberIDXG ) '로그인이 필요없이 이동할때 0
	  Call mallobj.Set("M_PR", "R" ) 'R: 선수 S:예비후보선수, L:지도자, A,B,Z:보호자, D:일반
	  Call mallobj.Set("M_SGB", iLISportsGb )

	  Call mallobj.Set("M_BNKEY", iProductLocateIDX ) '베너URL 찾아서 보냄 상품코드가 있을시는 ? ...
	  strjson = JSON.stringify(mallobj)
	  malljsondata = mallencode(strjson,0)

	  MALLURL = "http://www.sdamall.co.kr/pub/"
    
  %>
  <% if (IPHONEYN() = "0" and iLinkType = "2") then %>
    <% if iLink = "" then %>
    <div style="background-color: #<%=LRs("BColor")%>"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </div>
    <% else %>
      <% if iSDMallYN = "Y" and iLIMemberIDXG <> "" then %>
      <div style="background-color: #<%=LRs("BColor")%>"> <a href="<%=MALLURL%>tube.asp?p=<%=Server.URLEncode(malljsondata)%>" class="banner_area" target="_blank" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </a> </div>
      <% elseif iSDMallYN = "Y" and iLIMemberIDXG = "" then %>
      <div style="background-color: #<%=LRs("BColor")%>"> <a href="<%=MALLURL%>tube.asp?p=<%=Server.URLEncode(malljsondata)%>" class="banner_area" target="_blank" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </a> </div>
      <% else %>
      <div style="background-color: #<%=LRs("BColor")%>"> <a href="<%=iLink %>" class="banner_area" target="_blank" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </a> </div>
      <% end if %>
    <% end if %>
  <% else %>
    <% if iLink = "" then %>
    <div style="background-color: #<%=LRs("BColor")%>"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </div>
    <% else %>
      <% if iSDMallYN = "Y" and iLIMemberIDXG <> "" then %>
      <div style="background-color: #<%=LRs("BColor")%>"> <a href="javascript:;" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');alert('sportsdiary://urlblank=<%=MALLURL%>tube.asp?p=<%=Server.URLEncode(malljsondata)%>');" class="banner_area"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </a> </div>
      <% elseif iSDMallYN = "Y" and iLIMemberIDXG = "" then %>
      <div style="background-color: #<%=LRs("BColor")%>"> <a href="http://sdmain.sportsdiary.co.kr/sdmain/login.asp" class="banner_area"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </a> </div>
      <% else %>
      <div style="background-color: #<%=LRs("BColor")%>"> <a href="javascript:;" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');javascript:fn_mclicklink('<%=iLinkType %>','<%=iLink %>');" class="banner_area"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </a> </div>
      <% end if %>
    <% end if %>
  <% end if %>
  <%
          LRs.MoveNext
      Loop
  %>