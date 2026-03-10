-- =========================================================================
-- MUSTERLÖSUNG MODUL 6: Joins
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Stationsbelegung & INNER JOIN
-- -------------------------------------------------------------------------
SELECT p.Vorname,
       p.Nachname,
       p.SVNummer,
       s.Name AS Stationsname
FROM Patienten p
         INNER JOIN
     Stationen s ON p.StatID = s.ID;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Sorgenkinder & Anti-Joins
-- -------------------------------------------------------------------------

-- 2.1: Flurpatienten (Patienten ohne Station)
SELECT p.ID AS PatientenID,
       p.Nachname,
       p.Vorname
FROM Patienten p
         LEFT JOIN
     Stationen s ON p.StatID = s.ID
WHERE s.ID IS NULL; -- Der entscheidende Filter für den Anti-Join
GO

-- 2.2: Leere Stationen (Stationen ohne zugewiesene Patienten)
SELECT s.ID   AS StationsID,
       s.Name AS Stationsname
FROM Stationen s
         LEFT JOIN
     Patienten p ON s.ID = p.StatID
WHERE p.ID IS NULL;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Peer-Groups & Der Self-Join
-- -------------------------------------------------------------------------
-- Wir verwenden Aliase (a1, a2), um dieselbe Tabelle logisch zu trennen.
SELECT a1.Nachname AS Arzt_1,
       a2.Nachname AS Arzt_2,
       s.Name      AS Gemeinsame_Station
FROM Aerzte a1
         INNER JOIN
     Aerzte a2 ON a1.StatID = a2.StatID
         AND a1.ID < a2.ID -- Eliminiert Selbst-Paarungen (ID=ID) und Spiegelungen (ID>ID)
         INNER JOIN
     Stationen s ON a1.StatID = s.ID;
GO