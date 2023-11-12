CREATE OR ALTER TRIGGER after_update_info
ON [AdventureWorksLT2019].[dbo].[Price_history]
AFTER INSERT
AS 
PRINT 'VALUE CHANGED IN THE Price_List TABLE. SEE DETAILS IN THE Price_history TABLE'
GO
