# 📘 MySQL Query Commands Cheat Sheet

| Command                              | Description                                                                 |
|--------------------------------------|-----------------------------------------------------------------------------|
| `CREATE DATABASE db_name;`           | Creates a new database                                                      |
| `DROP DATABASE db_name;`             | Deletes a database                                                          |
| `USE db_name;`                       | Selects a database to work with                                             |
| `SHOW DATABASES;`                    | Lists all databases                                                         |

| `CREATE TABLE table_name (...);`     | Creates a new table                                                         |
| `DROP TABLE table_name;`            | Deletes a table                                                             |
| `ALTER TABLE table_name ADD ...;`    | Adds a new column to a table                                                |
| `DESCRIBE table_name;`               | Displays structure of a table                                               |
| `SHOW TABLES;`                       | Lists all tables in the current database                                    |

| `INSERT INTO table VALUES (...);`    | Inserts new data into a table                                               |
| `SELECT * FROM table;`               | Selects all rows and columns from a table                                   |
| `SELECT column1, column2 FROM table;`| Selects specific columns                                                    |
| `SELECT DISTINCT column FROM table;` | Selects unique values                                                       |
| `UPDATE table SET column=value ...`  | Updates existing data                                                       |
| `DELETE FROM table WHERE ...;`       | Deletes rows from a table                                                   |

| `WHERE`                              | Filters records based on conditions                                         |
| `AND`, `OR`, `NOT`                   | Combines multiple WHERE conditions                                          |
| `ORDER BY column ASC|DESC;`          | Sorts results by one or more columns                                        |
| `LIMIT number;`                      | Limits the number of returned records                                       |

| `IN (...)`                           | Matches any value in a list                                                 |
| `BETWEEN x AND y`                    | Filters values within a range                                               |
| `LIKE 'pattern'`                     | Pattern matching using `%` and `_` wildcards                                |

| `COUNT()`, `SUM()`, `AVG()`          | Aggregate functions to count, total, and average values                     |
| `MIN()`, `MAX()`                     | Finds the smallest/largest values                                           |
| `GROUP BY column;`                   | Groups records by a column                                                  |
| `HAVING`                             | Filters grouped data                                                        |

| `JOIN` types: `INNER`, `LEFT`, `RIGHT`, `FULL` | Combines rows from multiple tables based on a condition       |
| `ON table1.column = table2.column`   | Specifies join condition                                                    |
| `AS`                                 | Renames columns or tables temporarily (aliasing)                            |

| `CREATE VIEW view_name AS ...;`      | Creates a virtual table from a query                                        |
| `DROP VIEW view_name;`               | Deletes a view                                                              |

| `CREATE INDEX idx_name ON table(col);`| Creates an index for faster search                                          |
| `DROP INDEX idx_name ON table;`      | Removes an index                                                            |

| `BEGIN;` / `START TRANSACTION;`      | Starts a transaction                                                        |
| `COMMIT;`                            | Saves changes in a transaction                                              |
| `ROLLBACK;`                          | Cancels a transaction                                                       |

| `CREATE PROCEDURE` / `CALL`          | Defines and calls a stored procedure                                        |
| `CREATE TRIGGER`                     | Creates a trigger that runs before/after a DML event                        |

| `SHOW PROCESSLIST;`                  | Lists running queries on the MySQL server                                   |
| `EXPLAIN SELECT ...;`                | Shows how MySQL executes a query (for optimization)                         |

---

> ✨ This table includes the most commonly used MySQL commands. Practice them often for fluency!
