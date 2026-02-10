---
name: debug-and-build
description: Some tools for debugging and building. Use when you need to debug or build the project.
---

# Debug and Build Skill

## Makefile (Mandatory)

The project uses a `Makefile` to streamline common tasks. **You MUST prioritize the `Makefile` over direct Go commands.**

### Strict Guidelines:

1. **Makefile First**: Before performing any build, format, or generation task, you **MUST** check if a corresponding target exists in the `Makefile`.
2. **Forbidden Commands**: If a `Makefile` target exists, you are **FORBIDDEN** from using direct commands like `go build`, `go fmt`, `go mod tidy`, or `wire`.
3. **Self-Check**: During the first verification phase of any task, you **MUST** read the `Makefile` to identify the correct entry points.

### Common Commands:

 - `make api`: Builds the API server.
 - `make fmt`: Formats the codebase using `go fmt`.
 - `make wire`: Generates dependency injection code using Wire.
 - `make tidy`: Cleans up the project directory by removing unnecessary files.

## tipsy

[Tipsy](https://github.com/YianAndCode/tipsy) is command line interface helps you work with the gin framework.

The `tipsy --help` command will show you a list of available commands:

```text
Create a new component for your Gin project.
        Supported types: app, entity, repo, controller, middleware, service
        For example:
          tipsy new app User
          tipsy new entity User
          tipsy new repo User
          tipsy new controller UserController
          tipsy new middleware Auth
          tipsy new service UserService

Usage:
  tipsy new [type] [name] [flags]

Flags:
  -h, --help   help for new
```

If you don't have `tipsy` installed, you can install it by running:

```sh
go install github.com/YianAndCode/tipsy/cmd/tipsy@latest
```
