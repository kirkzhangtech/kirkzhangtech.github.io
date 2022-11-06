---
title: JuypterLab on wsl2
categories:
- archive
---
安装 Miniconda
```text
下载安装
# 下载
wget -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
# 安装
bash Miniconda3-latest-Linux-x86_64.sh
```
添加镜像
```text
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
```

安装 JupyterLab
第一步非常简单，命令如下
```shell
conda install -c conda-forge jupyterlab
```
关键是第二步，让 JupyterLab 自动打开宿主浏览器。打开配置文件jupyter_notebook_config.py。
```shell
vi ~/.jupyter/jupyter_notebook_config.py
```
修改下面这如下一行
```shell
c.NotebookApp.use_redirect_file = False
```
退回到主界面，在`~/.bashrc` 或`~/.zshrc`文件末尾添加，指定默认浏览器地址，其中，/mnt/之后的部分是你默认浏览器的在 Windows 上的地址
```shell
export BROWSER='/mnt/c/scoop/apps/firefox/current/firefox.exe'
```
使用source刷新后，就可以愉快地使用 Linux 版的 Python 了。