<script type="text/javascript">

  function myPointChart(ia, ib, ic, id) {

    //alert(ia + ', ' + ib + ', ' + ic + ', ' + id);

    $('#iName').text(ib);
    $('#iTeam').text('(' + ic + ')');

    if (id != "") {
      $('#iPhoto').html('<img src="../' + id.substring(3, id.length) + '" alt>');
    }
    else {
      $('#iPhoto').html('<img src="http://img.sportsdiary.co.kr/sdapp/gnb/profile@3x.png" alt="" />');
    }

    myPointChart_Main(ia);

  }

  function myPointChart_Main(ia) {



    var strJsonUrl = "../Json/record-rank.asp?SDate=" + sub_iSDate + "&EDate=" + sub_iEDate + "&Fnd_KeyWord=" + ia + "&Level=" + sub_ilevelname;

    //alert(strJsonUrl);

    FusionCharts.ready(function () {
      //Creating a new inline theme.
      //You can move this entire code block to a separate file, and load.
      FusionCharts.register('theme', {
        name: 'fire',
        theme: {
          base: {
            chart: {
              paletteColors: '#FF4444, #FFBB33, #99CC00, #33B5E5, #AA66CC',
              baseFontColor: '#36474D',
              baseFont: 'Helvetica Neue,Arial',
              captionFontSize: '14',
              subcaptionFontSize: '14',
              subcaptionFontBold: '0',
              showBorder: '0',
              bgColor: '#ffffff',
              showShadow: '0',
              canvasBgColor: '#ffffff',
              canvasBorderAlpha: '0',
              useplotgradientcolor: '0',
              useRoundEdges: '0',
              showPlotBorder: '0',
              showAlternateHGridColor: '0',
              showAlternateVGridColor: '0',
              toolTipBorderThickness: '0',
              toolTipBgColor: '#99CC00',
              toolTipBgAlpha: '90',
              toolTipBorderRadius: '2',
              toolTipPadding: '5',
              legendBgAlpha: '0',
              legendBorderAlpha: '0',
              legendShadow: '0',
              legendItemFontSize: '14',
              divlineAlpha: '100',
              divlineColor: '#36474D',
              divlineThickness: '1',
              divLineIsDashed: '1',
              divLineDashLen: '1',
              divLineGapLen: '1',
              showHoverEffect: '1',
              valueFontSize: '14',
              showXAxisLine: '1',
              xAxisLineThickness: '1',
              xAxisLineColor: '#36474D'
            }
          },
          mscolumn2d: {
            chart: {
              valueFontColor: '#FFFFFF', //overwrite base value
              valueBgColor: '#000000',
              valueBgAlpha: '30',
              placeValuesInside: '1',
              rotateValues: '0'
            }
          }
        }
      });

      var revenueChart = new FusionCharts({
        type: 'mscolumn2d',
        renderAt: 'chart',
        width: '100%',
        height: '320',
        dataFormat: 'jsonurl',
        dataSource: strJsonUrl
      }).render();
    });

  }

</script>

<!-- S: modal-record-rank -->
<div class="modal fade confirm-modal modal-record-rank" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="myModalLabel">전체 득실점</h4>
			</div>
			<div class="modal-body">
				<!-- S: player-profile -->
				<div class="player-profile">
					<div class="profile-img" id="iPhoto">
						<img src="http://img.sportsdiary.co.kr/sdapp/gnb/profile@3x.png" alt="" />
					</div>
					<h3><span id="iName">최보라</span> <span id="iTeam">(철원고등학교)</span></h3>
				</div>
				<!-- E: player-profile -->
				<!--//
					chart가 들어갑니다. msbar3d. 한판, 절반, 지도의 득점, 실점값
				-->
				<div id="chart"></div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-gray" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<!-- E: modal-record-rank -->
