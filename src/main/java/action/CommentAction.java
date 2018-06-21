package action;

import com.opensymphony.xwork2.ActionSupport;
import dao.CommentDao;
import dao.UserDao;
import entity.Comment;
import entity.User;
import util.DateConverter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CommentAction extends ActionSupport {
    private int pid;
    private int uid;
    private int cid;
    private String content;
    private String html;
    private String result;
    private ArrayList<Comment> comments;
    private static UserDao userDao = new UserDao();
    private static CommentDao commentDao = new CommentDao();

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public ArrayList<Comment> getComments() {
        return comments;
    }

    public void setComments(ArrayList<Comment> comments) {
        this.comments = comments;
    }

    public String getHtml() {
        return html;
    }

    public void setHtml(String html) {
        this.html = html;
    }

    public int getCid() {
        return cid;
    }

    public void setCid(int cid) {
        this.cid = cid;
    }

    public String add() {
        Comment c = new Comment();
        User u = userDao.getUser(uid);
        if (u.getStatus() == 0) {
            u.setCredit(u.getCredit() + 1);//评论得1积分
            userDao.updateUser(u);
        }
        c.setUser(u);
        c.setPost_pid(pid);
        c.setContent(content);
        c.setDate(System.currentTimeMillis());
        int cid = commentDao.addComment(c);

        Map<String, String> map = new HashMap<>();
        map.put("item", String.valueOf(commentDao.getCommentSize(pid)));
        map.put("imgUrl", u.getImgUrl());
        map.put("uid", String.valueOf(u.getUid()));
        map.put("username", u.getUsername());
        map.put("credit", String.valueOf(u.getCredit()));
        map.put("date", DateConverter.longToStr(c.getDate()));
        map.put("content", c.getContent());
        map.put("cid", String.valueOf(cid));
        html = renderHTMLStr(map);
        result = "add_ok";
        return SUCCESS;
    }

    public String del() {
        // 删除评论扣2分
        User u = commentDao.getUser(cid);
        if (u.getStatus() == 0) {
            u.setCredit(u.getCredit() - 2);
            userDao.updateUser(u);
        }

        commentDao.delComment(cid);
        result = "del_ok";
        return SUCCESS;
    }

    /**
     * 根据键值对填充模板字符串
     * 如("hello ${name}",{name:"xiaoming"})
     */
    private static String renderHTMLStr(Map<String, String> map) {
        String template = "<div class=\"panel panel-default\" id=\"item-${item}\"><div class=\"panel-body\">" +
                "<div class=\"col-md-2 left\"><div class=\"avatar\"><img alt=\"此处应有头像\" " +
                "style=\"width: 100px;height: 100px;\" src=\"${imgUrl}\" class=\"img-thumbnail\">" +
                "</div><h6 class=\"userinfo\"><a class=\"btn btn-default\" role=\"button\" " +
                "href=\"user!userCenter?uid=${uid}\">${username}<span class=\"badge\">${credit}</span></a></h6>" +
                "<div class=\"floor-msg\"><span class=\"floor-num\">${item}楼</span><br><span class=\"floor-date\">" +
                "${date}</span></div></div><div class=\"col-md-8 right\">${content}</div>" +
                "<div class=\"operation btn-group-vertical\" style=\"float: right\"><button class=\"btn btn-success\"" +
                " onclick=\"scrollToBottom();\">回复</button><button class=\"btn btn-danger\" type=\"button\" " +
                "data-toggle=\"modal\" data-target=\"#delete-confirm\" data-cid=\"${cid}\">删除</button></div></div></div>";

        Set<Map.Entry<String, String>> sets = map.entrySet();
        for (Map.Entry<String, String> entry : sets) {
            String regex = "\\$\\{" + entry.getKey() + "\\}";
            Pattern pattern = Pattern.compile(regex);
            Matcher matcher = pattern.matcher(template);
            template = matcher.replaceAll(entry.getValue());
        }
        return template;
    }
}
