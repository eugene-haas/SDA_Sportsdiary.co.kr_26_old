
/* =================================================================================== 
    * 2018. 11. 26    
    * jQuery를 이용한 html element 생성및 사용에 관한 function
                                                                    By Aramdry
   =================================================================================== */


   var ctx = ctx || {} 

/* =================================================================================== 
                    * Common Ctrl - 공통 기능 : 가능하면 사용하지 말자. ( 해당 ctrl 함수를 사용)
    =================================================================================== */        
   /* =================================================================================== 
       id를 입력받아 해당 element를 show / hide한다. 
       =================================================================================== */
       ctx.showElement = function(sender, bShow)
       {                
            if(bShow == true) $('#'+sender).show();
            else $('#'+sender).hide();
       }
   
   /* =================================================================================== 
       class name를 입력받아 해당 elements를 show / hide한다. 
       class name으로 검색할 경우 elements가 n개 이상이 검색 될수 있다. 
       =================================================================================== */
       ctx.showElementEx = function(name, bShow)
       {
           var objs = document.getElementsByClassName(name); 
           
           if(bShow == true) for(var i=0; i<objs.length; i++) objs[i].style.display = "";
           else for(var i=0; i<objs.length; i++) objs[i].style.display = "none";
       }

    /* =================================================================================== 
       id를 입력받아 해당 element를 show / hide한다. 
       =================================================================================== */
       ctx.enableElement = function(sender, bEnable)
       {                  
            if(bEnable == true) $('#'+sender).prop( "disabled", false );
            else $('#'+sender).prop( "disabled", true );
       }
   
   /* =================================================================================== 
       class name를 입력받아 해당 elements를 show / hide한다. 
       class name으로 검색할 경우 elements가 n개 이상이 검색 될수 있다. 
       =================================================================================== */
       ctx.enableElementEx = function(name, bEnable)
       {
           var objs = document.getElementsByClassName(name); 
           
           if(bEnable == true) for(var i=0; i<objs.length; i++) objs[i].style.display = "";
           else for(var i=0; i<objs.length; i++) objs[i].style.display = "none";
       }

   /* =================================================================================== 
       id를 입력받아 해당 element의 height를 setting 
       =================================================================================== */
       ctx.setHeightElement = function(elm_id, val)
       {                
            $('#'+elm_id).height(val);
       }

    /* =================================================================================== 
       id를 입력받아 해당 element의 height를 getting 
       =================================================================================== */
       ctx.getHeightElement = function(elm_id)
       {                
            $('#'+elm_id).height();
       }

    /* =================================================================================== 
       id를 입력받아 해당 element의 width를 setting 
       =================================================================================== */
       ctx.setWidthElement = function(elm_id, val)
       {                
            $('#'+elm_id).width(val);
       }

    /* =================================================================================== 
       id를 입력받아 해당 element의 width를 getting 
       =================================================================================== */
       ctx.getWidthElement = function(elm_id)
       {                
            $('#'+elm_id).width();
       }

    /* =================================================================================== 
        입력받은 id element에 class name을 추가한다.        
       =================================================================================== */
       ctx.addClassElement = function(elm_id, class_name)
       {
            $('#'+elm_id).addClass(class_name); 
       }

   /* =================================================================================== 
        입력받은 id element에 class name을 제거한다.        
       =================================================================================== */
       ctx.removeClassElement = function(elm_id, class_name)
       {
            $('#'+elm_id).removeClass(class_name); 
       }

   /* =================================================================================== 
        입력받은 id element에 class 속성을 반환한다. 
       =================================================================================== */
       ctx.getClassElement = function(elm_id)
       {
            return $('#'+elm_id).attr('class');
       }

    /* =================================================================================== 
        입력받은 id element를 Refresh한다.         
       =================================================================================== */
       ctx.refreshElement = function(elm_id)
       {
            $('#'+elm_id).load(' #'+elm_id+' > *');
       }

   /* =================================================================================== 
        입력받은 id element를 remove한다.   
       =================================================================================== */
       ctx.removeElement = function(elm_id)
       {
         $('#'+elm_id).remove();
       }

   /* =================================================================================== 
        입력받은 id element를 존재유무 체크 
       =================================================================================== */
       ctx.IsExistElement = function(elm_id)
       {
         return ($('#'+elm_id).length > 0) ? true : false ;
       }

      /* =================================================================================== 
        입력받은 id element의 childs을 class name으로 찾는다.  
       =================================================================================== */
       ctx.getChildAllByCID = function(parent_id, cls_name)
       {
         return $("#" + parent_id).find("."+ cls_name);
       }

    /* =================================================================================== 
        입력받은 id 앞에 html을 write한다. 
       =================================================================================== */
       ctx.writeHtmlBefore = function(sender, html)
       {                
            $("#"+sender).before(html);
       }

    /* =================================================================================== 
        입력받은 id 뒤에 html을 write한다. 
       =================================================================================== */
      ctx.writeHtmlAfter = function(sender, bShow)
      {                
        $("#"+sender).after(html);   
      }

   /* =================================================================================== 
        입력받은 id element에 html을 first child로 Insert한다.  <> appendHtml()
      =================================================================================== */
       ctx.addFirstChild = function(elm_id, html)
       {
         $('#'+elm_id).prepend(html);
       }

    /* =================================================================================== 
        입력받은 id에 html을 append 한다.          <> addFirstChild()
       =================================================================================== */
       ctx.appendHtml = function(sender, html)
       {                
            $("#"+sender).append(html);
       }

    /* =================================================================================== 
       id를 입력받아 해당 element를 Focus한다. 
       =================================================================================== */
       ctx.focusElement = function(sender)
       {
            $('#'+sender).focus();
       }

    /* =================================================================================== 
       id를 입력받아 해당 element value를 return - Normal function  
       ( 가능하면 사용하지 말고 특정 element의 get/set function을 사용할것 )
       =================================================================================== */
       ctx.getElementVal = function(sender)
       {
           return $('#'+sender).val();
       }

    /* =================================================================================== 
       id를 입력받아 해당 element text를 return - Normal function  
       ( 가능하면 사용하지 말고 특정 element의 get/set function을 사용할것 )
       =================================================================================== */
       ctx.getElementText = function(sender)
       {
           return $('#'+sender).text();
       }

    /* =================================================================================== 
       id를 입력받아 해당 element에 value를 Setting - Normal function 
       ( 가능하면 사용하지 말고 특정 element의 get/set function을 사용할것 )
       =================================================================================== */
       ctx.setElementVal = function(sender, val)
       {
           $('#'+sender).val(val);
       }
    
    /* =================================================================================== 
        td text를 Setting한다. 
       =================================================================================== */
       ctx.setElementText = function(id_elem, strData)
       {
            $('#'+id_elem).html(strData);
       }


    /* =================================================================================== 
       id를 입력받아 해당 hidden element value를 return 
       =================================================================================== */
       ctx.getHiddenVal = function(sender)
       {
           return $('#'+sender).val();
       }

    /* =================================================================================== 
       name을 입력받아 해당 hidden element value를 return 
       =================================================================================== */
       ctx.getHiddenValEx = function(name)
       {
           return $('input[name='+name+']').val();
       }

    /* =================================================================================== 
       id를 입력받아 해당 hidden element에 value를 Setting
       =================================================================================== */
       ctx.setHiddenVal = function(sender, val)
       {
           $('#'+sender).val(val);
       }

    /* =================================================================================== 
       name을 입력받아 해당 hidden element에 value를 Setting
       =================================================================================== */
       ctx.setHiddenValEx = function(name, val)
       {
           $('input[name='+name+']').val(val);
       }

   /* =================================================================================== 
       =================================================================================== */

   
/*  =================================================================================== 
                    * Datepicker
    =================================================================================== */      
      ctx.createDatepicker = function(sender, Initdate)
      {
         if(Initdate == undefined || Initdate == null) Initdate = ""; 

          $( "#"+sender ).datepicker({
              changeYear:true,
              changeMonth: true,
              dayNamesMin: ['일','월', '화', '수', '목', '금', '토'],
              monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
              showMonthAfterYear:true,
              showButtonPanel: true,
              currentText: '오늘 날짜',
              closeText: '닫기',
              dateFormat: "yy-mm-dd"
          });
      
          //초기값을 오늘 날짜로 설정
          if(Initdate == "") $("#"+sender).datepicker('setDate', 'today'); 
          else 
          {
              // Date객체를 만들어 setDate호출 
              $("#"+sender).datepicker('setDate', Initdate); 
          }
      }
      
/*  =================================================================================== 
                    * Select Ctrl 
    =================================================================================== */
      /* =================================================================================== 
          select element - id를 입력받아 해당 select의 option을 추가한다. (시간)
         =================================================================================== */
      ctx.createHourSelect = function(sender, bFrontZero)
      {
         if(bFrontZero == undefined || bFrontZero == null) bFrontZero = true; 
          for(i=0; i<24; i++)
          {
              if(bFrontZero && i < 10) $("#"+sender).append("<option value='"+(i) + "'> 0" + (i) + "시</option>");
              else $("#"+sender).append("<option value='"+(i) + "'>" + (i) + "시</option>");
          }
      }
      
      /* =================================================================================== 
          select element - id를 입력받아 해당 select의 option을 추가한다. (분)
         =================================================================================== */
      ctx.createMinSelect = function(sender, bFrontZero)
      {
         if(bFrontZero == undefined || bFrontZero == null) bFrontZero = true; 
          for(i=0; i<60; i++)
          {
              if(bFrontZero && i < 10) $("#"+sender).append("<option value='"+(i) + "'> 0" + (i) + "분</option>");
              else $("#"+sender).append("<option value='"+(i) + "'>" + (i) + "분</option>");
          }
      }
      
      /* =================================================================================== 
          select element - id, value를 입력받아 value를 가지고 있는 option을 선택한다. 
         =================================================================================== */
      ctx.setSelectVal = function(sender, selData)
      {
          $("#"+sender).val(selData);
      }
      
      /* =================================================================================== 
          select element - id를 입력받아 현재 선택된 value를 return 한다. 
         =================================================================================== */
      ctx.getSelectVal = function(sender)
      {       
          return $("#"+sender+ " option:selected").val();       
      }
   
   /* =================================================================================== 
       select element - id를 입력받아 현재 선택된 Text를 return 한다. 
       =================================================================================== */
       ctx.getSelectText = function(sender)
       {
           return  $("#"+sender+ " option:selected").text();
       }

   /* =================================================================================== 
       select element - id를 입력받아 select item 갯수를 반환한다. 
       =================================================================================== */
       ctx.getSelectItemCnt = function(sender)
       {           
           return $('select#'+sender+' option').length;
       }
      
      
/*  =================================================================================== 
                    * Radio Button Ctrl 
    =================================================================================== */
   
      /* =================================================================================== 
          Radio element 이름, 순서, check유무를 입력받아 해당 Radio를 (check or uncheck)한다. 
         =================================================================================== */
      ctx.setRadioVal = function(name, idx, bCheck)
      {
          $('input:radio[name='+name+']:nth('+idx+')').attr('checked',bCheck);
      }
      
      /* =================================================================================== 
          Radio element 이름을 입력받아 현재 선택된 element의 value를 Return한다. 
         =================================================================================== */
      ctx.getRadioVal = function(name)
      {
          return $('input:radio[name='+name+']:checked').val();
      }
   
      /* =================================================================================== 
          Radio element 이름을 입력받아 현재 선택된 element의 text를 Return한다. 
         =================================================================================== */
       ctx.getRadioText = function(name)
       {
           return $('input:radio[name='+name+']:checked').text();
       }

/*  =================================================================================== 
                    * check Button Ctrl 
    =================================================================================== */
   /* =================================================================================== 
       checkbox element id, check 유무를 입력받아 CheckBox를 Check/UnCheck한다. ( _Ex() name도 가능 )
       =================================================================================== */    
       ctx.setCheckboxVal = function(sender, bCheck)
       {
           $('input:checkbox[id='+sender+']').prop("checked", bCheck);
       }
   
       ctx.setCheckboxValEx = function(name, bCheck)
       {
           $('input:checkbox[name='+name+']').prop("checked", bCheck);
       } 

    /* =================================================================================== 
       child checkbox set check/uncheck
       =================================================================================== */  
       ctx.setCheckboxValCID = function(classID, bCheck)
       {
           $("."+classID).prop("checked", bCheck);
       }    
   
    /* =================================================================================== 
       get count Of checked child check box
       =================================================================================== */  
       ctx.getCntCheckedCID = function(classID)
       {
           return $("."+classID+":checked").length;
       }  
    /* =================================================================================== 
       get count Of child check box
       =================================================================================== */  
       ctx.getCntCheckboxCID = function(classID)
       {
           return $("."+classID).length;
       }     
    
    /* =================================================================================== 
       get value Array Of checked child check box
       =================================================================================== */  
       ctx.getAryCheckedValueCID = function(classID)
       {
            var aryVal = new Array();
            $("."+classID+":checked").each(function() {
                aryVal.push(this.value);
            });

            return aryVal;
       }  
    /* =================================================================================== 
       get string seperate ,  Of checked child check box
       =================================================================================== */  
       ctx.getStrCheckedValueCID = function(classID)
       {
            var aryVal = new Array();
            $("."+classID+":checked").each(function() {
                aryVal.push(this.value);
            });

            utx.printAry(aryVal);

            var len = aryVal.length;
            var strVal = "";    
            
            for(i=0; i<len; i++)
            {
                if(i == (len-1) ) strVal += utx.strPrintf("{0}", aryVal[i]); 
                else strVal += utx.strPrintf("{0},", aryVal[i]);
            }

            return strVal;
       }

      /* =================================================================================== 
       classID를 입력받아 모든 CheckBox의 상태를 Check/Uncheck한다. 
       =================================================================================== */
       ctx.setChildCheckboxVal = function(classID, bCheck)
       {
          $( '.'+classID ).prop( 'checked', bCheck );
       }

       /* =================================================================================== 
         classID를 입력받아 Check된 CheckBox의 Coun를 구한다. 
       =================================================================================== */
       ctx.getCntCheckedChildCheckbox = function(classID)
       {
          var nCnt = 0;
          $("."+classID+":checked").each(function() {
                nCnt++;
          });
    
          return nCnt; 
       }
    
      /* =================================================================================== 
         classID를 입력받아 모든 CheckBox의 Coun를 구한다. 
       =================================================================================== */
       ctx.getCntChildCheckbox = function(classID)
       {
          return $("."+classID).length
       }
    
   /* =================================================================================== 
       checkbox element id를 입력받아 현재 Checked 유무를 반환한다. ( _Ex() name도 가능 )
       =================================================================================== */
       ctx.IsSelectCheckbox = function(sender)
       {
           return $('input:checkbox[id='+sender+']').is(":checked");
       }
       
       ctx.IsSelectCheckboxEx = function(name)
       {
           return $('input:checkbox[name='+name+']').is(":checked");
       }
   
   
   /* =================================================================================== 
       checkbox element id를 입력받아 체크된 체크 박스의 value를 Return받는다. ( _Ex() name도 가능 )
       =================================================================================== */    
       ctx.getCheckboxVal = function(sender)
       {
           return $('input:checkbox[id='+sender+']').val();
           // return $('#'+sender+']').val();
       };
   
       ctx.getCheckboxValEx = function(name)
       {
           return $('input:checkbox[name='+name+']').val();
       };  
 
 /*  =================================================================================== 
                    * TextBox Ctrl 
    =================================================================================== */      
   /* =================================================================================== 
       text element id, val를 입력받아 text를 입력한다.  ( _Ex() name도 가능 )
       textArea도 적용 되나 id로만 가능하다. 
       =================================================================================== */    
       ctx.setTextboxVal = function(sender, val)
       {        
           $('#'+sender).val(val);
       }
   
       ctx.setTextboxValEx = function(name, val)
       {
           $('input[name='+name+']').val(val);
       }    
   /* =================================================================================== 
       text element id를 입력받아 입력된 text를 return한다.   ( _Ex() name도 가능 )
       textArea도 적용 되나 id로만 가능하다. 
       =================================================================================== */
       ctx.getTextboxVal = function(sender)
       {
           return $('#'+sender).val();
       }
       
       ctx.getTextboxValEx = function(name)
       {
           return $('input[name='+name+']').val();
       }


 /* =================================================================================== 
                    * Table
    =================================================================================== */  
    /* =================================================================================== 
        table id, table 안의 tb ctrl을 받아서 그 pos을 반환한다. 
        posObj.x : col position, posObj.y : row position
    =================================================================================== */
    ctx.getPosInTableByCell = function(id_table, tbCell) {
        var table, rows, cols;
        var posObj = {};
        posObj.x = -1; posObj.y = -1;
        
        table = document.getElementById(id_table);
        if( table  == null) return posObj; 
    
        rows = table.rows;
    
        for(var i=0; i< rows.length; i++)
        {
        cells = rows[i].cells;    
        for(var j=0; j<cells.length; j++)
        { 
            if(cells[j] == tbCell) {
            posObj.x = j; posObj.y = i;   
            return posObj; 
            }     
        }
        }
        
        return posObj; 
    }
/* =================================================================================== 
        table id, table 안의 td pos을 받아서 그 td의 Text를 ,로 구분된 문자열로 반환한다 .        
    =================================================================================== */
    ctx.getListTDInTable = function(id_table, td_pos)
    {
        var strCodes = ""; 
        // 특정상품 선택 
        var table = document.getElementById(id_table);
        var rowLength = table.rows.length;

        for(var i=1; i<rowLength; i+=1){
            var row = table.rows[i];
            strCodes += row.cells[td_pos].innerHTML + ",";
        }

        // 제일 마지막에 있는 ','문자열 제거
        if(strCodes.length > 1) strCodes = strCodes.substring(0, strCodes.length-1);
        return strCodes;
    }

    /* =================================================================================== 
       id를 입력받아 Table TR value를 return 
       =================================================================================== */
       ctx.getTableTRVal = function(sender)
       {
           return $('#'+sender).val();
       }

    /* =================================================================================== 
       id를 입력받아 해당 Table TR text를 return
       =================================================================================== */
       ctx.getTableTRText = function(sender)
       {
           return $('#'+sender).text();
       }

    /* =================================================================================== 
       id를 입력받아 Table TD value를 return 
       =================================================================================== */
       ctx.getTableTDVal = function(sender)
       {
           return $('#'+sender).val();
       }

    /* =================================================================================== 
       id를 입력받아 해당 Table TD text를 return
       =================================================================================== */
       ctx.getTableTDText = function(sender)
       {
           return $('#'+sender).text();
       }

    /* =================================================================================== 
        td text를 Setting한다. 
       =================================================================================== */
       ctx.setTableTDText = function(td_id, strData)
       {
            $('#'+td_id).html(strData);
       }

    /* =================================================================================== 
       tr을 다른 table에 move한다. 
       =================================================================================== */
       ctx.moveTRToTBody = function(tbody_id, tr_id)
       {
            $('#'+tbody_id).append($('#'+tr_id));
       }

    /* =================================================================================== 
       td html을 tr에 추가한다. 
       =================================================================================== */
       ctx.appendTDHtmlToTR = function(tr_id, td_html)
       {
            $('#'+tr_id).append(td_html);
       }

    /* =================================================================================== 
        td를 삭제한다. 
       =================================================================================== */
       ctx.removeTableTD = function(td_id)
       {
            $('#'+td_id).remove();
       }

    /* =================================================================================== 
        table에서 tr count를 센다. 
       =================================================================================== */
       ctx.getTableTRCount = function(table_id, bHasTBody)
       {
         if(bHasTBody == undefined || bHasTBody == null) bHasTBody=false;
         var count = 0; 
         if(bHasTBody) count = $('#'+table_id+' > tbody > tr').length;
         else count = $('#'+table_id).length;

         return count;
       }

 /*  =================================================================================== 
                    * Div
    =================================================================================== */   
    /* =================================================================================== 
            div에 html을 Write한다 .  
       =================================================================================== */
       ctx.writeHtmlToDiv = function(id_elem, strData)
       {
            $('#'+id_elem).html(strData);
       }
    
    /* =================================================================================== 
            div에 html을 추가한다. 
       =================================================================================== */
       ctx.appendHtmlToDiv = function(div_id, strHtml)
       {
            $('#'+div_id).append(strHtml);
       } 
       
    /* =================================================================================== 
            div에 html을 삭제한다. 
       =================================================================================== */
       ctx.removeHtmlFromDiv = function(div_id)
       {
            $('#'+div_id).html("");
       } 

   /* =================================================================================== 
       div val를 얻는다. 
       =================================================================================== */
       ctx.getDivVal = function(sender)
       {
           return $('#'+sender).val();
       }

    /* =================================================================================== 
        div text를 얻는다 .
       =================================================================================== */
       ctx.getDivText = function(sender)
       {
           return $('#'+sender).text();
       }

    /*  =================================================================================== 
                    * Span
         =================================================================================== */ 
      /* =================================================================================== 
       Set span val
       =================================================================================== */
       ctx.setSpanVal = function(sender, val)
       {
           return $('#'+sender).val(val);
       }

       
      /* =================================================================================== 
       span val를 얻는다. 
       =================================================================================== */
       ctx.getSpanVal = function(sender)
       {
           return $('#'+sender).val();
       }

      /* =================================================================================== 
        Set span text
       =================================================================================== */
       ctx.setSpanText = function(sender, strData)
       {
           return $('#'+sender).html(strData);
       }

    /* =================================================================================== 
        span text를 얻는다 .
       =================================================================================== */
       ctx.getSpanText = function(sender)
       {
           return $('#'+sender).text();
		 }
		 
	/* =================================================================================== 
            div에 html을 Write한다 .  
       =================================================================================== */
       ctx.writeHtmlToSpan = function(id_elem, strData)
       {
            $('#'+id_elem).html(strData);
       }

 /*  =================================================================================== 
                    * ul   - List
    =================================================================================== */       
    /* =================================================================================== 
            ul에서 li의 갯수를 센다. 
       =================================================================================== */
       ctx.getCntOfListItem = function(ul_id)
       {
            return $('ul#'+ul_id).children('li').length;
       } 

       ctx.removeChildAllList = function(ul_class)
       {
        $('ul.'+ul_class).children().remove();
       }

       ctx.getChildIdAryOfList = function(ul_id)
       {
           var list = $('ul#'+ul_id);
           var len = list.children('li').length;

           console.log("getChildIdAryOfList len = " + len);

           var ary = new Array(len);

           for(i=0; i<len; i++)
           {
               ary[i] = list.children('li').eq(i).attr("id");
           }

           return ary;
       }

       ctx.getListItemText = function(sender)
       {
            return $('#'+sender).text();
       } 

/*  =================================================================================== 
                    * scroll pos
    =================================================================================== */  
    /* =================================================================================== 
            스크롤의 제일 위로 이동한다. 
       =================================================================================== */
       ctx.moveToScrollTop = function(id_elem)
       {
            $('#'+id_elem).scrollTop(0);
       } 

    /* =================================================================================== 
            스크롤의 제일 아래로 이동한다. 
       =================================================================================== */
       ctx.moveToScrollBottom = function(id_elem)
       {
            $('#'+id_elem).scrollTop( $('#'+id_elem)[0].scrollHeight );
       } 
       

