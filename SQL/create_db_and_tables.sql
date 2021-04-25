CREATE DATABASE [KONTACTO]
GO

USE [KONTACTO]
GO

CREATE TABLE [ADDRESS_COUNTRY]
(
	[ID] CHAR (36) UNIQUE NOT NULL,
	[CODE] VARCHAR (3) UNIQUE NOT NULL,
	[NAME] VARCHAR (50) UNIQUE NOT NULL,
	PRIMARY KEY ([ID])
)
GO

CREATE TABLE [ADDRESS_CITY]
(
	[ID] CHAR (36) UNIQUE NOT NULL,
	[NAME] VARCHAR (50) NOT NULL,
	[COUNTRY_ID] CHAR (36) NOT NULL,
	PRIMARY KEY ([ID]),
	CONSTRAINT FK_COUNTRY FOREIGN KEY ([COUNTRY_ID]) REFERENCES [ADDRESS_COUNTRY] ([ID])
)
GO

CREATE TABLE [ADDRESS]
(
	[ID] CHAR (36) UNIQUE NOT NULL,
	[ADDRESS] VARCHAR (100) NOT NULL,
	[SECOND_ADDRESS] VARCHAR (100) NULL,
	[LATITUDE] DECIMAL(17, 15) NOT NULL,
	[LONGITUDE] DECIMAL(18, 15) NOT NULL,
	[CITY_ID] CHAR (36) NOT NULL,
	PRIMARY KEY ([ID]),
	CONSTRAINT FK_CITY FOREIGN KEY ([CITY_ID]) REFERENCES [ADDRESS_CITY] ([ID]),
	CONSTRAINT CHK_ADDRESS_LATITUDE CHECK ([LATITUDE] <= 90.000000000000001 AND [LATITUDE] >= -90.000000000000001),
	CONSTRAINT CHK_ADDRESS_LONGITUDE CHECK ([LONGITUDE] <= 180.000000000000001 AND [LONGITUDE] >= -180.000000000000001)
)
GO

CREATE TABLE [USER_TYPE]
(
	[ID] CHAR (36) UNIQUE NOT NULL,
	[TYPE] VARCHAR (25) NOT NULL,
	PRIMARY KEY ([ID])
)
GO

CREATE TABLE [USER_STATUS]
(
	[ID] CHAR (36) NOT NULL,
	[STATUS] VARCHAR (25) NOT NULL,
	PRIMARY KEY ([ID])
)
GO

CREATE TABLE [USER]
(
	[ID] CHAR (36) UNIQUE NOT NULL,
	[IMAGE] VARCHAR (MAX) NULL,
	[USERNAME] VARCHAR (25) UNIQUE NOT NULL,
	[NICKNAME] VARCHAR (25) NULL,
	[PRINCIPAL_EMAIL] VARCHAR (50) UNIQUE NOT NULL,
	[PASSWORD] CHAR (64) NOT NULL,
	[USER_TYPE_ID] CHAR (36) NOT NULL,
	[USER_STATUS_ID] CHAR (36) NOT NULL,
	[ADDRESS_ID] CHAR (36) NOT NULL,
	[CREATED_AT] DATETIME CONSTRAINT CHK_USER_CREATED_AT DEFAULT GETUTCDATE() NOT NULL,
	[LAST_UPADE] DATETIME NOT NULL,
	PRIMARY KEY ([ID]),
	CONSTRAINT FK_USER_TYPE FOREIGN KEY ([USER_TYPE_ID]) REFERENCES [USER_TYPE] ([ID]),
	CONSTRAINT FK_USER_STATUS FOREIGN KEY ([USER_STATUS_ID]) REFERENCES [USER_STATUS] ([ID]),
	CONSTRAINT FK_ADDRESS FOREIGN KEY ([ADDRESS_ID]) REFERENCES [ADDRESS] ([ID]),
	CONSTRAINT CHK_PRINCIPAL_EMAIL CHECK ([PRINCIPAL_EMAIL] LIKE '%_@__%.__%' AND PATINDEX('%[^a-z,0-9,@,.,_,\-]%', [PRINCIPAL_EMAIL]) = 0
	AND [PRINCIPAL_EMAIL] NOT LIKE '%@%@%' AND [PRINCIPAL_EMAIL] NOT LIKE '%..%')
)
GO

CREATE TABLE [BUSINESS_USER]
(
	[USER_ID] CHAR (36) UNIQUE NOT NULL,
	[NAME] VARCHAR (100) NOT NULL,
	[ANNIVERSARY_DATE] DATE NOT NULL,
	PRIMARY KEY ([USER_ID]),
	CONSTRAINT FK_BUSINESS_USER FOREIGN KEY ([USER_ID]) REFERENCES [USER] ([ID])
)
GO

CREATE TABLE [PRIVATE_USER]
(
	[USER_ID] CHAR (36) UNIQUE NOT NULL,
	[FIRST_NAME] VARCHAR (25) NOT NULL,
	[SECOND_NAME] VARCHAR (25) NULL,
	[FIRST_SURNAME] VARCHAR (25) NOT NULL,
	[SECOND_SURNAME] VARCHAR (25) NULL,
	[BUSINESS_ID] CHAR (36) NULL,
	[IS_WORKING] BIT DEFAULT 0 NULL, /*0 = NOT, 1 = YES*/
	[OCUPATION] VARCHAR (256) NULL,
	[BIRTH_DATE] DATE NOT NULL,
	PRIMARY KEY ([USER_ID]),
	CONSTRAINT FK_PRIVATE_USER FOREIGN KEY ([USER_ID]) REFERENCES [USER] ([ID]),
	CONSTRAINT FK_WORK FOREIGN KEY ([BUSINESS_ID]) REFERENCES [BUSINESS_USER] ([USER_ID])
)
GO

CREATE TABLE [USER_PHONE]
(
	[ID] CHAR (36) NOT NULL,
	[PHONE] VARCHAR (15) UNIQUE NOT NULL,
	[USER_ID] CHAR (36) NOT NULL,
	PRIMARY KEY ([ID]),
	CONSTRAINT FK_USER_PHONE FOREIGN KEY ([USER_ID]) REFERENCES [USER] ([ID])
)
GO

CREATE TABLE [USER_EMAIL]
(
	[ID] CHAR (36) NOT NULL,
	[EMAIL] VARCHAR (50) UNIQUE NOT NULL,
	[USER_ID] CHAR (36) NOT NULL,
	PRIMARY KEY ([ID]),
	CONSTRAINT FK_USER_EMAIL FOREIGN KEY (USER_ID) REFERENCES [USER] ([ID]),
	CONSTRAINT CHK_USER_EMAIL CHECK ([EMAIL] LIKE '%_@__%.__%' AND PATINDEX('%[^a-z,0-9,@,.,_,\-]%', [EMAIL]) = 0
	AND [EMAIL] NOT LIKE '%@%@%' AND [EMAIL] NOT LIKE '%..%')
)
GO

CREATE TABLE [CONTACT_STATUS]
(
	[ID] CHAR (36) NOT NULL,
	[STATUS] VARCHAR (25) NOT NULL,
	PRIMARY KEY ([ID])
)
GO

CREATE TABLE [CONTACT_RELATIONSHIP]
(
	[ID] CHAR (36) NOT NULL,
	[RELATIONSHIP] VARCHAR (50) NOT NULL,
	PRIMARY KEY ([ID])
)
GO

CREATE TABLE [CONTACT]
(
	[CONTACT_ID] CHAR (36) NOT NULL,
	[USER_ID] CHAR (36) NOT NULL,
	[CREATED_AT] DATETIME CONSTRAINT CHK_CONTACT_CREATED_AT DEFAULT GETUTCDATE() NOT NULL,
	[NICKNAME] VARCHAR (25) NULL,
	[IS_FAVORITE] BIT DEFAULT 0 NULL, /*0 = NOT, 1 = YES*/
	[CONTACT_STATUS_ID] CHAR (36) NOT NULL,
	[CONTACT_RELATIONSHIP_ID] CHAR (36) NOT NULL,
	CONSTRAINT PK_USER_CONTACT PRIMARY KEY ([CONTACT_ID], [USER_ID]),
	CONSTRAINT FK_CONTACTER FOREIGN KEY ([USER_ID]) REFERENCES [USER] ([ID]),
	CONSTRAINT FK_CONTACT FOREIGN KEY ([CONTACT_ID]) REFERENCES [USER] ([ID]),
	CONSTRAINT FK_CONTACT_STATUS FOREIGN KEY ([CONTACT_STATUS_ID]) REFERENCES [CONTACT_STATUS] ([ID]),
	CONSTRAINT FK_CONTACT_RELATIONSHIP FOREIGN KEY ([CONTACT_RELATIONSHIP_ID]) REFERENCES [CONTACT_RELATIONSHIP] ([ID]),
	CONSTRAINT CHK_USER_NOT_CONTACT CHECK ([USER_ID] != [CONTACT_ID])
)
GO

CREATE TABLE [SOCIAL_MEDIA]
(
	[ID] CHAR (36) NOT NULL,
	[NAME] VARCHAR (50) UNIQUE NOT NULL,
	[URL] VARCHAR (250) UNIQUE NOT NULL,
	PRIMARY KEY ([ID])
)
GO

CREATE TABLE [USER_SOCIAL_MEDIA]
(
	[SOCIAL_MEDIA_ID] CHAR (36) NOT NULL,
	[USER_ID] CHAR (36) NOT NULL,
	[USERNAME] VARCHAR (25) NOT NULL,
	CONSTRAINT PK_USER_SOCIAL_MEDIA_NICKNAME PRIMARY KEY ([SOCIAL_MEDIA_ID], [USERNAME]),
	CONSTRAINT FK_USER FOREIGN KEY ([USER_ID]) REFERENCES [USER] ([ID]),
	CONSTRAINT FK_SOCIAL_MEDIA FOREIGN KEY ([SOCIAL_MEDIA_ID]) REFERENCES [SOCIAL_MEDIA] ([ID])
)
GO

CREATE TABLE [NOTIFICATION_TYPE]
(
    [ID] CHAR (36) NOT NULL,
	[TYPE] VARCHAR (25) UNIQUE NOT NULL,
    [MESSAGE] VARCHAR (50) UNIQUE NOT NULL,
	PRIMARY KEY ([ID])
)
GO

CREATE TABLE [NOTIFICATION_STATUS]
(
	[ID] CHAR (36) NOT NULL,
	[STATUS] VARCHAR (25) NOT NULL,
	PRIMARY KEY ([ID])
)
GO

CREATE TABLE [NOTIFICATION]
(
	[ID] CHAR (36) NOT NULL,
	[NOTIFICATION_TYPE_ID] CHAR (36) NOT NULL,
	[NOTIFICATION_STATUS_ID] CHAR (36) NOT NULL,
	[SENDER_ID] CHAR (36) NOT NULL,
	[RECEPTOR_ID] CHAR (36) NOT NULL,
	[CREATED_AT] DATETIME CONSTRAINT CHK_NOTIFICATION_CREATED_AT DEFAULT GETUTCDATE() NOT NULL,
	PRIMARY KEY ([ID]),
	CONSTRAINT FK_USER_SENDER FOREIGN KEY ([SENDER_ID]) REFERENCES [USER] ([ID]),
	CONSTRAINT FK_USER_RECEPTOR FOREIGN KEY (RECEPTOR_ID) REFERENCES [USER] ([ID]),
	CONSTRAINT FK_NOTIFICATION_TYPE FOREIGN KEY ([NOTIFICATION_TYPE_ID]) REFERENCES [NOTIFICATION_TYPE] ([ID]),
	CONSTRAINT FK_NOTIFICATION_STATUS_ID FOREIGN KEY ([NOTIFICATION_STATUS_ID]) REFERENCES [NOTIFICATION_STATUS] ([ID]),
	CONSTRAINT CHK_USER_NOT_CONTACT_NOTIFICATION CHECK ([SENDER_ID] != [RECEPTOR_ID])
)
GO

CREATE TABLE [CONTACT_REQUEST]
(
	[ID] CHAR (36) NOT NULL,
	[IS_ACCEPTED] BIT DEFAULT 0 NOT NULL, /*0 = NOT, 1 = YES*/
	[IS_DENIED] BIT DEFAULT 0 NOT NULL, /*0 = NOT, 1 = YES*/
	[NOTIFICATION_ID] CHAR (36) NOT NULL,
	PRIMARY KEY ([ID]),
	CONSTRAINT FK_NOTIFICATION_CONTACT_REQUEST FOREIGN KEY ([NOTIFICATION_ID]) REFERENCES [NOTIFICATION] ([ID])
)
GO

CREATE TABLE [CONTACT_SHARED]
(
	[ID] CHAR (36) NOT NULL,
	[CONTACT_SHARED_ID] CHAR (36) NOT NULL,
	[NOTIFICATION_ID] CHAR (36) NOT NULL,
	PRIMARY KEY ([ID]),
	CONSTRAINT FK_NOTIFICATION_CONTACT_SHARED FOREIGN KEY ([NOTIFICATION_ID]) REFERENCES [NOTIFICATION] ([ID]),
	CONSTRAINT FK_CONTACT_SHARED FOREIGN KEY ([CONTACT_SHARED_ID]) REFERENCES [USER] ([ID])
)
GO