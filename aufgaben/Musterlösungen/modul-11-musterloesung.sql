-- =========================================================================
-- MUSTERLÖSUNG MODUL 11: Fortgeschrittene Konzepte
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Kapselung in Views
-- -------------------------------------------------------------------------
GO
CREATE VIEW vw_Patienten_Uebersicht AS
SELECT p.Vorname  AS Patient_Vorname,
       p.Nachname AS Patient_Nachname,
       s.Name     AS Station,
       a.Nachname AS Behandelnder_Arzt
FROM Patienten p
         LEFT JOIN
     Stationen s ON p.StatID = s.ID
         LEFT JOIN
     Behandlungen b ON p.ID = b.PatID
         LEFT JOIN
     Aerzte a ON b.ArztID = a.ID;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Strukturierung mit CTEs
-- -------------------------------------------------------------------------
WITH KostenStatistik AS (
    -- Die CTE berechnet den globalen Wert vorab
    SELECT AVG(Kosten) AS Schnitt
    FROM Behandlungen
)
SELECT p.Nachname,
       b.Kosten,
       ks.Schnitt AS Globaler_Durchschnitt
FROM Patienten p
         JOIN
     Behandlungen b ON p.ID = b.PatID
         CROSS JOIN
     KostenStatistik ks -- Verbindet den einen Skalarwert mit allen Zeilen
WHERE b.Kosten > ks.Schnitt;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Korrelierte Subqueries
-- -------------------------------------------------------------------------
SELECT b1.PatID,
       b1.Datum,
       b1.Kosten,
       (
           -- Die Subquery referenziert die äußere Tabelle (b1)
           SELECT AVG(b2.Kosten)
           FROM Behandlungen b2
           WHERE b2.PatID = b1.PatID) AS Patienten_Eigen_Durchschnitt
FROM Behandlungen b1
ORDER BY b1.PatID;
GO