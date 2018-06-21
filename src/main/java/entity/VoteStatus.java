package entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "Vote_Status")
public class VoteStatus {
    private int vid;
    private int userUid;
    private int postPid;
    private int status;


    @Id
    @Column(name = "vid")
    public int getVid() {
        return vid;
    }

    public void setVid(int vid) {
        this.vid = vid;
    }

    @Basic
    @Column(name = "User_uid")
    public int getUserUid() {
        return userUid;
    }

    public void setUserUid(int userUid) {
        this.userUid = userUid;
    }

    @Basic
    @Column(name = "Post_pid")
    public int getPostPid() {
        return postPid;
    }

    public void setPostPid(int postPid) {
        this.postPid = postPid;
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

        VoteStatus that = (VoteStatus) o;

        return vid != that.vid;
    }

    @Override
    public int hashCode() {
        return Objects.hash(vid);
    }

//    @ManyToOne
//    @JoinColumn(name = "User_uid", nullable = false)
//    public User getUser() {
//        return user;
//    }
//
//    public void setUser(User user) {
//        this.user = user;
//    }
}
