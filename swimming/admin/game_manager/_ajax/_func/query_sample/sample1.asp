<!-- #include virtual = "/main/api/_func/define_head.asp" -->

<%
	'=================================================================================
	'  Purpose  : 	쿼리 테스트 데이터 2
	'  Author   : 												By Aramdry
	'=================================================================================

%>

<%
   '=================================================================================
   '  Purpose  : 	선수 배정 정보를 이용하여 
   '          중복 할당된 방을 제거한다. 
   '=================================================================================
   with cte_room As (
      Select 
      A.assign_room_seq, R.ROOMNO,  A.PLAYER_SEQ, P.PLAYER_NAME
      From TB_ASSIGN_PLAYER As A
      Inner Join TB_PLAYER As P On P.DELKEY = 0 And P.Seq = A.PLAYER_SEQ
      Inner Join TB_ASSIGN_ROOM As R On R.DELKEY = 0 And R.SEQ = A.assign_room_seq
      
      Where A.DelKey = 0 And A.assign_lodging_seq = 121
   ) 

   Update tb_assign_room Set delKey = 1
      Where DelKey = 0 And assign_lodging_seq = 121
      And Seq Not In (Select assign_room_seq  From cte_room)


   /*
   Select * From tb_assign_room
      Where DelKey = 0 And assign_lodging_seq = 121
      And Seq Not In (Select assign_room_seq  From cte_room)\

   Update tb_assign_room Set delKey = 1
      Where DelKey = 0 And assign_lodging_seq = 121
      And Seq Not In (Select assign_room_seq  From cte_room)
   */

   
%>
