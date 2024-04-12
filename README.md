# Shipping Proximity Analysis SQL Query

## Overview
This SQL query calculates the proximity address of shipping orders and identifies orders within a specified distance of each other. It retrieves relevant transaction and order information from the database and computes the distance between shipping addresses using the Haversine formula.

## Prerequisites
- Access to the database containing transaction and order information.
- SQL environment for executing the query.

## Usage
1. Clone or download the repository.
2. Open the SQL script file in your preferred SQL environment.
3. Replace placeholder values and table names with actual values relevant to your database.
4. Execute the SQL query.

## Description
The query retrieves transaction and order details including account ID, order number, product information, shipping address, refund details, and fraud flags. It then calculates the distance between shipping addresses of different orders using latitude and longitude coordinates.

## Note
- Ensure proper permissions and data protection measures are in place before executing the query.
- Modify the query as necessary to suit your specific requirements and database schema.

## License
This project is licensed under the [MIT License](LICENSE).
