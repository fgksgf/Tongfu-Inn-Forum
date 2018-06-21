package entity;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "Comment")
public class Comment {
    private int cid;
    private long date;
    private String content;
    private User user;
    private int Post_pid;

    @Id
    @GeneratedValue
    @Column(name = "cid")
    public int getCid() {
        return cid;
    }

    public void setCid(int cid) {
        this.cid = cid;
    }

    @Basic
    @Column(name = "date")
    public long getDate() {
        return date;
    }

    public void setDate(long date) {
        this.date = date;
    }

    @Basic
    @Column(name = "content")
    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    @Basic
    @Column(name = "Post_pid")
    public int getPost_pid() {
        return Post_pid;
    }

    public void setPost_pid(int post_pid) {
        Post_pid = post_pid;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Comment comment = (Comment) o;
        return cid == comment.cid;
    }

    @Override
    public int hashCode() {
        return Objects.hash(cid);
    }

    @ManyToOne
    @JoinColumn(name = "User_uid", referencedColumnName = "uid", nullable = false)
    public User getUser() {
        return user;
    }

    public void setUser(User userByUserUid) {
        this.user = userByUserUid;
    }
}
