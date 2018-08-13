<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.io.PrintWriter" %> <%--스크립트 문장을 실행할 수 있도록 임포트 --%>
<%@ page import ="bbs.Bbs" %>
<%@ page import ="bbs.BbsDAO" %>
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
		if(userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert ('로그인을 하세요.')"); 
			script.println("location.href = 'login.jsp'"); //로그인이 안된 사람들은 로그인 페이지로 보냄
			script.println("</script>");
		}
		int bbsID = 0;
		if(request.getParameter("bbsID") != null) {  
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID ==0) { //작성자와 세션에있는 사람이 같지 않은 경우))
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert ('유효하지 않은 글입니다.')"); 
			script.println("location.href = 'bbs.jsp'"); //로그인이 안된 사람들은 로그인 페이지로 보냄
			script.println("</script>");
		}
		
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		if(!userID.equals(bbs.getUserID())) { //글을 작성한 사람과 세션에 있는 사람을 비교해서 id값이 동일하다면 문제가 없음
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert ('권한이 없습니다.')"); 
			script.println("location.href = 'bbs.jsp'"); //로그인이 안된 사람들은 로그인 페이지로 보냄
			script.println("</script>");
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
			
			
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">회원관리<span class="caret"></span>
							</a>
						
						<ul class="dropdown-menu">
							<li><a href="logoutAction.jsp">로그아웃</a></li>	
								
				</ul>
			
			
		</div>
	</nav>
	
	
	<%--게시판은 하나의 표(테이블)형태이므로 테이블을 만들어줘야함 --%>
	<div class="container">
		<div class="row">
			<form method="post" action="updateAction.jsp?bbsID=<%= bbsID %>"> <%--updateAction.jsp로 넘어가고 bbsID도 넘겨줌 --%>
				<table class="table table-striped" style="text-align: center: border: 1px solid #dddddd">
				<%--table-striped는 게시판글의 홀수짝수마다 색이 바뀌게 하는 거고 #dddddd는 회색빛이 돌게 하는 거임 --%>
					<thead> <%--테이블 제목으로 속성을 알려줌 --%>
						<tr> <%--테이블 하나의 행을 말함 --%>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th> 
						<%--colspan=2 : 두개의 열을 사용한다는 뜻 --%>
						</tr>
					</thead>
					<tbody>
						<tr> <%--tr은 한줄씩 띄울 때 --%>
							<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle() %>"></td>
						</tr>
						<tr>	
							<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"><%= bbs.getBbsContent() %></textarea></td>			
						</tr>
					</tbody>
					
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="글 수정"> <%--글 수정 버튼 --%>
			</form>
		
			
			
				
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>