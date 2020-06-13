title: karaf cmd develop
author: Joe Tong
tags:
  - JAVAEE
  - KARAF
categories:
  - IT
date: 2019-07-24 16:42:00
---
Karaf命令行辅助开发

在命令行中，要实现如上常用的help,通过ArgumentParsers，则可以容易实现,参考代码

    package com.zte.sunquan.demo.param;
     
    import java.io.File;
    import java.util.ArrayList;
    import net.sourceforge.argparse4j.ArgumentParsers;
    import net.sourceforge.argparse4j.annotation.Arg;
    import net.sourceforge.argparse4j.inf.ArgumentParser;
    import net.sourceforge.argparse4j.inf.ArgumentParserException;
     
    /**
     * Created by sunquan on 2018/1/10.
     */
    public class ParamTest {
        public static class Params {
     
            @Arg(dest = "type")
            public String type;
     
            @Arg(dest = "num1")
            public String num;
     
            @Arg(dest = "auth")
            public ArrayList&lt;String&gt; auth;
     
            @Arg(dest = "schemas-dir")
            public File schemasDir;
     
            public String getType() {
                return type;
            }
     
            public String getNum() {
                return num;
            }
     
            public ArrayList&lt;String&gt; getAuth() {
                return auth;
            }
     
            public File getSchemasDir() {
                return schemasDir;
            }
        }
     
        public static void main(String[] args) throws ArgumentParserException {
            //指定命令gcs
            final ArgumentParser parser = ArgumentParsers.newArgumentParser("gcs")
                    .defaultHelp(true)
                    .description("alculate checksum of given String.");//描述命令功能
     
            parser.addArgument("-t", "--type")//参数选项,第二个参数默认对应@Arg中dest
                    .type(String.class)//默认值
                    .choices("SHA-256", "SHA-512", "SHA1")//可选项
                    .setDefault("SHA-256")//默认值
                    .help("Specify hash function to use");//选项描述
            parser.addArgument("-c", "--content")
                    .type(String.class)
                    .help("content which need calculate")
                    .dest("num1");//指定对应的@Arg 定义属性
            parser.addArgument("-a", "--auth")
                    .nargs(2)
                    .help("Username and password for HTTP basic authentication in order username password.")
                    .dest("auth");
     
            parser.addArgument("-f", "--schemas-dir")
                    .type(File.class)
                    .help("Directory containing yang schemas to describe simulated devices. Some schemas e.g. netconf monitoring and inet types are included by default")
                    .dest("schemas-dir");
     
            parser.printHelp();//打印help信息
     
            Params params = new Params();//命令包装对象
            try {
                //命令行参数--&gt;自动转包装对象
                parser.parseArgs(new String[]{"-t", "SHA-256",
                        "--content", "sunquan",
                        "-a", "sunquan", "password",
                        "-f", "C:/Users/Administrator/.m2/settings.xml"}, params);//字符串转命令包装对象
            } catch (final ArgumentParserException e) {
                parser.handleError(e);
            }
            System.out.println("type:\t" + params.getType());
            System.out.println("num:\t" + params.getNum());
            System.out.println("userName:\t" + params.getAuth().get(0));
            System.out.println("password:\t" + params.getAuth().get(1));
            if (params.getSchemasDir().exists())
                System.out.println("file:\t" + params.getSchemasDir().getName());
     
        }
    }

再介绍org.apache.karaf.shell.table.ShellTable


        public static void main(String[] args) {
     
            ShellTable table = new ShellTable();
            table.size(40);//设置显示列宽（从最后一列开始计数），不设置
            table.column("name").alignLeft();//设置1列标题靠左
            table.column("age").alignCenter();//设置1列标题居中
            Col gender = new Col("gender");
            gender.alignRight();
            gender.maxSize(10);//设置该列长度，多余字符会被截断，不设置
            table.column(gender);
    //        table.column("gender").alignRight();//设置1列标题靠右
            table.separator(" % ");//设置分隔符
            table.addRow().addContent("sunquan111111111111111111", "291111111111", "boy456789");
            table.addRow().addContent("sunquan", "29", "boy");
            table.addRow().addContent("sunquan", "29", "boy");
    //        table.noHeaders();//不显示头，不设置
            table.print(System.out);
     
            table = new ShellTable();
            table.column("name").alignLeft();//设置1列标题靠左
            table.emptyTableText("null");//表示一个空表，用null替代
            table.print(System.out, true);
     
        }
