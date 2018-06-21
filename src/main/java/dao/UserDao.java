package dao;

import entity.User;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

import java.util.ArrayList;

@SuppressWarnings("Duplicates")
public class UserDao {
    // 保存用户信息到数据库
    public void saveUser(User user) {
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            Transaction tx = s.beginTransaction();
            s.save(user);
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 更新数据库中的用户信息
    public void updateUser(User user) {
        Session s;
        Transaction tx;
        try {
            s = HibernateUtil.getThreadLocalSession();
            tx = s.beginTransaction();
            s.update(user);
            tx.commit();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 根据用户名查询用户
    public User getUser(String name) {
        User u;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            String hql = "from User where username = :name";
            Query query = s.createQuery(hql);
            query.setParameter("name", name);
            query.setMaxResults(1);//最多返回一个结果
            u = (User) query.uniqueResult();
        } finally {
            HibernateUtil.closeSession();
        }
        return u;
    }

    // 根据用户id查询用户
    public User getUser(int uid) {
        User u;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            u = s.get(User.class, uid);
        } finally {
            HibernateUtil.closeSession();
        }
        return u;
    }

    // 根据用户名和密码查询用户
    public User searchUser(String name, String pwd) {
        Session s;
        try {
            s = HibernateUtil.getThreadLocalSession();
            String hql = "from User where username = :name and password = :pwd";
            Query query = s.createQuery(hql);
            query.setParameter("name", name);
            query.setParameter("pwd", pwd);
            query.setMaxResults(1);//最多返回一个结果
            return (User) query.uniqueResult();
        } finally {
            HibernateUtil.closeSession();
        }
    }

    // 根据关键字模糊查询用户
    public ArrayList<User> searchUser(String keyword) {
        ArrayList<User> ret;
        try {
            Session s = HibernateUtil.getThreadLocalSession();
            String hql = "from User where username like :keyword and status != 1";
            Query query = s.createQuery(hql);
            query.setParameter("keyword", "%" + keyword + "%");
            ret = (ArrayList<User>) query.list();
        } finally {
            HibernateUtil.closeSession();
        }
        return ret;
    }
}
