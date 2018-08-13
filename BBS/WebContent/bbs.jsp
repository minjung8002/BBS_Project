<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.io.PrintWriter" %> <%--스크립트 문장을 실행할 수 있도록 임포트 --%>
<%@ page import ="bbs.BbsDAO" %> 
<%@ page import ="bbs.Bbs" %>
<%@ page import ="java.util.ArrayList" %> <%--게시판 목록을 출력하기 위해 필요함 --%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
<style type="text/css"> <%--bbs.jsp에서만 쓰일 수 있는 스타일 태그임--%>
	a, a:hover{ <%--a태그는 링크가 달린 태그를 의미함--%>
		color: #000000; <%--색깔변경--%>
		text-decoration: none; <%--밑줄 없도록--%>
		}
</style>
</head>
<body>
	<%
		//로그인 된 사람들은 로그인 정보를 담을 수 있게 해줌
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID"); //현재 세션에 존재하는 사람이라면 그 아이디를 받아서 관리함
			
		}
		int pageNumber = 1; //현재 게시판을 알려주기 위한 것. 기본적으로 1페이지이기 때문
		if(request.getParameter("pageNumber") != null) { //파라미터로 페이지넘버가 넘어왔다면 
			pageNumber = Integer.parseInt(request.getParameter("pageNumber")); //페이지넘버에 해당 파라미터 값을 넣어줌(대신 정수형으로 바꿈)
			
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
			<table class="table table-striped" style="text-align: center: border: 1px solid #dddddd">
			<%--table-striped는 게시판글의 홀수짝수마다 색이 바뀌게 하는 거고 #dddddd는 회색빛이 돌게 하는 거임 --%>
				<thead> <%--테이블 제목으로 속성을 알려줌 --%>
					<tr> <%--테이블 하나의 행을 말함 --%>
						<th style="background-color: #eeeeee; text-align: center;">번호</th> 
						<th style="background-color: #eeeeee; text-align: center;">제목</th> 
						<th style="background-color: #eeeeee; text-align: center;">작성자</th> 
						<th style="background-color: #eeeeee; text-align: center;">작성일</th> 
					</tr>
				</thead>
				<tbody>
					<%--게시글이 보여져야 하므로 게시글 뽑아옴 --%>
					<%
						BbsDAO bbsDAO = new BbsDAO(); //인스턴스 생성
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber); //리스트로 보여져야 하므로 어레이리스트 생성
						for(int i = 0; i < list.size(); i++){ //리스트 사이즈
					%>
					<tr> <%--보여질 게시글에 대한 정보(db에서 불러와서 보여주는 것) --%>
						<td><%= list.get(i).getBbsID() %></td>
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></a></td> <%--게시글을 누르면 넘어가야 함(특문,공백 치환 포함) --%>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시" + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
							<%--게시글에 보여질 날짜를 필요한 부분만 잘라서 보여주기 --%>					
					</tr>
					<%			
						}
					%> 
				</tbody>
			</table>
			
			<%
				if(pageNumber != 1) { //페이지넘버가 1이 아니면 2페이지 이상이므로 이전페이지로 넘어갈 수 있는 버튼 생성
			%>
				<a href = "bbs.jsp?pageNumber=<%=pageNumber - 1 %> " class= "btn btn-success btn-arrow-left">이전</a>
			<%							
				}	if(bbsDAO.nextPage(pageNumber + 1)) { //다음페이지가 존재한다면 다음으로 넘어가야 하므로 +1을 함
			%>
				<a href = "bbs.jsp?pageNumber=<%=pageNumber + 1 %> " class= "btn btn-success btn-arrow-left">다음</a>
				
			<%
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a> <%--글쓰는 페이지로 넘어가도록하고 버튼이 오른쪽으로 고정되도록 --%>
				
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>