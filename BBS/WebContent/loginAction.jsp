<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %> <%--우리가 만든 클래스를 사용해야해서 불러옴 --%>
<%@ page import="java.io.PrintWriter" %> <%--자바스크립트 문장을 작성하려고 만듬 --%>
<% request.setCharacterEncoding("UTF-8");%> <%--건너오는 데이터를 UTF-8으로 받음 --%>
<jsp:useBean id="user" class="user.User" scope="page"/> <%--현재 페이지 안에서만 자바빈즈를 사용한다는 것을 알림  --%>
<jsp:setProperty name="user" property="userID"/> <%--로그인 페이지에서 넘겨준 userID를 그대로 받아서 한명의 사용자에 userID로 넣어주는 것--%>
<jsp:setProperty name="user" property="userPassword"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<% 
		
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");//세션확인후 userID로 세션이 존재하는 회원들은 userID에 세션값을 넣어주게됨	
		} 
		if (userID != null) {
			
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert ('이미 로그인이 되어있습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}  /*18~29이미 로그인이 된 사람은 로그인을 할 수 없도록 막음*/
		
		
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		
		
		if (result == 1) { //로그인 성공시
			
			session.setAttribute("userID", user.getUserID()); //회원의 아이디를 세션아이디를 부여해줌.
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		
		
		else if (result == 0) { //로그인 실패시
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert ('비밀번호가 틀립니다.')");
			script.println("history.back()"); //비밀번호가 틀렸을 때 로그인페이지로 다시 돌아가게 하는 것
			script.println("</script>");
		}
		else if (result == -1) { //아이디가 존재하지 않을 때
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert ('존재하지 않는 아이디입니다.')");
			script.println("history.back()"); 
			script.println("</script>");
		}
		else if (result == -2) { 
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert ('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()"); 
			script.println("</script>");
		}
		
	%> 
	

</body>
</html>