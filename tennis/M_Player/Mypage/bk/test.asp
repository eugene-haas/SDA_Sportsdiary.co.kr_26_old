<%    
	dim arr() 
    reDim arr(3, 4)   

    '4행 5열 배열  
    '0부터 시작하므로 행은 0,1,2,3까지 총 4행  
    '0부터 시작하므로 열은 0,1,2,3,4 까지 총 5열  
  
    numrows = UBound(arr, 1) '행  
    numcols = UBound(arr, 2) '열  
    cnt = 0  	
	
    For i = 0 To numrows '행  
        For j = 0 To numcols '열             
			arr(i, j) = cnt  	
			
            Response.Write "["&arr(i, j)&"]"
			
        Next  
        
		Response.Write "<br /><br />"
		
    Next
  
%>  
  
