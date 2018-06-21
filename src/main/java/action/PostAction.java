package action;

import com.opensymphony.xwork2.ActionSupport;
import dao.CommentDao;
import dao.PostDao;
import dao.UserDao;
import dao.VoteDao;
import entity.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

public class PostAction extends ActionSupport {
    private int pid;
    private int uid;
    private int score;
    private int status;
    private String title;
    private String content;
    private String result;
    private String labels;
    private Post p;
    private ArrayList<Comment> comments;
    private ArrayList<Post> posts;
    private static VoteDao voteDao = new VoteDao();
    private static PostDao postDao = new PostDao();
    private static UserDao userDao = new UserDao();
    private static CommentDao commentDao = new CommentDao();

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public Post getP() {
        return p;
    }

    public void setP(Post p) {
        this.p = p;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getLabels() {
        return labels;
    }

    public void setLabels(String labels) {
        this.labels = labels;
    }

    public ArrayList<Comment> getComments() {
        return comments;
    }

    public void setComments(ArrayList<Comment> comments) {
        this.comments = comments;
    }

    public ArrayList<Post> getPosts() {
        return posts;
    }

    public void setPosts(ArrayList<Post> posts) {
        this.posts = posts;
    }

    public String add() {
        User u = userDao.getUser(uid);

        String[] s = labels.trim().split(";");
        Set<Label> labelSet = new HashSet<>();
        for (String n : s) {
            Label l = new Label();
            l.setName(n);
            labelSet.add(l);
        }

        Post post = new Post();
        post.setContent(content);

        // 普通用户发帖得3个积分
        if (u.getStatus() == 0) {
            u.setCredit(u.getCredit() + 3);
            userDao.updateUser(u);
        }

        post.setUser(u);
        post.setTitle(title);
        post.setDate(System.currentTimeMillis());
        post.setLabels(labelSet);

        postDao.addPost(post);
        result = "add_ok";
        return SUCCESS;
    }

    public String vote() {
        Post post = postDao.getPost(pid);
        post.setScore(post.getScore() + score);
        postDao.updatePost(post);

        // 帖子被赞楼主加一分;帖子被踩楼主减一分
        User u = post.getUser();
        if (u.getStatus() == 0) {
            u.setCredit(u.getCredit() + score);
            userDao.updateUser(u);
        }

        VoteStatus voteStatus = voteDao.getStatus(uid, pid);
        if (voteStatus == null) {
            voteStatus = new VoteStatus();
            voteStatus.setPostPid(pid);
            voteStatus.setUserUid(uid);
            voteStatus.setStatus(status);
            voteDao.saveStatus(voteStatus);
        } else {
            voteStatus.setStatus(status);
            voteDao.updateStatus(voteStatus);
        }
        result = "vote_ok";
        return SUCCESS;
    }

    public String del() {
        User u = postDao.getPost(pid).getUser();

        // 删帖扣除4分
        if (u.getStatus() == 0) {
            u.setCredit(u.getCredit() - 4);
            userDao.updateUser(u);
        }

        postDao.delPost(pid);
        result = "del_ok";
        return SUCCESS;
    }

    // 跳转到帖子详情页面
    public String jumpTo() {
        p = postDao.getPost(pid);
        comments = commentDao.getByPid(pid);
        return "jump";
    }
}
