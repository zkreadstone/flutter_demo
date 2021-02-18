# flutter_demo

A new Flutter project.
 
 总结flutter 项目学习内容的demo
 1.富文本 解析和展示

示例文本“*asd*efg”
 原理简介：
 ①最先拆分行元素，一段文本，我们可以看成 有几段文本组成，这里分三类：普通段落、引用段落、代码段
 ②再遍历行元素 通过富文本特征字符或者特性拆分成一个一个子节点，这里子节点还不能算是行内元素，因为太碎了，还要组合
 ③通过特殊字符或者特殊特征来拆分文本，可以合并的子节点合并一下后生成[*,asd,*,efg] 
 ④然后利用正则，匹配上就解析成一个特殊节点，在通过各种节点的优先级优先匹配，逐级匹配，生成行内元素，例如：[[*,asd,*],[efg]] （[斜体node、文本node]）最后生成Document 

 结构：
 Document ： |-  Paragraph    ：Quote       ：FenceCode   ： InlineNode
             |                ：FenceCode                ： InlineNode
             |
             |
             |   Quote       ：FenceCode                 ： InlineNode
             |               
             |
             |
             |-  FenceCode                               ： InlineNode
