package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	
	private Connection conn;
	private ResultSet rs; //데이터를 담을 객체
	
	
	
	//실제로 mysql에 접속하게 해주는 부분
		public BbsDAO() {
			try {
				String dbURL = "jdbc:mysql://localhost:3306/BBS";
				String dbID = "root";
				String dbPassword = "s2158334";
				Class.forName("com.mysql.jdbc.Driver"); //드라이버는 sql에 접속할 수 있게 해주는 라이브러리
				conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
			
		//현재 시간을 가져오는 함수	
		public String getDate() {
			String SQL = "SELECT NOW()";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL문장을을 실행준비단계로 만들어줌
				rs = pstmt.executeQuery(); //실행했을 때 나오는 결과
				if(rs.next()) { //실행결과가 있을 때
					
					return rs.getString(1); //현재 날짜를 리턴함
				}
		
			} catch (Exception e) {
				
				e.printStackTrace();
			}
			return "" ; //데이터베이서 오류나면 빈 텍스트 나오도록
		} 
		
		
		
		//게시글 번호 주는 함수	
		public int getNext() {
			String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; //bbsID가져오기 위함인데 제일 마지막으로 쓰인 글을 위해 내림차순으로
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL문장을을 실행준비단계로 만들어줌
				rs = pstmt.executeQuery(); //실행했을 때 나오는 결과
				if(rs.next()) { //실행결과가 있을 때
							
					return rs.getInt(1) + 1; //+1을 해서 다음 게시글 번호가 들어갈 수 있게 함
				}
				return 1; //첫 번째 게시글인 경우 
				
			} catch (Exception e) {
						
				e.printStackTrace();
				}
			return -1 ; //게시글 번호로써 -1을 내보내 데이터베이스 오류임을 알게 함
			} 
				
				
				
			//하나의 게시물을 게시판에 삽입하는 함수	
			public int write(String bbsTitle, String userID, String bbsContent) {
				
				String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)"; //db에 데이터를 넣어줘야하기에 테이블안에 6개의 인자가 들어가도록 함
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL문장을을 실행준비단계로 만들어줌
					pstmt.setInt(1, getNext()); //다음 쓰일 게시글 번호
					pstmt.setString(2, bbsTitle); //제목
					pstmt.setString(3, userID); //사용자ID
					pstmt.setString(4, getDate()); //날짜
					pstmt.setString(5, bbsContent); //내용
					pstmt.setInt(6, 1); //글을 작성했을 때 보여줘야하므로 1으로 해놓음
					return pstmt.executeUpdate(); //문제 없을 때
				} catch (Exception e) {
					
					e.printStackTrace();
				}
				return -1 ; //문제 있을 때(데이터베이스 오류)			
			} 
			
			
			
			//특정한 리스트를 데이터베이스에서 받아서 반환하게 해줌 (특정 페이지에서 게시글 리스트 보이기)
			public ArrayList<Bbs> getList(int pageNumber) {
				String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
				//위에서 10개까지인 게시글들 가져오기(한 페이지에 게시글 10개인 것)
				ArrayList<Bbs> list = new ArrayList<Bbs>();
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); 
					//SQL문장을을 실행준비단계로 만들어줌
					pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
					/*getNext는 다음에 작성될 글의 번호인데 예를들어 현재 게시글이 5개면 getNext는 6이고  pagerNumer는 게시글이 다섯개니까
					  1페이지가 될것이고 저 식을 계산하면 6이 나옴.따라서 보다 작은 값만 가져오는 것이므로 1부터 5까지 다 나오는 것임 */
					rs = pstmt.executeQuery(); //실행했을 때 나오는 결과
					while (rs.next()) { //실행결과가 있을 때
						Bbs bbs = new Bbs();
						bbs.setBbsID(rs.getInt(1));
						bbs.setBbsTitle(rs.getString(2));
						bbs.setUserID(rs.getString(3));
						bbs.setBbsDate(rs.getString(4));
						bbs.setBbsContent(rs.getString(5));
						bbs.setBbsAvailable(rs.getInt(6));
						list.add(bbs); //위의 결과처럼 나온 게시글 목록을 담아서 list에 인스턴스를 반환함
					}	
				} catch (Exception e) {
					e.printStackTrace();
					}
				return list ; //게시글 출력
			}
			
			
			
			//페이징 처리를 위한 함수
			/*게시글이 5개면 페이지는 1개, 게시글이 20개면 페이지는 2개 이런것을 확인 하기 위함이다.*/
			public boolean nextPage(int pageNumber) {
				String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
				//위에서 10개까지인 게시글들 가져오기(한 페이지에 게시글 10개인 것)
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); 
					//SQL문장을을 실행준비단계로 만들어줌
					pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
					rs = pstmt.executeQuery(); //실행했을 때 나오는 결과
					if(rs.next()) { //실행결과가 있을 때
						return true; //다음페이지로 넘어갈 수 있음
					}	
				} catch (Exception e) {
					e.printStackTrace();
					}
				return false ; 
			}
			
			
			
			
			//하나의 글 내용을 불러오는 함수(특정한 bbsID에 해당하는 글 불러오기)
			public Bbs getBbs(int bbsID) {
				String SQL = "SELECT * FROM BBS WHERE bbsID = ? "; //bbsID가 어떤 특정한 숫자(?)일 때 그 게시글을 가져오도록
				//위에서 10개까지인 게시글들 가져오기(한 페이지에 게시글 10개인 것)
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); 
					//SQL문장을을 실행준비단계로 만들어줌
					pstmt.setInt(1, bbsID);
					rs = pstmt.executeQuery(); //실행했을 때 나오는 결과
					if(rs.next()) { //실행결과가 있을 때
						Bbs bbs = new Bbs(); //6가지 내용을 bbs인스턴스에 넣어서 리턴시킴
						bbs.setBbsID(rs.getInt(1));
						bbs.setBbsTitle(rs.getString(2));
						bbs.setUserID(rs.getString(3));
						bbs.setBbsDate(rs.getString(4));
						bbs.setBbsContent(rs.getString(5));
						bbs.setBbsAvailable(rs.getInt(6));
						return bbs; 
					}	
				} catch (Exception e) {
					e.printStackTrace();
					}
				return null ; 
			}
			
			
			//글 수정하는 함수 
			public int update(int bbsID, String bbsTitle, String bbsContent) {

				String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?"; //특정한 아이디에 해당하는 제목과 내용을 바꾸겠다는 말
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL문장을을 실행준비단계로 만들어줌
					pstmt.setString(1, bbsTitle); //제목
					pstmt.setString(2, bbsContent); //내용
					pstmt.setInt(3, bbsID);
					return pstmt.executeUpdate(); //문제 없을 때
				} catch (Exception e) {
					
					e.printStackTrace();
				}
				return -1 ; //문제 있을 때(데이터베이스 오류)			
				
			}
			
			
			
			//삭제 함수
			public int delete (int bbsID) {
				
				String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?"; //글을 삭제해도 정보가 남도록 available=0으로 함
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL문장을을 실행준비단계로 만들어줌
					pstmt.setInt(1, bbsID); //bbsID값을 0으로 바꾸어 삭제처리를 하게 만듬
					return pstmt.executeUpdate(); //문제 없을 때
				} catch (Exception e) {
					e.printStackTrace();
				}
				return -1 ; //문제 있을 때(데이터베이스 오류)
			}
			
			
}

