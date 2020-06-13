title: BUILD
author: Joe Tong
tags:
  - ONOS
  - JAVAEE
categories:
 - IT
date: 2019-07-30 01:20:00
---

bazel笔记：
bazel的编译是基于工作区，也就是项目的根目录  
1. workspace文件：制定当前文件夹就是一个bazel工作区。  
2. 一个或多个build文件，如果工作区中的一个目录包含build文件，那么他就是一个package.  
因此，要制定一个目录为bazel的工作区，就只要在该目录下创建一个空的workspace即可。  
&amp;lt;font color="red"&amp;gt;//: 该符号标识根目录下的文件  &amp;lt;/font&amp;gt;  
target：  
cc_binary (name)  
cc_libary  
cc_test  

bazel有两个关键元素，一个是package，另一个是target  
package是可独立编译的project包，由workspace文件（可为空）标识；  
target是BUILD文件中的关键元素，也就是编译的目标，目标可以是二进制文件（cc_binary), 可以是libary(cc_libary)

```
visiblity: ["//visibility:public"],['//visibility:private'](私有)，['//some/package:__pkg__'](注意冒号)  
ex: package(default_visibility = ["//visibility:public"])
```

Dependencies：

 在构建或者执行时，目标A依赖于目标B，这种依赖关系产生一个有向无环图，我们将这种有向无环图称为依赖图，
 一个目标的直接依赖关系指的是在依赖图中可以以1步到达依赖对象的关系，
 二传递依赖关系指的是需要经过数步才能到达依赖对象的关系。

事实上在构建的上下文中，有两种依赖关系，&amp;lt;font color="red"&amp;gt;实际依赖关系和声明依赖关系&amp;lt;/font&amp;gt;。两者差别极小。实际依赖关系指的是构建或者执行的时候A需要B，而声名依赖关系仅仅是在包A中有从A到B的一条依赖线。

为了确保构建的正确性，实际依赖关系A必须是声名依赖关系的子图，也就是说，每一个在A中的直接依赖关系对x---&amp;gt;y，必须也是D中的直接依赖关系对。

在a、b、c三个个字包含了BUILD文件的三个包中，a依赖b，b依赖c，比如下图：  


其中的声明依赖关系为：deps：a--&amp;gt;b;b--&amp;gt;c;  

实际依赖关系为：各自srcs的目标文件中的import 及相应的函数的表征：a--&amp;gt;b；b--&amp;gt;c;  

三种常见的构建规则的依赖关系类型：  

1、srcs依赖：也就是BUILD文件中规则的属性Srcs的值，他表示构建该规则时使用的程序代码；  

2、deps依赖：也就是规则中的deps属性的值，表示构建规则时所需要的头文件等；  

3、data依赖：它不是代码，只是构建规则时需要的数据；  

构建系统在一个独立的目录中进行测试，该目录中仅仅只有命名为data的文件可视，因此，需要测试时，需要声明数据为data文件；  

&amp;lt;font color="red"&amp;gt;注：您不应将目录指定为构建系统的输入，而应明确或使用该`glob()`函数枚举其中包含的文件集 用于强制递归。&amp;lt;/font&amp;gt;

java_binary 
java_binary（name，deps，srcs，data，resources，args，classpath_resources，compatible_with，
create_executable，deploy_env，deploy_manifest_lines，deprecation，distribs，exec_compatible_with，
features，javacopts，jvm_flags，launcher，licenses，main_class，output_licenses，plugins，resource_jars，
resource_strip_prefix，restricted_to，runtime_deps，stamp，tags，testonly，toolchains，use_testrunner，visibility）  

构建Java归档文件（“jar文件”），以及与规则同名的包装器shell脚本。包装器shell脚本使用一个类路径，
其中包括二进制所依赖的每个库的jar文件。  

包装器脚本接受几个唯一标志。请参阅 //src/main/java/com/google/devtools/build/lib/bazel/rules/java/java_stub_template.txt 
包装器接受的可配置标志和环境变量的列表。

建个target
可视化项目的依赖项 
将项目拆分为多个目标和包 
控制包之间的目标可见性
通过标签引用目标
部署目标

设置工作区
理解BUILD文件
构建项目
查看依赖关系图 
完善bazel 构建
指定多个生成目标 
使用多个包
使用标签引用目标 
打包部署的Java目标
进一步读

构建一个项目前需要先建个工作区
工作区是保存项目源文件和bazel的目录。
工作区文件，将目录及其内容标识为bazel工程
位于项目目录结构的根目录 
构建文件包含几种不同类型的bazel指令 
最重要的类型是构建规则
告诉Bazel如何构建所需的输出 
例如可执行的二进制文件或库 
生成文件中生成规则的每个实例都称为目标 
指向一组特定的源文件和依赖项 
目标也可以指向其他目标   
projectrunner目标实例化bazel的内置Java_二进制规则 
目标中的属性显式地声明其依赖项和选项 
规则告诉bazel构建一个.jar文件和一个包装shell脚本
虽然name属性是必需的，许多是可选的  
例如，在ProjectRunner规则目标中，name是目标的名称 
srcs指定bazel用于构建目标的源文件  
main_类指定包含main方法的类  
注意目标标签//部分是构建文件rela的位置 
ProjectRunner是我们在构建文件中命名的目标 
Bazel的产出与以下类似 

```
INFO: Found 1 target...
Target //:ProjectRunner up-to-date:
  bazel-bin/ProjectRunner.jar
  bazel-bin/ProjectRunner
INFO: Elapsed time: 1.021s, Critical Path: 0.83s

```
bazel将构建输出放在工作目录下的bazel bin目录中  
浏览其内容以了解Bazel的输出结构  
Bazel要求在生成文件中显式声明生成依赖项
Bazel使用这些语句创建项目的依赖关系图从而实现精确的增量构建 
让我们可视化示例项目的依赖关系。 
首先，生成依赖关系图的文本表示形式 在工作区根目录下运行命令
`bazel query  --nohost_deps --noimplicit_deps "deps(//:ProjectRunner)" --output graph`
上面的命令告诉bazel查找目标的所有依赖项 
//:ProjectRunner
然后，将文本粘贴到graphviz中
如您所见，该项目有一个构建两个源文件的目标
现在您已经设置了工作区，构建了项目，并检查了它。 
完善构建

当一个目标就足以满足小型项目的需求 ，您可能希望将较大的项目拆分为多个目标和包允许快速增量生成 
只重建已更改的内容 通过同时构建项目的多个部分来加速构建 

指定多个生成目标 
让我们将示例项目构建分为两个目标。替换内容 


```
java_binary(
    name = "ProjectRunner",
    srcs = ["src/main/java/com/example/ProjectRunner.java"],
    main_class = "com.example.ProjectRunner",
    deps = [":greeter"],
)

java_library(
    name = "greeter",
    srcs = ["src/main/java/com/example/Greeting.java"],
)

```
通过这种配置，Bazel首先构建了Greeter库。 
然后是projectrunner二进制文件 
java_二进制文件中的deps属性告诉bazel，需要Greeter库来构建ProjectRunner二进制文件
让我们构建这个新版本的项目。运行以下命令 
`bazel build //:ProjectRunner`

Bazel的输出与以下类似 
```
INFO: Found 1 target...
Target //:ProjectRunner up-to-date:
  bazel-bin/ProjectRunner.jar
  bazel-bin/ProjectRunner
INFO: Elapsed time: 2.454s, Critical Path: 1.58s
```
现在测试新构建的二进制文件 

`bazel-bin/ProjectRunner`
如果现在修改projectrunner.java并重新生成项目，则bazel仅重新编译该文件  
查看依赖关系图，您可以看到ProjectRunner 依赖于与以前相同的输入，但构建的结构不同
现在您已经用两个目标构建了项目。 
ProjectRunner目标生成两个源文件并依赖于另一个目标:greeter它会生成一个附加的源文件 

现在让我们把这个项目分成多个包
你现在看下src/main/java/com/example/cmdline这个文件夹
您可以看到它还包含一个生成文件 BUILD
加上一些源文件 因此，对于Bazel，工作区现在包含两个包 

`//src/main/java/com/example/cmdline 和 //`

因为在工作区的根目录下有一个生成文件 
看一下 src/main/java/com/example/cmdline/BUILD 文件

```
java_binary(
    name = "runner",
    srcs = ["Runner.java"],
    main_class = "com.example.cmdline.Runner",
    deps = ["//:greeter"]
)

```


运行目标依赖greeter目标 在// 包下
因此，目标标签 //:greeter
bazel 通过deps属性知道这一点 
看看依赖关系图 
但是，要使构建成功，必须在//src/main/java/com/example/cmdline/BUILD 文件中明确地给出运行者目标
目标可见性在//BUILD中使用visibility属性这是因为默认情况下，目标仅对同一个build 文件中的其他目标可见 
Bazel使用目标可见性来防止诸如包含泄漏到公共API中的实现细节的库
为此，将可见性属性添加到java-tutorial/BUILD中的greeter对象中。 

`bazel build //src/main/java/com/example/cmdline:runner`

```
java_library(
    name = "greeter",
    srcs = ["src/main/java/com/example/Greeting.java"],
    visibility = ["//src/main/java/com/example/cmdline:__pkg__"],
)

```
现在我们来构建新的包。在t的根目录下运行以下命令 
bazel的输出大概如下

```
INFO: Found 1 target...
Target //src/main/java/com/example/cmdline:runner up-to-date:
  bazel-bin/src/main/java/com/example/cmdline/runner.jar
  bazel-bin/src/main/java/com/example/cmdline/runner
  INFO: Elapsed time: 1.576s, Critical Path: 0.81s
  
```

现在测试新构建的二进制文件 

`./bazel-bin/src/main/java/com/example/cmdline/runner`

现在，您已经将项目修改为两个包，每个包含一个目标，并了解它们之间的依赖关系 
使用标签引用目标 
在构建文件和命令行中，bazel使用目标标签进行引用 
//:ProjectRunner或//src/main/java/com/example/cmdline:runner 他们的语法如下：

`//path/to/package:target-name`

如果目标是规则目标 则path/to/package是包含BUILD生成文件的目录的路径 
目标名称是您在构建文件中为目标命名的名称，如果目标是个文件目标则
path/to/package 是指向包根目录的路径目标名称是目标文件的名称，包括其完整路径。

引用同一包中的目标时 您可以跳过包路径 就用 //:target-name
引用同一生成文件中的目标时甚至可以跳过工作区根标识符  就用:target-name
例如在java-tutorial/BUILD目标文件您不必指定包路径 
因为工作区根本身就是一个包 (//)你的两个目标标签很简单
//:ProjectRunner 和 //:greeter.
然而目标在 //src/main/java/com/example/cmdline/BUILD 文件您必须指定全包路径你的目标标签是 
//src/main/java/com/example/cmdline:runner
打包部署一个Java目标 
现在我们通过构建二进制文件来打包部署Java目标。 
正如您所记得的，java_二进制构建规则生成一个.jar包和包装shell脚本
看下runner.jar的内容使用如下命令

`jar tf bazel-bin/src/main/java/com/example/cmdline/runner.jar`

内容如下：

```
META-INF/
META-INF/MANIFEST.MF
com/
com/example/
com/example/cmdline/
com/example/cmdline/Runner.class
```
如你所见runner.jar包含Runner.class但不是它的依赖性 Greeting.class
runner脚本 bazel生成的runner脚本将greeter.jar添加到类路径中 ，所以如果你像这样放着，
他将会在本地运行，但它不会在另一台机器上独立运行 幸运的是，
java_二进制规则允许您构建一个自包含的depl 
要构建它，请在构建runner时向文件名添加_deploy.jar后缀

`bazel build //src/main/java/com/example/cmdline:runner_deploy.jar`
 Bazel输出与以下类似 
 
 ```
 INFO: Found 1 target...
Target //src/main/java/com/example/cmdline:runner_deploy.jar up-to-date:
  bazel-bin/src/main/java/com/example/cmdline/runner_deploy.jar
INFO: Elapsed time: 1.700s, Critical Path: 0.23s
 ```
 你刚刚建立了一个runner_deploy.jar
它可以独立运行在开发环境之外因为它包含所需的运行时依赖项。 


隐含的输出目标
name.jar：Java归档文件，包含与二进制文件直接依赖项对应的类文件和其他资源。
name-src.jar：包含源（“源jar”）的存档。
name_deploy.jar：适合部署的Java归档文件（仅在明确请求时构建）。
构建规则的目标会创建一个自包含的jar文件，其中包含一个清单，允许使用命令或包装器脚本的 选项运行它 。
使用包装器脚本是首选，因为它还传递JVM标志和加载本机库的选项。 &amp;lt;name&amp;gt;_deploy.jarjava -jar--singlejarjava -jar

部署jar包含类加载器可以找到的所有类，这些类从头到尾从二进制文件的包装器脚本中搜索类路径。它还包含依赖项所需的本机库。
它们在运行时自动加载到JVM中。

如果您的目标指定了一个启动器 属性，那么_deploy.jar将是一个原生二进制文件，而不是一个普通的JAR文件。
这将包含启动程序以及规则的任何本机（C ++）依赖项，所有这些都链接到静态二进制文件。
实际的jar文件的字节将附加到该本机二进制文件，创建一个包含可执行文件和Java代码的二进制blob。
您可以直接执行生成的jar文件，就像执行任何本机二进制文件一样。

name_deploy-src.jar：包含从目标的传递闭包收集的源的存档。这些将匹配 deploy.jar除了jar没有匹配的源jar的类。
deps没有java_binary规则的规则中 不允许 使用属性srcs; 这样的规则要求 main_class提供者 runtime_deps。

以下代码段说明了一个常见错误：
```
java_binary（
    name =“DontDoThis”，
    srcs = [
        ... ,,
         "GeneratedJavaFile.java"＃生成的.java文件
    ]
    deps = [ ":generating_rule",]，＃生成该文件的规则
）

```

改为：

```
java_binary（
    name =“DoThisInstead”，
    srcs = [
        ......，
        “：generating_rule”
    ]
）

```

参数
属性
name	
Name; required

此目标的唯一名称。


最好使用作为应用程序主入口点的源文件的名称（减去扩展名）。
例如，如果您的入口点被调用 Main.java，那么您的名字可能就是Main。
deps	
List of labels; optional

要链接到目标的其他库的列表。看到一般的评论deps在 共同所有的生成规则属性 。
srcs	
List of labels; optional

处理以创建目标的源文件列表。几乎总是需要此属性; 看下面的例外。
.java编译 类型的源文件。在生成.java文件的情况下， 通常建议在此处放置生成规则的名称，而不是文件本身的名称。
这不仅提高了可读性，而且使规则对未来的更改更具弹性：如果生成规则将来生成不同的文件，您只需要修复一个地方：outs生成规则。
您不应该列出生成规则，deps 因为它是无操作。

类型的源文件.srcjar被解压缩和编译。（如果您需要生成一组.java带有genrule 的文件，这非常有用。）

规则：如果规则（通常genrule或filegroup）生成上面列出的任何文件，它们将以与源文件所述相同的方式使用。

除非main_class属性指定运行时类路径上的类或指定runtime_deps参数，否则几乎总是需要 此参数。

resources	
List of labels; optional

要包含在Java jar中的数据文件列表。
如果指定了资源，它们将与.class编译生成的常用文件一起捆绑在jar中 。jar文件中资源的位置由项目结构决定。
Bazel首先查找Maven的 标准目录布局，（“src”目录后跟“资源”目录孙子）。
如果找不到，那么Bazel会查找名为“java”或“javatests”的最顶层目录
（例如，如果资源处于&amp;lt;workspace root&amp;gt;/x/java/y/java/z，则资源的路径将是y/java/z。此启发式扫描不能被覆盖。

资源可以是源文件或生成的文件。

classpath_resources	
List of labels; optional

除非没有其他方式，否则不要使用此选项）
必须位于Java树根目录的资源列表。此属性的唯一目的是支持第三方库，这些库要求在类路径上找到它们的资源"myconfig.xml"。
由于名称空间冲突的危险，它只允许在二进制文件而不是库中。

create_executable	
Boolean; optional; nonconfigurable; default is True

二进制文件是否可执行。不可执行的二进制文件将传递的运行时Java依赖项收集到部署jar中，但不能直接执行。
如果设置了此属性，则不会创建包装器脚本。如果设置了launcher或main_class属性，则将此值设置为0是错误的。
deploy_env	
List of labels; optional

java_binary表示此二进制文件的部署环境 的其他目标的列表。在构建将由另一个加载的插件时设置此属性 java_binary。
设置此属性将排除此二进制文件的运行时类路径（和部署jar）中的所有依赖项，这些依赖项在此二进制文件和指定的目标之间共享deploy_env。
deploy_manifest_lines	
List of strings; optional

要添加到META-INF/manifest.mf为*_deploy.jar目标生成的文件 的行列表。此属性的内容不符合“使变量”替换。
javacopts	
List of strings; optional

此库的额外编译器选项。受“Make变量”替换和 Bourne shell标记化的约束。
这些编译器选项在全局编译器选项之后传递给javac。

jvm_flags	
List of strings; optional

要在运行此二进制文件时生成的包装器脚本中嵌入的标志列表。受$（位置）和 “Make变量”替换，以及 Bourne shell标记化。
Java二进制文件的包装器脚本包括一个CLASSPATH定义（用于查找所有相关的jar）并调用正确的Java解释器。
包装器脚本生成的命令行包含主类的名称，后跟a，"$@"因此您可以在类名后传递其他参数。
但是，必须在命令行上的类名之前指定用于由JVM进行解析的参数。在jvm_flags列出类名之前，将内容添加到包装脚本中。

请注意，此属性对 输出没有影响*_deploy.jar。

launcher	
Label; optional

指定将用于运行Java程序的二进制文件，而不是bin/javaJDK附带的普通程序。
目标必须是a cc_binary。任何cc_binary实现 Java Invocation API的都可以指定为此属性的值。
默认情况下，Bazel将使用普通的JDK启动程序（bin / java或java.exe）。

相关的 --java_launcherBazel标志仅影响未指定属性的那些 java_binary和java_test目标 。launcher

请注意，根据您使用的是JDK启动程序还是其他启动程序，您的本机（C ++，SWIG，JNI）依赖项的构建方式会有所不同：

如果您使用的是普通的JDK启动程序（默认），则将本机依赖项构建为名为的共享库{name}_nativedeps.so，其中 {name}是name此java_binary规则的属性。
在此配置中，链接器不会删除未使用的代码。
如果您正在使用任何其他启动程序，则本机（C ++）依赖项将静态链接到名为的二进制文件{name}_nativedeps，其中此java_binary规则{name} 的name属性。
在这种情况下，链接器将从生成的二进制文件中删除它认为未使用的任何代码，这意味着除非该cc_library目标指定，否则任何仅通过JNI访问的C ++代码都可能无法链接alwayslink = 1。
使用除默认JDK启动程序以外的任何启动程序时，*_deploy.jar输出的格式会更改。有关详细信息，请参阅主 java_binary文档。

main_class	
String; optional

具有main()用作入口点的方法的类的名称。如果规则使用此选项，则不需要srcs=[...]列表。因此，使用此属性，可以从已包含一个或多个main()方法的Java库生成可执行文件。
此属性的值是类名，而不是源文件。该类必须在运行时可用：它可以由此规则（从srcs）编译，或由直接或传递依赖（通过runtime_deps或 deps）提供。如果该类不可用，则二进制文件将在运行时失败; 没有构建时间检查。

plugins	
List of labels; optional

Java编译器插件在编译时运行。java_plugin无论何时构建此规则，都将运行此属性中指定的每个属性。库也可以从使用的依赖项继承插件 exported_plugins。插件生成的资源将包含在此规则的结果jar中。
resource_jars	
List of labels; optional

包含Java资源的档案集。
如果指定，这些jar的内容将合并到输出jar中。

resource_strip_prefix	
String; optional

从Java资源中剥离的路径前缀。
如果指定，则从resources 属性中的每个文件中剥离此路径前缀。资源文件不在此目录下是错误的。如果未指定（默认值），则根据与源文件的Java包相同的逻辑确定资源文件的路径。例如，源文件 stuff/java/foo/bar/a.txt位于foo/bar/a.txt。

runtime_deps	
List of labels; optional

库可用于最终二进制文件或仅在运行时测试。与普通类似deps，这些将出现在运行时类路径中，但与它们不同，不在编译时类路径上。应在此处列出仅在运行时所需的依赖关系。依赖性分析工具应该忽略出现在两个目标 runtime_deps和deps。
stamp	
Integer; optional; default is -1

启用链接标记。是否将构建信息编码为二进制文件。可能的值：
stamp = 1：将构建信息标记到二进制文件中。只有在依赖项发生变化时才会重建标记的二进制文件。如果存在依赖于构建信息的测试，请使用此选项。
stamp = 0：始终使用常量值替换构建信息。这提供了良好的构建结果缓存。
stamp = -1：嵌入构建信息由 - [no]戳标志控制。
toolchains	
List of labels; optional

提供“Make variables”的工具链集 ，该目标可以在其某些属性中使用。一些规则具有工具链，其默认情况下可以使用Make变量。
use_testrunner	
Boolean; optional; default is False

使用测试运行器（默认情况下 com.google.testing.junit.runner.BazelTestRunner）类作为Java程序的主入口点，并将测试类作为bazel.test_suite 系统属性的值提供给测试运行器。您可以使用它来覆盖默认行为，即使用测试运行器获取 java_test规则，而不是将其用于java_binary规则。你不太可能想要这样做。一种用途是用于AllTest 由另一个规则调用的规则（例如，在运行测试之前设置数据库）。该AllTest 规则必须被声明为java_binary，但仍应使用测试运行器作为其主要入口点。可以使用main_classattribute 覆盖测试运行器类的名称。
java_import 
java_import（name，deps，data，compatible_with，constraints，deprecation，distribs，exec_compatible_with，exports，features，jars，licenses，neverlink，proguard_specs，restricted_to，runtime_deps，srcjar，tags，testonly，visibility）
此规则允许将预编译.jar文件用作库java_library和 java_binary规则。

例子

```
    java_import（
        name =“maven_model”，
        jars = [
            “maven_model / Maven的以太网提供商-3.2.3.jar”，
            “maven_model / Maven的模型3.2.3.jar”，
            “maven_model / Maven的模型建设者-3.2.3.jar”，
        ]
    ）
    
```

参数

属性
name	
Name; required

此目标的唯一名称。

deps	
List of labels; optional

要链接到目标的其他库的列表。请参阅java_library.deps。
constraints	
List of strings; optional; nonconfigurable

作为Java库对此规则施加额外约束。
exports	
List of labels; optional

目标可供此规则的用户使用。请参阅java_library.exports。
jars	
List of labels; required

提供给依赖于此目标的Java目标的JAR文件列表。
neverlink	
Boolean; optional; default is False

仅使用此库进行编译，而不是在运行时使用。如果库将在执行期间由运行时环境提供，则很有用。
像这样的库的示例是用于IDE插件的IDE API或tools.jar用于在标准JDK上运行的任何内容。
proguard_specs	
List of labels; optional

用作Proguard规范的文件。这些将描述Proguard使用的规范集。如果指定，它们将android_binary根据此库添加到任何目标。
此处包含的文件必须只有幂等规则，即-dontnote，-dontwarn，assumenosideeffects和以-keep开头的规则。
其他选项只能出现在 android_binaryproguard_specs中，以确保非重言式合并。
runtime_deps	
List of labels; optional

库可用于最终二进制文件或仅在运行时测试。请参阅java_library.runtime_deps。
srcjar	
Label; optional

包含已编译JAR文件的源代码的JAR文件。

```
java_library 
java_library（name，deps，srcs，data，resources，compatible_with，deprecation，
distribs，exec_compatible_with，exported_plugins，exports，features，javacopts，
licenses，neverlink，plugins，proguard_specs，resource_jars，resource_strip_prefix，
restricted_to，runtime_deps，tags，testonly，能见度）

```

此规则编译源并将源链接到.jar文件中。

隐含的输出目标
libname.jar：包含类文件的Java归档文件。
libname-src.jar：包含源（“源jar”）的存档。
参数
属性
name	
Name; required

此目标的唯一名称。

deps	
List of labels; optional

要链接到此库的库列表。看到一般的评论deps在 共同所有的生成规则属性 。
由java_library列出的规则构建的jar deps将位于此规则的编译时类路径中。
此外，它们的传递闭包 deps，runtime_deps并将exports在运行时类路径上。

相比之下，data属性中的目标包含在运行文件中，但既不包含在编译时也不包含在运行时类路径中。

srcs	
List of labels; optional

处理以创建目标的源文件列表。几乎总是需要此属性; 看下面的例外。
.java编译 类型的源文件。在生成.java文件的情况下， 通常建议在此处放置生成规则的名称，而不是文件本身的名称。
这不仅提高了可读性，而且使规则对未来的更改更具弹性：如果生成规则将来生成不同的文件，您只需要修复一个地方：outs生成规则。
您不应该列出生成规则，deps 因为它是无操作。

类型的源文件.srcjar被解压缩和编译。（如果您需要生成一组.java带有genrule 的文件，这非常有用。）

规则：如果规则（通常genrule或filegroup）生成上面列出的任何文件，它们将以与源文件所述相同的方式使用。

除非main_class属性指定运行时类路径上的类或指定runtime_deps参数，否则几乎总是需要 此参数。

data	
List of labels; optional

此库在运行时所需的文件列表。看到一般的评论data在 共同所有的生成规则属性 。
在构建时java_library，Bazel不会将这些文件放在任何地方; 如果 data文件是生成文件，那么Bazel会生成它们。
构建依赖于此java_libraryBazel 的测试时，data会将文件复制或链接 到runfiles区域。

resources	
List of labels; optional

要包含在Java jar中的数据文件列表。
如果指定了资源，它们将与.class编译生成的常用文件一起捆绑在jar中 。jar文件中资源的位置由项目结构决定。
Bazel首先查找Maven的 标准目录布局，（“src”目录后跟“资源”目录孙子）。
如果找不到，那么Bazel会查找名为“java”或“javatests”的最顶层目录（例如，如果资源处于&amp;lt;workspace root&amp;gt;/x/java/y/java/z，则资源的路径将是y/java/z。
此启发式扫描不能被覆盖。

资源可以是源文件或生成的文件。

exported_plugins	
List of labels; optional

java_plugin要导出到直接依赖于此库的库 的s（例如注释处理器）列表。
指定的java_plugins 列表将应用于任何直接依赖于此库的库，就像该库已明确声明这些标签一样plugins。

exports	
List of labels; optional

导出的图书馆。
此处的列表规则将使它们可用于父规则，就像父项明确依赖于这些规则一样。对于常规（非导出），情况并非如此deps。

简介：规则X可以访问Y中的代码，如果它们之间存在依赖路径，该路径以deps边缘开始，后跟零个或多个 exports边缘。让我们看一些例子来说明这一点。

假设甲取决于乙和乙取决于Ç。在这种情况下，C是A 的传递依赖，因此更改C的源并重建A将正确地重建所有内容。然而，A将无法使用C中的类。
为了允许这种情况，要么A必须在其中声明C deps，要么B可以通过在其（B）中声明C来使A（以及可能依赖于A的任何东西）变得更容易。exports 属性。

所有直接父规则都可以使用导出库的闭包。举一个稍微不同的例子：A依赖于B，B依赖于C和D，并且还导出C而不是D.现在A可以访问C但不能访问D.现在，如果C和D导出了一些库，C'和D'，A只能访问C'但不能访问D'。

重要提示：导出的规则不是常规依赖项。坚持前面的例子，如果B导出C并且想要也使用C，它也必须自己列出它 deps。

javacopts	
List of strings; optional

此库的额外编译器选项。受“Make变量”替换和 Bourne shell标记化的约束。
这些编译器选项在全局编译器选项之后传递给javac。

neverlink	
Boolean; optional; default is False

此库是仅应用于编译而不是用于运行时。如果库将在执行期间由运行时环境提供，则很有用。此类库的示例是IDE插件的IDE API或tools.jar标准JDK上运行的任何内容。
请注意，neverlink = 1这不会阻止编译器将此库中的材料内联到依赖于它的编译目标中，如Java语言规范所允许的那样（例如， 原始类型的static final常量String或常量类型的常量）。因此，当运行时库与编译库相同时，首选用例是。

如果运行时库与编译库不同，则必须确保它仅在JLS禁止编译器内联的位置（并且必须适用于JLS的所有未来版本）中有所不同。

plugins	
List of labels; optional

Java编译器插件在编译时运行。java_plugin无论何时构建此规则，都将运行此属性中指定的每个属性。库也可以从使用的依赖项继承插件 exported_plugins。插件生成的资源将包含在此规则的结果jar中。
proguard_specs	
List of labels; optional

用作Proguard规范的文件。这些将描述Proguard使用的规范集。如果指定，它们将android_binary根据此库添加到任何目标。此处包含的文件必须只有幂等规则，即-dontnote，-dontwarn，assumenosideeffects和以-keep开头的规则。其他选项只能出现在 android_binaryproguard_specs中，以确保非重言式合并。
resource_jars	
List of labels; optional

包含Java资源的档案集。
如果指定，这些jar的内容将合并到输出jar中。

resource_strip_prefix	
String; optional

从Java资源中剥离的路径前缀。
如果指定，则从resources 属性中的每个文件中剥离此路径前缀。资源文件不在此目录下是错误的。如果未指定（默认值），则根据与源文件的Java包相同的逻辑确定资源文件的路径。例如，源文件 stuff/java/foo/bar/a.txt位于foo/bar/a.txt。

runtime_deps	
List of labels; optional

库可用于最终二进制文件或仅在运行时测试。与普通类似deps，这些将出现在运行时类路径中，但与它们不同，不在编译时类路径上。应在此处列出仅在运行时所需的依赖关系。依赖性分析工具应该忽略出现在两个目标 runtime_deps和deps。
```
java_lite_proto_library 
java_lite_proto_library（name，deps，data，compatible_with，deprecation，distribs，exec_compatible_with，features，licenses，restricted_to，tags，testonly，visibility）
java_lite_proto_library从.proto文件生成Java代码。

```
deps必须指出proto_library 规则。

例：

```
java_library（
    name =“lib”，
    deps = [“：foo”]，
）

java_lite_proto_library（
    name =“foo”，
    deps = [“：bar”]，
）

proto_library（
    name =“bar”，
）

```
参数
属性
name	
Name; required

此目标的唯一名称。

deps	
List of labels; optional

proto_library 生成Java代码 的规则列表。
```
java_proto_library 
java_proto_library（name，deps，data，compatible_with，deprecation，distribs，exec_compatible_with，features，licenses，restricted_to，tags，testonly，visibility）
java_proto_library从.proto文件生成Java代码。

```

deps必须指出proto_library 规则。

例：

```
java_library（
    name =“lib”，
    deps = [“：foo_java_proto”]，
）

java_proto_library（
    name =“foo_java_proto”，
    deps = [“：foo_proto”]，
）

proto_library（
    name =“foo_proto”，
）

```

属性
name	
Name; required

此目标的唯一名称。

deps	
List of labels; optional

proto_library 生成Java代码 的规则列表。


java_test 
java_test（名称，DEPS，索马里红新月会，数据，资源，ARGS，classpath_resources，compatible_with，create_executable，deploy_manifest_lines，折旧，发行商，exec_compatible_with，功能，片状，javacopts，jvm_flags，发射器，牌照，地方，MAIN_CLASS，插件，resource_jars，resource_strip_prefix，restricted_to，runtime_deps，shard_count，size，stamp，tags，test_class，testonly，timeout，toolchains，use_testrunner，visibility）
一个java_test()规则编译一个Java测试。测试是围绕测试代码的二进制包装器。调用测试运行器的main方法而不是正在编译的主类。

隐含的输出目标
name.jar：Java存档。
name_deploy.jar：适合部署的Java归档文件。（仅在显式请求时才构建。）有关详细信息，请参阅 java_binaryname_deploy.jar输出的 说明。
请参阅有关java_binary（）参数的部分。此规则还支持所有测试规则（* _test）共有的所有属性。

例子

```
java_library（
    name =“tests”，
    srcs = glob（[“*。java”]），
    deps = [
        “// java的/ COM /富/碱：testResources”，
        “//的Java / COM /富/测试/ UTIL”，
    ]
）

java_test（
    name =“AllTests”，
    size =“small”，
    runtime_deps = [
        “：测试”，
        “// UTIL / MySQL的”，
    ]
）

```

参数
属性
name	
Name; required

此目标的唯一名称。

deps	
List of labels; optional

要链接到目标的其他库的列表。看到一般的评论deps在 共同所有的生成规则属性 。
srcs	
List of labels; optional

处理以创建目标的源文件列表。几乎总是需要此属性; 看下面的例外。
.java编译 类型的源文件。在生成.java文件的情况下， 通常建议在此处放置生成规则的名称，而不是文件本身的名称。这不仅提高了可读性，而且使规则对未来的更改更具弹性：如果生成规则将来生成不同的文件，您只需要修复一个地方：outs生成规则。您不应该列出生成规则，deps 因为它是无操作。

类型的源文件.srcjar被解压缩和编译。（如果您需要生成一组.java带有genrule 的文件，这非常有用。）

规则：如果规则（通常genrule或filegroup）生成上面列出的任何文件，它们将以与源文件所述相同的方式使用。

除非main_class属性指定运行时类路径上的类或指定runtime_deps参数，否则几乎总是需要 此参数。

resources	
List of labels; optional

要包含在Java jar中的数据文件列表。
如果指定了资源，它们将与.class编译生成的常用文件一起捆绑在jar中 。jar文件中资源的位置由项目结构决定。Bazel首先查找Maven的 标准目录布局，（“src”目录后跟“资源”目录孙子）。如果找不到，那么Bazel会查找名为“java”或“javatests”的最顶层目录（例如，如果资源处于&amp;lt;workspace root&amp;gt;/x/java/y/java/z，则资源的路径将是y/java/z。此启发式扫描不能被覆盖。

资源可以是源文件或生成的文件。

classpath_resources	
List of labels; optional

除非没有其他方式，否则不要使用此选项）
必须位于Java树根目录的资源列表。此属性的唯一目的是支持第三方库，这些库要求在类路径上找到它们的资源"myconfig.xml"。由于名称空间冲突的危险，它只允许在二进制文件而不是库中。

create_executable	
Boolean; optional; nonconfigurable; default is True

二进制文件是否可执行。不可执行的二进制文件将传递的运行时Java依赖项收集到部署jar中，但不能直接执行。如果设置了此属性，则不会创建包装器脚本。如果设置了launcher或main_class属性，则将此值设置为0是错误的。
deploy_manifest_lines	
List of strings; optional

要添加到META-INF/manifest.mf为*_deploy.jar目标生成的文件 的行列表。此属性的内容不符合“使变量”替换。
javacopts	
List of strings; optional

此库的额外编译器选项。受“Make变量”替换和 Bourne shell标记化的约束。
这些编译器选项在全局编译器选项之后传递给javac。

jvm_flags	
List of strings; optional

要在运行此二进制文件时生成的包装器脚本中嵌入的标志列表。受$（位置）和 “Make变量”替换，以及 Bourne shell标记化。
Java二进制文件的包装器脚本包括一个CLASSPATH定义（用于查找所有相关的jar）并调用正确的Java解释器。包装器脚本生成的命令行包含主类的名称，后跟a，"$@"因此您可以在类名后传递其他参数。但是，必须在命令行上的类名之前指定用于由JVM进行解析的参数。在jvm_flags列出类名之前，将内容添加到包装脚本中。

请注意，此属性对 输出没有影响*_deploy.jar。

launcher	
Label; optional

指定将用于运行Java程序的二进制文件，而不是bin/javaJDK附带的普通程序。目标必须是a cc_binary。任何cc_binary实现 Java Invocation API的都可以指定为此属性的值。
默认情况下，Bazel将使用普通的JDK启动程序（bin / java或java.exe）。

相关的 --java_launcherBazel标志仅影响未指定属性的那些 java_binary和java_test目标 。launcher

请注意，根据您使用的是JDK启动程序还是其他启动程序，您的本机（C ++，SWIG，JNI）依赖项的构建方式会有所不同：

如果您使用的是普通的JDK启动程序（默认），则将本机依赖项构建为名为的共享库{name}_nativedeps.so，其中 {name}是name此java_binary规则的属性。在此配置中，链接器不会删除未使用的代码。
如果您正在使用任何其他启动程序，则本机（C ++）依赖项将静态链接到名为的二进制文件{name}_nativedeps，其中此java_binary规则{name} 的name属性。在这种情况下，链接器将从生成的二进制文件中删除它认为未使用的任何代码，这意味着除非该cc_library目标指定，否则任何仅通过JNI访问的C ++代码都可能无法链接alwayslink = 1。
使用除默认JDK启动程序以外的任何启动程序时，*_deploy.jar输出的格式会更改。有关详细信息，请参阅主 java_binary文档。

main_class	
String; optional

具有main()用作入口点的方法的类的名称。如果规则使用此选项，则不需要srcs=[...]列表。因此，使用此属性，可以从已包含一个或多个main()方法的Java库生成可执行文件。
此属性的值是类名，而不是源文件。该类必须在运行时可用：它可以由此规则（从srcs）编译，或由直接或传递依赖（通过runtime_deps或 deps）提供。如果该类不可用，则二进制文件将在运行时失败; 没有构建时间检查。

plugins	
List of labels; optional

Java编译器插件在编译时运行。java_plugin无论何时构建此规则，都将运行此属性中指定的每个属性。库也可以从使用的依赖项继承插件 exported_plugins。插件生成的资源将包含在此规则的结果jar中。
resource_jars	
List of labels; optional

包含Java资源的档案集。
如果指定，这些jar的内容将合并到输出jar中。

resource_strip_prefix	
String; optional

从Java资源中剥离的路径前缀。
如果指定，则从resources 属性中的每个文件中剥离此路径前缀。资源文件不在此目录下是错误的。如果未指定（默认值），则根据与源文件的Java包相同的逻辑确定资源文件的路径。例如，源文件 stuff/java/foo/bar/a.txt位于foo/bar/a.txt。

runtime_deps	
List of labels; optional

库可用于最终二进制文件或仅在运行时测试。与普通类似deps，这些将出现在运行时类路径中，但与它们不同，不在编译时类路径上。应在此处列出仅在运行时所需的依赖关系。依赖性分析工具应该忽略出现在两个目标 runtime_deps和deps。
stamp	
Integer; optional; default is 0

启用链接标记。是否将构建信息编码为二进制文件。可能的值：
stamp = 1：将构建信息标记到二进制文件中。只有在依赖项发生变化时才会重建标记的二进制文件。如果存在依赖于构建信息的测试，请使用此选项。
stamp = 0：始终使用常量值替换构建信息。这提供了良好的构建结果缓存。
stamp = -1：嵌入构建信息由 - [no]戳标志控制。
test_class	
String; optional

由测试运行器加载的Java类。
默认情况下，如果未定义此参数，则使用传统模式并使用测试参数。将--nolegacy_bazel_java_test标志设置为不在第一个参数上回退。

此属性指定此测试要运行的Java类的名称。很少需要设置它。如果省略此参数，则将使用目标name及其source-root-relative路径推断出该参数。如果测试位于已知源根目录之外，则Bazel将报告错误（如果test_class 未设置）。

对于JUnit3，测试类需要是子类， junit.framework.TestCase或者需要有一个suite()返回junit.framework.Test（或子类Test）的公共静态方法 。对于JUnit4，该类需要注释 org.junit.runner.RunWith。

此属性允许多个java_test规则共享相同的Test （TestCase，TestSuite，...）。通常将附加信息传递给它（例如通过jvm_flags=['-Dkey=value']），以便其行为在每种情况下都不同，例如运行不同的测试子集。此属性还允许在javatests树外使用Java测试。

toolchains	
List of labels; optional

提供“Make variables”的工具链集 ，该目标可以在其某些属性中使用。一些规则具有工具链，其默认情况下可以使用Make变量。
use_testrunner	
Boolean; optional; default is True

使用测试运行器（默认情况下 com.google.testing.junit.runner.BazelTestRunner）类作为Java程序的主入口点，并将测试类作为bazel.test_suite 系统属性的值提供给测试运行器。您可以使用它来覆盖默认行为，即使用测试运行器获取 java_test规则，而不是将其用于java_binary规则。你不太可能想要这样做。一种用途是用于AllTest 由另一个规则调用的规则（例如，在运行测试之前设置数据库）。该AllTest 规则必须被声明为java_binary，但仍应使用测试运行器作为其主要入口点。可以使用main_classattribute 覆盖测试运行器类的名称。

java_package_configuration 
java_package_configuration（name，data，compatible_with，deprecation，distribs，features，javacopts，licenses，packages，restricted_to，tags，testonly，visibility）
要应用于一组包的配置。配置可以添加到 java_toolchain.javacoptss。

例：

```
java_package_configuration（
    name =“my_configuration”，
    packages = [“：my_packages”]，
    javacopts = [“ -  Werror”]，
）

package_group（
    name =“my_packages”，
    包裹= [
        “// COM /我/项目/ ...”
        “ -  // COM /我/项目/测试/ ...”
    ]
）

java_toolchain（
    ...
    package_configuration = [
        “：my_configuration”
    ]
）

```

参数
属性
name	
Name; required

此目标的唯一名称。

data	
List of labels; optional

此配置在运行时所需的文件列表。
javacopts	
List of strings; optional

Java编译器标志。
packages	
List of labels; optional

package_group应该应用配置 集。

java_plugin 
java_plugin（name，deps，srcs，data，resources，compatible_with，deprecation，distribs，exec_compatible_with，features，generate_api，javacopts，licenses，neverlink，output_licenses，plugins，processor_class，proguard_specs，resource_jars，resource_strip_prefix，restricted_to，tags，testonly，能见度）
java_plugin为Bazel运行的Java编译器定义插件。目前，唯一受支持的插件类型是注释处理器。A java_library或 java_binary规则可以通过plugins 属性依赖于它们来运行插件。A java_library还可以自动将插件导出到直接依赖它的库 exported_plugins。

隐含的输出目标
libname.jar：Java存档。
java_library除了添加processor_class参数外， 参数与之相同。

参数
属性
name	
Name; required

此目标的唯一名称。

deps	
List of labels; optional

要链接到此库的库列表。看到一般的评论deps在 共同所有的生成规则属性 。
由java_library列出的规则构建的jar deps将位于此规则的编译时类路径中。此外，它们的传递闭包 deps，runtime_deps并将exports在运行时类路径上。

相比之下，data属性中的目标包含在运行文件中，但既不包含在编译时也不包含在运行时类路径中。

srcs	
List of labels; optional

处理以创建目标的源文件列表。几乎总是需要此属性; 看下面的例外。
.java编译 类型的源文件。在生成.java文件的情况下， 通常建议在此处放置生成规则的名称，而不是文件本身的名称。这不仅提高了可读性，而且使规则对未来的更改更具弹性：如果生成规则将来生成不同的文件，您只需要修复一个地方：outs生成规则。您不应该列出生成规则，deps 因为它是无操作。

类型的源文件.srcjar被解压缩和编译。（如果您需要生成一组.java带有genrule 的文件，这非常有用。）

规则：如果规则（通常genrule或filegroup）生成上面列出的任何文件，它们将以与源文件所述相同的方式使用。

除非main_class属性指定运行时类路径上的类或指定runtime_deps参数，否则几乎总是需要 此参数。

data	
List of labels; optional

此库在运行时所需的文件列表。看到一般的评论data在 共同所有的生成规则属性 。
在构建时java_library，Bazel不会将这些文件放在任何地方; 如果 data文件是生成文件，那么Bazel会生成它们。构建依赖于此java_libraryBazel 的测试时，data会将文件复制或链接 到runfiles区域。

resources	
List of labels; optional

要包含在Java jar中的数据文件列表。
如果指定了资源，它们将与.class编译生成的常用文件一起捆绑在jar中 。jar文件中资源的位置由项目结构决定。Bazel首先查找Maven的 标准目录布局，（“src”目录后跟“资源”目录孙子）。如果找不到，那么Bazel会查找名为“java”或“javatests”的最顶层目录（例如，如果资源处于&amp;lt;workspace root&amp;gt;/x/java/y/java/z，则资源的路径将是y/java/z。此启发式扫描不能被覆盖。

资源可以是源文件或生成的文件。

generates_api	
Boolean; optional; default is False

此属性标记生成API代码的注释处理器。
如果规则使用API 生成注释处理器，则只有在生成规则之后调度其编译操作时，依赖于它的其他规则才能引用生成的代码。当启用了--java_header_compilation时，此属性指示Bazel引入调度约束。

警告：此属性会影响构建性能，仅在必要时使用它。

javacopts	
List of strings; optional

此库的额外编译器选项。受“Make变量”替换和 Bourne shell标记化的约束。
这些编译器选项在全局编译器选项之后传递给javac。

neverlink	
Boolean; optional; default is False

此库是仅应用于编译而不是用于运行时。如果库将在执行期间由运行时环境提供，则很有用。此类库的示例是IDE插件的IDE API或tools.jar标准JDK上运行的任何内容。
请注意，neverlink = 1这不会阻止编译器将此库中的材料内联到依赖于它的编译目标中，如Java语言规范所允许的那样（例如， 原始类型的static final常量String或常量类型的常量）。因此，当运行时库与编译库相同时，首选用例是。

如果运行时库与编译库不同，则必须确保它仅在JLS禁止编译器内联的位置（并且必须适用于JLS的所有未来版本）中有所不同。

output_licenses	
Licence type; optional

看到 common attributes
plugins	
List of labels; optional

Java编译器插件在编译时运行。java_plugin无论何时构建此规则，都将运行此属性中指定的每个属性。库也可以从使用的依赖项继承插件 exported_plugins。插件生成的资源将包含在此规则的结果jar中。
processor_class	
String; optional

处理器类是Java编译器应该用作注释处理器入口点的类的完全限定类型。如果未指定，此规则将不会为Java编译器的注释处理提供注释处理器，但其运行时类路径仍将包含在编译器的注释处理器路径中。（这主要供 Error Prone插件使用，它使用 java.util.ServiceLoader从注释处理器路径加载 。）
proguard_specs	
List of labels; optional

用作Proguard规范的文件。这些将描述Proguard使用的规范集。如果指定，它们将android_binary根据此库添加到任何目标。此处包含的文件必须只有幂等规则，即-dontnote，-dontwarn，assumenosideeffects和以-keep开头的规则。其他选项只能出现在 android_binaryproguard_specs中，以确保非重言式合并。
resource_jars	
List of labels; optional

包含Java资源的档案集。
如果指定，这些jar的内容将合并到输出jar中。

resource_strip_prefix	
String; optional

从Java资源中剥离的路径前缀。
如果指定，则从resources 属性中的每个文件中剥离此路径前缀。资源文件不在此目录下是错误的。如果未指定（默认值），则根据与源文件的Java包相同的逻辑确定资源文件的路径。例如，源文件 stuff/java/foo/bar/a.txt位于foo/bar/a.txt。
java_runtime 
java_runtime（name，srcs，compatible_with，deprecation，distribs，features，java，java_home，licenses，restricted_to，tags，testonly，visibility）
指定Java运行时的配置。

例：

```
java_runtime（
    name =“jdk-9-ea + 153”，
    srcs = glob（[“jdk9-ea + 153 / **”]），
    java_home =“jdk9-ea + 153”，
）

```

参数
属性
name	
Name; required

此目标的唯一名称。

srcs	
List of labels; optional

运行时中的所有文件。
java	
Label; optional

java可执行文件的路径。
java_home	
String; optional

运行时根目录的路径。受“制造”变量替代。如果此路径是绝对路径，则该规则表示具有众所周知路径的非密集Java运行时。在那种情况下，srcs和 属性必须为空。
java_toolchain 
java_toolchain（名称，启动类路径，compatible_with，折旧，发行商，extclasspath，功能，forcibly_disable_header_compilation，genclass，header_compiler，header_compiler_direct，ijar，jacocorunner，javabuilder，javabuilder_jvm_opts，javac的，javac_supports_workers，javacopts，jvm_opts，许可证，oneversion，oneversion_whitelist，package_configuration，resourcejar，restricted_to，singlejar，source_version，tags，target_version，testonly，timezone_data，tools，visibility，xlint）
指定Java编译器的配置。可以通过--java_toolchain参数更改要使用的工具链。通常，除非要调整Java编译器，否则不应编写这些规则。

例子
一个简单的例子是：

```
java_toolchain（
    name =“toolchain”，
    source_version =“7”，
    target_version =“7”，
    bootclasspath = [“// tools / jdk：bootclasspath”]，
    xlint = [“classfile”，“divzero”，“empty”，“options”，“path”]，
    javacopts = [“ -  g”]，
    javabuilder =“：JavaBuilder_deploy.jar”，
）

```

参数
属性
name	
Name; required

此目标的唯一名称。

bootclasspath	
List of labels; optional

Java目标bootclasspath条目。对应于javac的-bootclasspath标志。
extclasspath	
List of labels; optional

Java目标extdir条目。对应于javac的-extdir标志。
forcibly_disable_header_compilation	
Boolean; optional; default is False

覆盖--java_header_compilation以在不支持它的平台上禁用标头编译，例如JDK 7 Bazel。
genclass	
List of labels; required

GenClass部署jar的标签。
header_compiler	
List of labels; optional

标头编译器的标签。如果启用了--java_header_compilation，则为必需。
header_compiler_direct	
List of labels; optional

标头编译器的可选标签，用于不包含任何API生成注释处理器的直接类路径操作。
此工具不支持注释处理。

ijar	
List of labels; required

ijar可执行文件的标签。
jacocorunner	
Label; optional

JacocoCoverageRunner部署jar的标签。
javabuilder	
List of labels; required

JavaBuilder部署jar的标签。
javabuilder_jvm_opts	
List of strings; optional

调用JavaBuilder时JVM的参数列表。
javac	
List of labels; optional

javac jar的标签。
javac_supports_workers	
Boolean; optional; default is True

如果JavaBuilder支持作为持久性工作程序运行，则为True，否则为false。
javacopts	
List of strings; optional

Java编译器的额外参数列表。有关可能的Java编译器标志的详尽列表，请参阅Java编译器文档。
jvm_opts	
List of strings; optional

调用Java编译器时JVM的参数列表。有关此选项的可能标志的详细列表，请参阅Java虚拟机文档。
oneversion	
Label; optional

单版本强制二进制文件的标签。
oneversion_whitelist	
Label; optional

单版本白名单的标签。
package_configuration	
List of labels; optional

应该应用于指定包组的配置。
resourcejar	
List of labels; optional

资源jar构建器可执行文件的标签。
singlejar	
List of labels; required

SingleJar部署jar的标签。
source_version	
String; optional

Java源代码版本（例如，'6'或'7'）。它指定Java源代码中允许哪组代码结构。
target_version	
String; optional

Java目标版本（例如，'6'或'7'）。它指定应该为哪个Java运行时构建类。
timezone_data	
Label; optional

包含时区数据的资源jar的标签。如果设置，则时区数据将作为所有java_binary规则的隐式运行时依赖项添加。
tools	
List of labels; optional

可用于jvm_opts中标签扩展的工具标签。
xlint	
List of strings; optional

要添加或从默认列表中删除的警告列表。用破折号在它之前删除它。有关更多信息，请参阅-Xlint选项上的Javac文档。

