<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.io.PrintWriter" %> <%--스크립트 문장을 실행할 수 있도록 임포트 --%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
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
				<li><a href="main.jsp">메인</a><li>
				<li class="active"><a href="bbs.jsp">게시판</a><li> <%-- class="active": 현재 접속한 페이지 --%>
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
	
	
	<%--게시판은 하나의 표(테이블)형태이므로 테이블을 만들어줘야함 --%>
	<div class="container">
		<div class="row">
			<form method="post" action="writeAction.jsp"> <%--post는 보내지는 내용이 숨겨지게 하는 것이고 writeAction.jsp로 넘어가게함(글이 등록되도록) --%>
				<table class="table table-striped" style="text-align: center: border: 1px solid #dddddd">
				<%--table-striped는 게시판글의 홀수짝수마다 색이 바뀌게 하는 거고 #dddddd는 회색빛이 돌게 하는 거임 --%>
					<thead> <%--테이블 제목으로 속성을 알려줌 --%>
						<tr> <%--테이블 하나의 행을 말함 --%>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th> 
						<%--colspan=2 : 두개의 열을 사용한다는 뜻 --%>
						</tr>
					</thead>
					<tbody>
						<tr> <%--tr은 한줄씩 띄울 때 --%>
							<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50"></td>  <%--글제목이 50자가 넘어가지않도록 --%>
						</tr>
						<tr>	
							<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"></textarea></td>			
						</tr>
					</tbody>
					
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기"> <%--글쓰기 버튼 --%>
			</form>
		
			
			
				
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>