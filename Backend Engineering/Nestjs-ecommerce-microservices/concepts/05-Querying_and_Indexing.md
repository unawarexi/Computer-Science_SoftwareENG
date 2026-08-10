# Querying & Indexing

## Overview
Optimizing data retrieval and search capabilities.

## Topics
1. **Query Optimization**
   - Analyzing slow queries using `EXPLAIN`.
   - Avoiding N+1 query problems (using JOINs, DataLoader, or eager loading).
   - Pagination strategies (Offset vs Cursor-based).

2. **Indexing Strategies**
   - **B-Tree Indexes**: Standard lookups and range queries (e.g., price ranges).
   - **Hash Indexes**: Exact match lookups.
   - **Composite Indexes**: Querying multiple columns efficiently.
   - **Geospatial Indexes**: Finding nearest stores or warehouses (MongoDB / PostGIS).

3. **Advanced Search (Elasticsearch)**
   - Full-text search for the product catalog.
   - Fuzzy matching, autocomplete, and faceting (filtering by brand, price, color).
