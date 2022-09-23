<% @LANGUAGE="JSCRIPT" CODEPAGE="65001" %>
<%
    // Custom Functions
    function $_GET(values) {
        return Request.QueryString(values)!="undefined"?String(Request.QueryString(values)):null;
    }

    function echo(values) {
        Response.Write(values);
    }

    // Define Timeout Limit
    Server.ScriptTimeout = 10;

    Object.prototype.toParam = function(){
        var querystring = [];
        for (var inc in this) {
            if(!this.hasOwnProperty(inc)) continue;
            if (this[inc]!=null) {
                querystring.push(inc + "=" + Server.URLEncode(String(this[inc])));
            } else {
                querystring.push(inc + "=");
            }
        }

        return querystring.join("&amp;");
    }

    var xmlHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP");

    // 원래 AJAX 요청을 수행하려던 페이지를 호출한다
    xmlHTTP.open("GET", "http://www.example.com/idrequest", false); //, false, false);

    xmlHTTP.setRequestHeader("Content-type", "text/xml");
    xmlHTTP.setRequestHeader("Cache-control","no-cache");

    xmlHTTP.send();

    Response.Write(xmlHTTP.responseText);

    xmlHTTP = null;
%>

<%'출처: http://heartdev.tistory.com/170 [Heart's Develop Inside]%>