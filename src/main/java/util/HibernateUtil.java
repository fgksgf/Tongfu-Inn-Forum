package util;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    private static SessionFactory sessionFactory;
    private static ThreadLocal session = new ThreadLocal();

    static {
        Configuration cfg = new Configuration().configure();
        sessionFactory = cfg.buildSessionFactory();
    }

    public static Session getThreadLocalSession() {
        Session s = (Session) session.get();
        if (s == null) {
            s = sessionFactory.openSession();
            session.set(s);
        }
        return s;
    }

    public static void closeSession() {
        Session s = (Session) session.get();
        if (s != null) {
            s.close();
            session.set(null);
        }
    }
}
