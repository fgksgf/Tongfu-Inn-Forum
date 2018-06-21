package dao;

import entity.Comment;
import entity.Post;
import entity.User;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

import java.util.ArrayList;

@SuppressWarnings("Duplicates")
public class CommentDao {
    // 增加评论
    public int addComment(Comment c) {
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();
            s.save(c);
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
        return c.getCid();
    }

    // 删除指定帖子的所有评论
    public void delAllComments(int pid) {
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();

            String hqlDelete = "delete Comment c where c.post_pid = :pid";
            Query query = s.createQuery( hqlDelete );
            query.setParameter("pid",pid);
            query.executeUpdate();
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 删除指定评论
    public void delComment(int cid) {
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();

            Comment c = s.get(Comment.class, cid);
            s.delete(c);
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 根据评论编号获取评论人
    public User getUser(int cid) {
        User ret;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Comment c = s.get(Comment.class, cid);
            ret = c.getUser();
        } finally {
            HibernateUtil.closeSession();
        }
        return ret;
    }

    // 获取指定帖子的所有评论
    public ArrayList<Comment> getByPid(int pid) {
        ArrayList<Comment> ret = null;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            String hql = "from Comment where post_pid = :pid order by date asc";
            Query query = s.createQuery(hql);
            query.setParameter("pid", pid);
            ret = (ArrayList<Comment>) query.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession();
        }
        return ret;
    }

    // 获取指定帖子的评论数目
    public long getCommentSize(int pid) {
        long ret = 0;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            String hql = "SELECT count(*) from Comment where post_pid = :pid";
            Query query = s.createQuery(hql);
            query.setParameter("pid", pid);
            query.setMaxResults(1);//最多返回一个结果
            ret = (long) query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.closeSession();
        }
        return ret;
    }
}
