---
name: api-implementation-standard
description: Strict guidelines for implementing backend APIs. Enforces the 4-layer architecture (Controller, Application, Service, Repo), Wire dependency injection, naming conventions, and error handling patterns.
---

# API Implementation Standard Skill

When creating or updating an API, adhere to the following specifications:

## Strict Consistency & Patterns

1.  **Imitate Existing Code**: Before implementing any new feature or refactoring, you **MUST** read at least one existing implementation of the same layer (e.g., read `user_controller.go` before creating `package_controller.go`) to ensure identical naming patterns, error handling, and structural style.
2.  **Strict Layering**: Never skip a layer. Even for simple CRUD, maintain the Controller -> Application -> Service -> Repository flow to ensure architectural integrity.
3.  **Tag Verification**: When working with entities or repositories, always double-check `xorm` tags for typos (e.g., `xorm` vs `xrom`) and ensure they match the database schema precisely.

## Basic Structure

1.  **Controller**: Entry point for the API (Protocol layer).
2.  **Application**: Orchestrates business processes and manages transaction boundaries.
3.  **Service**: Contains core domain business logic.
4.  **Repository**: Handles data access.

### Naming Conventions

-   **Structs**: Must include the layer suffix: `Controller`, `App`, `Service`, or `Repo` (e.g., `UserController`, `UserApp`, `UserService`, `UserRepo`).
-   **Methods**: Must be concise and avoid redundant domain names already implied by the struct (e.g., use `UserService.Login` instead of `UserService.UserLogin`; use `UserRepo.GetByID` instead of `UserRepo.GetUserByID`).

### Controller

1.  **File Location**: Define a controller struct for each module. The file should be located at `internal/controller/<module>/<module>_controller.go`.
    -   **Naming**: The struct name should be the module name suffixed with `Controller` (e.g., `UserController`).
    -   **Dependency Injection**: Use Wire to inject application instances (or service instances for very simple logic) into the controller struct.

2.  **Wrapper Function**: Define a wrapper function for each API method. This function is used directly by the router.
    -   **Naming**: The name should match the API operation (e.g., `Login`).
    -   **Signature**: `func(*gin.Context) (any, error)` (matches `ControllerFunc`).
        -   *Note*: This is not a standard `gin.HandlerFunc`. It is adapted by `internal/controller/controller.go` (via the `Controller()` function) to handle `AppError` and return a standard `gin.HandlerFunc`.
    -   **Purpose**: The wrapper function performs a single task: calling the actual controller logic.

3.  **Controller Logic**: Define the actual controller logic in a private function.
    -   **Naming**: Same as the wrapper function but lowercase (e.g., `login`).
    -   **Signature**: `func(ctx *gin.Context) (*dto.<ResponseName>, error)`.
    -   **Responsibilities**:
        1.  Parse request data (binding and basic validation).
        2.  Call the **Application** function.
        3.  Return response data using DTOs.

4.  **Data Transfer Objects (DTOs)**: Define request and response structures in the `dto` package.
    -   **Location**: Each module should have its own file in `internal/controller/dto`.
    -   **Structure**: Create separate structs for each request and response.
    -   **Naming**: Use the format `<ControllerName><Method><Request/Response>` (e.g., `UserLoginRequest`, `UserLoginResponse`).

5.  **Error Handling**: Do not wrap errors in the controller layer. If an error occurs (i.e., is not nil), return it directly.

6.  **Provider Registration**: Register the `New` function in the parent directory's provider.
    -   `internal/controller/provider.go` contains a Wire provider set that aggregates all controllers.

### Router

1.  **File Location**: Register routes in `internal/router/api_router.go`.
2.  **Route Groups**: Explicitly distinguish between authenticated and public (no-auth) route groups.
3.  **Naming Convention**: Unless otherwise specified, use the following pattern: `Group("/<controller_name>").<METHOD>("/<method_name>", wrapper)`.

### Application

1.  **File Location**: Define an application struct for each module. The file should be located at `internal/application/<module>/<module>_app.go`.
    -   **Naming**: The struct name should be the module name suffixed with `App` (e.g., `UserApp`).
    -   **Dependency Injection**: Use Wire to inject multiple service instances and the transaction manager.

2.  **Application Method**: Define a method for each business use case.
    -   **Naming**: Match the business operation (e.g., `Register`).
    -   **Signature**: `func(ctx context.Context, in *dto.<RequestName>) (*dto.<ResponseName>, error)`. It typically takes a DTO from the controller layer and returns a DTO.

3.  **Responsibilities**:
    -   **Orchestration**: Coordinate multiple domain services to fulfill a complex business requirement (e.g., create a user and then create their default namespace).
    -   **Transaction Management**: Explicitly manage database transaction boundaries. All service/repo calls within a single business operation should share the same transaction context.
    -   **DTO Mapping**: Convert between DTOs and domain-specific parameters or entities required by the Service layer.

4.  **Error Handling**:
    -   **Transaction Errors**: Must be wrapped using `AppError` to generate a `DBError`.
    -   **Business Errors**: Do not wrap errors returned by the Service layer; pass them through directly.

5.  **Provider Registration**: Register the `New` function in `internal/application/provider.go`.

### Service

1.  **File Location**: Define a service struct for each module. The file should be located at `internal/service/<module>/<module>_service.go`.
    -   **Naming**: The struct name should be the module name suffixed with `Service` (e.g., `UserService`).
    -   **Dependency Injection**: Use Wire to inject repository instances and other domain-level dependencies.

2.  **Service Method**: Define a service function for specific domain logic.
    -   **Naming**: Descriptive of the domain action (e.g., `Create`).
    -   **Signature**: 
        -   For simple logic: `func(ctx context.Context, param1 type, param2 type) (*entity.Entity, error)`.
        -   For complex logic: `func(ctx context.Context, in *<DomainInputName>) (*entity.Entity, error)`.
        -   Avoid using DTOs in service signatures.

3.  **Data Structures**: If using an input struct, define it within the service package (e.g., in `data.go` or the service file itself). This struct should only contain fields relevant to the domain logic.

4.  **Business Logic**: The service function handles **pure domain logic** and state transitions. It should be "transaction-unaware," assuming the `ctx` already contains a transaction if one is required.

5.  **Dependency Inversion (Circular Dependencies)**: 
    -   **Problem**: Service functions should not call other *public* service functions directly if it leads to circular dependencies.
    -   **Solution**: 
        -   **Orchestration**: Use the Application layer to coordinate between services.
        -   **Interfaces**: Define an interface in the `internal/contract` package and inject it into the Service constructor via Wire.

6.  **Error Handling**:
    -   **Definition**: Define error codes in `internal/contract/constant/errcode/code.go`.
    -   **Wrapping**: Use the `New` function from the `internal/contract/error` package to wrap standard errors. For database errors (where the repository method returns a non-nil error), use the `Db` function from the `internal/contract/error` package.
    -   **Requirements**: The `errMsg` (internal error message) is mandatory. The user-facing error message is optional, as the framework handles internationalization (i18n) based on the error code.
    -   **Service Layer**: Any error returned by the service layer must be wrapped using `AppError`.

7.  **Provider Registration**: Register the `New` function in `internal/service/provider.go`.


### Repository

1.  **File Location**: Define a repository struct for each entity. The file should be located at `internal/repo/<module>/<module>_repo.go`.
    -   **Naming**: Entity name suffixed with `Repo` (e.g., `UserRepo`).

2.  **Database Access**: 
    -   Embed `data.Base` to inherit database access capabilities.
    -   **Context**: All repository methods **must** accept `context.Context` as the first argument. The `Base.CtxDB()` method utilizes this context to automatically detect and manage transaction sessions.

3.  **Dependency Injection**: Use Wire to inject the database connection instance.

4.  **Repository Methods**: Define functions for CRUD operations and stored procedures (e.g., listing entities by condition).
    -   **Naming**: Descriptive of the action (e.g., `GetByID`, `Update`).

5.  **Atomicity**: Ensure each repository function is atomic.
    -   **Transactions**: Do not initiate transactions within the repository. The caller (e.g., the Application layer) should manage transactions.
    -   *Note*: Since most operations involve a single repo method, explicit transaction management is often unnecessary for simple operations.

6.  **ORM**: Use `xorm` for database interactions.

7.  **Error Handling**: Do not wrap errors in the repository layer. If an error occurs (i.e., is not nil), return it immediately.

8.  **Provider Registration**: Register the `New` function in the parent directory's provider.
    -   `internal/repo/provider.go` provides a Wire set for all repositories.