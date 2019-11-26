/* Cause Simon's server still doesn't have enough space to create new database after I 
 * deleted my databse, so I just change Terry's database as our group databse*/

USE "Tianrui_Wei_Test";

ALTER DATABASE Tianrui_Wei_Test MODIFY NAME = "GROUP9_INFO6210" ;

USE "GROUP9_INFO6210";

CREATE TABLE dbo.passenger (
	psg_id INT NOT NULL,
	psg_type INT NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	middle_name VARCHAR(45) NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	gender INT NOT NULL,
	phone_no INT NOT NULL,
	email VARCHAR(45) NOT NULL,
	birthday DATE NOT NULL
		CONSTRAINT PKPassenger PRIMARY KEY CLUSTERED (psg_id, psg_type)
)

-- add comments to the column
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Identification card/ passport', @level0type = N'SCHEMA',
@level0name = N'dbo', @level1type = N'TABLE',
@level1name = N'passenger', @level2type = N'COLUMN',
@level2name = N'psg_id';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Domestic = 0/ international = 1', @level0type = N'SCHEMA',
@level0name = N'dbo', @level1type = N'TABLE',
@level1name = N'passenger', @level2type = N'COLUMN',
@level2name = N'psg_type';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Male = 0 / female = 1', @level0type = N'SCHEMA',
@level0name = N'dbo', @level1type = N'TABLE',
@level1name = N'passenger', @level2type = N'COLUMN',
@level2name = N'gender';

