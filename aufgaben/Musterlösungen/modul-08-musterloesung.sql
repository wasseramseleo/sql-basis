-- =========================================================================
-- MUSTERLÖSUNG MODUL 8: Sortierung & Formatierung
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Europäische Datumsstandards & Multi-Sortierung
-- -------------------------------------------------------------------------
SELECT Nachname,
       Vorname,
       CONVERT(VARCHAR, GebDatum, 104) AS GebDatum_AT
FROM Patienten
ORDER BY Nachname ASC,
         Vorname ASC;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: String-Manipulation für Dienstpläne
-- -------------------------------------------------------------------------
SELECT
    CONCAT(Titel, ' ', Nachname, ', ', SUBSTRING(Vorname, 1,1), '.') AS AnzeigeName
FROM Aerzte
ORDER BY Nachname ASC;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Klinische Zeitdifferenzen messen
-- -------------------------------------------------------------------------
SELECT ID,
       DiagnoseCode,
       Datum,
       DATEDIFF(day, Datum, GETDATE()) AS Tage_Vergangen
FROM Behandlungen
ORDER BY Tage_Vergangen DESC; -- Älteste Datensätze zuerst (höchste Differenz)
GO