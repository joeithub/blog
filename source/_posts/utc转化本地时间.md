title: utc转化本地时间
author: Joe Tong
tags:
  - JAVAEE
  - 时间转化
categories:
  - IT
date: 2019-10-31 13:41:00
---
UTC就是世界标准时间，与北京时间相差八个时区（相关文章）。所以只要将UTC时间转化成一定格式的时间，再在此基础上加上8个小时就得到北京时间了。

```
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


/**
 * Created by LiChao on 2017/11/23
 */
public class RegexTest {

    public static void main(String args[]) throws ParseException {

        UTCToCST("2017-11-27T03:16:03.944Z", "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    }

    public static void UTCToCST(String UTCStr, String format) throws ParseException {
        Date date = null;
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        date = sdf.parse(UTCStr);
        System.out.println("UTC时间: " + date);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR, calendar.get(Calendar.HOUR) + 8);
        //calendar.getTime() 返回的是Date类型，也可以使用calendar.getTimeInMillis()获取时间戳
        System.out.println("北京时间: " + calendar.getTime());
    }

}
```


```
/**
     * toString
     * <p>将时间字符串转化成 yyyy-MM-dd HH:mm:ss</>
     * @param dateStr
     * @author: tongq
     * @return
     */
    public static String getPatternTime(String dateStr) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_TIME_PATTERN, Locale.SIMPLIFIED_CHINESE);
        String time = null;
        try {
            LOGGER.info("UTC: "+dateStr);
            Date date = dateFormat.parse(dateStr.replace("T"," ").replace("Z",""));
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.set(Calendar.HOUR, calendar.get(Calendar.HOUR) + 8);
            time = dateFormat.format(calendar.getTime());
            LOGGER.info("local: " + time);
        } catch (ParseException e) {
            LOGGER.error("时间转换出错");
            e.printStackTrace();
        }
        return time;
    }
```