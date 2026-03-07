# Übungssatz: Modul 3 – DDL (Die Geburtsstunde der DB)

# Vorbereitung: Skripting & Ausführung im SSMS

Bevor Sie die DDL-Aufgaben lösen, müssen die Werkzeug-Mechaniken im SQL Server Management Studio (SSMS) klar sein.

### 1. Der Arbeitsbereich (New Query)

T-SQL-Code wird in einem dedizierten Editor-Fenster geschrieben.

* Klicken Sie in der oberen Symbolleiste des SSMS auf **"New Query"** (Neue Abfrage).

Stellen Sie sicher, dass im Datenbank-Dropdown (links neben "Execute") die Zieldatenbank `AKH_Wien` ausgewählt ist. Alternativ erzwingen Sie den korrekten Kontext als erste Zeile im Skript mit: `USE AKH_Wien; GO`.

### 2. Skripte ausführen (Execute / F5)

* **Vollständige Ausführung:** Ein Klick auf **"Execute"** (oder Taste **F5**) sendet den gesamten Text im Editorfenster an den SQL Server.
* **Partielle Ausführung:** Markieren Sie mit der Maus nur einen spezifischen Code-Block (z.B. nur ein einzelnes `CREATE TABLE`-Statement) und drücken Sie F5. Der Server kompiliert und führt dann *ausschließlich* die markierten Zeilen aus. Dies ist Best Practice beim schrittweisen Aufbau eines Schemas.

### 3. Das "Kein Strg+Z"-Prinzip (Fehlerkorrektur)

Eine Datenbank ist kein Textdokument. Sobald ein DDL-Kommando (`CREATE`, `ALTER`, `DROP`) an den Server gesendet und fehlerfrei ausgeführt wurde, ist die Struktur der Datenbank **permanent und physisch geändert**.

* Ein klassisches "Rückgängig" (Strg+Z) greift nur für den *Text* im Editor, **nicht** für den Zustand der Datenbank.
* **Evidenzbasierte Korrektur:** Fehler müssen durch explizite Gegenbefehle behoben werden.
* Haben Sie eine Tabelle fehlerhaft erstellt, müssen Sie diese mit `DROP TABLE <Name>;` komplett löschen und den korrigierten `CREATE`-Befehl neu ausführen.
* Haben Sie eine Spalte falsch benannt, müssen Sie die Tabelle über `ALTER TABLE` modifizieren oder die Spalte mit `DROP COLUMN` entfernen.

Ganz Unten in dieser Angabe finden Sie hilfreiche SQL-Befehle.

---
# Aufgabe 1: DDL-Struktur für das ärztliche Personal

### Lernziel

Sichere Anwendung von `CREATE TABLE` zur Erstellung relationaler Entitäten inklusive Primärschlüsseln, Datentypen und
Fremdschlüsseln (FK) im T-SQL-Skript.

### Szenario

Das im SSMS-Diagramm erstellte Fundament (Patienten und Stationen) muss nun scriptbasiert um das medizinische Personal
erweitert werden. Ärzte werden den bestehenden Stationen als Hauptabteilung zugewiesen.

### Aufgabenstellung

Schreiben Sie ein DDL-Skript zur Erstellung der Tabelle `Aerzte`. Definieren Sie die Spalte `ID` (INT) als automatisch
inkrementierenden Primärschlüssel. Fügen Sie `Nachname` und `Vorname` (jeweils NVARCHAR(100), zwingend erforderlich),
`Titel` (NVARCHAR(50), optional) sowie `Fachrichtung` (NVARCHAR(100), zwingend erforderlich) hinzu. Etablieren Sie einen
Fremdschlüssel `StatID` (INT), der auf die bestehende Tabelle `Stationen` (Spalte `ID`) referenziert.

### Erwartetes Ergebnis

Ein syntaktisch korrektes `CREATE TABLE`-Skript, das die Tabelle `Aerzte` mit allen Integritätsbedingungen (PK, FK, NOT
NULL) erzeugt.

### Tipp

Die Verwendung von `NVARCHAR` anstelle von `VARCHAR` ist im klinischen Umfeld essenziell, um internationale Namen mit
Sonderzeichen (Unicode) verlustfrei zu speichern. Der Speicher-Overhead rechtfertigt die gewonnene Datenintegrität.


---

# Aufgabe 2: Behandlungshistorie & Archiv-Strukturen

### Lernziel

Modellierung einer m:n-Auflösung (Assoziationstabelle) via DDL und Implementierung logischer Prüfungen durch `CHECK`
-Constraints und `DEFAULT`-Werte.

### Szenario

Das Controlling fordert die lückenlose Erfassung aller medizinischen Leistungen. Zudem wird eine strukturgleiche
Archivtabelle für Patienten benötigt, die aus rechtlichen Gründen aufbewahrt, aber aus dem operativen System ausgelagert
werden.

### Aufgabenstellung

1. **Assoziationstabelle:** Erstellen Sie die Tabelle `Behandlungen`. Definieren Sie einen Surrogate-Key `ID` (INT,
   Identity, PK). Verknüpfen Sie die Entität über die Fremdschlüssel `PatID` (zu `Patienten`) und `ArztID` (zu
   `Aerzte`). Fügen Sie die Spalten `Datum` (DATETIME2, NOT NULL), `DiagnoseCode` (NVARCHAR(20)) und `Kosten` (DECIMAL(
   18,2)) hinzu. Sichern Sie die Kosten durch ein Check-Constraint gegen negative Werte (`>= 0`) ab. Die Spalte
   `Status` (NVARCHAR(50)) soll standardmäßig den Wert `'Abgeschlossen'` erhalten.
2. **Archivtabelle:** Erstellen Sie die Tabelle `Patienten_Archiv` mit den exakten Spalten der `Patienten`-Tabelle (
   `ID`, `Nachname`, `Vorname`, `GebDatum`, `SVNummer`, `Geschlecht`, `StatID`). *Achtung:* Setzen Sie die `ID` als
   Primary Key, verzichten Sie hier aber zwingend auf die `IDENTITY`-Eigenschaft, da historische IDs 1:1 übernommen
   werden müssen.

### Erwartetes Ergebnis

Zwei `CREATE TABLE`-Skripte. Das Behandlungs-Skript sichert die relationale und logische Integrität (FK, CHECK, DEFAULT)
auf Datenbankebene ab.

### Tipp

Der Datentyp `DATETIME2` ist ANSI-SQL-konform, speichereffizienter und präziser (bis auf 100 Nanosekunden) als das
veraltete `DATETIME`. In modernen SQL Server-Architekturen gilt `DATETIME2` als Best Practice.


---

# Aufgabe 3: Laufende Modifikationen (ALTER & DROP)

### Lernziel

Strukturänderungen an bestehenden Tabellen im laufenden Betrieb mittels `ALTER TABLE` und `DROP COLUMN` durchführen.

### Szenario

Das Qualitätsmanagement meldet zwei akute Probleme: In der visuell erstellten Tabelle `Patienten` (aus Lab 1) fehlt die
Einschränkung auf gültige Geschlechtsangaben. Zudem wurde für einen Schnittstellentest temporär eine Notiz-Spalte in der
Tabelle `Behandlungen` benötigt, die nun in Produktion unzulässig ist.

### Aufgabenstellung

1. Fügen Sie der in Lab 1 erstellten Tabelle `Patienten` ein `CHECK`-Constraint für die Spalte `Geschlecht` hinzu.
   Erlaubt sind ausschließlich die Werte `'M'`, `'W'` und `'D'`.
2. Fügen Sie der Tabelle `Behandlungen` eine neue Spalte `Tmp_Notiz` (NVARCHAR(255)) hinzu.
3. Löschen Sie die Spalte `Tmp_Notiz` aus der Tabelle `Behandlungen` im darauffolgenden Skript wieder rückstandslos.

### Erwartetes Ergebnis

Drei separate `ALTER TABLE`-Befehle zur Modifikation und Bereinigung des Schemas.

### Tipp

In hochverfügbaren Systemen blockieren DDL-Operationen wie `ALTER TABLE` die betroffene Tabelle (Schéma-Lock). Führen
Sie solche Eingriffe ausschließlich in definierten Wartungsfenstern aus, um Transaktionsabbrüche (Deadlocks) im
Krankenhausbetrieb zu vermeiden.


---

Fügen Sie diesen Abschnitt am besten direkt an das vorbereitende Briefing an. Er liefert das notwendige Rüstzeug, um strukturelle Fehler systematisch und ohne Frustration zu beheben.

---

### 4. Nothilfe & Reset-Befehle (Troubleshooting)

Beim Aufbau relationaler Strukturen sind Fehlversuche Teil des Lernprozesses. Nutzen Sie die folgenden T-SQL-Kommandos, um den Zustand der Datenbank gezielt zu bereinigen.

**Einzelne Tabellen löschen**
Der Befehl löscht die physische Struktur irreversibel aus der Datenbank.

```sql
DROP TABLE Aerzte;

```

*Kritischer Hinweis:* Die relationale Architektur erzwingt eine strikte Hierarchie. Sie können eine Tabelle nicht löschen, solange eine andere Tabelle über einen Fremdschlüssel (Foreign Key) auf sie verweist. Löschen Sie immer zuerst die abhängige Tabelle (z.B. `Behandlungen`), bevor Sie die übergeordnete Tabelle (z.B. `Aerzte`) entfernen.

**Sicherer Drop (Best Practice)**
Prüft vor dem Löschen, ob das Objekt überhaupt existiert. Das verhindert unnötige Fehlermeldungen im SSMS.

```sql
DROP TABLE IF EXISTS Behandlungen;

```

**Rollback auf den Stand von Lab 1**
Führen Sie dieses Skript aus, um alle in Lab 2 fehlerhaft erstellten Tabellen sauber zu entfernen. Die Löschreihenfolge respektiert die referenzielle Integrität. Übrig bleiben exakt die in Lab 1 visuell erstellten Tabellen `Patienten` und `Stationen`.

```sql
USE AKH_Wien;
GO
DROP TABLE IF EXISTS Behandlungen;
DROP TABLE IF EXISTS Aerzte;
DROP TABLE IF EXISTS Patienten_Archiv;
GO

```

**Tabula Rasa: Datenbank komplett zurücksetzen (Hard Reset)**
Die ultimative Maßnahme bei irreparablen Strukturfehlern. Achtung: Danach muss auch Lab 1 (visuelle Erstellung) komplett wiederholt werden.

```sql
-- Zwingend: Kontext wechseln. Sie können die Datenbank nicht löschen, 
-- während Sie (oder das Diagramm-Tool) noch darin arbeiten.
USE master; 
GO

-- Trennt alle aktiven Hintergrundverbindungen sofort
ALTER DATABASE AKH_Wien SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
GO

-- Löscht die Datenbank restlos
DROP DATABASE IF EXISTS AKH_Wien; 
GO

-- Erstellt eine frische, komplett leere Datenbank
CREATE DATABASE AKH_Wien;
GO

USE AKH_Wien;
GO

SET NOCOUNT ON;
GO

DROP TABLE IF EXISTS Patienten;
DROP TABLE IF EXISTS Stationen;
GO

CREATE TABLE Stationen (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          Name NVARCHAR(100) NOT NULL,
                          Fachbereich NVARCHAR(100) NOT NULL,
                          Stockwerk INT NOT NULL,
                          BettenAnzahl INT CHECK (BettenAnzahl > 0)
);

CREATE TABLE Patienten (
                          ID INT IDENTITY(1,1) PRIMARY KEY,
                          Nachname NVARCHAR(100) NOT NULL,
                          Vorname NVARCHAR(100) NOT NULL,
                          GebDatum DATE NOT NULL,
                          SVNummer CHAR(10) UNIQUE NOT NULL,
                          Geschlecht CHAR(1) CHECK (Geschlecht IN ('M', 'W', 'D')),
   -- Erlaubt NULL für LEFT/RIGHT/FULL JOIN Übungen
                          StatID INT FOREIGN KEY REFERENCES Stationen(ID) NULL
);
GO
```

---

### Datei 2: `AKH_Loesungen_Modul3_DDL.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 3: DDL – Die Geburtsstunde der DB
-- =========================================================================
USE
AKH_Wien;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: DDL-Struktur für das ärztliche Personal
-- -------------------------------------------------------------------------
CREATE TABLE Aerzte
(
   ID           INT IDENTITY(1,1) PRIMARY KEY,
   Nachname     NVARCHAR(100) NOT NULL,
   Vorname      NVARCHAR(100) NOT NULL,
   Titel        NVARCHAR(50),
   Fachrichtung NVARCHAR(100) NOT NULL,
   StatID       INT FOREIGN KEY REFERENCES Stationen(ID)
);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Behandlungshistorie & Archiv-Strukturen
-- -------------------------------------------------------------------------
-- Assoziationstabelle für Behandlungen
CREATE TABLE Behandlungen
(
   ID           INT IDENTITY(1,1) PRIMARY KEY,
   PatID        INT FOREIGN KEY REFERENCES Patienten(ID),
   ArztID       INT FOREIGN KEY REFERENCES Aerzte(ID),
   Datum        DATETIME2 NOT NULL,
   DiagnoseCode NVARCHAR(20),
   Kosten       DECIMAL(18, 2) CHECK (Kosten >= 0),
   Status       NVARCHAR(50) DEFAULT 'Abgeschlossen'
);
GO

-- Archivtabelle (ohne IDENTITY, da IDs aus der Produktivtabelle migriert werden)
CREATE TABLE Patienten_Archiv
(
   ID         INT PRIMARY KEY,
   Nachname   NVARCHAR(100) NOT NULL,
   Vorname    NVARCHAR(100) NOT NULL,
   GebDatum   DATE     NOT NULL,
   SVNummer   CHAR(10) NOT NULL,
   Geschlecht CHAR(1),
   StatID     INT
);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Laufende Modifikationen
-- -------------------------------------------------------------------------

-- 3.1: Logische Integrität bei Patienten nachrüsten
ALTER TABLE Patienten
   ADD CONSTRAINT CHK_Patient_Geschlecht CHECK (Geschlecht IN ('M', 'W', 'D'));
GO

-- 3.2: Temporäre Spalte hinzufügen
ALTER TABLE Behandlungen
   ADD Tmp_Notiz NVARCHAR(255);
GO

-- 3.3: Temporäre Spalte restlos entfernen
ALTER TABLE Behandlungen
DROP
COLUMN Tmp_Notiz;
GO

```