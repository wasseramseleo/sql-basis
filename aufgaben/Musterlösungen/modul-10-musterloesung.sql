-- =========================================================================
-- MUSTERLÖSUNG MODUL 10: Mengenoperationen & Subqueries
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Historische Datenfusion & Performance
-- -------------------------------------------------------------------------

-- Variante A: UNION (Mit impliziter Duplikatprüfung -> Hoher CPU/I/O-Aufwand)
SELECT SVNummer
FROM Patienten
UNION
SELECT SVNummer
FROM Patienten_Archiv;
GO

-- Variante B: UNION ALL (Ohne Prüfung -> Maximale Performance)
SELECT SVNummer
FROM Patienten
UNION ALL
SELECT SVNummer
FROM Patienten_Archiv;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Anomalie-Erkennung via Subquery
-- -------------------------------------------------------------------------
SELECT ID,
       Datum,
       Kosten
FROM Behandlungen
WHERE Kosten > (
    -- Unkorrelierte Subquery berechnet den globalen Schnitt
    SELECT AVG(Kosten)
    FROM Behandlungen);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Mengenfilter ohne Joins
-- -------------------------------------------------------------------------
SELECT Nachname,
       Vorname
FROM Patienten
WHERE ID IN (
    -- Subquery liefert die isolierte Menge an Patienten-IDs
    SELECT PatID
    FROM Behandlungen
    WHERE Kosten > 2000.00);
GO