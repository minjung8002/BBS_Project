<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.io.PrintWriter" %> <%--스크립트 문장을 실행할 수 있도록 임포트 --%>
<%@ page import= "bbs.Bbs"%>
<%@ page import= "bbs.BbsDAO"%>
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
		
		
		//게시판에서 글을 눌렀을 때 해당 게시글로 넘어가게 해줌 (bbsID가 정상적으로 넘어왔다면 view페이지에서 bbsID에 담은다음 처리 하는 것)
		int bbsID = 0;
		if(request.getParameter("bbsID") != null) {  
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID ==0) { //게시글이 존재하지 않은 경우(넘어온 bbsID가 없음))
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert ('유효하지 않은 글입니다.')"); 
			script.println("location.href = 'bbs.jsp'"); //로그인이 안된 사람들은 로그인 페이지로 보냄
			script.println("</script>");
		}
		
		Bbs bbs = new BbsDAO().getBbs(bbsID); //유효한 글이라서(bbsID가 0이 아닐 경우)구체적인 정보를  bbs라는 인스턴스에 담는 것	
		
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
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글보기</th> 
						<%--colspan=3 : 세개의 열을 사용한다는 뜻 --%>
						</tr>
					</thead>
					<tbody>
						<tr> <%--tr은 한줄씩 띄울 때 --%>
							<td style="width:20%;">글제목</td>
							<td colspan="2"><%=bbs.getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></td>
						</tr>
						<tr> 
							<td>작성자</td>
							<td colspan="2"><%=bbs.getUserID() %></td>
						</tr>
						<tr>
							<td>작성일자</td>
							<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분"  %></td>
						</tr>
						<tr> 
							<td>내용</td>
							<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ","&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></td>
							<%--특수문자와 공백들도 보일 수 있도록 치환(.replaceAll) --%>
						</tr>
					</tbody>
				</table>
				
				<a href="bbs.jsp" class="btn btn-primary">목록</a> <%--목록으로 돌아가는 버튼 --%>
				<%
					if(userID != null && userID.equals(bbs.getUserID())){ //해당작성자가 본인이라면 수정과 삭제가 가능하도록
				%>
						<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
						<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
						<%--삭제버튼 클릭시 확인 메시지 띄우기 onclick --%>
				<%	
					}
				%>
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기"> <%--글쓰기 버튼 --%>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>