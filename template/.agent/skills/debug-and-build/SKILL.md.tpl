---
name: debug-and-build
description: Guidelines and tools for debugging, building the project, and rapidly scaffolding new code components using tipsy.
version: 1.0.0
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

## Rapid Code Scaffolding with Tipsy

[Tipsy](https://github.com/YianAndCode/tipsy) is a command-line interface that helps you work with the Gin framework and quickly generate code skeletons (boilerplates) for various components.

### Generating Code Skeletons

Whenever you need to create a new module, controller, service, repository, or other components, you should **proactively use `tipsy`** to generate the initial structure rather than creating folders and files manually.

The `tipsy new --help` command lists the available commands:

```text
Create a new component for your Gin project.
        Supported types: entity, repo, controller, middleware, service
        For example:
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


### Installation

If `tipsy` is not installed or available in your environment, you can install it using:

```sh
go install github.com/YianAndCode/tipsy/cmd/tipsy@latest
```
