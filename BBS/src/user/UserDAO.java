package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO { //������ �����ͺ��̽��� �����ؼ� �����͸� �ְų� �������� ������ �ϴ� ���������ٰ�ü
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs; //�����͸� ���� ��ü
	
	
	
	
	//������ mysql�� �����ϰ� ���ִ� �κ�
	public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "s2158334";
			Class.forName("com.mysql.jdbc.Driver"); //����̹��� sql�� ������ �� �ְ� ���ִ� ���̺귯��
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	} 
	
	
	//�� ������ ���� �α��� �õ��ϴ� �ڵ�
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?" ; //?�� ���� �κ��� userID�� �Է¹ް���
		try {
			pstmt = conn.prepareStatement(SQL); // pstmt�� ������ SQL������ �����ͺ��̽��� �����ϴ� ������� �ν��Ͻ��� ������
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next() ) {
				if(rs.getString(1).equals(userPassword)) {
					return 1; //�α��� ����
				}
				else
					return 0; //��й�ȣ ����ġ
				
			}
			return -1; //���̵� ����
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; //�����ͺ��̽� ����
	}
	
	
	//ȸ������ ���
	public int join(User user) {
		
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserGender());
			pstmt.setString(4, user.getUserEmail());
			pstmt.setString(5, user.getUserName());
			return pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
	
}












