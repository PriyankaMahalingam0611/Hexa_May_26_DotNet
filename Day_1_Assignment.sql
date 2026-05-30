-- Database creation
create database ECOMMERCE_ASSIGNMENT_DB;
use ECOMMERCE_ASSIGNMENT_DB;

-- Table creation
create table Customer(CustomerId int primary key identity(1,1),CustomerName varchar(50) not null, Email varchar(50) not null unique, MobileNo varchar(15) not null, City varchar(50), Address varchar(100), IsActive bit not null default 1, CreateDate datetime default getdate()); 
select * from Customer;

create table Seller(SellerId int primary key identity(1,1), SellerName varchar(50) not null,  Email varchar(50) not null unique, MobileNo varchar(15) not null, City varchar(50), Rating decimal(2,1), IsActive bit default 1);
select * from Seller;

create table Product(ProductId int primary key identity(1,1), ProductName varchar(50) not null, Category varchar(50) not null, Price decimal(10,2) not null check (Price > 0), StockQuantity int not null check (StockQuantity >= 0), SellerId int not null, CreatedDate datetime default getdate(), constraint FK_Product_Seller  foreign key (SellerId) references Seller(SellerId));
select * from Product;

create table Orders(OrderId int primary key identity(1,1), CustomerId int not null, OrderDate datetime default getdate(), OrderStatus varchar(50) default 'Pending', PaymentMode varchar(50) not null, DeliveryCity varchar(50), constraint FK_Orders_Customer foreign key (CustomerId) references Customer(CustomerId));
select * from Orders;

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

-- Basic subquery

select * from Product where Price > (select avg(Price) from Product);

select * from Product where StockQuantity < (select avg(StockQuantity) from Product);

select * from Customer where CustomerId in (select CustomerId from Orders);

select * from Customer where CustomerId not in (select CustomerId from Orders);

select * from Product where ProductId in (select ProductId from OrderItem);

select * from Product where ProductId not in (select ProductId from OrderItem);

select * from Seller where SellerId in (select SellerId from Product);

select * from Seller where SellerId not in (select SellerId from Product);

select * from Orders where CustomerId in (select CustomerId from Customer where City = 'Chennai');

select * from Product where SellerId in (select SellerId from Seller where City = 'Bangalore');

-- Subquery with IN/NOT IN

select * from Customer where CustomerId in (select CustomerId from Orders);

select * from Customer where CustomerId not in (select CustomerId from Orders);

select * from Product where ProductId in (select ProductId from OrderItem);

select * from Product where ProductId not in (select ProductId from OrderItem);

select * from Seller where SellerId in (select SellerId from Product);

select * from Seller where SellerId not in (select SellerId from Product);

select * from Orders where OrderId in (
    select OrderId from OrderItem where ProductId in (
        select ProductId from Product where Category = 'Mobile'));

select * from Orders where OrderId not in (
    select OrderId from OrderItem where ProductId in (
        select ProductId from Product where Category = 'Laptop'));

-- Subquery with aggregate fns

select * from Product where Price = (select max(Price) from Product);

select * from Product where Price = (select min(Price) from Product);

select * from Product where Price > (select avg(Price) from Product);

select * from Product where Price < (select avg(Price) from Product);

select * from Customer where CustomerId in (
    select O.CustomerId from Orders O join OrderItem OI on O.OrderId = OI.OrderId 
    group by O.CustomerId having sum(OI.Quantity * OI.UnitPrice) >(
        select sum(Quantity * UnitPrice) / count(distinct OrderId) from OrderItem));

select * from Seller where SellerId in (
    select P.SellerId from Product P join OrderItem OI on P.ProductId = OI.ProductId
    group by P.SellerId having sum(OI.Quantity * OI.UnitPrice) > 50000
);

select * from Product where ProductId in (
    select ProductId from OrderItem group by ProductId having sum(Quantity) >(
        select avg(TotalQty) from (
            select sum(Quantity) as TotalQty from OrderItem group by ProductId
        ) as AvgQty
    )
);

select top 1 * from Customer where CustomerId in (
    select top 1 O.CustomerId from Orders O join OrderItem OI on O.OrderId = OI.OrderId 
    group by O.CustomerId order by sum(OI.Quantity * OI.UnitPrice) desc
);

select top 1 * from Product where ProductId in (
    select top 1 ProductId from OrderItem group by ProductId order by sum(Quantity * UnitPrice) desc
);

select top 1 * from Seller where SellerId in (
    select top 1 P.SellerId from Product P join OrderItem OI on P.ProductId = OI.ProductId
    group by P.SellerId order by sum(OI.Quantity * OI.UnitPrice) desc
);

-- Correlated subquery

select * from Product p1 where Price >(
    select avg(Price) from Product p2 where p1.Category = p2.Category
);

select * from Product p1 where Price < (
    select avg(Price) from Product p2 where p1.Category = p2.Category
);

select * from Seller s where 2 < (
    select count(*) from Product p where p.SellerId = s.SellerId
);

select * from Customer c where 1 < (
    select count(*) from Orders o where o.CustomerId = c.CustomerId
);

select * from Orders o1 where (
    select sum(Quantity * UnitPrice) from OrderItem oi where oi.OrderId = o1.OrderId) > (
    select sum(Quantity * UnitPrice) / count(distinct OrderId) from OrderItem
);

select * from Product p1 where StockQuantity > (
    select avg(StockQuantity) from Product p2 where p1.Category = p2.Category
);

select * from Seller s where (
    select avg(Price) from Product p where p.SellerId = s.SellerId
)>(
    select avg(Price) from Product
);

-- EXISTS / NOT EXISTS queries

select * from Customer c where exists (
    select 1 from Orders o where o.CustomerId = c.CustomerId
);

select * from Customer c where not exists (
    select 1 from Orders o where o.CustomerId = c.CustomerId
);

select * from Product p where exists (
    select 1 from OrderItem oi where oi.ProductId = p.ProductId
);

select * from Product p where not exists (
    select 1 from OrderItem oi where oi.ProductId = p.ProductId
);

select * from Seller s where exists (
    select 1 from Product p where p.SellerId = s.SellerId
);

select * from Seller s where not exists (
    select 1 from Product p where p.SellerId = s.SellerId
);

select * from Customer c where exists (
    select 1 from Orders o join OrderItem oi on o.OrderId = oi.OrderId join Product p on oi.ProductId = p.ProductId 
    where o.CustomerId = c.CustomerId and p.Category = 'Mobile'
);

select * from Customer c where not exists (
    select 1 from Orders o join OrderItem oi on o.OrderId = oi.OrderId
    join Product p on oi.ProductId = p.ProductId
    where o.CustomerId = c.CustomerId and p.Category = 'Laptop'
);

-- Basic stored prodedure query
go
create procedure sp_GetAllCustomers
as
begin
    select * from Customer;
end;
go

create procedure sp_GetAllProducts
as
begin
    select * from Product;
end;
go

create procedure sp_GetAllSellers
as
begin
    select * from Seller;
end;
go

create procedure sp_GetAllOrders
as
begin
    select * from Orders;
end;
go

create procedure sp_GetAllOrderItems
as
begin
    select * from OrderItem;
end;
go

exec sp_GetAllCustomers;
exec sp_GetAllProducts;
exec sp_GetAllSellers;
exec sp_GetAllOrders;
exec sp_GetAllOrderItems;

-- Stored procedure with input parameter
go 
create procedure sp_GetCustomerById
    @CustomerId int
as
begin
    select * from Customer
    where CustomerId = @CustomerId;
end;
go

create procedure sp_GetProductById
    @ProductId int
as
begin
    select * from Product
    where ProductId = @ProductId;
end;
go

create procedure sp_GetSellerById
    @SellerId int
as
begin
    select * from Seller
    where SellerId = @SellerId;
end;
go

create procedure sp_GetOrderById
    @OrderId int
as
begin
    select * from Orders
    where OrderId = @OrderId;
end;
go

create procedure sp_GetCustomersByCity
    @City varchar(50)
as
begin
    select * from Customer
    where City = @City;
end;
go

create procedure sp_GetProductsByCategory
    @Category varchar(50)
as
begin
    select * from Product
    where Category = @Category;
end;
go

create procedure sp_GetProductsBySellerId
    @SellerId int
as
begin
    select * from Product
    where SellerId = @SellerId;
end;
go

create procedure sp_GetOrdersByCustomerId
    @CustomerId int
as
begin
    select * from Orders
    where CustomerId = @CustomerId;
end;
go

create procedure sp_GetOrderItemsByOrderId
    @OrderId int
as
begin
    select * from OrderItem
    where OrderId = @OrderId;
end;
go

create procedure sp_GetProductsGreaterThanPrice
    @Price decimal(10,2)
as
begin
    select * from Product
    where Price > @Price;
end;
go

exec sp_GetCustomerById 1;

exec sp_GetProductById 2;

exec sp_GetSellerById 3;

exec sp_GetOrderById 2;

exec sp_GetCustomersByCity 'Chennai';

exec sp_GetProductsByCategory 'Mobile';

exec sp_GetProductsBySellerId 2;

exec sp_GetOrdersByCustomerId 1;

exec sp_GetOrderItemsByOrderId 2;

exec sp_GetProductsGreaterThanPrice 50000;

-- Insert stored procedure
go
create procedure sp_InsertCustomer 
    @Name varchar(50), @Email varchar(50), @Mobile varchar(15), @City varchar(50), @Address varchar(100)
as 
begin
    insert into Customer(CustomerName, Email, MobileNo, City, Address)
    values(@Name, @Email, @Mobile, @City, @Address);
end;
exec sp_InsertCustomer
    'Priyanka M', 'priyamaha@gmail.com', '9876543210', 'Salem', 'Kondalamapatti';
go

create procedure sp_InsertSeller
    @Name varchar(50), @Email varchar(50), @Mobile varchar(15), @City varchar(50), @Rating decimal(2,1)
as
begin
    insert into Seller(SellerName, Email, MobileNo, City, Rating)
    values(@Name, @Email, @Mobile, @City,@Rating);
end;
exec sp_InsertSeller
    'Karthik','karthik@gmail.com','9876543211', 'Chennai', 4.5;
go

create procedure sp_InsertProduct
    @Name varchar(50), @Cat varchar(50), @Price decimal(10,2), @Qty int, @SellerId int
as
begin
    insert into Product(ProductName, Category, Price, StockQuantity, SellerId)
    values(@Name, @Cat, @Price, @Qty, @SellerId);
end;
exec sp_InsertProduct
    'iPhone 15', 'Mobile', 79999, 20, 1;
go

create procedure sp_InsertOrder
    @CustId int, @PayMode varchar(50), @City varchar(50)
as
begin
    insert into Orders(CustomerId, PaymentMode, DeliveryCity)
    values(@CustId, @PayMode, @City);
end;
exec sp_InsertOrder
    1, 'UPI', 'Salem';
go

create procedure sp_InsertOrderItem
    @OrdId int, @ProdId int, @Qty int, @Price decimal(10,2)
as
begin
    insert into OrderItem(OrderId, ProductId, Quantity, UnitPrice)
    values(@OrdId, @ProdId, @Qty, @Price);
end;
exec sp_InsertOrderItem
    1, 1, 2, 79999;
go

-- Update stored procedure queries

create procedure UpdateCustomerCity
    @CustomerId int, @City varchar(50)
as
begin
    update Customer set City = @City  where CustomerId = @CustomerId;
end;
exec UpdateCustomerCity
    1, 'Coimbatore';
go

create procedure UpdateCustomerMobile
    @CustomerId int, @Mobile varchar(15)
as
begin
    update Customer set MobileNo = @Mobile where CustomerId = @CustomerId;
end;
exec UpdateCustomerMobile
    1, '9999999999';
go

create procedure UpdateProductPrice
    @ProductId int, @Price decimal(10,2)
as
begin
    update Product set Price = @Price where ProductId = @ProductId;
end;
exec UpdateProductPrice
    1,
    85000;
go

create procedure UpdateProductStock
    @ProductId int, @Stock int
as
begin
    update Product set StockQuantity = @Stock where ProductId = @ProductId;
end;
exec UpdateProductStock
    1, 50;
go

create procedure UpdateOrderStatus
    @OrderId int, @Status varchar(50)
as
begin
    update Orders set OrderStatus = @Status where OrderId = @OrderId;
end;
exec UpdateOrderStatus
    1, 'Delivered';
go

create procedure UpdateSellerRating
    @SellerId int, @Rating decimal(2,1)
as
begin
    update Seller set Rating = @Rating where SellerId = @SellerId;
end;
exec UpdateSellerRating
    1, 4.8;
go

create procedure sp_UpdateCustomerActiveStatus
    @CustomerId int, @IsActive bit
as
begin
    update Customer set IsActive = @IsActive where CustomerId = @CustomerId;
end;
exec sp_UpdateCustomerActiveStatus
    1,1;
go

create procedure sp_UpdateSellerActiveStatus
    @SellerId int, @IsActive bit
as
begin
    update Seller set IsActive = @IsActive where SellerId = @SellerId;
end;
exec sp_UpdateSellerActiveStatus
    1, 1;
go

-- Delete stored procedure

create procedure sp_DeleteCustomer
    @CustomerId int
as
begin
    delete from Customer where CustomerId = @CustomerId;
end;
exec sp_DeleteCustomer 1;
go

create procedure sp_DeleteSeller
    @SellerId int
as
begin
    delete from Seller where SellerId = @SellerId;
end;
exec sp_DeleteSeller 2;
go

create procedure sp_DeleteProduct
    @ProductId int
as
begin
    delete from Product where ProductId = @ProductId;
end;
exec sp_DeleteProduct 1;
go

create procedure sp_DeleteOrder
    @OrderId int
as
begin
    delete from Orders where OrderId = @OrderId;
end;
exec sp_DeleteOrder 3;
go

create procedure sp_DeleteOrderItem
    @OrderItemId int
as
begin
    delete from OrderItem where OrderItemId = @OrderItemId;
end;
exec sp_DeleteOrderItem 1;
go

-- Stored procedure with join

create procedure sp_GetCustomerOrders
as
begin
    select c.CustomerName,o.OrderId, o.OrderDate, o.OrderStatus
    from Customer c join Orders o
    on c.CustomerId = o.CustomerId;
end;
exec sp_GetCustomerOrders;
go

create procedure sp_GetSellerProducts
as
begin
    select s.SellerName, p.ProductName, p.Category, p.Price from Seller s
    join Product p on s.SellerId = p.SellerId;
end;
exec sp_GetSellerProducts;
go

create procedure sp_GetOrderProducts
as
begin
    select o.OrderId,  p.ProductName, oi.Quantity,oi.UnitPrice from Orders o
    join OrderItem oi on o.OrderId = oi.OrderId
    join Product p on oi.ProductId = p.ProductId;
end;
exec sp_GetOrderProducts;
go

create procedure sp_GetCompleteOrderReport
as
begin
    select c.CustomerName, p.ProductName, s.SellerName, oi.Quantity, oi.UnitPrice, (oi.Quantity * oi.UnitPrice) as TotalAmount
    from Orders o join Customer c on o.CustomerId = c.CustomerId
    join OrderItem oi on o.OrderId = oi.OrderId
    join Product p on oi.ProductId = p.ProductId
    join Seller s on p.SellerId = s.SellerId;
end;
exec sp_GetCompleteOrderReport;
go

create procedure sp_GetCustomerTotalAmount
as
begin
    select c.CustomerName, sum(oi.Quantity * oi.UnitPrice) as TotalAmount
    from Customer c join Orders o on c.CustomerId = o.CustomerId
    join OrderItem oi on o.OrderId = oi.OrderId group by c.CustomerName;
end;
exec sp_GetCustomerTotalAmount;
go

create procedure sp_GetSellerTotalSales
as
begin
    select s.SellerName, sum(oi.Quantity * oi.UnitPrice) as TotalSales
    from Seller s join Product p on s.SellerId = p.SellerId
    join OrderItem oi on p.ProductId = oi.ProductId group by s.SellerName;
end;
exec sp_GetSellerTotalSales;
go

create procedure sp_GetProductTotalQty
as
begin
    select p.ProductName, sum(oi.Quantity) as TotalQuantitySold from Product p
    join OrderItem oi on p.ProductId = oi.ProductId group by p.ProductName;
end;
exec sp_GetProductTotalQty;
go

-- Stored procedure with output parameter

create procedure sp_GetTotalCustomers
    @TotalCount int output
as
begin
    select @TotalCount = count(*) from Customer;
end;
declare @Count int;
exec sp_GetTotalCustomers @Count output;
select @Count as TotalCustomers;
go


create procedure sp_GetTotalProducts
    @TotalCount int output
as
begin
    select @TotalCount = count(*) from Product;
end;
declare @Count int;
exec sp_GetTotalProducts @Count output;
select @Count as TotalProducts;
go


create procedure sp_GetTotalOrders
    @TotalCount int output
as
begin
    select @TotalCount = count(*)  from Orders;
end;
declare @Count int;
exec sp_GetTotalOrders @Count output;
select @Count as TotalOrders;
go


create procedure sp_GetTotalSalesByProduct
    @ProductId int, @TotalSales decimal(10,2) output
as
begin
    select @TotalSales = isnull(sum(Quantity * UnitPrice), 0)
    from OrderItem where ProductId = @ProductId;
end;
declare @Sales decimal(10,2);
exec sp_GetTotalSalesByProduct
    1, @Sales output;
select @Sales as TotalSales;
go


create procedure sp_GetTotalPurchasesByCustomer
    @CustomerId int, @TotalPurchase decimal(10,2) output
as
begin
    select @TotalPurchase = isnull(sum(oi.Quantity * oi.UnitPrice), 0) from Orders o
    join OrderItem oi on o.OrderId = oi.OrderId where o.CustomerId = @CustomerId;
end;
declare @Purchase decimal(10,2);
exec sp_GetTotalPurchasesByCustomer
    1, @Purchase output;
select @Purchase as TotalPurchase;
go