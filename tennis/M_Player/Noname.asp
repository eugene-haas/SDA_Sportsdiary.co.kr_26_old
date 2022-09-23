<!-- #include file="Library/JSON_2.0.4.asp" -->
<!-- #include file="Library/JSON_UTIL_0.1.1.asp" -->
<%
Dim json
Dim person, people(4)

For i = 0 To 4
	Set person = jsObject()
	person("name") = "park"
	person("age") = 20
	person("sex") = "male"
	Set people(i) = person
Next

Set json = jsObject()
json("count") = Ubound(people)
json("people") = people

Response.Write toJSON(json)
' °á°ú
'{"count":4,"people":[{"name":"park","age":20,"sex":"male"},{"name":"park","age":20,"sex":"male"},{"name":"park","age":20,"sex":"male"},{"name":"park","age":20,"sex":"male"},{"name":"park","age":20,"sex":"male"}]}
%>