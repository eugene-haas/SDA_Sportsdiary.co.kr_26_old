<% 
'   ===============================================================================     
'    Purpose : state code를 정의한다. ( code 와 description을 연동한다. )
'    Make    : 2021.09.06
'    Author  :                                                       By Aramdry
'   ===============================================================================   

'   ===============================================================================     
'    	총평 등록 에러 코드 
'   ===============================================================================   
 		E_TOTAL_DESC_NOT_AUTHIRITY    	= "ERR_3001"			' 권한 없음 
		E_TOTAL_DESC_NOT_ASSOCIATION   	= "ERR_3002"			' 미등록 협회 

'   ===============================================================================     
'    	평가의견 등록 에러 코드 
'   ===============================================================================   
		E_DESC_NOT_AUTHIRITY    				= "ERR_3101"			' 권한 없음 
		E_DESC_NOT_ASSOCIATION   				= "ERR_3102"			' 미등록 협회 
		E_DESC_MISSMATCH_DATA   				= "ERR_3103"			' id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다.		
		E_DESC_MISSMATCH_DATA_CNT 				= "ERR_3104"			' client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. 

'   ===============================================================================     
'    	평가점수 등록 에러 코드 
'   ===============================================================================   
		E_POINT_NOT_AUTHIRITY    				= "ERR_3201"			' 권한 없음 
		E_POINT_NOT_ASSOCIATION   				= "ERR_3202"			' 미등록 협회 
		E_POINT_MISSMATCH_DATA   				= "ERR_3203"			' id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다.		
		E_POINT_MISSMATCH_DATA_CNT 			= "ERR_3204"			' client에서 보낸 평가점수와 평가 항목의 갯수가 틀리다. 
		E_POINT_OVER_MAXPOINT 					= "ERR_3205"			' 평가 점수가 최대 평가 점수보다 높다.
		
%>