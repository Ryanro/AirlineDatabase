USE "ZECHEN_LI_TEST";

CREATE FUNCTION GetTotalSaleByYearAndMonth
(@year int, @month int)
RETURNS decimal(19,4)
AS
BEGIN
	DECLARE @RETURNT decimal(19,4);

	SET @RETURNT = COALESCE((SELECT SUM(TotalDue) 
							FROM AdventureWorks2008R2.Sales.SalesOrderHeader
							WHERE CAST(DATEPART(year, OrderDate) AS int) = @year 
							AND 
							CAST(DATEPART(month, OrderDate) AS int) = @month), 0);

	RETURN @RETURNT;
					
END

SELECT dbo.GetTotalSaleByYearAndMonth(2002,7);

DROP FUNCTION GetTotalSaleByYearAndMonth;
