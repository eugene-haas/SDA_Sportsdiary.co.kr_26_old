





<label for="FileSize">10MB file Size Limit</lebel>
<input id="InputFileSize" name="InputFileSize" type="file" onchange="CheckFiles_Size('InputFileSize')"/>

<br/>

<br/>

<label for="ImageFileFormat">Image file Format Limit</lebel>
<input  type="file" id="InputImageFileFormat" name="iFile" onchange="Checkfiles_Img('InputImageFileFormat');"/>

<br/>

<br/>

<label for="PDFFileFormat">PDF file Format Limit</lebel>
<input type="file" ID="InputPDFFile" name="iFile"  onchange="Checkfiles_Pdf('InputPDFFile');"/>

<script type="text/javascript">
function Checkfiles_Img(fileID) {
		var fup = document.getElementById(fileID);
		var fileName = fup.value;
		var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
		if (ext == "gif" || ext == "GIF" ||
         ext == "JPEG" || ext == "jpeg" || 
          ext == "jpg" ||ext == "JPG" || 
            ext == "png" || ext == "PNG" || ext == "") {
			return true;
		} else {
			alert("Only Image");
			fup.value = "";
			fup.focus();
			return false;
		}
	}

	function Checkfiles_Pdf(fileID) {
		var fup = document.getElementById("InputPDFFile");
		var fileName = fup.value;
		var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
		if (ext == "pdf" || ext == "PDF" || ext == "") {
			return true;
		} else {
			alert("Need a PDF");
			fup.value = "";
			fup.focus();
			return false;
		}
	}
  
  function CheckFiles_Size(fileID)
  {
		var size= 2097152; //2MB
		var FileControl = document.getElementById(fileID)
		var oFile = FileControl.files[0];
		if(oFile.size >= size){
    alert('2MB 이상 업로드 할 수 없습니다.');
		FileControl.value = "";
    return false;
		}
  }
</script>