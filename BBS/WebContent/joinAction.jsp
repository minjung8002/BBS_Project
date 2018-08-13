<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %> <%--우리가 만든 클래스를 사용해야해서 불러옴 --%>
<%@ page import="java.io.PrintWriter" %> <%--자바스크립트 문장을 작성하려고 만듬 --%>
<% request.setCharacterEncoding("UTF-8");%> <%--건너오는 데이터를 UTF-8으로 받음 --%>
<jsp:useBean id="user" class="user.User" scope="page"/> <%--현재 페이지 안에서만 자바빈즈를 사용한다는 것을 알림  --%>
<jsp:setProperty name="user" property="userID"/> <%--로그인 페이지에서 넘겨준 userID를 그대로 받아서 한명의 사용자에 userID로 넣어주는 것--%>
<jsp:setProperty name="user" property="userPassword"/>
<jsp:setProperty name="user" property="userGender"/>
<jsp:setProperty name="user" property="userEmail"/>
<jsp:setProperty name="user" property="userName"/>
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
		} 
		/*22~33 이미 로그인이 된 사람은 회원가입 페이지에 접속할수 없도록 함*/
		
	
	
	
		if(user.getUserID() == null || user.getUserPassword() == null || user.getUserGender() == null || user.getUserEmail() == null || user.getUserName() == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert ('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()"); 
			script.println("</script>");
		} else {
			
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user); //변수들을 입력받은 user라는 인스턴스가 join함수를 수행하도록 매개변수로 들어가는 것
			
			if (result == -1) { //동일한 아이디를 입력했을 경우
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert ('이미 존재하는 아이디입니다.')");
				script.println("history.back()"); //이전 페이지로 돌아가기
				script.println("</script>");
			}
			
			
			else { //회원가입이 되었을 때 
				session.setAttribute("userID", user.getUserID()); //회원가입 성공한 사람에게 세션 부여
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'main.jsp'"); //회원가입 되었을 때 바로 로그인해서 main페이지로 넘겨주는 것
				script.println("</script>");
			}
			
			
		}
	
		
		
	%> 
	

</body>
</html>