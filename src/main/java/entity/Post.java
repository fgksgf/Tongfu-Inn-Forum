package entity;

import javax.persistence.*;
import java.util.*;

@Entity
@Table(name = "Post")
public class Post {
    private int pid;
    private String title;
    private String content;
    private long date;
    private int score;
    private User user;
    private Set<Label> labels = new HashSet<>();

    public Post() {
        score = 0;
    }

    @Id
    @GeneratedValue
    @Column(name = "pid")
    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    @Basic
    @Column(name = "title")
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
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
    @Column(name = "date")
    public long getDate() {
        return date;
    }

    public void setDate(long date) {
        this.date = date;
    }

    @Basic
    @Column(name = "score")
    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Post post = (Post) o;
        return pid == post.pid;
    }

    @Override
    public int hashCode() {
        return Objects.hash(pid);
    }

    @ManyToMany(fetch = FetchType.EAGER, cascade = {CascadeType.ALL})
    @JoinTable(
        name = "Post_Label",
        joinColumns = {@JoinColumn(name = "Post_pid")},
        inverseJoinColumns = {@JoinColumn(name = "Label_lid")}
    )
    public Set<Label> getLabels() {
        return labels;
    }

    public void setLabels(Set<Label> labels) {
        this.labels = labels;
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
