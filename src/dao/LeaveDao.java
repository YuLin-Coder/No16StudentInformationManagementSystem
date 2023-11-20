package dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Leave;
import model.Page;

//����б����ݲ���
public class LeaveDao extends BaseDao {

	//��������Ϣ
	public boolean addLeave(Leave leave){
		String sql = "insert into s_leave values(null,"+leave.getStudentId()+",'"+leave.getInfo()+"',"+Leave.LEAVE_STATUS_WAIT+",'"+leave.getRemark()+"')";
		return update(sql);
	}
	//�༭��ٲ˵�
	public boolean editLeave(Leave leave){
		String sql = "update s_leave set student_id = "+leave.getStudentId()+", info = '"+leave.getInfo()+"',status = "+leave.getStatus()+",remark = '"+leave.getRemark()+"' where id = " + leave.getId();
		return update(sql);
	}
	//ɾ�������Ϣ
	public boolean deleteLeave(int id){
		String sql ="delete from s_leave where id = "+id;
		return update(sql);
	}
	//��ȡ��ҳ��ٵ���Ϣ�б�
	public List<Leave> getLeaveList(Leave leave,Page page){
		List<Leave> ret = new ArrayList<Leave>();
		String sql = "select * from s_leave ";
		if(leave.getStudentId() != 0){
			sql += " and student_id = " + leave.getStudentId() + "";
		}
		sql += " limit " + page.getStart() + "," + page.getPageSize();
		ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		try {
			while(resultSet.next()){
				Leave l = new Leave();
				l.setId(resultSet.getInt("id"));
				l.setStudentId(resultSet.getInt("student_id"));
				l.setInfo(resultSet.getString("info"));
				l.setStatus(resultSet.getInt("status"));
				l.setRemark(resultSet.getString("remark"));
				ret.add(l);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ret;
	}
	//��ȡ�ܼ�¼��
	public int getLeaveListTotal(Leave leave){
		int total = 0;
		String sql = "select count(*)as total from s_leave ";
		if(leave.getStudentId() != 0){
			sql += " and student_id = " + leave.getStudentId() + "";
		}
		ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		try {
			while(resultSet.next()){
				total = resultSet.getInt("total");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return total;
	}
	//�鿴�Ƿ����ͨ��
	public  boolean getStatus(int id){
		String sql = "select status from s_leave where id ="+id;
		int status = 0;
		ResultSet resultSet = query(sql);
		try {
			while(resultSet.next())
			{
				status =  resultSet.getInt("status");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(status >0)
		{
			return true;
		}
		return false;
		
	}
}
