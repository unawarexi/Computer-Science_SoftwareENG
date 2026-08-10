-- name: CreateCustomer :one
INSERT INTO customers (
    email, phone_number, first_name, last_name, date_of_birth, country_code, status, kyc_level
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetCustomerByID :one
SELECT * FROM customers
WHERE id = $1 LIMIT 1;

-- name: GetCustomerByEmail :one
SELECT * FROM customers
WHERE email = $1 LIMIT 1;

-- name: UpdateCustomerStatus :one
UPDATE customers
SET status = $2
WHERE id = $1
RETURNING *;
