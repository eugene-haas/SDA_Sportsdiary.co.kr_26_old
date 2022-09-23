<!--#include virtual="/Manager/Library/config.asp"-->
<%
	StadiumNumber = fInject(Request("StadiumNumber"))


	GameDay = fInject(Request("GameDay"))




  Search_GroupGameGb = fInject(Request("Search_GroupGameGb"))

	Search_TeamGb      = fInject(Request("Search_TeamGb"))


  Level              = fInject(Request("Level"))

	H_MediaLink         = fInject(Request("H_MediaLink"))
	H_PlayerResultIDX  = fInject(Request("H_PlayerResultIDX"))

	

	MediaLink = Replace(H_MediaLink,"https://youtu.be/","https://youtube.com/embed/")

	UpSQL = "update tblPlayerResult set MediaLink='"&MediaLink&"' where PlayerResultIDX = '"&H_PlayerResultIDX&"'"

	Dbcon.Execute(UpSQL)

	
	%>
	<script>
	location.href="MatchUpload.asp?StadiumNumber=<%=StadiumNumber%>&GameDay=<%=GameDay%>&Search_GroupGameGb=<%=Search_GroupGameGb%>&Search_TeamGb=<%=Search_TeamGb%>&Level=<%=Level%>"
	</script>