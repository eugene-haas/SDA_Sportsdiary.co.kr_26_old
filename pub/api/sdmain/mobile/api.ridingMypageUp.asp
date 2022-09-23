<%
'#############################################
'승마 마이페이지 수정
'#############################################
	'request

if request.cookies("SD") <> "" Then

  Set db = new clsDBHelper

  If hasown(oJSONoutput, "id") = "ok" then
    id = fInject(oJSONoutput.id)
  End if
  If hasown(oJSONoutput, "PHONE") = "ok" then
    PHONE = fInject(oJSONoutput.PHONE)
  Else
    PHONE = ""
  End if
  If hasown(oJSONoutput, "PHONEAUTH") = "ok" then
    PHONEAUTH = fInject(oJSONoutput.PHONEAUTH)
  Else
    PHONEAUTH = ""
  End if
  If hasown(oJSONoutput, "SMSYN") = "ok" then
    SMSYN = fInject(oJSONoutput.SMSYN)
  Else
    SMSYN = ""
  End if
  If hasown(oJSONoutput, "EMAIL") = "ok" then
    EMAIL = fInject(oJSONoutput.EMAIL)
  Else
    EMAIL = ""
  End if
  If hasown(oJSONoutput, "EMAILYN") = "ok" then
    EMAILYN = fInject(oJSONoutput.EMAILYN)
  Else
    EMAILYN = ""
  End if
  If hasown(oJSONoutput, "ZIPCODE") = "ok" then
    ZIPCODE = fInject(oJSONoutput.ZIPCODE)
  Else
    ZIPCODE = ""
  End if
  If hasown(oJSONoutput, "ADDRESS") = "ok" then
    ADDRESS = fInject(oJSONoutput.ADDRESS)
  Else
    ADDRESS = ""
  End if
  If hasown(oJSONoutput, "ADDRESSDTL") = "ok" then
    ADDRESSDTL = fInject(oJSONoutput.ADDRESSDTL)
  Else
    ADDRESSDTL = ""
  End if

  if request.cookies("SD")("userid") = id then
    if EMAIL <> "" and ZIPCODE <> "" and ADDRESS <> "" and ADDRESSDTL <> "" Then
      checksql = "select count(memberidx) as chk,memberidx from tblMember where DelYN = 'N' and UserID = '"& id &"' group by memberidx"
      Set rs = db.ExecSQLReturnRS(checksql , null, T_ConStr)
      if not rs.eof then
        if rs("chk") = "1" then
          updateitem = ""
          if SMSYN <> "" then updateitem = updateitem & "SmsYn='"& SMSYN &"', SmsYnDt=getdate(), "
          if EMAILYN <> "" then updateitem = updateitem & "EmailYn='"& EMAILYN &"', EmailYnDt=getdate(), "
          if PHONEAUTH = "OK" then updateitem = updateitem & "UserPhone='"& PHONE &"', "

          updatesql = "update tblMember set Email='"& EMAIL &"', ZipCode='"& ZIPCODE &"', Address='"& ADDRESS &"', AddressDtl='"& ADDRESSDTL &"', "& updateitem &" ModDate=getdate() where MemberIDX='"& rs("memberidx") &"'"
          Call db.execSQLRs(updatesql , null, T_ConStr)
          'response.write updatesql

          response.write "{""jlist"": ""OK""}"
        else
          response.write "{""jlist"": ""NOT""}"
        end if
      else
        response.write "{""jlist"": ""NOT""}"
      end if
      set rs = nothing
    Else
      response.write "{""jlist"": ""NOT""}"
    end if
  else
    response.write "{""jlist"": ""NOT""}"
  end if
else
  response.write "{""jlist"": ""NOT""}"
end if
%>
