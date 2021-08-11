---
title: docker相关命令
date: 2021-08-10 15:15:16
tags: [docker,远程配置]
categories: docker
---

>简要介绍Docker，记录Docker常用命令使用方法。
>
>搬运自师兄的博客 又见苍岚 ：https://www.zywvvd.com/2020/05/06/docker/docker_usage/

### Docker 简介

> **Docker 属于 Linux 容器的一种封装，提供简单易用的容器使用接口。**Docker 将应用程序与该程序的依赖，打包在一个文件里面。运行这个文件，就会生成一个虚拟容器。程序在这个虚拟容器里运行，就好像在真实的物理机上运行一样。有了 Docker，就不用担心环境问题。

### Docker 使用流程

- [安装docker](https://docs.docker.com/desktop/)
- 创建Image
- 从Image创建Container
- 在Container中工作
- 将在Container中做的修改提交给Image
- 销毁Container

### 命令介绍

- 拉取 image

```
docker image pull [docker-url]
```

- 获取docker images 列表

```
docker images
或
docker image ls
```

- 建立container （nvidia docker)

```
NV_GPU=[gpu_num] nvidia-docker run -it --name [container_name] --shm-size=[shm_size] --rm -v [current_dir]:[container_dir] -p [current_port]:[container_port] [image_name]:[image_tag]  [command] 
```
实例：
```
nvidia-docker run -it --name mlfan --shm-size=10g -v /disk/fanmeilin:/workspace/fanmeilin -p 12345:22 -p 12346:8080 -p 12347:5678 tf-1.14-2.0-2.1:1.0 bash
```
<font color=SlateBlue size=4>注意不要加 --rm  否则载在container stop之后会自动删除此容器</font>

> NV_GPU: container中可见的GPU，如果不设置可见所有GPU
>
> -it: 将容器的 Shell 映射到当前的 Shell，然后你在本机窗口输入的命令，就会传入容器
>
> –name: 容器名称，如果不设置会随机分配一个名字
>
> –shm-size: 容器共享内存大小设置。如果不设置默认大小64M，对于需要使用共享内存的情况往往是不够用的，如果设置为10g，这样配置： `--ssh-size="10g"`
>
> –rm: 容器关闭后自动删除，如果不设置容器不会自动删除
>
> -v: 驱动器映射，将本机的目录映射到容器的指定文件夹中；需要说明的是，在主机文件夹中的挂载目录在容器中是可见的；需要再说明的是容器启动时主机挂载的目录容器是见不到的；最后说明，容器关闭再打开就可以看到主机挂载的所有文件夹了。
>
> -p: 暴漏容器的端口到本机的端口上，例如用于ssh连接容器时需要将容器的22端口暴露到主机的端口上(比如3721)，则可以设置 `-p 3721:22`
>
> image_name, image_tag: 这是docker镜像的名称与标记，如果使用本机镜像可以在docker images列表中查询到
>
> command: 启动容器后内部执行的第一个命令，一般为 `/bin/bash`

- 查询container列表

```
docker container ls --all
```

> –all: 加上该参数会显示没有在运行的容器，不加的话仅显示运行中的容器

- 停止指定的容器运行

```
docker container kill [containerID]
docker stop [containerID]
```

> `docker container kill`命令终止容器运行，相当于向容器里面的主进程发出 SIGKILL 信号。`docker container stop`命令相当于向容器里面的主进程发出 SIGTERM 信号，然后过一段时间再发出 SIGKILL 信号。

- 启动停止的容器

```
docker start [containerID]
```

- 重启运行的容器

```
docker restart [containerID]
```

- 删除指定的容器文件（仅在停止运行时可用）

```
docker container rm [containerID]
```

- 查看容器输出

```
docker container logs [containerID]
```

- 启动容器的一个终端

```
docker exec -it [containerID] /bin/bash
```

> 此种方法启动的终端，即使退出也不会关闭容器
>
> 相反 - 如果直接通过端口映射连接 docker 建立的ssh链接，窗口退出后该终端的工作也会一同停止

- 进入容器的主终端

```
docker attach [containerID]
```

> 连接到容器的主终端，该终端退出后容器关闭。
>
> 如果不希望退出后关闭，可以加入选项 `--sig-proxy=false`

- 退出终端

```
ctrl p + ctrl q
```

> 可以在退出终端的同时保持终端继续工作

- 退出容器

```
exit
```

> 在容器中运行此命令

- 拷贝容器里的文件到本机

```
docker container cp [containerID]:[/path/to/file]
```

- 提交容器修改到镜像

```
docker commit -a [name] -m [comments] -p  [containerID[:TAG]]
```

> -a: 提交的镜像作者
>
> -m: 提交时的说明文字
>
> -p: 在commit时，将容器暂停

- 删除镜像

```
docker rmi [image]
```

> 或

```
docker image rm [image]
```

> 支持的子命令如下：

- `-f, -force`: 强制删除镜像，即便有容器引用该镜像；
- `-no-prune`: 不要删除未带标签的父镜像；

### 参考资料

- http://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html
- https://www.runoob.com/docker/docker-tutorial.html
