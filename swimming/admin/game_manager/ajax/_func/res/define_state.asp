<% 
'   ===============================================================================     
'    Purpose : state code를 정의한다. ( code 와 description을 연동한다. )
'    Make    : 2019.12.04
'    Author  :                                                       By Aramdry
'   ===============================================================================   

'   ===============================================================================     
'    	입촌신청 상태 코드 
'   ===============================================================================   
		'Dim E_ENTER_STATE_TEMP, E_ENTER_STATE_REQ, E_ENTER_STATE_ALLOW		
			E_ENTER_STATE_TEMP									= 0				' 임시저장
			E_ENTER_STATE_REQ										= 1				' 확인 요청
			E_ENTER_STATE_ALLOWAFTERMODIFY					= 2				' 확인 후 수정
			E_ENTER_STATE_ALLOW									= 3				' 확인 
			E_ENTER_STATE_DENY									= 4				' 반려			
			E_ENTER_STATE_OUT										= 5				' 퇴촌 
			E_ENTER_STATE_DEL										= 99				' 삭제 

		'Dim STR_ENTER_TEMP, STR_ENTER_REQ, STR_ENTER_ALLOW
			STR_ENTER_TEMP 											= "임시 저장"
			STR_ENTER_REQ 												= "확인 요청"
			STR_ENTER_ALLOWAFTERMODIFY								= "확인 후 수정"
			STR_ENTER_ALLOW 											= "확인"
			STR_ENTER_DENY 											= "반려"					
			STR_ENTER_OUT	 											= "퇴촌"

		Function getStrEnterState(cState)
			Dim strState

			Select Case Cdbl(cState)
				case E_ENTER_STATE_TEMP 										' 임시파일 
					strState = STR_ENTER_TEMP
				case E_ENTER_STATE_REQ 											' 승인 요청
					strState = STR_ENTER_REQ
				case E_ENTER_STATE_ALLOWAFTERMODIFY 				' 승인 후 수정
					strState = STR_ENTER_ALLOWAFTERMODIFY
				case E_ENTER_STATE_ALLOW 										' 승인 
					strState = STR_ENTER_ALLOW
				case E_ENTER_STATE_DENY 										' 반려 
					strState = STR_ENTER_DENY
				case E_ENTER_STATE_OUT 											' 퇴촌
					strState = STR_ENTER_OUT
				case else
					strState = ""
			End Select 

			getStrEnterState = strState
		End Function 

		Function getCodeEnterState(strState)
			Dim cState

			Select Case Cdbl(strState)
				case STR_ENTER_TEMP 															' 임시파일 
					cState = E_ENTER_STATE_TEMP
				case STR_ENTER_REQ 																' 승인 요청
					cState = E_ENTER_STATE_REQ
				case STR_ENTER_ALLOWAFTERMODIFY 									' 승인 후 수정
					cState = E_ENTER_STATE_ALLOWAFTERMODIFY
				case STR_ENTER_ALLOW 															' 승인 
					cState = E_ENTER_STATE_ALLOW				
				case STR_ENTER_DENY 															' 반려 
					cState = E_ENTER_STATE_DENY				
				case STR_ENTER_OUT 																' 퇴촌 
					cState = E_ENTER_STATE_OUT
				case else
					cState = 999				
			End Select 

			getCodeEnterState = cState
		End Function 

'   ===============================================================================     
'    	입촌신청 상태 코드 
'   ===============================================================================  

'   ===============================================================================     
'    	방배정 상태 코드 
'   ===============================================================================   
		E_ASSIGN_ROOM_REQ							= 1		' 숙소배정대기
		E_ASSIGN_ROOM_MOD_REQ					= 2		' 숙소재배정대기
		E_ASSIGN_ROOM_CHANGE_REQ				= 3		' 숙소재배정요청
		E_ASSIGN_ROOM_START						= 4		' 숙소배정중
		E_ASSIGN_ROOM_END							= 5		' 숙소배정완료
		E_ASSIGN_PLAYER_REQ						= 10		' 선수배정대기
		E_ASSIGN_PLAYER_CHANGE_REQ				= 11		' 선수재배정요청
		E_ASSIGN_PLAYER_START					= 12		' 선수배정중
		'E_ASSIGN_PLAYER_END						= 13		' 선수배정완료
		E_ASSIGN_PLAYER_ALLOWREQ				= 14		' 선수배정승인대기
		'E_ASSIGN_PLAYER_ALLOW					= 15		' 선수배정승인
		E_ASSIGN_ROOM_COMPLETE					= 20		' 숙소확인/수정

		STR_ASSIGN_ROOM_REQ						= "숙소배정대기"
		STR_ASSIGN_ROOM_MOD_REQ					= "숙소재배정대기"
		STR_ASSIGN_ROOM_CHANGE_REQ				= "숙소재배정요청"
		STR_ASSIGN_ROOM_START					= "숙소배정중"
		STR_ASSIGN_ROOM_END						= "숙소배정완료"
		STR_ASSIGN_PLAYER_REQ					= "선수배정대기"
		STR_ASSIGN_PLAYER_CHANGE_REQ			= "선수재배정요청"
		STR_ASSIGN_PLAYER_START					= "선수배정중"
		STR_ASSIGN_PLAYER_END					= "선수배정완료"
		STR_ASSIGN_PLAYER_ALLOWREQ				= "선수배정승인대기"
		STR_ASSIGN_PLAYER_ALLOW					= "선수배정승인"
		STR_ASSIGN_ROOM_COMPLETE				= "숙소확인/수정"

		Function getStrAssignRoomState(cState)
			Dim strState

			Select Case Cdbl(cState)
				case E_ASSIGN_ROOM_REQ 										' 숙소배정대기
					strState = STR_ASSIGN_ROOM_REQ
				case E_ASSIGN_ROOM_MOD_REQ 								' 숙소재배정대기
					strState = STR_ASSIGN_ROOM_MOD_REQ
				case E_ASSIGN_ROOM_CHANGE_REQ 							' 숙소재배정요청
					strState = STR_ASSIGN_ROOM_CHANGE_REQ
				case E_ASSIGN_ROOM_START 									' 숙소배정중
					strState = STR_ASSIGN_ROOM_START
				case E_ASSIGN_ROOM_END 										' 숙소배정완료
					strState = STR_ASSIGN_ROOM_END
				
				case E_ASSIGN_PLAYER_REQ 									' 선수배정대기
					strState = STR_ASSIGN_PLAYER_REQ
				case E_ASSIGN_PLAYER_CHANGE_REQ 										' 선수배정대기
					strState = STR_ASSIGN_PLAYER_CHANGE_REQ
				case E_ASSIGN_PLAYER_START 									' 선수배정중
					strState = STR_ASSIGN_PLAYER_START
		'		case E_ASSIGN_PLAYER_END 										' 선수배정완료
		'			strState = STR_ASSIGN_PLAYER_END
				case E_ASSIGN_PLAYER_ALLOWREQ 								' 선수배정승인대기
					strState = STR_ASSIGN_PLAYER_ALLOWREQ
		'		case E_ASSIGN_PLAYER_ALLOW 									' 선수배정승인
		'			strState = STR_ASSIGN_PLAYER_ALLOW
				
				case E_ASSIGN_ROOM_COMPLETE 									' 숙소확인/수정
					strState = STR_ASSIGN_ROOM_COMPLETE
				case else
					strState = ""
			End Select 

			getStrAssignRoomState = strState
		End Function 

'   ===============================================================================     
'    	방배정 상태 코드 
'   ===============================================================================  

'   ===============================================================================     
'    	방 타입 코드 
'   ===============================================================================   
		E_ROOM_TYPE_ASSIGN				= 1		' 	입촌 선수 배정 방 
		E_ROOM_TYPE_RENT					= 2		' 	대관 배정 방
		E_ROOM_TYPE_SYSTEM				= 3		'  관리자 관리 방 ( 예약, 고장 ... )

'   ===============================================================================     
'    	방 상태 코드
'     현재 날짜 기준으로 공실 설정의 경우 사용 리스트 상에서 삭제 
'   ===============================================================================   		
		E_ROOM_STATE_ASSIGN							= 1		' 	배정 상태
		E_ROOM_STATE_RENT								= 2		' 	대관 상태		
		E_ROOM_STATE_RESERVED						= 3		'  관리자 예약
		E_ROOM_STATE_DISABLE_USE					= 4		'  사용 불가 

'   ===============================================================================     
'    	외출 / 외박
'   ===============================================================================   		
		E_CENTER_OUT									= "OT0001"		' 	외출
		E_CENTER_SLEEP_OUT							= "OT0002"		' 	외박

'   ===============================================================================     
'    	외출 / 외박 - 상태 
'   ===============================================================================  
		E_CENTER_OUT_STATE_REQUEST 				= 400			' 외출/외박 - 신청	
		E_CENTER_OUT_STATE_REJECT 					= 401			' 외출/외박 - 반려	
		E_CENTER_OUT_STATE_ALLOW 					= 402			' 외출/외박 - 확인	
		E_CENTER_OUT_STATE_COMPLETE 				= 403			' 외출/외박 - 복귀확인	

	'   ===============================================================================     
	'    	외출 / 외박 - 신청/복귀
	'   ==============================================================================
		E_CENTER_OUT_REQ								= 1	' 외출/외박 신청 List ( 신청, 반려, 확인 Display )
		E_CENTER_OUT_ALLOW							= 2 	' 외출/외박 복귀확인 List ( 확인, 복귀확인 Display )

	'   ===============================================================================     
	'    	외출 / 외박 - 출발/복귀
	'   ==============================================================================
		E_CENTER_OUT_START								= 1	' 외출/외박 출발
		E_CENTER_OUT_RETURN								= 2 	' 외출/외박 복귀

	'   ===============================================================================     
	'    	훈련 보고서 
	'   ==============================================================================
		E_TRAINING_REPORT_WAIT						= 1	' 보고대기 
		E_TRAINING_REPORT_REQ						= 2 	' 승인요청
		E_TRAINING_REPORT_RSP						= 3 	' 승인
		E_TRAINING_REPORT_REJECT					= 4 	' 반려

	'   ===============================================================================     
	'    	훈련 계획서 - 동/관 외부시설 코드
	'   ==============================================================================
		E_EXTERNAL_QUARTER_SEQ 						= "EF0001" 		' 동관 코드
		E_EXTERNAL_QUARTER_STR	 					= "외부시설"
		E_EXTERNAL_FACILITY_SEQ 					= 9999 			' 호실(시설명) 코드
	   E_EXTERNAL_FACILITY_STR 					= "외부시설"
%>