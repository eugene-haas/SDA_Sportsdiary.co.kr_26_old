    <div class="main main-check container-fluid">
     <h2 class="stage-title row" id="tourney_title" class="stage-title row"><!-- title --></h2>
      <!-- S: input-select -->
      <div class="input-select ent-sel row">
        <!-- S: tab-menu -->
        <div class="enter-type tab-menu">
          <ul class="clearfix">
            <li class="game-type"  id="_s1menu1">
              <label >
                <span><img src="images/tournerment/tourney/icon-private@3x.png" alt width="18" height="18"></span>
                <label for="game-typeA" class="type-text" >개인전</label>
                <input type="radio" name="game-type" id="game-typeA" value="<%=CONST_CODE_PERSON%>" checked>
              </label>
            </li>
            <li class="game-type"  id="_s1menu2">
              <label >
                <span><img src="images/tournerment/tourney/icon-group@3x.png" alt width="16" height="21"></span>
                <label for="game-typeB" class="type-text" >단체전</label>
                <input type="radio" name="game-type" id="game-typeB" value="<%=CONST_CODE_GROUP%>">
              </label> 
            </li>
            <li class="type-sel">
                <select id="TeamGb"  onchange="SettingSearch();" data-native-menu="false">
                  <option value="<%=CONST_CODE_PERSON_SINGLE%>">단식</option>
                  <option value="<%=CONST_CODE_PERSON_DOUBLE%>">복식</option>
                </select>
            </li>
            <li class="type-sel">
              <select id="SexLevel" data-native-menu="false"></select>
            </li>
            <li class="btn-list">
              <button type="button" id="search" class="btn btn-warning btn-search" onmousedown="score.gameSearch(10)">조 회</button>
            </li>
          </ul>
        </div>
        <!-- E: tab-menu -->
      </div>
      <!-- E: input-select -->
    </div>
    <!-- E: main -->

	
	
	<!-- S: tourney-main -->
	<div class="tourney-main" id="scoregametable"><!-- 대진표 위치 --></div>


    <!-- S: Winner  result Modal -->	
	<div class="round-res fade modal" id="round-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true">	</div>
    <!-- E: Winner-1 result Modal -->










<%If x = "true" then%>

    <!-- S: tourney-main -->
    <div class="tourney-main">
	 

      <!-- S: Winner  result Modal -->
      <div class="round-res fade modal" id="round-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true">

        </div> <!-- modal-dialog -->
      <!-- E: Winner-1 result Modal -->

<%End if%>