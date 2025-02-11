# PostgreSQL 2-Week Learning Guide

This guide will help you master PostgreSQL in 2 weeks, covering all essential topics step-by-step. Each day's learning content includes theory, practice, and suggested exercises.

## Week 1: PostgreSQL Basics

### **Day 1: Introduction & Installation**
- **Topics:**
  - What is PostgreSQL?
  - PostgreSQL vs. Other Databases (MySQL, SQLite)
  - Installation on different platforms (Windows, macOS, Linux)
  - Connecting to PostgreSQL using `psql` command line
  - Introduction to PgAdmin
- **Practice:**
  - Install PostgreSQL
  - Set up PgAdmin for database management
  - Use the `psql` command line to connect to the server
  - Basic psql commands (`\c`, `\l`, `\dt`, `\du`, etc.)

### **Day 2: Creating & Managing Databases**
- **Topics:**
  - Creating and Dropping Databases
  - Database structure: Tables, Columns, Rows
  - Data types in PostgreSQL (text, integer, float, date, etc.)
  - Schemas and their importance
- **Practice:**
  - Create a database
  - Set up schemas and explore different data types
  - Manage databases (renaming, dropping)

### **Day 3: Table Management**
- **Topics:**
  - Creating tables
  - Primary Keys, Foreign Keys, and Constraints
  - ALTER, DROP, and TRUNCATE tables
  - Indexes and performance considerations
- **Practice:**
  - Create tables with primary and foreign keys
  - Add, remove, and alter columns
  - Experiment with constraints and indexes

### **Day 4: Data Insertion & Querying Basics**
- **Topics:**
  - Inserting Data (`INSERT INTO`)
  - Retrieving Data (`SELECT`)
  - Filtering results using `WHERE`
  - Sorting results with `ORDER BY`
  - Limiting results (`LIMIT`, `OFFSET`)
- **Practice:**
  - Insert records into a table
  - Run basic queries with filtering and sorting
  - Experiment with `LIMIT` and `OFFSET`

### **Day 5: Querying Advanced**
- **Topics:**
  - JOINs (INNER, OUTER, LEFT, RIGHT)
  - Aggregate functions (`COUNT`, `AVG`, `SUM`, `MAX`, `MIN`)
  - Grouping results (`GROUP BY`, `HAVING`)
  - Subqueries
- **Practice:**
  - Perform various JOIN operations
  - Use aggregate functions to summarize data
  - Write subqueries to extract more complex information

### **Day 6: Data Modifications & Transactions**
- **Topics:**
  - Updating data (`UPDATE`)
  - Deleting data (`DELETE`)
  - Transactions, COMMIT, and ROLLBACK
  - Savepoints
  - Atomicity and Consistency in PostgreSQL
- **Practice:**
  - Update and delete records
  - Use transactions to ensure data integrity
  - Experiment with savepoints

### **Day 7: Views & Functions**
- **Topics:**
  - What are Views?
  - Creating and managing Views
  - Introduction to Functions
  - Creating and using stored procedures
- **Practice:**
  - Create and manage views
  - Write simple stored procedures
  - Call functions and examine their role in query efficiency

---

## Week 2: Intermediate to Advanced PostgreSQL

### **Day 8: Indexes & Performance Tuning**
- **Topics:**
  - Types of indexes (B-tree, Hash, GIN, GiST)
  - Query optimization and EXPLAIN
  - Vacuuming and auto-vacuum
  - Managing large datasets
- **Practice:**
  - Create and manage indexes
  - Use `EXPLAIN` to analyze queries
  - Set up vacuuming for performance

### **Day 9: Security & User Management**
- **Topics:**
  - Roles and privileges
  - Creating and managing users
  - Granting and revoking permissions
  - Row-level security
  - Securing connections (SSL)
- **Practice:**
  - Create users and assign roles
  - Manage permissions for different roles
  - Set up SSL for secure connections

### **Day 10: Backup & Recovery**
- **Topics:**
  - Backup strategies
  - Using `pg_dump` for backups
  - Restoring databases from dumps
  - PITR (Point-In-Time Recovery)
- **Practice:**
  - Perform a full database backup using `pg_dump`
  - Restore from a backup
  - Set up and test PITR

### **Day 11: Replication & High Availability**
- **Topics:**
  - Introduction to replication
  - Types of replication (synchronous, asynchronous)
  - Setting up streaming replication
  - Monitoring replication
  - Introduction to clustering and high availability (HA)
- **Practice:**
  - Set up streaming replication between two PostgreSQL servers
  - Monitor replication status

### **Day 12: Advanced Queries**
- **Topics:**
  - Window functions (`ROW_NUMBER()`, `RANK()`, `LEAD()`, `LAG()`)
  - Recursive CTEs
  - Full-text search
  - JSON data type and querying
- **Practice:**
  - Write advanced queries using window functions
  - Perform recursive queries with CTEs
  - Implement full-text search in a table

### **Day 13: PostgreSQL Extensions & PL/pgSQL**
- **Topics:**
  - Popular extensions (PostGIS, pg_trgm, etc.)
  - Installing and managing extensions
  - Introduction to PL/pgSQL
  - Writing stored procedures and triggers
- **Practice:**
  - Install and use extensions like PostGIS
  - Write stored procedures and triggers using PL/pgSQL

### **Day 14: Optimization & Monitoring**
- **Topics:**
  - Performance tuning best practices
  - Query optimization strategies
  - Monitoring tools (pg_stat_activity, pg_stat_statements)
  - Setting up logging and alerts
- **Practice:**
  - Optimize a slow query
  - Use PostgreSQL monitoring tools
  - Set up logging and analyze query performance

---

## Additional Resources
- [Official PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [PostgreSQL Exercises](https://pgexercises.com/)
- [Learning PostgreSQL by Salahaldin Juba](https://www.packtpub.com/product/learning-postgresql-10-second-edition/9781788474714)
- [PostgreSQL Tutorial](https://www.tutorialspoint.com/postgresql/index.htm)

