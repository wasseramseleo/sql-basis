-- 1. Sicherstellen, dass wir in der Master-DB sind
USE master;
GO

-- 2. Datenbank mit expliziten Pfaden anlegen
-- WICHTIG: Die Ordner C:\SQLData\ müssen existieren!
CREATE DATABASE AKH_Wien
ON PRIMARY (
NAME = AKH_Wien_Data,
FILENAME = 'C:\Users\Public\AKH_Wien.mdf', -- Pfad anpassen, wo er Rechte hat
SIZE = 10MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB
)
LOG ON (
NAME = AKH_Wien_Log,
FILENAME = 'C:\Users\Public\AKH_Wien.ldf', -- Pfad anpassen
SIZE = 5MB,
MAXSIZE = 50MB,
FILEGROWTH = 5MB
);
GO