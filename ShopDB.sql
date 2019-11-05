IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL 
   DROP TABLE dbo.Orders;

CREATE TABLE dbo.Orders (
  OrderId INT NOT NULL, 
  OrderDate Date NOT NULL, 
  Customer NVARCHAR(5) NOT NULL, 
  CONSTRAINT pk_Orders PRIMARY KEY (OrderID)
) 

IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL 
   DROP TABLE dbo.OrderDetails;

CREATE TABLE dbo.OrderDetails (
  OrderId INT NOT NULL, 
  ProductId INT NOT NULL, 
  Quantity INT NOT NULL CHECK(Quantity <> 0), 
  CONSTRAINT pk_OrderDetails PRIMARY KEY (OrderId, ProductId)
)

ALTER TABLE OrderDetails
    ADD CONSTRAINT fk_OrderId FOREIGN key (OrderId) REFERENCES Orders(OrderId)
    
    
    
    
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL 
   DROP TABLE dbo.Products;

CREATE TABLE dbo.Products (
  ProductId INT NOT NULL, 
  Product_Details NVARCHAR(50) NOT NULL, 
  Price MONEY NOT NULL,
  Quantity INT NOT NULL
  CONSTRAINT pk_Products PRIMARY KEY (ProductId)
);

ALTER TABLE OrderDetails
    ADD CONSTRAINT fk_ProductId FOREIGN key (ProductId) REFERENCES Products(ProductId)
       
    
    
INSERT INTO Orders VALUES (1, CONVERT(datetime, '20191020', 112), 'John' );
INSERT INTO Orders VALUES (2, CONVERT(datetime, '20191020', 112), 'Peter' );
INSERT INTO Products VALUES (1, 'Cappuccino', 38, 100);
INSERT INTO Products VALUES (2, 'Mocha', 40, 100);
INSERT INTO Products VALUES (3, 'Expresso', 25, 100);
INSERT INTO OrderDetails VALUES (1, 1, 2);
INSERT INTO OrderDetails VALUES (1, 2, 3);
INSERT INTO OrderDetails VALUES (2, 2, 1);
INSERT INTO OrderDetails VALUES (2, 3, 2);


CREATE VIEW Sales
AS SELECT Orders.OrderID, 
          SUM(OrderDetails.Quantity * Products.Price) AS TotalCost
   FROM OrderDetails, 
        Products, 
        Orders
   WHERE Orders.OrderID = OrderDetails.OrderID AND 
         OrderDetails.ProductID = Products.ProductID
   GROUP BY Orders.OrderID;
GO

CREATE TRIGGER ChangeStock ON OrderDetails
AFTER INSERT
AS 
BEGIN
  IF UPDATE (Quantity)
  BEGIN
     UPDATE Products
        SET Products.Quantity = Products.Quantity - inserted.Quantity
       FROM inserted
      WHERE Products.ProductID = inserted.ProductID
  END
END;

GO

CREATE PROCEDURE FindProduct(@ProductID AS INT) AS
BEGIN
  SELECT Product_Details, Price, Quantity
    FROM Products
   WHERE ProductID = @ProductID
END;

GO
