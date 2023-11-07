CREATE TABLE Price_history (
	REASON varchar (30), 
	PRODUCT_ID int, 
	OLD_VALUE int, 
	NEW_VALUE int, 
	Modified_date date
)

GO
-- create new table with sample data
SELECT SalesOrderDetailID, ProductID, UnitPrice, ModifiedDate
into Price_List
FROM [SalesLT].[SalesOrderDetail]
GO

CREATE OR ALTER PROCEDURE [dbo].[PRICE_CHANGE] @REASON nvarchar (30), @PRODUCT_ID INT, @NEW_VALUE MONEY
AS
IF @REASON = 'UPDATE' OR @REASON = 'update'
	IF @PRODUCT_ID NOT IN (SELECT DISTINCT ProductID FROM Price_List)
	PRINT 'WRONG PRODUCT_ID VALUE. PLEASE CHOOSE SAMPLE PRODUCT_ID FROM PRICE_LIST TABLE'
	ELSE
		BEGIN
		DECLARE @OLD_VALUE money
		SET @OLD_VALUE = (SELECT distinct UNITPRICE FROM Price_List where ProductID = @PRODUCT_ID) 
		INSERT INTO Price_history (REASON, PRODUCT_ID, OLD_VALUE, NEW_VALUE, Modified_date)
		VALUES (@REASON, @PRODUCT_ID, @OLD_VALUE, @NEW_VALUE, GETDATE())
		UPDATE Price_List 
		SET UnitPrice = @NEW_VALUE, ModifiedDate = GETDATE()
		WHERE ProductID = @PRODUCT_ID
		END;
ELSE
	PRINT 'WRONG ''REASON'' PARAMETER VALUE'
GO

-- change variables product_id & new_value 
EXEC [dbo].[PRICE_CHANGE] @REASON = 'UPDATE', @PRODUCT_ID = 708, @NEW_VALUE = 30

select * from Price_List order by ProductID
SELECT * FROM Price_history
GO
