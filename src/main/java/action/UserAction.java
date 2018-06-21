package action;

import entity.User;
import com.opensymphony.xwork2.ActionSupport;
import dao.UserDao;
import org.apache.struts2.ServletActionContext;
import util.IdenticonUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.*;

public class UserAction extends ActionSupport {
    private int uid;
    private User user;
    private String username;
    private String password;
    private String code;
    private String result;
    private boolean valid;
    private File upload;
    private String uploadContextType;
    private String uploadFileName;
    private static UserDao dao = new UserDao();
    private static final int BUFFER_SIZE = 40 * 40;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public File getUpload() {
        return upload;
    }

    public void setUpload(File upload) {
        this.upload = upload;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getUploadContextType() {
        return uploadContextType;
    }

    public void setUploadContextType(String uploadContextType) {
        this.uploadContextType = uploadContextType;
    }

    public String getUploadFileName() {
        return uploadFileName;
    }

    public void setUploadFileName(String uploadFileName) {
        this.uploadFileName = uploadFileName;
    }

    // 检验用户名是否存在是否可用
    public String hasUser() {
        UserDao dao = new UserDao();
        User u = dao.getUser(username);
        if (u == null) {
            valid = true;
        } else {
            valid = false;
        }
        return SUCCESS;
    }

    // 用户和管理员登录
    public String login() {
        HttpServletRequest request = ServletActionContext.getRequest();
        HttpSession session = request.getSession();

        // 获取正确的验证码
        String realCode = (String) session.getAttribute("SECURITY_CODE");

        if (code.equalsIgnoreCase(realCode)) {
            User u = dao.searchUser(username, password);
            if (u != null) {
                session.setAttribute("user", u);
                result = "login_ok";
            } else {
                session.setAttribute("user", null);
                result = "login_fail";
            }
        } else {
            result = "wrong_code";
        }
        return SUCCESS;
    }

    // 用户注册
    public String register() {
        User u = new User();
        u.setUsername(username);
        u.setPassword(password);
        String path = ServletActionContext.getServletContext().getRealPath("/resources/img/");
        IdenticonUtil.generate(path,username);
        String imgName = IdenticonUtil.MD5(username);
        u.setImgUrl("./resources/img/" + imgName +".png");
        dao.saveUser(u);
        result = "reg_ok";
        return SUCCESS;
    }

    // 退出登录
    public String logout() {
        HttpServletRequest request = ServletActionContext.getRequest();
        HttpSession session = request.getSession();
        session.setAttribute("user", null);
        result = "logout_ok";
        return SUCCESS;
    }

    // 用户中心
    public String userCenter() {
        user = dao.getUser(uid);
        return "jump";
    }

    // 更改密码
    public String changeCode() {
        User u = dao.getUser(uid);
        u.setPassword(password);
        dao.updateUser(u);
        result = "change_ok";
        return SUCCESS;
    }

    // 更改头像
    public String updateAvatar() {
        String path = ServletActionContext.getServletContext().getRealPath("/resources/img/");

        // 获取上传文件的后缀名
        String fileType = uploadFileName.substring(uploadFileName.indexOf("."));
        user = dao.getUser(uid);

        File oldAvatar = new File(user.getImgUrl());
        // 更新头像路径名
        user.setImgUrl("./resources/img/" + user.getUid() + fileType);

        File target = new File(path + user.getUid() + fileType);
        copy(upload, target);

        // 删除上传的头像
        upload.delete();
        // 删除原头像文件
        oldAvatar.delete();
        dao.updateUser(user);
        result = "update_ok";
        return "jump";
    }

    // 封禁、解禁用户
    public String block() {
        User u = dao.getUser(uid);
        if (u.getStatus() == 0) {
            u.setStatus(-1);
        } else if (u.getStatus() == -1) {
            u.setStatus(0);
        }
        dao.updateUser(u);
        result = "block_ok";
        return SUCCESS;
    }

    // 将源文件复制为目标文件
    private static void copy(File source, File target) {
        InputStream inputStream = null;
        OutputStream outputStream = null;

        try {
            inputStream = new BufferedInputStream(new FileInputStream(source), BUFFER_SIZE);
            outputStream = new BufferedOutputStream(new FileOutputStream(target), BUFFER_SIZE);
            byte[] buffer = new byte[BUFFER_SIZE];
            int length = 0;
            while ((length = inputStream.read(buffer)) > 0) {
                // 如果上传的文件字节数大于0,将内容以字节形式写入
                outputStream.write(buffer,0,length);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (outputStream != null) {
                try{
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
