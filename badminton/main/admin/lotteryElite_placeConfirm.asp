
<!-- #include virtual = "/pub/charset.asp" -->
<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->  

<%
	'		http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/lotteryElite_placeConfirm_test.asp
%>


<%
   Dim strPos, strQPos, strReqUser, colP, IsDblGame
	Dim aryPos, aryQPos, aryUser, aryResult	 

   strPos = Request.Form("pos")
   strQPos = Request.Form("q_pos")
	strReqUser = Request.Form("reqUser")

	aryPos = uxGet2DimAryFromStr(strPos, "|", ",")
	aryQPos = uxGet2DimAryFromStr(strQPos, "|", ",")
	aryUser = uxGet2DimAryFromStr(strReqUser, "|", ",")

	colP = UBound(aryPos, 1)
	IsDblGame = 0
	If(colP > 10) Then IsDblGame = 1 End If 

'	' Call TraceLog2Dim(SAMALL_LOG1, aryPos, "placeConfirm - aryPos")
'	' Call TraceLog2Dim(SAMALL_LOG1, aryQPos, "placeConfirm - aryQPos")
'	' Call TraceLog2Dim(SAMALL_LOG1, aryUser, "placeConfirm - aryUser")
	
	aryResult = ApplyPos(aryUser, aryPos, aryQPos, IsDblGame)

%>

<%
'=================================================================================
'				Sub Function 
'================================================================================= 

'=================================================================================
'				aryUser에 Tournament, Qualify infomation을 넣는다. 
'	aryResult : playerCode, player, team , team_order, tonament_pos, tonament_group_pos, is_qualify
'                 0  ,       1  ,    2  ,      3    ,        4    ,     5             ,     6
'================================================================================= 
Function ApplyPos(rAryUser, rAryPos, rAryQPos, IsDblGame)
	Dim Idx, ub, ubQ
	Dim aryResult, col_result

	ub = UBound(rAryUser, 2)
	col_result = 7 - 1

	ReDim aryResult(col_result, ub)  

	For Idx = 0 To ub 
		aryResult(0,Idx) = rAryUser(6,Idx)			' playerCode
		aryResult(1,Idx) = rAryUser(9,Idx)			' player
		aryResult(2,Idx) = rAryUser(11,Idx)			' team
		aryResult(3,Idx) = rAryUser(5,Idx)			' team_order
	Next 

	Call ApplyTonamentPos(aryResult, rAryPos, IsDblGame)

	If(IsArray(rAryQPos)) Then 
		Call ApplyQualifyPos(aryResult, rAryPos, rAryQPos, IsDblGame)
	End If 

	ApplyPos = aryResult 
End Function 

'=================================================================================
'	aryResult에 Tournament Infomation을 setting한다. 
'================================================================================= 
Function ApplyTonamentPos(rAryResult, rAryPos, IsDblGame)
	Dim Idx, ub, ubP, groupIdx, groupPos, pos, szBlock, IsQualify
	
	ub 	= UBound(rAryPos, 2)
	IsQualify = 0

	If(ub+1 <= 32) Then 
		szBlock = 4 
	Else 
		szBlock = 8 
	End If 

	For Idx = 0 To ub 
		groupIdx = rAryPos(4, Idx)
		groupPos = Fix(Idx / szBlock) + 1
		pos = Idx + 1
		Call SetInfoToResult(rAryResult,groupIdx, pos, groupPos, IsQualify, IsDblGame) 
	Next 

	ApplyTonamentPos = rAryResult
End Function 

'=================================================================================
'	aryResult에 예선전 Tournament Infomation을 setting한다. 
'================================================================================= 
Function ApplyQualifyPos(rAryResult, rAryPos, rAryQPos, IsDblGame)
	Dim Idx, ub, groupIdx, pos, groupPos, szQBlock, IsQualify
	IsQualify = 1
	
	ub = UBound(rAryQPos, 2)
	szQBlock = 4

	For Idx = 0 To ub 
		groupIdx = rAryQPos(4, Idx)
		pos = Fix(Idx / szQBlock) + 1
		groupPos = FindQPosInTonament(rAryPos, pos)

		Call SetInfoToResult(rAryResult,groupIdx, pos, groupPos, IsQualify, IsDblGame) 
	Next 

	ApplyQualifyPos = rAryResult
End Function 

'=================================================================================
'				aryResult에 Tournament Infomation을 setting한다. 
'	aryResult : playerCode, player, team , team_order, tonament_pos, tonament_group_pos, is_qualify
'                 0  ,       1  ,    2  ,      3    ,        4    ,     5             ,     6
'================================================================================= 
Function SetInfoToResult(rAryResult, groupIdx, pos, group_pos, bQualify, IsDblGame)
	Dim Idx, ub

	ub = UBound(rAryResult, 2)
	
	For Idx = 0 To ub 
		If(rAryResult(0,Idx) = groupIdx) Then 			
			rAryResult(4,Idx) = pos
			rAryResult(5,Idx) = group_pos
			rAryResult(6,Idx) = bQualify
			If(IsDblGame = 1) Then 
				rAryResult(4,Idx+1) = pos
				rAryResult(5,Idx+1) = group_pos
				rAryResult(6,Idx+1) = bQualify
			End If 
			Exit For 
		End If 
	Next
End Function 

'=================================================================================
'				aryResult에 Tournament Infomation을 setting한다. 
'	aryResult : playerCode, player, team , team_order, tonament_pos, tonament_group_pos, is_qualify
'                 0  ,       1  ,    2  ,      3    ,        4    ,     5             ,     6
'================================================================================= 
Function FindQPosInTonament(rAryPos, QIdx)
	Dim Idx, ub, groupPos, szBlock
	Dim E_POS_NORMAL, E_POS_SEED, E_POS_BYE, E_POS_Q, E_POS_FIRST, E_POS_MANUAL

   E_POS_NORMAL            = 0               ' 일반 자리 
   E_POS_SEED              = 1               ' Seed 자리 
   E_POS_BYE               = 2               ' Bye 자리 
   E_POS_Q                 = 3               ' 예선전 조 자리 
   E_POS_FIRST             = 4               ' 1장 자리 
   E_POS_MANUAL            = 5               ' 수동 배정 자리 

	ub = UBound(rAryPos, 2)

	If(ub+1 <= 32) Then 
		szBlock = 4 
	Else 
		szBlock = 8 
	End If 
	
	groupPos = -1
	For Idx = 0 To ub 
		If(CDbl(rAryPos(2,Idx)) = E_POS_Q) Then 	
			If(CDbl(rAryPos(3,Idx)) = QIdx) Then 
				groupPos = Fix(Idx / szBlock) + 1
				Exit For 
			End If 
			
		End If 
	Next

	FindQPosInTonament = groupPos
End Function 

%>

<!DOCTYPE html>
<html>
   <head>
      <meta charset="UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>::: 대한배드민턴 협회 :::</title>
      <link rel="stylesheet" href="<%=URL_HOST%>/front/dist/css/lib/fontaweome-all.css">
      <link rel="stylesheet" href="<%=URL_HOST%>/front/dev/css/import.css?ver=0.1" />
      <script type="text/javascript" src="<%=URL_HOST%>/front/dist/js/jquery-1.12.2.min.js"></script>
      <script type="text/javascript" src="<%=URL_HOST%>/front/dist/js/jquery-ui.js"></script>
      <script type="text/javascript" src="<%=URL_HOST%>/front/dist/js/bootstrap.min.js"></script>
      <script type="text/javascript" src="<%=URL_HOST%>/front/dist/js/html5shiv.min.js"></script>
      <script type="text/javascript" src="<%=URL_HOST%>/front/dist/js/selectivizr-min.js"></script>
      <script type="text/javascript" src="<%=URL_HOST%>/front/dist/js/jquery.bxslider.js"></script>
      <script type="text/javascript" src="<%=URL_HOST%>/front/dist/js/lib/jquery.placeholder.min.js"></script>
      <script type="text/javascript" src="<%=URL_HOST%>/front/dist/js/js.js"></script>
      <script type="text/javascript" src="<%=URL_HOST%>/dev/dist/Common_Js.js"></script>
      <script type="text/javascript" src="<%=URL_HOST%>/front/dist/js/lgz.js"></script>      
      <script type="text/javascript" src="/js/etc/excel/xlsx.full.min.js"></script>
      <script type="text/javascript" src="/js/etc/excel/FileSaver.min.js"></script>

      <style>
         table {
            border-collapse: collapse;
            /* width: 100%; */
            width: 800px;
            border-spacing: 20 0px;
            position: relative;
         }

         td {
            text-align: left;
            padding: 8px;
            margin-left: 30px;
         }

         /* tr:nth-child(even){background-color: #f2f2f2} */
			.s_border{border-top:2px solid #000;}
			.game_normal {background-color: #ffffff}			
			.game_even {background-color: #f2f2f2}
			.game_qualify {
				background-color: #f1f0e7;            
            color: #7e693b; 
			}
			.game_header {
            background-color: #3c6588;
            font-weight: bold;
            color: white;
         }

         .game_title {
            background-color: #3c6588;
            font-weight: bold;
            color: white;
         }
         .game_info {
            background-color: #3c6588;
            color: white;
         }
         .lv_info {
            background-color: #929ca4;
            font-weight: bold;
            color: white;
         }

			.place_no {
            width: 100;
            text-align: center;
         }
         
         .place_player {
            width: 100;
            text-align: center;
         }
         .place_team {
            width: 100;
            text-align: center;
         }

			.place_team_order {
            width: 100;
            text-align: center;
         }

			.place_pos {
            width: 100;
            text-align: center;
         }

			.place_group_pos {
            width: 100;
            text-align: center;
         }

			.place_qualify {
            width: 100;
            text-align: center;
         }

         .btn_con {            
            margin-left: 5%;
            margin-top : 20px;             
            /* font-weight: bold; */                
            position: absolute;   
            height : 50; 
            top: 0;  
         }
         
         a:link, a:visited {
            background-color: #c2d5dd;            
            padding: 10px 25px;
            color: black;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            border-style: solid;
            border-color: #3c6588;
         }

         .sp_con {            
            /* margin-left: 20px; */
            padding-left: 50px;      
            /* position: absolute;   
            height : 50; 
            top: 0;  */
         }

         .sp_period {                      
            padding-left: 50px;      
         }
			
			.btn-sp-box{position:relative;width:800px;height:47px;padding:20px 0 10px;}
			.btn-sp-box__sp{position:absolute;right:0;}
			.btn-sp-box__sp>a{border:1px solid;}
			.tbl_tr{border-bottom:1px solid #000;}
			.tbl_tr.t_two{border-bottom:0;}
			.tbl_tr.t_two:nth-child(2n) td.t_border{border-bottom:1px solid #000;}
			.tbl_tr.t_two:nth-child(2n+1){border-bottom:1px solid #000;}

      </style>
   </head>


   <body>
		<div class="btn-sp-box">
			<span class = "sp_con btn-sp-box__sp"><a href="javascript:exportExcel();">EXCEL 파일</a></span>
		</div>

      <table id = "tbl_placeInfo">
			<tr>
				<th class = 'game_header'> No</th>
				<th class = 'game_header'> 선수</th>
				<th class = 'game_header'> Team</th>
				<th class = 'game_header'> Team Order</th>
				<th class = 'game_header'> pos</th>
				<th class = 'game_header'> group pos</th>
			</tr>

			<%
				Dim tr_class, ub, i, class_line, class_qualify
				Dim player, team, team_order, tonament_pos, group_pos, bQualify
				Dim strTonamentPos
				ub = UBound(aryResult, 2) 
				
				For i = 0 To ub
					player 			= aryResult(1, i)
					team 				= aryResult(2, i)
					team_order 		= aryResult(3, i)
					tonament_pos 	= aryResult(4, i)
					group_pos 		= aryResult(5, i)
					bQualify 		= aryResult(6, i)

					strTonamentPos = tonament_pos

					If(IsDblGame = 1) Then 
						If(i > 1) And (team_order = 1) Then
							If(class_line = "") Then 
								class_line = "s_border" 
							Else 
								class_line = "" 
							End If  
						Else 						
							class_line = "" 
						End If 
					Else 
						If(i > 0) And (team_order = 1) Then
							class_line = "s_border" 
						Else 						
							class_line = "" 
						End If 
					End If 

					If(bQualify = 1) Then 
						class_qualify = "game_qualify" 

						strTonamentPos 	= sprintf("Q{0}", Array(tonament_pos))						
					Else 
						class_qualify = "" 
					End If 

					tr_class = sprintf("{0} {1}", Array(class_line, class_qualify))

			%>
				<% If (IsDblGame = 1) Then  %>
					<tr class = '<%=tr_class%> tbl_tr t_two' >
						<td class = "place_no" >			<%=i+1%></td>
						<td class = "place_player" >		<%=player%></td>
						<td class = "place_team" >			<%=team%></td>

						<% If (i Mod 2) = 0 Then  %>
							<td rowspan="2" class = "place_team_order t_border" >	<%=team_order%></td>
							<td rowspan="2" class = "place_pos t_border" >			<%=strTonamentPos%></td>
							<td rowspan="2" class = "place_group_pos t_border" >	<%=group_pos%></td>
						<% End If %>
					</tr>
				<% Else %>
					<tr class = '<%=tr_class%> tbl_tr ' >
						<td class = "place_no" >			<%=i+1%></td>
						<td class = "place_player" >		<%=player%></td>
						<td class = "place_team" >			<%=team%></td>
						<td class = "place_team_order t_border" >	<%=team_order%></td>
						<td class = "place_pos t_border" >			<%=strTonamentPos%></td>
						<td class = "place_group_pos t_border" >	<%=group_pos%></td>
					</tr>
				<% End If %>
				
			
			<%                       
				Next                
			%>

      </table>

   </body>
</html>


<script>
   var gExportFileName; 
   gExportFileName = "토너먼트 배치확인"+".xlsx";

   function s2ab(s) {
      var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
      var view = new Uint8Array(buf); //create uint8array as viewer
      for (var i = 0; i < s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
      return buf;
   }

   function exportExcel() {
      // step 1. workbook 생성
      var wb = XLSX.utils.book_new();

      // step 2. 시트 만들기 
      var newWorksheet = excelHandler.getWorksheet();

      // Sheet Cell Width Setting 
      var wsrows =  [            
            {wch: 10}, // A Cell Width
            {wch: 20}, // B Cell Width
				{wch: 20}, // B Cell Width
				{wch: 10}, // B Cell Width
         ];
      newWorksheet['!cols'] = wsrows;

      // step 3. workbook에 새로만든 워크시트에 이름을 주고 붙인다.  
      XLSX.utils.book_append_sheet(wb, newWorksheet, excelHandler.getSheetName());

      // step 4. 엑셀 파일 만들기 
      var wbout = XLSX.write(wb, {
            bookType: 'xlsx',
            type: 'binary'
      });

      // step 5. 엑셀 파일 내보내기 
      saveAs(new Blob([s2ab(wbout)], {
            type: "application/octet-stream"
      }), excelHandler.getExcelFileName());
   }  

   var excelHandler = {
      getExcelFileName: function() {
            return gExportFileName;
      },
      getSheetName: function() {
            return '토너먼트 배치';
      },
      getExcelData: function() {
            return document.getElementById('tbl_placeInfo');
      },
      getWorksheet: function() {
            return XLSX.utils.table_to_sheet(this.getExcelData());
      }
   }
</script>
