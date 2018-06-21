package util;

import org.apache.struts2.util.StrutsTypeConverter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

public class DateConverter extends StrutsTypeConverter {
    //24小时制
    private static final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Override
    public Object convertFromString(Map map, String[] strings, Class aClass) {
        String dateStr = strings[0];
        long ret = 0;
        try {
            ret = df.parse(dateStr).getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return ret;
    }

    @Override
    public String convertToString(Map map, Object o) {
        return df.format(new Date((long) o));
    }

    public static String longToStr(long mill) {
        return df.format(new Date(mill));
    }

    public static void main(String[] args) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String s = "2018-06-01 14:30:00";
        try {
            System.out.println(df.parse(s).getTime());
        } catch (ParseException e) {
            e.printStackTrace();
        }

        long o = 1527834600000l;
        System.out.println(df.format(new Date(o)));
    }
}
