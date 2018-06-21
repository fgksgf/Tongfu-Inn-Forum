package dao;

import entity.VoteStatus;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

@SuppressWarnings("Duplicates")
public class VoteDao {
    // 保存投票状态
    public void saveStatus(VoteStatus vs) {
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();
            s.save(vs);
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 更新投票状态
    public void updateStatus(VoteStatus vs) {
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();
            s.update(vs);
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 根据帖子id删除投票状态
    public void delStatusByPid(int pid) {
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();

            String hqlDelete = "delete VoteStatus where postPid = :pid";
            Query query = s.createQuery( hqlDelete );
            query.setParameter("pid",pid);
            query.executeUpdate();
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 根据用户id和帖子id获取投票状态
    public VoteStatus getStatus(int uid, int pid) {
        VoteStatus ret;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            String hql = "from VoteStatus where userUid = :uid and postPid = :pid";
            Query query = s.createQuery(hql);
            query.setParameter("uid", uid);
            query.setParameter("pid", pid);
            query.setMaxResults(1);//最多返回一个结果
            ret = (VoteStatus) query.uniqueResult();

        } finally {
            HibernateUtil.closeSession();
        }
        return ret;
    }
}
