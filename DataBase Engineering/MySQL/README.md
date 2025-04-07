# 🗂️ MySQL Learning Plan – 2 Months (8 Weeks)

This is a structured 2-month (8-week) learning guide to master MySQL from the basics to intermediate/advanced concepts. Designed for self-paced learning with weekly goals, practical exercises, and project ideas.

---

## 📅 Week 1: Introduction to Databases & MySQL Setup

- What is a relational database?
- Introduction to SQL and MySQL
- Installing MySQL on your system
- Using MySQL CLI and Workbench
- Connecting to a MySQL server
- Creating your first database and table

**Practice:**
- Create a database called `learn_mysql`
- Create a `users` table with basic fields (id, name, email)

---

## 📅 Week 2: Basic SQL – SELECT, INSERT, UPDATE, DELETE

- `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`
- `INSERT INTO` and inserting multiple rows
- `UPDATE` and `DELETE` statements
- SQL syntax best practices

**Practice:**
- Populate your `users` table with 10+ sample users
- Write queries to filter, update, and delete specific records

---

## 📅 Week 3: Filtering, Sorting & Aggregations

- Advanced filtering with `AND`, `OR`, `NOT`, `BETWEEN`, `LIKE`
- `ORDER BY` and sorting techniques
- `GROUP BY` and aggregate functions: `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`
- `HAVING` clause for group filtering

**Practice:**
- Create a `sales` table and run aggregation queries
- Get total and average sales per user

---

## 📅 Week 4: Joins & Relationships

- Understanding table relationships
- `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN`
- Joining 2 or more tables
- Aliases and multi-table queries

**Practice:**
- Create a `products` table and `orders` table
- Join `users` with `orders` to see who ordered what

---

## 📅 Week 5: Constraints, Indexing & Normalization

- Primary keys, foreign keys
- Unique, Not Null, Default constraints
- Indexing for performance
- Database normalization (1NF, 2NF, 3NF)

**Practice:**
- Normalize your current schema to at least 2NF
- Apply indexing to common search fields

---

## 📅 Week 6: Subqueries & Views

- Writing subqueries (in `SELECT`, `WHERE`, `FROM`)
- Nested queries and correlated subqueries
- Creating and using Views
- Advantages of using Views

**Practice:**
- Create a view that shows active users and their total orders
- Use subqueries to filter data dynamically

---

## 📅 Week 7: Stored Procedures, Triggers & Transactions

- What are stored procedures and how to use them
- Writing simple triggers (`BEFORE INSERT`, `AFTER UPDATE`)
- Understanding transactions and rollbacks
- ACID properties

**Practice:**
- Create a stored procedure to add a new user + initial balance
- Write a trigger to log changes to the `orders` table

---

## 📅 Week 8: Real-World Project + Optimization

- Design a small real-world schema (e.g. blog, store, school)
- Apply all concepts learned: joins, views, triggers, procedures
- Optimize slow queries using EXPLAIN
- Backup & restore databases

**Final Project:**
- Build a MySQL-backed app (e.g. CLI or web dashboard)
- Document your schema, queries, and learnings

---

## 🎯 Bonus Goals (Optional)

- Learn how to connect MySQL with Python/Node.js
- Practice with MySQL on AWS RDS or Docker
- Explore MySQL Workbench for schema design

---

> Stay consistent. Practice daily. Don't just memorize — understand and build.
