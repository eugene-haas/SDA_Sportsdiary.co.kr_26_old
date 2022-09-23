<%

'송장번호 구하기
Function getDeliveryNum ( byVal gdSendNum )
  Dim gdSendNums
  ''ㅡ가 없으면 Erp에서 입력한 한진택배 송장번호
  If Instr(gdSendNum, "ㅡ") = 0 Then
    'Erp로 넣는 한진택배 송장번호는 끝에 ,가 항상 붙어서 ,위치로 송장번호 갯수 구분
    If InstrRev(gdSendNum, ",") > 20 Then
      '송장번호 2개이상일때
      getDeliveryNum = Split(gdSendNum, ",")
    Else
      '송장번호가 한개일때
      getDeliveryNum = Split(gdSendNum, ",")(0)
    End If

  '' 그외 택배 입력형식은 "택배사ㅡ송장번호" 형식
  Else
    gdSendNums = Split(gdSendNum, "ㅡ")
    '콤마가 유무 확인해서 배열에 넣기
    If Instr(gdSendNums(1), ",") = 0 Then
      getDeliveryNum = Cstr(gdSendNums(1))
    Else
      getDeliveryNum = Split(Cstr(gdSendNums(1)), ",")
    End If
  End If
End Function

'택배사명 가져오기
Function getDeliveryCom ( byVal gdSendNum )
  Dim deliveryCom

  'gdSendNum 에 택배사명이 없으면 한진택배, 택배사명과 송장번호는 ㅡ 로 구분
  If Instr(gdSendNum, "ㅡ") = 0 Or Instr(gdSendNum, "한진") Then
    deliveryCom = "한진택배"
  Else
    deliveryCom = Split(gdSendNum, "ㅡ")(0)
  End If

  getDeliveryCom = deliveryCom
End Function

%>
