# tipsy

`tipsy` is command line interface helps you work with the gin framework

English | [简体中文](README-zh.md)

## Introduction

Tipsy is a command-line tool written in Go for Gin framework projects. Similar to Laravel's `artisan`, it can initialize a new Gin project and quickly generate various components like entities, repositories, controllers, middlewares, and services.

## Installation

```bash
go install github.com/YianAndCode/tipsy/cmd/tipsy@latest
```

## Usage

### Create a new project

To create a new Gin project:

```bash
tipsy create <project-name>
```

This command will generate a well-structured Gin project with the following directory layout:

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

### Generate components

Tipsy provides several commands to generate different components:

1. Create a new entity:
```bash
tipsy new entity <entity-name>
```

2. Create a new repo:
```bash
tipsy new repo <repo-name>
```

3. Create a new controller:
```bash
tipsy new controller <controller-name>
```

4. Create a new middleware:
```bash
tipsy new middleware <middleware-name>
```

5. Create a new service:
```bash
tipsy new service <service-name>
```

Each command will generate the corresponding Go source files with proper structure and basic implementations.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

