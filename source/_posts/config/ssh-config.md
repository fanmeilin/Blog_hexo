---
title: 远程服务器配置--vscode及本地查看tensorboardx
tags: [配置]
categories: [配置]
date: 2022-06-27 17:16:07
---

> https://zhuanlan.zhihu.com/p/425641299

### vscode配置ssh

- 打开vscode，在扩展里搜一下remote-ssh进行一键安装。

- 打开远程链接，输入入IP地址，修改配置文件即可。

```
Host PET
  HostName 27.17.30.150
  Port 20401
  User dpet
```

### vscode设置默认参数

1. 点击Run
2. 选择Python编译环境
3. 点击添加配置
4. 打开launch.json
5. 添加如下代码：

```
{
    // 使用 IntelliSense 了解相关属性。 
    // 悬停以查看现有属性的描述。
    // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "MTCBD_mergedata/train_NUnetSkip.py",
            "console": "integratedTerminal",
            "args": [
                "--root_path",
                "./datasets/fivek_bsd_train",
                "--Rroot_path",
                "./datasets/SIDD_train",
                "--Vroot_path",
                "./datasets/SIDD_valnew",
                "--max_iterations",
                "100000",
                "--batch_size",
                "32",
                "--labeled_bs",
                "21",
                "--base_lr",
                "0.0002",
            ],
            "env": {
                "CUDA_VISIBLE_DEVICES": "0"
            },
            "justMyCode": true
        }
    ]
}
```

### 查看tensorboardX

#### 本地cmd输入命令

```
ssh -L 16006:127.0.0.1:6006 dpet/root@27.17.30.150 -p 20401
或者
ssh -L 16006:127.0.0.1:6006 dpet/root@27.17.30.150 -p 20401 -N -v -v
```

#### 服务器端输入命令

```
tensorboard --logdir=log --port=6006
```

浏览器打开http://localhost:16006 就可以查看图像信息了。

#### 查看GPU占用情况

```
watch -n 0.1 nvidia-smi #每0.1秒更新展示
```

