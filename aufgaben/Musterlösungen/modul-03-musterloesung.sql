-- =========================================================================
-- MUSTERLÖSUNG MODUL 3: DDL – Die Geburtsstunde der DB
-- =========================================================================
USE
AKH_Wien;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: DDL-Struktur für das ärztliche Personal
-- -------------------------------------------------------------------------
CREATE TABLE Aerzte
(
    ID           INT IDENTITY(1,1) PRIMARY KEY,
    Nachname     NVARCHAR(100) NOT NULL,
    Vorname      NVARCHAR(100) NOT NULL,
    Titel        NVARCHAR(50),
    Fachrichtung NVARCHAR(100) NOT NULL,
    StatID       INT FOREIGN KEY REFERENCES Stationen(ID)
);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Behandlungshistorie & Archiv-Strukturen
-- -------------------------------------------------------------------------
-- Assoziationstabelle für Behandlungen
CREATE TABLE Behandlungen
(
    ID           INT IDENTITY(1,1) PRIMARY KEY,
    PatID        INT FOREIGN KEY REFERENCES Patienten(ID),
    ArztID       INT FOREIGN KEY REFERENCES Aerzte(ID),
    Datum        DATETIME2 NOT NULL,
    DiagnoseCode NVARCHAR(20),
    Kosten       DECIMAL(18, 2) CHECK (Kosten >= 0),
    Status       NVARCHAR(50) DEFAULT 'Abgeschlossen'
);
GO

-- Archivtabelle (ohne IDENTITY, da IDs aus der Produktivtabelle migriert werden)
CREATE TABLE Patienten_Archiv
(
    ID         INT PRIMARY KEY,
    Nachname   NVARCHAR(100) NOT NULL,
    Vorname    NVARCHAR(100) NOT NULL,
    GebDatum   DATE     NOT NULL,
    SVNummer   CHAR(10) NOT NULL,
    Geschlecht CHAR(1),
    StatID     INT
);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Laufende Modifikationen
-- -------------------------------------------------------------------------

-- 3.1: Logische Integrität bei Patienten nachrüsten
ALTER TABLE Patienten
    ADD CONSTRAINT CHK_Patient_Geschlecht CHECK (Geschlecht IN ('M', 'W', 'D'));
GO

-- 3.2: Temporäre Spalte hinzufügen
ALTER TABLE Behandlungen
    ADD Tmp_Notiz NVARCHAR(255);
GO

-- 3.3: Temporäre Spalte restlos entfernen
ALTER TABLE Behandlungen
DROP
COLUMN Tmp_Notiz;
GO