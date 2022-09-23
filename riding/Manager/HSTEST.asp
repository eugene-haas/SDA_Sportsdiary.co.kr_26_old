<% @CODEPAGE="65001" language="VBScript" %>
<%
Response.CharSet="utf-8"
Session.codepage="65001"
Response.codepage="65001"
Response.ContentType="text/html;charset=utf-8"


Public Function convertImageToBase64(filePath)
  Dim inputStream
  Set inputStream = CreateObject("ADODB.Stream")
  inputStream.Open
  inputStream.Type = 1  ' adTypeBinary
  inputStream.LoadFromFile filePath
  Dim bytes: bytes = inputStream.Read
  Dim dom: Set dom = CreateObject("Microsoft.XMLDOM")
  Dim elem: Set elem = dom.createElement("tmp")
  elem.dataType = "bin.base64"
  elem.nodeTypedValue = bytes
  convertImageToBase64 = "data:image/png;base64," & Replace(elem.text, vbLf, "")
End Function

'========성별
public function SexStringReturn(SexText)
  select case SexText
    case "Man"
      SexStringReturn = "남자"
    case "WoMan"
      SexStringReturn = "여자"
    case "Mix"
      SexStringReturn = "혼성"
    case else
      SexStringReturn = ""
  end select
end function

'========플레이 타입
public function PlayTypeReturn(PlayText)
  select case PlayText
    case "B0020001"
      PlayTypeReturn = "단식"
    case "B0020002"
      PlayTypeReturn = "복식"
    case else
      SexStringReturn = ""
  end select
end function



Function RegExpTest(Patrn, text)
  Dim ObjRegExp
  On Error Resume Next
  Set ObjRegExp = New RegExp
  ObjRegExp.Pattern = Patrn               ' 정규 표현식 패턴
  ObjRegExp.Global = True                 ' 문자열 전체를 검색함
  ObjRegExp.IgnoreCase = True          ' 대.소문자 구분 안함

  RegExpTest = ObjRegExp.Test(text)
  Set ObjRegExp = Nothing
End Function

'patten = "^0(?:11|16|17|18|19|10)-(?:\d{3}|\d{4})-\d{4}$"
'text = "010-9716-0512"
'response.write RegExpTest(patten,text) & "<br/>"
'response.write RepairPhoneNumber(text)


Function RepairPhoneNumber(strPhone)
    Dim len1 , pos1, pos2
    Dim str1, str2, str3

    strPhone = Replace(strPhone, ".", "-" )

    len1 = Len(strPhone)
    pos1 = instr(strPhone, "-")
    pos2 =  instrrev(strPhone, "-")

'        strLog = strPrintf("len1 = {0}, pos1 = {1}, pos2 = {2}", Array(len1, pos1, pos2))
'        Response.write(strLog)

    ' 전화번호가 '-' 없이 숫자만 있다.
    If( pos1 = 0 And pos2 = 0 And len1 = 11 ) Then
        str1 = Mid(strPhone, 1,3)
        str2 = Mid(strPhone, 4,4)
        str3 = Mid(strPhone, 8,4)

        strPhone = strPrintf("{0}-{1}-{2}", Array(str1, str2, str3))
    End If

    ' 전화번호가 '-' 1개만 있다.
    If( pos1 = pos2 And len1 = 12 ) Then    ' 010-77778888
        If (pos1 = 8) Then
            str1 = Mid(strPhone, 1,3)
            str2 = Mid(strPhone, 4,9)
        ElseIf( pos1 = 4 ) Then             ' 0107777-8888
            str1 = Mid(strPhone, 1,8)
            str2 = Mid(strPhone, 9,4)
        End If

        strPhone = strPrintf("{0}-{1}", Array(str1, str2))
    End If

RepairPhoneNumber = strPhone
End Function

Function strPrintf(sVal, aArgs)
Dim i
    For i=0 To UBound(aArgs)
        sVal = Replace(sVal,"{" & CStr(i) & "}",aArgs(i))
    Next
    strPrintf = sVal
End Function
'========조이름
'public function JooNameReturn(JooText)
'  select case JooText
'    case "B0120007"
'      JooNameReturn = "조번호"
'    case "B0110007"
'      JooNameReturn = "조이름"
'    case "B0110001"
'      JooNameReturn = "A"
'    case "B0110002"
'      JooNameReturn = "B"
'    case "B0110003"
'      JooNameReturn = "C"
'    case "B0110004"
'      JooNameReturn = "D"
'    case "B0110005"
'      JooNameReturn = "E"
'    case "B0110008"
'      JooNameReturn = "초심"
'    case "B0110006"
'      JooNameReturn = "자강"
'    case "B0110009"
'      JooNameReturn = "일반"
'    case "B0110010"
'      JooNameReturn = "통합"
'    case "B0110012"
'      JooNameReturn = "AA"
'    case "B0110011"
'      JooNameReturn = "초급"
'    case "B0110013"
'      JooNameReturn = "준자강"
'    case "B0110014"
'      JooNameReturn = "최강"
'    case else
'      JooNameReturn = "이름없음"
'  end select
'end function


'public function TeamGbReturn(TeamGbText)
'  select case TeamGbText
'    case "39001"
'    	TeamGbReturn = "실버부"
'    case "29001"
'      TeamGbReturn = "인천남구"
'    case "25001"
'      TeamGbReturn = "80세대항"
'    case "16001"
'      TeamGbReturn = "일반부"
'    case "30001"
'      TeamGbReturn = "경기부천"
'    case "23001"
'      TeamGbReturn = "울산 북구"
'    case "11001"
'      TeamGbReturn = "초등부"
'    case "24001"
'      TeamGbReturn = "서울 서초구"
'    case "26001"
'      TeamGbReturn = "100세대항"
'    case "27001"
'      TeamGbReturn = "120세대항"
'    case "28001"
'      TeamGbReturn = "부산진구"
'    case "17001"
'      TeamGbReturn = "어르신부"
'    case "29002"
'      TeamGbReturn = "인천계양구,중구"
'    case "23002"
'      TeamGbReturn = "울산 울주군"
'    case "28002"
'      TeamGbReturn = "부산북구"
'    case "30002"
'      TeamGbReturn = "경기수원"
'    case "12001"
'      TeamGbReturn = "중학부"
'    case "16002"
'      TeamGbReturn = "일반 1부"
'    case "23003"
'      TeamGbReturn = "울산 남구"
'    case "30003"
'      TeamGbReturn = "경기안산"
'    case "16003"
'      TeamGbReturn = "일반 2부"
'    case "13001"
'      TeamGbReturn = "고등부"
'    case "28003"
'      TeamGbReturn = "부산사상구"
'    case "29003"
'      TeamGbReturn = "인천부평구"
'    case "18001"
'      TeamGbReturn = "부부대항"
'    case "28004"
'      TeamGbReturn = "부산수영구"
'    case "14001"
'      TeamGbReturn = "대학부"
'    case "23004"
'      TeamGbReturn = "울산 중구"
'    case "30004"
'      TeamGbReturn = "경기안성"
'    case "19001"
'      TeamGbReturn = "가족대항"
'    case "29004"
'      TeamGbReturn = "인천동구,남동구"
'    case "15001"
'      TeamGbReturn = "일반부"
'    case "21001"
'      TeamGbReturn = "동호인부"
'    case "22001"
'      TeamGbReturn = "부부"
'    case "29006"
'      TeamGbReturn = "인천서구"
'    case "29007"
'      TeamGbReturn = "인천연수구"
'    case "22002"
'      TeamGbReturn = "형제"
'    case "22003"
'      TeamGbReturn = "남매"
'    case "22004"
'      TeamGbReturn = "자매"
'    case "16004"
'      TeamGbReturn = "일반 3부"
'    case else
'      TeamGbReturn = ""
'  end select
'end function




'response.write SexStringReturn("Man")&"<BR>"
'response.write PlayTypeReturn("B0020002")&"<BR>"
'response.write JooNameReturn("B0110001")&"<BR>"
'response.write TeamGbReturn("15001")&"<BR>"

'for i = 1 to 10
'  response.write "<img src='"& convertImageToBase64(Server.mappath("/res")&"\main_txt.png") &"'>"
'next
'
'
'Response.Buffer = true    '버퍼 사용 여부(Y)
'
'for i = 0 to 100
'  response.write "버퍼 테스트 입니다.<br/>"
'  if i mod 10 = 0 then Response.flush    '처리 완료된 데이터를 출력
'next
'
'Response.Clear    '버퍼 내용 초기화
'Response.End    '페이지 종료
Class DynamicArray
 '************** Properties **************
 Private aData
 '****************************************

 '*********** Event Handlers *************
 Private Sub Class_Initialize()
 Redim aData(0)
 End Sub
 '****************************************

 '************ Property Get **************
 Public Property Get Data(iPos)
 '사용자가 지정한 배열 인덱스 유효성 검증
 If iPos < LBound(aData) or iPos > UBound(aData) then
 Exit Property '잘못된 인덱스
 End If

 Data = aData(iPos)
 End Property

 Public Property Get DataArray()
 DataArray = aData
 End Property
 '****************************************

 '************ Property Let **************
 Public Property Let Data(iPos, varValue)
 'iPos >= LBound(aData)인지 검증
 If iPos < LBound(aData) Then Exit Property

 If iPos > UBound(aData) then
 '배열 크기 재조정
 Redim Preserve aData(iPos)
 aData(iPos) = varValue
 Else
 '배열 크기 재조정 필요 없음
 aData(iPos) = varValue
 End If
 End Property
 '****************************************

 '************** Methods *****************
 Public Function StartIndex()
 StartIndex = LBound(aData)
 End Function

 Public Function StopIndex()
 StopIndex = UBound(aData)
 End Function

 Public Sub Delete(iPos)
 'iPos가 적합한 범위 안에 있는지 체크
   If iPos < LBound(aData) or iPos > UBound(aData) then
    Exit Sub 'Invalid range
   End If

   Dim iLoop
   For iLoop = iPos to UBound(aData) - 1
    aData(iLoop) = aData(iLoop + 1)
   Next

   Redim Preserve aData(UBound(aData) - 1)
 End Sub
 '****************************************
End Class

Dim objDynArray
Set objDynArray = New DynamicArray

objDynArray.Data(0) = "안녕"
objDynArray.Data(1) = "하십"
objDynArray.Data(3) = "니까"
objDynArray.Data(4) = "오예"
objDynArray.delete 3

'response.write  instr("김해시청,김해시청","김")


response.write datepart("w","2019-03-17")
%>
