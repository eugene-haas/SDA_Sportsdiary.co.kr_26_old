<% 
'   ===============================================================================     
'    Purpose : Coupon 발급조건 설정 Form
'    Make    : 2018.12.03
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%>

<% 
'   ===============================================================================     
'    아래 선언된 function들은 다음 경로를 참조하면 된다. 
'      /pub/util/badmt/sql/sql.badmt.asp 참조  - sql query 선언
'      /pub/js/etc/utx.js              - utx Function 정의 되어 있음. 
'      /pub/js/etc/ctx.js              - ctx Function 정의 되어 있음. 
'   ===============================================================================     
%> 

<% 
    ' Call writeLog(SAMALL_LOG1, "c.publish.manage.asp --. start")    
%>

<% 
'   ===============================================================================     
'      아래 값은 Html element의 크기및 간격을 맞추기 위해 선언된 변수들이다. 
'   =============================================================================== 
    Dim trw_reg1, trw_reg2, fgap_reg, cgap_reg
    trw_reg1 = "15%;"
    trw_reg2 = "85%;"
    trw_reg3 = "100%;"
    fgap_reg = "5"
    cgap_reg = "10"

    ' sel, textbox, datectrl Element Width
    Dim txtw_reg, lbw_reg, chkw_reg
    txtw_reg = "150"
    lbw_reg = "80"
    chkw_reg = "90"

'   =============================================================================== 
%>

<%
  
'  위에 선언한 변수들은 oJSONoutput으로 넘어와 execpublishSearch() 안에서 셋팅한다.      
'  ===============================================================================   
    Dim userName, birthDay, sex, phone, team, sido, gugun, authYN, smsSendYN
    Dim sName, sBirth, sPhone, sClub, sSido, sGugun
    Dim chkName, chkBirth, chkPhone, chkClub, chkSido, chkGugun, chkTmp
    Dim allowMod 

    If hasown(oJSONoutput, "NAME") = "ok" Then  'search 조건 : 이름
            sName = chkStrRpl(oJSONoutput.NAME,"")
    End If

    If hasown(oJSONoutput, "BIRTH") = "ok" Then  'search 조건 : 생년월일
		sBirth = chkStrRpl(oJSONoutput.BIRTH,"")
	End If

    If hasown(oJSONoutput, "PHONE") = "ok" Then  'search 조건 : 전화번호
		sPhone = chkStrRpl(oJSONoutput.PHONE,"")
	End If

    If hasown(oJSONoutput, "CLUB") = "ok" Then  'search 조건 : 클럽
        sClub = chkStrRpl(oJSONoutput.CLUB,"")
    End If

    If hasown(oJSONoutput, "SIDO") = "ok" Then  'search 조건 : 시도
        sSido = chkStrRpl(oJSONoutput.SIDO,"")
    End If

    If hasown(oJSONoutput, "GUGUN") = "ok" Then  'search 조건 : 구군
        sGugun = chkStrRpl(oJSONoutput.GUGUN,"")
    End If

    If hasown(oJSONoutput, "CHK") = "ok" Then  'search 조건 : Check Box Value
        chkTmp = chkStrRpl(oJSONoutput.CHK,"")

        strLen = Len(chkTmp)
        If(strLen = 6) Then
            chkName     = Mid(chkTmp, 1, 1)
            chkBirth    = Mid(chkTmp, 2, 1)
            chkPhone    = Mid(chkTmp, 3, 1)
            chkClub     = Mid(chkTmp, 4, 1)
            chkSido     = Mid(chkTmp, 5, 1)
            chkGugun    = Mid(chkTmp, 6, 1)
        End If

'        strLog = strPrintf("chkName = {0}, chkBirth = {1}, chkPhone = {2}, chkClub = {3}, chkSido = {4}, chkGugun = {5}", _
'                        Array(chkName, chkBirth, chkPhone, chkClub, chkSido, chkGugun))
'        rESPONSE.WRITE strLog
    End If
%>

<%
	strSql = getSqlSearchRegPlayer(sName, sBirth, sPhone, sClub, sSido, sGugun)
    Call writeLog(SAMALL_LOG1, "======================================= CMD_COACHSEARCH_FORREG")   
    Call writeLog(SAMALL_LOG1, "sql = " & strSql)   
    Call writeLog(SAMALL_LOG1, "======================================= CMD_COACHSEARCH_FORREG")   

   allowMod = 0

    If ( strSql <> "") Then 
        Set rs = db.ExecSQLReturnRS(strSql , null, BadMin_ConStr) 
'  ===============================================================================   
        If Not (rs.Eof Or rs.Bof) Then
                aryUsers = rs.GetRows()
                allowMod = UBound(aryUsers, 2) + 1      ' 데이터가 1개 있을 경우 LBound, UBound 모두 0을 반환한다. 
                seq      = aryUsers(0,0)  
        End If
        Set rs = Nothing
    End If
       
%>


<!-- Search Form value -->
    <form method='post' name='pub_sform'><input type='hidden' name='p'></form>
                
    <!-- ********************************************* modal-content *********************************************************  -->
    <div class="table-box basic-table-box" id="w_form">
  
    <!-- ********************************************* search condition Div *********************************************************  --> 
        <div id = div_pubCond_search>
        <table id = "tbPubCond_search" class = "clsPubCond_search" cellspacing="0" cellpadding="0">

            <!-- ************ 발급대상 검색 ************  -->
            <tr id="trPub_sub" colspan="2">
                    <td colspan="2" style="width:<%=trw_reg3%>background:#c2c5ba;"> 
                        <span style ="font-weight:bold;"> 신청 회원검색 (검색할 회원 정보를 입력하세요)</span>
                    </td>
            </tr>

            <!-- ************ 회원조건검색 ************  -->
            <tr id="tr_pubCond" colspan="2">
                <td style="width:<%=trw_reg1%>background:gray;color:white">회원조건검색</td>
                <td style="width:<%=trw_reg2%>;word-break:break-all;">
                    <div style="width:100%;border-bottom: 1px dotted gray;text-align:left;padding:5px"> 
                        <label class="label_space" style = "width:<%=fgap_reg%>px;"> </label>   

                        <div>
                            <label class="chk-box" style = "width:<%=chkw_reg%>px;">
                            <input type="checkbox" id="chk_sName"  <% If chkName = "Y" Then %>checked<% End If %> >
                                <span>이름:</span>                                  
                            </label> 

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <input type='text' id="txt_sName" value="<%=sName%>" style= "width:<%=txtw_reg%>px; text-align: right">   

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label> 
                            <label class="chk-box" style = "width:<%=chkw_reg%>px;">
                            <input type="checkbox" id="chk_sBirthDay" <% If chkBirth = "Y" Then %>checked<% End If %> >
                                <span>생년월일:</span>                                  
                            </label>   
                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <input type='text' id="txt_sBirthDay" value="<%=sBirth%>" style= "width:<%=txtw_reg%>px; text-align: right">   

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <label class="chk-box" style = "width:<%=chkw_reg%>px;">
                            <input type="checkbox" id="chk_sPhone" <% If chkPhone = "Y" Then %>checked<% End If %> >
                                <span>전화번호:</span>                                  
                            </label>
                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <input type='text' id="txt_sPhone" value="<%=sPhone%>" style= "width:<%=txtw_reg%>px; text-align: right">   
                        </div>
                        <div>
                            <label class="chk-box" style = "width:<%=chkw_reg%>px;">
                            <input type="checkbox" id="chk_sClub" <% If chkClub = "Y" Then %>checked<% End If %> >
                                <span>클럽:</span>                                  
                            </label>
                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <input type='text' id="txt_sClub" value="<%=sClub%>" style= "width:<%=txtw_reg%>px; text-align: right">   

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <label class="chk-box" style = "width:<%=chkw_reg%>px;">
                            <input type="checkbox" id="chk_sSido" <% If chkSido = "Y" Then %>checked<% End If %> >
                                <span>시도:</span>                                  
                            </label>
                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <input type='text' id="txt_sSido" value="<%=sSido%>" style= "width:<%=txtw_reg%>px; text-align: right">   

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <label class="chk-box" style = "width:<%=chkw_reg%>px;">
                            <input type="checkbox" id="chk_sGugun" <% If chkGugun = "Y" Then %>checked<% End If %> >
                                <span>구군:</span>                                  
                            </label>
                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <input type='text' id="txt_sGugun" value="<%=sGugun%>" style= "width:<%=txtw_reg%>px; text-align: right"> 

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>  
                            <a href="#" class="navy-btn" id="btnSearch" 
                            onclick="onSearch();" >검색</a>
                        </div>
                    </div>
                </td>
            </tr>

            <!-- ************ 변경 데이터 ************  -->
            <tr id="trPub_sub" colspan="2">
                    <td colspan="2" style="width:<%=trw_reg3%>background:#c2c5ba;"> 
                        <span style ="font-weight:bold;"> 변경 데이터 정보를 입력하세요 => 데이터 형식 준수 ( 19880101 / 010-8888-9999 )</span>
                    </td>
            </tr>

            <tr id="tr_pubCond" colspan="2">                
                <td style="width:<%=trw_reg1%>background:gray;color:white">변경 데이터</td>
                <td style="width:<%=trw_reg2%>;word-break:break-all;">
                    <div style="width:100%;border-bottom: 1px dotted gray;text-align:left;padding:5px"> 
                        <label class="label_space" style = "width:<%=fgap_reg%>px;"> </label>   

                        <div>
                            <label class="chk-box" style = "width:<%=chkw_reg%>px;">
                            <input type="checkbox" id="chk_name" value="1">
                                <span>이름:</span>                                  
                            </label> 

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <input type='text' id="txt_name" value="<%=strFindKey%>" style= "width:<%=txtw_reg%>px; text-align: right">   

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label> 
                            <label class="chk-box" style = "width:<%=chkw_reg%>px;">
                            <input type="checkbox" id="chk_birthDay" value="1">
                                <span>생년월일:</span>                                  
                            </label>   
                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <input type='text' id="txt_birthDay" value="<%=strFindKey%>" style= "width:<%=txtw_reg%>px; text-align: right">   

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <label class="chk-box" style = "width:<%=chkw_reg%>px;">
                            <input type="checkbox" id="chk_phone" value="1">
                                <span>전화번호:</span>                                  
                            </label>
                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>   
                            <input type='text' id="txt_phone" value="<%=strFindKey%>" style= "width:<%=txtw_reg%>px; text-align: right">   

                            <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>  
                            <a href="#" class="navy-btn" id="btnModify" 
                            onclick="onModify('<%=allowMod%>', '<%=seq%>');" >변경</a>
                        </div>
                    </div>
                </td>
            </tr>

            <!-- ************ SMS 재전송 ************  -->
            <tr id="trPub_sub" colspan="2">
                    <td colspan="2" style="width:<%=trw_reg3%>background:#c2c5ba;"> 
                        <span style ="font-weight:bold;"> SMS 재전송 - 데이터 변경 없이 재전송 할때만 사용하세요 </span>
                    </td>
            </tr>

            <tr id="tr_pubCond" colspan="2">                
                <td style="width:<%=trw_reg1%>background:gray;color:white">SMS 재전송</td>
                <td style="width:<%=trw_reg2%>;word-break:break-all;">
                    <div style="width:100%;border-bottom: 1px dotted gray;text-align:left;padding:5px"> 
                        <label class="label_space" style = "width:<%=fgap_reg%>px;"> </label>   

                        <label class="label_space" style = "width:<%=cgap_reg%>px;"> </label>  
                            <a href="#" class="navy-btn" id="btnModify" 
                            onclick="onSendSMS('<%=allowMod%>', '<%=seq%>');" >SMS 재전송</a>
                    </div>
                </td>
            </tr>


        </table>
        </div>
    <!-- ********************************************* publish condition Div *********************************************************  -->     

    <!-- ********************************************* publish target search list *********************************************************  -->     
    <!-- s: 테이블 리스트 -->
    <div class="table-box basic-table-box" id = "div_listPublish" style="height:480px;margin-top:80px;">
        <table id = "tb_listPublish" tb_cellspacing="0" cellpadding="0">

            <tr id="trPub_sub" colspan="2">
                
            </tr>
            <!-- *************************** Total Count Display***************************  -->     
            <tr> 
                <th style="width:50px;">No</th>                                                                      
                <th style="width:100px;">이름</th>
                <th style="width:100px;">생년월일</th>
                <th style="width:50px;">성별</th>             
                <th style="width:50px;">전화번호</th>
                <th style="width:80px;">팀</th>            
                <th style="width:80px;">팀Code</th>           
                <th style="width:80px;">시도</th>             
                <th style="width:80px;">시도Code</th>                              
                <th style="width:80px;">구군</th>            
                <th style="width:80px;">구군Code</th>            
                <th style="width:120px;">인증</th>                
                <th style="width:50px;">Sms발송</th>                             
            </tr>        

            <div id="divpub_searchlist">
                   
                <%
                    If IsArray(aryUsers) Then 
                        nl = LBound(aryUsers, 2)
                        ul = UBound(aryUsers, 2)    
                  
                        For i = nl to ul        
                            seq         = aryUsers(0,i)     
                            userName    = aryUsers(1,i)     
                            birthDay    = aryUsers(2,i)
                            sex         = aryUsers(3,i)            
                            phone       = aryUsers(4,i)
                            team        = aryUsers(5,i)                                
                            c_team      = aryUsers(6,i)   
                            sido        = aryUsers(7,i)    
                            c_sido      = aryUsers(8,i)    
                            gugun       = aryUsers(9,i)
                            c_gugun     = aryUsers(10,i)
                            authYN      = aryUsers(11,i)    
                            smsSendYN   = aryUsers(12,i)
                %>     
                        <tr style="cursor:pointer" id="trUser<%=seq%>">                             
                            <td class="coupon_val" id="tUser_idx<%=seq%>"><%=i+1%></td>          
                            <td class="coupon_val" id="tUser_name<%=seq%>"><%=userName%></td>
                            <td class="coupon_val" id="tUser_birthDay<%=seq%>"><%=birthDay%></td>
                            <td class="coupon_val" id="tUser_sex<%=seq%>"><%=sex %></td>                                                     
                            <td class="coupon_val" id="tUser_phone<%=seq%>"><%=phone%></td>
                            <td class="coupon_val" id="tUser_team<%=seq%>"><%=team%></td>
                            <td class="coupon_val" id="tUser_cteam<%=seq%>"><%=c_team%></td>
                            <td class="coupon_val" id="tUser_sido<%=seq%>"><%=sido%></td>                                      
                            <td class="coupon_val" id="tUser_csido<%=seq%>"><%=c_sido%></td>
                            <td class="coupon_val" id="tUser_gugun<%=seq%>"><%=gugun%></td>
                            <td class="coupon_val" id="tUser_cgugun<%=seq%>"><%=c_gugun%></td>
                            <td class="coupon_val" id="tUser_authYN<%=seq%>"><%=authYN %></td>                            
                            <td class="coupon_val" id="tUser_smsSendYN<%=seq%>"><%=smsSendYN%></td>  
                        </tr>
                <%        
                        Next 
                        Erase aryUsers
                    End If 
                %>
    <!-- </div> -->


            </div>
   
        </table>    
    </div>
        
<!-- ********************************************* modal-content *********************************************************  -->
    </div>
</div>

<% 
    ' Call writeLog(SAMALL_LOG1, "c.publish.manage.asp --. end")
%>


<script language="Javascript">


/*  ======================================================================= 
        Initial Setting 
    ======================================================================= */
    $(document).ready(function(){        
    }); 
    
  //  <div style="<%'if editmode = true then%>display:none;">

/*  ======================================================================= 
        Search Button Click - 발급대상 검색
    ======================================================================= */
    function onSearch()
    {
        var obj = {};            
        var sName, sBirth, sPhone, sClub, sSido, sGugun;

        if(ctx.IsSelectCheckbox("chk_sName"))       sName   = ctx.getTextboxVal("txt_sName"); 
        if(ctx.IsSelectCheckbox("chk_sBirthDay"))   sBirth  = ctx.getTextboxVal("txt_sBirthDay");
        if(ctx.IsSelectCheckbox("chk_sPhone"))      sPhone  = ctx.getTextboxVal("txt_sPhone"); 
        if(ctx.IsSelectCheckbox("chk_sClub"))       sClub   = ctx.getTextboxVal("txt_sClub"); 
        if(ctx.IsSelectCheckbox("chk_sSido"))       sSido   = ctx.getTextboxVal("txt_sSido"); 
        if(ctx.IsSelectCheckbox("chk_sGugun"))      sGugun  = ctx.getTextboxVal("txt_sGugun");  
        
        obj.NAME        = sName;
        obj.BIRTH       = sBirth;
        obj.PHONE       = sPhone;
        obj.CLUB        = sClub;
        obj.SIDO        = sSido;      
        obj.GUGUN       = sGugun;    
        obj.CHK         = getSearchCondition(); 
        
        strLog = utx.strPrintf("onSearch sName = {0}, sBirth = {1}, sPhone = {2}, sClub = {3}, sSido = {4}, sGugun = {5}", 
                                sName, sBirth, sPhone, sClub, sSido, sGugun)
        console.log(strLog); 

        badmt.goSearchEx(obj, 1); 
        return true; 
    }

    function onModify(allowMod,seq)
    {   
        var mName, mBirth, mPhone;     
        allowMod = Number(allowMod);

        console.log("onModify allowMod = " + allowMod); 
        if( allowMod != 1) 
        {
            alert("검색 데이터가 1개이어야만 수정이 가능합니다. "); 
            return false; 
        }
        
        if( seq == undefined || seq == "" )
        {
            alert("검색 데이터에 오류가 있읍니다. \n 재 검색후 다시 시도해 주세요 "); 
            return false; 
        }   

        if(ctx.IsSelectCheckbox("chk_name"))       mName   = ctx.getTextboxVal("txt_name"); 
        if(ctx.IsSelectCheckbox("chk_birthDay"))
        {
            mBirth  = ctx.getTextboxVal("txt_birthDay");

            if( utx.checkBirthDay(mBirth) == false )
            {
                alert("생년월일은 8자리 숫자 이어야 합니다. \nex)19880101"); 
                ctx.focusElement("chk_birthDay"); 
                return false; 
            }
        }
        if(ctx.IsSelectCheckbox("chk_phone"))
        {
            mPhone  = ctx.getTextboxVal("txt_phone"); 

            if( utx.checkPhoneNumber(mPhone) == false )
            {
                alert("전화번호 형식이 아닙니다. \nex)010-8888-9999"); 
                ctx.focusElement("txt_phone"); 
                return false; 
            }
        }

        if( (mName == undefined && mBirth == undefined && mPhone == undefined) || 
            (mName == "" && mBirth == "" && mPhone == "" ) )
        {
            alert("데이터 변경을 하시려면 하나 이상 선택후 입력하셔야 합니다."); 
            ctx.focusElement("txt_phone"); 
            return false;
        }

        badmt.reqModRegInfo("", seq, mName, mBirth, mPhone);
        return true; 
    }

    function onSendSMS(allowMod, seq)
    {          
        console.log("onSendSMS allowMod = " + allowMod);  
        if( allowMod != 1) 
        {
            alert("검색 데이터가 1개이어야만 SMS 재전송이 가능합니다. "); 
            return false; 
        }   

        if( seq == undefined || seq == "" )
        {
            alert("검색 데이터에 오류가 있읍니다. \n 재 검색후 다시 시도해 주세요 "); 
            return false; 
        }   

        badmt.reqResendSMS("", seq);
        return true; 
    }

/*  ======================================================================= 
    ======================================================================= */
     // Sub Function 
    function getSearchCondition() {
        var strCondition = "";

        strCondition +=  (ctx.IsSelectCheckbox("chk_sName")==true) ? "Y" : "N";                         
        strCondition +=  (ctx.IsSelectCheckbox("chk_sBirthDay")==true) ? "Y" : "N";                         
        strCondition +=  (ctx.IsSelectCheckbox("chk_sPhone")==true) ? "Y" : "N";                         
        strCondition +=  (ctx.IsSelectCheckbox("chk_sClub")==true) ? "Y" : "N";                                    
        strCondition +=  (ctx.IsSelectCheckbox("chk_sSido")==true) ? "Y" : "N";                                    
        strCondition +=  (ctx.IsSelectCheckbox("chk_sGugun")==true) ? "Y" : "N";                                    

        return strCondition;
    }
    
/*  ======================================================================= 
    ======================================================================= */
</script>



