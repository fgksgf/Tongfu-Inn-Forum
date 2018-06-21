package util;

import com.google.common.base.Charsets;
import com.google.common.hash.Hasher;
import com.google.common.hash.Hashing;
import util.identicon.Identicon;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;


public class IdenticonUtil {
    public static String MD5(String s) {
        Hasher hasher = Hashing.md5().newHasher();
        hasher.putString(s, Charsets.UTF_8);
        return hasher.hash().toString();
    }


    public static void generate(String path, String name) {
        Identicon identicon = new Identicon();
        String md5 = MD5(name);
        BufferedImage image = identicon.create(md5, 100);

        try {
            ImageIO.write(image, "PNG", new File(path + md5 + ".png"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        System.out.println(IdenticonUtil.MD5("掌柜"));
        System.out.println(IdenticonUtil.MD5("zerone"));
        System.out.println(IdenticonUtil.MD5("1"));
        System.out.println(IdenticonUtil.MD5("解放路口就说了分"));
    }
}
