package model;

//�γ�ʵ���
public class Course {
	
	private int id;
	private String name;
	private int teacherId;
	private String courseDate;
	private int selectedNum = 0;//��ѡ����
	private int maxNum = 200;//�γ����ѡ������
	private String info;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getTeacherId() {
		return teacherId;
	}
	public void setTeacherId(int teacherId) {
		this.teacherId = teacherId;
	}
	public String getCourseDate() {
		return courseDate;
	}
	public void setCourseDate(String courseDate) {
		this.courseDate = courseDate;
	}
	public int getSelectedNum() {
		return selectedNum;
	}
	public void setSelectedNum(int selectedNum) {
		this.selectedNum = selectedNum;
	}
	public int getMaxNum() {
		return maxNum;
	}
	public void setMaxNum(int maxNum) {
		this.maxNum = maxNum;
	}
	public String getInfo() {
		return info;
	}
	public void setInfo(String info) {
		this.info = info;
	}
	
}
