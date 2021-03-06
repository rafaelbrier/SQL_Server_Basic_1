USE [DB_Testes]
GO

/*
DATETIME: FORMAT > '20120618 10:34:09 AM' > 'YYYYMMDD HH:mm:ss XM'
*/

CREATE TABLE ProcAvailable
(
	procID INT IDENTITY(1,1),
	name varchar(200) NOT NULL UNIQUE,
	schedulePeriod nvarchar(10) NOT NULL,
	scheduleTime TIME(0) NOT NULL,
	estimatedRunTime TIME(3),
	createdAt DATETIME2(0) NOT NULL,

	PRIMARY KEY (procID)
); 

GO

CREATE TABLE ProcLogExec
(
	logExecID INT IDENTITY(1,1),
	procID INT NOT NULL,
	startPointID INT,

	startDate DATETIME2(0),
	endDate DATETIME2(0),

	execState varchar(10) NOT NULL,

	execStatus char(1) NOT NULL,
	
	PRIMARY KEY (logExecID),
	FOREIGN KEY (startPointID) REFERENCES ProcLogExec (logExecID),
	FOREIGN KEY (procID) REFERENCES ProcAvailable (procID)
); 

CREATE TABLE ProcLogError
(
	logErrorID INT IDENTITY(1,1),
	logExecID INT,
	procID INT,

	errorMessage varchar(2000) NOT NULL,

	createdAt DATETIME2(0) NOT NULL,

	PRIMARY KEY (logErrorID),
	FOREIGN KEY (logExecID) REFERENCES ProcLogExec (logExecID),
	FOREIGN KEY (procID) REFERENCES ProcAvailable (procID)
); 

GO



