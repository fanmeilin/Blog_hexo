---
title: 常见的hexo问题记录和解决
tags: [报错解决]
categories: [报错解决]
date: 2022-05-22 16:37:13
---


## ⛄Hexo常见问题

### 👀问题一，hexo命令运行出错

**①问题描述**：运行Hexo报错hexo : 无法加载文件hexo.ps1，因为在此系统上禁止运行脚本

使用如下命令安装 `Hexo`成功：

```
PLAINTEXT
npm install hexo-cli -g
```

运行`hexo -v、hexo clean、hexo g、hexo s、hexo d`会出现错误：

```
PLAINTEXT
bashPS C:\Users\Desktop\heartlovelife> hexo s
hexo : 无法加载文件 C:\Users\AppData\Roaming\npm\hexo.ps1，因为在此系统上禁止运行脚本。有关详细信息，请参阅 https:/go.microsoft.com/fwlink/?LinkID
=135170 中的 about_Execution_Policies。
所在位置 行:1 字符: 1
+ hexo s
+ ~~~~
    + CategoryInfo          : SecurityError: (:) []，PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
```

**②解决方案**：针对`windows`系统，设置->隐私和安全性->开发者选项->允许本地`PowerShell`脚本在为签名的情况下运行。

### 👀问题二， `hexo init`初始化失败

**①问题描述**：`WARN Failed to install dependencies. Please run ‘npm install’ manually!`

**②解决方案**：如果我们输入命令`npm install`还是会出现错误，这时我们需要修改`npm`的镜像：

```
PLAINTEXT
bashnpm -v
# 修改镜像
npm install -g cnpm --registry=https://registry.npm.taobao.org
# 初始化
hexo init
# 利用cnpm执行cnpm install
cnpm install 
```

### 👀问题三，`hexo d`部署失败

**①问题描述**：`fatal: unable to auto-detect email address....`

```
PLAINTEXT
bashfatal: unable to auto-detect email address
error:src refspec HEAD does not match any
error:failed to push some refs to "*******"
FATAL {
	err:Error:Spawn failed
	.......
}
```

**②解决方案**：在文件浏览器中勾选显示隐藏的项目，进入我们的博客目录

```
PLAINTEXT
D:\Blog_Hexo\Blog\.deploy_git\.git
```

找到config文件，添加

```
PLAINTEXT

[user]
	email = 3086786161@qq.com
	name = HeartLoveLife
[core]
	repositoryformatversion = 0
	filemode = false
	bare = false
	logallrefupdates = true
	symlinks = false
	ignorecase = true
[branch "main"]
	remote = https://github.com/HeartLoveLife/HeartLoveLife.github.io.git
	merge = refs/heads/main
```

### 👀问题四，`hexo s`出现警告

**①问题描述**：`Accessing non-existent property '*' of module exports inside circular dependency`

```
PLAINTEXT

bashINFO  Start processing
INFO  Hexo is running at http://localhost:4000/ . Press Ctrl+C to stop.
(node:60224) Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency
(Use `node --trace-warnings ...` to show where the warning was created)
(node:60224) Warning: Accessing non-existent property 'column' of module exports inside circular dependency
(node:60224) Warning: Accessing non-existent property 'filename' of module exports inside circular dependency
(node:60224) Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency
(node:60224) Warning: Accessing non-existent property 'column' of module exports inside circular dependency
(node:60224) Warning: Accessing non-existent property 'filename' of module exports inside circular dependency
```

**②解决方案**：出现警告，是因为`node`版本太高，切换成低版本的`node`来安装`Hexo`就可以了

## ⛄Hexo更换主题

在博客的项目文件夹下打开`git bash`执行命令，以`hexo-theme-butterfly`主题为例

```
PLAINTEXT
git clone -b master https://github.com/jerryc127/hexo-theme-butterfly.git themes/butterfly
```

运行成功之后，在项目文件夹`source`中可以查看到新的主题`themes`文件夹：`butterfly`

在博客的项目文件夹下，修改`_config.yml`配置文件如下:

```
YML
# theme: landscape  默认主题
theme: butterfly
```

此时主题还不能正常配置使用，需要安装`pug` 以及`stylus` 的渲染器:

```
PLAINTEXT
bash# npm install hexo-renderer-pug hexo-renderer-stylus --save
cnpm install hexo-renderer-pug hexo-renderer-stylus --save
```

执行`hexo s`部署到本地运行

```shell
PLAINTEXT
bash# 清除缓存b.json 和已生成的静态文件 public
hexo clean
# 生成静态页面到默认设置的 public 文件夹
hexo g
# 启动本地服务器，用于预览
hexo s
# 自动生成网站静态文件，并部署到设定的仓库或上传部署至服务端
hexo d
```

默认地址：

```shell
PLAINTEXT
http://localhost:4000/
```
