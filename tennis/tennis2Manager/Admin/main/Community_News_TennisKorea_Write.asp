<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%

	Dim iFileCnt, iFileExt
	
	iFileCnt = 0
	iFileExt = ""

  Set fs = Server.CreateObject("Scripting.FileSystemObject")
  Set folderObj = fs.GetFolder(global_filepath_TKNews)
  Set files = folderObj.Files

	For Each file in files

		iFileExt = FileExt_Check(file.name)

		if iFileExt = "xml" then
			iFileCnt = iFileCnt + 1
		end if

	Next
  
%>


<script type="text/javascript">

	function OK_Link() {

		// 스마트에디트 아닐때
		var theForm = document.form1;
		
		
		//if (theForm.iSubject.value == "") {
		//  alert('<%=global_Subject_Val %>');
		//  return theForm.iSubject.focus();
		//}
		
		if (confirm("뉴스 등록을 하시겠습니까?") == true) {
		  try {
		
		    theForm.method = "post";
		    theForm.target = "_self";
		    theForm.action = "./Community_News_TennisKorea_Write_p.asp";
		    theForm.submit();
		
		  } catch (e) { }
		}
		else {
		
		}

	}

</script>

<section>
  <div id="content">

    <!-- S : 내용 시작 -->
    <div class="contents">
      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        메인 > 뉴스 > 테니스코리아 뉴스등록
      </div>
      <!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./Community_News_TennisKorea_Write_p.asp" method="post">
        <table cellspacing="0" cellpadding="0" class="Community_wtite_box">

          <tr>
            <th>등록 예정<p />갯수</th>
            <td colspan="2">
              <span class="right_con">
                <%=iFileCnt %> 개
              </span>
            </td>
          </tr>

        </table>

        <div class="btn_list">

          <input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
					
        </div>

			</form>

      

    </div>
    <!-- E : 내용 시작 -->
  </div>
<section>


<!--#include file="footer.asp"-->

</html>