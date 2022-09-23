<!doctype html>
<html>
<head>
  <!-- #include file = "./include/head.asp" -->
  <!-- ==================================== -->
</head>
<body>
<div class="t_default">


  <!-- #include file = "./include/header.asp" -->
  <!-- ====================================== -->
  <!-- #include file = "./include/aside.asp" -->
  <!-- ===================================== -->


  <article>
		<div class="admin_content">

      <!-- ================================================================================================ -->

			<div class="page_title"><h1>대회신청관리</h1></div>

      <!-- ================================================================================================ -->

			<div class="info_serch form-horizontal">
    		<div class="form-group">

    			<div class="col-sm-1">
            <select id="" class="form-control">
              <option value="" selected>개인</option>
              <option value="">단체</option>
            </select>
    			</div>

    			<div class="col-sm-1">
            <select id="" class="form-control">
              <option value="" selected>전체</option>
              <option value="">임급전</option>
              <option value="">입금완료</option>
            </select>
    			</div>

    			<div class="col-sm-1">
            <select id="" class="form-control">
              <option value="" selected>선수명</option>
              <option value="">입금자명</option>
              <option value="">대회명</option>
            </select>
    			</div>

          <div class="col-sm-2">
            <div class="input-group date">
  						<input type="text" class="form-control" placeholder="" id="" value="">
  						<span class="input-group-btn">
  							<a class="btn btn-primary ">검색</a>
  						</span>
  					</div>
    			</div>

          <div class="col-sm-2">
            <span class="btn-group">
              <a class="btn btn-success">엑셀다운로드</a>
              <a class="btn btn-success">리스트화면에출력</a>
            </span>
          </div>
    		</div>
			</div>

      <!-- ================================================================================================ -->
      <hr>

		  <div class="btn-toolbar" role="toolbar" aria-label="btns">
        <a href="#" class="btn btn-link">전체 : 328 건</a>

        <div class="btn-group pull-right">
          <a href="" id="" class="btn btn-primary">버튼</a>
        </div>
			</div>

			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
							<th>번호</th>
							<th>대회명</th>
							<th>부명</th>
							<th>개인/단체</th>
							<th>선수명</th>
							<th>입금자명</th>
              <th>입금금액</th>
              <th>입금상태</th>
              <th>입금상태확인</th>
              <th>신청날짜</th>
						</tr>
					</thead>

					<tbody>
        		<tr>
        			<td><span>2</span></td>
        			<td><span>제1회 양양군수배 스포츠다이어리 랭킹 리그전</span></td>
              <td><span>제외경기 외 1개</span></td>
              <td><span>개인</span></td>
        			<td><span>황석희(남)</span></td>
        			<td><span>황석희</span></td>
        			<td><span>50000</span></td>
              <td>
                <span>
                  <label class="switch" title="참가신청">
                    <input type="checkbox" id="" value="" checked>
                    <span class="slider round"></span>
                  </label>
                </span>
              </td>
              <td><span>2018-07-23</span></td>
              <td><span>2018-07-20</span></td>
        		</tr>
					</tbody>
				</table>
			</div>

			<nav>
				<div class="container-fluid text-center">
          <ul class="pagination">
            <li class="prev"><a href="javascript:alert('첫 페이지 입니다.');">&lt;</a></li>
            <li class="active"><a href="javascript:;">1</a></li>
            <li class="next"><a href="javascript:alert('마지막 페이지 입니다.');">&gt;</a></li>
          </ul>
        </div>
			</nav>

      <!-- ================================================================================================ -->

		</div>
  </article>





</div>
<script src="./js/common.js"></script>
</body>
</html>
