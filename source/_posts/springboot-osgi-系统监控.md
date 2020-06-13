title: springboot osgi 系统监控
author: Joe Tong
tags:
  - JAVAEE
  - OSGI
categories:
  - IT
date: 2019-07-24 16:54:00
---
Springboot 集成osgi 实现本机性能监控


&lt;!-- 获取系统信息 --&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;com.github.oshi&lt;/groupId&gt;
			&lt;artifactId&gt;oshi-core&lt;/artifactId&gt;
			&lt;version&gt;3.9.1&lt;/version&gt;
		&lt;/dependency&gt;
 
		&lt;dependency&gt;
			&lt;groupId&gt;net.java.dev.jna&lt;/groupId&gt;
			&lt;artifactId&gt;jna&lt;/artifactId&gt;
		&lt;/dependency&gt;
 
		&lt;dependency&gt;
			&lt;groupId&gt;net.java.dev.jna&lt;/groupId&gt;
			&lt;artifactId&gt;jna-platform&lt;/artifactId&gt;
		&lt;/dependency&gt;
第二步：CPU、内存、虚拟机、系统、系统文件属性基础封装
```
package com.zzg.monit.domain.server;
 
import com.zzg.util.Arith;
 
import lombok.Getter;
import lombok.Setter;
 
public class Cpu {
	/**
     * 核心数
     */
	@Getter
	@Setter
    private int cpuNum;
 
    /**
     * CPU总的使用率
     */
	@Setter
    private double total;
 
    /**
     * CPU系统使用率
     */
	@Setter
    private double sys;
 
    /**
     * CPU用户使用率
     */
	@Setter
    private double used;
 
    /**
     * CPU当前等待率
     */
	@Setter
    private double wait;
 
    /**
     * CPU当前空闲率
     */
	@Setter
    private double free;
 
 
    public double getTotal() {
        return Arith.round(Arith.mul(total, 100), 2);
    }
 
    public double getSys() {
        return Arith.round(Arith.mul(sys / total, 100), 2);
    }
    
    public double getUsed() {
        return Arith.round(Arith.mul(used / total, 100), 2);
    }
 
    public double getWait() {
        return Arith.round(Arith.mul(wait / total, 100), 2);
    }
 
    public double getFree() {
        return Arith.round(Arith.mul(free / total, 100), 2);
    }
}
```
```
package com.zzg.monit.domain.server;
 
import java.lang.management.ManagementFactory;
 
import com.zzg.util.Arith;
import com.zzg.util.DateUtils;
 
import lombok.Getter;
import lombok.Setter;
 
 
/**
 * 虚拟机相关设置
 * @author zzg
 *
 */
public class Jvm {
	/**
     * 当前JVM占用的内存总数(M)
     */
	@Setter
    private double total;
 
    /**
     * JVM最大可用内存总数(M)
     */
	@Setter
    private double max;
 
    /**
     * JVM空闲内存(M)
     */
	@Setter
    private double free;
 
    /**
     * JDK版本
     */
	@Getter
	@Setter
    private String version;
 
    /**
     * JDK路径
     */
	@Getter
	@Setter
    private String home;
 
    public double getTotal() {
        return Arith.div(total, (1024 * 1024), 2);
    }
 
    public double getMax() {
        return Arith.div(max, (1024 * 1024), 2);
    }
 
    public double getFree() {
        return Arith.div(free, (1024 * 1024), 2);
    }
 
    public double getUsed() {
        return Arith.div(total - free, (1024 * 1024), 2);
    }
 
    public double getUsage() {
        return Arith.mul(Arith.div(total - free, total, 4), 100);
    }
 
    /**
     * 获取JDK名称
     */
    public String getName() {
        return ManagementFactory.getRuntimeMXBean().getVmName();
    }
 
    /**
     * JDK启动时间
     */
    public String getStartTime() {
        return DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD_HH_MM_SS, DateUtils.getServerStartDate());
    }
 
    /**
     * JDK运行时间
     */
    public String getRunTime() {
        return DateUtils.getDatePoor(DateUtils.getNowDate(), DateUtils.getServerStartDate());
    }
}
```
```
package com.zzg.monit.domain.server;
 
import com.zzg.util.Arith;
 
import lombok.Setter;
 
/**
 * 内存相关信息
 * @author zzg
 *
 */
public class Mem {
	/**
     * 内存总量
     */
	@Setter
    private double total;
 
    /**
     * 已用内存
     */
	@Setter
    private double used;
 
    /**
     * 剩余内存
     */
	@Setter
    private double free;
 
    public double getTotal() {
        return Arith.div(total, (1024 * 1024 * 1024), 2);
    }
 
    public double getUsed() {
        return Arith.div(used, (1024 * 1024 * 1024), 2);
    }
 
    public double getFree() {
        return Arith.div(free, (1024 * 1024 * 1024), 2);
    }
 
    public double getUsage() {
        return Arith.mul(Arith.div(used, total, 4), 100);
    }
}
```
```
package com.zzg.monit.domain.server;
 
import lombok.Getter;
import lombok.Setter;
 
/**
 * 系统相关信息
 * @author zzg
 *
 */
public class Sys {
	/**
     * 服务器名称
     */
	@Getter
	@Setter
    private String computerName;
 
    /**
     * 服务器Ip
     */
	@Getter
	@Setter
    private String computerIp;
 
    /**
     * 项目路径
     */
	@Getter
	@Setter
    private String userDir;
 
    /**
     * 操作系统
     */
	@Getter
	@Setter
    private String osName;
 
    /**
     * 系统架构
     */
	@Getter
	@Setter
    private String osArch;		
}
package com.zzg.monit.domain.server;
 
import lombok.Getter;
import lombok.Setter;
 
/**
 * 系统文件相关信息
 * @author zzg
 *
 */
public class SysFile {
	 /**
     * 盘符路径
     */
	@Getter
	@Setter
    private String dirName;
 
    /**
     * 盘符类型
     */
	@Getter
	@Setter
    private String sysTypeName;
 
    /**
     * 文件类型
     */
	@Getter
	@Setter
    private String typeName;
 
    /**
     * 总大小
     */
	@Getter
	@Setter
    private String total;
 
    /**
     * 剩余大小
     */
	@Getter
	@Setter
    private String free;
 
    /**
     * 已经使用量
     */
	@Getter
	@Setter
    private String used;
 
    /**
     * 资源的使用率
     */
	@Getter
	@Setter
    private double usage;
}
```
```
package com.zzg.monit.domain;
 
import java.io.Serializable;
import java.net.UnknownHostException;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import com.zzg.monit.domain.server.Cpu;
import com.zzg.monit.domain.server.Jvm;
import com.zzg.monit.domain.server.Mem;
import com.zzg.monit.domain.server.Sys;
import com.zzg.monit.domain.server.SysFile;
import com.zzg.util.Arith;
import com.zzg.util.IpUtils;
 
import lombok.Getter;
import lombok.Setter;
import oshi.SystemInfo;
import oshi.hardware.CentralProcessor;
import oshi.hardware.GlobalMemory;
import oshi.hardware.HardwareAbstractionLayer;
import oshi.hardware.CentralProcessor.TickType;
import oshi.software.os.FileSystem;
import oshi.software.os.OSFileStore;
import oshi.software.os.OperatingSystem;
import oshi.util.Util;
 
public class Server implements Serializable {
 
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
 
	private static final int OSHI_WAIT_SECOND = 1000;
 
	/**
	 * CPU相关信息
	 */
	@Getter
	@Setter
	private Cpu cpu = new Cpu();
 
	/**
	 * 內存相关信息
	 */
	@Getter
	@Setter
	private Mem mem = new Mem();
 
	/**
	 * JVM相关信息
	 */
	@Getter
	@Setter
	private Jvm jvm = new Jvm();
 
	/**
	 * 服务器相关信息
	 */
	@Getter
	@Setter
	private Sys sys = new Sys();
 
	/**
	 * 磁盘相关信息
	 */
	@Getter
	@Setter
	private List&lt;SysFile&gt; sysFiles = new LinkedList&lt;SysFile&gt;();
	
 
	 public void copyTo() throws Exception {
	        SystemInfo si = new SystemInfo();
	        HardwareAbstractionLayer hal = si.getHardware();
 
	        setCpuInfo(hal.getProcessor());
 
	        setMemInfo(hal.getMemory());
 
	        setSysInfo();
 
	        setJvmInfo();
 
	        setSysFiles(si.getOperatingSystem());
	    }
 
	    /**
	     * 设置CPU信息
	     */
	    private void setCpuInfo(CentralProcessor processor) {
	        // CPU信息
	        long[] prevTicks = processor.getSystemCpuLoadTicks();
	        Util.sleep(OSHI_WAIT_SECOND);
	        long[] ticks = processor.getSystemCpuLoadTicks();
	        long nice = ticks[TickType.NICE.getIndex()] - prevTicks[TickType.NICE.getIndex()];
	        long irq = ticks[TickType.IRQ.getIndex()] - prevTicks[TickType.IRQ.getIndex()];
	        long softirq = ticks[TickType.SOFTIRQ.getIndex()] - prevTicks[TickType.SOFTIRQ.getIndex()];
	        long steal = ticks[TickType.STEAL.getIndex()] - prevTicks[TickType.STEAL.getIndex()];
	        long cSys = ticks[TickType.SYSTEM.getIndex()] - prevTicks[TickType.SYSTEM.getIndex()];
	        long user = ticks[TickType.USER.getIndex()] - prevTicks[TickType.USER.getIndex()];
	        long iowait = ticks[TickType.IOWAIT.getIndex()] - prevTicks[TickType.IOWAIT.getIndex()];
	        long idle = ticks[TickType.IDLE.getIndex()] - prevTicks[TickType.IDLE.getIndex()];
	        long totalCpu = user + nice + cSys + idle + iowait + irq + softirq + steal;
	        cpu.setCpuNum(processor.getLogicalProcessorCount());
	        cpu.setTotal(totalCpu);
	        cpu.setSys(cSys);
	        cpu.setUsed(user);
	        cpu.setWait(iowait);
	        cpu.setFree(idle);
	    }
 
	    /**
	     * 设置内存信息
	     */
	    private void setMemInfo(GlobalMemory memory) {
	        mem.setTotal(memory.getTotal());
	        mem.setUsed(memory.getTotal() - memory.getAvailable());
	        mem.setFree(memory.getAvailable());
	    }
 
	    /**
	     * 设置服务器信息
	     */
	    private void setSysInfo() {
	        Properties props = System.getProperties();
	        sys.setComputerName(IpUtils.getHostName());
	        sys.setComputerIp(IpUtils.getHostIp());
	        sys.setOsName(props.getProperty("os.name"));
	        sys.setOsArch(props.getProperty("os.arch"));
	        sys.setUserDir(props.getProperty("user.dir"));
	    }
 
	    /**
	     * 设置Java虚拟机
	     */
	    private void setJvmInfo() throws UnknownHostException {
	        Properties props = System.getProperties();
	        jvm.setTotal(Runtime.getRuntime().totalMemory());
	        jvm.setMax(Runtime.getRuntime().maxMemory());
	        jvm.setFree(Runtime.getRuntime().freeMemory());
	        jvm.setVersion(props.getProperty("java.version"));
	        jvm.setHome(props.getProperty("java.home"));
	    }
 
	    /**
	     * 设置磁盘信息
	     */
	    private void setSysFiles(OperatingSystem os) {
	        FileSystem fileSystem = os.getFileSystem();
	        OSFileStore[] fsArray = fileSystem.getFileStores();
	        for (OSFileStore fs : fsArray) {
	            long free = fs.getUsableSpace();
	            long total = fs.getTotalSpace();
	            long used = total - free;
	            SysFile sysFile = new SysFile();
	            sysFile.setDirName(fs.getMount());
	            sysFile.setSysTypeName(fs.getType());
	            sysFile.setTypeName(fs.getName());
	            sysFile.setTotal(convertFileSize(total));
	            sysFile.setFree(convertFileSize(free));
	            sysFile.setUsed(convertFileSize(used));
	            sysFile.setUsage(Arith.mul(Arith.div(used, total, 4), 100));
	            sysFiles.add(sysFile);
	        }
	    }
 
	    /**
	     * 字节转换
	     *
	     * @param size 字节大小
	     * @return 转换后值
	     */
	    public String convertFileSize(long size) {
	        long kb = 1024;
	        long mb = kb * 1024;
	        long gb = mb * 1024;
	        if (size &gt;= gb) {
	            return String.format("%.1f GB" , (float) size / gb);
	        } else if (size &gt;= mb) {
	            float f = (float) size / mb;
	            return String.format(f &gt; 100 ? "%.0f MB" : "%.1f MB" , f);
	        } else if (size &gt;= kb) {
	            float f = (float) size / kb;
	            return String.format(f &gt; 100 ? "%.0f KB" : "%.1f KB" , f);
	        } else {
	            return String.format("%d B" , size);
	        }
	    }
}
```
第三步：控制层编写：
```
package com.zzg.controller;
 
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import com.zzg.monit.domain.Server;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
 
/**
 * 服务器监控
 * @author zzg
 *
 */
@Api(value = "服务器监控", description = "服务器监控管理")
@Controller
@RequestMapping("/server")
@Slf4j
public class ServerController {
	
	/**服务器监控首页
	 * @throws Exception **/
    @ApiOperation(value = "服务器监控首页", notes = "服务器监控首页")
    @GetMapping("/server")
    public ModelAndView user() throws Exception{
    	Server server = new Server();
        server.copyTo();
    	ModelAndView modelAndView = new ModelAndView();
    	modelAndView.setViewName("admin/server/server");
    	modelAndView.addObject("server", server);
        return modelAndView;
    } 
}

```

![upload successful](/images/pasted-28.png)




