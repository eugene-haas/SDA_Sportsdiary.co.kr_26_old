<%
Response.CharSet="utf-8"
Session.codepage="65001"
Response.codepage="65001"

dim chk_master,master,association_select,department_select,fr_select,f_select,program_select,joins

DBOpen()
'아이템코드가 정의되어있다. (모든셀렉트 ) by baek 주석좀 달자 ...ㅡㅡ
'SELECT_SQL = "SELECT MASTER_CODE,SUB_CODE,SUB_TITLE FROM TB_SELECTITEM WHERE DELKEY = 0 ORDER BY MASTER_CODE,ORDERBY,TITLE"

SELECT_SQL ="SELECT MASTER_CODE,SUB_CODE,SUB_TITLE FROM TB_SELECTITEM WHERE DELKEY = 0 and MASTER_CODE not in ('QT','QF') or  "
SELECT_SQL = SELECT_SQL &" (MASTER_CODE in ('QF','QT') and sub_code in ( select QUARTER_CODE from TB_FACILITY where DELKEY = 0 and ONOFF = 0 group by QUARTER_CODE )) ORDER BY MASTER_CODE,ORDERBY,TITLE "
SELECTED = ExecuteReturn(SELECT_SQL, DB)


'단체명
SELECT_SQL = " SELECT SEQ,TITLE FROM TB_ASSOCIATION WHERE DELKEY = 0 ORDER BY TITLE "
ASSOCIATION_SELECTED = ExecuteReturn(SELECT_SQL, DB)
'부서
SELECT_SQL = " SELECT SEQ,TITLE FROM TB_DEPARTMENT WHERE DELKEY = 0 AND SEQ NOT IN (2) ORDER BY TITLE "
DEPARTMENT_SELECTED = ExecuteReturn(SELECT_SQL, DB)

'시설명
SELECT_SQL = " SELECT A.SEQ, A.NUMBER, A.PRICE, B.INTERVAL FROM TB_FACILITY A INNER JOIN TB_RENTAL_FACILITY_INFO B ON B.DELKEY = 0 AND B.FACILITY_SEQ = A.SEQ  WHERE A.DELKEY = 0 and a.onoff = 0 AND A.FACILITY_TYPE_CODE = 'FT0002' ORDER BY A.NUMBER "
FR_SELECTED = ExecuteReturn(SELECT_SQL, DB)

'동/관전체
SELECT_SQL = " SELECT SEQ,NUMBER,QUARTER_CODE FROM TB_FACILITY WHERE DELKEY = 0 and ONOFF = 0 ORDER BY NUMBER "
F_SELECTED = ExecuteReturn(SELECT_SQL, DB)

SELECT_SQL = " SELECT SEQ,TITLE FROM TB_RENTAL_PROGRAM WHERE DELKEY = 0 ORDER BY TITLE "
PROGRAM_SELECTED = ExecuteReturn(SELECT_SQL, DB)



chk_master = ""
master = ""
joins = ""
For i = 0 To UBound(SELECTED,2)
  If SELECTED(0,i) <> chk_master Then
    chk_master = SELECTED(0,i)
    master = master & joins & "]," & SELECTED(0,i) & ":["
    joins = "{seq: '"& SELECTED(1,i) &"', title: '"& SELECTED(2,i) &"' }"
  Else
    joins = joins & ",{seq: '"& SELECTED(1,i) &"', title: '"& SELECTED(2,i) &"' }"
  End If
Next
master = master & joins & "],"



For i = 0 To UBound(ASSOCIATION_SELECTED,2)
  association_select = association_select & ",{seq: '"& ASSOCIATION_SELECTED(0,i) &"', title: '"& ASSOCIATION_SELECTED(1,i) &"' }"
Next

For i = 0 To UBound(DEPARTMENT_SELECTED,2)
  department_select = department_select & ",{seq: '"& DEPARTMENT_SELECTED(0,i) &"', title: '"& DEPARTMENT_SELECTED(1,i) &"' }"
Next

If isarray(FR_SELECTED) then
For i = 0 To UBound(FR_SELECTED,2)
  fr_select = fr_select & ",{seq: '"& FR_SELECTED(0,i) &"', number: '"& FR_SELECTED(1,i) &"', price: '"& FR_SELECTED(2,i) &"', interval: '"& FR_SELECTED(3,i) &"' }"
Next
End if

For i = 0 To UBound(F_SELECTED,2)
  f_select = f_select & ",{seq: '"& F_SELECTED(0,i) &"', number: '"& F_SELECTED(1,i) &"', quarter_seq: '"& F_SELECTED(2,i) &"' }"
Next

For i = 0 To UBound(PROGRAM_SELECTED,2)
  program_select = program_select & ",{seq: '"& PROGRAM_SELECTED(0,i) &"', title: '"& PROGRAM_SELECTED(1,i) &"' }"
Next

DBClose()
%>
<script>
var selected_item={
    <%=mid(master,3)%>
    association: [<%=mid(association_select,2)%>],
    department: [<%=mid(department_select,2)%>],
    facility_rental: [<%=mid(fr_select,2)%>],
    facility: [<%=mid(f_select,2)%>],
    program: [<%=mid(program_select,2)%>]
  }
</script>
