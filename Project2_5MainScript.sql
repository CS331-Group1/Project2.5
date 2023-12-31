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

-- Schema for views
DROP SCHEMA IF EXISTS [G9_1];
GO
CREATE SCHEMA [G9_1];
GO

------------------------- CREATE SEQUENCES ----------------------------


-- for automatically assigning keys in [DbSecurity].[UserAuthorization]
-- Aleks
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

-- Aryeh
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

-- Edwin
-- for automatically assigning keys in [Sales].[Customers]
CREATE SEQUENCE [PkSequence].[CustomersSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO

-- for automatically assigning keys in [Sales].[Orders]
CREATE SEQUENCE [PkSequence].[OrdersSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO

-- for automatically assigning keys in [Sales].[OrderDetails]
CREATE SEQUENCE [PkSequence].[OrderDetailsSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO


-- Sigi
--Assigning keys in [Sales].[MakeMarketing]
CREATE SEQUENCE [PkSequence].[MarketingSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO

--Assigning keys in [Sales].[BudgetDelegations]
CREATE SEQUENCE [PkSequence].[DelegationSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO

--Nicholas
-- for automatically assigning keys in [Production].[Make]
CREATE SEQUENCE [PkSequence].[MakeSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO

-- for automatically assigning keys in [Production].[Model]
CREATE SEQUENCE [PkSequence].[ModelSequenceObject] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
GO

-- for automatically assigning keys in [Production].[Stock]
CREATE SEQUENCE [PkSequence].[StockSequenceObject] 
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


-- Aryeh
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

-- Edwin
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [Sales].[Customers]
GO
CREATE TABLE [Sales].[Customers]
(
    [CustomerID] [int] NOT NULL,
    [CustomerName] [nvarchar](150) NULL,
    [Address1] [nvarchar](50) NULL,
    [Address2] [nvarchar](50) NULL,
    [Town] [nvarchar](50) NULL,
    [Country] [nvarchar](50) NULL,
    [PostCode] [nvarchar](50) NULL,
    [SpendCapacity] [nvarchar](25) NULL,
    [IsReseller] [bit] NULL,
    [IsCreditRisk] [bit] NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [Sales].[Orders]
GO
CREATE TABLE [Sales].[Orders]
(
    [OrderID] [int] NOT NULL,
    [CustomerID] [int] NOT NULL,
    [OrderDate] [datetime] NULL,
    [InvoiceNumber] [char](8) NULL,
    [TotalSalePrice] [numeric](18,2) NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [Sales].[OrderDetails]
GO
CREATE TABLE [Sales].[OrderDetails]
(
    [OrderDetailsID] [int] NOT NULL,
    [OrderID] [int] NOT NULL,
    [CustomerID] [int] NOT NULL,
    [LineItemNumber] [tinyint] NULL,
    [StockID] [nvarchar](50) NULL,
    [SalesPrice] [numeric](18,2) NULL,
    [LineItemDiscount] [numeric](18,2) NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[OrderDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Sigi
DROP TABLE IF EXISTS [Sales].[MakeMarketing]
GO
CREATE TABLE [Sales].[MakeMarketing]
(
    [MarketingKey] [int] NOT NULL,
    [MakeName] [nvarchar](50) NOT NULL,
    [MarketingType] [nvarchar] (50) NOT NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[MarketingKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [Sales].[ColorBudget]
GO
CREATE TABLE [Sales].[ColorBudget]
(
    [BudgetKey] [int] NOT NULL,
    [BudgetValue] [money] NOT NULL,
    [BudgetYear] [int] NOT NULL,
    [Color] [nvarchar](20) NOT NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[BudgetKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [Sales].[SalesBudget]
GO
CREATE TABLE [Sales].[SalesBudget]
(
    [BudgetKey] [int] NOT NULL,
    [BudgetValue] [money] NOT NULL,
    [BudgetDate] [Date] NOT NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[BudgetKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [Sales].[CountryBudget]
GO
CREATE TABLE [Sales].[CountryBudget]
(
    [BudgetKey] [int] NOT NULL,
    [BudgetValue] [money] NOT NULL,
    [BudgetDate] [Date] NOT NULL,
    [Country] [nvarchar](50) NOT NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[BudgetKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [Sales].[BudgetDelegations]
GO
CREATE TABLE [Sales].[BudgetDelegations]
(
    [DelegationKey] [int] NOT NULL,
    [BudgetArea] [nvarchar](20) NOT NULL,
    [BudgetAmount] [money] NOT NULL,
    [BudgetDate] [Date] NOT NULL,
    [LastUpdated] [Date] NOT NULL,
    [UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[DelegationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--Nicholas
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [Production].[Make]
GO
CREATE TABLE [Production].[Make]
(
    [MakeName] NVARCHAR(100),
	[MakeID] INT,
	[UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[MakeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--Nicholas
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [Production].[Model]
GO
CREATE TABLE [Production].[Model]
(
    [ModelName] NVARCHAR(150),
	[ModelVariant] NVARCHAR(150),
	[MakeID] INT,
	[ModelID] INT,
	[UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[ModelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--Nicholas
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [Production].[Stock]
GO
CREATE TABLE [Production].[Stock]
(
    StockCode NVARCHAR(50),
	Cost MONEY,
	RepairsCost MONEY,
    PartsCost MONEY,
    TransportInCost MONEY,
    Color NVARCHAR(50),
    DateBought DATE,
    TimeBought TIME,
	[ModelID] INT,
	StockID INT,
	[UserAuthorizationKey] [int] NOT NULL,
    [DateAdded] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[StockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO





--------------------- Alter Tables To Update Defaults/Constraints -------------------


-- adding default values in the following format:
-- Aleks
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

--Aryeh
ALTER TABLE [HumanResources].[Staff] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[StaffSequenceObject]) FOR [StaffID]
GO
ALTER TABLE [HumanResources].[Departments] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[DepartmentsSequenceObject]) FOR [DepartmentKey]
GO

-- Edwin
ALTER TABLE [Sales].[Customers] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[CustomersSequenceObject]) FOR [CustomerID]
GO
ALTER TABLE [Sales].[Orders] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[OrdersSequenceObject]) FOR [OrderID]
GO
ALTER TABLE [Sales].[OrderDetails] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[OrderDetailsSequenceObject]) FOR [OrderDetailsID]
GO

-- Sigi
ALTER TABLE [Sales].[MakeMarketing] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[MarketingSequenceObject]) FOR [MarketingKey]
GO
ALTER TABLE [Sales].[BudgetDelegations] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[DelegationSequenceObject]) FOR [DelegationKey]
GO


--Nicholas
ALTER TABLE [Production].[Make] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[MakeSequenceObject]) FOR [MakeID]
GO
ALTER TABLE [Production].[Model] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[ModelSequenceObject]) FOR [ModelID]
GO
ALTER TABLE [Production].[Stock] ADD  DEFAULT (NEXT VALUE FOR [PkSequence].[StockSequenceObject]) FOR [StockID]
GO



-- add check constraints in the following format: 
-- Aleks
ALTER TABLE [Process].[WorkflowSteps]  WITH CHECK ADD  CONSTRAINT [FK_WorkFlowSteps_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Process].[WorkflowSteps] CHECK CONSTRAINT [FK_WorkFlowSteps_UserAuthorization]
GO

-- Aryeh
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

-- Edwin
ALTER TABLE [Sales].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Sales].[Customers] CHECK CONSTRAINT [FK_Customers_UserAuthorization]
GO

ALTER TABLE [Sales].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerID])
REFERENCES [Sales].[Customers] ([CustomerID])
GO
ALTER TABLE [Sales].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO

ALTER TABLE [Sales].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Sales].[Orders] CHECK CONSTRAINT [FK_Orders_UserAuthorization]
GO

ALTER TABLE [Sales].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([OrderID])
REFERENCES [Sales].[Orders] ([OrderID])
GO
ALTER TABLE [Sales].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Orders]
GO

ALTER TABLE [Sales].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Customers] FOREIGN KEY([CustomerID])
REFERENCES [Sales].[Customers] ([CustomerID])
GO
ALTER TABLE [Sales].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Customers]
GO

ALTER TABLE [Sales].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Sales].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_UserAuthorization]
GO

-- Sigi
ALTER TABLE [Sales].[MakeMarketing]  WITH CHECK ADD  CONSTRAINT [FK_Marketing_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Sales].[MakeMarketing] CHECK CONSTRAINT [FK_Marketing_UserAuthorization]
GO

ALTER TABLE [Sales].[BudgetDelegations]  WITH CHECK ADD  CONSTRAINT [FK_Delegation_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Sales].[BudgetDelegations] CHECK CONSTRAINT [FK_Delegation_UserAuthorization]
GO

ALTER TABLE [Sales].[ColorBudget]  WITH CHECK ADD  CONSTRAINT [FK_Color_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Sales].[ColorBudget] CHECK CONSTRAINT [FK_Color_UserAuthorization]
GO

ALTER TABLE [Sales].[CountryBudget]  WITH CHECK ADD  CONSTRAINT [FK_Country_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Sales].[CountryBudget] CHECK CONSTRAINT [FK_Country_UserAuthorization]
GO

ALTER TABLE [Sales].[SalesBudget]  WITH CHECK ADD  CONSTRAINT [FK_SalesBudget_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Sales].[SalesBudget] CHECK CONSTRAINT [FK_SalesBudget_UserAuthorization]
GO


--Nicholas
ALTER TABLE [Production].[Model]  WITH CHECK ADD  CONSTRAINT [FK_Model_Make] FOREIGN KEY([MakeID])
REFERENCES [Production].[Make] ([MakeID])
GO
ALTER TABLE [Production].[Model] CHECK CONSTRAINT [FK_Model_Make];
GO

ALTER TABLE [Production].[Stock]  WITH CHECK ADD  CONSTRAINT [FK_Stock_Model] FOREIGN KEY([ModelID])
REFERENCES [Production].[Model] ([ModelID])
GO
ALTER TABLE [Production].[Stock] CHECK CONSTRAINT [FK_Stock_Model];
GO

ALTER TABLE [Production].[Make] WITH CHECK ADD  CONSTRAINT [FK_Make_Authorization] FOREIGN KEY([AuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Production].[Make]  CHECK CONSTRAINT [FK_Make_Authorization] 
GO

ALTER TABLE [Production].[Model] WITH CHECK ADD  CONSTRAINT [FK_Model_Authorization] FOREIGN KEY([AuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Production].[Model]  CHECK CONSTRAINT [FK_Model_Authorization] 
GO

ALTER TABLE [Production].[Stock] WITH CHECK ADD  CONSTRAINT [FK_Stock_Authorization] FOREIGN KEY([AuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Production].[Stock]  CHECK CONSTRAINT [FK_Stock_Authorization] 
GO




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

    -- Aleks
    ALTER TABLE [Process].[WorkflowSteps]
    ADD CONSTRAINT FK_WorkFlowSteps_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    -- Aryeh
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

    -- Edwin
    ALTER TABLE [Sales].[Customers]
    ADD CONSTRAINT FK_Customers_UserAuthorization
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Sales].[Orders]
    ADD CONSTRAINT FK_Orders_Customers
        FOREIGN KEY ([CustomerID])
        REFERENCES [Sales].[Customers] ([CustomerID]);

    ALTER TABLE [Sales].[Orders]
    ADD CONSTRAINT FK_Orders_UserAuthorization
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Sales].[OrderDetails]
    ADD CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY ([OrderID])
        REFERENCES [Sales].[Orders] ([OrderID]);

    ALTER TABLE [Sales].[OrderDetails]
    ADD CONSTRAINT FK_OrderDetails_Customers
        FOREIGN KEY ([CustomerID])
        REFERENCES [Sales].[Customers] ([CustomerID]);

    ALTER TABLE [Sales].[OrderDetails]
    ADD CONSTRAINT FK_OrderDetails_UserAuthorization
        FOREIGN KEY ([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);


    -- Sigi
    ALTER TABLE [Sales].[MakeMarketing]
    ADD CONSTRAINT FK_Marketing_UserAuthorization
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Sales].[BudgetDelegations]
    ADD CONSTRAINT FK_Delegation_UserAuthorization
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Sales].[ColorBudget]
    ADD CONSTRAINT FK_Color_UserAuthorization
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Sales].[CountryBudget]
    ADD CONSTRAINT FK_Country_UserAuthorization
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

    ALTER TABLE [Sales].[SalesBudget]
    ADD CONSTRAINT FK_SalesBudget_UserAuthorization
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);

	--Nicholas
	ALTER TABLE [Production].[Make]  
	ADD CONSTRAINT FK_Make_UserAuthorization
		FOREIGN KEY ([UserAuthorizationKey])
		REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);
	ALTER TABLE [Production].[Model]  
	ADD CONSTRAINT FK_Model_UserAuthorization
		FOREIGN KEY ([UserAuthorizationKey])
		REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);
	ALTER TABLE [Production].[Stock]  
	ADD CONSTRAINT FK_Stock_UserAuthorization
		FOREIGN KEY ([UserAuthorizationKey])
		REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);
	ALTER TABLE [Production].[Model]
	ADD CONSTRAINT FK_Model_Make
		FOREIGN KEY ([MakeID])
		REFERENCES [Production].[Make](MakeID);
	ALTER TABLE [Production].[Stock]
	ADD CONSTRAINT FK_Stock_Model
		FOREIGN KEY ([ModelID])
	REFERENCES [Production].[Model](ModelID);




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


    -- Aleks
    ALTER TABLE [Process].[WorkflowSteps] DROP CONSTRAINT FK_WorkFlowSteps_UserAuthorization;

    -- Aryeh
    ALTER TABLE [HumanResources].[Staff] DROP CONSTRAINT FK_Staff_Departments;
    ALTER TABLE [HumanResources].[Staff] DROP CONSTRAINT FK_Staff_UserAuthorization;
    ALTER TABLE [HumanResources].[Departments] DROP CONSTRAINT FK_Departments_UserAuthorization;
    
    -- Sigi
    ALTER TABLE [Sales].[MakeMarketing] DROP CONSTRAINT FK_Marketing_UserAuthorization;
    ALTER TABLE [Sales].[BudgetDelegations] DROP CONSTRAINT FK_Delegation_UserAuthorization;
    ALTER TABLE [Sales].[ColorBudget] DROP CONSTRAINT FK_Color_UserAuthorization;
    ALTER TABLE [Sales].[CountryBudget] DROP CONSTRAINT FK_Country_UserAuthorization;
    ALTER TABLE [Sales].[SalesBudget] DROP CONSTRAINT FK_SalesBudget_UserAuthorization;
    
    -- Edwin
    ALTER TABLE [Sales].[Customers] DROP CONSTRAINT FK_Customers_UserAuthorization;
    ALTER TABLE [Sales].[Orders] DROP CONSTRAINT FK_Orders_Customers;
    ALTER TABLE [Sales].[Orders] DROP CONSTRAINT FK_Orders_UserAuthorization;
    ALTER TABLE [Sales].[OrderDetails] DROP CONSTRAINT FK_OrderDetails_Customers;
    ALTER TABLE [Sales].[OrderDetails] DROP CONSTRAINT FK_OrderDetails_Orders;
    ALTER TABLE [Sales].[OrderDetails] DROP CONSTRAINT FK_OrderDetails_UserAuthorization;
    
    -- Nicholas 
	ALTER TABLE [Production].[Model] DROP CONSTRAINT FK_Model_Make;
	ALTER TABLE [Production].[Stock] DROP CONSTRAINT FK_Stock_Model;
	ALTER TABLE [Production].[Make] DROP CONSTRAINT  FK_Make_UserAuthorization;
	ALTER TABLE [Production].[Model] DROP CONSTRAINT FK_Model_UserAuthorization;
	ALTER TABLE [Production].[Stock] DROP CONSTRAINT FK_Stock_UserAuthorization;


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
    
    -- Aleks
    ALTER SEQUENCE [PkSequence].[UserAuthorizationSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [DbSecurity].[UserAuthorization]
    ALTER SEQUENCE [PkSequence].[WorkFlowStepsSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [Process].[WorkFlowSteps]

    -- Aryeh
    ALTER SEQUENCE [PkSequence].[StaffSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [HumanResources].[Staff];
    ALTER SEQUENCE [PkSequence].[DepartmentsSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [HumanResources].[Departments];

    -- Edwin
    ALTER SEQUENCE [PkSequence].[CustomersSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [Sales].[Customers];
    ALTER SEQUENCE [PkSequence].[OrdersSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [Sales].[Orders];
    ALTER SEQUENCE [PkSequence].[OrderDetailsSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [Sales].[OrderDetails];

    -- Sigi
    ALTER SEQUENCE [PkSequence].[MarketingSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [Sales].[MakeMarketing];

    ALTER SEQUENCE [PkSequence].[DelegationSequenceObject] RESTART WITH 1;
    TRUNCATE TABLE [Sales].[BudgetDelegations];

    TRUNCATE TABLE [Sales].[ColorBudget];
    TRUNCATE TABLE [Sales].[CountryBudget];
    TRUNCATE TABLE [Sales].[SalesBudget];

	-- Nicholas
	ALTER SEQUENCE [PkSequence].[MakeSequenceObject] RESTART WITH 1;
	TRUNCATE TABLE [Production].[Make];
	ALTER SEQUENCE [PkSequence].[ModelSequenceObject] RESTART WITH 1; 
	TRUNCATE TABLE [Production].[Model];
	ALTER SEQUENCE [PkSequence].[StockSequenceObject] RESTART WITH 1;
	TRUNCATE TABLE [Production].[Stock];

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
        FROM [HumanResources].[Staff]
    -- Sigi
    UNION ALL
        SELECT TableStatus = @TableStatus,
        TableName = '[Sales].[MakeMarketing]',
            [Row Count] = COUNT(*)
        FROM [Sales].[MakeMarketing]
    UNION ALL
        SELECT TableStatus = @TableStatus,
        TableName = '[Sales].[BudgetDelegations]',
            [Row Count] = COUNT(*)
        FROM [Sales].[BudgetDelegations]
    UNION ALL
        SELECT TableStatus = @TableStatus,
        TableName = '[Sales].[ColorBudget]',
            [Row Count] = COUNT(*)
        FROM [Sales].[ColorBudget]
    UNION ALL
        SELECT TableStatus = @TableStatus,
        TableName = '[Sales].[CountryBudget]',
            [Row Count] = COUNT(*)
        FROM [Sales].[CountryBudget]
    UNION ALL
        SELECT TableStatus = @TableStatus,
        TableName = '[Sales].[SalesBudget]',
            [Row Count] = COUNT(*)
        FROM [Sales].[SalesBudget]
    -- Edwin
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Sales].[Customers]',
            [Row Count] = COUNT(*)
        FROM [Sales].[Customers]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Sales].[Orders]',
            [Row Count] = COUNT(*)
        FROM [Sales].[Orders]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Sales].[OrderDetails]',
            [Row Count] = COUNT(*)
        FROM [Sales].[OrderDetails]
	--Nicholas
	UNION ALL
	      SELECT TableStatus = @TableStatus,
            TableName = '[Production].[Make]',
            [Row Count] = COUNT(*)
        FROM [Production].[Make]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Production].[Model]',
            [Row Count] = COUNT(*)
        FROM [Production].[Model]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Production].[Stock]',
            [Row Count] = COUNT(*)
        FROM [Production].[Stock];



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



-- =============================================
-- Author:		Edwin Wray
-- Create date: 11/28/2023
-- Description:	Load data into the Customers table
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [Project2.5].[Load_Customers]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Sales].[Customers]
        (CustomerID, CustomerName, [Address1], [Address2], Town, Country, PostCode 
            , SpendCapacity, IsReseller, IsCreditRisk, UserAuthorizationKey, DateAdded)
    SELECT DISTINCT CAST(C.CustomerID AS INT) AS CustomerID, C.CustomerName, C.Address1, C.Address2
                        , Town, C.Country, C.PostCode, M.SpendCapacity, C.IsReseller, C.IsCreditRisk
                    , @UserAuthorizationKey, @DateAdded
    FROM [PrestigeCars].[Data].[Customer] AS C
        LEFT JOIN [PrestigeCars].[Reference].[MarketingInformation] AS M
            ON C.CustomerName = M.CUST AND C.Country = M.Country
    ORDER BY CustomerID


    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [Sales].Customers);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[Load_Customers] loads data into [Sales].Customers',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO

-- =============================================
-- Author:		Edwin Wray
-- Create date: 11/28/2023
-- Description:	Load data into the Orders table
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [Project2.5].[Load_Orders]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Sales].[Orders]
        (OrderID, CustomerID, OrderDate, InvoiceNumber, TotalSalePrice
            , UserAuthorizationKey, DateAdded)
    SELECT DISTINCT S.SalesID, CAST(S.CustomerID AS INT) AS CustomerID, S.SaleDate, S.InvoiceNumber, S.TotalSalePrice
                        , @UserAuthorizationKey, @DateAdded
    FROM [PrestigeCars].[Data].[Sales] AS S
    ORDER BY S.SalesID


    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [Sales].Orders);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[Load_Orders] loads data into [Sales].Orders',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO

-- =============================================
-- Author:		Edwin Wray
-- Create date: 11/28/2023
-- Description:	Load data into the OrderDetails table
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [Project2.5].[Load_OrderDetails]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Sales].[OrderDetails]
        (OrderDetailsID, OrderID, CustomerID, LineItemNumber, StockID
            , SalesPrice, LineItemDiscount, UserAuthorizationKey, DateAdded)
    SELECT DISTINCT SD.SalesDetailsID, SD.SalesID, CAST(S.CustomerID AS INT) AS CustomerID, SD.LineItemNumber
                        , SD.StockID, SD.SalePrice, SD.LineItemDiscount
                        , @UserAuthorizationKey, @DateAdded
    FROM [PrestigeCars].[Data].[SalesDetails] AS SD
        LEFT JOIN [PrestigeCars].[Data].[Sales] AS S
            ON SD.SalesID = S.SalesID
    ORDER BY SD.SalesDetailsID


    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [Sales].OrderDetails);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[Load_OrderDetails] loads data into [Sales].OrderDetails',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO


-- Sigi
/* Stored Proecedure: [Project2.5].[LoadMakeMarketing]

Description: 
Will pull in data from the Original Prestige Cars database and will reorganize and clean up the data into a more readable and effecient layout
This table differs from the table its pulling from by separating the marketing types using STRING_SPLIT to make the data more readable are useful in querying.
*/
/*
-- =============================================
-- Author:		Sigalita Yakubova
-- Create date: 11/27/23
-- Description:	Loads data into the Sales Marketing table
-- =============================================
*/
CREATE OR ALTER PROCEDURE [Project2.5].[LoadMakeMarketing]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO Sales.MakeMarketing (MakeName, MarketingType, DateAdded, UserAuthorizationKey)
    SELECT MakeName, Value AS MarketingType, @DateAdded, @UserAuthorizationKey
    FROM PrestigeCars.Reference.MarketingCategories
    CROSS APPLY STRING_SPLIT(MarketingType, ',');


    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [Sales].[MakeMarketing]);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[LoadMakeMarketing] loads data into [Sales].MakeMarketing',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO
/* Stored Proecedure: [Project2.5].[LoadBudgetDelegations]

Description: Loads in Budget Information for each location. 
This table doesn't include comments as they were not helpful and combines budget month and year

*/
-- =============================================
-- Author:		Sigalita Yakubova
-- Create date: 11/28/23
-- Description:	Loads data into the Sales Budget Delegations table
-- =============================================
CREATE OR ALTER PROCEDURE [Project2.5].[LoadBudgetDelegations]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Sales].BudgetDelegations (BudgetArea, BudgetAmount, BudgetDate, LastUpdated, UserAuthorizationKey, DateAdded)
    SELECT BudgetArea, BudgetAmount,
        DATEFROMPARTS(BudgetYear, BudgetMonth, 1),
         DateUpdated, @UserAuthorizationKey, @DateAdded
    FROM PrestigeCars.Reference.SalesBudgets

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [Sales].[BudgetDelegations]);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[LoadBudgetDelegations] loads data into [Sales].BudgetDelegations',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO


-- =============================================
-- Author:		Sigalita Yakubova
-- Create date: 11/28/23
-- Description:	Loads data into the Sales Color Budget table
-- =============================================
CREATE OR ALTER PROCEDURE [Project2.5].[LoadColorBudget]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO Sales.ColorBudget (BudgetKey, BudgetValue, BudgetYear, Color, UserAuthorizationKey, DateAdded)
    SELECT BudgetKey, BudgetValue, [Year], BudgetDetail, @UserAuthorizationKey, @DateAdded
    FROM PrestigeCars.Reference.Budget
    WHERE BudgetElement LIKE 'Color';

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [Sales].[ColorBudget]);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[LoadColorBudget] loads data into [Sales].ColorBudget',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO

-- =============================================
-- Author:		Sigalita Yakubova
-- Create date: 11/28/23
-- Description:	Loads data into the Sales Country Budget table
-- =============================================
CREATE OR ALTER PROCEDURE [Project2.5].[LoadCountryBudget]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO Sales.CountryBudget (BudgetKey, BudgetValue, BudgetDate, Country, UserAuthorizationKey, DateAdded)
    SELECT BudgetKey, BudgetValue, DATEFROMPARTS([Year], [Month], 1), BudgetDetail, @UserAuthorizationKey, @DateAdded
    FROM PrestigeCars.Reference.Budget
    WHERE BudgetElement LIKE 'Country';

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [Sales].[CountryBudget]);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[LoadCountryBudget] loads data into [Sales].CountryBudget',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO

-- =============================================
-- Author:		Sigalita Yakubova
-- Create date: 11/28/23
-- Description:	Loads data into the Sales Budget table
-- =============================================
CREATE OR ALTER PROCEDURE [Project2.5].[LoadSalesBudget]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2 = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO Sales.SalesBudget (BudgetKey, BudgetValue, BudgetDate, UserAuthorizationKey, DateAdded)
    SELECT BudgetKey, BudgetValue, DATEFROMPARTS([Year], [Month], 1), @UserAuthorizationKey, @DateAdded
    FROM PrestigeCars.Reference.Budget
    WHERE BudgetElement LIKE 'Sales';

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [Sales].[SalesBudget]);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[LoadSalesBudget] loads data into [Sales].SalesBudget',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey
END;
GO


--============================================================
-- Author: Nicholas Kong
-- Create date: 11/28/2023
-- Description: Extract from Source to Target for Production.Model & Normalize
--============================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [Project2.5].[Load_Model]
	@UserAuthorizationKey INT
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @DateAdded DATETIME2 = SYSDATETIME();
	DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

	-- Extract Process

    -- Insert distinct rows from the source table
    -- Use ISNULL to handle null values in the ModelID column
    -- Coalesce resolves the rows displaying null values
    -- Nullif '' resolves the rows displaying empty string
    INSERT INTO [Production].[Model](ModelName, ModelVariant, MakeID,ModelID, UserAuthorizationKey,DateAdded)
    SELECT DISTINCT
        COALESCE(NULLIF(ModelName, ''), 'Not Specified') AS ModelName,
        COALESCE(NULLIF(ModelVariant, ''), 'Not Specified') AS ModelVariant,
		M.MakeID,
		M.ModelID, 
		@UserAuthorizationKey,
		@DateAdded
    FROM PrestigeCars.Data.Model AS M
	JOIN [PrestigeCars].[Data].[Stock] AS S
		ON M.ModelID = S.ModelID
	Order By M.ModelID

	DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*)
                                        FROM [Production].Model);

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();

	DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[Load_Make] loads data into [Production].Make',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey

END;
GO

------------------------- CREATE VIEWS ---------------------------
/*

These views preserve some tables from the original Prestige Cars database. 
The original tables had various issues (ex: some were determined to be 
redundant) and so were broken into new tables in order to adhere to 
normalization techniques. 
Some original tables were preserved in Views since it's clear the business
would want to query that information quickly for reporting purposes.

*/





-- Stored Procedure for creating views
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ahnaf Ahmed
-- Create date: 11/29/2023
-- Description:	Creates views for PrestigeCars database
-- =============================================
CREATE OR ALTER PROCEDURE [Project2.5].[Create_Views]
    @UserAuthorizationKey INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DateAdded DATETIME2 = SYSDATETIME();

	DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

	-- uvw_[Sales].[OrdersByYear]
	EXEC ('DROP VIEW IF EXISTS [G9_1].[uvw_OrdersByYear]')

	EXEC ('CREATE VIEW [G9_1].[uvw_OrdersByYear]
    AS

    SELECT MA.[MakeName]
        ,MO.[ModelName]
        ,C.[CustomerName]
        ,C.[Country]
        ,S.[Cost]
        ,S.[RepairsCost]
        ,S.[PartsCost]
        ,S.[TransportInCost]
        ,OD.[SalesPrice]
        ,O.[OrderDate]
    FROM [Sales].[Orders] AS O
    INNER JOIN [Sales].[OrderDetails] AS OD ON O.[OrderID] = OD.[OrderID]
    INNER JOIN [Sales].[Customers] AS C ON O.[CustomerID] = C.[CustomerID]
    INNER JOIN [Production].[Stock] AS S ON OD.[StockID] = S.[StockID]
    INNER JOIN [Production].[Model] AS MO ON S.[ModelID] = MO.[ModelID]
    INNER JOIN [Production].[Make] AS MA ON MO.[MakeID] = MA.[MakeID]')


	-- G9_1.[uvw_[Sales].[Orders]ByCountry]
	EXEC ('DROP VIEW IF EXISTS [G9_1].[uvw_OrdersByCountry]')

	EXEC ('CREATE VIEW [G9_1].[uvw_OrdersByCountry]
    AS

    SELECT C.[Country]
        ,MA.[MakeName]
        ,MO.[ModelName]
        ,S.[Cost]
        ,S.[RepairsCost]
        ,S.[PartsCost]
        ,S.[TransportInCost]
        ,S.[Color]
        ,OD.[SalesPrice]
        ,OD.[LineItemDiscount]
        ,O.[InvoiceNumber]
        ,C.[CustomerName]
        ,OD.[OrderDetailsID]
    FROM [Sales].[Orders] AS O
    INNER JOIN [Sales].[OrderDetails] AS OD ON O.[OrderID] = OD.[OrderID]
    INNER JOIN [Sales].[Customers] AS C ON O.[CustomerID] = C.[CustomerID]
    INNER JOIN [Production].[Stock] AS S ON OD.[StockID] = S.[StockID]
    INNER JOIN [Production].[Model] AS MO ON S.[ModelID] = MO.[ModelID]
    INNER JOIN [Production].[Make] AS MA ON MO.[MakeID] = MA.[MakeID]')


	-- G9_1.[uvw_[Sales].[OrdersByCurrency]
	EXEC ('DROP VIEW IF EXISTS [G9_1].[uvw_OrdersByCurrency]')

	EXEC ('CREATE VIEW [G9_1].[uvw_OrdersByCurrency]
    AS

    SELECT MA.[MakeName]
        ,MO.[ModelName]
        ,[$] + S.[Cost] AS [VehicleCostInUSD]
        ,[￡] + (S.[Cost] * 0.79) [VehicleCostInGBP]
    FROM [Sales].[Orders] AS O
    INNER JOIN [Sales].[OrderDetails] AS OD ON O.[OrderID] = OD.[OrderID]
    INNER JOIN [Sales].[Customers] AS C ON O.[CustomerID] = C.[CustomerID]
    INNER JOIN [Production].[Stock] AS S ON OD.[StockID] = S.[StockID]
    INNER JOIN [Production].[Model] AS MO ON S.[ModelID] = MO.[ModelID]
    INNER JOIN [Production].[Make] AS MA ON MO.[MakeID] = MA.[MakeID]')


	-- G9_1.[uvw_StockPrices]
	EXEC ('DROP VIEW IF EXISTS [G9_1].[uvw_StockPrices]')

	EXEC ('CREATE VIEW [G9_1].[uvw_StockPrices]
    AS

    SELECT MA.[MakeName]
        ,MO.[ModelName]
        ,S.[Cost]
    FROM [Production].[Stock] AS S
    INNER JOIN [Production].[Model] AS MO ON S.[ModelID] = MO.[ModelID]
    INNER JOIN [Production].[Make] AS MA ON MO.[MakeID] = MA.[MakeID]')


    -- G9_1.[uvw_Pivot]
    EXEC ('DROP VIEW IF EXISTS [G9_1].[uvw_Pivot]')

    EXEC ('CREATE VIEW [G9_1].[uvw_Pivot]
    AS

    SELECT P.ProductName
        ,SUM(CASE WHEN YEAR(O.OrderDate) = 2015 THEN OD.[SalesPrice] END) AS [2015]
        ,SUM(CASE WHEN YEAR(O.OrderDate) = 2016 THEN OD.[SalesPrice] END) AS [2016]
        ,SUM(CASE WHEN YEAR(O.OrderDate) = 2017 THEN OD.[SalesPrice] END) AS [2017]
        ,SUM(CASE WHEN YEAR(O.OrderDate) = 2018 THEN OD.[SalesPrice] END) AS [2018]
    FROM [Sales].[Orders] AS O
    INNER JOIN [Sales].[OrderDetails] AS OD ON O.[OrderID] = OD.[OrderID]
    INNER JOIN [Production].[Stock] AS S ON OD.[StockID] = S.[StockID]
    GROUP BY S.[Color]')


	DECLARE @WorkFlowStepTableRowCount INT = 0;

	DECLARE @EndingDateTime DATETIME2 = SYSDATETIME()
	DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS BIGINT);

	EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2.5].[Create_Views] creates [G9_1].[uvw_OrdersByYear], [G9_1].[uvw_OrdersByCountry], [G9_1].[uvw_OrdersByCurrency], [G9_1].[uvw_StockPrices], and [G9_1].[uvw_Pivot] views for the PrestigeCars database'
		,@WorkFlowStepTableRowCount
		,@StartingDateTime
		,@EndingDateTime
		,@QueryTime
		,@UserAuthorizationKey
END;
GO





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

    -- Edwin
    EXEC [Project2.5].[Load_Customers] @UserAuthorizationKey = 4
    EXEC [Project2.5].[Load_Orders] @UserAuthorizationKey = 4
    EXEC [Project2.5].[Load_OrderDetails] @UserAuthorizationKey = 4

    -- Ahnaf
    EXEC [Project2.5].[Create_Views] @UserAuthorizationKey = 5

    -- Sigi
    EXEC [Project2.5].[LoadMakeMarketing] @UserAuthorizationKey = 2
    EXEC [Project2.5].[LoadBudgetDelegations] @UserAuthorizationKey = 2
    EXEC [Project2.5].[LoadColorBudget] @UserAuthorizationKey = 2
    EXEC [Project2.5].[LoadCountryBudget] @UserAuthorizationKey = 2    
    EXEC [Project2.5].[LoadSalesBudget] @UserAuthorizationKey = 2  

    -- Nicholas
    EXEC [Project2.5].[Load_Model] @UserAuthorizationKey = 3


    --	Check row count before truncation
    EXEC [Project2.5].[ShowTableStatusRowCount] @UserAuthorizationKey = 6,  -- Change to the appropriate UserAuthorizationKey
		@TableStatus = N'''Row Count after loading the Prestige Cars db'''

    --	Recreate all of the foreign keys after loading the Prestige Cars schema
    EXEC [Project2.5].[AddForeignKeysToPrestigeCars] @UserAuthorizationKey = 1; -- Change to the appropriate UserAuthorizationKey

END;
GO

----------------- EXEC COMMANDS TO MANAGE THE DB -----------------------

-- run the following command to load the database
EXEC [Project2.5].[LoadPrestigeCarsDatabase]  @UserAuthorizationKey = 1;

-- run the following 2 exec commands to CLEAR and load the database 
-- EXEC [Project2.5].[TruncatePrestigeCarsDatabase] @UserAuthorizationKey = 1;
-- EXEC [Project2.5].[LoadPrestigeCarsDatabase]  @UserAuthorizationKey = 1;

-- run the following to show the workflow steps table 
EXEC [Process].[usp_ShowWorkflowSteps]
