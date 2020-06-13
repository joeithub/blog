title: 查询数据库转map
author: Joe Tong
tags:
  - JAVAEE
  - MYSQL
categories:
  - IT
date: 2019-09-05 19:33:00
---
```
import java.sql.Connection;  
import java.sql.DriverManager;  
import java.sql.ResultSet;  
import java.sql.ResultSetMetaData;  
import java.sql.SQLException;  
import java.sql.Statement;  
import java.util.ArrayList;  
import java.util.HashMap;  
  
public class DBHelper {  
    public static void main(String[] args) throws ClassNotFoundException,  
            SQLException {  
        Class.forName("oracle.jdbc.driver.OracleDriver");  
        String url = "jdbc:oracle:thin:@localhost:1521:orcl";  
        String user = "ssmy";  
        String password = "ssmy";  
        Connection conn = DriverManager.getConnection(url, user, password);  
        Statement stmt = conn.createStatement();  
        /*//造数据 
         * for(char letter='a';letter&lt;='z';letter++){ int id = letter-97; String 
         * name = ""; String sex = (id&amp;1)!=0?"男":"女"; String state = "Y"; 
         *  
         * String sql = 
         * "insert into person (id,name, sex,state) values("+id+","+ 
         * name+","+sex+","+state+")"; ps.execute(sql); } 
         */  
        ResultSet rs = stmt.executeQuery("select t.* from SSMY_SYS_USER t");  
        ResultSetMetaData data = rs.getMetaData();  
  
        ArrayList&lt;HashMap&lt;String, String&gt;&gt; al = new ArrayList&lt;HashMap&lt;String, String&gt;&gt;();  
  
        while (rs.next()) {  
            HashMap&lt;String, String&gt; map = new HashMap&lt;String, String&gt;();  
            for (int i = 1; i &lt;= data.getColumnCount(); i++) {// 数据库里从 1 开始  
  
                String c = data.getColumnName(i);  
                String v = rs.getString(c);  
                System.out.println(c + ":" + v + "\t");  
                map.put(c, v);  
            }  
            System.out.println("======================");  
            al.add(map);  
        }  
        System.out.println(al);  
        rs.close();  
        stmt.close();  
        conn.close();  
          
    }  
}  


```







