package action;

import com.opensymphony.xwork2.ActionSupport;
import dao.PostDao;
import dao.UserDao;
import entity.Post;
import entity.User;

import java.util.ArrayList;

public class SearchAction extends ActionSupport {
    private String keyword;
    private ArrayList<Post> posts;
    private ArrayList<User> users;

    private static PostDao postDao = new PostDao();
    private static UserDao userDao = new UserDao();

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public ArrayList<Post> getPosts() {
        return posts;
    }

    public void setPosts(ArrayList<Post> posts) {
        this.posts = posts;
    }

    public ArrayList<User> getUsers() {
        return users;
    }

    public void setUsers(ArrayList<User> users) {
        this.users = users;
    }

    @Override
    public String execute() throws Exception {
        posts = postDao.searchByKeyWord(keyword);
        users = userDao.searchUser(keyword);
        return SUCCESS;
    }
}
