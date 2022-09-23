<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Dim imageTitle, titleIdx, ajaxDb
SET ajaxDb = Server.CreateObject("ADODB.Connection")
    ajaxDb.CommandTimeout = 1000
    ajaxDb.Open B_ConStr

' 관리자id
adminId = "jaehongtest"
sitecode = UCase(GLOBAL_HOSTCODE)

' 허용 확장자
imageExt = "jpg,jpeg,png"

upload_path = "E:\www\upload\sportsdiary\"& sitecode &"\"


'업로드를 처리할 오브젝트를 생성합니다.
Set Upload = Server.CreateObject("TABSUpload4.Upload")


'Response.write upload_path
'Response.end

Upload.Start upload_path

Set iFile      = Upload.Form("uploadIMG") '등록파일
mode           = Upload.Form("mode") '
titleIdx       = Upload.Form("titleIdx") ' 대회idx
isUpdateFile   = Upload.Form("isUpdateFile") ' 파일업데이트 여부
contentsTitle  = Upload.Form("contentsTitle") ' 이미지제목
logoYN         = Upload.Form("logoYN") ' 이미지제목
imageIdx       = Upload.Form("imageIdx") ' 이미지제목
PN             = Upload.Form("PN") ' 페이지

' S:업로드하려는 대회와 로그인한 아이디의 host가 일치하는지 확인
SQL = " SELECT HostIdx FROM tblBikeHostCode WHERE HostCode = '"& sitecode &"' "
Set rs = ajaxDb.Execute(SQL)
If Not rs.eof Then
  hostIdx = rs(0)
End If

SQL = " SELECT CONVERT(VARCHAR(4), StartDate, 121) FROM tblBikeTitle WHERE TitleIdx = "& titleIdx &" AND HostIdx = "& hostIdx &""
Set rs = ajaxDb.Execute(SQL)
If Not rs.eof Then
  titleYear = rs(0)
Else
  Response.Write False
  Response.End
End If
' E:업로드하려는 대회와 로그인한 아이디의 host가 일치하는지 확인

' 대회시작일 기준일년도아래 파일저장
If isUpdateFile = "Y" Then
  ' 저장위치 원본/썸네일
  orgin_filepath = upload_path & titleYear &"\Sketch\"& titleIdx &"\Origin\"
  orgin_filepath_db = "/"& titleYear &"/Sketch/"& titleIdx &"/Origin/"
  thumb_filepath = upload_path & titleYear &"\Sketch\"& titleIdx &"\Thumbnail\"
  thumb_filepath_db = "/"& titleYear &"/Sketch/"& titleIdx &"/Thumbnail/"

'Response.write orgin_filepath
'Response.end

sub createfolder(path)
  ' 저장위치에 해당 폴더가 없으면 생성
  Set Fso = Server.CreateObject("Scripting.FileSystemObject")
  If not Fso.FolderExists(path) Then
    Fso.CreateFolder(path)
  End if
End sub

Call createfolder(upload_path & titleYear)
Call createfolder(upload_path & titleYear &"\Sketch\" )
Call createfolder(upload_path & titleYear &"\Sketch\"& titleIdx )
Call createfolder(upload_path & titleYear &"\Sketch\"& titleIdx &"\Origin\" )
Call createfolder(upload_path & titleYear &"\Sketch\"& titleIdx &"\Thumbnail\" )


  ' 저장위치에 해당 폴더가 없으면 생성
'  Set Fso = Server.CreateObject("Scripting.FileSystemObject")
'  If not Fso.FolderExists(orgin_filepath) Then
'    orgin_filepath = Fso.CreateFolder(orgin_filepath)
'  End if
'  If not Fso.FolderExists(thumb_filepath) Then
'    thumb_filepath = Fso.CreateFolder(thumb_filepath)
'  End if

  ' 파일이름 확인
  file_origin_name = fInject(iFile.FileName)
  ext = Split(file_origin_name, ".")(1)
  If InStr(imageExt, ext) = 0 Then
    Response.write "허용되지 않은 확장자입니다."
    Response.End
  End If

  save_file_name = Replace(date, "-", "") & "_" & titleIdx & "_" & file_origin_name

  '업로드된 파일을 디스크에 저장합니다.(Overwrite), option 덮어쓰기(false)
  iFile.SaveAs orgin_filepath & save_file_name, false

  Set savedImage = Server.CreateObject("TABSUpload4.Image")
  savedImage.Load(iFile.SaveName)

  If savedImage.Width > 2560 Then
    savedImage.Resize 2560, 0, ItpModeBicubic
  End If

  savedImage.SaveThumbnail thumb_filepath & "thumb_" & iFile.ShortSaveName, 540, 0, 100

 'http://upload.sportsdiary.co.kr/sportsdiary/Bike01/Watermark/sportsdiary_water_mark_new.png

'  If logoYN = "Y" Then
  Set logoImage = Server.CreateObject("TABSUpload4.Image")
'  LogoImage.Load(upload_path & "Watermark\" & "sportsdiary_water_mark_new.png")       
  LogoImage.Load(upload_path & "Watermark\" & "Photo_sponsor_logo.png")       


  savedImage.DrawImage LogoImage, savedImage.Width-300, savedImage.Height-60, 255
'  savedImage.DrawImage LogoImage, savedImage.Width-savedImage.Width+5, savedImage.Height-savedImage.Height+5, 255
'  savedImage.DrawImage LogoImage, savedImage.Width-150, savedImage.Height-savedImage.Height+5, 255
'  savedImage.DrawImage LogoImage, savedImage.Width-savedImage.Width+5, savedImage.Height-60, 255

 ' End If

  savedImage.Save iFile.SaveName, 100, True
  savedImage.Close
  savedFileName = iFile.ShortSaveName
  savedThumbFileName = "thumb_" & iFile.ShortSaveName

  If mode = "insert" Then
    SQL =       " INSERT INTO tblBikeImage ( TitleIdx , ContentsTitle , OriginFile , Thumbnail, Writer ) "
    SQL = SQL & " VALUES ( "& titleIdx &", '"& contentsTitle &"', '"& orgin_filepath_db & savedFileName &"', '"& thumb_filepath_db & savedThumbFileName &"', '"& adminId &"' ) "
    Call ajaxDb.Execute(SQL)
  ElseIf mode = "update" Then
    SQL =       " UPDATE tblBikeImage SET  "
    SQL = SQL & " ContentsTitle = '"& contentsTitle &"' , OriginFile = '"& orgin_filepath_db & savedFileName &"', Thumbnail = '"& thumb_filepath_db & savedThumbFileName &"'  "
    SQL = SQL & " , Updater = '"& adminId &"', UpdateDate = GETDATE() "
    SQL = SQL & " WHERE ImageIdx = "& imageIdx &" "
    Call ajaxDb.Execute(SQL)
  End If
ElseIf isUpdateFile = "N" Then
  SQL =       " UPDATE tblBikeImage SET  "
  SQL = SQL & " ContentsTitle = '"& contentsTitle &"', Updater = '"& adminId &"', UpdateDate = GETDATE() "
  SQL = SQL & " WHERE ImageIdx = "& imageIdx &" "
  Call ajaxDb.Execute(SQL)
End If


Session("PN") = PN
If PN = "" Or PN = "undefined" Then
	PN = 1
End if
Session("titleIdx") = titleIdx
Server.Execute("/include/landing.asp")



Set ajaxDb = nothing
Set Fso = nothing
Set File = nothing

%>
