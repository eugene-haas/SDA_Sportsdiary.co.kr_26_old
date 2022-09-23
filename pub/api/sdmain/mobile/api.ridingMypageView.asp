<%
'#############################################
'승마 마이페이지
'#############################################
	'request

if request.cookies("SD") <> "" Then

  Set db = new clsDBHelper

  If hasown(oJSONoutput, "id") = "ok" then
    id = fInject(oJSONoutput.id)
  End if

  if request.cookies("SD")("userid") = id then
    sql = "select UserID,UserName,sex,Birthday,UserPhone,SmsYn,Email,EmailYn,ZipCode,Address,AddressDtl,PushYN from tblMember where DelYN = 'N' and UserID = '"& id &"'"
    Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

    if not rs.eof Then
      strjson = "{""ID"": """& rs("UserID") &""", ""NAME"": """& rs("UserName") &""", ""GENDER"": """& rs("sex") &""", ""BIRTHDAY"": """& rs("Birthday") &""", ""PHONE"": """& rs("UserPhone") &""", "
      strjson = strjson & """SMSYN"": """& rs("SmsYn") &""", ""EMAIL"": """& rs("Email") &""", ""EMAILYN"": """& rs("EmailYn") &""", ""ZIPCODE"": """& rs("ZipCode") &""", ""ADDRESS"": """& rs("Address") &""", "
      strjson = strjson & """ADDRESSDTL"": """& rs("AddressDtl") &""", ""PUSHYN"": """& rs("PushYN") &"""}"
      response.write "{""jlist"": ["& strjson &"]}"
    else
      response.write "{""jlist"": ""nodata""}"
    end if
  else
    response.write "{""jlist"": ""nodata""}"
  end if
else
  response.write "{""jlist"": ""nodata""}"
end if
%>
