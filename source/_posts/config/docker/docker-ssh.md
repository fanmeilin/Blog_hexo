---
title: docker的ssh相关配置
tags: [docker,远程配置,ssh]
categories: [配置,docker]
date: 2021-08-10 17:07:14
---

>参考师兄博客：https://www.zywvvd.com/2020/11/02/windows/win_ssh_linux_docker/win_ssh_linux_docker/

> ssh是较可靠，专为远程登录会话和其他网络服务提供安全性的协议，广泛用于远程登录的场景，也是远程调试代码的神兵利器。在开发中经常会在服务器启动自己的 docker 容器进行开发，又需要调试代码，vim的调试环境配置起来门槛又太高。于是就有了使用Windows直接ssh打通docker进行调试的需求。本文记录Windows远程登录Linux服务器docker容器的方法。

## 环境说明

- 登录主机操作系统 Win 10
- 被登录主机操作系统 docker container in Linux
- 主机与被登录主机（此处指服务器，不是docker）网络联通，IP在同一网段
- 服务器与docker的IP在同一网段

## 配置方法

### 建立docker与Linux服务器的端口映射

> ssh协议链接时默认使用22端口，Windows与docker的端口往往不能直接进行映射（很可能不在一个网段），因此需要将docker的22端口映射到Linux服务器的某个端口，此时需要在建立docker容器时进行[配置](https://www.zywvvd.com/2020/05/14/coding/environment/wingide-remote-docker/wingide-remote-docker/#docker配置)：

```
$ docker run -it --name vvd -p 3721:22 -v /root/tmp:/root/tmp my_docker bash
```

- 其中 `-p` 的部分表示将本机（服务器）的3721端口映射到容器的22端口。

### 容器内部安装ssh服务

> 需要在被登录的容器内部建立并启动ssh服务。

- 首先需要安装：

```
apt-get update
apt-get install openssh-server
apt-get install openssh-client
```

- 安装完成后需要容器每次启动时自动运行相关服务，可以在 `~/.bashrc`中加入：

```
/etc/init.d/ssh start
```

> 这样就保证了docker容器自动启动该服务。

- 查看ssh运行状态

```
/etc/init.d/ssh status
```

> 如果是 `* sshd is running` 说明ssh正常运行

### 修改容器内root用户登录设置

> 有的容器默认不支持root用户远程使用ssh协议进行密码登录的，此时需要更改设置。

- 打开 `/etc/ssh/sshd_config`文件：

```
# PermitRootLogin prohibit-password # 默认打开 禁止root用户使用密码登陆，需要将其注释
RSAAuthentication yes #启用 RSA 认证
PubkeyAuthentication yes #启用公钥私钥配对认证方式
PermitRootLogin yes #允许root用户使用ssh登录
```

- 将 `PermitRootLogin` 设置为 yes

### 修改root密码

> 远程登录时需要使用系统的用户密码，我们就直接使用root用户登录好了，需要设置新建容器的密码：

```
passwd root
```

### 设置SSH

- [本地生成ssh key](https://www.zywvvd.com/2020/02/23/git/link_github/Git-connect-remote-pos/#创建SSH密钥)
- 将.pub 内容复制粘贴加入到远程 ~/.ssh/authorized_keys

### SSH连接服务器

> 需要用户名（被登录端用户）与被登录的主机ip和端口号
>
> 例如： 用户名- root ip：192.168.10.12 端口映射为 3721

- linux

```
ssh root@192.168.10.12:3721
```

- Windows

```
ssh -p 3721 root@192.168.10.12
```

![](https://photos.zywvvd.com/images_matrixtime/20201102200256.png)

- 如果不清楚Linux系统端口映射配置情况：

```
iptables -t nat -L -n
```

### X-shell配置

> 命令行ssh登录成功后就可以在X-shell中建立配置信息方便地连接了。

- 新建会话，填写名称、IP、端口号（我们刚刚配置过的）：

![](https://photos.zywvvd.com/images_matrixtime/20201102200522.png)

- 用户身份认证，填入用户名密码（刚刚配置过的）：

![](https://photos.zywvvd.com/images_matrixtime/20201102200640.png)

- 随后就可以使用该会话直接登录docker容器了，为远程调试打下了坚实的基础：

![](https://photos.zywvvd.com/images_matrixtime/20201102200804.png)

### 填坑

- ssh: Could not resolve hostname 192.168.10.12:3721: Name or service not known

  > 这是在Windows中使用了Linux格式的SSH登录命令导致的解析错误
  >
  > 将命令语法更换为Windows的格式即可

- root 用户无论如何密码不被接受

  > 需要在被登录主机 /etc/ssh/sshd_config 中设置：
  >
  > ```
  > # PermitRootLogin prohibit-password # 默认打开 禁止root用户使用密码登陆，需要将其注释
  > RSAAuthentication yes #启用 RSA 认证
  > PubkeyAuthentication yes #启用公钥私钥配对认证方式
  > PermitRootLogin yes #允许root用户使用ssh登录
  > ```
  >
  > - 重点：**PermitRootLogin yes**

- Connection to 192.168.10.12 closed.

- 或

- Connection closed by foreign host.

  > 意思是 断开主机链接了，出现这种问题，跟你的IPTABLES，防火墙什么的都没关系。
  >
  > 造成这个原 因是因为原来连接到SSHD服务器进程的22端口，当你的客户端突然断开时，服务器端的TCP连接就处于一个半打开状态。当下一次同一客户机再次建立 TCP连接时，服务器检测到这个半打开的TCP连接，并向客户机回传一个置位RST的TCP报文，客户机就会显示connection closed by foreign host。
  > 这是TCP协议本身的一个保护措施，并不是什么错误，你只要再重新连接服务器就能连上。
  >
  > ——— http://www.pooy.net/connection-closed-foreign-host.html
  >
  > 总结一下解决方案： **关机重启**

### 关于ssh的相关配置

#### 修改配置文件

```
cd /etc/ssh
vi ssh_config #可设置ssh的默认端口（22）
vi sshd_config
```

ssh_config和sshd_config都是ssh服务器的配置文件，二者区别在于，前者是针对客户端的配置文件，后者则是针对服务端的配置文件。两个配置文件都允许你通过设置不同的选项来改变客户端程序的运行方式。

#### 重启ssh服务

```
service sshd restart
```

如果报错 sshd: unrecognized service 则需要开启ssh服务。

```
/etc/init.d/ssh start
```

## vscode连接远程服务器

- 正确的ssh服务

- 密码设置完成（passwd root）

### 安装插件

- 安装 Remote Development 插件

  > 会自动安装 Remote-WSL / Containers / SSH 等插件。

![](https://photos.zywvvd.com/images_matrixtime/20201028143530.png)

### 配置主机信息

> ctrl + shift + p

![](https://photos.zywvvd.com/images_matrixtime/20201028174129.png)

![](https://photos.zywvvd.com/images_matrixtime/20201028175152.png)

```
Host Enter
  HostName 192.168.10.15
  Port 12345
  User root
  IdentityFile ~\.ssh\id_rsa
  IdentitiesOnly yes
```

### vs code 连接远程主机

![](https://photos.zywvvd.com/images_matrixtime/20201028175324.png)

> 之后选择目标主机的操作系统。

- 成功连接到远程主机：

- 打开文件夹运行程序时，选择使用的Python环境：

#### 相对路径的设置

在读取文件时，可能使用相对路径出现错误。

> python 插件设置中没有设置`终端执行命令时使用文件的路径代替现在打开的目录`。

### 解决方案

- 搜索配置 `execute in file`：

![](https://photos.zywvvd.com/win11-mt/20210717114300.png)
