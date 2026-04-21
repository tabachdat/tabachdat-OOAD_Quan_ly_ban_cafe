CREATE DATABASE CafeManagementDB;
GO

USE CafeManagementDB;
GO
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Role VARCHAR(20) NOT NULL, -- Admin / Staff
    Phone VARCHAR(20),
    Status BIT DEFAULT 1
);
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
);
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    CategoryID INT,
    Image VARCHAR(255),
    Description NVARCHAR(255),
    Status BIT DEFAULT 1,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
CREATE TABLE CafeTables (
    TableID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50) NOT NULL,
    Status NVARCHAR(30) DEFAULT N'Trống',
    QRCodePath VARCHAR(255)
);
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    TableID INT NOT NULL,
    UserID INT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(30) DEFAULT N'Đang chờ',
    TotalAmount DECIMAL(18,2) DEFAULT 0,
    FOREIGN KEY (TableID) REFERENCES CafeTables(TableID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT DEFAULT 1,
    Price DECIMAL(18,2) NOT NULL,
    Note NVARCHAR(255),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    Method NVARCHAR(50) DEFAULT N'Tiền mặt',
    Amount DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
CREATE TABLE Notifications (
    NotifyID INT IDENTITY(1,1) PRIMARY KEY,
    TableID INT NOT NULL,
    Message NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    Status BIT DEFAULT 0,
    FOREIGN KEY (TableID) REFERENCES CafeTables(TableID)
);
INSERT INTO Users (Username, Password, FullName, Role)
VALUES
('admin', '123456', N'Quản trị viên', 'Admin'),
('staff1', '123456', N'Nhân viên 1', 'Staff');
INSERT INTO Categories (CategoryName)
VALUES
(N'Cafe'),
(N'Trà'),
(N'Bánh ngọt'),
(N'Nước ép');
INSERT INTO Products (ProductName, Price, CategoryID, Image, Description)
VALUES
(N'Espresso', 35000, 1, 'espresso.png', N'Cà phê đậm vị Ý'),
(N'Americano', 40000, 1, 'americano.png', N'Cà phê pha loãng kiểu Mỹ'),
(N'Latte', 45000, 1, 'latte.png', N'Cà phê sữa béo nhẹ'),
(N'Cappuccino', 50000, 1, 'cappuccino.png', N'Cà phê bọt sữa truyền thống'),
(N'Bạc xỉu', 42000, 1, 'bacxiu.png', N'Sữa nhiều cà phê ít'),

(N'Matcha Latte', 50000, 2, 'matcha_latte.png', N'Trà xanh sữa thơm ngon'),
(N'Trà đào cam sả', 48000, 2, 'tra_dao_cam_sa.png', N'Trà đào thanh mát'),
(N'Trà vải', 45000, 2, 'tra_vai.png', N'Trà vải ngọt dịu'),
(N'Hồng trà sữa', 47000, 2, 'hong_tra_sua.png', N'Trà sữa truyền thống'),

(N'Chocolate đá xay', 55000, 4, 'chocolate_da_xay.png', N'Socola xay mát lạnh'),
(N'Sinh tố xoài', 52000, 4, 'sinh_to_xoai.png', N'Sinh tố xoài tươi'),
(N'Cam ép', 45000, 4, 'cam_ep.png', N'Nước cam nguyên chất'),

(N'Tiramisu', 55000, 3, 'tiramisu.png', N'Bánh ngọt Ý mềm mịn'),
(N'Croissant', 40000, 3, 'croissant.png', N'Bánh sừng bò bơ thơm'),
(N'Cheesecake', 60000, 3, 'cheesecake.png', N'Bánh kem phô mai');
INSERT INTO CafeTables (TableName, QRCodePath)
VALUES
(N'Bàn 1', 'table1.png'),
(N'Bàn 2', 'table2.png'),
(N'Bàn 3', 'table3.png'),
(N'Bàn 4', 'table4.png'),
(N'Bàn 5', 'table5.png'),
(N'Bàn 6', 'table6.png'),
(N'Bàn 7', 'table7.png'),
(N'Bàn 8', 'table8.png'),
(N'Bàn 9', 'table9.png'),
(N'Bàn 10', 'table10.png');
ALTER TABLE Products
ADD StockQuantity INT DEFAULT 100;
CREATE TRIGGER trg_UpdateTotalAmount
ON OrderDetails
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE Orders
    SET TotalAmount =
    ISNULL(
        (
            SELECT SUM(Quantity * Price)
            FROM OrderDetails
            WHERE OrderID = Orders.OrderID
        ),0
    )
    WHERE OrderID IN (
        SELECT DISTINCT OrderID FROM inserted
        UNION
        SELECT DISTINCT OrderID FROM deleted
    );
END;
CREATE PROCEDURE sp_PayOrder
    @OrderID INT
AS
BEGIN
    DECLARE @Total MONEY;

    SELECT @Total = TotalAmount
    FROM Orders
    WHERE OrderID = @OrderID;

    INSERT INTO Payments(OrderID, Amount)
    VALUES(@OrderID, @Total);

    UPDATE Orders
    SET Status = N'Đã thanh toán'
    WHERE OrderID = @OrderID;

    UPDATE CafeTables
    SET Status = N'Trống'
    WHERE TableID = (
        SELECT TableID FROM Orders WHERE OrderID = @OrderID
    );
END;
CREATE VIEW vw_Revenue AS
SELECT
    CAST(PaymentDate AS DATE) AS RevenueDate,
    SUM(Amount) AS TotalRevenue
FROM Payments
GROUP BY CAST(PaymentDate AS DATE);
CREATE VIEW vw_BestSeller AS
SELECT
    P.ProductName,
    SUM(OD.Quantity) AS TotalSold
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName;
