package util.identicon.generator;

import java.awt.*;

public interface IBaseGenartor {
    /**
     * 将hash字符串转换为bool二维6*5数组
     *
     * @param hash
     * @return
     */
    boolean[][] getBooleanValueArray(String hash);


    /**
     * 获取图片背景色
     *
     * @return
     */
    Color getBackgroundColor();


    /**
     * 获取图案前景色
     *
     * @return
     */
    Color getForegroundColor();
}
