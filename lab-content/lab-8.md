### Datei 1: `AKH_Uebungen_Modul9_DML.md`

# Übungssatz: Modul 9 – DML (Daten verwalten)

Der sichere Umgang mit DML-Operationen erfordert höchste Präzision. In Produktionssystemen wie dem AKH Wien führen unachtsame Datenmanipulationen zu kritischen Systemausfällen oder medizinischen Falschinformationen.

# Aufgabe 1: Die sichere Patientenaufnahme

### Lernziel
 Anwendung von `INSERT INTO` mit expliziter Spaltendeklaration.
### Szenario
 Ein neuer Patient (Max Mustermann, geb. 15.05.1982, SVN: 8765150582, männlich) wird in der Kardiologie (StatID 1) aufgenommen.
## Aufgabenstellung
 Fügen Sie diesen Datensatz in die Tabelle `Patienten` ein. Deklarieren Sie die Zielspalten explizit im SQL-Befehl.
### Erwartetes Ergebnis
 Ein neuer Datensatz in der Tabelle `Patienten`.
### Pro-Tipp
 Evidenzbasierte Datenbankentwicklung verbietet den Einsatz von `INSERT INTO Tabelle VALUES (...)` ohne Spaltenangabe. Bei zukünftigen Schema-Erweiterungen (z.B. einer neuen Spalte) bricht dieser Code unweigerlich ab.
### Geschätzte Dauer
 10 Minuten.

---

# Aufgabe 2: Verlegung & Die "Goldene Regel"

### Lernziel
 Gezielte Datenmodifikation mittels `UPDATE` und zwingender `WHERE`-Klausel.
### Szenario
 Der zuvor aufgenommene Patient Max Mustermann wird auf die Onkologie (StatID 2) verlegt. Gleichzeitig stellt sich heraus, dass sein Nachname "Muster" lautet, nicht "Mustermann".
## Aufgabenstellung
 Aktualisieren Sie den Datensatz in der Tabelle `Patienten`. Ändern Sie `StatID` und `Nachname` in einem einzigen Befehl. Nutzen Sie die eindeutige `SVNummer` zur Identifikation des korrekten Datensatzes.
### Erwartetes Ergebnis
 Die Attribute `StatID` und `Nachname` sind für diesen einen spezifischen Patienten modifiziert. Alle anderen Datensätze bleiben unberührt.
### Pro-Tipp
 Ein `UPDATE` ohne `WHERE`-Klausel überschreibt die gesamte Tabelle – der absolute GAU im Klinikbetrieb. In professionellen Umgebungen wird jede manuelle DML-Operation zwingend in eine Transaktion (`BEGIN TRAN ... COMMIT / ROLLBACK`) gekapselt, um destruktive Fehler rückgängig machen zu können.
### Geschätzte Dauer
 15 Minuten.

---

# Aufgabe 3: Archivierung & Systematisches Löschen

### Lernziel
 Unterscheidung der logischen und physischen Implikationen von `DELETE` versus `TRUNCATE`.
### Szenario
 Der Patient Max Muster hat seine Behandlung abgebrochen. Sein Datensatz muss aus der aktiven Tabelle entfernt werden. Zusätzlich muss die strukturidentische Tabelle `Patienten_Archiv`, die für einen fehlgeschlagenen Massenimport genutzt wurde, vollständig und ressourcenschonend geleert werden.
## Aufgabenstellung
 1. Löschen Sie den Datensatz von Max Muster aus `Patienten` mittels `DELETE`.
2. Leeren Sie die Tabelle `Patienten_Archiv` mittels `TRUNCATE`.
### Erwartetes Ergebnis
 Zwei separate Befehle. Ein spezifisch gelöschter Datensatz und eine komplett zurückgesetzte Archiv-Tabelle.
### Pro-Tipp
  `DELETE` ist eine voll protokollierte Operation (DML). Jede gelöschte Zeile wird ins Transaction Log geschrieben. `TRUNCATE` (DDL) dealloziert hingegen die Datenseiten (Data Pages) und protokolliert nur diese Deallokation. `TRUNCATE` ist massiv schneller, setzt aber auch den `IDENTITY`-Zähler unwiderruflich zurück.
### Geschätzte Dauer
 15 Minuten.

---

### Datei 2: `AKH_Loesungen_Modul9_DML.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 9: DML – Daten verwalten
-- =========================================================================

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Die sichere Patientenaufnahme
-- -------------------------------------------------------------------------
INSERT INTO Patienten (
    Nachname, 
    Vorname, 
    GebDatum, 
    SVNummer, 
    Geschlecht, 
    StatID
)
VALUES (
    'Mustermann', 
    'Max', 
    '1982-05-15', 
    '8765150582', 
    'M', 
    1
);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Verlegung & Die "Goldene Regel"
-- -------------------------------------------------------------------------
-- Kritische Operation: Eingebettet in eine Transaktion für maximale Sicherheit.
BEGIN TRAN;

UPDATE Patienten
SET 
    StatID = 2,
    Nachname = 'Muster'
WHERE 
    SVNummer = '8765150582';

-- Kontrolle der betroffenen Zeilen vor dem Commit (optional, aber empfohlen)
-- COMMIT TRAN; -- Ausführen, wenn alles korrekt ist
-- ROLLBACK TRAN; -- Ausführen im Fehlerfall
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Archivierung & Systematisches Löschen
-- -------------------------------------------------------------------------

-- 3.1: Gezieltes Löschen eines einzelnen Datensatzes (DML)
DELETE FROM Patienten
WHERE SVNummer = '8765150582';
GO

-- 3.2: Vollständiges Leeren der Tabelle und Zurücksetzen der Struktur (DDL-ähnlich)
-- Schlägt fehl, falls ein Foreign Key auf diese Tabelle verweisen würde.
TRUNCATE TABLE Patienten_Archiv;
GO

```
