/* Cause Simon's server doesn't have enough space to create new database after I 
 * deleted my databse, so I just change Terry's database as our group databse*/

USE "Tianrui_Wei_Test";

ALTER DATABASE Tianrui_Wei_Test MODIFY NAME = "GROUP9_INFO6210" ;

USE "GROUP9_INFO6210";

---- create table ----

CREATE SCHEMA Passenger;
CREATE SCHEMA Flight;
CREATE SCHEMA Aircraft;
CREATE SCHEMA Crew;
CREATE SCHEMA Cost;

CREATE TABLE Passenger.passenger (
	psg_id INT NOT NULL,
	psg_type INT NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	middle_name VARCHAR(45) NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	gender INT NOT NULL,
	phone_no INT NOT NULL,
	email VARCHAR(45) NOT NULL,
	birthday DATE NOT NULL,
		CONSTRAINT PKPassenger PRIMARY KEY CLUSTERED (psg_id, psg_type)
);

-- add comments to the column
EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Identification card/ passport', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'passenger', @level2type = N'COLUMN',
@level2name = N'psg_id';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Domestic = 0/ international = 1', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'passenger', @level2type = N'COLUMN',
@level2name = N'psg_type';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Male = 1 / female = 0', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'passenger', @level2type = N'COLUMN',
@level2name = N'gender';

CREATE TABLE Passenger.ticket (
	ticket_no INT NOT NULL PRIMARY KEY,
	psg_id INT NOT NULL,
	psg_type INT NOT NULL,
	ticket_type INT NOT NULL,
	ticket_price Money NOT NULL,
	baggage_price Money NOT NULL,
		CONSTRAINT FKTicket FOREIGN KEY (psg_id, psg_type) REFERENCES Passenger.passenger(psg_id, psg_type)
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Domestic = 0/ international = 1', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'ticket', @level2type = N'COLUMN',
@level2name = N'psg_type';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'economy = 0 / business = 1 / first class = 2', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'ticket', @level2type = N'COLUMN',
@level2name = N'ticket_type';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The additional baggage price', @level0type = N'SCHEMA',
@level0name = N'Passenger', @level1type = N'TABLE',
@level1name = N'ticket', @level2type = N'COLUMN',
@level2name = N'baggage_price';

CREATE TABLE Flight.airport (
	airport_code INT NOT NULL PRIMARY KEY,
	airport_name VARCHAR(45) NOT NULL
);

CREATE TABLE Flight.route (
	route_id INT NOT NULL PRIMARY KEY,
	departure INT NOT NULL
		REFERENCES Flight.airport(airport_code),
	destination INT NOT NULL
		REFERENCES Flight.airport(airport_code),
	distance FLOAT NOT NULL
)

CREATE TABLE Flight.flight (
	flight_no INT NOT NULL PRIMARY KEY
)

CREATE TABLE Flight.flight_legs (
	flight_no INT NOT NULL
		REFERENCES Flight.flight(flight_no),
	leg_no INT NOT NULL,
	dep_time DATETIME NOT NULL,
	route_id INT NOT NULL
		REFERENCES Flight.route(route_id),
	arr_time DATETIME NOT NULL,
		CONSTRAINT PKFlightLegs PRIMARY KEY CLUSTERED (flight_no, leg_no)
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The planned departure time', @level0type = N'SCHEMA',
@level0name = N'Flight', @level1type = N'TABLE',
@level1name = N'flight_legs', @level2type = N'COLUMN',
@level2name = N'dep_time';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The planned arrival time', @level0type = N'SCHEMA',
@level0name = N'Flight', @level1type = N'TABLE',
@level1name = N'flight_legs', @level2type = N'COLUMN',
@level2name = N'arr_time';

CREATE TABLE Aircraft.aircraft_model (
	aircraft_model_id INT NOT NULL PRIMARY KEY,
	first_seats INT NOT NULL,
	business_seats INT NOT NULL,
	economy_seats INT NOT NULL
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The sum number of the first seats', @level0type = N'SCHEMA',
@level0name = N'Aircraft', @level1type = N'TABLE',
@level1name = N'aircraft_model', @level2type = N'COLUMN',
@level2name = N'first_seats';

CREATE TABLE Aircraft.aircraft (
	aircraft_id INT NOT NULL PRIMARY KEY,
	aircraft_model_id INT NOT NULL
		REFERENCES Aircraft.aircraft_model(aircraft_model_id),
	aircraft_year INT NOT NULL
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The year aircraft start to be used', @level0type = N'SCHEMA',
@level0name = N'Aircraft', @level1type = N'TABLE',
@level1name = N'aircraft', @level2type = N'COLUMN',
@level2name = N'aircraft_year';

CREATE TABLE Flight.leg_instance (
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	date_of_travel DATE NOT NULL,
	dep_time DATETIME NOT NULL,
	arr_time DATETIME NOT NULL,
	aircraft_id INT NOT NULL
		REFERENCES Aircraft.aircraft(aircraft_id),
		CONSTRAINT PKLegInstance PRIMARY KEY CLUSTERED (flight_no, leg_no, date_of_travel),
		CONSTRAINT FKLegInstance FOREIGN KEY (flight_no, leg_no) REFERENCES Flight.flight_legs(flight_no, leg_no)
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The actual departure time', @level0type = N'SCHEMA',
@level0name = N'Flight', @level1type = N'TABLE',
@level1name = N'leg_instance', @level2type = N'COLUMN',
@level2name = N'dep_time';

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'The actual arrival time', @level0type = N'SCHEMA',
@level0name = N'Flight', @level1type = N'TABLE',
@level1name = N'leg_instance', @level2type = N'COLUMN',
@level2name = N'arr_time';

CREATE TABLE Flight.seat (
	seat_no INT NOT NULL,
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	date_of_travel DATE NOT NULL,
		CONSTRAINT PKSeat PRIMARY KEY CLUSTERED (seat_no, flight_no, leg_no, date_of_travel),
		CONSTRAINT FKSeat FOREIGN KEY (flight_no, leg_no, date_of_travel) REFERENCES Flight.leg_instance(flight_no, leg_no, date_of_travel)
);


CREATE TABLE Passenger.reservation (
	rev_id INT NOT NULL PRIMARY KEY,
	ticket_no INT NOT NULL
		REFERENCES Passenger.ticket(ticket_no),
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	date_of_travel DATE NOT NULL,
	seat_no INT NOT NULL,
		CONSTRAINT FKReservation FOREIGN KEY (seat_no, flight_no, leg_no, date_of_travel) REFERENCES Flight.seat(seat_no, flight_no, leg_no, date_of_travel)
);

CREATE TABLE Cost.ground_cost (
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	date_of_travel DATE NOT NULL,
	wearing Money NOT NULL,
	maintance Money NOT NULL,
	airport_usage_fee Money NOT NULL,
		CONSTRAINT PKGroundCost PRIMARY KEY CLUSTERED (flight_no, leg_no, date_of_travel),
		CONSTRAINT FKGroundCost FOREIGN KEY (flight_no, leg_no, date_of_travel) REFERENCES Flight.leg_instance(flight_no, leg_no, date_of_travel)
);

CREATE TABLE Cost.flight_cost (
	flight_no INT NOT NULL,
	leg_no INT NOT NULL,
	fuel Money NOT NULL,
	food Money NOT NULL,
		CONSTRAINT PKFlightCost PRIMARY KEY CLUSTERED (flight_no, leg_no),
		CONSTRAINT FKFlightCost FOREIGN KEY (flight_no, leg_no) REFERENCES Flight.flight_legs(flight_no, leg_no)
);

CREATE TABLE Crew.job (
	job_id INT NOT NULL PRIMARY KEY,
	job_name VARCHAR(45) NOT NULL,
	salary Money NOT NULL
);

CREATE TABLE Crew.staff (
	staff_id INT NOT NULL PRIMARY KEY,
	job_id INT NOT NULL
		REFERENCES Crew.job(job_id),
	last_name VARCHAR(45) NOT NULL,
	middle_name VARCHAR(45) NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	gender INT NOT NULL,
	phone_no INT NOT NULL,
	email VARCHAR(45) NOT NULL,
	birthday DATE NOT NULL
);

EXEC sys.sp_addextendedproperty @name = N'MS_Description',
@value = N'Male = 1 / female = 0', @level0type = N'SCHEMA',
@level0name = N'Crew', @level1type = N'TABLE',
@level1name = N'staff', @level2type = N'COLUMN',
@level2name = N'gender';

CREATE TABLE Crew.crew (
	crew_id INT NOT NULL
		REFERENCES Crew.staff(staff_id),
	flight_no INT NOT NULL
		REFERENCES Flight.flight(Flight.flight),
	date_of_travel DATE NOT NULL,
		CONSTRAINT PKCrew PRIMARY KEY CLUSTERED (crew_id, flight_no, date_of_travel)
);

/*
 * change the data type of route_id from INT to VARCHAR
*/
ALTER TABLE Flight.flight_legs  
DROP CONSTRAINT FK__flight_le__route__2180FB33; 

ALTER TABLE Flight.route  
DROP CONSTRAINT PK__route__28F706FE40D56F69; 

ALTER TABLE Flight.route 
ALTER COLUMN route_id VARCHAR(10) NOT NULL; 

ALTER TABLE Flight.route ADD PRIMARY KEY (route_id);

ALTER TABLE Flight.flight_legs 
ALTER COLUMN route_id VARCHAR(10) NOT NULL; 

ALTER TABLE Flight.flight_legs ADD FOREIGN KEY (route_id) REFERENCES Flight.route(route_id);

/*
 * change the data type of airport_code from INT to VARCHAR
*/
ALTER TABLE Flight.route  
DROP CONSTRAINT FK__route__departure__1332DBDC, FK__route__destinati__14270015; 

ALTER TABLE Flight.airport  
DROP CONSTRAINT PK__airport__E949ADC6C466BD05; 

ALTER TABLE Flight.airport 
ALTER COLUMN airport_code VARCHAR(10) NOT NULL; 

ALTER TABLE Flight.airport ADD PRIMARY KEY (airport_code);

ALTER TABLE Flight.route 
ALTER COLUMN departure VARCHAR(10) NOT NULL; 

ALTER TABLE Flight.route 
ALTER COLUMN destination VARCHAR(10) NOT NULL;

ALTER TABLE Flight.route ADD FOREIGN KEY (departure) REFERENCES Flight.airport(airport_code);

ALTER TABLE Flight.route ADD FOREIGN KEY (destination) REFERENCES Flight.airport(airport_code);


/*
 * Insert data to Flight Section
*/

-- insert data to airpot entity
INSERT INTO Flight.airport VALUES ('BOS', 'Boston'),
	('PEK', 'Beijing'),('TXL', 'Berlin'),('SEA', 'Seattle'),
	('YYZ', 'Toronto'),('SJC', 'San Jose'),('BRU', 'Brussels'),
	('ORD', 'Chicago'),('SVO', 'Moscow'),('SHA', 'Shanghai'),
	('LED', 'St. Petersburg');


-- create stored procedure to insert data into route entity
CREATE PROCEDURE addRoute
(@departure VARCHAR(10), @destination VARCHAR(10), @distance FLOAT, @depName VARCHAR(10) = '', @desName VARCHAR(10) = '')
AS
BEGIN
	DECLARE @routeId VARCHAR(10) = '';
	SELECT @routeId = route_id FROM Flight.route WHERE route_id = CONCAT(@departure, @destination);
	IF @routeId <> ''
		PRINT 'Unable to insert data because the route_id has already existed!'
	ELSE 
		BEGIN
			DECLARE @dep VARCHAR(10) = '';
			DECLARE @des VARCHAR(10) = '';
			SELECT @dep = airport_code FROM Flight.airport WHERE airport_code = @departure;
			SELECT @des = airport_code FROM Flight.airport WHERE airport_code = @destination;
			IF @dep <> '' AND @des <> ''
				BEGIN
					INSERT INTO Flight.route (route_id, departure, destination, distance)
						VALUES(CONCAT(@departure, @destination), @departure, @destination, @distance);
					INSERT INTO Flight.route (route_id, departure, destination, distance)
						VALUES(CONCAT(@destination, @departure), @destination, @departure, @distance);
					PRINT 'SUCCESFUL INSERT DATA INTO Flight.route!';
				END
			ELSE
				IF @dep = ''
					IF @depName = ''
						PRINT 'Add parameter @depName to this procedure';
					ELSE
						BEGIN
							INSERT INTO Flight.airport VALUES (@departure, @depName);
							PRINT 'Insert new data into airport table successfully!';
							INSERT INTO Flight.route (route_id, departure, destination, distance)
								VALUES(CONCAT(@departure, @destination), @departure, @destination, @distance);
							INSERT INTO Flight.route (route_id, departure, destination, distance)
								VALUES(CONCAT(@destination, @departure), @destination, @departure, @distance);
							PRINT 'SUCCESFUL INSERT DATA INTO Flight.route!';
						END
						
				IF @des = ''
					IF @desName = ''
						PRINT 'Add parameter @desName to this procedure';
					ELSE
						BEGIN
							INSERT INTO Flight.airport VALUES (@destination, @desName);
							PRINT 'Insert new data into airport table successfully!';
							INSERT INTO Flight.route (route_id, departure, destination, distance)
								VALUES(CONCAT(@departure, @destination), @departure, @destination, @distance);
							INSERT INTO Flight.route (route_id, departure, destination, distance)
								VALUES(CONCAT(@destination, @departure), @destination, @departure, @distance);
							PRINT 'SUCCESFUL INSERT DATA INTO Flight.route!';
						END
		END
END

EXEC addRoute 'BOS', 'PEK', 6737;
EXEC addRoute 'TXL', 'PEK', 4582;
EXEC addRoute 'SEA', 'SHA', 5407;
EXEC addRoute 'BRU', 'PEK', 4951;
EXEC addRoute 'ORD', 'PEK', 6590;
EXEC addRoute 'SVO', 'PEK', 3610;
EXEC addRoute 'BOS', 'SHA', 4263;
EXEC addRoute 'LED', 'PEK', 3774;
EXEC addRoute 'YYZ', 'PEK', 6578;
EXEC addRoute 'SJC', 'PEK', 8739;
EXEC addRoute 'PEK', 'CAN', 1165;
EXEC addRoute 'PEK', 'CAN', 1165, @desName = 'Guangzhou';

/* DROP PROC addRoute; */


/*
 * change the flight_no to IDENTITY with the seed = 10000 and increment = 1
*/
ALTER TABLE Flight.flight_legs  
DROP CONSTRAINT FK__flight_le__fligh__04AFB25B; 

ALTER TABLE Flight.flight  
DROP CONSTRAINT PK__flight__E3700CB17B6FC3A9; 

ALTER TABLE Flight.flight 
ADD flight_no1 INT IDENTITY(10001,1); 

ALTER TABLE Flight.flight 
DROP COLUMN flight_no;

EXEC sp_RENAME 'Flight.flight.flight_no1' , 'flight_no', 'COLUMN'

ALTER TABLE Flight.flight ADD PRIMARY KEY (flight_no);

ALTER TABLE Flight.flight_legs ADD FOREIGN KEY (flight_no) REFERENCES Flight.flight(flight_no);


-- insert data to flight entity automatically
CREATE PROCEDURE addFlight
(@num int)
AS
BEGIN
	WHILE (@num > 0)
	BEGIN
		INSERT Flight.flight DEFAULT VALUES;
		SET @num = @num - 1;
	END
END

EXEC addFlight 3;
EXEC addFlight 7;

/* drop proc addFlight */

-- added a identity attribute in Passenger.passenger table
ALTER TABLE Passenger.passenger ADD passenger_no INT IDENTITY(100,1);

--ALTER TABLE Passenger.passenger ADD PRIMARY KEY (passenger_no);

-- changing the data type for phone number attribute in Passenger.passenger table
ALTER TABLE Passenger.passenger ALTER COLUMN phone_no BIGINT;

-- changes made to change the primary key of Passenger.passenger Table
ALTER TABLE Passenger.ticket 
DROP CONSTRAINT FKTicket;

ALTER TABLE Passenger.passenger 
DROP CONSTRAINT PKPassenger;

ALTER TABLE Passenger.passenger DROP COLUMN passenger_no;

ALTER TABLE Passenger.passenger ADD passenger_no INT PRIMARY KEY IDENTITY(100,1)

ALTER TABLE Passenger.passenger ALTER  COLUMN psg_id VARCHAR(45);


-- chnages made in the Passenger.ticket table adding new foreign key
ALTER TABLE Passenger.ticket DROP COLUMN psg_id, psg_type;

ALTER TABLE Passenger.ticket ADD passenger_no INT FOREIGN KEY REFERENCES Passenger.passenger(passenger_no)


--insertion of data in Passenger.passenger table.

INSERT INTO Passenger.passenger VALUES ( '1342453', 0, 'Wayne', 'K.','Peter', 1, 4256245678, 'waynep@gmail.com','01/06/1990'),
( '654163', 0, 'Wei', 'S.','Tianrui', 1, 9096145678, 'tianruiwei@gmail.com','05/06/1994'),
( 'SY4560', 1, 'Malfoy', 'T.','Amanda', 0, 3234145998, 'malfoyamanda@gmail.com','12/06/1982'),
( 'HKS1061', 1, 'Walter', 'A.','Jake', 1, 6071915522, 'walterjake@gmail.com','11/09/1991'),
( '7474540', 0, 'Han', 'V.','Shang', 1, 3608708986, 'hanshang@gmail.com','10/12/1993'),
( '457540', 0, 'Li', 'V.','Zechen', 1, 2063108681, 'lizec@gmail.com','07/07/1996'),
( 'GHI8641', 1, 'Dinkling', 'Z.','Amy', 0, 2066115971, 'amyz@gmail.com','04/16/1980'),
( 'NMO5361', 1, 'Wayne', 'A.','Josh', 1, 2068125712, 'waynejosh@gmail.com','01/29/1985'),
( 'YIN3535', 1, 'McDougall', 'S.','Harry', 1, 4252349678, 'harry12@gmail.com','09/19/1978'),
( '890565', 0, 'Hun', 'C.','Mei', 0, 2068809298, 'hunm@gmail.com','07/15/1992')

--DELETE FROM Passenger.passenger WHERE first_name='Peter';

-- insertion of data in Passenger.ticket table.

--DELETE FROM Passenger.ticket;

INSERT INTO Passenger.ticket (ticket_no, ticket_type, ticket_price, baggage_price, passenger_no) 
VALUES (2123, 0, 90.95, 40, 100), (7321, 1, 399.25, 60, 101), (8563, 0, 94.29, 40, 102),
(2321, 2, 794.22, 80, 103), (9654, 2, 858.80, 80, 104), (9231, 1, 501.96, 60, 105), (2945, 0, 90.95, 40, 106), 
(3223, 1, 399.25, 60, 107), (0852, 2, 794.22, 80, 108), (5439, 1, 399.25, 60, 109)

----Insert data into crew.staff
insert into [Crew].[staff] values (1,1,'lebron','l','james','0',2061234567,'james.gmail.com','06/21/1994')
,(2,2,'dwight','m','wade','0',2061234568,'wade.gmail.com','08/02/1982'),
(3,3,'chris','o','paul','0',2061234569,'paul.gmail.com','06/02/1988'),
(4,4,'camero','r','anthony','0',2061234570,'anthony.gmail.com','05/31/1971'),
(5,5,'steven','w','curry','1',2061234571,'curry.gmail.com','03/31/1979'),
(6,6,'camero','r','anthony','0',2061234572,'anthony.gmail.com','07/03/1976'),
(7,7,'jiayi','w','ren','1',2061234573,'ren.gmail.com','10/03/1993'),
(8,8,'james','h','harden','1',2061234574,'harden.gmail.com','04/01/1973'),
(9,9,'paul','c','george','0',2061234575,'george.gmail.com','02/06/1968'),
(10,10,'kevin','n','durant','0',2061234576,'durant.gmail.com','09/01/1977')

insert into [Crew].[crew] values (1901,10001,'08/01/2019'),(1902,10001,'08/01/2019'),
(1903,10001,'08/01/2019'),(1904,10001,'08/01/2019'),(1905,10001,'08/01/2019'),
(1906,10001,'08/01/2019'),(1907,10001,'08/01/2019'),(1908,10001,'08/01/2019'),(1911,10011,'08/01/2019'),(1912,10011,'08/01/2019'),
(1913,10011,'08/01/2019'),(1914,10011,'08/01/2019'),(1915,10011,'08/01/2019'),(1916,10011,'08/01/2019'),
(1917,10011,'08/01/2019'),(1918,10011,'08/01/2019')

insert into [Crew].[staff] values (11,1,'zhiqi','x','kang','0',2061234577,'kang.gmail.com','01/28/1993')
,(12,2,'zhun','h','song','0',2061234578,'song.gmail.com','08/02/1996'),
(13,2,'zhaohong','b','zhu','1',2061234579,'zhu.gmail.com','06/22/1992'),
(14,2,'sijian','g','zhou','0',2061234580,'zhou.gmail.com','05/27/1997'),
(15,2,'weijin','l','zhang','1',2061234581,'zhang.gmail.com','03/11/1987'),
(16,2,'chengyuan','k','zhou','0',2061234582,'zhou1.gmail.com','07/03/1998'),
(17,2,'yuerui','h','guo','1',2061234583,'guo.gmail.com','10/01/1999'),
(18,2,'da','s','deng','0',2061234584,'deng.gmail.com','08/12/1993'),
(19,2,'ke','c','huang','1',2061234585,'huang.gmail.com','02/08/1998'),
(20,3,'yifan','h','li','0',2061234586,'li.gmail.com','09/13/1991'),
(21,3,'siyang','c','liu','0',2061234587,'liu.gmail.com','09/27/1995'),
(22,3,'yan','s','xi','1',2061234588,'xi.gmail.com','04/14/1997')

insert into [Crew].[crew] values (1,10001,'08/01/2019'),(2,10001,'08/01/2019'),
(12,10001,'08/01/2019'),(13,10001,'08/01/2019'),(14,10001,'08/01/2019'),
(15,10001,'08/01/2019'),(16,10001,'08/01/2019'),(20,10001,'08/01/2019'),(23,10011,'08/01/2019'),(17,10011,'08/01/2019'),
(24,10011,'08/01/2019'),(25,10011,'08/01/2019'),(26,10011,'08/01/2019'),(27,10011,'08/01/2019'),
(28,10011,'08/01/2019'),(22,10011,'08/01/2019')

insert into [Crew].[staff] values 
(23,2,'zhenying','b','lin','1',2061234589,'lin.gmail.com','06/22/1991'),
(24,2,'ying','y','li','0',2061234590,'li1.gmail.com','05/27/1982'),
(25,2,'lixian','n','tang','1',2061234591,'tang.gmail.com','03/11/1986'),
(26,2,'jie','k','shen','0',2061234592,'shen.gmail.com','07/03/1993'),
(27,2,'shan','h','huang','1',2061234593,'huang.gmail.com','10/01/1997'),
(28,2,'fusheng','l','ren','0',2061234594,'ren1.gmail.com','08/12/1969'),
(29,2,'xiaoyu','c','liu','1',2061234595,'liu3.gmail.com','02/08/1987')