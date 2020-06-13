title: js读取文件内容
author: Joe Tong
tags:
  - JAVASCRIPT 
categories:  
  - IT 
date: 2019-11-08 12:49:49 
---

流程只用两步：

用file类型的input载入文件；
用HTML5的FileReader方法读取文件内容。
如下是一个js读取文件内容到文本框的方法。

1 演示
点击查看演示地址。

2 HTML代码
页面有两个元素，file类型的input，和显示内容的textarea文本框。
```
<input type="file" name="upload" id="upload" accept="text/plain"/>
<textarea name="content" id="content"></textarea>
```
3 JS代码
Javasctipt代码有两段，读取文件内容的getFileContent()函数，和响应文件上传的事件：
```
<script type="text/javascript">
    window.onload = function() {
        /**
         * 上传函数
         * @param fileInput DOM对象
         * @param callback 回调函数
         */
        var getFileContent = function (fileInput, callback) {
            if (fileInput.files && fileInput.files.length > 0 && fileInput.files[0].size > 0) {
                //下面这一句相当于JQuery的：var file =$("#upload").prop('files')[0];
                var file = fileInput.files[0];
                if (window.FileReader) {
                    var reader = new FileReader();
                    reader.onloadend = function (evt) {
                        if (evt.target.readyState == FileReader.DONE) {
                            callback(evt.target.result);
                        }
                    };
                    // 包含中文内容用gbk编码
                    reader.readAsText(file, 'gbk');
                }
            }
        };

        /**
         * upload内容变化时载入内容
         */
        document.getElementById('upload').onchange = function () {
            var content = document.getElementById('content');

            getFileContent(this, function (str) {
                content.value = str;
            });
        };
    };
</script>
```
3 代码说明
FileReader() 对象提供了一些方法，可以将本地文件读取到内存中。

|方法名|	参数|	描述|
|:--|:--|:--|
|abort|	none|	中断读取|
|readAsBinaryString|	file|	将文件读取为二进制码|
|readAsDataURL|	file|	将文件读取为 DataURL|
|readAsText	|file, [encoding]|	将文件读取为文本，编码方式默认为“UTF-8”，支持可改用“GBK”|

**后面三个方法第一个参数传入File对象或者Blob对象。**

readAsText：该方法有两个参数，其中第二个参数是文本的编码方式，默认值为 UTF-8，要支持中文要改为GBK。将文件以文本方式读取，读取的结果即是这个文本文件中的内容。

readAsBinaryString：该方法将文件读取为二进制字符串，通常我们将它传送到后端，后端可以通过这段字符串存储文件。

readAsDataURL：该方法将文件读取为一段以 data: 开头的字符串，这段字符串的实质就是 Data URL，这是一种将小文件直接嵌入文档的方案。这里的小文件通常是指图像与 html 等格式的文件。

如果要下载页面内容到本地文件，请看这一篇：Javascript实现文件形式下载页面内容。

 
