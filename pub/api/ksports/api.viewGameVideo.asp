<%

videoID = oJSONoutput.videoId
videoName = oJSONoutput.videoName

%>

<!-- S: modal-header -->
<div class="modal-header">
  <h2><%=videoName%></h2>
  <a href="#" class="btn btn-close" data-dismiss="modal" >x</a>
</div>
<!-- E: modal-header -->

<iframe src="http://www.youtube.com/embed/<%=videoID%>?rel=0&showinfo=0" frameborder="0" gesture="media" allow="encrypted-media"  allowfullscreen width=100% height=500px ></iframe>
