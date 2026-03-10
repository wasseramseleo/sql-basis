-- =========================================================================
-- MUSTERLÖSUNG MODUL 5: Daten-Setup & Filterung
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Kostenkontrolle & Mengenfilter
-- -------------------------------------------------------------------------
SELECT ID,
       PatID,
       ArztID,
       Datum,
       Kosten,
       Status
FROM Behandlungen
WHERE Kosten BETWEEN 500.00 AND 2000.00
  AND Status IN ('Abgeschlossen', 'Storniert');
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Operator-Präzedenz bei AND/OR
-- -------------------------------------------------------------------------
-- FALSCH (ohne Klammern): Liefert alle Diversen (egal welches Alter)
-- UND weibliche Patienten nach 1990.
/*
SELECT * FROM Patienten
WHERE Geschlecht = 'D' OR Geschlecht = 'W' AND GebDatum > '1990-12-31';
*/

-- KORREKT (mit Klammern): Isoliert die OR-Logik vor der AND-Prüfung.
SELECT ID,
       Nachname,
       Vorname,
       GebDatum,
       Geschlecht
FROM Patienten
WHERE (Geschlecht = 'W' OR Geschlecht = 'D')
  AND GebDatum > '1990-12-31';
GO

-- Alternative (und sauberere) Lösung mit IN:
SELECT ID,
       Nachname,
       Vorname,
       GebDatum,
       Geschlecht
FROM Patienten
WHERE Geschlecht IN ('W', 'D')
  AND GebDatum > '1990-12-31';
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Die Three-Valued Logic Falle
-- -------------------------------------------------------------------------
-- FEHLERHAFT (liefert 0 Zeilen, da NULL = NULL -> UNKNOWN ergibt):
-- SELECT * FROM Patienten WHERE StatID = NULL;

-- KORREKT:
SELECT ID,
       Nachname,
       Vorname,
       SVNummer
FROM Patienten
WHERE StatID IS NULL;
GO