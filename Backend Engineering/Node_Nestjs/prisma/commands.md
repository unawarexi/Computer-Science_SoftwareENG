# 🌐 Prisma CLI Commands Cheat Sheet

A complete guide to the most important Prisma CLI commands and what they do. Prisma is a next-generation ORM for Node.js and TypeScript.

---

## 📦 Installation

| Command | Description |
|---------|-------------|
| `npm install prisma --save-dev` | Installs the Prisma CLI as a dev dependency. |
| `npm install @prisma/client` | Installs the Prisma Client for database access. |
| `npx prisma` | Shows all available Prisma CLI commands. |

---

## 📄 Initialization

| Command | Description |
|---------|-------------|
| `npx prisma init` | Creates a new Prisma setup with `schema.prisma`, `.env`, and folders. |

---

## 🔁 Migrations & Schema

| Command | Description |
|---------|-------------|
| `npx prisma migrate dev` | Creates & runs a new migration in development; also updates the database. |
| `npx prisma migrate reset` | Resets the database, applies all migrations, and optionally seeds it. |
| `npx prisma migrate deploy` | Applies all pending migrations in production. |
| `npx prisma migrate status` | Shows the current status of database migrations. |
| `npx prisma db push` | Pushes the schema to the database without generating a migration. |
| `npx prisma db seed` | Runs the seed script defined in `package.json`. |
| `npx prisma migrate diff` | Compares two database states and outputs the difference. |

---

## 💻 Prisma Client

| Command | Description |
|---------|-------------|
| `npx prisma generate` | Generates Prisma Client from the schema. |
| `npx prisma validate` | Validates the `schema.prisma` file for errors. |

---

## 🧪 Introspection

| Command | Description |
|---------|-------------|
| `npx prisma db pull` | Introspects an existing database and updates your Prisma schema. |
| `npx prisma format` | Formats the Prisma schema file using Prettier-like rules. |

---

## 🧬 Studio

| Command | Description |
|---------|-------------|
| `npx prisma studio` | Opens Prisma Studio, a GUI for viewing and editing data in your DB. |

---

## 🧱 Environment & Configuration

| File | Purpose |
|------|---------|
| `.env` | Stores your environment variables like database URL. |
| `prisma/schema.prisma` | Defines your data models, data source, and generator. |
| `prisma/migrations/` | Stores migration files when you run `migrate dev`. |

---

## 🛠️ Useful Combos

```bash
npx prisma migrate dev --name init
# Creates a migration called 'init', applies it, and regenerates the client

npx prisma generate
# Re-run this anytime you update the schema
```