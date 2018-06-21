package util;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.awt.image.RenderedImage;
import java.io.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class CodeUtil {
    private static final int width = 90;// 定义图片的width
    private static final int height = 30;// 定义图片的height
    private static final int codeCount = 4;// 定义图片上显示验证码的个数
    private static final int xx = 15;
    private static final int fontHeight = 22;
    private static final int codeY = 26;
    private static final char[] codeSequence = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'M', 'N',
            'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

    /**
     * 返回一个键值对
     * code: 键为生成的验证码字符串
     * img: 值为生成的验证码BufferedImage对象
     */
    public static Map<String, Object> generateCodeAndPic() {
        // 定义图像buffer
        BufferedImage buffImg = new BufferedImage(width, height,
                BufferedImage.TYPE_INT_RGB);
        Graphics gd = buffImg.getGraphics();
        // 创建一个随机数生成器类
        Random random = new Random();
        // 将图像填充为白色
        gd.setColor(Color.WHITE);
        gd.fillRect(0, 0, width, height);

        // 创建字体，字体的大小应该根据图片的高度来定。
        Font font = new Font("Fixedsys", Font.BOLD, fontHeight);
        // 设置字体。
        gd.setFont(font);

        // 画边框。
        gd.setColor(Color.BLACK);
        gd.drawRect(0, 0, width - 1, height - 1);

        // 随机产生10条干扰线，使图象中的认证码不易被其它程序探测到。
        gd.setColor(Color.BLACK);
        for (int i = 0; i < 10; i++) {
            int x = random.nextInt(width);
            int y = random.nextInt(height);
            int xl = random.nextInt(12);
            int yl = random.nextInt(12);
            gd.drawLine(x, y, x + xl, y + yl);
        }

        // randomCode用于保存随机产生的验证码，以便用户登录后进行验证。
        StringBuffer randomCode = new StringBuffer();
        int red, green, blue;

        // 随机产生codeCount数字的验证码。
        for (int i = 0; i < codeCount; i++) {
            // 得到随机产生的验证码数字。
            String code = String.valueOf(
                    codeSequence[random.nextInt(codeSequence.length)]);
            // 产生随机的颜色分量来构造颜色值，这样输出的每位数字的颜色值都将不同。
            red = random.nextInt(255);
            green = random.nextInt(255);
            blue = random.nextInt(255);

            // 用随机产生的颜色将验证码绘制到图像中。
            gd.setColor(new Color(red, green, blue));
            gd.drawString(code, (i + 1) * xx, codeY);

            // 将产生的四个随机数组合在一起。
            randomCode.append(code);
        }
        Map<String, Object> map = new HashMap<>();
        //存放验证码
        map.put("code", randomCode);
        //存放生成的验证码BufferedImage对象
        map.put("img", buffImg);
        return map;
    }

    /**
     * 返回一个键值对
     * 键为生成的验证码字符串
     * 值为生成的验证码ByteArrayInputStream图片流
     */
    public static Map<String, Object> getImageInputStream(){
        Map<String, Object> codeMap = generateCodeAndPic();
        BufferedImage image = (BufferedImage) codeMap.get("img");
        ByteArrayInputStream inputStream = convertToStream(image);
        codeMap.put("img",inputStream);
        return codeMap;
    }
    /**
     * 将BufferedImage转换成ByteArrayInputStream
     * @param image  图片
     * @return ByteArrayInputStream 流
     */
    private static ByteArrayInputStream convertToStream(BufferedImage image){
        ByteArrayInputStream inputStream = null;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        byte [] bimage;
        try {
            ImageIO.write(image, "jpeg", bos);
            bimage=bos.toByteArray();
            inputStream = new ByteArrayInputStream(bimage);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return inputStream;
    }

    public static void main(String[] args) throws Exception {
        //创建文件输出流对象
        OutputStream out = new FileOutputStream("./img/" + System.currentTimeMillis() + ".jpg");
        Map<String, Object> map = CodeUtil.generateCodeAndPic();
        ImageIO.write((RenderedImage) map.get("codePic"), "jpeg", out);
        System.out.println("验证码的值为：" + map.get("code"));
    }
}
