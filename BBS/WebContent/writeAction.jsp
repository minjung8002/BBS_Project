<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %> <%--우리가 만든 클래스를 사용해야해서 불러옴 --%>
<%@ page import="java.io.PrintWriter" %> <%--자바스크립트 문장을 작성하려고 만듬 --%>
<% request.setCharacterEncoding("UTF-8");%> <%--건너오는 데이터를 UTF-8으로 받음 --%>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/> <%--현재 페이지 안에서만 자바빈즈를 사용한다는 것을 알림  --%>
<jsp:setProperty name="bbs" property="bbsTitle"/> 
<jsp:setProperty name="bbs" property="bbsContent"/> <%--게시글 작성을 위한 인스턴스 --%>
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
		} else { //로그인이 되어있을 경우
			if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null) //사용자가 글의 제목이나 내용을 입력하지 않은 경우
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert ('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()"); 
				script.println("</script>");
			} else {		
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent()); //write함수							
				if (result == -1) { //글쓰기 실패했을 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert ('글쓰기에 실패했습니다.')");
					script.println("history.back()"); //이전 페이지로 돌아가기
					script.println("</script>");
				}		
				else { //글쓰기 성공한 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'"); //게시판 메인화면으로 넘어감
					script.println("</script>");
				}	
			}			
		}	
	%> 
	

</body>
</html>