-- query used to extract data
-- headers
select 'Product_name', 'Color', 'Product_category', 'Quantity', 'Unit_Price', 'Total_Price'
union all
-- extract data
select a.Name as Product_name, isnull(a.Color, 'N/A'), b.Name as Product_category, convert(varchar(20),c.OrderQty), 
convert(varchar(20),c.UnitPrice), convert(varchar(20), c.OrderQty * c.UnitPrice)
from AdventureWorksLT2019.SalesLT.Product a
inner join AdventureWorksLT2019.SalesLT.ProductCategory b 
on a.ProductCategoryID = b.ProductCategoryID
inner join AdventureWorksLT2019.SalesLT.SalesOrderDetail c
on a.ProductID = c.ProductID
go

--procedure for export and save output in .csv format 
create or alter procedure Create_report (@destination varchar(255)) 
as
declare @path varchar(255), @time_stamp date, @bcp1 varchar (955)
set @time_stamp = convert(date, getdate(), 5)
set @path = @destination + '.' + ltrim(@time_stamp) + '.csv'
set @bcp1 = 'bcp "select ''Product_name'', ''Color'', ''Product_category'', ''Quantity'', ''Unit_Price'', ''Total_Price'' union all select a.Name as Product_name, isnull(a.Color, ''N/A''), b.Name as Product_category, convert(varchar(20),c.OrderQty), convert(varchar(20),c.UnitPrice), convert(varchar(20), c.OrderQty * c.UnitPrice) from AdventureWorksLT2019.SalesLT.Product a inner join AdventureWorksLT2019.SalesLT.ProductCategory b on a.ProductCategoryID = b.ProductCategoryID inner join AdventureWorksLT2019.SalesLT.SalesOrderDetail c on a.ProductID = c.ProductID" queryout '+ @path + ' -T -c'
exec xp_cmdshell @bcp1

-- paste your destination
exec [dbo].[Create_report] @destination = 'C:\SQL_Server1\Sales'