<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %> <%--우리가 만든 클래스를 사용해야해서 불러옴 --%>
<%@ page import="java.io.PrintWriter" %> <%--자바스크립트 문장을 작성하려고 만듬 --%>
<% request.setCharacterEncoding("UTF-8");%> <%--건너오는 데이터를 UTF-8으로 받음 --%>
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
		if (userID == null) { //로그인이 되어야 글을 쓸 수 있음
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
		else { //권한이 있는 사람
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.delete(bbsID);							
				if (result == -1) { //글삭제 실패했을 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert ('글 삭제를 실패했습니다.')");
					script.println("history.back()"); //이전 페이지로 돌아가기
					script.println("</script>");
				}		
				else { //글삭제를 성공한 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'"); //게시판 메인화면으로 넘어감
					script.println("</script>");
				}	
						
		}	
	%> 
	

</body>
</html>