<!-- #include virtual ='/tennis/manager/include/top_config.asp' -->
  <title>스포츠다이어리 테니스 관리자</title>
<!-- #include virtual = '/tennis/manager/include/bot_config.asp' -->
</head>
<body>
  <!-- S: header -->
  <!-- #include virtual ='/tennis/manager/include/header.asp' -->
  <!-- E: header -->

  <!-- S: container -->
  <div id="container">
    <!-- S: navi left-navi 네비게이션 -->
    <!-- #include virtual = '/tennis/manager/include/nav.asp' -->
    <!-- E: navi left-navi 네비게이션 -->

    <!-- S: content -->
    <div id="content">
      <!-- S: 네비게이션 -->
      <div class="navigation_box">
        관리자 관리 > 관리자 등록
      </div>
      <!-- E: 네비게이션 -->
      
      <!-- S: form -->
      <form method="post">
        <!-- S: table-list -->
        <table class="table-list Community_wtite_box">
          <caption>어드민 권한</caption>
          <colgroup>
            <col width="20%">
            <col width="80%">
          </colgroup>
          <tbody>
            <tr>
              <th>성명</th>
              <td>
                <input type="text">
              </td>
            </tr>
            <tr>
              <th>아이디</th>
              <td>
                <input type="text">
              </td>
            </tr>
            <tr>
              <th>비밀번호</th>
              <td>
                <input type="password">
              </td>
            </tr>
            <tr>
              <th>어드민 권한</th>
              <td>
                <select>
                  <option value="">어드민</option>
                  <option value="">슈퍼어드민</option>
                </select>
              </td>
            </tr>
          </tbody>
        </table>
        <!-- E: table-list -->
      </form>
      <!-- E: form -->

      <!-- S: btn_list right -->
      <div class="btn_list">
        <input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인">
        <input type="button" id="btnCC" name="btnCC" class="btn_cancel" value="취소">
      </div>
      <!-- E: btn_list right -->
    </div>
    <!-- E: content -->
  </div>
  <!-- E: container -->
</body>
</html>