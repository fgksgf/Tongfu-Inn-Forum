package action;

import com.opensymphony.xwork2.ActionSupport;
import dao.CommentDao;
import dao.PostDao;
import dao.VoteDao;
import entity.Post;
import entity.User;
import entity.VoteStatus;
import org.apache.struts2.ServletActionContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;

public class PageAction extends ActionSupport {
    private int type;
    private ArrayList<Post> posts;
    private ArrayList<Integer> comments;
    private ArrayList<Integer> status;
    private static PostDao postDao = new PostDao();
    private static CommentDao commentDao = new CommentDao();
    private static VoteDao voteDao = new VoteDao();

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public ArrayList<Post> getPosts() {
        return posts;
    }

    public void setPosts(ArrayList<Post> posts) {
        this.posts = posts;
    }

    public ArrayList<Integer> getComments() {
        return comments;
    }

    public void setComments(ArrayList<Integer> comments) {
        this.comments = comments;
    }

    public ArrayList<Integer> getStatus() {
        return status;
    }

    public void setStatus(ArrayList<Integer> status) {
        this.status = status;
    }

    @Override
    public String execute() throws Exception {
        HttpServletRequest request = ServletActionContext.getRequest();
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("user");

        // 获取所有帖子。type = 1, 按帖子得分降序；type = 其他, 按发帖时间降序
        if (type == 0) {
            type = 1;
        }
        posts = postDao.getAll(type);

        comments = new ArrayList<>();
        status = new ArrayList<>();

        for (Post p: posts) {
            // 该列表用来存储对应帖子的评论数目
            comments.add(commentDao.getByPid(p.getPid()).size());
            if (u != null) { // 该列表用来存储已登录用户对应帖子的投票状态
                VoteStatus vs = voteDao.getStatus(u.getUid(), p.getPid());
                if (vs == null) {
                    status.add(0);
                } else {
                    status.add(vs.getStatus());
                }
            }
        }
        return SUCCESS;
    }

}
