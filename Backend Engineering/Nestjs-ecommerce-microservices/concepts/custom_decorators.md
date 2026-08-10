# 🧩 NestJS Decorators Cheat Sheet

NestJS uses **TypeScript decorators** extensively to provide metadata for classes and methods, enabling its powerful and modular structure. Here's a comprehensive list of **NestJS decorators** and what they do.

---

## 🎯 What are Decorators?

Decorators are a special kind of declaration in TypeScript that can be attached to a class, method, property, or parameter. They allow you to modify or extend the behavior of the target they are applied to. In NestJS, decorators are used to provide metadata that helps the framework understand how to handle various components like controllers, providers, and routes.

---

## 🤔 Why Use Decorators?

Decorators simplify the process of defining and configuring application components by:

- **Enhancing Readability**: They make the code more declarative and easier to understand.
- **Reducing Boilerplate**: They eliminate the need for repetitive code by encapsulating logic in reusable annotations.
- **Enabling Metadata**: They allow attaching metadata to classes and methods, which NestJS uses to handle dependency injection, routing, and more.

For example, `@Controller()` tells NestJS that a class is a controller, while `@Get()` maps a method to an HTTP GET request.

---

## 🧪 Custom Decorators in NestJS

Custom decorators in NestJS allow you to encapsulate reusable logic or extract specific data from requests. They are typically created using the `@CreateParamDecorator()` function.

### Example: Creating a Custom Decorator

```ts
import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const User = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.user; // Extracts the user object from the request
  },
);
```

You can then use this custom decorator in your controllers:

```ts
@Get('profile')
getProfile(@User() user: any) {
  return user;
}
```

This approach simplifies extracting specific data (like the authenticated user) from the request object, making your code cleaner and more modular.

---

## 📦 Class-Level Decorators

| Decorator | Usage | Description |
|-----------|-------|-------------|
| `@Module()` | Class | Declares a Nest module. Groups related providers, controllers, and imports. |
| `@Injectable()` | Class | Makes a class a **provider** that can be injected into other components. |
| `@Controller()` | Class | Declares a controller that handles HTTP requests. You can pass a path as a parameter. |
| `@Global()` | Class | Marks a module as **global**, making its providers accessible in all modules without importing. |
| `@Catch()` | Class | Used to define **exception filters** for handling errors globally or locally. |
| `@Inject()` | Property | Allows manual injection of a dependency, especially with custom tokens. |

---

## 🚏 Route-Level Decorators (Controllers)

| Decorator | Usage | Description |
|-----------|-------|-------------|
| `@Get()` | Method | Maps HTTP GET requests to the method. |
| `@Post()` | Method | Maps HTTP POST requests. |
| `@Put()` | Method | Maps HTTP PUT requests. |
| `@Patch()` | Method | Maps HTTP PATCH requests. |
| `@Delete()` | Method | Maps HTTP DELETE requests. |
| `@Options()` | Method | Maps HTTP OPTIONS requests. |
| `@Head()` | Method | Maps HTTP HEAD requests. |
| `@All()` | Method | Matches all HTTP methods. |
| `@HttpCode()` | Method | Overrides the default HTTP response code. |
| `@Header()` | Method | Sets a custom response header. |
| `@Redirect()` | Method | Sends an HTTP redirect response. |

---

## 📥 Request/Response Decorators

| Decorator | Usage | Description |
|-----------|-------|-------------|
| `@Req()` | Parameter | Injects the full **request** object (like `req` in Express). |
| `@Res()` | Parameter | Injects the **response** object (used to bypass Nest's response handling). |
| `@Body()` | Parameter | Extracts data from the request **body**. |
| `@Param()` | Parameter | Extracts **route parameters**. |
| `@Query()` | Parameter | Extracts data from the **query string**. |
| `@Headers()` | Parameter | Gets headers from the request. |
| `@Session()` | Parameter | Access the session (if session middleware is set up). |
| `@Ip()` | Parameter | Retrieves the client's IP address. |
| `@HostParam()` | Parameter | Gets parameters from the host (when using host-based routing). |

---

## 🔐 Guards, Interceptors, Pipes & Filters

| Decorator | Usage | Description |
|-----------|-------|-------------|
| `@UseGuards()` | Method/Class | Applies **guards** to routes or controllers. Guards handle authorization logic. |
| `@UseInterceptors()` | Method/Class | Applies **interceptors** to transform request/response or extend behavior. |
| `@UsePipes()` | Method/Class | Applies **pipes** to transform/validate data. |
| `@UseFilters()` | Method/Class | Applies **exception filters** to handle errors. |

---

## 🧪 Custom Decorators

| Decorator | Usage | Description |
|-----------|-------|-------------|
| `@SetMetadata()` | Method/Class | Attaches custom metadata used often in conjunction with guards. |
| `@CreateParamDecorator()` | Method | Used to create **custom decorators** (e.g., `@User()`) to extract data from requests. |

---

## 🧱 Provider-Specific Decorators

| Decorator | Usage | Description |
|-----------|-------|-------------|
| `@Optional()` | Constructor Param | Marks a dependency as optional (won’t throw if not provided). |
| `@Inject()` | Constructor Param | Manually inject a dependency using a token. |
| `@Self()` | Constructor Param | Only look for the dependency in the current injector. |
| `@SkipSelf()` | Constructor Param | Skip current and look in parent injectors. |
| `@Host()` | Constructor Param | Restrict resolution to the host component. |

---

## 🧵 Lifecycle Hooks

Nest also supports lifecycle hooks using method decorators (not technically decorators but worth knowing):

| Hook | Description |
|------|-------------|
| `onModuleInit()` | Called once the module’s dependencies are resolved. |
| `onApplicationBootstrap()` | Called once the application is fully initialized. |
| `onModuleDestroy()` | Called when the module is about to be destroyed. |
| `beforeApplicationShutdown()` | Invoked before app shutdown begins. |
| `onApplicationShutdown()` | Called during shutdown signal (e.g., SIGINT). |

---

## ✅ Example

```ts
@Controller('users')
export class UserController {
  constructor(private userService: UserService) {}

  @Get(':id')
  getUser(@Param('id') id: string) {
    return this.userService.findOne(id);
  }

  @Post()
  @HttpCode(201)
  create(@Body() createUserDto: CreateUserDto) {
    return this.userService.create(createUserDto);
  }
}
```
