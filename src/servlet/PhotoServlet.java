package servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileUploadException;

import com.lizhou.exception.FileFormatException;
import com.lizhou.exception.NullFileException;
import com.lizhou.exception.ProtocolException;
import com.lizhou.exception.SizeException;
import com.lizhou.fileload.FileUpload;
//ͼƬ������

import dao.StudentDao;
import dao.TeacherDao;
import model.Student;
import model.Teacher;

public class PhotoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public PhotoServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String method = request.getParameter("method");
		if("getPhoto".equals(method)){
			getPhoto(request, response);
		}else if("SetPhoto".equals(method)){
			uploadPhoto(request, response);
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	private void uploadPhoto(HttpServletRequest request,HttpServletResponse response){
		//ͼƬ�ϴ�
		int sid = request.getParameter("sid") == null ? 0 : Integer.parseInt(request.getParameter("sid"));
		int tid = request.getParameter("tid") == null ? 0 : Integer.parseInt(request.getParameter("tid"));
		FileUpload fileUpload = new FileUpload(request);
		fileUpload.setFileFormat("jpg");
		fileUpload.setFileFormat("png");
		fileUpload.setFileFormat("jpeg");
		fileUpload.setFileFormat("gif");
		fileUpload.setFileSize(2048);
		response.setCharacterEncoding("UTF-8");
		try {
			InputStream uploadInputStream = fileUpload.getUploadInputStream();
			if(sid !=0){
				Student student = new Student();
				student.setId(sid);
				student.setPhoto(uploadInputStream);
				StudentDao studentDao = new StudentDao();
				if(studentDao.setStudentPhoto(student)){
					response.getWriter().write("<div id='message'>�ϴ��ɹ���</div>");
				}else{
					response.getWriter().write("<div id='message'>�ϴ�ʧ�ܣ�</div>");
				}
			}
			if(tid != 0){
				Teacher teacher = new Teacher();
				teacher.setId(tid);
				teacher.setPhoto(uploadInputStream);
				TeacherDao teacherDao = new TeacherDao();
				if(teacherDao.setTeacherPhoto(teacher)){
					response.getWriter().write("<div id='message'>�ϴ��ɹ���</div>");
				}else{
					response.getWriter().write("<div id='message'>�ϴ�ʧ�ܣ�</div>");
				}
			}
			
		} catch (ProtocolException e) {
			try {
				response.getWriter().write("<div id='message'>�ϴ�Э�����</div>");
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} catch (NullFileException e) {
			try {
				response.getWriter().write("<div id='message'>�ϴ����ļ�Ϊ��!</div>");
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} catch (SizeException e) {
			try {
				response.getWriter().write("<div id='message'>�ϴ��ļ���С���ܳ���"+fileUpload.getFileSize()+"��</div>");
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} catch (FileFormatException e) {
			try {
				response.getWriter().write("<div id='message'>�ϴ��ļ���ʽ����ȷ�����ϴ� "+fileUpload.getFileFormat()+" ��ʽ���ļ���</div>");
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} catch (IOException e) {
			try {
				response.getWriter().write("<div id='message'>��ȡ�ļ�����</div>");
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		} catch (FileUploadException e) {
			try {
				response.getWriter().write("<div id='message'>�ϴ��ļ�ʧ�ܣ�</div>");
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
	}

	private void getPhoto(HttpServletRequest request,HttpServletResponse response) {
		// TODO Auto-generated method stub
		//File file = new File();
		int sid = request.getParameter("sid") == null ? 0 : Integer.parseInt(request.getParameter("sid"));
		int tid = request.getParameter("tid") == null ? 0 : Integer.parseInt(request.getParameter("tid"));
		if(sid != 0){
			//ѧ��
			StudentDao studentDao = new StudentDao();
			Student student = studentDao.getStudent(sid);
			studentDao.closeCon();
			if(student != null){
				InputStream photo = student.getPhoto();
				if(photo != null){
					try {
						byte[] b = new byte[photo.available()];
						photo.read(b);
						response.getOutputStream().write(b,0,b.length);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					return;
				}
			}
		}
		if(tid != 0){
			//��ʦ
			TeacherDao teacherDao = new TeacherDao();
			Teacher teacher = teacherDao.getTeacher(tid);
			teacherDao.closeCon();
			if(teacher != null){
				InputStream photo = teacher.getPhoto();
				if(photo != null){
					try {
						byte[] b = new byte[photo.available()];
						photo.read(b);
						response.getOutputStream().write(b,0,b.length);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					return;
				}
			}
		}
		String path = request.getSession().getServletContext().getRealPath("");
		File file = new File(path+"\\file\\logo.jpg");
		try {
			FileInputStream fis = new FileInputStream(file);
			byte[] b = new byte[fis.available()];
			fis.read(b);
			response.getOutputStream().write(b,0,b.length);
			fis.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
