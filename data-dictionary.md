Das ist ein solides Fundament. Ein sauber dokumentiertes Data Dictionary ist für Teilnehmer oft der "Anker", wenn sie sich in komplexen Joins verlieren. Hier ist die Übersicht für deine Kursunterlagen:

---

## 🏥 Data Dictionary: AKH Wien Datenbank

Dieses Dokument beschreibt die Struktur der Übungsdatenbank. Alle Tabellen befinden sich im Schema `dbo`.

### 1. Tabelle: `Stationen`

Speichert Informationen über die klinischen Fachabteilungen und deren Kapazitäten.

| Spalte | Datentyp | Beschreibung | Beispielwert |
| --- | --- | --- | --- |
| **ID** | INT (PK) | Eindeutige Identifikationsnummer (Auto-Inkrement) | 1 |
| **Name** | NVARCHAR(100) | Name der Station | Kardiologie Nord |
| **Fachbereich** | NVARCHAR(100) | Medizinisches Fachgebiet | Innere Medizin |
| **Stockwerk** | INT | Stockwerk im AKH Hauptgebäude | 14 |
| **BettenAnzahl** | INT | Maximale Kapazität der Station | 25 |

### 2. Tabelle: `Aerzte`

Enthält das medizinische Personal und deren primäre Zuweisung zu einer Station.

| Spalte | Datentyp | Beschreibung | Beispielwert |
| --- | --- | --- | --- |
| **ID** | INT (PK) | Eindeutige Arzt-ID | 101 |
| **Nachname** | NVARCHAR(100) | Familienname | Gruber |
| **Vorname** | NVARCHAR(100) | Vorname | Maria |
| **Titel** | NVARCHAR(50) | Akademischer Grad | Dr. med. univ. |
| **Fachrichtung** | NVARCHAR(100) | Spezialisierung | Onkologie |
| **StatID** | INT (FK) | Verknüpfung zu `Stationen.ID` | 3 |

### 3. Tabelle: `Patienten`

Das aktuelle Patientenregister. **Wichtig:** Die Spalte `StatID` kann `NULL` sein, wenn ein Patient noch nicht zugewiesen wurde.

| Spalte | Datentyp | Beschreibung | Beispielwert |
| --- | --- | --- | --- |
| **ID** | INT (PK) | Eindeutige Patienten-ID | 5001 |
| **Nachname** | NVARCHAR(100) | Familienname | Huber |
| **Vorname** | NVARCHAR(100) | Vorname | Stefan |
| **GebDatum** | DATE | Geburtsdatum | 1985-05-12 |
| **SVNummer** | CHAR(10) | Sozialversicherungsnummer (Eindeutig) | 1234120585 |
| **Geschlecht** | CHAR(1) | M (Männlich), W (Weiblich), D (Divers) | M |
| **StatID** | INT (FK) | Aktuelle Station (NULL erlaubt) | 1 |

### 4. Tabelle: `Patienten_Archiv`

Historische Daten entlassener Patienten für Mengenoperationen (`UNION`, `EXCEPT`).

* **Hinweis:** Struktur ist identisch mit der Tabelle `Patienten`, enthält jedoch keine automatische ID-Generierung, um den Import von Altdaten zu simulieren.

### 5. Tabelle: `Behandlungen`

Protokolliert alle medizinischen Leistungen und die damit verbundenen Kosten.

| Spalte | Datentyp | Beschreibung | Beispielwert |
| --- | --- | --- | --- |
| **ID** | INT (PK) | Transaktionsnummer der Behandlung | 90001 |
| **PatID** | INT (FK) | Betroffener Patient (`Patienten.ID`) | 5001 |
| **ArztID** | INT (FK) | Behandelnder Arzt (`Aerzte.ID`) | 101 |
| **Datum** | DATETIME2 | Zeitpunkt der Behandlung | 2026-03-04 10:30 |
| **DiagnoseCode** | NVARCHAR(20) | ICD-10 Code der Diagnose | I10.0 (Bluthochdruck) |
| **Kosten** | DECIMAL(18,2) | Kosten der Leistung in Euro | 450.50 |
| **Status** | NVARCHAR(50) | Abrechnungsstatus | Abgeschlossen |

---

> **Didaktischer Hinweis:** Die `SVNummer` ist als `CHAR(10)` definiert, da sie immer exakt 10 Stellen hat – ein guter Aufhänger, um den Unterschied zu `VARCHAR` zu erklären.

Soll ich dir nun für den **Tag 2** (Modul 6: Joins) die erste konkrete Übungsserie generieren, die direkt auf diesen Tabellen und IDs aufbaut?