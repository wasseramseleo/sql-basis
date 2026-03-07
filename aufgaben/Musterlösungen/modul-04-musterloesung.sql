-- =========================================================================
-- MUSTERLÖSUNG MODUL 4: Erste Selektionen & Syntax-Regeln
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Die SELECT-Anatomie & Aliase
-- -------------------------------------------------------------------------
SELECT Vorname,
       Nachname AS Familienname,
       SVNummer AS Sozialversicherungsnummer
FROM Patienten;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Literale & Mathematische Berechnungen
-- -------------------------------------------------------------------------
SELECT Vorname,
       Nachname,
       'AKH Wien' AS Krankenhaus,                          -- Literal (statischer Wert)
    YEAR (GETDATE()) - YEAR (GebDatum) AS Alter_Geschaetzt -- Einfache Berechnung
FROM
    Patienten;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Logische Verarbeitungsreihenfolge
-- -------------------------------------------------------------------------
-- FEHLERHAFT: WHERE Alter_Geschaetzt > 50 (Alias ist hier noch unbekannt)
-- KORREKT: Berechnung muss in der WHERE-Klausel wiederholt werden.

SELECT Vorname,
       Nachname, YEAR (GETDATE()) - YEAR (GebDatum) AS Alter_Geschaetzt
FROM
    Patienten
WHERE
    (YEAR (GETDATE()) - YEAR (GebDatum))
    > 50;
GO