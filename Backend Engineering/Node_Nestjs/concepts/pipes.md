# 🧪 NestJS Pipes Cheat Sheet

In NestJS, **Pipes** are a powerful feature used to **transform** input data and **validate** it before it reaches the route handler. They're commonly used for data validation, sanitization, and transformation.

---

## 🧱 What Are Pipes?

Pipes in NestJS operate on the `@Body()`, `@Param()`, `@Query()`, etc., to **transform** or **validate** the input before it reaches the route handler. If validation fails, they can throw an exception.

---

## 🔧 Built-in Pipes

| Pipe | Usage | Description |
|------|-------|-------------|
| `ValidationPipe` | `@UsePipes()` | Validates incoming requests using `class-validator` decorators. Most used pipe in real-world apps. |
| `ParseIntPipe` | `@Param('id', ParseIntPipe)` | Transforms a string to an integer. Throws error if transformation fails. |
| `ParseBoolPipe` | `@Query('active', ParseBoolPipe)` | Transforms input string to a boolean (`true`, `false`, `1`, `0`). |
| `ParseFloatPipe` | `@Query('rate', ParseFloatPipe)` | Parses a string and converts it to a float. |
| `ParseArrayPipe` | `@Query('ids', ParseArrayPipe)` | Parses a comma-separated list (or delimited by custom character) into an array. |
| `ParseUUIDPipe` | `@Param('uuid', ParseUUIDPipe)` | Validates and transforms a UUID string. |
| `DefaultValuePipe` | `@Query('page', new DefaultValuePipe(1))` | Supplies a default value when a query param or input is missing. |
| `TrimPipe` *(Custom Needed)* | — | Used to trim whitespace. Must be created manually or use a library. |
library.         |

---

## 🧠 Use Cases by Pipe

### ✅ ValidationPipe (with DTOs)
```typescript
@UsePipes(new ValidationPipe())
@Post()
createUser(@Body() dto: CreateUserDto) {
  // Data is validated and transformed here
}
```

### 🔢 ParseIntPipe
```typescript
@Get(':id')
getUser(@Param('id', ParseIntPipe) id: number) {
  return this.userService.find(id);
}
```

### 🎚 ParseBoolPipe
```typescript
@Get()
filter(@Query('active', ParseBoolPipe) active: boolean) {
  return this.service.filter(active);
}
```

### 📏 ParseFloatPipe
```typescript
@Get('rate')
getRate(@Query('amount', ParseFloatPipe) amount: number) {
  return this.service.calculateRate(amount);
}
```

### 📋 ParseArrayPipe
```typescript
@Get()
bulkGet(@Query('ids', new ParseArrayPipe({ items: Number })) ids: number[]) {
  return this.service.getMany(ids);
}
```

### 🧾 ParseUUIDPipe
```typescript
@Get(':uuid')
getByUuid(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
  return this.service.findByUuid(uuid);
}
```

### 🪛 DefaultValuePipe
```typescript
@Get()
list(@Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number) {
  return this.service.paginate(page);
}
```

---

## 🧱 Custom Pipe Example

### UppercasePipe
```typescript
@Injectable()
export class UppercasePipe implements PipeTransform {
  transform(value: string) {
    return value.toUpperCase();
  }
}

// Usage
@Get(':name')
getName(@Param('name', UppercasePipe) name: string) {
  return name; // always uppercase
}
```

---

## 📌 Applying Pipes

| Level            | How to Use                     |
|------------------|--------------------------------|
| **Method Level** | `@UsePipes(MyPipe)`            |
| **Controller Level** | `@UsePipes()` on controller |
| **Global Level** | `app.useGlobalPipes(new ValidationPipe())` |

---

## 📚 Additional Resources

- [Official Docs](https://docs.nestjs.com/pipes)
- [Class Validator](https://github.com/typestack/class-validator)

✅ **Tip**: Use `ValidationPipe` with DTOs for clean, safe data handling across your entire app.