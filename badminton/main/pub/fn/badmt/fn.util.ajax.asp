<script language="Javascript" runat="server">
	function hasown(obj,  prop){
		if (obj.hasOwnProperty(prop) == true){
			return "ok";
		}
		else{
			return "notok";
		}
	}
</script>

<%
   '#############################
   '레코드 JSON 으로 반환
   '#############################
   Function rsTojson_arr(rs)
      Dim rsObj,subObj, fieldarr, i, arr, mainObj
      Dim ub, ub2
      Set mainObj = jsObject()

      If Not rs.EOF Then
         arr = rs.GetRows()

         ub = UBound(arr,1)
         ub2 = UBound(arr,2)

         ReDim rsObj(ub2)
         ReDim fieldarr(ub)
         For i = 0 To ub
            fieldarr(i) = CStr(i)
         Next

         If IsArray(arr) Then
            For ar = LBound(arr, 2) To UBound(arr, 2)

               Set subObj = jsObject()
               For c = LBound(arr, 1) To UBound(arr, 1)
                  subObj(fieldarr(c)) = arr(c, ar)
               Next
               Set rsObj(ar) = subObj
            Next
         End if

         rsTojson_arr = toJSON(rsObj)
      Else
         rsTojson_arr = ""
      End if
   End Function		

   '#############################
   '레코드 JSON 으로 반환
   '#############################
   Function rsTojson_arrEx(rs)
      Dim rsObj,subObj, fieldarr, i, arr, mainObj
      Dim ub, ub2

      Set mainObj = jsObject()

      If Not rs.EOF Then
         arr = rs.GetRows()

         ub = UBound(arr,1)
         ub2 = UBound(arr,2)

         ReDim rsObj(ub2)
         ReDim fieldarr(ub)
         For i = 0 To ub
            fieldarr(i) = Rs.Fields(i).name
         Next

         If IsArray(arr) Then
            For ar = LBound(arr, 2) To UBound(arr, 2)

               Set subObj = jsObject()
               For c = LBound(arr, 1) To UBound(arr, 1)
                  subObj(fieldarr(c)) = arr(c, ar)
               Next
               Set rsObj(ar) = subObj
            Next
         End if

         rsTojson_arrEx = toJSON(rsObj)
      Else
         rsTojson_arrEx = toJSON(rsObj)
      End if
   End Function
%>