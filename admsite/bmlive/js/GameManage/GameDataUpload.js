var mx =  mx || {};

////////////명령어////////////
CMD_SELFILESHEET = 1;
CMD_UPLOADFILEDATA = 2;
CMD_SELGAMETITLE = 3;
CMD_SEARCHFILELIST = 4;
CMD_REMOVEFILE = 5;
////////////명령어////////////

////////////Ajax Receive////////////

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  switch(CMD) {
    case CMD_SELFILESHEET:
    {
      if(dataType == "html") {
          $('#divExcelDataList').html(htmldata); 
      }
    }break;
    case CMD_UPLOADFILEDATA:{
      
      jsondata.ROWKEY = Number(jsondata.ROWKEY) + 1;

      if( Number(jsondata.ROWKEY) > Number(mx.TotalCnt - 1)) {
        alert("Insert Complated")
      }
      else {
        //alert("asdsad"+jsondata.GameType)
        if(jsondata.GameType == "B4E57B7A4F9D60AE9C71424182BA33FE") {
          Url ="/Ajax/GameTitleMenu/updateFileDataGroup_frm.asp"
        }
        else {
          Url ="/Ajax/GameTitleMenu/updateFileDataPerson_frm.asp"
        }
        
        $('#tableExcelDataList > tbody:last').append(htmldata)
//        document.getElementById("tbodyExcelDataList").scrollTop = document.getElementById("tbodyExcelDataList").scrollHeight;
        SendPacket(Url, jsondata);
      }
    }break;
    case CMD_SELGAMETITLE : {
      if(dataType == "html") {
        $('#tdGameLevelList').html(htmldata); 
      }

    }break;

    case CMD_SEARCHFILELIST :{
      if(dataType == "html") {
        $('#tbodyExcelFileList').html(htmldata); 
      }

    }break;
    case CMD_REMOVEFILE :{
      if(dataType == "json") {
        if(jsondata.result == "0")
        {
          alert("삭제 성공")
          SearchFileList();
        }
        else
        {
          alert("삭제 실패")

        }

      }


   }break;
    default:
        //alert("데이터 받았다.")
    break;
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////

function SelFileSheet(fileName, GameType){
  Url ="/Ajax/GameTitleMenu/selFileSheet.asp"
  var tStadiumNum = $( "#selStadiums" ).val(); 
  var packet = {};
  packet.CMD = CMD_SELFILESHEET;
  packet.FileName = fileName;
  packet.GameType = GameType;
  SendPacket(Url, packet);
};

function SearchFileList(){
  Url ="/Ajax/GameManage/SearchExcelFileListAjax.asp"
  var packet = {};
  packet.CMD = CMD_SEARCHFILELIST;
  SendPacket(Url, packet);
};

function DownloadExcelPerson(){

};

function DownloadExcelGroup(){


};

function RemoveFile(FileName,GameType){
  if (confirm(FileName+" 파일을 삭제 하시겠습니까?") == true) {
  Url ="/Ajax/GameManage/RemoveExcelFile.asp"
  var packet = {};
  packet.CMD = CMD_REMOVEFILE;
  packet.FileName = FileName;
  packet.GameType = GameType;
  //console.log(packet);
  SendPacket(Url, packet);
  }
};

function updateFile(GameType){

  if (confirm("해당 파일을 저장 하시겠습니까?") == true) {
    //폼객체를 불러와서
    var formData = new FormData($("#form1")[0]);
    //console.log(formData)
    formData.append("GameType",GameType);
    //console.log(formData)

   
    $.ajax({
          url: '/ajax/GameManage/GameDataUploadAjax.asp',
          type: 'POST',
          data: formData,
          async: false,
          cache: false,
          contentType: false,
          processData: false,
          success: function (returndata) {
            if (returndata == "True" )
            {
              SearchFileList()
              alert("업로드 성공");

            }
            else{
              alert("업로드 실패")
            }
          }
      });
  }
};

function UploadData(fileName, GameType){
  
  if(fileName == ""){
    alert("파일의 선택을 눌러주세요");
  }
  else{
    var tIdx= $( "#selGameTitle" ).val(); 
    var tIdxName = $("#selGameTitle option:selected").text();
    var tTotalCnt= $( "#totalRowCnt" ).val(); 
 
    
    var isFileSelected =  confirm("[" + fileName + "]" + " 해당 파일의 데이터를 이 [" + tIdxName + "] 에 넣겠습니까?");

    if(isFileSelected) {
      if (tTotalCnt > 0 )
      {
        $("#tbodyExcelDataList").empty();
        mx.TotalCnt = tTotalCnt;
      
        if(GameType == "B4E57B7A4F9D60AE9C71424182BA33FE") {
          Url ="/Ajax/GameTitleMenu/updateFileDataGroup_frm.asp"
        }
        else {
          Url ="/Ajax/GameTitleMenu/updateFileDataPerson_frm.asp"
        }
        alert(Url)
        var packet = {};
        packet.CMD = CMD_UPLOADFILEDATA;
        packet.tIdx= tIdx;
        packet.ROWKEY= 0;
        packet.tGameTitleName= tIdxName;
        packet.GameType = GameType;
        packet.tTeamGb= "";
        packet.fileName= fileName;
        packet.tTotalCnt= tTotalCnt;
        SendPacket(Url, packet);
        //alert(mx.TotalCnt)
        
      }
      else{
        alert("데이터 Row가 없습니다.");
      
      }
    }
    else {
      alert("취소");
    }
  }
};


////////////Custom Function////////////

$(document).ready(function(){
  init();
}); 

init = function(){
    $(document).ready(function(){
        $('input[type="file"]').change(function(e){
            var fileName = e.target.files[0].name;
            $("#fileName").html(fileName)
        });
    });
};

href_gametitle = function(NowPage){
  post_to_url('./index.asp', { 'i2': NowPage});
}

href_level = function(tIdx){
  post_to_url('./level.asp', { 'tIDX': tIdx});
};

href_stadium = function(tIdx){
  post_to_url('./stadium.asp', { 'tIDX': tIdx});
};