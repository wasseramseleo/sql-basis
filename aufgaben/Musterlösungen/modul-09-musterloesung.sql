-- =========================================================================
-- MUSTERLÖSUNG MODUL 9: DML – Daten verwalten
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Die sichere Patientenaufnahme
-- -------------------------------------------------------------------------
INSERT INTO Patienten (Nachname,
                       Vorname,
                       GebDatum,
                       SVNummer,
                       Geschlecht,
                       StatID)
VALUES ('Mustermann',
        'Max',
        '1982-05-15',
        '8765150582',
        'M',
        1);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Verlegung & Die "Goldene Regel"
-- -------------------------------------------------------------------------
-- Kritische Operation: Eingebettet in eine Transaktion für maximale Sicherheit.
BEGIN TRAN;

UPDATE Patienten
SET StatID   = 2,
    Nachname = 'Muster'
WHERE SVNummer = '8765150582';

-- Kontrolle der betroffenen Zeilen vor dem Commit (optional, aber empfohlen)
-- COMMIT TRAN; -- Ausführen, wenn alles korrekt ist
ROLLBACK TRAN; -- Ausführen im Fehlerfall
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Archivierung & Systematisches Löschen
-- -------------------------------------------------------------------------

-- 3.1: Gezieltes Löschen eines einzelnen Datensatzes (DML)
DELETE
FROM Patienten
WHERE SVNummer = '8765150582';
GO

-- 3.2: Vollständiges Leeren der Tabelle und Zurücksetzen der Struktur (DDL-ähnlich)
-- Schlägt fehl, falls ein Foreign Key auf diese Tabelle verweisen würde.
TRUNCATE TABLE Patienten_Archiv;
GO