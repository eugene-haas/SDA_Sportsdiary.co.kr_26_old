<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":1,""tIDX"":""47E0533CF10C4690F617881B06E75784"",""tStadiumIdx"":""D3510D3EEF159089CEE3710534553C12""}"
  Set oJSONoutput = JSON.Parse(REQ)
	tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))
  crypt_tIDX =crypt.EncryptStringENC(tIDX)
  tStadiumIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIdx))
  'Response.Write "tIDXtIDXtIDXtIDXtIDX :" & tIDX & "<br>"
  'Response.Write "crypt_tIDXcrypt_tIDXcrypt_tIDXcrypt_tIDX :" & crypt_tIDX & "<br>"
  'Response.Write "tStadiumIdxtStadiumIdxtStadiumIdx :" & tStadiumIdx & "<br>"
  LSQL = "SELECT Top 1 StadiumIDX, GameTitleIDX, StadiumName, StadiumCourt,StadiumAddr,StadiumAddrDtl, WriteDate"
  LSQL = LSQL & " FROM  tblStadium"
  LSQL = LSQL & " WHERE DelYN ='N' and GameTitleIDX = '" & tIDX  & "' and StadiumIDX = '" & tStadiumIdx & "'"
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tStadiumIDX = LRs("StadiumIDX")
      crypt_tStadiumIDX =crypt.EncryptStringENC(tStadiumIDX)
      tGameTitleIDX = LRs("GameTitleIDX")
      tStadiumName = LRs("StadiumName")
      tStadiumCourt = LRs("StadiumCourt")
      tWriteDate = LRs("WriteDate")
      tStadiumAddr = LRs("StadiumAddr")
      tStadiumAddrDtl = LRs("StadiumAddrDtl")

      LRs.MoveNext
    Loop
  End If
  LRs.close

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>


 <table class="left-head view-table navi-tp-table">
  <caption>대회정보 기본정보</caption>
  <colgroup>
    <col width="110px">
    <col width="*">
    <col width="110px">
    <col width="*">
    <col width="110px">
    <col width="*">
  </colgroup>
  <tbody>
    <tr>
      <th scope="row"><label for="competition-StadiumName">경기번호</label></th>
      <td>
        <div>
          <span><%=tStadiumIDX%></span>
          <input type="hidden" id="selStadium" value="<%=crypt_tStadiumIDX%>">
        </div>
      </td>
    </tr>
    <tr>
      <th scope="row"><label for="competition-StadiumName">경기 장소</label></th>
      <td>
        <div>
          <span><input type="text" id="txtStadiumName" value="<%=tStadiumName%>" ></span>
        </div>
      </td>
    </tr>
    <tr>
      <th scope="row">주소</th>
      <td><div>
				<span class="con">
          <!-- <input type="hidden" readonly name="ZipCode" id="ZipCode"/>-->
          
          <input type="text" readonly name="Addr" id="Addr" value="<%=tStadiumAddr%>" onClick="execDaumPostCode();" /></span>
          <span class="con"><input type="text" name="AddrDtl" id="AddrDtl" placeholder="나머지 주소 입력" value="<%=tStadiumAddrDtl%>" />
          </span> <a href="javascript:execDaumPostCode();" class="btn btn-confirm">주소검색</a></div></td>
    </tr>
    <tr>
      <th scope="row"><label for="competition-CourtCnt">코트수</label></th>
      <td>
        <div>
          <span><input type="text" id="txtCourtCnt" value="<%=tStadiumCourt%>" ></span>
        </div>
      </td>
    </tr>
  </tbody>
</table>

<!-- S: btn-list-left -->
<div class="btn-list-left">
    <a href="#" id="btnsave" class="btn btn-confirm" onclick="inputStadium_frm();" accesskey="i">등록(I)</a>
    <a href="#" id="btnupdate" class="btn btn-add" onclick="updateStadium_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
    <a href="#" id="btndel" class="btn btn-red" onclick="delStadium_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a>
  </div>
  <!-- E: btn-list-left -->
</div>