-- project 2.5 main sql script

/* 

Step1: CREATE THE DATABASE

Instructions: run only lines 10 and 11 using the master databse 

*/

-- CREATE DATABASE [PrestigeCars_9:15_Group1];
-- GO

/*

Step2: Create the Schemas & run all remaining code & procedures  

Instructions: Run all remaining code under the [PrestigeCars_9:15_Group1] database

*/


--------------------- CREATE SCHEMAS -------------------------

DROP SCHEMA IF EXISTS [Sales];
GO
CREATE SCHEMA [Sales];
GO

DROP SCHEMA IF EXISTS [HumanResources];
GO
CREATE SCHEMA [HumanResources];
GO

DROP SCHEMA IF EXISTS [Production]; 
GO
CREATE SCHEMA [Production];
GO

DROP SCHEMA IF EXISTS [DbSecurity]; 
GO
CREATE SCHEMA [DbSecurity];
GO

DROP SCHEMA IF EXISTS [Process]; 
GO
CREATE SCHEMA [Process];
GO

DROP SCHEMA IF EXISTS [PkSequence]; 
GO
CREATE SCHEMA [PkSequence];
GO

DROP SCHEMA IF EXISTS [Project2.5];
GO
CREATE SCHEMA [Project2.5];
GO

------------------------- CREATE SEQUENCES ----------------------------


-- for automatically assigning keys in [DbSecurity].[UserAuthorization]
CREATE SEQUENCE [PkSequence].[UserAuthorizationSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO

-- for replacing identity key in [Process].[WorkflowSteps]
CREATE SEQUENCE [PkSequence].[WorkFlowStepsSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO

-- for automatically assigning keys in [HumanResources].[Staff]
-- We need to ensure that the 13 staff members from the PrestigeCars database maintain the same StaffIDs so that the ManagerIDs would be acurate
-- Therefore we restart the sequence to start at 14 for future staff additions, since we already have the first 13 Staff members from the PrestigeCars database
CREATE SEQUENCE [PkSequence].[StaffSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO
ALTER SEQUENCE [PkSequence].[StaffSequenceObject]
    RESTART WITH 14;

-- for automatically assigning keys in [HumanResources].[Departments]
CREATE SEQUENCE [PkSequence].[DepartmentsSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO

-- add more sequences as needed


------------------------- CREATE TABLES ---------------------------


-- UserAuthorization Table -- 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [DbSecurity].[UserAuthorization]
GO
CREATE TABLE [DbSecurity].[UserAuthorization]
(
    [UserAuthorizationKey] [int] NOT NULL,
    [ClassTime] [nchar](5) NOT NULL,
    [IndividualProject] [nvarchar](60) NULL,
    [GroupMemberLastName] [nvarchar](35) NOT NULL,
    [GroupMemberFirstName] [nvarchar](25) NOT NULL,
    [GroupName] [nvarchar](20) NOT NULL,
    [DateAdded] [datetime2](7) NULL,
    PRIMARY KEY CLUSTERED 
(
	[UserAuthorizationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/*

Table: Process.[WorkflowSteps]

Description:
This table is used for auditing and tracking the execution of various workflow steps within the system. 
It records key information about each workflow step, including a description, the number of rows affected, 
the start and end times of the step, and the user who executed the step.

Columns:
[WorkFlowStepKey] - The primary key for the table, uniquely identifying each workflow step.
[WorkFlowStepDescription] - A descriptive name or summary of the workflow step.
[WorkFlowStepTableRowCount] - The number of table rows that were affected or processed during the workflow step.
[StartingDateTime] - The date and time when the workflow step began.
[EndingDateTime] - The date and time when the workflow step ended.
[Class Time] - An optional field that could be used to record the time of a class or session during which the workflow step was executed.
[UserAuthorizationKey] - A foreign key linking to the UserAuthorization table to identify the user responsible for the workflow step.

Usage:
This table is populated by the 'usp_TrackWorkFlow' stored procedure, which is called at the beginning and end 
of each workflow step to log its execution. It can be used for monitoring system activity, analyzing the performance 
and duration of workflow steps, and ensuring that data processing is carried out by authorized users.

*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [Process].[WorkflowSteps]
GO
CREATE TABLE [Process].[WorkflowSteps]
(
    [WorkFlowStepKey] [int] NOT NULL,
    [WorkFlowStepDescription] [nvarchar](100) NOT NULL,
    [WorkFlowStepTableRowCount] [int] NULL,
    [StartingDateTime] [datetime2](7) NULL,
    [EndingDateTime] [datetime2](7) NULL,
    [QueryTime (ms)] [bigint] NULL, 
    [Class Time] [char](5) NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[WorkFlowStepKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [HumanResources].[Staff]
GO
CREATE TABLE [HumanResources].[Staff]
(
    [StaffID] [int] NOT NULL,
    [StaffName] [nvarchar](50) NOT NULL,
    [ManagerID] [int] NULL,
    [DepartmentKey] [int] NOT NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[StaffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS [HumanResources].[Departments]
GO
CREATE TABLE [HumanResources].[Departments]
(
    [DepartmentKey] [int] NOT NULL,
    [Department] [nvarchar](50) NOT NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[DepartmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- add more tables as needed following this format:

-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE TABLE [SCHEMA_NAME].[TABLE_NAME]
-- (
--     ...add columns here 
--     PRIMARY KEY CLUSTERED 
-- (
-- 	[UserAuthorizationKey] ASC
-- )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
-- ) ON [PRIMARY]
-- GO





--------------------- Alter Tables To Update Defaults/Constraints -------------------


-- adding default values in the following format:
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT (NEXT VALUE FOR PkSequence.[UserAuthorizationSequenceObject]) FOR [UserAuthorizationKey]
GO
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT ('9:15') FOR [ClassTime]
GO
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT ('PROJECT 2.5  NORMALIZE PRESTIGE CARS SCHEMA') FOR [IndividualProject]
GO
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT ('GROUP 1') FOR [GroupName]
GO
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (NEXT VALUE FOR PkSequence.[WorkFlowStepsSequenceObject]) FOR [WorkFlowStepKey]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ((0)) FOR [WorkFlowStepTableRowCount]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [StartingDateTime]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [EndingDateTime]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('9:15') FOR [Class Time]
GO
ALTER TABLE [HumanResources].[Staff] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[StaffSequenceObject]) FOR [StaffID]
GO
ALTER TABLE [HumanResources].[Departments] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[DepartmentsSequenceObject]) FOR [DepartmentKey]
GO






-- add check constraints in the following format: 

ALTER TABLE [Process].[WorkflowSteps]  WITH CHECK ADD  CONSTRAINT [FK_WorkFlowSteps_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Process].[WorkflowSteps] CHECK CONSTRAINT [FK_WorkFlowSteps_UserAuthorization]
GO
ALTER TABLE [HumanResources].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Departments] FOREIGN KEY([DepartmentKey])
REFERENCES [HumanResources].[Departments] ([DepartmentKey])
GO
ALTER TABLE [HumanResources].[Staff] CHECK CONSTRAINT [FK_Staff_Departments]
GO

ALTER TABLE [HumanResources].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [HumanResources].[Staff] CHECK CONSTRAINT [FK_Staff_UserAuthorization]
GO

ALTER TABLE [HumanResources].[Departments]  WITH CHECK ADD  CONSTRAINT [FK_Departments_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [HumanResources].[Departments] CHECK CONSTRAINT [FK_Departments_UserAuthorization]
GO

-- add more here.. 




------------------------- CREATE VIEWS ---------------------------
/*

These views preserve some tables from the original Prestige Cars database. 
The original tables had various issues (ex: some were determined to be 
redundant) and so were broken into new tables in order to adhere to 
normalization techniques. 
Some original tables were preserved in Views since it's clear the business
would want to query that information quickly for reporting purposes.

*/


-- add views here!






------------------------- CREATE Table Valued Functions ---------------------------

-- =============================================
-- Author:		Aryeh Richman
-- Create date: 11/27/23
-- Description:	Input: StaffID
--              Output: Table of that staff member's managerial hierarchy
--                      (the staff member, boss, boss's boss, etc.)
-- =============================================
DROP FUNCTION IF EXISTS [HumanResources].[GetStaffHierarchy]
GO
CREATE FUNCTION [HumanResources].[GetStaffHierarchy]
    (@id AS INT) RETURNS TABLE
AS
RETURN
    WITH HierarchyCTE AS (
        SELECT S.StaffID, S.StaffName, S.ManagerID
        FROM [HumanResources].[Staff] AS S
        WHERE S.StaffID = @id
    
        UNION ALL
    
        SELECT E.StaffID, E.StaffName, E.ManagerID
        FROM HierarchyCTE AS R 
            INNER JOIN [HumanResources].[Staff] AS E
                ON R.ManagerID = E.StaffID
    )
    SELECT * FROM HierarchyCTE
GO


-------------- Create Stored Procedures --------------

/*
Stored Procedure: [Process].[usp_ShowWorkflowSteps]

Description:
This stored procedure is designed to retrieve and display all records from the Process.[WorkFlowSteps] table. It is intended to provide a comprehensive view of all workflow steps that have been logged in the system, offering insights into the various processes and their execution details.

Operations:
- The procedure sets NOCOUNT ON to prevent the return of the count of affected rows, thereby enhancing performance and reducing network traffic.
- A simple SELECT statement retrieves all records from the Process.[WorkFlowSteps] table, providing details such as the description of the workflow step, the start and end times, the number of rows affected, and the user authorization key associated with each step.

Usage:
This procedure is particularly useful for administrators and analysts who need to audit or review the history of workflow steps executed in the system. It allows for an easy overview of the entire workflow history, which can be crucial for process optimization, troubleshooting, and compliance purposes.

Example:
EXEC Process.[usp_ShowWorkflowSteps];

This example executes the stored procedure to retrieve and display all workflow steps from the Process.[WorkFlowSteps] table.

Note: The effectiveness of this procedure depends on the accurate and consistent logging of workflow steps in the Process.[WorkFlowSteps] table.

-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/13/23
-- Description:	Show table of all workflow steps
-- =============================================
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Process].[usp_ShowWorkflowSteps]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    SELECT *
    FROM [Process].[WorkFlowSteps];
END
GO

/*
Stored Procedure: Process.[usp_TrackWorkFlow]

Description:
This stored procedure is designed to track and log each step of various workflows within the system. It inserts records into the [WorkflowSteps] table, capturing key details about each workflow step, such as its description, the number of table rows affected, and the start and end times. This procedure is instrumental in maintaining an audit trail and enhancing transparency in automated processes.

Parameters:
- @WorkflowDescription: NVARCHAR(100) describing the workflow step.
- @WorkFlowStepTableRowCount: INT indicating the number of rows affected or processed during the workflow step.
- @StartingDateTime: DATETIME2 marking when the workflow step began.
- @EndingDateTime: DATETIME2 marking when the workflow step ended.
- @UserAuthorizationKey: INT identifying the user who initiated or is responsible for the workflow step, crucial for auditing purposes.

Usage:
This procedure should be invoked at the start and end of each significant workflow step within automated processes or ETL jobs. It ensures that all workflow activities are logged, which aids in monitoring, troubleshooting, and analyzing process efficiency and user activity.

Example:
EXEC Process.[usp_TrackWorkFlow]
    @WorkflowDescription = 'Data Load Step 1',
    @WorkFlowStepTableRowCount = 100,
    @StartingDateTime = '2023-11-13T08:00:00',
    @EndingDateTime = '2023-11-13T08:30:00',
    @UserAuthorizationKey = 5;

This example logs a workflow step described as 'Data Load Step 1', indicating that 100 rows were affected, starting at 8:00 AM and ending at 8:30 AM on November 13, 2023, performed by the user with authorization key 5.

Note: Proper usage of this stored procedure is essential for accurate and reliable workflow tracking. It should be consistently implemented across all relevant workflows for effective auditability and process analysis.

-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/13/23
-- Description:	Keep track of all workflow steps
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Process].[usp_TrackWorkFlow]
    -- Add the parameters for the stored procedure here
    @WorkflowDescription NVARCHAR(100),
    @WorkFlowStepTableRowCount INT,
    @StartingDateTime DATETIME2,
    @EndingDateTime DATETIME2,
    @QueryTime BIGINT,
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    INSERT INTO [Process].[WorkflowSteps]
        (
        WorkFlowStepDescription,
        WorkFlowStepTableRowCount,
        StartingDateTime,
        EndingDateTime,
        [QueryTime (ms)],
        [Class Time],
        UserAuthorizationKey
        )
    VALUES
        (@WorkflowDescription, @WorkFlowStepTableRowCount, @StartingDateTime, @EndingDateTime, @QueryTime, '9:15',
            @UserAuthorizationKey);

END;
GO




/*

Stored Procedure: Process.[Load_UserAuthorization]

Description: Prepopulating the UserAuthorization Table with the Group Names 

-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/126/23
-- Description:	Load the names & default values into the user authorization table
-- =============================================
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project2.5].[Load_UserAuthorization]
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [DbSecurity].[UserAuthorization]
    ([GroupMemberLastName],[GroupMemberFirstName])
    VALUES

            ('Georgievska','Aleksandra'),
            ('Yakubova','Sigalita'),
            ('Kong','Nicholas'),
            ('Wray','Edwin'),
            ('Ahmed','Ahnaf'),
            ('Richman','Aryeh');

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 6;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Users',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO





/*
Stored Procedure: [Project2.5].[AddForeignKeysToPrestigeCars]

Description:
This procedure is responsible for establishing foreign key relationships across various tables in the star schema database. It adds constraints to link fact and dimension tables to ensure referential integrity. The procedure also associates dimension tables with the UserAuthorization table, thereby establishing a traceable link between data records and the users responsible for their creation or updates.

Parameters:
- @UserAuthorizationKey: INT representing the user authorizing this operation, used for auditing purposes.

Operations:
1. Adds foreign key constraints to the [CH01-01-Fact].[Data] table, linking it to various dimension tables like DimCustomer, DimGender, DimMaritalStatus, etc.
2. Adds foreign key constraints to dimension tables, linking them to the [DbSecurity].[UserAuthorization] table.
3. Tracks the process using Process.[usp_TrackWorkFlow] to maintain an audit trail of the operation.

Usage:
This procedure should be executed when setting up the database schema or when modifications to the schema are required. It ensures data integrity across the star schema by enforcing appropriate foreign key relationships.

Example:
EXEC Project2.[AddForeignKeysToPrestigeCars] @UserAuthorizationKey = 5;

This example runs the procedure to add foreign keys across tables, authorized by the user with key 5.

Note: Proper execution of this procedure is critical to maintain data integrity and referential relationships in the star schema database. It should be executed with caution, ensuring that no data inconsistencies exist that could be affected by the new constraints.

-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/13/23
-- Description:	Add the foreign keys to the start Schema database
-- =============================================
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project2.5].[AddForeignKeysToPrestigeCars]
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    ALTER TABLE [Process].[WorkflowSteps]
    ADD CONSTRAINT FK_WorkFlowSteps_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [HumanResources].[Staff]
    ADD CONSTRAINT FK_Staff_Departments 
        FOREIGN KEY([DepartmentKey])
        REFERENCES [HumanResources].[Departments] ([DepartmentKey]);
    ALTER TABLE [HumanResources].[Staff]
    ADD CONSTRAINT FK_Staff_UserAuthorization
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);
    ALTER TABLE [HumanResources].[Departments]
    ADD CONSTRAINT FK_Departments_UserAuthorization
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);




    -- ADD FOREIGN KEYS USEING THIS FORMAT:
    -- ALTER TABLE [SCHEMA_NAME].[TABLE]
    -- ADD CONSTRAINT FK_Data_DimCustomer
    --     FOREIGN KEY (CustomerKey)
    --     REFERENCES [CH01-01-Dimension].DimCustomer (CustomerKey);
    -- ALTER TABLE [CH01-01-Fact].[Data]
    -- ADD CONSTRAINT FK_Data_DimGender
    --     FOREIGN KEY (Gender)
    --     REFERENCES [CH01-01-Dimension].DimGender (Gender);
    -- ...




    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Foreign Keys',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO



/*
Stored Procedure: [Project2.5].[DropForeignKeysFromPrestigeCars]

Description:
This procedure is designed to remove foreign key constraints from various tables in the star schema database. It primarily focuses on dropping constraints that link fact and dimension tables as well as the constraints linking dimension tables to the UserAuthorization table. This is typically performed in preparation for data loading operations that require constraint-free bulk data manipulations.

Parameters:
- @UserAuthorizationKey: INT indicating the user authorizing the operation, used for auditing.

Operations:
1. Drops foreign key constraints from the [CH01-01-Fact].[Data] table and various dimension tables, ensuring the removal of referential integrity constraints.
2. Logs the procedure execution using Process.[usp_TrackWorkFlow] for audit trails, tracking the start and end times, and user responsibility.

Usage:
Execute this procedure before performing bulk data load operations or schema alterations that might be hindered by existing foreign key constraints. It ensures that data modifications can be performed without constraint violations.

Example:
EXEC [Project2.5].[DropForeignKeysFromPrestigeCars] @UserAuthorizationKey = 5;

This example runs the procedure to drop foreign keys across the star schema tables, authorized by the user with key 5.

Note: Care should be taken when executing this procedure as dropping foreign keys can temporarily weaken data integrity. Ensure to re-establish the foreign keys after the required operations are completed.

-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/13/23
-- Description:	Drop the foreign keys from the start Schema database
-- =============================================

*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project2.5].[DropForeignKeysFromPrestigeCars]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    -- ADD DROP COMMANDS USING THE FOLLOWING FORMAT:
    -- ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT FK_Data_DimCustomer;
    -- ...


    ALTER TABLE [Process].[WorkflowSteps] DROP CONSTRAINT FK_WorkFlowSteps_UserAuthorization;
    ALTER TABLE [HumanResources].[Staff] DROP CONSTRAINT FK_Staff_Departments;
    ALTER TABLE [HumanResources].[Staff] DROP CONSTRAINT FK_Staff_UserAuthorization;
    ALTER TABLE [HumanResources].[Departments] DROP CONSTRAINT FK_Departments_UserAuthorization;
    
    
    -- .. add more here!

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Drop Foreign Keys',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO




/*
Stored Procedure: Project2.[TruncateStarSchemaData]

Description:
This procedure is designed to truncate tables in the star schema of the data warehouse. It removes all records from specified dimension and fact tables and restarts the associated sequences. This action is essential for data refresh scenarios where existing data needs to be cleared before loading new data.

Parameters:
- @UserAuthorizationKey: INT representing the user authorizing the truncation operation, used for auditing purposes.

Operations:
1. Truncates each specified dimension and fact table within the [CH01-01-Dimension] and [CH01-01-Fact] schemas.
2. Resets the sequences associated with these tables to their initial values.
3. Logs the execution of the truncation process using Process.[usp_TrackWorkFlow], capturing details like the operation's start and end times, and user responsibility.

Usage:
Execute this procedure before performing bulk data load operations or when resetting the data warehouse for a fresh data import. It is particularly useful for maintaining a clean state in development or test environments or when reinitializing the data warehouse.

Example:
EXEC Project2.[TruncateStarSchemaData] @UserAuthorizationKey = 30;

This example executes the procedure to truncate the star schema tables, authorized by the user with key 30.

Note: This procedure should be used with extreme caution as it will irreversibly remove all data from the specified tables. Ensure that backups are taken or data is otherwise preserved if needed before executing this procedure.

-- =============================================
-- Author:		Nicholas Kong
-- Create date: 11/13/2023
-- Description:	Truncate the star schema 
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project2.5].[TruncateStarSchemaData]
    @UserAuthorizationKey int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    ALTER SEQUENCE [PkSequence].[UserAuthorizationSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [DbSecurity].[UserAuthorization]
    ALTER SEQUENCE [PkSequence].[WorkFlowStepsSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [Process].[WorkFlowSteps]
    ALTER SEQUENCE [PkSequence].[StaffSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [HumanResources].[Staff];
    ALTER SEQUENCE [PkSequence].[DepartmentsSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [HumanResources].[Departments];


    -- ADD TRUNCATE COMMANDS IN THE FOLLOWING FORAMT:
    -- ALTER SEQUENCE PkSequence.DimCustomerSequenceObject RESTART WITH 1;
    -- TRUNCATE TABLE [CH01-01-Dimension].DimGender;
    -- ...




    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Truncate Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO



/*
Stored Procedure: Project2.[ShowTableStatusRowCount]

Description:
This procedure is designed to report the row count of various tables in the database, providing a snapshot of the current data volume across different tables. It includes tables from the [CH01-01-Dimension], [CH01-01-Fact], [DbSecurity], and [Process] schemas. The procedure also logs this operation, including user authorization keys and timestamps, to maintain an audit trail.

Parameters:
- @TableStatus: VARCHAR(64) representing the label or status description for the row count report.
- @UserAuthorizationKey: INT indicating the user responsible for the operation, used for auditing purposes.

Operations:
1. Queries each specified table to calculate its row count.
2. Outputs the table name and its corresponding row count, along with the provided @TableStatus label.
3. Logs the execution using Process.[usp_TrackWorkFlow], capturing details such as the operation's start and end times and the user's authorization key.

Usage:
Run this procedure to obtain a row count report of various tables, which can be useful for data auditing, capacity planning, or simply understanding the current data volume in different parts of the database.

Example:
EXEC Project2.[ShowTableStatusRowCount] @TableStatus = 'Post-Load Analysis', @UserAuthorizationKey = 65;

This example retrieves the row counts for various tables under the label 'Post-Load Analysis', authorized by the user with key 65.

Note: This procedure is a utility tool for data monitoring and should be used accordingly. Ensure the correct interpretation of the row count data, especially in the context of data load operations or data audits.

-- =============================================
-- Author:		Aryeh Richman
-- Create date: 11/13/23
-- Description:	Populate a table to show the status of the row counts
-- =============================================
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project2.5].[ShowTableStatusRowCount]
    @TableStatus VARCHAR(64),
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    DECLARE @WorkFlowStepTableRowCount INT = 0;

    SELECT TableStatus = @TableStatus,
            TableName = '[DbSecurity].[UserAuthorization]',
            [Row Count] = COUNT(*)
        FROM [DbSecurity].[UserAuthorization]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Process].[WorkflowSteps]',
            [Row Count] = COUNT(*)
        FROM [Process].[WorkflowSteps]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[HumanResources].[Departments]',
            [Row Count] = COUNT(*)
        FROM [HumanResources].[Departments]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[HumanResources].[Staff]',
            [Row Count] = COUNT(*)
        FROM [HumanResources].[Staff];


    -- ADD NEW TABLE STATUS ENTRIES IN THE FOLLOWING FORMAT:
    -- UNION ALL
        -- SELECT TableStatus = @TableStatus,
            -- TableName = ''
            -- [Row Count] = COUNT(*)
        -- FROM [].[]


    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: Project2.5[ShowStatusRowCount] loads data into ShowTableStatusRowCount',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO


-- Decided that there should be no NULL values for department i.e. every staff member should be part of a department
-- So NULL values from the PrestigeCars database, i.e. the boss, is now in the Executive department using the COALESCE function
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aryeh Richman
-- Create date: 11/27/2023
-- Description:	Load data into the Departments table
-- =============================================
CREATE OR ALTER PROCEDURE [Project2.5].[Load_Departments]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [HumanResources].[Departments]
        (Department, UserAuthorizationKey, DateAdded)
    SELECT DISTINCT COALESCE(Department, 'Executive') AS Department, @UserAuthorizationKey, @DateAdded
    FROM [PrestigeCars].[Reference].[Staff]

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [HumanResources].Departments);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[Load_Departments] loads data into [HumanResources].Departments',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO



-- Had to use an INNER JOIN to get the correct DepartmentID based on the staff member's department from the PrestigeCars Reference.Staff Table
-- Included the StaffID from the PrestigeCars database instead of the sequence object so that the ManagerIDs remain correct
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Aryeh Richman
-- Create date: 11/27/2023
-- Description:	Load data into the Staff table
-- =============================================
CREATE OR ALTER PROCEDURE [Project2.5].[Load_Staff]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [HumanResources].[Staff]
        (StaffID, StaffName, ManagerID, DepartmentKey, UserAuthorizationKey, DateAdded)
    SELECT DISTINCT StaffID, StaffName, ManagerID,
                    D.DepartmentKey,
                    @UserAuthorizationKey, @DateAdded
    FROM [PrestigeCars].[Reference].[Staff] AS S
        JOIN [HumanResources].[Departments] AS D
            ON COALESCE(S.Department, 'Executive') = D.Department
    ORDER BY S.StaffID


    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [HumanResources].Departments);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[Load_Departments] loads data into [HumanResources].Staff',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO




-- add new stored procedures in this space:

















-- don't add new stored procuedures after this space:

/*
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/14/23
-- Description:	Clears all data from the Prestige Cars db
-- =============================================
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project2.5].[TruncatePrestigeCarsDatabase]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    -- Drop All of the foreign keys prior to truncating tables in the Prestige Cars db
    EXEC [Project2.5].[DropForeignKeysFromPrestigeCars] @UserAuthorizationKey = 1;

    --	Check row count before truncation
    EXEC [Project2.5].[ShowTableStatusRowCount] @UserAuthorizationKey = 6,  
		@TableStatus = N'''Pre-truncate of tables'''
    
    --	Always truncate the Star Schema Data
    EXEC  [Project2.5].[TruncateStarSchemaData] @UserAuthorizationKey = 3;

    --	Check row count AFTER truncation
    EXEC [Project2.5].[ShowTableStatusRowCount] @UserAuthorizationKey = 6,  
		@TableStatus = N'''Post-truncate of tables'''
END;
GO


/*
This T-SQL script is for creating a stored procedure named LoadStarSchemaData within a SQL Server database, likely for the 
purpose of managing and updating a star schema data warehouse structure. Here's a breakdown of what this script does:

 1. Setting Options:
    
    * SET ANSI_NULLS ON: Ensures that the session treats NULL values according to the ANSI SQL standard.
    * SET QUOTED_IDENTIFIER ON: Allows the use of double quotes to delimit identifiers.

 2. Creating the Stored Procedure:
    
    * CREATE PROCEDURE [Project2].[LoadStarSchemaData]: This line starts the creation of a stored procedure named LoadStarSchemaData 
    under the schema Project2. It takes an @UserAuthorizationKey as an integer parameter.

 3. Procedure Body:
    
    * SET NOCOUNT ON;: This line stops the message that shows the number of rows affected by a T-SQL statement from being returned.
    * DECLARE @StartingDateTime DATETIME2: Declares a variable to store the starting time of the procedure execution.
    * Loading Data: The procedure then loads data into various dimension tables (like product categories, subcategories, product, etc.) 
    and fact tables using multiple EXEC statements. Each EXEC statement calls a specific procedure to load data into a particular table.
    * Recreating Foreign Keys: After loading the data, it recreates the foreign keys using [Project2].[AddForeignKeysToStarSchemaData].
    * Final Steps: It checks the row count again after loading the data, sets an @EndingDateTime variable, and then calls [Process].[usp_TrackWorkFlow] 
    to track the workflow, passing in various parameters including the start and end times.

 4. End of Procedure: The script ends with END; to signify the end of the stored procedure and GO to signal the end of a batch of 
 Transact-SQL statements to the SQL Server.

In summary, this stored procedure is designed to manage the updating of a star schema database by first dropping foreign keys, 
truncating existing data, loading new data into the dimensional and fact tables, recreating the foreign keys, and logging the 
workflow process. The use of @UserAuthorizationKey in various places suggests that the procedure includes some form of authorization 
or tracking mechanism based on the user executing the procedure.

-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/14/23
-- Description:	Procedure runs other stored procedures to populate the data
-- =============================================
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project2.5].[LoadPrestigeCarsDatabase]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    /*
            Note: User Authorization keys are hardcoded, each representing a different group user 
                    Aleksandra Georgievska → User Key 1
                    Sigalita Yakubova → User Key 2
                    Nicholas Kong → User Key 3
                    Edwin Wray → User Key 4
                    Ahnaf Ahmed → User Key 5
                    Aryeh Richman → User Key 6
    */

    -- ADD EXEC COMMANDS IN THE FOLLOWNG FORMAT:
    EXEC [Project2.5].[Load_UserAuthorization] @UserAuthorizationKey = 1
    EXEC [Project2.5].[Load_Departments] @UserAuthorizationKey = 6
    EXEC [Project2.5].[Load_Staff] @UserAuthorizationKey = 6


    --	Check row count before truncation
    EXEC [Project2.5].[ShowTableStatusRowCount] @UserAuthorizationKey = 6,  -- Change to the appropriate UserAuthorizationKey
		@TableStatus = N'''Row Count after loading the Prestige Cars db'''

    --	Recreate all of the foreign keys after loading the Prestige Cars schema
    EXEC [Project2.5].[AddForeignKeysToPrestigeCars] @UserAuthorizationKey = 1; -- Change to the appropriate UserAuthorizationKey

END;
GO


EXEC [Project2.5].[TruncatePrestigeCarsDatabase] @UserAuthorizationKey = 1;
EXEC [Project2.5].[LoadPrestigeCarsDatabase]  @UserAuthorizationKey = 1;
EXEC [Process].[usp_ShowWorkflowSteps]