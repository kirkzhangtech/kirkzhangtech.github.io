---
title: Neovim
categories:
- neovim
date: 2022-10-30 13:58:59
thumbnailImagePosition: bottom
coverImage: https://user-images.githubusercontent.com/46363359/199011812-44a2e355-c72a-4252-bac9-37ecded0cb54.jpg
metaAlignment: center
coverMeta: out
---

> 官方文档: https://neovim.io/doc/user/

摘要: 后面具体学习时候再补充

## Neovim Installation

针对不同的平台直接在github上下载对应的版本的文件，然后直接解压放到`/usr/bin/nvim`

## Configuration

nvim的配置文件放在了`~/.config/nvim`目录下，创建`init.lua`文件和`lua`目录，在`lua`目录下放置你的配置文件，简单的`init.lua`入选所示
```lua
--[[ init.lua ]]

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ","
vim.g.localleader = "\\"

-- IMPORTS
-- require('vars')      -- Variables
-- require('opts')      -- Options
-- require('keys')      -- Keymaps
-- require('plug')      -- Plugins
```

## Set Variables

你的变量的可以放在`var.lua`文件中就可以进行全局变量的定义

## Manage plugins with Packer

here is list including more awesosme neovim [plugins](https://github.com/rockerBOO/awesome-neovim) 

where i installed the Packer at the `~/.config/nvim/`
