<!--#include file="../dev/dist/config.asp"-->
<%
   	Check_AdminLogin()
   
	dim CIDX 	: CIDX 		= crypt.DecryptStringENC(fInject(request("CIDX")))  
   	dim LC_Num 	: LC_Num 	= fInject(request("LC_Num"&request("CIDX")))
	
   	IF CIDX = "" Then
   		response.write "<script>alert('잘못된 접근입니다. 확인 후 이용하세요.'); self.close();</script>"
   		response.end
   	Else
   		
   		dim LicenseNumber, UserName, UserBirth, RefereeLvl, LicenseDt
   
   		LSQL = "    	SELECT A.LicenseIDX"
		LSQL = LSQL & "		,B.PubName RefereeNm"
		LSQL = LSQL & "		,A.RefereeLevel RefereeLvl"
		LSQL = LSQL & "		,A.LicenseNumber"
		LSQL = LSQL & "		,A.LicenseDt"
		LSQL = LSQL & "		,A.UserName"
		LSQL = LSQL & "		,CASE WHEN A.UserBirth<>'' THEN SUBSTRING(A.UserBirth, 3, 2)+'.'+SUBSTRING(A.UserBirth, 5, 2)+'.'+SUBSTRING(A.UserBirth, 7, 2) END UserBirth"
		LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblLicenseInfo] A"
		LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblPubcode] B on A.RefereeGb = B.PubCode"
		LSQL = LSQL & "			AND B.DelYN = 'N'"
		LSQL = LSQL & "			AND B.PPubCode = 'LICENSE'"
		LSQL = LSQL & "	WHERE A.DelYN = 'N'"
   		LSQL = LSQL & "		AND A.LicenseIDX = '"&CIDX&"'"	
		LSQL = LSQL & "	ORDER BY A.RefereeGb, A.UserName"

		'response.Write LSQL

		SET LRs = DBCon.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 

			LicenseNumber = ReHtmlSpecialChars(LRs("LicenseNumber"))
		 	UserName = LRs("UserName")		
		 	UserBirth = LRs("UserBirth")		
		 	RefereeLvl = LRs("RefereeLvl")		
			LicenseDt = mid(formatdatetime(LRs("LicenseDt"), 1), 1, len(formatdatetime(LRs("LicenseDt"), 1))-4)

		Else
		 	response.write "<script>alert('일치하는 정보가 없습니다. 확인 후 이용하세요.'); self.close();</script>"
   			response.end
		End IF   
   	End IF
%>

<!-- S: print_area -->
<div class="print_area">

  <table border="6" cellpadding="0" cellspacing="0" width="680" height="100%" style="border-style:double;border-width:6px;border-color:#000000;" valign="top">
    <tbody>
      <tr>
      <td valign="top">
        <table border="0" cellpadding="30" cellspacing="10" class="plane" height="100%" width="100%">
          <tbody><tr height="100%">
            <td height="100%" valign="top">
              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tbody><tr height="60">
                  <td colspan="4"><font style="font-family:궁서체; font-size:20pt; color:#000000; line-height:25pt;"><b>대배협&nbsp;<%=LC_Num%>호</b></font></td>
                </tr>
                <tr height="50">
                  <td colspan="4">&nbsp;</td>
                </tr>

                <tr height="80">
                                <td colspan="4" align="center"><font style="font-family:궁서체; font-size:40pt; color:#000000; line-height:50pt;"><b>심판 자격증명원</b></font></td>
                </tr>
                <tr height="80">
                  <td colspan="4">&nbsp;</td>
                </tr>

                <tr>
                                <td width="22%"><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 :</b></font></td>
                  <td width="29%"><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>&nbsp;<%=UserName%></b></font></td>
                  <td width="17%"><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>자격종목 :</b></font> </td>
                  <td width="32%"><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>&nbsp;배드민턴</b></font></td>
                </tr>

                <tr>
                                <td><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-2;"><b>생&nbsp;년&nbsp;&nbsp;월&nbsp;일 : </b></font></td>
                  <td><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>&nbsp;<%=UserBirth%></b></font></td>
                  <td><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>자격등급 : </b></font></td>
                <td><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>&nbsp;<%=RefereeLvl%>급</b></font></td>
                </tr>


                <tr>
                  <td><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-3;"><b>자격취득일자 : </b></font></td>
                    <td><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>&nbsp;<%=LicenseDt%></b></font></td>
                    <td><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>발급번호 : </b></font></td>
                    <td><font style="font-family:궁서체; font-size:15pt; color:#000000; line-height:20pt;letter-spacing:-1;"><b>&nbsp;대배드  제<%=LicenseNumber%>호</b></font></td>
                </tr>
                <tr height="100">
                  <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="4"><center><font style="font-family:궁서체; font-size:30pt; color:#000000; line-height:40pt;"><!--<b>본 협회 심판위원회 규정 제16조에 의하여 위의 자격이 있음을 증명함</b>--><b>위와 같이 자격이 있음을<br> 확인 함</b></font></center></td>
                </tr>
                <tr height="120">
                  <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                <td colspan="4"><center><font style="font-family:궁서체; font-size:20pt; color:#000000; line-height:25pt;"><b><%=Year(date())&"년 "&Month(date())&"월 "&Day(date())&"일"%></b></font></center></td>             </tr>
                <tr height="60">
                <td colspan="4">&nbsp;</td></tr>
                <tr>
                  <td colspan="4"><center>
                    <font style="font-family:궁서체; font-size:20pt; color:#000000; line-height:25pt;"><b>사단법인</b></font> <font style="font-family:궁서체; font-size:30pt; color:#000000; line-height:40pt;">대한배드민턴협회장</font>
                    </center>               </td>
                </tr>
              </tbody></table>
            </td>
          </tr>
        </tbody></table>              
      </td>
    </tr>
  </tbody></table>
  
</div>
<!-- E: print_area -->

<!--#include file="../include/footer.asp"-->