<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.io.PrintWriter" %> <%--스크립트 문장을 실행할 수 있도록 임포트 --%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css"> <%--따로만든 custom.css파일 참조 --%>
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		//로그인 된 사람들은 로그인 정보를 담을 수 있게 해줌
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID"); //현재 세션에 존재하는 사람이라면 그 아이디를 받아서 관리함
			
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span> 
				</button>
				<a class="navbar-brand" href="main.jsp">JSP 게시판 웹사이트</a>
		</div>
		<div class="collpase navbar-collapse" id="bs-example-navbar-collpase-1">
		
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">메인</a><li> <%-- class="active": 현재 접속한 페이지 --%>
				<li><a href="bbs.jsp">게시판</a><li>
			</ul>
			
			
			<%-- 로그인에 접속하지 않은 경우에만 접속하기 보여주기 (41~58 --%>
			<% 
				if(userID == null) { //로그인이 되어있지 않으면 회원가입을 할 수 있도록함			
			%>
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">접속하기<span class="caret"></span>
							</a>
						
						<ul class="dropdown-menu">
							<li><a href="login.jsp">로그인</a></li>	
							<li><a href="join.jsp">회원가입</a></li>	
				</ul>
			<%			
				} else { //로그인이 되어있는 사람들
			%>
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">회원관리<span class="caret"></span>
							</a>
						
						<ul class="dropdown-menu">
							<li><a href="logoutAction.jsp">로그아웃</a></li>	
								
				</ul>
			<% 
				}
			%>
				
			
		</div>
	</nav>
	<div class="container">
		<div class="jumbotron">
			<div class="container">
				<h1>웹 사이트 소개</h1>
				<p>이 웹사이트는 부트스트랩으로 만든 jsp웹 사이트입니다. 최소한의 간단한 로직만을 이용해서 개발했습니다.</p>
				<p><a class="btn btn-primary btn-pull" href="#" role="button">자세히 알아보기</a></p>
			</div>
		</div>
	</div>
	<div class="contatiner">
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
			<ol class ="carousel=indicators">
				<li data-traget="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-traget="#myCarousel" data-slide-to="1"></li>
				<li data-traget="#myCarousel" data-slide-to="2"></li>
			</ol>
			<div class="carousel-inner">
				<div class="item active">
					<img src="images/슬기1.jpg">
				</div>
				<div class="item">
					<img src="images/슬기2.jpg">
				</div>
				<div class="item">
					<img src="images/슬기3.jpg">
				</div>
			</div>
			<a class="left carousel-control" href="#myCarousel" data-slide="prev">
				<span class="glyphicon glyphicon-chevron-left"></span>
			</a>
			<a class="right carousel-control" href="#myCarousel" data-slide="next">
				<span class="glyphicon glyphicon-chevron-right"></span>
			</a>
			
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>