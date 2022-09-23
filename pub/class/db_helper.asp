<%
  Class clsDBHelper
    Private DefaultConnString
    Private DefaultConnection
    private rs
    private cmd
    private param

    private sub Class_Initialize()
      DefaultConnString = ConStr
      Set DefaultConnection = Nothing
    End Sub


	Private Sub Class_Terminate()
		Dispose
	End Sub

    '---------------------------------------------------
    ' SP를 실행하고, RecordSet을 반환한다.
    '---------------------------------------------------
	Public Function ExecSPReturnRS(ByVal spName, ByRef params, ByVal connectionString)
		If IsObject(connectionString) Then
			If connectionString is Nothing Then
				If DefaultConnection is Nothing Then
					Set DefaultConnection = CreateObject("ADODB.Connection")
					DefaultConnection.CommandTimeout = 0
					DefaultConnection.Open DefaultConnString
					'DefaultConnection.Execute "SET ARITHABORT ON;"
				End If
				Set connectionString = DefaultConnection
			End If
		End If

	    Set rs = CreateObject("ADODB.RecordSet")
	    Set cmd = CreateObject("ADODB.Command")

	    cmd.ActiveConnection = connectionString
	    cmd.CommandText = spName
	    cmd.CommandType = adCmdStoredProc
	    Set cmd = collectParams(cmd, params)
	    'cmd.Parameters.Refresh

	    rs.CursorLocation = adUseClient
	    rs.Open cmd, ,adOpenStatic, adLockReadOnly

	    For f = 0 To cmd.Parameters.Count - 1
			If cmd.Parameters(f).Direction = adParamOutput OR cmd.Parameters(f).Direction = adParamInputOutput OR cmd.Parameters(f).Direction = adParamReturnValue Then
				If IsObject(params) Then
					If params is Nothing Then
						Exit For
					End If
				Else
					params(f)(4) = cmd.Parameters(f).Value
				End If
			End If
	    Next

	    Set cmd.ActiveConnection = Nothing
	    Set cmd = Nothing

	    If rs.State = adStateClosed Then
			Set rs.Source = Nothing
		End If

		'Set rs.ActiveConnection = Nothing

	    Set ExecSPReturnRS = rs
    End Function

    '---------------------------------------------------
    ' SQL Query를 실행하고, RecordSet을 반환한다.
    '---------------------------------------------------
'    Public Function ExecSQLReturnRS(strSQL, params, connectionString)
'      If IsObject(connectionString) Then
'        If connectionString is Nothing Then
'          If DefaultConnection is Nothing Then
'            Set DefaultConnection = CreateObject("ADODB.Connection")
'            DefaultConnection.Open DefaultConnString
'          End If
'          Set connectionString = DefaultConnection
'        End If
'      End If
'
'      Set rs = CreateObject("ADODB.RecordSet")
'      Set cmd = CreateObject("ADODB.Command")
'
'      cmd.ActiveConnection = connectionString
'      cmd.CommandText = strSQL
'      cmd.CommandType = adCmdText
'      Set cmd = collectParams(cmd, params)
'
'      rs.CursorLocation = adUseClient
'      rs.Open cmd, , adOpenStatic, adLockReadOnly
'
'      Set cmd.ActiveConnection = Nothing
'      Set cmd = Nothing
'
'	  Set ExecSQLReturnRS = rs
'    End Function


    Public Function ExecSQLReturnRS(ByVal strSQL, ByRef params, ByVal connectionString)
		If IsObject(connectionString) Then
			If connectionString is Nothing Then
				If DefaultConnection is Nothing Then
					Set DefaultConnection = CreateObject("ADODB.Connection")
					DefaultConnection.CommandTimeout = 0
					DefaultConnection.Open DefaultConnString
					'DefaultConnection.Execute "SET ARITHABORT ON;"
				End If
				Set connectionString = DefaultConnection
			End If
		End If

	    Set rs = CreateObject("ADODB.RecordSet")
	    Set cmd = CreateObject("ADODB.Command")

	    cmd.ActiveConnection = connectionString
	    cmd.CommandText = strSQL
	    cmd.CommandType = adCmdText
	    Set cmd = collectParams(cmd, params)


	    rs.CursorLocation = adUseClient
		rs.Open cmd, , adOpenStatic, adLockReadOnly

	    For f = 0 To cmd.Parameters.Count - 1
			If cmd.Parameters(f).Direction = adParamOutput OR cmd.Parameters(f).Direction = adParamInputOutput OR cmd.Parameters(f).Direction = adParamReturnValue Then
				If IsObject(params) Then
					If params is Nothing Then
						Exit For
					End If
				Else
					params(f)(4) = cmd.Parameters(f).Value
				End If
			End If
	    Next

	    Set cmd.ActiveConnection = Nothing
	    Set cmd = Nothing

    	If rs.State = adStateClosed Then
			Set rs.Source = Nothing
		End If

		'Set rs.ActiveConnection = Nothing

	    Set ExecSQLReturnRS = rs
    End Function




  Public Sub execSQLRs(ByVal strSQL, ByRef params, ByRef connectionString)
	  
	  If IsObject(connectionString) Then
        If connectionString is Nothing Then
          If DefaultConnection is Nothing Then
            Set DefaultConnection = CreateObject("ADODB.Connection")
            DefaultConnection.Open DefaultConnString
          End If
          Set connectionString = DefaultConnection
        End If
      End If

      Set cmd = CreateObject("ADODB.Command")
      cmd.ActiveConnection = connectionString
      cmd.CommandText = strSQL
      cmd.CommandType = adCmdText
      Set cmd = collectParams(cmd, params)

'If  Request.ServerVariables("REMOTE_ADDR") = "220.118.165.212" then

Response.write strSQL & "..<br>"
'Response.End

'else
      cmd.Execute , , adExecuteNoRecords
      Dim i
      For i = 0 To cmd.Parameters.Count - 1
        If cmd.Parameters(i).Direction = adParamOutput OR cmd.Parameters(i).Direction = adParamInputOutput OR cmd.Parameters(i).Direction = adParamReturnValue Then
          If IsObject(params) Then
            If params is Nothing Then
              Exit For
            End If
          Else
            params(i)(4) = cmd.Parameters(i).Value

          End If
        End If
      Next
'End if

      Set cmd.ActiveConnection = Nothing
      Set cmd = Nothing
  End Sub

    '---------------------------------------------------
    ' SP를 실행한다.(RecordSet 반환없음)
    '---------------------------------------------------
    Public Sub ExecSP(strSP,params,connectionString)
      If IsObject(connectionString) Then
        If connectionString is Nothing Then
          If DefaultConnection is Nothing Then
            Set DefaultConnection = CreateObject("ADODB.Connection")
            DefaultConnection.Open DefaultConnString
          End If
          Set connectionString = DefaultConnection
        End If
      End If

      Set cmd = CreateObject("ADODB.Command")

    cmd.ActiveConnection = connectionString
      cmd.CommandText = strSP
      cmd.CommandType = adCmdStoredProc
      Set cmd = collectParams(cmd, params)

      cmd.Execute , , adExecuteNoRecords
      Dim i
      For i = 0 To cmd.Parameters.Count - 1
        If cmd.Parameters(i).Direction = adParamOutput OR cmd.Parameters(i).Direction = adParamInputOutput OR cmd.Parameters(i).Direction = adParamReturnValue Then
          If IsObject(params) Then
            If params is Nothing Then
              Exit For
            End If
          Else
            params(i)(4) = cmd.Parameters(i).Value
          End If
        End If
      Next

      Set cmd.ActiveConnection = Nothing
      Set cmd = Nothing
    End Sub

    '---------------------------------------------------
    ' SP를 실행한다.(RecordSet 반환없음)
    '---------------------------------------------------
    Public Sub ExecSQL(strSQL,params,connectionString)
      If IsObject(connectionString) Then
        If connectionString is Nothing Then
          If DefaultConnection is Nothing Then
            Set DefaultConnection = CreateObject("ADODB.Connection")
            DefaultConnection.Open DefaultConnString
          End If
          Set connectionString = DefaultConnection
        End If
      End If

      Set cmd = CreateObject("ADODB.Command")

      cmd.ActiveConnection = connectionString
      cmd.CommandText = strSQL
      cmd.CommandType = adCmdText
      Set cmd = collectParams(cmd, params)

      cmd.Execute , , adExecuteNoRecords

      Set cmd.ActiveConnection = Nothing
      Set cmd = Nothing
    End Sub

    '---------------------------------------------------
    ' 트랜잭션을 시작하고, Connetion 개체를 반환한다.
    '---------------------------------------------------
    Public Function BeginTrans(connectionString)
      If IsObject(connectionString) Then
        If connectionString is Nothing Then
          connectionString = DefaultConnString
        End If
      End If

      Set conn = Server.CreateObject("ADODB.Connection")
      conn.Open connectionString
      conn.BeginTrans
      Set BeginTrans = conn
    End Function

    '---------------------------------------------------
    ' 활성화된 트랜잭션을 커밋한다.
    '---------------------------------------------------
    Public Sub CommitTrans(connectionObj)
      If Not connectionObj Is Nothing Then
        connectionObj.CommitTrans
        connectionObj.Close
        Set ConnectionObj = Nothing
      End If
    End Sub

    '---------------------------------------------------
    ' 활성화된 트랜잭션을 롤백한다.
    '---------------------------------------------------
    Public Sub RollbackTrans(connectionObj)
      If Not connectionObj Is Nothing Then
        connectionObj.RollbackTrans
        connectionObj.Close
        Set ConnectionObj = Nothing
      End If
    End Sub

    '---------------------------------------------------
    ' 배열로 매개변수를 만든다.
    '---------------------------------------------------
    Public Function MakeParam(PName,PType,PDirection,PSize,PValue)
      MakeParam = Array(PName, PType, PDirection, PSize, PValue)
    End Function

    '---------------------------------------------------
    ' 매개변수 배열 내에서 지정된 이름의 매개변수 값을 반환한다.
    '---------------------------------------------------
    Public Function GetValue(params, paramName)
      For Each param in params
        If param(0) = paramName Then
          GetValue = param(4)
          Exit Function
        End If
      Next
    End Function

    Public Sub Dispose
    if (Not DefaultConnection is Nothing) Then
      if (DefaultConnection.State = adStateOpen) Then DefaultConnection.Close
      Set DefaultConnection = Nothing
    End if
    End Sub

    '---------------------------------------------------------------------------
    'Array로 넘겨오는 파라메터를 Parsing 하여 Parameter 객체를
    '생성하여 Command 객체에 추가한다.
    '---------------------------------------------------------------------------
    '---------------------------------------------------------------------------
    'Array로 넘겨오는 파라메터를 Parsing 하여 Parameter 객체를
    '생성하여 Command 객체에 추가한다.
    '---------------------------------------------------------------------------
    Private Function collectParams(ByVal cmd, ByVal argparams)
		Dim params, f, l, u, v, length

	    If VarType(argparams) = 8192 or VarType(argparams) = 8204 or VarType(argparams) = 8209 then
		    params = argparams
		    For f = LBound(params) To UBound(params)
			    l = LBound(params(f))
			    u = UBound(params(f))
			    ' Check for nulls.
			    If u - l = 4 Then

				    If VarType(params(f)(4)) = vbString Then
					    If params(f)(4) = "" Then
							If IsNull(params(f)(4)) Then
								v = Null
							Else
								v = ""
							End If
					    Else  'Varchar형 일때 html 태그 가능한건 변환
							v = Replace(Replace(Replace(Replace(params(f)(4) _
									,"https://www." & URL_HOST, "") _
									,"https://" & URL_HOST, "") _
									,"http://www." & URL_HOST, "") _
									,"http://" & URL_HOST, "")
					    End If
				    Else
					    v = params(f)(4)
				    End If



					If Not IsNull(v) Then
						Select Case params(f)(1)
							Case adChar, adwChar, adVarchar, adVarwchar, adLongVarchar, adLongVarwchar
								length = params(f)(3)
								If length="max" Or params(f)(1)=adLongVarchar Or params(f)(1)=adLongVarwchar Then
									length = 2147483647
								End If

								v = returnToCut(v, length, "")
							Case adInteger
								If chkBlank(v) Then v = null
								If CDbl(v) > 2147483647 Then v = 0
							Case adBigInt
								If chkBlank(v) Then v = null
								If CDbl(v) > 9223372036854775807 Then v = 0
						End Select
					Else
						If chkBlank(params(f)(3)) Then
							length = 0
						Else
							length = params(f)(3)
						End If
					End If

				   cmd.Parameters.Append cmd.CreateParameter(params(f)(0), params(f)(1), params(f)(2), length, v)
			    End If
		    Next

		    Set collectParams = cmd
		    Exit Function
	    Else
		    Set collectParams = cmd
	    End If
    End Function

End Class

%>
