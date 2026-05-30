-- Database creation
create database ECOMMERCE_ASSIGNMENT_DB;
use ECOMMERCE_ASSIGNMENT_DB;
-- Customer table
create table Customer(CustomerId int primary key identity(1,1),CustomerName varchar(50) not null, Email varchar(50) not null unique, MobileNo varchar(15) not null, City varchar(50), Address varchar(100), IsActive bit not null default 1, CreateDate datetime default getdate()); 
select * from Customer;
-- Seller table
create table Seller(SellerId int primary key identity(1,1), SellerName varchar(50) not null,  Email varchar(50) not null unique, MobileNo varchar(15) not null, City varchar(50), Rating decimal(2,1), IsActive bit default 1);
select * from Seller;
--Product table
create table Product(ProductId int primary key identity(1,1), ProductName varchar(50) not null, Category varchar(50) not null, Price decimal(10,2) not null check (Price > 0), StockQuantity int not null check (StockQuantity >= 0), SellerId int not null, CreatedDate datetime default getdate(), constraint FK_Product_Seller  foreign key (SellerId) references Seller(SellerId));
select * from Product;
-- Orders table
create table Orders(OrderId int primary key identity(1,1), CustomerId int not null, OrderDate datetime default getdate(), OrderStatus varchar(50) default 'Pending', PaymentMode varchar(50) not null, DeliveryCity varchar(50), constraint FK_Orders_Customer foreign key (CustomerId) references Customer(CustomerId));
select * from Orders;
-- OrderItem table
create table OrderItem(OrderItemId int primary key identity(1,1), OrderId int not null, ProductId int not null, Quantity int not null check (Quantity > 0), UnitPrice decimal(10,2) not null, constraint FK_OrderItem_Orders foreign key (OrderId) references Orders(OrderId), constraint FK_OrderItem_Product foreign key (ProductId) references Product(ProductId));
select * from OrderItem;

-- Customer record insertion
insert into Customer(CustomerName,Email,MobileNo,City,Address) 
	values('Arun Kumar','arun@gmail.com','9876543210','Chennai','Anna Nagar'),
	('Priya Sharma','priya@gmail.com','9876543211','Bangalore','MG Road'),
	('Ajay Singh','ajay@gmail.com','9876543212','Hyderabad','Banjara Hills'),
	('Anitha Devi','anitha@gmail.com','9876543213','Chennai','T Nagar'),
	('Rahul Verma','rahul@gmail.com','9876543214','Mumbai','Andheri');
select * from Customer;

-- Seller record insertion
insert into Seller(SellerName,Email,MobileNo,City,Rating) 
	values('Tech World','techworld@gmail.com','9123456780','Chennai',4.5),
	('Mobile Hub','mobilehub@gmail.com','9123456781','Bangalore',4.2),
	('Laptop Store','laptop@gmail.com','9123456782','Hyderabad',4.8),
	('Gadget Zone','gadget@gmail.com','9123456783','Mumbai',4.1);
select * from Seller;

-- Product record insertion
insert into Product(ProductName,Category,Price,StockQuantity,SellerId) 
	values('iPhone 15','Mobile',80000,15,2),
	('Samsung Galaxy S24','Mobile',70000,20,2),
	('Dell Inspiron','Laptop',60000,10,3),
	('HP Pavilion','Laptop',55000,8,3),
	('Boat Headset','Accessories',2000,50,1),
	('Apple Watch','Accessories',30000,12,1),
	('Lenovo ThinkPad','Laptop',75000,5,3),
	('OnePlus 12','Mobile',65000,7,4);
select * from Product;

-- Orders record insertion
insert into Orders(CustomerId,PaymentMode,DeliveryCity,OrderStatus) 
	values(1,'UPI','Chennai','Delivered'),
	(2,'Card','Bangalore','Pending'),
	(3,'Cash On Delivery','Hyderabad','Shipped'),
	(4,'UPI','Chennai','Delivered'),
	(5,'Net Banking','Mumbai','Pending');
select * from Orders;

-- OrderItem record insertion
insert into OrderItem(OrderId,ProductId,Quantity,UnitPrice) 
	values(1,1,1,80000),(1,5,2,2000),(2,3,1,60000),(2,6,1,30000),(3,2,1,70000),(3,5,1,2000),(4,4,1,55000),(4,8,1,65000),(5,7,1,75000),(5,5,3,2000);
select * from OrderItem;

-- Updation
update Customer set City = 'Coimbatore' where CustomerId = 2;
select * from Customer;
update Product set Price = 85000 where ProductId = 1;
select * from Product;
update Orders set OrderStatus = 'Delivered' where OrderId = 2;
select * from Orders;

-- Deletion
delete from OrderItem where ProductId=6;
delete from Product where ProductId = 6;

-- all records selection
select * from Customer;
select * from Seller;
select * from Product;
select * from Orders;
select * from OrderItem;

-- Display queries
select * from Customer where City = 'Chennai';

select * from Customer where City != 'Chennai';

select * from Product where Price > 50000;

select * from Product where Price between 10000 and 60000;

select * from Product where Category in ('Mobile', 'Laptop');

select * from Customer where CustomerName like 'A%';

select * from Customer where Email like '%gmail%';

select * from Product where ProductName like '%Phone%';

select * from Orders where OrderStatus = 'Delivered';

select * from Product where StockQuantity < 10;

select * from Customer where MobileNo is not null;

select * from Product where Price not between 10000 and 50000;

select * from Customer where City in ('Chennai', 'Bangalore');

select * from Customer where City = 'Chennai' and IsActive = 1;

select * from Customer where City != 'Hyderabad';

-- Aggregate fn queries
select City, count(*) as TotalCustomers from Customer group by City;

select Category, count(*) as TotalProducts from Product group by Category;

select Category, sum(StockQuantity) as TotalStock from Product group by Category;

select Category, max(Price) as MaxPrice from Product group by Category;

select Category, min(Price) as MinPrice from Product group by Category;

select Category, avg(Price) as AvgPrice from Product group by Category;

select C.CustomerName,sum(OI.Quantity * OI.UnitPrice) as TotalOrderAmount from Customer C join Orders O on C.CustomerId = O.CustomerId join OrderItem OI on O.OrderId = OI.OrderId group by C.CustomerName;

select P.ProductName,sum(OI.Quantity * OI.UnitPrice) as TotalSales from Product P join OrderItem OI on P.ProductId = OI.ProductId group by P.ProductName;

select P.ProductName,sum(OI.Quantity) as TotalQuantitySold from Product P join OrderItem OI on P.ProductId = OI.ProductId group by P.ProductName;

select Category,count(*) as ProductCount from Product group by Category having count(*) > 1;

select C.CustomerName,sum(OI.Quantity * OI.UnitPrice) as TotalAmount from Customer C join Orders O on C.CustomerId = O.CustomerId join OrderItem OI on O.OrderId = OI.OrderId group by C.CustomerName having sum(OI.Quantity * OI.UnitPrice) > 50000;

select S.SellerName,count(P.ProductId) as TotalProducts from Seller S left join Product P on S.SellerId = P.SellerId group by S.SellerName;

select S.SellerName,sum(OI.Quantity * OI.UnitPrice) as TotalSales from Seller S join Product P on S.SellerId = P.SellerId join OrderItem OI on P.ProductId = OI.ProductId group by S.SellerName;

select OrderStatus,count(*) as OrderCount from Orders group by OrderStatus;

select City,count(*) as CustomerCount from Customer group by City order by CustomerCount desc;

-- ORDER BY queries

select * from Product order by Price asc;

select * from Product order by Price desc;

select * from Customer order by City asc, CustomerName asc;

select * from Orders order by OrderDate desc;

select * from Product order by Category asc, Price desc;

select top 3 * from Product order by Price desc;

select top 5 * from Orders order by OrderDate desc;

select * from Customer order by IsActive desc, CustomerName asc;

-- JOIN queries

select O.OrderId,C.CustomerName,O.OrderDate,O.OrderStatus from Orders O inner join Customer C on O.CustomerId = C.CustomerId;

select P.ProductName,S.SellerName,P.Price from Product P inner join Seller S on P.SellerId = S.SellerId;

select OI.OrderItemId,P.ProductName,OI.Quantity,OI.UnitPrice from OrderItem OI inner join Product P on OI.ProductId = P.ProductId;

select C.CustomerName,O.OrderId,P.ProductName,S.SellerName,OI.Quantity,OI.UnitPrice from Customer C join Orders O on C.CustomerId = O.CustomerId join OrderItem OI on O.OrderId = OI.OrderId join Product P on OI.ProductId = P.ProductId join Seller S on P.SellerId = S.SellerId;

select C.CustomerName,O.OrderId from Customer C left join Orders O on C.CustomerId = O.CustomerId;

select O.OrderId,C.CustomerName from Customer C right join Orders O on C.CustomerId = O.CustomerId;

select C.CustomerName,O.OrderId from Customer C full outer join Orders O on C.CustomerId = O.CustomerId;

select C.CustomerName,P.ProductName from Customer C cross join Product P;

select * from Customer where CustomerId not in(select CustomerId from Orders);

select * from Product where ProductId not in(select ProductId from OrderItem);

select S.SellerName,P.ProductName from Seller S join Product P on S.SellerId = P.SellerId;

select C.CustomerName,P.ProductName from Customer C join Orders O on C.CustomerId = O.CustomerId join OrderItem OI on O.OrderId = OI.OrderId join Product P on OI.ProductId = P.ProductId;

select O.OrderId,sum(OI.Quantity * OI.UnitPrice) as TotalAmount from Orders O join OrderItem OI on O.OrderId = OI.OrderId group by O.OrderId;

select S.SellerName,sum(OI.Quantity * OI.UnitPrice) as TotalSales from Seller S join Product P on S.SellerId = P.SellerId join OrderItem OI on P.ProductId = OI.ProductId group by S.SellerName;

select P.ProductName,sum(OI.Quantity) as TotalSalesQuantity from Product P join OrderItem OI on P.ProductId = OI.ProductId group by P.ProductName;