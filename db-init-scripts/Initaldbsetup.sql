-- Step 1: Create the Database
CREATE DATABASE LoginApp;
GO

-- Step 2: Use the Database
USE LoginApp;
GO

-- Step 3: Create Users Table
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,       -- Unique ID for each user
    Username NVARCHAR(50) NOT NULL UNIQUE,     -- Unique username
    PasswordHash NVARCHAR(256) NOT NULL,       -- Hashed password
    Salt NVARCHAR(256) NOT NULL,               -- Salt for password
    Email NVARCHAR(100) NOT NULL UNIQUE,       -- Email address
    IsActive BIT NOT NULL DEFAULT 1,           -- Whether the user is active
    CreatedDate DATETIME DEFAULT GETDATE(),    -- Account creation date
    UpdatedDate DATETIME NULL                  -- Last update date
);
GO

-- Step 4: Create Roles Table
CREATE TABLE Roles (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,      -- Unique ID for each role
    RoleName NVARCHAR(50) NOT NULL UNIQUE,    -- Unique role name
    CreatedDate DATETIME DEFAULT GETDATE()    -- Role creation date
);
GO

-- Step 5: Create UserRoles Table (Many-to-Many Relationship)
CREATE TABLE UserRoles (
    UserRoleId INT IDENTITY(1,1) PRIMARY KEY,  -- Unique ID for user-role mapping
    UserId INT NOT NULL,                       -- Foreign key to Users table
    RoleId INT NOT NULL,                       -- Foreign key to Roles table
    CreatedDate DATETIME DEFAULT GETDATE(),    -- Mapping creation date
    CONSTRAINT FK_UserRoles_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_UserRoles_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);
GO

-- Step 6: Create Sessions Table
CREATE TABLE Sessions (
    SessionId INT IDENTITY(1,1) PRIMARY KEY,   -- Unique ID for each session
    UserId INT NOT NULL,                       -- Foreign key to Users table
    Token NVARCHAR(512) NOT NULL,             -- JWT or session token
    IsValid BIT NOT NULL DEFAULT 1,            -- Whether the session is active
    CreatedAt DATETIME DEFAULT GETDATE(),      -- Session creation date
    ExpiresAt DATETIME NOT NULL,               -- Session expiration date
    CONSTRAINT FK_Sessions_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO

-----------------------------------------
-- Insert Sample Roles
INSERT INTO Roles (RoleName) VALUES
('Admin'),
('User');
GO
-- Insert Sample Users
INSERT INTO Users (Username, PasswordHash, Salt, Email)
VALUES 
('admin', 'hashed_password_admin', 'random_salt_admin', 'admin@example.com'),
('user1', 'hashed_password_user1', 'random_salt_user1', 'user1@example.com');
GO
-- Assign Roles to Users
INSERT INTO UserRoles (UserId, RoleId) VALUES
(1, 1), -- Admin role for admin
(2, 2); -- User role for user1
GO