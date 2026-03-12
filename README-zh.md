# tipsy

`tipsy` 是一个辅助你使用 Gin 框架做开发的命令行工具

[English](README.md) | 简体中文

## 简介

Tipsy 是一个使用 Go 编写的用于 Gin 框架项目的命令行工具。类似于 Laravel 的 `artisan`，它可以初始化一个新的 Gin 项目，并快速生成各种组件，如数据库实体、存储层、控制器、中间件和服务。

## 安装

```bash
go install github.com/YianAndCode/tipsy/cmd/tipsy@latest
```

## 使用方法

### 创建新项目

创建一个新的 Gin 项目：

```bash
tipsy create <project_name>
```

*（注：`<project_name>` 为必填项）*

这个命令将生成一个结构完善的 Gin 项目，目录结构如下：

```
.
├── cmd
│   └── api
│       └── bootstrap
└── internal
    ├── config
    ├── contract
    │   ├── constant
    │   │   └── errcode
    │   ├── datatype
    │   └── error
    ├── controller
    │   └── user
    ├── data
    ├── entity
    ├── log
    ├── middleware
    │   └── auth
    ├── repo
    │   └── user
    ├── router
    ├── server
    └── service
        └── user
```

### 生成组件

Tipsy 提供了多个命令来生成不同的组件。注意：在以下所有命令中，参数 `<name>` 均为**必填项**。

1. 创建新数据实体：

```bash
tipsy new entity <name>
```

2. 创建新仓储层：

```bash
tipsy new repo <name>
```

3. 创建新控制器：

```bash
tipsy new controller <name>
```

4. 创建新中间件：

```bash
tipsy new middleware <name>
```

5. 创建新服务：

```bash
tipsy new service <name>
```

每个命令都会生成相应的 Go 源文件。

## 开源许可

本项目采用 MIT 开源许可 - 查看 [LICENSE](LICENSE) 文件了解详情。