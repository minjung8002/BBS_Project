package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	
	private Connection conn;
	private ResultSet rs; //�����͸� ���� ��ü
	
	
	
	//������ mysql�� �����ϰ� ���ִ� �κ�
		public BbsDAO() {
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
			
		//���� �ð��� �������� �Լ�	
		public String getDate() {
			String SQL = "SELECT NOW()";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL�������� �����غ�ܰ�� �������
				rs = pstmt.executeQuery(); //�������� �� ������ ���
				if(rs.next()) { //�������� ���� ��
					
					return rs.getString(1); //���� ��¥�� ������
				}
		
			} catch (Exception e) {
				
				e.printStackTrace();
			}
			return "" ; //�����ͺ��̼� �������� �� �ؽ�Ʈ ��������
		} 
		
		
		
		//�Խñ� ��ȣ �ִ� �Լ�	
		public int getNext() {
			String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; //bbsID�������� �����ε� ���� ���������� ���� ���� ���� ������������
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL�������� �����غ�ܰ�� �������
				rs = pstmt.executeQuery(); //�������� �� ������ ���
				if(rs.next()) { //�������� ���� ��
							
					return rs.getInt(1) + 1; //+1�� �ؼ� ���� �Խñ� ��ȣ�� �� �� �ְ� ��
				}
				return 1; //ù ��° �Խñ��� ��� 
				
			} catch (Exception e) {
						
				e.printStackTrace();
				}
			return -1 ; //�Խñ� ��ȣ�ν� -1�� ������ �����ͺ��̽� �������� �˰� ��
			} 
				
				
				
			//�ϳ��� �Խù��� �Խ��ǿ� �����ϴ� �Լ�	
			public int write(String bbsTitle, String userID, String bbsContent) {
				
				String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)"; //db�� �����͸� �־�����ϱ⿡ ���̺�ȿ� 6���� ���ڰ� ������ ��
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL�������� �����غ�ܰ�� �������
					pstmt.setInt(1, getNext()); //���� ���� �Խñ� ��ȣ
					pstmt.setString(2, bbsTitle); //����
					pstmt.setString(3, userID); //�����ID
					pstmt.setString(4, getDate()); //��¥
					pstmt.setString(5, bbsContent); //����
					pstmt.setInt(6, 1); //���� �ۼ����� �� ��������ϹǷ� 1���� �س���
					return pstmt.executeUpdate(); //���� ���� ��
				} catch (Exception e) {
					
					e.printStackTrace();
				}
				return -1 ; //���� ���� ��(�����ͺ��̽� ����)			
			} 
			
			
			
			//Ư���� ����Ʈ�� �����ͺ��̽����� �޾Ƽ� ��ȯ�ϰ� ���� (Ư�� ���������� �Խñ� ����Ʈ ���̱�)
			public ArrayList<Bbs> getList(int pageNumber) {
				String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
				//������ 10�������� �Խñ۵� ��������(�� �������� �Խñ� 10���� ��)
				ArrayList<Bbs> list = new ArrayList<Bbs>();
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); 
					//SQL�������� �����غ�ܰ�� �������
					pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
					/*getNext�� ������ �ۼ��� ���� ��ȣ�ε� ������� ���� �Խñ��� 5���� getNext�� 6�̰�  pagerNumer�� �Խñ��� �ټ����ϱ�
					  1�������� �ɰ��̰� �� ���� ����ϸ� 6�� ����.���� ���� ���� ���� �������� ���̹Ƿ� 1���� 5���� �� ������ ���� */
					rs = pstmt.executeQuery(); //�������� �� ������ ���
					while (rs.next()) { //�������� ���� ��
						Bbs bbs = new Bbs();
						bbs.setBbsID(rs.getInt(1));
						bbs.setBbsTitle(rs.getString(2));
						bbs.setUserID(rs.getString(3));
						bbs.setBbsDate(rs.getString(4));
						bbs.setBbsContent(rs.getString(5));
						bbs.setBbsAvailable(rs.getInt(6));
						list.add(bbs); //���� ���ó�� ���� �Խñ� ����� ��Ƽ� list�� �ν��Ͻ��� ��ȯ��
					}	
				} catch (Exception e) {
					e.printStackTrace();
					}
				return list ; //�Խñ� ���
			}
			
			
			
			//����¡ ó���� ���� �Լ�
			/*�Խñ��� 5���� �������� 1��, �Խñ��� 20���� �������� 2�� �̷����� Ȯ�� �ϱ� �����̴�.*/
			public boolean nextPage(int pageNumber) {
				String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
				//������ 10�������� �Խñ۵� ��������(�� �������� �Խñ� 10���� ��)
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); 
					//SQL�������� �����غ�ܰ�� �������
					pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
					rs = pstmt.executeQuery(); //�������� �� ������ ���
					if(rs.next()) { //�������� ���� ��
						return true; //������������ �Ѿ �� ����
					}	
				} catch (Exception e) {
					e.printStackTrace();
					}
				return false ; 
			}
			
			
			
			
			//�ϳ��� �� ������ �ҷ����� �Լ�(Ư���� bbsID�� �ش��ϴ� �� �ҷ�����)
			public Bbs getBbs(int bbsID) {
				String SQL = "SELECT * FROM BBS WHERE bbsID = ? "; //bbsID�� � Ư���� ����(?)�� �� �� �Խñ��� ����������
				//������ 10�������� �Խñ۵� ��������(�� �������� �Խñ� 10���� ��)
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); 
					//SQL�������� �����غ�ܰ�� �������
					pstmt.setInt(1, bbsID);
					rs = pstmt.executeQuery(); //�������� �� ������ ���
					if(rs.next()) { //�������� ���� ��
						Bbs bbs = new Bbs(); //6���� ������ bbs�ν��Ͻ��� �־ ���Ͻ�Ŵ
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
			
			
			//�� �����ϴ� �Լ� 
			public int update(int bbsID, String bbsTitle, String bbsContent) {

				String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?"; //Ư���� ���̵� �ش��ϴ� ����� ������ �ٲٰڴٴ� ��
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL�������� �����غ�ܰ�� �������
					pstmt.setString(1, bbsTitle); //����
					pstmt.setString(2, bbsContent); //����
					pstmt.setInt(3, bbsID);
					return pstmt.executeUpdate(); //���� ���� ��
				} catch (Exception e) {
					
					e.printStackTrace();
				}
				return -1 ; //���� ���� ��(�����ͺ��̽� ����)			
				
			}
			
			
			
			//���� �Լ�
			public int delete (int bbsID) {
				
				String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?"; //���� �����ص� ������ ������ available=0���� ��
				try {
					PreparedStatement pstmt = conn.prepareStatement(SQL); //SQL�������� �����غ�ܰ�� �������
					pstmt.setInt(1, bbsID); //bbsID���� 0���� �ٲپ� ����ó���� �ϰ� ����
					return pstmt.executeUpdate(); //���� ���� ��
				} catch (Exception e) {
					e.printStackTrace();
				}
				return -1 ; //���� ���� ��(�����ͺ��̽� ����)
			}
			
			
}

