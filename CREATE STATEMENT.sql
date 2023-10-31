--BEGIN TRANSACTION
-- check if the database exists
IF EXISTS(SELECT * FROM sys.databases WHERE name='PBL3')
BEGIN
    -- drop the database
    USE MASTER;
    ALTER DATABASE PBL3 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PBL3;
END
CREATE DATABASE PBL3;
USE PBL3;

-- CREATE administrative_regions TABLE
CREATE TABLE [administrative_regions] (
	[id] integer NOT NULL,
	[name] NVARCHAR(255) NOT NULL,
	[name_en] NVARCHAR(255) NOT NULL,
	[code_name] NVARCHAR(255) NULL,
	[code_name_en] NVARCHAR(255) NULL,
	CONSTRAINT administrative_regions_pkey PRIMARY KEY CLUSTERED ([id] ASC)
);


-- CREATE administrative_units TABLE
CREATE TABLE [administrative_units] (
	[id] integer NOT NULL,
	[full_name] NVARCHAR(255) NULL,
	[full_name_en] NVARCHAR(255) NULL,
	[short_name] NVARCHAR(255) NULL,
	[short_name_en] NVARCHAR(255) NULL,
	[code_name] NVARCHAR(255) NULL,
	[code_name_en] NVARCHAR(255) NULL,
	CONSTRAINT [administrative_units_pkey] PRIMARY KEY CLUSTERED ([id] ASC)
);


-- CREATE provinces TABLE
CREATE TABLE [provinces] (
	[code] NVARCHAR(20) NOT NULL,
	[name] NVARCHAR(255) NOT NULL,
	[name_en] NVARCHAR(255) NULL,
	[full_name] NVARCHAR(255) NOT NULL,
	[full_name_en] NVARCHAR(255) NULL,
	[code_name] NVARCHAR(255) NULL,
	[administrative_unit_id] integer NULL,
	[administrative_region_id] integer NULL,
	CONSTRAINT [provinces_pkey] PRIMARY KEY CLUSTERED ([code] ASC)
);


-- provinces foreign keys

ALTER TABLE [provinces] ADD CONSTRAINT [provinces_administrative_region_id_fkey] FOREIGN KEY ([administrative_region_id]) REFERENCES [administrative_regions]([id]);
ALTER TABLE [provinces] ADD CONSTRAINT [provinces_administrative_unit_id_fkey] FOREIGN KEY ([administrative_unit_id]) REFERENCES [administrative_units]([id]);


-- CREATE districts TABLE
CREATE TABLE [districts] (
	[code] NVARCHAR(20) NOT NULL,
	[name] NVARCHAR(255) NOT NULL,
	[name_en] NVARCHAR(255) NULL,
	[full_name] NVARCHAR(255) NULL,
	[full_name_en] NVARCHAR(255) NULL,
	[code_name] NVARCHAR(255) NULL,
	[province_code] NVARCHAR(20) NULL,
	[administrative_unit_id] integer NULL,
	CONSTRAINT [districts_pkey] PRIMARY KEY CLUSTERED ([code] ASC)
);


-- districts foreign keys

ALTER TABLE [districts] ADD CONSTRAINT [districts_administrative_unit_id_fkey] FOREIGN KEY ([administrative_unit_id]) REFERENCES [administrative_units]([id]);
ALTER TABLE [districts] ADD CONSTRAINT [districts_province_code_fkey] FOREIGN KEY ([province_code]) REFERENCES [provinces]([code]);



-- CREATE wards TABLE
CREATE TABLE [wards] (
	[code] NVARCHAR(20) NOT NULL,
	[name] NVARCHAR(255) NOT NULL,
	[name_en] NVARCHAR(255) NULL,
	[full_name] NVARCHAR(255) NULL,
	[full_name_en] NVARCHAR(255) NULL,
	[code_name] NVARCHAR(255) NULL,
	[district_code] NVARCHAR(20) NULL,
	[administrative_unit_id] integer NULL,
	CONSTRAINT [wards_pkey] PRIMARY KEY CLUSTERED ([code] ASC)
);


-- wards foreign keys

ALTER TABLE [wards] ADD CONSTRAINT [wards_administrative_unit_id_fkey] FOREIGN KEY ([administrative_unit_id]) REFERENCES [administrative_units]([id]);
ALTER TABLE [wards] ADD CONSTRAINT [wards_district_code_fkey] FOREIGN KEY ([district_code]) REFERENCES [districts]([code]);
CREATE TABLE [Notification] (
    [Id] INT IDENTITY(1,1) NOT NULL
    ,[PostingDate] DATE NOT NULL
    ,[Content] TEXT
)
CREATE TABLE [Department] (
/*
	1 : Tổ toán
	2 : Tổ vật lý - công nghệ
	3 : Tổ hoá học
	4 : Tổ sinh
	5 : Tổ tiếng anh
	6 : Tổ ngữ văn
	7 : Tổ lịch sử
	8 : Tổ địa lý
	9 : Tổ GDCD 
	10 : Tổ tin học
	11 : Tổ thể dục - GDQP&AN
*/
    [departmentId] TINYINT IDENTITY(1,1) NOT NULL
    ,[departmentName] NVARCHAR(50) NOT NULL
    ,PRIMARY KEY CLUSTERED ([departmentId] ASC)
);
CREATE TABLE [Degree] (
    [degreeID] TINYINT IDENTITY(1,1) NOT NULL
    ,[description] NVARCHAR (50) NOT NULL
    ,PRIMARY KEY CLUSTERED ([degreeID] ASC)
);
CREATE TABLE [Religion] (
    [religionID] TINYINT IDENTITY(1,1) NOT NULL
    ,[name] NVARCHAR(50) NOT NULL
    ,PRIMARY KEY CLUSTERED ([religionID] ASC)
);
CREATE TABLE [EthnicGroups] (
    [ethnicID] TINYINT IDENTITY(1,1) NOT NULL
    ,[name] NVARCHAR(50) NOT NULL
    ,PRIMARY KEY CLUSTERED ([EthnicID] ASC)
);
CREATE TABLE [Teacher] (
    [teacherId] CHAR(6) NOT NULL
	,[password] VARCHAR(50) NOT NULL
/*
    DEPARTMENT		   : 2 CHAR
    TEACHER ID		   : 4 CHAR
*/
    ,[firstName] NVARCHAR(7) NOT NULL
    ,[middleName] NVARCHAR(30)
    ,[lastName] NVARCHAR(7) NOT NULL
    ,[contactNumber] CHAR(10) NOT NULL
    ,[email] VARCHAR(100) NOT NULL
    ,[dateOfBirth] DATE
    -- ADDRESS
    ,[provincesCode] NVARCHAR(20) NOT NULL
    ,[districtsCode] NVARCHAR(20) NOT NULL
    ,[wardsCode] NVARCHAR(20) NOT NULL
	,[homeAddress] NVARCHAR(100) NOT NULL
    ,[degreeID] TINYINT NOT NULL
    ,[ethnicID] TINYINT NOT NULL
    ,[religionID] TINYINT NOT NULL
    ,[departmentId] TINYINT NOT NULL
    ,[yearOfEmployment] SMALLINT NOT NULL
    ,[coefficientSalary] FLOAT NOT NULL
    ,[imagePath] TEXT
	,CONSTRAINT chk_password CHECK (LEN([password]) >= 8)
    ,FOREIGN KEY ([provincesCode]) REFERENCES [provinces]([code])
    ,FOREIGN KEY ([districtsCode]) REFERENCES [districts]([code])
    ,FOREIGN KEY ([wardsCode]) REFERENCES [wards]([code])
    ,FOREIGN KEY ([departmentId]) REFERENCES [Department]([departmentId])
    ,FOREIGN KEY ([degreeID]) REFERENCES [Degree]([degreeID])
    ,FOREIGN KEY ([ethnicID]) REFERENCES [EthnicGroups]([ethnicID])
    ,FOREIGN KEY ([religionID]) REFERENCES [Religion]([religionID])
    ,PRIMARY KEY CLUSTERED ([teacherId] ASC)
);
CREATE TABLE [RoomType] (
    [TypeId] TINYINT IDENTITY(1,1) NOT NULL
    , [Description] NVARCHAR(50) 
    ,PRIMARY KEY ([TypeId])
)
CREATE TABLE [ClassRoom] (
    [RoomID] CHAR(4) NOT NULL
    /*
        KHU  : 1 CHAR - ABCDE
        TẦNG : 1 CHAR
        STT Phòng : 2 CHAR
    */
    ,[TypeId] TINYINT NOT NULL
    ,FOREIGN KEY ([TypeId]) REFERENCES [RoomType]([TypeId])
    ,PRIMARY KEY CLUSTERED([RoomID] ASC)
)
CREATE TABLE [Class] (
	[classId] CHAR(10) NOT NULL
/*
	FOUNDED YEAR : 2 CHAR
	GRADE LEVEL  : 2 CHAR
	SUB LEVEL    : 2 CHAR
	CLASS ID     : 4 CHAR
*/   
	,[gradeLevel] CHAR(2) NOT NULL
	,[subLevel] CHAR(2) NOT NULL
	,[foundedYear] CHAR(5) /*14-15 20-21*/
    ,[RoomID] CHAR(4) NOT NULL
	,[homeroomTeacherId] CHAR(6) NOT NULL
    ,FOREIGN KEY([RoomID]) REFERENCES [ClassRoom]([RoomID])
	,FOREIGN KEY ([homeroomTeacherId]) REFERENCES [Teacher]([teacherId])
    ,PRIMARY KEY CLUSTERED ([classId] ASC)  
);
CREATE TABLE [Student] (
    [studentId] CHAR(6) NOT NULL
	,[password] VARCHAR(50) NOT NULL
    -- YEAR OF ADMISSION : 2 CHAR
    -- STUDENT ID	     : 4 CHAR
	,[accountID] CHAR(10) NOT NULL
    ,[firstName] NVARCHAR(7) NOT NULL
    ,[middleName] NVARCHAR(30)
    ,[lastName] NVARCHAR(7) NOT NULL
    ,[contactNumber] CHAR(11) NOT NULL
    ,[email] VARCHAR(100) NOT NULL
    ,[dateOfBirth] DATE
    ,[provincesCode] NVARCHAR(20) NOT NULL
    ,[districtsCode] NVARCHAR(20) NOT NULL
    ,[wardsCode] NVARCHAR(20) NOT NULL
    ,[ethnicID] TINYINT
    ,[religionID] TINYINT
	,[imagePath] TEXT
    ,[trainingScore] INT CONSTRAINT DF_training_score DEFAULT 100 NOT NULL
    ,[isOrphan] BIT DEFAULT 0 NOT NULL
    ,[isPoorHousehold] BIT DEFAULT 0 NOT NULL
    ,[isWoundedSoldierChild] BIT DEFAULT 0 NOT NULL
    ,FOREIGN KEY ([provincesCode]) REFERENCES [provinces]([code])
    ,FOREIGN KEY ([districtsCode]) REFERENCES [districts]([code])
    ,FOREIGN KEY ([wardsCode]) REFERENCES [wards]([code])
    ,FOREIGN KEY ([ethnicID]) REFERENCES [EthnicGroups]([ethnicID])
    ,FOREIGN KEY ([religionID]) REFERENCES [Religion]([religionID])
    ,PRIMARY KEY CLUSTERED ([studentId] ASC)
	,CONSTRAINT chk_student_password CHECK (LEN([password]) >= 8)
    ,CONSTRAINT chk_student_trainingScore CHECK([trainingScore] >= 0 AND [trainingScore] <= 100)
);
CREATE TABLE [Conduct] /*Hạnh kiểm*/ (
    [conductID] SMALLINT IDENTITY(1,1) NOT NULL
/*
	TỐT, KHÁ, TRUNG BÌNH, YẾU
*/
    ,[Description] NVARCHAR(10) NOT NULL
    ,PRIMARY KEY CLUSTERED  ([conductID] ASC)
);
CREATE TABLE [ClassDetail] (
    [classId] CHAR(10) NOT NULL
    ,[studentID] CHAR(10) NOT NULL
    ,[studentAveragePoint] NUMERIC(4,2) NOT NULL
    ,[conductID] SMALLINT NOT NULL
	,CONSTRAINT chk_classdetail_averagepoint CHECK([studentAveragePoint] >=0 AND [studentAveragePoint] <= 10)
	,FOREIGN KEY([classID]) REFERENCES [Class]([classID])
	,FOREIGN KEY([conductID]) REFERENCES [Conduct]([conductID])
	,PRIMARY KEY ([classID], [studentID])
);
CREATE TABLE [Parent] (
    [parentId] CHAR(7) NOT NULL
    --FIRST CHAR : FATHER/MOTHER/PROTECTURE...
    --LAST 6 CHAR : SAME AS STUDENT ID
    ,[firstName] NVARCHAR(7) NOT NULL
    ,[middleName] NVARCHAR(30)
    ,[lastName] NVARCHAR(7) NOT NULL
    ,[contactNumber] CHAR(11) NOT NULL
    ,[email] VARCHAR(100) NOT NULL
    ,PRIMARY KEY CLUSTERED  ([parentId] ASC)
);
CREATE TABLE [Relationship] (
    [relationshipId] TINYINT IDENTITY(1,1) NOT NULL
    ,[relationshipDescription] TEXT NOT NULL
    ,PRIMARY KEY CLUSTERED ([relationshipId] ASC)
);
CREATE TABLE [ParentStudent] (
    [studentId] CHAR(6) NOT NULL
    ,[parentId] CHAR(7) NOT NULL
    ,[relationshipId] TINYINT NOT NULL
    ,FOREIGN KEY ([parentId]) REFERENCES [Parent]([parentId])
    ,FOREIGN KEY ([studentId]) REFERENCES [Student]([studentId])
    ,FOREIGN KEY ([relationshipId]) REFERENCES [Relationship]([relationshipId])
);
CREATE TABLE [Subject] (
    [subjectId] CHAR(6) NOT NULL
/*
    DEPARTMENT ID : 2 CHAR
    GRADE LEVEL : 2 CHAR
    SUBJECT ID : 2 CHAR
*/
    ,[subjectName] NVARCHAR(50) NOT NULL
    ,[gradeLevel] CHAR(2) NOT NULL
    ,[lessonPerWeek] INT NOT NULL
	,[subjectCoefficients] TINYINT NOT NULL /*Hệ số môn học*/
    ,[departmentId] TINYINT NOT NULL
    ,FOREIGN KEY([departmentId]) REFERENCES [Department]([departmentID])
    ,PRIMARY KEY CLUSTERED ([subjectId] ASC)
);
CREATE TABLE [Lesson] (
    [lessonId] SMALLINT NOT NULL
	/*
		TIẾT 1 : 7H   - 7H45
		TIẾT 2 : 7H50 - 8H35
	*/
    ,[description] VARCHAR(20)
	,PRIMARY KEY CLUSTERED ([lessonId] ASC)
);
CREATE TABLE [Schedule] (
    [classId] CHAR(10) NOT NULL
    ,[subjectId] CHAR(6) NOT NULL
    ,[weekDay] VARCHAR(10) NOT NULL
    ,[startTimeId] SMALLINT NOT NULL
    ,[endTimeId] SMALLINT NOT NULL
    ,[teacherId] CHAR(6) NOT NULL
	,[semester] TINYINT NOT NULL /*1 OR 2*/
	,CONSTRAINT chk_schedule_semester CHECK ([semester] = 1 OR [semester] = 2)
    ,FOREIGN KEY([classId]) REFERENCES [Class]([classId])
    ,FOREIGN KEY([subjectId]) REFERENCES [Subject]([subjectId])
	,FOREIGN KEY([startTimeId]) REFERENCES [Lesson]([lessonId])
	,FOREIGN KEY([endTimeId]) REFERENCES [Lesson]([lessonId])
    ,FOREIGN KEY([teacherId]) REFERENCES [Teacher]([teacherId])
    ,PRIMARY KEY ([classId], [subjectId], [weekDay], [startTimeId])
);
CREATE TABLE [ScoreType] (
    [scoreTypeId] TINYINT IDENTITY(1,1) NOT NULL
/*
	1 : KIỂM TRA THƯỜNG XUYÊN
	2 : GIỮA KỲ
    3 : CUỐI KỲ
*/
    ,[description] NVARCHAR(25) NOT NULL
    ,PRIMARY KEY CLUSTERED ([scoreTypeId] ASC)
);
CREATE TABLE [StudentPoint] (
    [studentId] CHAR(6) NOT NULL
	,[classId] CHAR(10) NOT NULL
    ,[subjectId] CHAR(6) NOT NULL 
    ,[scoreTypeId] TINYINT NOT NULL
    ,[value] DECIMAL(4,2)
    ,[datetime] SMALLDATETIME NOT NULL
	,[semester] TINYINT NOT NULL /*1 OR 2*/
	,CONSTRAINT chk_studentpoint_semester CHECK ([semester] = 1 OR [semester] = 2)
    ,FOREIGN KEY([studentId]) REFERENCES [Student]([studentId])
	,FOREIGN KEY ([classId]) REFERENCES [Class]([classId])
    ,FOREIGN KEY([subjectId]) REFERENCES [Subject]([subjectId])
    ,FOREIGN KEY([scoreTypeId]) REFERENCES [ScoreType]([scoreTypeId])
    ,PRIMARY KEY ([studentId], [classId], [subjectId], [datetime])
    ,CONSTRAINT chk_studentpoint_Value CHECK([Value] >= 0 AND [Value] <= 10),
);

--ROLLBACK
