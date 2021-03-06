USE [master]
GO
/****** Object:  Database [B2BDBMSProject]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE DATABASE [B2BDBMSProject]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'B2BDBMSProject', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\B2BDBMSProject.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'B2BDBMSProject_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\B2BDBMSProject_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [B2BDBMSProject] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [B2BDBMSProject].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [B2BDBMSProject] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET ARITHABORT OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [B2BDBMSProject] SET AUTO_SHRINK ON 
GO
ALTER DATABASE [B2BDBMSProject] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [B2BDBMSProject] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [B2BDBMSProject] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET  ENABLE_BROKER 
GO
ALTER DATABASE [B2BDBMSProject] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [B2BDBMSProject] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET RECOVERY FULL 
GO
ALTER DATABASE [B2BDBMSProject] SET  MULTI_USER 
GO
ALTER DATABASE [B2BDBMSProject] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [B2BDBMSProject] SET DB_CHAINING OFF 
GO
ALTER DATABASE [B2BDBMSProject] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [B2BDBMSProject] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'B2BDBMSProject', N'ON'
GO
USE [B2BDBMSProject]
GO
/****** Object:  UserDefinedTableType [dbo].[ModelSubsidiaryInsert]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE TYPE [dbo].[ModelSubsidiaryInsert] AS TABLE(
	[SUIT] [uniqueidentifier] NULL,
	[NickName] [varchar](200) NULL
)
GO
/****** Object:  StoredProcedure [dbo].[AddAddress]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddAddress is used by an outside application to add a new record to the dbo.Address table
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@EntityId				INT				FK to dbo.Entity
--	@AddressTypeId			INT				FK to dbo.AddressType
--  @AddressLine1			VARCHAR(200)	First line of address data
--  @AddressLine2			VARCHAR(200)	Second line of address data
--  @City					VARCHAR(100)	Free-text city of address
--  @State					VARCHAR(2)		2-letter state abbreviation
--  @PostalCode				VARCHAR(10)		Zip or other postal code
--  @Country				VARCHAR(100)	Country where the address is located
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddAddress @EntityId = 1, @AddressTypeId = 3, @AddressLine1 = '1863 Ellison Creek Rd' @AddressLine2 = NULL, @City = 'Clemmons', @State = 'NC', @PostalCode = '27012', @Country = 'USA'
-- =============================================
CREATE PROCEDURE [dbo].[AddAddress]
	 @EntityId INT
	,@AddressTypeId INT
	,@AddressLine1 VARCHAR(200)
	,@AddressLine2 VARCHAR(200)
	,@City VARCHAR(100)
	,@State VARCHAR(2)
	,@PostalCode VARCHAR(10)
	,@Country VARCHAR(100)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.[Address] --Address is a reserved word in SQL Server; [] used to differentiate from reserved word.
	(
	 EntityId
	,AddressTypeId
	,AddressLine1
	,AddressLine2
	,City
	,[State] --State is a reserved word in SQL Server; [] used to differentiate from reserved word.
	,PostalCode
	,Country
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@EntityId, @AddressTypeId, @AddressLine1, @AddressLine2, @City, @State, @PostalCode, @Country, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddAddressType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddAddressType is used by an outside application to add a new record to the dbo.AddressType table
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@AddressTypeDescription	VARCHAR(200)	Describes the address type (i.e. Home, Office, Mailing, etc.)
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddAddressType @AddressTypeDescription = 'Billing'
-- =============================================
CREATE PROCEDURE [dbo].[AddAddressType]
	 @AddressTypeDescription VARCHAR(200)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.AddressType (AddressTypeDescription, IsDeleted, InsertUser, InsertDateTime)
   VALUES (@AddressTypeDescription, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddCompany]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddCompany is used by an outside application to add a new record to the dbo.Company table
-- Arguments:
--	Parameter Name			Data Type			Notes
--	@CUIT					UNIQUEIDENTIFIER	GUID uniquely identifying the Company
--	@CompanyTypeId			INT					FK to dbo.CompanyType
--  @CompanyName			VARCHAR(1000)		Full name of company
--  @ActivityStartDate		DATE				The date of commencement of business activities
--  @Website				VARCHAR(2000)		Web address of the company website
--  @User					INT					FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddCompany @CUIT = '00000000-0000-0000-0000-000000000000', @CompanyTypeId = 2, @CompanyName = 'Acme Supply', @ActivityStartDate = '20000101', @website = 'www.acmesupply.com'
-- =============================================
CREATE PROCEDURE [dbo].[AddCompany]
	 @CUIT UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
	,@CompanyTypeId INT
	,@CompanyName VARCHAR(1000)
	,@ActivityStartDate DATE
	,@Website VARCHAR(2000)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.Company
	(
	 CUIT
	,CompanyTypeId
	,CompanyName
	,ActivityStartDate
	,Website
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@CUIT, @CompanyTypeId, @CompanyName, @ActivityStartDate, @Website, 0, @User, GETDATE())
	
END


DELETE dbo.Company
WHERE CompanyEntityId = 22


GO
/****** Object:  StoredProcedure [dbo].[AddCompanyPrice]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddCompanyPrice is used by an outside application to add a new record to the dbo.CompanyPrice table
-- Arguments:
--	Parameter Name			Data Type			Notes
--	@CompanyEntityId		INT					FK to dbo.Company
--	@SupplierProductId		INT					FK to dbo.SupplierProduct (links a supplier with a product and a default price)
--  @CompanyPricePerUnit	Money				Company price per unit (units defined in SupplierProduct)
--  @User					INT					FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddCompanyPrice @CompanyEntityId = 2, @SupplierProductId = 301, @CompanyPricePerUnit = 51.99
-- =============================================
CREATE PROCEDURE [dbo].[AddCompanyPrice]
	 @CompanyEntityId INT
	,@SupplierProductId INT
	,@CompanyPricePerUnit MONEY
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.CompanyPrice
	(
	 CompanyEntityId
	,SupplierProductId
	,CompanyPricePerUnit
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@CompanyEntityId, @SupplierProductId, @CompanyPricePerUnit, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddCompanyType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/10/2019
-- Description:	dbo.AddCompanyType is used by an outside application to add a new record to the dbo.CompanyType table
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@CompanyTypeDescription	VARCHAR(200)	Friendly description of the company type (i.e. User Company or Supplier)
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddCompanyType @CompanyTypeDescriptoin = 'New Description'
-- =============================================
CREATE PROCEDURE [dbo].[AddCompanyType]
	 @CompanyTypeDescription VARCHAR(200)
	,@User INT = 14 -- Admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.[CompanyType] 
	(
	 CompanyTypeDescription
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@CompanyTypeDescription, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddCompanyWithSubsidiaries]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddCompanyWithSubsidiaries adds a new company and all related subsidiaries
-- Arguments:
--	Parameter Name			Data Type			Notes
--	@CUIT					UNIQUEIDENTIFIER	GUID uniquely identifying the Company
--	@CompanyTypeId			INT					FK to dbo.CompanyType
--  @CompanyName			VARCHAR(1000)		Full name of company
--  @ActivityStartDate		DATE				The date of commencement of business activities
--  @Website				VARCHAR(2000)		Web address of the company website
--  @Subsidiaries			TABLE				Using Type definition ModelSubsidiaryInsert, adds 1 or many subsidiaries related to the company
--  @User					INT					FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  DECLARE @tablevariable AS ModelSubsidiaryInsert
--  INSERT @tablevariable (SUIT, NickName)
--  VALUES ('00000000-0000-0000-0000-000000000000', 'BunnyWorld'), ('00000000-0000-0000-0000-000000000000', 'CMI'), ('00000000-0000-0000-0000-000000000000', 'Cuba Libre')
--  EXEC dbo.AddCompanyWithSubsidiaries @CUIT = '00000000-0000-0000-0000-000000000000', @CompanyTypeId = 1, @CompanyName = 'Doug Perez Enterprises', @ActivityStartDate = '20180101', @website = 'www.dougperezenterprises.com', @Subsidiaries = @tablevariable
-- =============================================
CREATE PROCEDURE [dbo].[AddCompanyWithSubsidiaries]
	(
	 @CUIT UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
	,@CompanyTypeId INT
	,@CompanyName VARCHAR(1000)
	,@ActivityStartDate DATE
	,@Website VARCHAR(2000)
	,@Subsidiaries dbo.ModelSubsidiaryInsert READONLY
	)
AS 
-- The CUIT GUID will be important for linking the records we create, so we make sure that the value is known and stored as a variable
IF @CUIT = '00000000-0000-0000-0000-000000000000'
	SET @CUIT = NEWID()

--In the first step, the company is added using dbo.AddCompany stored procedure
EXEC dbo.AddCompany @CUIT = @CUIT, @CompanyTypeId = @CompanyTypeId, @CompanyName = @CompanyName, @ActivityStartDate = @ActivityStartDate, @Website = @Website

--Next, we retrieve the newly created CompanyEntityId using the CUIT value we created earlier
DECLARE @CompanyEntityId INT
SELECT @CompanyEntityId = CompanyEntityId FROM dbo.Company WHERE CUIT = @CUIT

--Now it is time to define the loop we will use to create all related subsidiaries.
--The #loop table adds an incrementing integer to the @Subsidiaries table variable.
--The ID incrementing integer will be used to step through the records in the loop.
CREATE TABLE #loop
	(
	 ID INT IDENTITY(1,1)
	,SUIT UNIQUEIDENTIFIER
	,NickName VARCHAR(200)
	)
INSERT #loop (SUIT, NickName)
SELECT SUIT, NickName
FROM @Subsidiaries

--Addional variables need to be declared to add the subsidiaries.
DECLARE @SUIT UNIQUEIDENTIFIER, @Nickname VARCHAR(200), @Counter INT = 1

--Next we begin the loop.  The counter begins at 1 and the loop will run as long as the counter holds a value in the ID column of #loop.
WHILE @counter <= (SELECT MAX(ID) FROM #loop)
BEGIN
	SELECT @SUIT = SUIT, @Nickname = Nickname --The subsidiary-specific data is assigned to variables
	FROM #loop
	WHERE ID = @Counter

	--Subsidiary is added using the dbo.AddSubsidiary procedure and the data is passed through the variables assigned earlier 
	EXEC dbo.AddSubsidiary @SUIT = @SUIT, @CompanyEntityId = @CompanyEntityId, @Nickname = @Nickname

	--Increment the counter to the next iteration
	SET @Counter += 1
END 
GO
/****** Object:  StoredProcedure [dbo].[AddCustomer]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddCustomer is used by an outside application to add a new record to the dbo.Customer table
-- Arguments:
--	Parameter Name			Data Type			Notes
--	@COIT					UNIQUEIDENTIFIER	GUID uniquely identifying the Customer
--	@DocumentNumber			VARCHAR(200)		Free-text identifier of the customer's document.
--  @DocumentTypeId			INT					FK to DocumentType.  Describes what sort of document the DocumentNumber refers to.
--  @FullName				VARCHAR(200)		The customer's full name, per the requirements.
--  @DateOfBirth			DATE				Customer's date of birth.
--  @DiscountPercent		NUMERIC(5,3)		A number between 0 and 1 reflecting any discount percentage the customer might receive.
--  @User					INT					FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddCustomer @COIT = '00000000-0000-0000-0000-000000000000', @DocumentNumber = 1234567, @DocumentTypeId = 1, @FullName = 'Doug Perez', @DateOfBirth = '20000101', @DiscountPercent = .05
-- =============================================
CREATE PROCEDURE [dbo].[AddCustomer]
	 @COIT UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
	,@DocumentNumber VARCHAR(200)
	,@DocumentTypeId INT
	,@FullName VARCHAR(200)
	,@DateOfBirth DATE
	,@DiscountPercent NUMERIC(5,3)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.Customer
	(
	 COIT
	,DocumentNumber
	,DocumentTypeId
	,FullName
	,DateOfBirth
	,DiscountPercent
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@COIT, @DocumentNumber, @DocumentTypeId, @FullName, @DateOfBirth, @DiscountPercent, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddDocumentType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddDocumentType is used by an outside application to add a new record to the dbo.DocumentType table
-- Arguments:
--	Parameter Name				Data Type		Notes
--	@DocumentTypeDescription	VARCHAR(200)	Describes the Document type (i.e. Driver License, Passport, etc.)
--  @User						INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddDocumentType @DocumentTypeDescription = 'Student ID'
-- =============================================
CREATE PROCEDURE [dbo].[AddDocumentType]
	 @DocumentTypeDescription VARCHAR(200)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.DocumentType (DocumentTypeDescription, IsDeleted, InsertUser, InsertDateTime)
   VALUES (@DocumentTypeDescription, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddEmail]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddEmail is used by an outside application to add a new record to the dbo.Email table
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@EntityId				INT				FK to dbo.Entity
--	@EmailTypeId			INT				FK to dbo.EmailType
--  @Email					VARCHAR(1000)	The email address
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddEmail @EntityId = 1, @EmailTypeId = 3, @Email = 'you@address.com'
-- =============================================
CREATE PROCEDURE [dbo].[AddEmail]
	 @EntityId INT
	,@EmailTypeId INT
	,@Email VARCHAR(1000)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.[Email] 
	(
	 EntityId
	,EmailTypeId
	,Email
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@EntityId, @EmailTypeId, @Email, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddEmailType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddEmailType is used by an outside application to add a new record to the dbo.EmailType table
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@EmailTypeDescription	VARCHAR(200)	Describes the Email type (i.e. Work, Home, Business, etc.)
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddEmailType @EmailTypeDescription = 'Marketing'
-- =============================================
CREATE PROCEDURE [dbo].[AddEmailType]
	 @EmailTypeDescription VARCHAR(200)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.EmailType (EmailTypeDescription, IsDeleted, InsertUser, InsertDateTime)
   VALUES (@EmailTypeDescription, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddEntityType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddEntityType is used by an outside application to add a new record to the dbo.EntityType table
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@EntityTypeDescription	VARCHAR(200)	Describes the Entity type (i.e. Company, Supplier, User, etc.)
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddEntityType @EntityTypeDescription = 'Vendor'
-- =============================================
CREATE PROCEDURE [dbo].[AddEntityType]
	 @EntityTypeDescription VARCHAR(200)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.EntityType (EntityTypeDescription, IsDeleted, InsertUser, InsertDateTime)
   VALUES (@EntityTypeDescription, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddOrder]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddOrder is used by an outside application to add a new order header to the dbo.Order table
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@CustomerEntityId		INT				FK to dbo.Customer
--	@SubsidiaryEntityId		INT				FK to dbo.Subsidiary
--  @OrderDate				DATETIME		Date the order was placed
--  @ShippingAddressId		INT				FK to dbo.Address
--  @OrderNotes				VARCHAR(MAX)	Free-text notes about the order
--  @OrderStatusId			INT				FK to dbo.OrderStatus
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddOrder @CustomerEntityId = 1, @SubsidiaryEntityId = 8, @OrderDate = '20180101', @ShippingAddressId = 2, @OrderNotes = 'No notes at this time', @OrderStatusId = 1
-- =============================================
CREATE PROCEDURE [dbo].[AddOrder]
	 @CustomerEntityId INT
	,@SubsidiaryEntityId INT
	,@OrderDate DATETIME
	,@ShippingAddressId INT
	,@OrderNotes VARCHAR(MAX)
	,@OrderStatusId INT
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.[Order] --Order is a reserved word in SQL Server; [] used to differentiate from reserved word.
	(
	 CustomerEntityId
	,SubsidiaryEntityId
	,OrderDate
	,ShippingAddressId
	,OrderNotes
	,OrderStatusId
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@CustomerEntityId, @SubsidiaryEntityId, @OrderDate, @ShippingAddressId, @OrderNotes, @OrderStatusId, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddOrderItem]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddOrderItem is used by an outside application to add a new OrderItem details to the dbo.OrderItem table for an order in dbo.Order.
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@OrderId				INT				FK to dbo.Order
--	@CompanyPriceId			INT				FK to dbo.CompanyPrice
--  @OrderLineNumber		DATETIME		Unique number assigned to each line of the order (1,2,3...)
--  @UnitsOrdered			NUMERIC(5,3)	Number of units of product ordered
--  @OverridePrice			Money			Free-entry price to override price calculations
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddOrderItem @OrderId = 1, @CompanyPriceId = 3, @OrderLineNumber = 1, @UnitsOrdered = 5, @OverridePrice = NULL
-- =============================================
CREATE PROCEDURE [dbo].[AddOrderItem]
	 @OrderId INT
	,@CompanyPriceId INT
	,@OrderLineNumber INT
	,@UnitsOrdered NUMERIC(5,3)
	,@OverridePrice MONEY
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.[OrderItem] 
	(
	 OrderId
	,CompanyPriceId
	,OrderLineNumber
	,UnitsOrdered
	,ListPrice
	,DiscountPrice
	,OverridePrice
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@OrderId, @CompanyPriceId, @OrderLineNumber, @UnitsOrdered, dbo.GetListPrice(@CompanyPriceId), dbo.GetDiscountPrice(@CompanyPriceId, @OrderId), @OverridePrice, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddOrderStatus]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddOrderStatus is used by an outside application to add a new record to the dbo.OrderStatus table
-- Arguments:
--	Parameter Name				Data Type		Notes
--	@OrderStatusDescription		VARCHAR(200)	Describes the Order Status (i.e. New, Processing, Shipped, etc.)
--  @User						INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddOrderStatus @OrderStatusDescription = 'Cancelled'
-- =============================================
CREATE PROCEDURE [dbo].[AddOrderStatus]
	 @OrderStatusDescription VARCHAR(200)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.OrderStatus (OrderStatusDescription, IsDeleted, InsertUser, InsertDateTime)
   VALUES (@OrderStatusDescription, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddProduct]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddProduct is used by an outside application to add a new Product details to the dbo.Product table.
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@ProductDescription		VARCHAR(200)	Description of the product	
--	@ProductSKU				VARCHAR(50)		Product's own Stockkeeping Unit
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddProduct @ProductDescription = 'Enterprise Database Design, @ProductSKU = 'EDD0001234'
-- =============================================
CREATE PROCEDURE [dbo].[AddProduct]
	 @ProductDescription VARCHAR(200)
	,@ProductSKU VARCHAR(50)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.[Product] 
	(
	 ProductDescription
	,ProductSKU
	,isDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@ProductDescription, @ProductSKU, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddSubsidiary]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddSubsidiary is used by an outside application to add a new record to the dbo.Subsidiary table
-- Arguments:
--	Parameter Name			Data Type			Notes
--	@SUIT					UNIQUEIDENTIFIER	GUID uniquely identifying the Subsidiary
--	@CompanyEntityId		INT					FK to dbo.Company
--  @NickName				VARCHAR(200)		Nickname of Subsidiary
--  @User					INT					FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddSubsidiary @SUIT = '00000000-0000-0000-0000-000000000000', @CompanyEntityId = 1, @Nickname = 'Southern Bunny Bakery'
-- =============================================
CREATE PROCEDURE [dbo].[AddSubsidiary]
	 @SUIT UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
	,@CompanyEntityId INT
	,@Nickname VARCHAR(200)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.Subsidiary
	(
	 SUIT
	,CompanyEntityId
	,Nickname
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@SUIT, @CompanyEntityId, @Nickname, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddSupplierProduct]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddSupplierProduct is used by an outside application to add a new SupplierProduct details to the dbo.SupplierProduct table.
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@SupplierEntityId		INT				FK to dbo.Company (Company Type = Supplier)	
--	@ProductId				INT				FK to dbo.Product
--  @UnitTypeId				INT				FK to dbo.UnitType
--  @SupplierPricePerUnit	Money			The amount the supplier will charge per unit of the product
--  @SupplierSKU			VARCHAR(50)		The supplier's stockkeeping unit identifier, if different from the product's 
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddSupplierProduct @SupplierEntityId = 11, @ProductId = 1, @UnitTypeId = 1, @SupplierPricePerUnit = 1000, @SupplierSKU = 'EDD99911'
-- =============================================
CREATE PROCEDURE [dbo].[AddSupplierProduct]
	 @SupplierEntityId INT
	,@ProductId INT
	,@UnitTypeId INT
	,@SupplierPricePerUnit MONEY
	,@SupplierSKU VARCHAR(50)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.[SupplierProduct] 
	(
	 SupplierEntityId
	,ProductId
	,UnitTypeId
	,SupplierPricePerUnit
	,SupplierSKU
	,isDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@SupplierEntityId, @ProductId, @UnitTypeId, @SupplierPricePerUnit, @SupplierSKU, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddTelephone]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddTelephone is used by an outside application to add a new Telephone details to the dbo.Telephone table.
-- Arguments:
--	Parameter Name			Data Type		Notes
--	@EntityId				INT				FK to dbo.Entity
--	@TelephoneType			INT				FK to dbo.TelephoneType
--  @TelephoneNumber		VARCHAR(20)		The telephone number to be stored
--  @User					INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddTelephone @EntityId = 1, @TelephoneType = 3, @TelephoneNumber = 123456789
-- =============================================
CREATE PROCEDURE [dbo].[AddTelephone]
	 @EntityId INT
	,@TelephoneTypeId INT
	,@TelephoneNumber VARCHAR(20)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.[Telephone] 
	(
	 EntityId
	,TelephoneTypeId
	,TelephoneNumber
	,isDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@EntityId, @TelephoneTypeId, @TelephoneNumber, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddTelephoneType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddTelephoneType is used by an outside application to add a new record to the dbo.TelephoneType table
-- Arguments:
--	Parameter Name				Data Type		Notes
--	@TelephoneTypeDescription	VARCHAR(200)	Describes the Telephone type (i.e. Work, Home, Fax, etc.)
--  @User						INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddTelephoneType @TelephoneTypeDescription = 'Voicemail'
-- =============================================
CREATE PROCEDURE [dbo].[AddTelephoneType]
	 @TelephoneTypeDescription VARCHAR(200)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.TelephoneType (TelephoneTypeDescription, IsDeleted, InsertUser, InsertDateTime)
   VALUES (@TelephoneTypeDescription, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddUnitType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddUnitType is used by an outside application to add a new record to the dbo.UnitType table
-- Arguments:
--	Parameter Name				Data Type		Notes
--	@UnitTypeDescription		VARCHAR(200)	Describes the Unit type (i.e. kg, ft, lb, etc.)
--  @User						INT				FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddUnitType @UnitTypeDescription = 'Metric Ton'
-- =============================================
CREATE PROCEDURE [dbo].[AddUnitType]
	 @UnitTypeDescription VARCHAR(200)
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.UnitType (UnitTypeDescription, IsDeleted, InsertUser, InsertDateTime)
   VALUES (@UnitTypeDescription, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[AddUser]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/9/2019
-- Description:	dbo.AddUser is used by an outside application to add a new record to the dbo.[User] table
-- Arguments:
--	Parameter Name			Data Type			Notes
--	@USIT					UNIQUEIDENTIFIER	GUID uniquely identifying the User
--	@LastName				VARCHAR(100)		User's last name
--  @FirstName				VARCHAR(100)		User's first name
--  @Username				VARCHAR(50)			Username to access the system
--  @FirstActivityDate		DATETIME			Date user became active
--  @User					INT					FK to dbo.User.  The UserID of the user entering the record.
--  Execution example:
--  EXEC dbo.AddUser @USIT = '00000000-0000-0000-0000-000000000000', @LastName = 'Cheek', @FirstName = 'Alex', @UserName = 'acheek', @FirstActiveDate = '20000101'
-- =============================================
CREATE PROCEDURE [dbo].[AddUser]
	 @USIT UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
	,@LastName VARCHAR(100)
	,@FirstName VARCHAR(100)
	,@UserName VARCHAR(50)
	,@FirstActiveDate DATETIME
	,@User INT = 14 --14 is the hard-coded admin user in this system.
AS
BEGIN

	SET NOCOUNT ON;

   INSERT dbo.[User]
	(
	 USIT
	,LastName
	,FirstName
	,UserName
	,FirstActiveDate
	,IsDeleted
	,InsertUser
	,InsertDateTime
	)
   VALUES (@USIT, @LastName, @FirstName, @UserName, @FirstActiveDate, 0, @User, GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[GetProductOrdersByCompanyByMonth]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Doug Perez
-- Create date: 1/14/2019
-- Description:	dbo.GetProductOrdersByCompanyByMonth returns number of products ordered by month by subsidiary for a specific company or all companies
-- Arguments:
--	Parameter Name			Data Type			Notes
--	@CUIT					UNIQUEIDENTIFIER	GUID uniquely identifying the Company
--  Execution example:
--  EXEC dbo.GetProductOrdersByCompanyByMonth @CUIT = 'D89674D2-DD5B-4BA0-961B-93D96F0F6543'
-- =============================================
CREATE PROCEDURE [dbo].[GetProductOrdersByCompanyByMonth]
	(
	 @CUIT UNIQUEIDENTIFIER = NULL
	)
AS
SELECT 
	 DATEPART(yyyy, o.OrderDate) AS OrderYear
	,DATEPART(mm, o.OrderDate) AS MorderMonth
	,c.CompanyName
	,s.Nickname AS Subsidiary
	,p.ProductDescription
	,p.ProductSKU
	,ut.UnitTypeDescription
	,SUM(oi.UnitsOrdered) AS ProductTotal
FROM dbo.Company c
JOIN dbo.Subsidiary s
	ON c.CompanyEntityId = S.CompanyEntityId
	AND c.IsDeleted = 0
	AND s.IsDeleted = 0
LEFT JOIN dbo.[Order] o
	ON s.SubsidiaryEntityId = o.SubsidiaryEntityId
	AND o.isDeleted = 0
LEFT JOIN dbo.OrderItem	oi
	ON o.OrderId = oi.OrderId
	AND oi.IsDeleted = 0
LEFT JOIN dbo.CompanyPrice cp
	ON oi.CompanyPriceId = cp.CompanyPriceId
	AND cp.IsDeleted = 0
LEFT JOIN dbo.SupplierProduct sp
	ON cp.SupplierProductId = sp.SupplierProductId
	AND sp.isDeleted = 0
LEFT JOIN dbo.Product p
	ON sp.ProductId = p.ProductId
	AND p.IsDeleted = 0
LEFT JOIN dbo.UnitType ut
	ON sp.UnitTypeId = ut.UnitTypeId
	AND ut.IsDeleted = 0
WHERE c.CUIT = @CUIT
OR @CUIT IS NULL
GROUP BY DATEPART(yyyy, o.OrderDate), DATEPART(mm, o.OrderDate), c.CompanyName, s.Nickname, p.ProductDescription, p.ProductSKU, ut.UnitTypeDescription
ORDER BY DATEPART(yyyy, o.OrderDate), DATEPART(mm, o.OrderDate), c.CompanyName, s.Nickname, p.ProductDescription, p.ProductSKU, ut.UnitTypeDescription

GO
/****** Object:  StoredProcedure [dbo].[GetTotalOrdersPaidForCustomer]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/14/2019
-- Description:	dbo.GetTotalOrdersPaidForCustomer total value of orders by company a specific customer or all customers
-- Arguments:
--	Parameter Name			Data Type			Notes
--	@COIT					UNIQUEIDENTIFIER	GUID uniquely identifying the Customer
--  Execution example:
--  EXEC dbo.GetTotalOrdersPaidForCustomer @COIT = '00000000-0000-0000-0000-000000000000'
-- =============================================
CREATE PROCEDURE [dbo].[GetTotalOrdersPaidForCustomer]
	(
	 @COIT UNIQUEIDENTIFIER = NULL
	)
AS
SELECT c.COIT, c.FullName AS CustomerName, co.CompanyName, SUM(o.TotalPrice) TotalOrdersPaid
FROM dbo.Customer c
JOIN dbo.[Order] o
	ON c.CustomerEntityId = o.CustomerEntityId
	AND c.IsDeleted = 0
	AND o.IsDeleted = 0
JOIN dbo.Subsidiary s
	ON o.SubsidiaryEntityId = s.SubsidiaryEntityId
	AND s.isDeleted = 0
JOIN dbo.Company co
	ON s.CompanyEntityId = co.CompanyEntityId
	AND o.IsDeleted = 0
WHERE c.COIT = @COIT
OR @COIT IS NULL
GROUP BY c.COIT, c.FullName, co.CompanyName
ORDER BY c.FullName, TotalOrdersPaid DESC
GO
/****** Object:  UserDefinedFunction [dbo].[GetAddressFromEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetAddressFromEntityId retrieves the Address record based on EntityId
-- =============================================
CREATE FUNCTION [dbo].[GetAddressFromEntityId]
(
	@EntityId INT
)
RETURNS @Return TABLE 
		(
		 AddressTypeDescription VARCHAR(200)
		,AddressLine1 VARCHAR(200)
		,AddressLine2 VARCHAR(200)
		,City VARCHAR(100)
		,[State] VARCHAR(2)
		,PostalCode VARCHAR(10)
		,Country VARCHAR(100)
		)
AS
BEGIN
		
	INSERT @Return
		(
		 AddressTypeDescription
		,AddressLine1
		,AddressLine2
		,City
		,[State]
		,PostalCode
		,Country
		)

	SELECT 
		 at.AddressTypeDescription
		,a.AddressLine1
		,a.AddressLine2
		,a.City
		,a.[State]
		,a.PostalCode
		,a.Country
	FROM dbo.[Address] a
	JOIN dbo.AddressType at
		ON a.AddressTypeId = at.AddressTypeId
	WHERE a.EntityId = @EntityId

	RETURN

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetCOITFromCustomerEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetCOITFromCustomerEntityId finds the COIT based on CustomerEntityId
-- =============================================
CREATE FUNCTION [dbo].[GetCOITFromCustomerEntityId]
(
	@CustomerEntityId INT
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	
	DECLARE @Return UNIQUEIDENTIFIER

	SELECT @Return = COIT FROM dbo.Customer WHERE CustomerEntityId = @CustomerEntityId

	RETURN @Return

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetCOITFromDocumentNumber]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetCOITFromDocumentNumber finds the COIT based on DocumentNumber
-- =============================================
CREATE FUNCTION [dbo].[GetCOITFromDocumentNumber]
(
	@DocumentNumber VARCHAR(200)
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	
	DECLARE @Return UNIQUEIDENTIFIER

	SELECT @Return = COIT FROM dbo.Customer WHERE DocumentNumber = @DocumentNumber

	RETURN @Return

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetCUITFromCompanyEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetCUITFromCompanyEntityId finds the CUIT based on CompanyEntityId
-- =============================================
CREATE FUNCTION [dbo].[GetCUITFromCompanyEntityId]
(
	@CompanyEntityId INT
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	
	DECLARE @Return UNIQUEIDENTIFIER

	SELECT @Return = CUIT FROM dbo.Company c WHERE CompanyEntityId = @CompanyEntityId

	RETURN @Return

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetCUITFromSubsidiaryEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetCUITFromSubsidiaryEntityId finds the CUIT based on SubsidiaryEntityId
-- =============================================
CREATE FUNCTION [dbo].[GetCUITFromSubsidiaryEntityId]
(
	@SubsidiaryEntityId INT
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	
	DECLARE @Return UNIQUEIDENTIFIER

	SELECT @Return = c.CUIT FROM dbo.Subsidiary s JOIN dbo.Company c ON s.CompanyEntityId = c.CompanyEntityId WHERE s.SubsidiaryEntityId = @SubsidiaryEntityId

	RETURN @Return

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetDiscountPrice]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetDiscountPrice finds the Discount price based on CustomerPriceId
-- =============================================
CREATE FUNCTION [dbo].[GetDiscountPrice]
(
	 @CompanyPriceId INT
	,@OrderId INT
	
)
RETURNS MONEY
AS
BEGIN
	
	DECLARE @Result MONEY, @Base MONEY, @Discount NUMERIC(5,3)

	SELECT @Base = CompanyPricePerUnit  FROM dbo.CompanyPrice WHERE CompanyPriceId = @CompanyPriceId AND IsDeleted = 0

	SELECT @Discount = c.DiscountPercent FROM dbo.Customer c JOIN dbo.[Order] o ON c.CustomerEntityId = o.CustomerEntityId WHERE o.OrderId = @OrderId AND o.IsDeleted = 0

	SELECT @Result = @Base * (1 - @Discount)

	RETURN @Result

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetEmailFromEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetEmailFromEntityId retrieves the Email record based on EntityId
-- =============================================
CREATE FUNCTION [dbo].[GetEmailFromEntityId]
(
	@EntityId INT
)
RETURNS @Return TABLE
	(
	 EmailTypeDescription VARCHAR(200)
	,Email VARCHAR(1000)
	)
AS
BEGIN
	
	INSERT @Return
		(
		 EmailTypeDescription
		,Email
		)
	SELECT tt.EmailTypeDescription, t.Email
	FROM dbo.Email t
	JOIN dbo.EmailType tt
		ON t.EmailTypeId = tt.EmailTypeId
	WHERE t.EntityId = @EntityId

	RETURN

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetListPrice]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetListPrice finds the list price based on CustomerPriceId
-- =============================================
CREATE FUNCTION [dbo].[GetListPrice]
(
	@CompanyPriceId INT
)
RETURNS MONEY
AS
BEGIN
	
	DECLARE @Result MONEY

	SELECT @Result = CompanyPricePerUnit FROM dbo.CompanyPrice WHERE CompanyPriceId = @CompanyPriceId AND IsDeleted = 0

	RETURN @Result

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetOrderTotal]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetOrderTotal sums all OrderItem line prices for the given OrderId
-- =============================================
CREATE FUNCTION [dbo].[GetOrderTotal]
(
	@OrderId INT
)
RETURNS MONEY
AS
BEGIN
	
	DECLARE @Result MONEY

	SELECT @Result = SUM(ISNULL(OverridePrice, DiscountPrice) * UnitsOrdered) FROM dbo.OrderItem WHERE OrderId = @OrderId AND IsDeleted = 0

	RETURN @Result

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetProductsFromOrderId]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetProductsFromOrderId retrieves the Products record based on OrderId
-- =============================================
CREATE FUNCTION [dbo].[GetProductsFromOrderId]
(
	@OrderId INT
)
RETURNS @Return TABLE
	(
	 ProductDescription VARCHAR(200)
	,ProductSKU VARCHAR(1000)
	,SupplierSKU VARCHAR(1000)
	,UnitsOrdered NUMERIC(5,3)
	)
AS
BEGIN
	
	INSERT @Return
		(
		 ProductDescription
		,ProductSKU
		,SupplierSKU
		,UnitsOrdered
		)
	SELECT p.ProductDescription, p.ProductSKU, sp.SupplierSKU, oi.UnitsOrdered
	FROM dbo.[Order] o
	JOIN dbo.OrderItem oi
		ON o.OrderId = oi.OrderId
	JOIN dbo.CompanyPrice cp
		ON oi.CompanyPriceId = cp.CompanyPriceId
	JOIN dbo.SupplierProduct sp
		ON cp.SupplierProductid = sp.SupplierProductId
	JOIN dbo.Product p
		ON sp.ProductId = p.ProductId
	WHERE o.OrderId = @OrderId

	RETURN

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetSubsidiariesByCompanyEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetSubsidiariesByCompanyEntityId retrieves the Subsidiaries that belong to a given Company
-- =============================================
CREATE FUNCTION [dbo].[GetSubsidiariesByCompanyEntityId]
(
	@CompanyEntityId INT
)
RETURNS @Return TABLE
	(
	 SUIT UNIQUEIDENTIFIER
	,Nickname VARCHAR(200)
	)
AS
BEGIN
	
	INSERT @Return
		(
		 SUIT
		,Nickname
		)
	SELECT SUIT, Nickname
	FROM dbo.Subsidiary
	WHERE CompanyEntityId = @CompanyEntityId

	RETURN

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetTelephoneFromEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/11/2018
-- Description:	dbo.GetTelephoneFromEntityId retrieves the telephone record based on EntityId
-- =============================================
CREATE FUNCTION [dbo].[GetTelephoneFromEntityId]
(
	@EntityId INT
)
RETURNS @Return TABLE
	(
	 TelephoneTypeDescription VARCHAR(200)
	,TelephoneNumber VARCHAR(20)
	)
AS
BEGIN
	
	INSERT @Return
		(
		 TelephoneTypeDescription
		,TelephoneNumber
		)
	SELECT tt.TelephoneTypeDescription, t.TelephoneNumber
	FROM dbo.Telephone t
	JOIN dbo.TelephoneType tt
		ON t.TelephoneTypeId = tt.TelephoneTypeId
	WHERE t.EntityId = @EntityId

	RETURN

END

GO
/****** Object:  Table [dbo].[Address]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Address](
	[AddressId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EntityId] [int] NOT NULL,
	[AddressTypeId] [int] NOT NULL,
	[AddressLine1] [varchar](200) NULL,
	[AddressLine2] [varchar](200) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](2) NULL,
	[PostalCode] [varchar](10) NULL,
	[Country] [varchar](100) NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Address_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_Address_EntityId_AddressTypeId] UNIQUE NONCLUSTERED 
(
	[EntityId] ASC,
	[AddressTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AddressType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AddressType](
	[AddressTypeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AddressTypeDescription] [varchar](200) NOT NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_AddressType_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_AddressType] PRIMARY KEY CLUSTERED 
(
	[AddressTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Company]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Company](
	[CompanyEntityId] [int] NOT NULL,
	[CUIT] [uniqueidentifier] NOT NULL,
	[CompanyTypeId] [int] NOT NULL,
	[CompanyName] [varchar](1000) NULL,
	[ActivityStartDate] [date] NULL,
	[Website] [varchar](2000) NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Company_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[CompanyEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_Company_CompanyEntityId_CUIT] UNIQUE NONCLUSTERED 
(
	[CompanyEntityId] ASC,
	[CUIT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyPrice]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyPrice](
	[CompanyPriceId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CompanyEntityId] [int] NOT NULL,
	[SupplierProductId] [int] NOT NULL,
	[CompanyPricePerUnit] [money] NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_CompanyPrice_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_CompanyPrice] PRIMARY KEY CLUSTERED 
(
	[CompanyPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_CompanyPrice_CompanyEntityId_SupplierProductId] UNIQUE NONCLUSTERED 
(
	[CompanyEntityId] ASC,
	[SupplierProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CompanyType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CompanyType](
	[CompanyTypeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CompanyTypeDescription] [varchar](200) NOT NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_CompanyType_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_CompanyTypeId] PRIMARY KEY CLUSTERED 
(
	[CompanyTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerEntityId] [int] NOT NULL,
	[COIT] [uniqueidentifier] NOT NULL,
	[DocumentNumber] [varchar](200) NOT NULL,
	[DocumentTypeId] [int] NOT NULL,
	[FullName] [varchar](200) NULL,
	[DateOfBirth] [date] NULL,
	[DiscountPercent] [numeric](5, 3) NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Customer_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_Customer_CustomerEntityId_COIT] UNIQUE NONCLUSTERED 
(
	[CustomerEntityId] ASC,
	[COIT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DocumentType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DocumentType](
	[DocumentTypeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DocumentTypeDescription] [varchar](200) NOT NULL,
	[isDeleted] [bit] NOT NULL,
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_DocumentType] PRIMARY KEY CLUSTERED 
(
	[DocumentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Email]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Email](
	[EmailId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EntityId] [int] NOT NULL,
	[EmailTypeId] [int] NOT NULL,
	[Email] [varchar](1000) NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_Email_IsDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_Email] PRIMARY KEY CLUSTERED 
(
	[EmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_Email_EntityId_EmailTypeId] UNIQUE NONCLUSTERED 
(
	[EntityId] ASC,
	[EmailTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailType](
	[EmailTypeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EmailTypeDescription] [varchar](200) NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_EmailType_IsDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_EmailType] PRIMARY KEY CLUSTERED 
(
	[EmailTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Entity]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Entity](
	[EntityId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EntityTypeId] [int] NOT NULL,
	[EntityNativeId] [uniqueidentifier] NOT NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Entity_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_Entity] PRIMARY KEY CLUSTERED 
(
	[EntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_Entity_EntityId_EntityNativeId] UNIQUE NONCLUSTERED 
(
	[EntityId] ASC,
	[EntityNativeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_Entity_EntityNativeId] UNIQUE NONCLUSTERED 
(
	[EntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EntityType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EntityType](
	[EntityTypeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EntityTypeDescription] [varchar](200) NOT NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_EntityType_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_EntityType] PRIMARY KEY CLUSTERED 
(
	[EntityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Order]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Order](
	[OrderId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CustomerEntityId] [int] NOT NULL,
	[SubsidiaryEntityId] [int] NOT NULL,
	[OrderDate] [date] NOT NULL,
	[ShippingAddressId] [int] NULL,
	[OrderNotes] [varchar](max) NULL,
	[OrderStatusId] [int] NOT NULL CONSTRAINT [DF_Order_OrderStatusId]  DEFAULT ((1)),
	[TotalPrice] [money] NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Order_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrderItem]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItem](
	[OrderItemId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrderId] [int] NOT NULL,
	[CompanyPriceId] [int] NOT NULL,
	[OrderLineNumber] [int] NOT NULL,
	[UnitsOrdered] [numeric](5, 3) NULL,
	[ListPrice] [money] NULL,
	[DiscountPrice] [money] NULL,
	[OverridePrice] [money] NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_OrderItem_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_OrderItem] PRIMARY KEY CLUSTERED 
(
	[OrderItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_OrderItem_OrderId_CompanyPriceId] UNIQUE NONCLUSTERED 
(
	[OrderId] ASC,
	[CompanyPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderStatus]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrderStatus](
	[OrderStatusId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrderStatusDescription] [varchar](200) NOT NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_OrderStatus_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_OrderStatus] PRIMARY KEY CLUSTERED 
(
	[OrderStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ProductDescription] [varchar](200) NOT NULL,
	[ProductSKU] [varchar](50) NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Product_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Subsidiary]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Subsidiary](
	[SubsidiaryEntityId] [int] NOT NULL,
	[SUIT] [uniqueidentifier] NOT NULL,
	[CompanyEntityId] [int] NOT NULL,
	[Nickname] [varchar](200) NOT NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Subsidiary_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_Subsidiary] PRIMARY KEY CLUSTERED 
(
	[SubsidiaryEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_Subsidiary_SubsidiaryEntityId_SUIT] UNIQUE NONCLUSTERED 
(
	[SubsidiaryEntityId] ASC,
	[SUIT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SupplierProduct]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SupplierProduct](
	[SupplierProductId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SupplierEntityId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[UnitTypeId] [int] NOT NULL,
	[SupplierPricePerUnit] [money] NULL,
	[SupplierSKU] [varchar](50) NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_SupplierProduct_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_SupplierProduct] PRIMARY KEY CLUSTERED 
(
	[SupplierProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_SupplierProduct_SupplierEntityId_ProductId_UnitTypeId] UNIQUE NONCLUSTERED 
(
	[SupplierEntityId] ASC,
	[ProductId] ASC,
	[UnitTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Telephone]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Telephone](
	[TelephoneId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EntityId] [int] NOT NULL,
	[TelephoneTypeId] [int] NOT NULL,
	[TelephoneNumber] [varchar](20) NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Telephone_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_Telephone] PRIMARY KEY CLUSTERED 
(
	[TelephoneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_Telephone_EntityId_TelephoneTypeId] UNIQUE NONCLUSTERED 
(
	[EntityId] ASC,
	[TelephoneTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TelephoneType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TelephoneType](
	[TelephoneTypeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TelephoneTypeDescription] [varchar](200) NOT NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_TelephoneType_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_TelephoneType] PRIMARY KEY CLUSTERED 
(
	[TelephoneTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UnitType]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UnitType](
	[UnitTypeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UnitTypeDescription] [varchar](200) NOT NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_UnitType_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_UnitType] PRIMARY KEY CLUSTERED 
(
	[UnitTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[UserEntityId] [int] NOT NULL,
	[USIT] [uniqueidentifier] NOT NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[UserName] [varchar](50) NOT NULL,
	[FirstActiveDate] [date] NOT NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_User_isDeleted]  DEFAULT ((0)),
	[InsertDateTime] [datetime] NULL,
	[InsertUser] [int] NULL,
	[LastUpdateDateTime] [datetime] NULL,
	[LastUpdateUser] [int] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [XU_User_UserEntityId_USIT] UNIQUE NONCLUSTERED 
(
	[UserEntityId] ASC,
	[USIT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vwEntityAddress]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwEntityAddress]
AS
SELECT
	 et.EntityTypeDescription
	,CASE WHEN e.EntityTypeId = 1 THEN co.CompanyName --Company
		  WHEN e.EntityTypeId = 2 THEN s.Nickname --Subsidiary
		  WHEN e.EntityTypeId = 2 THEN c.FullName --Customer
		  WHEN e.EntityTypeId = 4 THEN u.UserName --User
		  END AS EntityName
	,at.AddressTypeDescription
	,a.AddressLine1
	,a.AddressLine2
	,a.City
	,a.PostalCode
	,a.Country
FROM dbo.[Address] a
JOIN dbo.Entity e
	ON a.EntityId = e.EntityId
	AND a.IsDeleted = 0
	AND e.IsDeleted = 0
JOIN dbo.EntityType et
	ON e.EntityTypeId = et.EntityTypeId
	AND et.IsDeleted = 0
JOIN dbo.AddressType at
	ON a.AddressTypeId = at.AddressTypeId
	AND at.IsDeleted = 0
LEFT JOIN dbo.Company co
	ON e.EntityId = co.CompanyEntityId
	AND e.EntityTypeId = 1 --Company
	AND co.IsDeleted = 0
LEFT JOIN dbo.Subsidiary s
	ON e.EntityId = s.SubsidiaryEntityId
	AND e.EntityTypeId = 2 --Subsidiary
	AND s.IsDeleted = 0
LEFT JOIN dbo.Customer c
	ON e.EntityId = c.CustomerEntityId
	AND e.EntityTypeId = 3 --Customer
	AND c.IsDeleted = 0
LEFT JOIN dbo.[User] u
	ON e.EntityId = u.UserEntityId
	AND e.EntityTypeId = 4 --User
	AND u.IsDeleted = 0




GO
/****** Object:  View [dbo].[vwEntityEmail]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwEntityEmail]
AS
SELECT
	 et.EntityTypeDescription
	,CASE WHEN e.EntityTypeId = 1 THEN co.CompanyName --Company
		  WHEN e.EntityTypeId = 2 THEN s.Nickname --Subsidiary
		  WHEN e.EntityTypeId = 2 THEN c.FullName --Customer
		  WHEN e.EntityTypeId = 4 THEN u.UserName --User
		  END AS EntityName
	,tt.EmailTypeDescription
	,t.Email
FROM dbo.Email t
JOIN dbo.Entity e
	ON t.EntityId = e.EntityId
	AND t.IsDeleted = 0
	AND e.IsDeleted = 0
JOIN dbo.EntityType et
	ON e.EntityTypeId = et.EntityTypeId
	AND et.IsDeleted = 0
JOIN dbo.EmailType tt
	ON t.EmailTypeId = tt.EmailTypeId
	AND tt.IsDeleted = 0
LEFT JOIN dbo.Company co
	ON e.EntityId = co.CompanyEntityId
	AND e.EntityTypeId = 1 --Company
	AND co.IsDeleted = 0
LEFT JOIN dbo.Subsidiary s
	ON e.EntityId = s.SubsidiaryEntityId
	AND e.EntityTypeId = 2 --Subsidiary
	AND s.IsDeleted = 0
LEFT JOIN dbo.Customer c
	ON e.EntityId = c.CustomerEntityId
	AND e.EntityTypeId = 3 --Customer
	AND c.IsDeleted = 0
LEFT JOIN dbo.[User] u
	ON e.EntityId = u.UserEntityId
	AND e.EntityTypeId = 4 --User
	AND u.IsDeleted = 0
GO
/****** Object:  View [dbo].[vwEntityTelephone]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwEntityTelephone]
AS
SELECT
	 et.EntityTypeDescription
	,CASE WHEN e.EntityTypeId = 1 THEN co.CompanyName --Company
		  WHEN e.EntityTypeId = 2 THEN s.Nickname --Subsidiary
		  WHEN e.EntityTypeId = 2 THEN c.FullName --Customer
		  WHEN e.EntityTypeId = 4 THEN u.UserName --User
		  END AS EntityName
	,tt.TelephoneTypeDescription
	,t.TelephoneNumber
FROM dbo.Telephone t
JOIN dbo.Entity e
	ON t.EntityId = e.EntityId
	AND t.IsDeleted = 0
	AND e.IsDeleted = 0
JOIN dbo.EntityType et
	ON e.EntityTypeId = et.EntityTypeId
	AND et.IsDeleted = 0
JOIN dbo.TelephoneType tt
	ON t.TelephoneTypeId = tt.TelephoneTypeId
	AND tt.IsDeleted = 0
LEFT JOIN dbo.Company co
	ON e.EntityId = co.CompanyEntityId
	AND e.EntityTypeId = 1 --Company
	AND co.IsDeleted = 0
LEFT JOIN dbo.Subsidiary s
	ON e.EntityId = s.SubsidiaryEntityId
	AND e.EntityTypeId = 2 --Subsidiary
	AND s.IsDeleted = 0
LEFT JOIN dbo.Customer c
	ON e.EntityId = c.CustomerEntityId
	AND e.EntityTypeId = 3 --Customer
	AND c.IsDeleted = 0
LEFT JOIN dbo.[User] u
	ON e.EntityId = u.UserEntityId
	AND e.EntityTypeId = 4 --User
	AND u.IsDeleted = 0


GO
/****** Object:  View [dbo].[vwOrderDetails]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwOrderDetails]
AS
SELECT
	 o.OrderId
	,c.FullName AS CustomerFullName
	,co.CompanyName
	,s.Nickname AS SubsidiaryNickName
	,o.OrderDate
	,a.AddressLine1
	,a.AddressLine2
	,a.City
	,a.[State]
	,a.PostalCode
	,a.Country
	,os.OrderStatusDescription
	,o.TotalPrice AS OrderTotalPrice
	,oi.OrderLineNumber
	,p.ProductDescription
	,oi.UnitsOrdered
	,oi.ListPrice
	,oi.DiscountPrice
	,oi.OverridePrice
FROM dbo.[Order] o
JOIN dbo.OrderItem oi
	ON o.OrderId = oi.OrderId
	AND o.IsDeleted = 0
	AND oi.IsDeleted = 0
JOIN dbo.OrderStatus os
	ON o.OrderStatusId = os.OrderStatusId
	AND os.IsDeleted = 0
JOIN dbo.Customer c
	ON o.CustomerEntityId = c.CustomerEntityId
	AND c.IsDeleted = 0
JOIN dbo.Subsidiary s
	ON o.SubsidiaryEntityId = s.SubsidiaryEntityId
	AND s.IsDeleted = 0
JOIN dbo.Company co
	ON s.CompanyEntityId = co.CompanyEntityId
	AND co.IsDeleted = 0
JOIN dbo.CompanyPrice cp
	ON oi.CompanyPriceId = cp.CompanyPriceId
	AND cp.IsDeleted = 0
JOIN dbo.SupplierProduct sp
	ON cp.SupplierProductId = sp.SupplierProductId
	AND sp.IsDeleted = 0
JOIN dbo.Product p
	ON sp.ProductId = p.ProductId
	AND p.IsDeleted = 0
LEFT JOIN dbo.[Address] a
	ON o.ShippingAddressId = a.AddressId
	AND a.IsDeleted = 0
GO

SET IDENTITY_INSERT [dbo].[Entity] ON 

GO

INSERT [dbo].[Entity] ([EntityId], [EntityTypeId], [EntityNativeId], [isDeleted], [InsertDateTime], [InsertUser], [LastUpdateDateTime], [LastUpdateUser]) VALUES (12, 3, N'b3dca355-ece7-40b7-8996-6ce25e2bdf27', 0, NULL, NULL, NULL, NULL)
GO

SET IDENTITY_INSERT [dbo].[Entity] OFF
GO

INSERT [dbo].[User] ([UserEntityId], [USIT], [LastName], [FirstName], [UserName], [FirstActiveDate], [isDeleted], [InsertDateTime], [InsertUser], [LastUpdateDateTime], [LastUpdateUser]) VALUES (14, N'dd1c0d5e-80d8-419c-8e95-064aa37ab5bb', N'User', N'Admin', N'AdminUser', CAST(N'2000-01-01' AS Date), 0, CAST(N'2018-01-11 13:58:59.813' AS DateTime), 14, CAST(N'2018-01-11 13:58:59.813' AS DateTime), 14)
GO

/****** Object:  Index [XNC_Address_AddressTypeId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Address_AddressTypeId] ON [dbo].[Address]
(
	[AddressTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [XNC_Address_EntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Address_EntityId] ON [dbo].[Address]
(
	[EntityId] ASC
)
INCLUDE ( 	[AddressTypeId],
	[AddressLine1],
	[AddressLine2],
	[City],
	[State],
	[PostalCode],
	[Country]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_Company_CompanyTypeId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Company_CompanyTypeId] ON [dbo].[Company]
(
	[CompanyTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_CompanyPrice_CompanyEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_CompanyPrice_CompanyEntityId] ON [dbo].[CompanyPrice]
(
	[CompanyEntityId] ASC
)
INCLUDE ( 	[SupplierProductId],
	[CompanyPricePerUnit]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_CompanyPrice_SupplierProductId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_CompanyPrice_SupplierProductId] ON [dbo].[CompanyPrice]
(
	[SupplierProductId] ASC
)
INCLUDE ( 	[CompanyEntityId],
	[CompanyPricePerUnit]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [XNC_Customer_COIT]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Customer_COIT] ON [dbo].[Customer]
(
	[COIT] ASC
)
INCLUDE ( 	[CustomerEntityId],
	[DocumentNumber],
	[DocumentTypeId],
	[FullName],
	[DateOfBirth],
	[DiscountPercent]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [XNC_Customer_CustomerEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Customer_CustomerEntityId] ON [dbo].[Customer]
(
	[CustomerEntityId] ASC
)
INCLUDE ( 	[COIT],
	[DocumentNumber],
	[DocumentTypeId],
	[FullName],
	[DateOfBirth],
	[DiscountPercent]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [XNC_Customer_DocumentNumber_DocumentTypeId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Customer_DocumentNumber_DocumentTypeId] ON [dbo].[Customer]
(
	[DocumentNumber] ASC,
	[DocumentTypeId] ASC
)
INCLUDE ( 	[CustomerEntityId],
	[COIT],
	[FullName],
	[DateOfBirth],
	[DiscountPercent]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [XNC_Customer_DocumentTypeId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Customer_DocumentTypeId] ON [dbo].[Customer]
(
	[DocumentTypeId] ASC
)
INCLUDE ( 	[DocumentNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_Order_CustomerEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Order_CustomerEntityId] ON [dbo].[Order]
(
	[CustomerEntityId] ASC
)
INCLUDE ( 	[OrderId],
	[SubsidiaryEntityId],
	[OrderDate],
	[TotalPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_Order_SubsidiaryEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Order_SubsidiaryEntityId] ON [dbo].[Order]
(
	[SubsidiaryEntityId] ASC
)
INCLUDE ( 	[OrderId],
	[CustomerEntityId],
	[OrderDate],
	[TotalPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_OrderItem_CompanyPriceId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_OrderItem_CompanyPriceId] ON [dbo].[OrderItem]
(
	[CompanyPriceId] ASC
)
INCLUDE ( 	[OrderId],
	[OrderLineNumber],
	[UnitsOrdered],
	[ListPrice],
	[DiscountPrice],
	[OverridePrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_OrderItem_OrderId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_OrderItem_OrderId] ON [dbo].[OrderItem]
(
	[OrderId] ASC
)
INCLUDE ( 	[CompanyPriceId],
	[OrderLineNumber],
	[UnitsOrdered],
	[ListPrice],
	[DiscountPrice],
	[OverridePrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_OrderItem_OrderId_CompanyPriceId_OrderLineNumber]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_OrderItem_OrderId_CompanyPriceId_OrderLineNumber] ON [dbo].[OrderItem]
(
	[OrderId] ASC,
	[CompanyPriceId] ASC,
	[OrderLineNumber] ASC
)
INCLUDE ( 	[UnitsOrdered],
	[ListPrice],
	[DiscountPrice],
	[OverridePrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_Subsidiary_CompanyEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Subsidiary_CompanyEntityId] ON [dbo].[Subsidiary]
(
	[CompanyEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_SupplierProduct_ProductId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_SupplierProduct_ProductId] ON [dbo].[SupplierProduct]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_SupplierProduct_SupplierEntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_SupplierProduct_SupplierEntityId] ON [dbo].[SupplierProduct]
(
	[SupplierEntityId] ASC
)
INCLUDE ( 	[ProductId],
	[UnitTypeId],
	[SupplierPricePerUnit]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_SupplierProduct_UnitTypeId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_SupplierProduct_UnitTypeId] ON [dbo].[SupplierProduct]
(
	[UnitTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [XNC_Telephone_EntityId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Telephone_EntityId] ON [dbo].[Telephone]
(
	[EntityId] ASC
)
INCLUDE ( 	[TelephoneTypeId],
	[TelephoneNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [XNC_Telephone_TelephoneTypeId]    Script Date: 1/14/2018 11:44:33 PM ******/
CREATE NONCLUSTERED INDEX [XNC_Telephone_TelephoneTypeId] ON [dbo].[Telephone]
(
	[TelephoneTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_AddressTypeId] FOREIGN KEY([AddressTypeId])
REFERENCES [dbo].[AddressType] ([AddressTypeId])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_AddressTypeId]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_EntityId] FOREIGN KEY([EntityId])
REFERENCES [dbo].[Entity] ([EntityId])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_EntityId]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_InsertUser]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_LastUpdateUser]
GO
ALTER TABLE [dbo].[AddressType]  WITH CHECK ADD  CONSTRAINT [FK_AddressType_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[AddressType] CHECK CONSTRAINT [FK_AddressType_InsertUser]
GO
ALTER TABLE [dbo].[AddressType]  WITH CHECK ADD  CONSTRAINT [FK_AddressType_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[AddressType] CHECK CONSTRAINT [FK_AddressType_LastUpdateUser]
GO
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_CompanyEntityId_CUIT] FOREIGN KEY([CompanyEntityId], [CUIT])
REFERENCES [dbo].[Entity] ([EntityId], [EntityNativeId])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_Company_CompanyEntityId_CUIT]
GO
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_CompanyTypeId] FOREIGN KEY([CompanyTypeId])
REFERENCES [dbo].[CompanyType] ([CompanyTypeId])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_Company_CompanyTypeId]
GO
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_Company_InsertUser]
GO
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_Company_LastUpdateUser]
GO
ALTER TABLE [dbo].[CompanyPrice]  WITH CHECK ADD  CONSTRAINT [FK_CompanyPrice_CompanyEntityId] FOREIGN KEY([CompanyEntityId])
REFERENCES [dbo].[Company] ([CompanyEntityId])
GO
ALTER TABLE [dbo].[CompanyPrice] CHECK CONSTRAINT [FK_CompanyPrice_CompanyEntityId]
GO
ALTER TABLE [dbo].[CompanyPrice]  WITH CHECK ADD  CONSTRAINT [FK_CompanyPrice_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[CompanyPrice] CHECK CONSTRAINT [FK_CompanyPrice_InsertUser]
GO
ALTER TABLE [dbo].[CompanyPrice]  WITH CHECK ADD  CONSTRAINT [FK_CompanyPrice_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[CompanyPrice] CHECK CONSTRAINT [FK_CompanyPrice_LastUpdateUser]
GO
ALTER TABLE [dbo].[CompanyPrice]  WITH CHECK ADD  CONSTRAINT [FK_CompanyPrice_SupplierProductId] FOREIGN KEY([SupplierProductId])
REFERENCES [dbo].[SupplierProduct] ([SupplierProductId])
GO
ALTER TABLE [dbo].[CompanyPrice] CHECK CONSTRAINT [FK_CompanyPrice_SupplierProductId]
GO
ALTER TABLE [dbo].[CompanyType]  WITH CHECK ADD  CONSTRAINT [FK_CompanyType_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[CompanyType] CHECK CONSTRAINT [FK_CompanyType_InsertUser]
GO
ALTER TABLE [dbo].[CompanyType]  WITH CHECK ADD  CONSTRAINT [FK_CompanyType_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[CompanyType] CHECK CONSTRAINT [FK_CompanyType_LastUpdateUser]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_CustomerEntityId_COIT] FOREIGN KEY([CustomerEntityId], [COIT])
REFERENCES [dbo].[Entity] ([EntityId], [EntityNativeId])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_CustomerEntityId_COIT]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_DocumentTypeId] FOREIGN KEY([DocumentTypeId])
REFERENCES [dbo].[DocumentType] ([DocumentTypeId])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_DocumentTypeId]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_InsertUser]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_LastUpdateUser]
GO
ALTER TABLE [dbo].[DocumentType]  WITH CHECK ADD  CONSTRAINT [FK_DocumentType_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[DocumentType] CHECK CONSTRAINT [FK_DocumentType_InsertUser]
GO
ALTER TABLE [dbo].[DocumentType]  WITH CHECK ADD  CONSTRAINT [FK_DocumentType_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[DocumentType] CHECK CONSTRAINT [FK_DocumentType_LastUpdateUser]
GO
ALTER TABLE [dbo].[Email]  WITH CHECK ADD  CONSTRAINT [FK_Email_EmailTypeId] FOREIGN KEY([EmailTypeId])
REFERENCES [dbo].[EmailType] ([EmailTypeId])
GO
ALTER TABLE [dbo].[Email] CHECK CONSTRAINT [FK_Email_EmailTypeId]
GO
ALTER TABLE [dbo].[Email]  WITH CHECK ADD  CONSTRAINT [FK_Email_EntityId] FOREIGN KEY([EntityId])
REFERENCES [dbo].[Entity] ([EntityId])
GO
ALTER TABLE [dbo].[Email] CHECK CONSTRAINT [FK_Email_EntityId]
GO
ALTER TABLE [dbo].[Email]  WITH CHECK ADD  CONSTRAINT [FK_Email_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Email] CHECK CONSTRAINT [FK_Email_InsertUser]
GO
ALTER TABLE [dbo].[Email]  WITH CHECK ADD  CONSTRAINT [FK_Email_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Email] CHECK CONSTRAINT [FK_Email_LastUpdateUser]
GO
ALTER TABLE [dbo].[EmailType]  WITH CHECK ADD  CONSTRAINT [FK_EmailType_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[EmailType] CHECK CONSTRAINT [FK_EmailType_InsertUser]
GO
ALTER TABLE [dbo].[EmailType]  WITH CHECK ADD  CONSTRAINT [FK_EmailType_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[EmailType] CHECK CONSTRAINT [FK_EmailType_LastUpdateUser]
GO
ALTER TABLE [dbo].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Entity_EntityTypeId] FOREIGN KEY([EntityTypeId])
REFERENCES [dbo].[EntityType] ([EntityTypeId])
GO
ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [FK_Entity_EntityTypeId]
GO
ALTER TABLE [dbo].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Entity_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [FK_Entity_InsertUser]
GO
ALTER TABLE [dbo].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Entity_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [FK_Entity_LastUpdateUser]
GO
ALTER TABLE [dbo].[EntityType]  WITH CHECK ADD  CONSTRAINT [FK_EntityType_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[EntityType] CHECK CONSTRAINT [FK_EntityType_InsertUser]
GO
ALTER TABLE [dbo].[EntityType]  WITH CHECK ADD  CONSTRAINT [FK_EntityType_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[EntityType] CHECK CONSTRAINT [FK_EntityType_LastUpdateUser]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_CustomerEntityId] FOREIGN KEY([CustomerEntityId])
REFERENCES [dbo].[Customer] ([CustomerEntityId])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_CustomerEntityId]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_InsertUser]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_LastUpdateUser]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_OrderStatusId] FOREIGN KEY([OrderStatusId])
REFERENCES [dbo].[OrderStatus] ([OrderStatusId])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_OrderStatusId]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_ShippingAddress] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([OrderId])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_ShippingAddress]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_ShippingAddressId] FOREIGN KEY([ShippingAddressId])
REFERENCES [dbo].[Address] ([AddressId])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_ShippingAddressId]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_SubsidiaryEntityId] FOREIGN KEY([SubsidiaryEntityId])
REFERENCES [dbo].[Subsidiary] ([SubsidiaryEntityId])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_SubsidiaryEntityId]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_CompanyPriceId] FOREIGN KEY([CompanyPriceId])
REFERENCES [dbo].[CompanyPrice] ([CompanyPriceId])
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_CompanyPriceId]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_InsertUser]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_LastUpdateUser]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([OrderId])
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_OrderId]
GO
ALTER TABLE [dbo].[OrderStatus]  WITH CHECK ADD  CONSTRAINT [FK_OrderStatus_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[OrderStatus] CHECK CONSTRAINT [FK_OrderStatus_InsertUser]
GO
ALTER TABLE [dbo].[OrderStatus]  WITH CHECK ADD  CONSTRAINT [FK_OrderStatus_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[OrderStatus] CHECK CONSTRAINT [FK_OrderStatus_LastUpdateUser]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_InsertUser]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_LastUpdateUser]
GO
ALTER TABLE [dbo].[Subsidiary]  WITH CHECK ADD  CONSTRAINT [FK_Subsidiary_CompanyEntityId] FOREIGN KEY([CompanyEntityId])
REFERENCES [dbo].[Company] ([CompanyEntityId])
GO
ALTER TABLE [dbo].[Subsidiary] CHECK CONSTRAINT [FK_Subsidiary_CompanyEntityId]
GO
ALTER TABLE [dbo].[Subsidiary]  WITH CHECK ADD  CONSTRAINT [FK_Subsidiary_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Subsidiary] CHECK CONSTRAINT [FK_Subsidiary_InsertUser]
GO
ALTER TABLE [dbo].[Subsidiary]  WITH CHECK ADD  CONSTRAINT [FK_Subsidiary_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Subsidiary] CHECK CONSTRAINT [FK_Subsidiary_LastUpdateUser]
GO
ALTER TABLE [dbo].[Subsidiary]  WITH CHECK ADD  CONSTRAINT [FK_Subsidiary_SubsidiaryEntityId_SUIT] FOREIGN KEY([SubsidiaryEntityId], [SUIT])
REFERENCES [dbo].[Entity] ([EntityId], [EntityNativeId])
GO
ALTER TABLE [dbo].[Subsidiary] CHECK CONSTRAINT [FK_Subsidiary_SubsidiaryEntityId_SUIT]
GO
ALTER TABLE [dbo].[SupplierProduct]  WITH CHECK ADD  CONSTRAINT [FK_SupplierProduct_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[SupplierProduct] CHECK CONSTRAINT [FK_SupplierProduct_InsertUser]
GO
ALTER TABLE [dbo].[SupplierProduct]  WITH CHECK ADD  CONSTRAINT [FK_SupplierProduct_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[SupplierProduct] CHECK CONSTRAINT [FK_SupplierProduct_LastUpdateUser]
GO
ALTER TABLE [dbo].[SupplierProduct]  WITH CHECK ADD  CONSTRAINT [FK_SupplierProduct_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
GO
ALTER TABLE [dbo].[SupplierProduct] CHECK CONSTRAINT [FK_SupplierProduct_ProductId]
GO
ALTER TABLE [dbo].[SupplierProduct]  WITH CHECK ADD  CONSTRAINT [FK_SupplierProduct_SupplierEntityId] FOREIGN KEY([SupplierEntityId])
REFERENCES [dbo].[Entity] ([EntityId])
GO
ALTER TABLE [dbo].[SupplierProduct] CHECK CONSTRAINT [FK_SupplierProduct_SupplierEntityId]
GO
ALTER TABLE [dbo].[SupplierProduct]  WITH CHECK ADD  CONSTRAINT [FK_SupplierProduct_UnitTypeId] FOREIGN KEY([UnitTypeId])
REFERENCES [dbo].[UnitType] ([UnitTypeId])
GO
ALTER TABLE [dbo].[SupplierProduct] CHECK CONSTRAINT [FK_SupplierProduct_UnitTypeId]
GO
ALTER TABLE [dbo].[Telephone]  WITH CHECK ADD  CONSTRAINT [FK_Telephone_EntityId] FOREIGN KEY([EntityId])
REFERENCES [dbo].[Entity] ([EntityId])
GO
ALTER TABLE [dbo].[Telephone] CHECK CONSTRAINT [FK_Telephone_EntityId]
GO
ALTER TABLE [dbo].[Telephone]  WITH CHECK ADD  CONSTRAINT [FK_Telephone_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Telephone] CHECK CONSTRAINT [FK_Telephone_InsertUser]
GO
ALTER TABLE [dbo].[Telephone]  WITH CHECK ADD  CONSTRAINT [FK_Telephone_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[Telephone] CHECK CONSTRAINT [FK_Telephone_LastUpdateUser]
GO
ALTER TABLE [dbo].[Telephone]  WITH CHECK ADD  CONSTRAINT [FK_Telephone_TelephoneTypeId] FOREIGN KEY([TelephoneTypeId])
REFERENCES [dbo].[TelephoneType] ([TelephoneTypeId])
GO
ALTER TABLE [dbo].[Telephone] CHECK CONSTRAINT [FK_Telephone_TelephoneTypeId]
GO
ALTER TABLE [dbo].[TelephoneType]  WITH CHECK ADD  CONSTRAINT [FK_TelephoneType_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[TelephoneType] CHECK CONSTRAINT [FK_TelephoneType_InsertUser]
GO
ALTER TABLE [dbo].[TelephoneType]  WITH CHECK ADD  CONSTRAINT [FK_TelephoneType_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[TelephoneType] CHECK CONSTRAINT [FK_TelephoneType_LastUpdateUser]
GO
ALTER TABLE [dbo].[UnitType]  WITH CHECK ADD  CONSTRAINT [FK_UnitType_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[UnitType] CHECK CONSTRAINT [FK_UnitType_InsertUser]
GO
ALTER TABLE [dbo].[UnitType]  WITH CHECK ADD  CONSTRAINT [FK_UnitType_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[UnitType] CHECK CONSTRAINT [FK_UnitType_LastUpdateUser]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_InsertUser] FOREIGN KEY([InsertUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_InsertUser]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_LastUpdateUser] FOREIGN KEY([LastUpdateUser])
REFERENCES [dbo].[User] ([UserEntityId])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_LastUpdateUser]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserEntityId_USIT] FOREIGN KEY([UserEntityId], [USIT])
REFERENCES [dbo].[Entity] ([EntityId], [EntityNativeId])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserEntityId_USIT]
GO
/****** Object:  Trigger [dbo].[Address_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[Address_TD] 
   ON  [dbo].[Address]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[Address] a
	JOIN Deleted d
		ON a.AddressId = d.AddressId

 
END

GO
/****** Object:  Trigger [dbo].[AddressType_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[AddressType_TD] 
   ON  [dbo].[AddressType]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[AddressType] a
	JOIN Deleted d
		ON a.AddressTypeId = d.AddressTypeId

 
END

GO
/****** Object:  Trigger [dbo].[Company_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[Company_TD] 
   ON  [dbo].[Company]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[Company] a
	JOIN Deleted d
		ON a.CompanyEntityId = d.CompanyEntityId

 
END

GO
/****** Object:  Trigger [dbo].[Company_TI]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Insert Trigger on dbo.Company first inserts the record into dbo.Entity, then uses the EntityId generated there to complete the insert to dbo.Company.
-- =============================================
CREATE TRIGGER [dbo].[Company_TI] 
   ON  [dbo].[Company]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	--Look up the proper EntityTypeId to insert record to dbo.Entity
	DECLARE  @entityType INT = (SELECT EntityTypeId FROM dbo.EntityType WHERE EntityTypeDescription = 'Company')

	--Create temp table for working with the records and their ids
	CREATE TABLE #ids
		(
		 CUIT UNIQUEIDENTIFIER NOT NULL
		,CompanyEntityId INT
		,CompanyTypeId INT
		,CompanyName VARCHAR(1000)
		,ActivityStartDate DATETIME
		,Website VARCHAR(2000)
		,IsDeleted BIT
		,InsertUser INT
		,InsertDateTime DATETIME
		)

	--Index the temp table to maximize performance
	CREATE CLUSTERED INDEX #ids_CUIT ON #ids(CUIT)

	--Populate the temp table with the values inserted
	INSERT #ids (CUIT, CompanyTypeId, CompanyName, ActivityStartDate, Website, IsDeleted, InsertUser, InsertDateTime)
	SELECT CUIT, CompanyTypeId, CompanyName, ActivityStartDate, Website, IsDeleted, InsertUser, InsertDateTime
	FROM Inserted

	--For any missing or invalid GUID's, generate new values
	UPDATE #ids
	SET CUIT = NEWID()
	WHERE ISNULL(CUIT, '00000000-0000-0000-0000-000000000000') = '00000000-0000-0000-0000-000000000000'

	--Populate dbo.Entity with the GUID and EntityTypeId
	INSERT dbo.Entity(EntityTypeId, EntityNativeId)
	SELECT @entityType, CUIT
	FROM #ids

	--Update the temp table with the newly created EntityTypeId values
	UPDATE i
	SET i.CompanyEntityID = e.EntityId
	FROM #ids i	
	JOIN dbo.Entity e
		ON i.CUIT = e.EntityNativeId

	--Finally, insert the records into dbo.Company with CompanyEntityId populated from dbo.Entity
	INSERT dbo.Company(CompanyEntityID, CUIT, CompanyTypeId, CompanyName, ActivityStartDate, Website, isDeleted, InsertUser, InsertDateTime)
	SELECT CompanyEntityId, CUIT, CompanyTypeId, CompanyName, ActivityStartDate, Website, isDeleted, InsertUser, InsertDateTime
	FROM #ids

	DROP TABLE #ids

 
END

GO
/****** Object:  Trigger [dbo].[CompanyPrice_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[CompanyPrice_TD] 
   ON  [dbo].[CompanyPrice]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[CompanyPrice] a
	JOIN Deleted d
		ON a.CompanyPriceId = d.CompanyPriceId

 
END

GO
/****** Object:  Trigger [dbo].[CompanyType_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[CompanyType_TD] 
   ON  [dbo].[CompanyType]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[CompanyType] a
	JOIN Deleted d
		ON a.CompanyTypeId = d.CompanyTypeId

 
END

GO
/****** Object:  Trigger [dbo].[Customer_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[Customer_TD] 
   ON  [dbo].[Customer]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test Customer for this demonstration
	FROM dbo.[Customer] a
	JOIN Deleted d
		ON a.CustomerEntityId = d.CustomerEntityId

 
END

GO
/****** Object:  Trigger [dbo].[Customer_TI]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Insert Trigger on dbo.Customer first inserts the record into dbo.Entity, then uses the EntityId generated there to complete the insert to dbo.Customer.
-- =============================================
CREATE TRIGGER [dbo].[Customer_TI] 
   ON  [dbo].[Customer]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	--Look up the proper EntityTypeId to insert record to dbo.Entity
	DECLARE  @entityType INT = (SELECT EntityTypeId FROM dbo.EntityType WHERE EntityTypeDescription = 'Customer')

	--Create temp table for working with the records and their ids
	CREATE TABLE #ids
		(
		 CustomerEntityID INT
		,COIT UNIQUEIDENTIFIER NOT NULL
		,DocumentNumber VARCHAR(200)
		,DocumentTypeId INT
		,FullName VARCHAR(200)
		,DateOfBirth DATE
		,DiscountPercent NUMERIC(5,3)
		,IsDeleted BIT
		,InsertUser INT
		,InsertDateTime DATETIME
		)

	--Index the temp table to maximize performance
	CREATE CLUSTERED INDEX #ids_COIT ON #ids(COIT)

	--Populate the temp table with the values inserted
	INSERT #ids
		(
		 COIT
		,DocumentNumber
		,DocumentTypeId
		,FullName
		,DateOfBirth
		,DiscountPercent
		,IsDeleted
		,InsertUser
		,InsertDateTime
		)
	SELECT
		 COIT
		,DocumentNumber
		,DocumentTypeId
		,FullName
		,DateOfBirth
		,DiscountPercent
		,IsDeleted
		,InsertUser
		,InsertDateTime
	FROM Inserted

	--For any missing or invalid GUID's, generate new values
	UPDATE #ids
	SET COIT = NEWID()
	WHERE ISNULL(COIT, '00000000-0000-0000-0000-000000000000') = '00000000-0000-0000-0000-000000000000'

	--Populate dbo.Entity with the GUID and EntityTypeId
	INSERT dbo.Entity(EntityTypeId, EntityNativeId)
	SELECT @entityType, COIT
	FROM #ids

	--Update the temp table with the newly created EntityTypeId values
	UPDATE i
	SET i.CustomerEntityID = e.EntityId
	FROM #ids i
	JOIN dbo.Entity e
		ON i.COIT = e.EntityNativeId

	--Finally, insert the records into dbo.Customer with CustomerEntityId populated from dbo.Entity
	INSERT dbo.Customer(CustomerEntityID, COIT, DocumentNumber, DocumentTypeId, FullName, DateOfBirth, DiscountPercent, isDeleted, InsertUser, InsertDateTime)
	SELECT CustomerEntityId, COIT, DocumentNumber, DocumentTypeId, FullName, DateOfBirth, DiscountPercent, IsDeleted, InsertUser, InsertDateTime
	FROM #ids

	DROP TABLE #ids

 
END

GO
/****** Object:  Trigger [dbo].[DocumentType_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[DocumentType_TD] 
   ON  [dbo].[DocumentType]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[DocumentType] a
	JOIN Deleted d
		ON a.DocumentTypeId = d.DocumentTypeId

 
END

GO
/****** Object:  Trigger [dbo].[Entity_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[Entity_TD] 
   ON  [dbo].[Entity]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[Entity] a
	JOIN Deleted d
		ON a.EntityId = d.EntityId

 
END

GO
/****** Object:  Trigger [dbo].[EntityType_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[EntityType_TD] 
   ON  [dbo].[EntityType]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[EntityType] a
	JOIN Deleted d
		ON a.EntityTypeId = d.EntityTypeId

 
END

GO
/****** Object:  Trigger [dbo].[Order_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[Order_TD] 
   ON  [dbo].[Order]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[Order] a
	JOIN Deleted d
		ON a.OrderId = d.OrderId

 
END

GO
/****** Object:  Trigger [dbo].[OrderItem_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[OrderItem_TD] 
   ON  [dbo].[OrderItem]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[OrderItem] a
	JOIN Deleted d
		ON a.OrderItemId = d.OrderItemId

 
END

GO
/****** Object:  Trigger [dbo].[OrderItem_TIU]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	After Insert, Update Trigger on dbo.OrderItem updates the order total on dbo.Order.
-- =============================================
CREATE TRIGGER [dbo].[OrderItem_TIU]
   ON  [dbo].[OrderItem]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @OrderId INT

	SELECT @OrderId = OrderId FROM Inserted

	UPDATE dbo.[Order] 
	SET TotalPrice = dbo.GetOrderTotal(OrderId)

 
END

GO
/****** Object:  Trigger [dbo].[OrderStatus_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[OrderStatus_TD] 
   ON  [dbo].[OrderStatus]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[OrderStatus] a
	JOIN Deleted d
		ON a.OrderStatusId = d.OrderStatusId

 
END

GO
/****** Object:  Trigger [dbo].[Product_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[Product_TD] 
   ON  [dbo].[Product]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[Product] a
	JOIN Deleted d
		ON a.ProductId = d.ProductId

 
END

GO
/****** Object:  Trigger [dbo].[Subsidiary_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[Subsidiary_TD] 
   ON  [dbo].[Subsidiary]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test Subsidiary for this demonstration
	FROM dbo.[Subsidiary] a
	JOIN Deleted d
		ON a.SubsidiaryEntityId = d.SubsidiaryEntityId

 
END

GO
/****** Object:  Trigger [dbo].[Subsidiary_TI]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Insert Trigger on dbo.Subsidiary first inserts the record into dbo.Entity, then uses the EntityId generated there to complete the insert to dbo.Subsidiary.
-- =============================================
CREATE TRIGGER [dbo].[Subsidiary_TI] 
   ON  [dbo].[Subsidiary]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	--Look up the proper EntityTypeId to insert record to dbo.Entity
	DECLARE  @entityType INT = (SELECT EntityTypeId FROM dbo.EntityType WHERE EntityTypeDescription = 'Subsidiary')

	--Create temp table for working with the records and their ids
	CREATE TABLE #ids
		(
		 SUIT UNIQUEIDENTIFIER NOT NULL
		,EntityId INT NULL
		,CompanyEntityId INT
		,Nickname VARCHAR(200)
		,IsDeleted BIT
		,InsertUser INT
		,InsertDateTime DATETIME
		)

	--Index the temp table to maximize performance
	CREATE CLUSTERED INDEX #ids_SUIT ON #ids(SUIT)

	--Populate the temp table with the values inserted
	INSERT #ids (SUIT, CompanyEntityId, Nickname, IsDeleted, InsertUser, InsertDateTime)
	SELECT SUIT, CompanyEntityId, Nickname, IsDeleted, InsertUser, InsertDateTime
	FROM Inserted

	--For any missing or invalid GUID's, generate new values
	UPDATE #ids
	SET SUIT = NEWID()
	WHERE ISNULL(SUIT, '00000000-0000-0000-0000-000000000000') = '00000000-0000-0000-0000-000000000000'

	--Populate dbo.Entity with the GUID and EntityTypeId
	INSERT dbo.Entity(EntityTypeId, EntityNativeId)
	SELECT @entityType, SUIT
	FROM #ids

	--Update the temp table with the newly created EntityTypeId values
	UPDATE i
	SET i.EntityID = e.EntityID
	FROM #ids i
	JOIN dbo.Entity e
		ON i.SUIT = e.EntityNativeId

	--Finally, insert the records into dbo.Customer with CustomerEntityId populated from dbo.Entity
	INSERT dbo.Subsidiary(SubsidiaryEntityID, SUIT, CompanyEntityId, Nickname, IsDeleted, InsertUser, InsertDateTime)
	SELECT EntityId, SUIT, CompanyEntityId, Nickname, IsDeleted, InsertUser, InsertDateTime
	FROM #ids

	DROP TABLE #ids

 
END

GO
/****** Object:  Trigger [dbo].[SupplierProduct_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[SupplierProduct_TD] 
   ON  [dbo].[SupplierProduct]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[SupplierProduct] a
	JOIN Deleted d
		ON a.SupplierProductId = d.SupplierProductId

 
END

GO
/****** Object:  Trigger [dbo].[Telephone_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[Telephone_TD] 
   ON  [dbo].[Telephone]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test Telephone for this demonstration
	FROM dbo.[Telephone] a
	JOIN Deleted d
		ON a.TelephoneId = d.TelephoneId

 
END

GO
/****** Object:  Trigger [dbo].[TelephoneType_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[TelephoneType_TD] 
   ON  [dbo].[TelephoneType]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[TelephoneType] a
	JOIN Deleted d
		ON a.TelephoneTypeId = d.TelephoneTypeId

 
END

GO
/****** Object:  Trigger [dbo].[UnitType_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[UnitType_TD] 
   ON  [dbo].[UnitType]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[UnitType] a
	JOIN Deleted d
		ON a.UnitTypeId = d.UnitTypeId

 
END

GO
/****** Object:  Trigger [dbo].[User_TD]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Delete Trigger on all tables enforces a soft delete, rather than a hard record delete.
-- =============================================
CREATE TRIGGER [dbo].[User_TD] 
   ON  [dbo].[User]
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	--Instead of delete, update IsDeleted = 1 and set the LastModifiedDateTime to the current date and time.
	UPDATE a
	SET a.isDeleted = 1, a.LastUpdateDateTime = GETDATE(), a.LastUpdateUser = 14 --Test User for this demonstration
	FROM dbo.[User] a
	JOIN Deleted d
		ON a.UserEntityId = d.UserEntityId

 
END

GO
/****** Object:  Trigger [dbo].[User_TI]    Script Date: 1/14/2018 11:44:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Doug Perez
-- Create date: 1/8/2018
-- Description:	Instead of Insert Trigger on dbo.User first inserts the record into dbo.Entity, then uses the EntityId generated there to complete the insert to dbo.User.
-- =============================================
CREATE TRIGGER [dbo].[User_TI] 
   ON  [dbo].[User]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	--Look up the proper EntityTypeId to insert record to dbo.Entity
	DECLARE  @entityType INT = (SELECT EntityTypeId FROM dbo.EntityType WHERE EntityTypeDescription = 'User')

	--Create temp table for working with the records and their ids
	CREATE TABLE #ids
		(
		 UserEntityID INT
		,USIT UNIQUEIDENTIFIER NOT NULL
		,LastName VARCHAR(100)
		,FirstName VARCHAR(100)
		,UserName VARCHAR(50)
		,FirstActiveDate DATETIME
		,IsDeleted BIT
		,InsertDateTime DATETIME
		,InsertUser INT
		)

	--Index the temp table to maximize performance
	CREATE CLUSTERED INDEX #ids_USIT ON #ids(USIT)

	--Populate the temp table with the values inserted
	INSERT #ids
		(
		 USIT
		,LastName
		,FirstName
		,UserName
		,FirstActiveDate
		,IsDeleted
		,InsertDateTime
		,InsertUser
		)
	SELECT
		 USIT
		,LastName
		,FirstName
		,UserName
		,FirstActiveDate
		,IsDeleted
		,InsertDateTime
		,InsertUser
	FROM Inserted

	--For any missing or invalid GUID's, generate new values
	UPDATE #ids
	SET USIT = NEWID()
	WHERE ISNULL(USIT, '00000000-0000-0000-0000-000000000000') = '00000000-0000-0000-0000-000000000000'

	--Populate dbo.Entity with the GUID and EntityTypeId
	INSERT dbo.Entity(EntityTypeId, EntityNativeId)
	SELECT @entityType, USIT
	FROM #ids

	--Update the temp table with the newly created EntityTypeId values
	UPDATE i
	SET i.UserEntityID = e.EntityId
	FROM #ids i
	JOIN dbo.Entity e
		ON i.USIT = e.EntityNativeId

	--Finally, insert the records into dbo.User with UserEntityId populated from dbo.Entity
	INSERT dbo.[User](UserEntityID, USIT, LastName, FirstName, UserName, FirstActiveDate, isDeleted, InsertDateTime, InsertUser)
	SELECT UserEntityID, USIT, LastName, FirstName, UserName, FirstActiveDate, isDeleted, InsertDateTime, InsertUser
	FROM #ids

	DROP TABLE #ids

 
END

GO
USE [master]
GO
ALTER DATABASE [B2BDBMSProject] SET  READ_WRITE 
GO
