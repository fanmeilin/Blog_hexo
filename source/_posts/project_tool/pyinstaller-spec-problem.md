---
title: pyinstaller打包问题
tags: [项目打包]
categories: [工具,pyinstaller]
date: 2021-09-29 15:41:26
---

>在使用pyinstaller打包的过程中的坑点，记录一下
>参考大佬：https://blog.csdn.net/u012219045/article/details/115397646

```
在使用pyinstaller打包的整个过程中，遇到不少问题，在此总结一下。后面遇到会继续更新！

1. 在64下可运行，不能在32位下运行
   解决：在32位系统下打包，可以参考 https://blog.csdn.net/u012219045/article/details/115320619

2. RecursionError:maximum recursion depth
   解决：在xxx.spec文件开始增加两行：

    import sys
    sys.setrecursionlimit(5000)
再执行打包：pyinstaller xxx.spec 

3. UnicodeDecodeError:'utf-8' codec can't decode byte 0xce in position 122:invalid continuation byte
   解决：在你打包的命令行中先输入chcp 65001 然后再输入打包命令。

4. 使用了多进程 multiprocessing 模块
   解决：必须调用 multiprocessing.freeze_support()，直接在“if __name__ == '__main__'”之后调用

5. 打包PyQt5闪退
   原因：可能未找到某个文件
   解决办法：
        1. 把需要读取的文件及其其他资源 都放到dist中。
        2. 打包成exe的话，需使用 --add-data 附加。可参考：https://blog.csdn.net/u012219045/article/details/114841287

6. WARNING:file already exists but should not：_C.cp37-win_amd64
   解决：报错内容可能不同，但都是xxx已存在，问题的原因是pyinstaller打包时多打了一次，所以会报已经存在了。
   这个解决方案就是把多余的去掉。在自动生成的xxx.spec中，在 a 和 PYZ 中间添加如下代码，去掉多余依赖项

    for d in a.datas:
        if '_C.cp37-win_amd64' in d[0]:
            a.datas.remove(d)
            break
7. Hidden import "xxx"  not found!
    Hidden import "pkg_resources.markers" not found!
    Hidden import "pkg_resources.py2_warn" not found!
    Hidden import "MySQLdb" not found!
    Hidden import "sqlalchemy.sql.functions.func" not found!
    Hidden import "mx.DateTime" not found!
    解决： hiddenimports=['pkg_resources.markers', 'pkg_resources.py2_warn', '...']

8.  打包的时候出现了很多warning：lib not found...dll, 原因是pyinstaller 没有办法识别到这些dll
    解决办法：copy warning中一些dll文件的名字，再电脑中搜索到他们的路径！添加到环境变量里面
    WARNING:lib not found:msmpi.dll dependency of d:\programdata\anaconda3\Library\bin\mkl_blacs_msmpi_ilp64.dll
    WARNING:lib not found:impi.dll dependency of d:\programdata\anaconda3\Library\bin\mkl_blacs_intelmpi_lp64.dll
    WARNING:lib not found:msmpi.dll dependency of d:\programdata\anaconda3\Library\bin\mkl_blacs_msmpi_lp64.dll
    WARNING:lib not found:impi.dll dependency of d:\programdata\anaconda3\Library\bin\mkl_blacs_intelmpi_ilp64.dll
    WARNING:lib not found:mpich2mpi.dll dependency of d:\programdata\anaconda3\Library\bin\mkl_blacs_mpich2_lp64.dll
    WARNING:lib not found:mpich2mpi.dll dependency of d:\programdata\anaconda3\Library\bin\mkl_blacs_mpich2_ilp64.dll
    WARNING:lib not found:pgf90.dll dependency of d:\programdata\anaconda3\Library\bin\mkl_pgi_thread.dll
    WARNING:lib not found:pgf90rtl.dll dependency of d:\programdata\anaconda3\Library\bin\mkl_pgi_thread.dll
    WARNING:lib not found:pgc14.dll dependency of d:\programdata\anaconda3\Library\bin\mkl_pgi_thread.dll
    WARNING:lib not found:torch_python.dll dependency of d:\programdata\anaconda3\lib\site-packages\torch\_C.cp37-win_amd64.pyd

9. 切换了虚拟环境打包，报DLL无法导入，实际是打包时还在使用旧的虚拟环境
    解决： 打包时指定虚拟环境：-p。可参考： https://blog.csdn.net/u012219045/article/details/113612475

10. DecodeEncodeError
    解决： 检查执行路径中是否有中文，非Acsii码，换成英文路径。Python文件开头加 #-*-coding:utf-8-*-

11. Pyqt5 打包后会出现错误:"QThread:Destroyed while thread is still running"
    解决办法1：启动QThread使用了start(), 改为run() 可解决，但这样会卡主UI线程
    解决办法2：依然使用start()，再追加一句 exec()。推荐这样！

12. No module named 'sklearn.xx'
    43852 WARNING: Hidden import "sklearn.utils.sparsetools._graph_validation" not found!
    43854 WARNING: Hidden import "sklearn.utils.sparsetools._graph_tools" not found!
    43866 WARNING: Hidden import "sklearn.utils.lgamma" not found!
    No module named 'sklearn.utils._cython_blas'
    No module named 'sklearn.neighbors._typedefs'
    No module named 'sklearn.neighbors._quad_tree'
    No module named 'sklearn.tree'
    No module named 'sklearn.tree._utils'
    解决：hiddenimports=['sklearn', 'sklearn.tree', 'sklearn.tree._utils', 'sklearn.neighbors._quad_tree',
                       'sklearn.neighbors._typedefs', 'sklearn.utils._cython_blas',
                       'sklearn.utils.sparsetools._graph_validation',
                       'sklearn.utils.sparsetools._graph_tools', 'sklearn.utils.lgamma']
13. No module named 'scipy.special.cython_special'
   解决: 使用scipy==1.4.1 或者 --hidden-import scipy.special.cython_special

14. No such file or directory: 'xxx\\librosa\\util\\example_data\\registry.txt'
   解决: 使用--add-data或者直接拷贝librosa下的对应文件到dist。
   
15. fatal error:zmq.h:No such file or directory
    解决: sudo apt install libzmq3-dev

16. Error loading "xxx\torch\lib\caffe2_detectron_ops_gpu.dll" or one of its dependencies
    开始使用pytorch==1.6.0 torchvision==0.7.0 cudatoolkit=10.1，后来更换高版本torch1.7.0解决！
    # pip install torch===1.7.0+cu110 torchvision===0.8.1+cu110 torchaudio===0.7.0 -f https://download.pytorch.org/whl/torch_stable.html

17. unhandled exception 
    Error loading "xxx\torch\lib\caffe2_nvrtc.dll" or one of its dependencies
    开始使用pytorch降版本到1.8
```

