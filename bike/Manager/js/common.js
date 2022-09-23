$(document).ready(function () {
  bindDatetimepicker();
})

var bindDatetimepicker = function () {
  $('.date').datetimepicker({
    format: 'YYYY/MM/DD',
    locale:'KO'
  });

  $('.time').datetimepicker({
    format: 'LT',
    locale:'KO'
  });

  $('._date').datetimepicker({
    format: 'YYYY/MM/DD',
    locale:'KO'
  });

  $('._time').datetimepicker({
    format: 'LT',
    locale:'KO'
  });

}


// 다음 주소 찾기
function execDaumPostCode() {
  var address_layer = document.getElementById('address_layer');
  new daum.Postcode({
    oncomplete: function(data) {
      // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
      // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
      // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
      var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
      var extraRoadAddr = ''; // 도로명 조합형 주소 변수

      // 법정동명이 있을 경우 추가한다.
      if(data.bname !== ''){
          extraRoadAddr += data.bname;
      }
      // 건물명이 있을 경우 추가한다.
      if(data.buildingName !== ''){
          extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
      }
      // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
      if(extraRoadAddr !== ''){
          extraRoadAddr = ' (' + extraRoadAddr + ')';
      }
      // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
      if(fullRoadAddr !== ''){
          fullRoadAddr += extraRoadAddr;
      }

      // 우편번호와 주소 정보를 해당 필드에 넣는다.
      document.getElementById("addressZip").value = data.zonecode;
      document.getElementById("address").value = data.roadAddress;
			document.getElementById("addressDetail").value = "";

      // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
      if(data.autoRoadAddress) {
          //예상되는 도로명 주소에 조합형 주소를 추가한다.
          var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
          //document.getElementById("guide").innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

      } else if(data.autoJibunAddress) {
          var expJibunAddr = data.autoJibunAddress;
          //document.getElementById("guide").innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

      } else {
          //document.getElementById("guide").innerHTML = '';
      }
    },
    onclose: function(state){
      if(state === 'COMPLETE_CLOSE'){
        address_layer.style.display = 'none';
      }
    },
    width : '100%',
    height : '100%',
    maxSuggestItems : 5
  }).embed(address_layer);
  address_layer.style.display = 'block';
}

goPN = function (packet, pageno, url, listId) {
  packet.PN = pageno;
  var data = JSON.stringify(packet);
  $.ajax({
    url: url,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      $("#" + listId).html(retDATA)
    },
    error: function (xhr, status, error) {
    }
  });
};
