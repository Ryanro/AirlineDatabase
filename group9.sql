/* Cause Simon's server doesn't have enough space to create new database after I 
 * deleted my databse, so I just change Terry's database as our group databse*/

USE "Tianrui_Wei_Test";

ALTER DATABASE Tianrui_Wei_Test MODIFY NAME = "GROUP9_INFO6210" ;

USE "GROUP9_INFO6210";

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
	airport_name VARCHAR(45) NOT NULL,
	city_code INT NOT NULL,
	country_code INT NOT NULL
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





