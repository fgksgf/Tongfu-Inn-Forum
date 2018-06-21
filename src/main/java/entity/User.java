package entity;

import javax.persistence.*;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "User")
public class User {
    private int uid;
    private String username;
    private String password;
    private String imgUrl;
    private int credit;
    private int status;
    private List<Comment> comments;
    private List<Post> posts;

    public User() {
        imgUrl = "./resources/img/default.png";
        credit = 0;
        status = 0;
    }

    @Id
    @GeneratedValue
    @Column(name = "uid")
    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    @Basic
    @Column(name = "username")
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Basic
    @Column(name = "password")
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Basic
    @Column(name = "imgUrl")
    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    @Basic
    @Column(name = "credit")
    public int getCredit() {
        return credit;
    }

    public void setCredit(int credit) {
        this.credit = credit;
    }

    @Basic
    @Column(name = "status")
    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return uid == user.uid;
    }

    @Override
    public int hashCode() {
        return Objects.hash(uid);
    }

    @OneToMany(mappedBy = "user")
    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> commentsByUid) {
        this.comments = commentsByUid;
    }

    @OneToMany(fetch = FetchType.EAGER, mappedBy = "user")
    public List<Post> getPosts() {
        return posts;
    }

    public void setPosts(List<Post> postsByUid) {
        this.posts = postsByUid;
    }
}
