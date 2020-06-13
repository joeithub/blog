title: crontab another form
author: Joe Tong
tags:
  - LINUX
  - SHELL
  - CRONTAB
categories:
  - IT
date: 2019-07-20 12:26:00
---
@hourly /usr/local/www/awstats/cgi-bin/awstats.sh 
使用 @hourly 对应的是 0 * * * *, 还有下述可以使用:  

复制代码 
string meaning 
—— ——- 
@reboot Run once, at startup. 
@yearly Run once a year, “0 0 1 1 *”. 
@annually (same as @yearly) 
@monthly Run once a month, “0 0 1 * *”. 
@weekly Run once a week, “0 0 * * 0”. 
@daily Run once a day, “0 0 * * *”. 
@midnight (same as @daily) 
@hourly Run once an hour, “0 * * * *”. 

特別是看到 @reboot, 所以写 rc.local 的東西, 也可以使用 @reboot 寫在 crontab 里面。  


1.每分钟定时执行一次规则：
每1分钟执行： */1 * * * *或者* * * * *
每5分钟执行： */5 * * * *

2.每小时定时执行一次规则：
每小时执行： 0 * * * *或者0 */1 * * *
每天上午7点执行：0 7 * * *
每天上午7点10分执行：10 7 * * *

3.每天定时执行一次规则：
每天执行 0 0 * * *

4.每周定时执行一次规则：
每周执行 0 0 * * 0

5.每月定时执行一次规则：
每月执行 0 0 1 * *

6.每年定时执行一次规则：
每年执行 0 0 1 1 *

7.其他例子
5 * * * * 指定每小时的第5分钟执行一次ls命令
30 5 * * * ls 指定每天的 5:30 执行ls命令
30 7 8 * * ls 指定每月8号的7：30分执行ls命令
30 5 8 6 * ls 指定每年的6月8日5：30执行ls命令
30 6 * * 0 ls 指定每星期日的6:30执行ls命令[注：0表示星期天，1表示星期1，以此类推，也可以用英文来表示，sun表示星期天，mon表示星期一等。]
30 3 10,20 * * ls 每月10号及20号的3：30执行ls命令[注：“，”用来连接多个不连续的时段]
25 8-11 * * * ls 每天8-11点的第25分钟执行ls命令[注：“-”用来连接连续的时段]
*/15 * * * * ls 每15分钟执行一次ls命令 [即每个小时的第0 15 30 45 60分钟执行ls命令 ]
30 6 */10 * * ls 每个月中，每隔10天6:30执行一次ls命令[即每月的1、11、21、31日是的6：30执行一次ls命令。 ]

