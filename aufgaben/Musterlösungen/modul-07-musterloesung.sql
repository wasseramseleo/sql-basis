-- =========================================================================
-- MUSTERLÖSUNG MODUL 7: Aggregation & Gruppierung
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Finanzielle Kennzahlen & Skalare Aggregation
-- -------------------------------------------------------------------------
SELECT SUM(Kosten) AS Gesamtkosten,
       AVG(Kosten) AS Durchschnittskosten,
       MAX(Kosten) AS Max_Kosten,
       COUNT(ID)   AS Anzahl_Behandlungen -- COUNT(*) wäre hier ebenfalls valide
FROM Behandlungen;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Datenqualität & Die COUNT-Falle
-- -------------------------------------------------------------------------
-- COUNT(*) zählt physische Zeilen (inklusive NULLs).
-- COUNT(StatID) zählt nur Zeilen, in denen StatID NICHT NULL ist.
SELECT Geschlecht,
       COUNT(*)      AS Patienten_Gesamt,
       COUNT(StatID) AS Patienten_Mit_Station
FROM Patienten
GROUP BY Geschlecht;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Kostenstellen-Reporting & HAVING
-- -------------------------------------------------------------------------
SELECT s.Name        AS Station,
       SUM(b.Kosten) AS Total_Kosten
FROM Stationen s
         INNER JOIN
     Aerzte a ON s.ID = a.StatID
         INNER JOIN
     Behandlungen b ON a.ID = b.ArztID
WHERE b.Status = 'Abgeschlossen' -- 1. WHERE: Filtert unfertige Behandlungen VOR der Berechnung
GROUP BY s.Name -- 2. GROUP BY: Definiert die Granularität
HAVING SUM(b.Kosten) > 10000.00 -- 3. HAVING: Filtert die fertigen Aggregate
GO