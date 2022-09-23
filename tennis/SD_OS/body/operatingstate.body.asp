    <!-- S: main -->
    <div class="main main-operating container-fluid">
     <h2 id="tourney_title" class="stage-title row"><!--제16회 제주컵 유도대회--></h2>
      <!-- S: input-select -->
      <div class="input-select ent-sel row">
        <!-- S: tab-menu -->
        <div class="enter-type tab-menu">
          <ul class="clearfix">
            <li class="type-sel">
              <select data-native-menu="false" id="StatusGB">
                <option value="s01">진행현황</option>
                <option value="s02">수상현황</option>
              </select>
            </li>
            <li class="btn-list">
              <button type="button" id="search" class="btn btn-warning btn-search" onclick="score.statusSearch(0);">조 회</button>
            </li>
          </ul>
        </div>
        <!-- E: tab-menu -->
      </div>
      <!-- E: input-select -->
    </div>
    <!-- E: main -->


  <!-- S: tourney-main -->
  <span id="statustable"><!-- 불러올내용 --></span>


    <!-- S: Winner  result Modal -->  
  <div class="round-res fade modal" id="round-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true">  </div>
    <!-- E: Winner-1 result Modal -->
