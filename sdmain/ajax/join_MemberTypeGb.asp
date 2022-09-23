<!--#include file="../Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'종목별, Step별 회원구분선택
	'/sdmain/join_MemberTypeGb.asp
	'===============================================================================================
	dim valSportsType  	: valSportsType   	= fInject(Request("valSportsType"))	
   	dim valStep			: valStep 			= fInject(Request("valStep"))
   	dim valMemType		: valMemType 		= fInject(Request("valMemType"))
	
	dim ReData, txtData		
   
   	IF valSportsType = "" Then 
		response.Write "FALSE|200"
		response.End()
	Else
		
		SELECT CASE valStep
   			
			CASE "sel_SportsType" 		: ReData = MEMBER_TAG_STEP1(valSportsType, valMemType)
			CASE "sel_MemberType" 		: ReData = MEMBER_TAG_STEP2(valSportsType, valMemType)
	 		CASE "sel_EnterType" 		: ReData = MEMBER_TAG_STEP3(valSportsType, valMemType)
			CASE "sel_PlayerType"		: ReData = MEMBER_TAG_STEP4(valSportsType, valMemType)
			CASE ELSE					
				response.Write "FALSE|200"
				response.End()
		END SELECT

		response.write "TRUE|"&ReData
			
	End IF
	
   
   	'-----------------------------------------------------------------------------------------------------
   	'회원구분 선택
   	'-----------------------------------------------------------------------------------------------------
   	FUNCTION MEMBER_TAG_STEP1(valType, strVal)
	 	txtData = ""
	 
   		SELECT CASE valType
   			CASE "judo", "tennis"
				txtData = "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','R');"" class='btn btn-list'>선수</a></li>"
				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','T');"" class='btn btn-list'>지도자</a></li>"
				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','P');"" class='btn btn-list'>보호자</a></li>"
				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','D');"" class='btn btn-list'>일반</a></li>"
			
'			CASE "tennis"
'				txtData = "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','R');"" class='btn btn-list'>선수</a></li>"
'				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','T');"" class='btn btn-list'>지도자</a></li>"
'				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','P');"" class='btn btn-list'>보호자</a></li>"				
'				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','D');"" class='btn btn-list'>일반</a></li>"																																		   
																																		  
			CASE "bike"
				txtData = "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','R');"" class='btn btn-list'>선수</a></li>"
				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_MemberType','P');"" class='btn btn-list'>보호자</a></li>"
   		END SELECT
   
   		MEMBER_TAG_STEP1 = txtData
   
   	END FUNCTION
	'-----------------------------------------------------------------------------------------------------
	'가입구분 선택
	'-----------------------------------------------------------------------------------------------------
   	FUNCTION MEMBER_TAG_STEP2(valType, strVal)
	 	txtData = ""
	 
   		SELECT CASE valType
   			CASE "judo"
				txtData = "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_EnterType','E');"" class='btn btn-list'>엘리트</a></li>"
				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_EnterType','A');"" class='btn btn-list'>생활체육</a></li>"
   			
   			CASE "tennis", "bike"
				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_EnterType','A');"" class='btn btn-list'>생활체육</a></li>"
   		END SELECT
   
   		MEMBER_TAG_STEP2 = txtData
   
   	END FUNCTION   
	'-----------------------------------------------------------------------------------------------------
	'선수구분[Ⅰ] 선택
	'-----------------------------------------------------------------------------------------------------
   	FUNCTION MEMBER_TAG_STEP3(valType, strVal)
	 	txtData = ""
	 	
   		SELECT CASE valType
   			CASE "judo"	 
				txtData = "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_PlayerType','R');"" class='btn btn-list'>대한체육회 등록선수</a></li>"
				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_PlayerType','K');"" class='btn btn-list'>대한체육회 비등록선수</a></li>"
   		END SELECT
   
   		MEMBER_TAG_STEP3 = txtData
   
   	END FUNCTION
	'-----------------------------------------------------------------------------------------------------
	'선수구분[Ⅱ] 선택
	'-----------------------------------------------------------------------------------------------------
   	FUNCTION MEMBER_TAG_STEP4(valType, strVal)
	 	txtData = ""
	 
   		SELECT CASE valType
   			CASE "judo"
				txtData = "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_PlayerType_Ex','K');"" class='btn btn-list'>대한체육회 선수등록 유경험</a></li>"
				txtData = txtData & "<li><a href=""javascript:MemberType_Select('"&valType&"','sel_PlayerType_Ex','S');"" class='btn btn-list'>대한체육회 선수등록 무경험</a></li>"
   		END SELECT
   
   		MEMBER_TAG_STEP4 = txtData
   
   	END FUNCTION
	'----------------------------------------------------------------------------------------------------- 
   
%>