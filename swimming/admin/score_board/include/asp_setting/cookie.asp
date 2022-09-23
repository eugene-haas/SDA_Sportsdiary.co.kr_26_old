
<%
	'----------------------------------------------------------------------
	'@description
	'	입력된 데이터 공백, null 체크 후 Boolean 값을 반환한다.
	'@param
	'	(string) value : 데이터값
	'@return
	'	(Boolean) true or false
	'----------------------------------------------------------------------
	Function chkBlank(ByVal value)
		If Trim(value) = "" Or Len(Trim(value)) = 0 Or IsNull(value) Or IsEmpty(value)  Then
			chkBlank = True
		Else
			chkBlank = False
		End If
	End Function
%>
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->
<script language="Javascript" runat="server">
function IsJsonString(str) {
  try {
    var json = JSON.parse(str);
    return (typeof json === 'object');
  } catch (e) {
    return false;
  }
}
</script>
<%

'####################################
'전광판 쿠키
'####################################
Cookies_billBoard = request.Cookies("BBE2") '전광판 쿠키
If Cookies_billBoard <> "" Then
	Cookies_billBoard =  f_dec(Cookies_billBoard)
Else
	Cookies_billBoard = "''"
End if
'#################################

%>
