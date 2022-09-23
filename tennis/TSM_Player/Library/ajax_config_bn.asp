<%

  Const Ref1 = "GPQRSATWXVYBCHL640MN598OIJKZ12D7EF3U"

	'===============================================================================
	' 암호화
	'===============================================================================
	Function encode_bn(str, chipVal)
		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""
		
		chipVal = CInt(chipVal)
		str = StringToHex(str)
		
		For i = 0 To Len(str) - 1
			TempChar = Mid(str, i + 1, 1)
			Conv = InStr(Ref1, TempChar) - 1
			Cipher = Conv Xor chipVal
			Cipher = Mid(Ref1, Cipher + 1, 1)
			Temp = Temp + Cipher
		Next

		encode_bn = Temp

	End Function

	'===============================================================================
	' 복호화
	'===============================================================================
	Function decode_bn(str, chipVal)	      
		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""
	
		chipVal = CInt(chipVal)
		
		For i = 0 To Len(str) - 1
		  TempChar = Mid(str, i + 1, 1)
		  Conv = InStr(Ref1, TempChar) - 1
		  Cipher = Conv Xor chipVal
		  Cipher = Mid(Ref1, Cipher + 1, 1)
		  Temp = Temp + Cipher
		Next
		
		Temp = HexToString(Temp)
		decode_bn = Temp
		
	End Function  
  
%>

<!--#include file="../Library/common_function.asp"-->
<!--#include file="../Library/dbcon.asp"-->

<%

	DBopen()
	DBOpen3()
	DBOpen4()
  AD_DBOpen()

%>