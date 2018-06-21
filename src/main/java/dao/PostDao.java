package dao;

import entity.Post;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

import java.util.ArrayList;

@SuppressWarnings("Duplicates")
public class PostDao {
    // 增加帖子
    public void addPost(Post p) {
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();
            s.save(p);
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 更新帖子
    public void updatePost(Post p) {
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();
            s.update(p);
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 删除帖子
    public void delPost(int pid) {
        try {
            // 删除帖子下的所有评论
            new CommentDao().delAllComments(pid);
            // 删除帖子的投票状态
            new VoteDao().delStatusByPid(pid);
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();

            Post p = s.get(Post.class, pid);
            s.delete(p);
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 获取所有帖子，type=1按帖子得分降序，type=2按发表时间降序
    public ArrayList<Post> getAll(int type) {
        ArrayList<Post> ret;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            String hql;
            if (type == 1) {
                hql = "from Post order by score desc ";
            }
            else {
                hql = "from Post order by date desc ";
            }
            Query query = s.createQuery(hql);
            ret = (ArrayList<Post>) query.list();
        } finally {
            HibernateUtil.closeSession();
        }
        return ret;
    }

    // 根据帖子id获取帖子
    public Post getPost(int pid) {
        Post p;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            p = s.get(Post.class, pid);
        } finally {
            HibernateUtil.closeSession();
        }
        return p;
    }

    // 根据关键词搜索帖子
    public ArrayList<Post> searchByKeyWord(String key) {
        ArrayList<Post> ret;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            String hql = "from Post where title like :key or content like :key";
            Query query = s.createQuery(hql);
            query.setParameter("key","%" + key + "%");
            ret = (ArrayList<Post>) query.list();
        } finally {
            HibernateUtil.closeSession();
        }
        return ret;
    }
}
