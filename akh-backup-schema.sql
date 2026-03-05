-- =========================================================================
-- DDL: Datenbank & Tabellenstruktur
-- =========================================================================
USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'AKH_Wien')
BEGIN
    CREATE DATABASE AKH_Wien;
END
GO

USE AKH_Wien;
GO

SET NOCOUNT ON;
GO

-- Bestehende Tabellen für idempotente Ausführung droppen
DROP TABLE IF EXISTS Behandlungen;
DROP TABLE IF EXISTS Patienten_Archiv;
DROP TABLE IF EXISTS Patienten;
DROP TABLE IF EXISTS Aerzte;
DROP TABLE IF EXISTS Stationen;
GO

CREATE TABLE Stationen (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Fachbereich NVARCHAR(100) NOT NULL,
    Stockwerk INT NOT NULL,
    BettenAnzahl INT CHECK (BettenAnzahl > 0)
);

CREATE TABLE Aerzte (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nachname NVARCHAR(100) NOT NULL,
    Vorname NVARCHAR(100) NOT NULL,
    Titel NVARCHAR(50),
    Fachrichtung NVARCHAR(100) NOT NULL,
    StatID INT FOREIGN KEY REFERENCES Stationen(ID)
);

CREATE TABLE Patienten (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nachname NVARCHAR(100) NOT NULL,
    Vorname NVARCHAR(100) NOT NULL,
    GebDatum DATE NOT NULL,
    SVNummer CHAR(10) UNIQUE NOT NULL,
    Geschlecht CHAR(1) CHECK (Geschlecht IN ('M', 'W', 'D')),
    -- Erlaubt NULL für LEFT/RIGHT/FULL JOIN Übungen
    StatID INT FOREIGN KEY REFERENCES Stationen(ID) NULL
);

-- Strukturidentische Tabelle für UNION / INTERSECT / EXCEPT Übungen
CREATE TABLE Patienten_Archiv (
    ID INT PRIMARY KEY,
    Nachname NVARCHAR(100) NOT NULL,
    Vorname NVARCHAR(100) NOT NULL,
    GebDatum DATE NOT NULL,
    SVNummer CHAR(10) NOT NULL,
    Geschlecht CHAR(1),
    StatID INT
);

CREATE TABLE Behandlungen (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    PatID INT FOREIGN KEY REFERENCES Patienten(ID),
    ArztID INT FOREIGN KEY REFERENCES Aerzte(ID),
    Datum DATETIME2 NOT NULL,
    DiagnoseCode NVARCHAR(20),
    Kosten DECIMAL(18,2) CHECK (Kosten >= 0),
    Status NVARCHAR(50) DEFAULT 'Abgeschlossen'
);
GO
