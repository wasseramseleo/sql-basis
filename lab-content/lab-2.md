### Datei 1: `AKH_Uebungen_Modul3_DDL.md`

# Übungssatz: Modul 3 – DDL (Die Geburtsstunde der DB)

## Aufgabe 1: Physische Anlage der Infrastruktur (Level 1 - Basic)

* **Lernziel:** Syntax für `CREATE TABLE`, Definition von Primärschlüsseln und Einsatz von `IDENTITY` für automatisches Hochzählen.
* **Szenario:** Das AKH-System benötigt die physische Tabelle für die bettenführenden Stationen, um Patienten zuweisen zu können.
* **Aufgabenstellung:** Erstellen Sie die Tabelle `Station`. Definieren Sie `StatID` (INT) als Primärschlüssel, der automatisch bei 1 beginnt und um 1 hochzählt. Fügen Sie `Name` (VARCHAR(50)) und `Stockwerk` (TINYINT) hinzu. Beide dürfen nicht leer sein (`NOT NULL`).
* **Erwartetes Ergebnis:** Ein fehlerfrei ausführbares `CREATE TABLE`-Skript für die Entität `Station`.
* **Pro-Tipp:** `TINYINT` verbraucht nur 1 Byte Speicherplatz und reicht für Werte von 0 bis 255 – ideal für Stockwerke in einem Krankenhausgebäude. Effiziente Datentypwahl reduziert den I/O-Overhead massiv.
* **Geschätzte Dauer:** 10 Minuten.

---

## Aufgabe 2: Patientenstammdaten & Datenintegrität (Level 2 - Applied)

* **Lernziel:** Implementierung von Fremdschlüsseln (`FOREIGN KEY`), Eindeutigkeit (`UNIQUE`) und Standard-Constraints.
* **Szenario:** Die Patientenaufnahme muss digitalisiert werden. Um Duplikate zu vermeiden, muss die österreichische Sozialversicherungsnummer zwingend eindeutig sein.
* **Aufgabenstellung:** Erstellen Sie die Tabelle `Patient`. Spalten: `PatID` (INT, Primary Key, Identity), `Nachname` (VARCHAR(50), NOT NULL), `Vorname` (VARCHAR(50), NOT NULL), `GebDatum` (DATE, NOT NULL), `SVNummer` (CHAR(10)). Setzen Sie ein `UNIQUE`-Constraint auf die SV-Nummer. Etablieren Sie einen Foreign Key über `StatID` (INT) zur Tabelle `Station`.
* **Erwartetes Ergebnis:** Ein `CREATE TABLE`-Skript, das relationale Integrität (FK) und Datenqualität (UNIQUE, NOT NULL) erzwingt.
* **Pro-Tipp:** Ein `UNIQUE`-Constraint erzeugt im SQL Server automatisch einen Non-Clustered Index. Dies beschleunigt spätere Suchanfragen nach der SV-Nummer erheblich, verlangsamt aber `INSERT`-Operationen minimal.
* **Geschätzte Dauer:** 15 Minuten.

---

## Aufgabe 3: Laufende Anpassungen & Restriktionen (Level 3 - Expert)

* **Lernziel:** Nachträgliche Modifikation der Tabellenstruktur mittels `ALTER TABLE` und Hinzufügen von Check-Constraints.
* **Szenario:** Nach dem Go-Live fordert die Pflegedirektion zwei Änderungen: Es muss eine Notfall-Telefonnummer erfasst werden, und das System darf keine zukünftigen Geburtsdaten bei der Patientenaufnahme zulassen (Eingabefehler-Prävention). Zudem wurde testweise eine Spalte `Bemerkung_Temp` angelegt, die nun restlos entfernt werden muss.
* **Aufgabenstellung:** 1. Fügen Sie der Tabelle `Patient` die Spalte `NotfallKontakt` (VARCHAR(30), NULL-Werte erlaubt) hinzu.
2. Fügen Sie der Tabelle `Patient` ein `CHECK`-Constraint hinzu, das sicherstellt, dass das `GebDatum` kleiner oder gleich dem heutigen Datum (`GETDATE()`) ist.
3. Löschen Sie eine fiktive Spalte `Bemerkung_Temp` aus der Tabelle `Patient` (Hinweis: Schreiben Sie den Code so, als ob die Spalte existieren würde).
* **Erwartetes Ergebnis:** Drei separate `ALTER TABLE`-Statements.
* **Pro-Tipp:** `ALTER TABLE`-Operationen können auf großen Tabellen zu Table-Locks führen. In kritischen 24/7-Umgebungen wie dem AKH müssen solche DDL-Operationen in Wartungsfenstern eingeplant werden.
* **Geschätzte Dauer:** 20 Minuten.

---

### Datei 2: `AKH_Loesungen_Modul3_DDL.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 3: DDL – Die Geburtsstunde der DB
-- =========================================================================

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Physische Anlage der Infrastruktur (Level 1)
-- -------------------------------------------------------------------------
CREATE TABLE Station (
    StatID INT IDENTITY(1,1) PRIMARY KEY, -- IDENTITY(1,1) ersetzt manuelle ID-Vergabe
    Name VARCHAR(50) NOT NULL,
    Stockwerk TINYINT NOT NULL            -- TINYINT (0-255) ist speichereffizient für Gebäude
);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Patientenstammdaten & Datenintegrität (Level 2)
-- -------------------------------------------------------------------------
CREATE TABLE Patient (
    PatID INT IDENTITY(1,1) PRIMARY KEY,
    Nachname VARCHAR(50) NOT NULL,
    Vorname VARCHAR(50) NOT NULL,
    GebDatum DATE NOT NULL,
    SVNummer CHAR(10) UNIQUE NOT NULL,    -- Eindeutigkeit erzwingen, impliziter Index
    StatID INT,                           -- Datentyp muss exakt dem PK der Ziel-Tabelle entsprechen (INT)
    CONSTRAINT FK_Patient_Station FOREIGN KEY (StatID) REFERENCES Station(StatID)
);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Laufende Anpassungen & Restriktionen (Level 3)
-- -------------------------------------------------------------------------

-- 3.1: Neue Spalte hinzufügen (NULL zulassen, da Altbestand keine Daten hat)
ALTER TABLE Patient
ADD NotfallKontakt VARCHAR(30) NULL;
GO

-- 3.2: Logische Fehler bei Dateneingabe verhindern (CHECK-Constraint)
-- CAST(GETDATE() AS DATE) entfernt den Zeitstempel für einen sauberen Vergleich
ALTER TABLE Patient
ADD CONSTRAINT CHK_Patient_GebDatum CHECK (GebDatum <= CAST(GETDATE() AS DATE));
GO

-- 3.3: Struktur bereinigen (Spalte entfernen)
-- Angenommen, diese Spalte wurde zuvor für einen Test erstellt
-- ALTER TABLE Patient ADD Bemerkung_Temp VARCHAR(100);
ALTER TABLE Patient
DROP COLUMN Bemerkung_Temp;
GO

```

Sollen für Modul 4 ("Erste Selektionen & Syntax-Regeln") Aufgaben generiert werden, die auf diesem neu erstellten Schema basieren?