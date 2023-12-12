---
title: 压缩wsl2的磁盘
categories:
- article
---

<!-- more -->
1. shuwdown wsl
```bash
wsl --shutdown
```

2. find out wsl file location
一般情况下wsl文件位于：C:\Users\Administrator\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\ext4.vhdx

3. 备份wsl
```bash
wsl --export name target_file

```
name可以通过`wsl -l`命令进行查看

4. 运行diskpart
```bash
select vdisk file="your location"
compact vdisk

```
