-- Question 1: Achieving 1NF

 SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTR(Products, INSTR(Products || ',', ',', 1, n) + 1, INSTR(Products || ',', ',', 1, n + 1) - INSTR(Products || ',', ',', 1, n) - 1)) AS Product
FROM
    ProductDetail
CROSS JOIN
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3) AS numbers
WHERE
    INSTR(Products || ',', ',', 1, n) > 0
    AND LENGTH(TRIM(SUBSTR(Products, INSTR(Products || ',', ',', 1, n) + 1, INSTR(Products || ',', ',', 1, n + 1) - INSTR(Products || ',', ',', 1, n) - 1))) > 0;
    
 
-- Question 2: Achieving 2NF


-- Creating a new Customers table:

CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL
);

INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Creating a new OrderItems table:

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    Product VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;