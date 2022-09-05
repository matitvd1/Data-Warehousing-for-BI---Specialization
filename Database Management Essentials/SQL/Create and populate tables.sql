create table Customer (
	CustNo varchar(8) constraint CustNotNull not null,
	CustName varchar(30) constraint CustNameNotNull not null,
	Address varchar(50) constraint AddressNotNull not null,
	Internal char(1) constraint InternalNotNull not null,
	Contact varchar(40) constraint ContactNotNull not null,
	Phone varchar(10) constraint PhoneNotNull not null,
	City varchar(30) constraint CityNotNull not null,
	State varchar(2) constraint StateNotNull not null,
	Zip varchar(8) constraint ZipNotNull not null,
	constraint PK_CUSTOMER primary key (CustNo)
	);

create table Facility (
	FacNo varchar(8) constraint FacNotNull not null,
	FacName varchar(50) constraint FacNameNotNull not null,
	constraint PK_FACILITY primary key (FacNo),
	constraint UNIQUE_FACNAME unique (FacName)
	);
	
create table Location (
	LocNo varchar(8) constraint LocNotNull not null,
	FacNo varchar(8),
	LocName varchar(50) constraint LocNameNotNull not null,
	constraint PK_LOCATION primary key (LocNo),
	constraint FK_FACNO foreign key (FacNo) 
	references Facility (FacNo) 
	);

create table ResourceTbl (
	ResNo varchar(8) constraint resNotNull not null primary key,
	ResName varchar(50) constraint ResNameNotNull not null,
	Rate varchar(10) constraint RateNotNull not null check (Rate > '0')
);

create table Employee (
	EmpNo varchar(8) constraint EmpNotNull not null primary key,
	EmpName varchar(40) constraint EmpNameNotNull not null,
	Department varchar(30) constraint DepartmentNotNull not null,
	Email varchar(40) constraint EmailNotNull not null,
	Phone varchar(10) constraint PhoneNotNull not null
	);

create table EventRequest (
	EventNo varchar(8) constraint EventNotNull not null primary key,
	DateHeld date constraint DateHeldNotNull not null,
	DateReq date constraint DateReqNotNull not null,
	FacNo varchar(8) constraint FacNoNotNull not null,
	CustNo varchar(8) constraint CustNoNotNull not null,
	DateAuth date,
	Status varchar(15) constraint StatusNotNull not null check (Status in ('Pending','Denied','Approved')),
	EstCost varchar(20) constraint EstCostNotNull not null,
	EstAudience varchar(15) constraint EstAudienceNotNull not null check (EstAudience > '0'),
	BudNo varchar (10), 
	constraint FK_FACILITY foreign key (FacNo) 
	references Facility (FacNo),
	constraint FK_CUSTOMER foreign key (CustNo) 
	references Customer (CustNo)
	);

create table EventPlan (
	PlanNo varchar(8) constraint PlanNoNotNull not null primary key,
	EventNo varchar(8) constraint EventNoNotNull not null,
	WorkDate date constraint WorkDateNotNull not null,
	Notes varchar(80),
	Activity varchar(15) constraint ActivityNotNull not null,
	EmpNo varchar(8), 
	constraint FK_EVENTREQUEST foreign key (EventNo) 
	references EventRequest (EventNo),
	constraint FK_EMPLOYEET foreign key (EmpNo) 
	references Employee (EmpNo)
	);

create table EventPlanLine (
	PlanNo varchar(8) constraint PlanNotNull not null,
	LineNo varchar(8) constraint LineNotNull not null,
	TimeStart timestamp constraint TimeStartNotNull not null,
	TimeEnd timestamp constraint TimeEndNotNull not null,
	NumberFld varchar(5) constraint NumberFldNotNull not null,
	LocNo varchar(8) constraint LocNotNull not null,
	ResNo varchar(8) constraint ResNotNull not null,	
	constraint PK_EVENTPLANLINE primary key (PlanNo,LineNo),
	constraint FK_EVENTPLAN foreign key (PlanNo)
	references EventPlan(PlanNo),
	constraint FK_LOCATION foreign key (LocNo)
	references Location(LocNo),
	constraint FK_RESOURCE foreign key (ResNo)
	references ResourceTbl(ResNo)
	)
	
alter table EventPlanLine add constraint StartEndTime check (TimeStart < TimeEnd);

Insert into EMPLOYEE (EMPNO,EMPNAME,DEPARTMENT,EMAIL,PHONE) values ('E100','Chuck Coordinator','Administration','chuck@colorado.edu','3-1111');
Insert into EMPLOYEE (EMPNO,EMPNAME,DEPARTMENT,EMAIL,PHONE) values ('E101','Mary Manager','Football','mary@colorado.edu','5-1111');
Insert into EMPLOYEE (EMPNO,EMPNAME,DEPARTMENT,EMAIL,PHONE) values ('E102','Sally Supervisor','Planning','sally@colorado.edu','3-2222');
Insert into EMPLOYEE (EMPNO,EMPNAME,DEPARTMENT,EMAIL,PHONE) values ('E103','Alan Administrator','Administration','alan@colorado.edu','3-3333');

select * from EMPLOYEE;

Insert into CUSTOMER (CUSTNO,CUSTNAME,ADDRESS,INTERNAL,CONTACT,PHONE,CITY,STATE,ZIP) values ('C100','Football','Box 352200','Y','Mary Manager','6857100','Boulder','CO','80309');
Insert into CUSTOMER (CUSTNO,CUSTNAME,ADDRESS,INTERNAL,CONTACT,PHONE,CITY,STATE,ZIP) values ('C101','Men''s Basketball','Box 352400','Y','Sally Supervisor','5431700','Boulder','CO','80309');
Insert into CUSTOMER (CUSTNO,CUSTNAME,ADDRESS,INTERNAL,CONTACT,PHONE,CITY,STATE,ZIP) values ('C103','Baseball','Box 352020','Y','Bill Baseball','5431234','Boulder','CO','80309');
Insert into CUSTOMER (CUSTNO,CUSTNAME,ADDRESS,INTERNAL,CONTACT,PHONE,CITY,STATE,ZIP) values ('C104','Women''s Softball','Box 351200','Y','Sue Softball','5434321','Boulder','CO','80309');
Insert into CUSTOMER (CUSTNO,CUSTNAME,ADDRESS,INTERNAL,CONTACT,PHONE,CITY,STATE,ZIP) values ('C105','High School Football','123 AnyStreet','N','Coach Bob','4441234','Louisville','CO','80027');

select * from CUSTOMER;

Insert into RESOURCETBL (RESNO,RESNAME,RATE) values ('R100','attendant',10);
Insert into RESOURCETBL (RESNO,RESNAME,RATE) values ('R101','police',15);
Insert into RESOURCETBL (RESNO,RESNAME,RATE) values ('R102','usher',10);
Insert into RESOURCETBL (RESNO,RESNAME,RATE) values ('R103','nurse',20);
Insert into RESOURCETBL (RESNO,RESNAME,RATE) values ('R104','janitor',15);
Insert into RESOURCETBL (RESNO,RESNAME,RATE) values ('R105','food service',10);

select * from RESOURCETBL;

Insert into FACILITY (FACNO,FACNAME) values ('F100','Football stadium');
Insert into FACILITY (FACNO,FACNAME) values ('F101','Basketball arena');
Insert into FACILITY (FACNO,FACNAME) values ('F102','Baseball field');
Insert into FACILITY (FACNO,FACNAME) values ('F103','Recreation room');

select * from FACILITY;

Insert into LOCATION (LOCNO,FACNO,LOCNAME) values ('L100','F100','Locker room');
Insert into LOCATION (LOCNO,FACNO,LOCNAME) values ('L101','F100','Plaza');
Insert into LOCATION (LOCNO,FACNO,LOCNAME) values ('L102','F100','Vehicle gate');
Insert into LOCATION (LOCNO,FACNO,LOCNAME) values ('L103','F101','Locker room');
Insert into LOCATION (LOCNO,FACNO,LOCNAME) values ('L104','F100','Ticket Booth');
Insert into LOCATION (LOCNO,FACNO,LOCNAME) values ('L105','F101','Gate');
Insert into LOCATION (LOCNO,FACNO,LOCNAME) values ('L106','F100','Pedestrian gate');

select * from LOCATION;

Insert into EVENTREQUEST (EVENTNO,DATEHELD,DATEREQ,CUSTNO,FACNO,DATEAUTH,STATUS,ESTCOST,ESTAUDIENCE,BUDNO) values ('E100','2018-10-25','2018-06-06','C100','F100','2018-06-08','Approved',5000,80000,'B1000');
Insert into EVENTREQUEST (EVENTNO,DATEHELD,DATEREQ,CUSTNO,FACNO,DATEAUTH,STATUS,ESTCOST,ESTAUDIENCE,BUDNO) values ('E101','2018-10-26','2018-07-28','C100','F100',NULL,'Pending',5000,80000,'B1000');
Insert into EVENTREQUEST (EVENTNO,DATEHELD,DATEREQ,CUSTNO,FACNO,DATEAUTH,STATUS,ESTCOST,ESTAUDIENCE,BUDNO) values ('E103','2018-09-21','2018-07-28','C100','F100','2018-08-01','Approved',5000,80000,'B1000');
Insert into EVENTREQUEST (EVENTNO,DATEHELD,DATEREQ,CUSTNO,FACNO,DATEAUTH,STATUS,ESTCOST,ESTAUDIENCE,BUDNO) values ('E102','2018-09-14','2018-07-28','C100','F100','2018-07-31','Approved',5000,80000,'B1000');
Insert into EVENTREQUEST (EVENTNO,DATEHELD,DATEREQ,CUSTNO,FACNO,DATEAUTH,STATUS,ESTCOST,ESTAUDIENCE,BUDNO) values ('E104','2018-12-03','2018-07-28','C101','F101','2018-07-31','Approved',2000,12000,'B1000');
Insert into EVENTREQUEST (EVENTNO,DATEHELD,DATEREQ,CUSTNO,FACNO,DATEAUTH,STATUS,ESTCOST,ESTAUDIENCE,BUDNO) values ('E105','2018-12-05','2018-07-28','C101','F101','2018-08-01','Approved',2000,10000,'B1000');
Insert into EVENTREQUEST (EVENTNO,DATEHELD,DATEREQ,CUSTNO,FACNO,DATEAUTH,STATUS,ESTCOST,ESTAUDIENCE,BUDNO) values ('E106','2018-12-12','2018-07-28','C101','F101','2018-07-31','Approved',2000,10000,'B1000');
Insert into EVENTREQUEST (EVENTNO,DATEHELD,DATEREQ,CUSTNO,FACNO,DATEAUTH,STATUS,ESTCOST,ESTAUDIENCE,BUDNO) values ('E107','2018-11-23','2018-07-28','C105','F100','2018-07-31','Denied',10000,5000,null);

select * from EVENTREQUEST;

Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P100','E100','2018-10-25','Standard operation','Operation','E102');
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P101','E104','2018-12-03','Watch for gate crashers','Operation','E100');
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P102','E105','2018-12-05','Standard operation','Operation','E102');
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P103','E106','2018-12-12','Watch for seat switching','Operation',null);
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P104','E101','2018-10-26','Standard cleanup','Cleanup','E101');
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P105','E100','2018-10-25','Light cleanup','Cleanup','E101');
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P199','E102','2018-12-10','ABC','Operation','E101');
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P299','E101','2018-10-26',NULL,'Operation','E101');
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P349','E106','2018-12-12',NULL,'Setup','E101');
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P85','E100','2018-10-25','Standard operation','Cleanup','E102');
Insert into EVENTPLAN (PLANNO,EVENTNO,WORKDATE,NOTES,ACTIVITY,EMPNO) values ('P95','E101','2018-10-26','Extra security','Cleanup','E102');

select * from EVENTPLAN;

Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P100',1,'2018-10-25 08:00:00','2018-10-25 017:00:00',2,'L100','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P100',2,'2018-10-25 12:00:00','2018-10-25 17:00:00', 2,'L101','R101');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P100',3,'2018-10-25 07:00:00','2018-10-25 16:30:00', 1,'L102','R102');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P100',4,'2018-10-25 18:00:00','2018-10-25 22:00:00', 2,'L100','R102');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P101',1,'2018-12-03 18:00:00','2018-12-03 20:00:00', 2,'L103','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P101',2,'2018-12-03 18:30:00','2018-12-03 19:00:00', 4,'L105','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P101',3,'2018-12-03 19:00:00','2018-12-03 20:00:00', 2,'L103','R103');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P102',1,'2018-12-05 18:00:00','2018-12-05 19:00:00', 2,'L103','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P102',2,'2018-12-05 18:00:00','2018-12-05 21:00:00', 4,'L105','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P102',3,'2018-12-05 19:00:00','2018-12-05 22:00:00', 2,'L103','R103');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P103',1,'2018-12-12 18:00:00','2018-12-12 21:00:00', 2,'L103','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P103',2,'2018-12-12 18:00:00','2018-12-12 21:00:00', 4,'L105','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P103',3,'2018-12-12 19:00:00','2018-12-12 22:00:00', 2,'L103','R103');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P104',1,'2018-10-26 18:00:00','2018-10-26 22:00:00', 4,'L101','R104');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P104',2,'2018-10-26 18:00:00','2018-10-26 22:00:00', 4,'L100','R104');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P105',1,'2018-10-25 18:00:00','2018-10-25 22:00:00', 4,'L101','R104');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P105',2,'2018-10-25 18:00:00','2018-10-25 22:00:00', 4,'L100','R104');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P199',1,'2018-12-10 08:00:00','2018-12-10 12:00:00', 1,'L100','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P349',1,'2018-12-10 12:00:00','2018-12-12 15:30:00', 1,'L103','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P85',1,'2018-10-25 09:00:00','2018-10-25 17:00:00',  5,'L100','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P85',2,'2018-10-25 08:00:00','2018-10-25 17:00:00',  2,'L102','R101');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P85',3,'2018-10-25 10:00:00','2018-10-25 15:00:00',  3,'L104','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P95',1,'2018-10-26 08:00:00','2018-10-26 17:00:00',  4,'L100','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P95',2,'2018-10-26 09:00:00','2018-10-26 17:00:00',  4,'L102','R101');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P95',3,'2018-10-26 10:00:00','2018-10-26 15:00:00',  4,'L106','R100');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P95',4,'2018-10-26 13:00:00','2018-10-26 17:00:00', 2,'L100','R103');
Insert into EVENTPLANLINE (PLANNO,LINENO,TIMESTART,TIMEEND,NUMBERFLD,LOCNO,RESNO) values ('P95',5,'2018-10-26 13:00:00','2018-10-26 17:00:00', 2,'L101','R104');

select * from EVENTPLANLINE;
