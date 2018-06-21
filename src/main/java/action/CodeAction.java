package action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import util.CodeUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.ByteArrayInputStream;
import java.util.Map;

public class CodeAction extends ActionSupport {
    //图片流
    private ByteArrayInputStream imageStream;
    private String timestamp;//得到时间戳

    public ByteArrayInputStream getImageStream() {
        return imageStream;
    }

    public void setImageStream(ByteArrayInputStream imageStream) {
        this.imageStream = imageStream;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String get() {
        // 调用工具类生成的验证码和验证码图片
        Map<String, Object> codeMap = CodeUtil.getImageInputStream();
        HttpServletRequest request = ServletActionContext.getRequest();
        HttpSession session = request.getSession();

        // 将正确的验证码放入session中
        session.setAttribute("SECURITY_CODE", codeMap.get("code").toString());
        imageStream = (ByteArrayInputStream) codeMap.get("img");
        return SUCCESS;
    }
}
