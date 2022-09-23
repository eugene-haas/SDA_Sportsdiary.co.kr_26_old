  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta charset="utf-8">
  <title>슈퍼루키</title>

<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.1/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">

<%If CDbl(ADGRADE) > 500 then%>

  <link href="/pub/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
  <script src="/pub/js/jquery-1.11.1.min.js"></script>
  <script src="/pub/js/jquery-ui.min.js"></script>

  <link href="/pub/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
  <script src="/pub/bootstrap/js/bootstrap.min.js"></script>
  <style>
  [draggable] {
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: none;
    user-select: none;
    /* Required to make elements draggable in old WebKit */
    -khtml-user-drag: element;
    -webkit-user-drag: element;
  }
  </style>
  <link rel="stylesheet" href="/pub/css/RookieTennisAdmin.css<%=CONST_CSVER%>">
  <script src="https://cdn.ckeditor.com/4.8.0/full-all/ckeditor.js"></script>

  <link rel="stylesheet" type="text/css" href="/pub/css/tennis/normalize-4.1.1.css">
  <link rel="stylesheet" type="text/css" href="/pub/css/tennis/RookieStyle.css<%=CONST_CSVER%>">

<%else%>

  <link href="/pub/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
  <script src="/pub/js/jquery-1.11.1.min.js"></script>
  <script src="/pub/js/jquery-ui.min.js"></script>

  <link href="/pub/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
  <script src="/pub/bootstrap/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="/pub/css/RookieTennisAdmin.css<%=CONST_CSVER%>">
  <link rel="stylesheet" type="text/css" href="/pub/css/tennis/normalize-4.1.1.css">
  <link rel="stylesheet" type="text/css" href="/pub/css/tennis/RookieStyle.css<%=CONST_CSVER%>">

</head>
<%End if%>







