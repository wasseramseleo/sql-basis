Die Anforderung ist verstanden. Da Modul 2 den Fokus auf visuelles Design legt, die Vorgaben aber explizit T-SQL als Lösungsformat fordern, bilden die Musterlösungen das physische DDL-Skript ab, welches das SSMS Database Diagram Tool im Hintergrund generiert.

Hier sind die Übungsunterlagen für Modul 2.

---

### Datei 1: `AKH_Uebungen_Modul2_ERM.md`

# Übungssatz: Modul 2 – ERM & Datenbankdesign

## Aufgabe 1: Fundament der Stationen (Level 1 - Basic)

* **Lernziel:** Definition einer Entität, Identifikation von Primärschlüsseln und Datentypen.
* **Szenario:** Die Direktion des AKH Wien benötigt eine digitale Übersicht aller bettenführenden Abteilungen.
* **Aufgabenstellung:** Modellieren Sie die Entität `Stationen`. Definieren Sie einen eindeutigen Identifikator (ID) als Primärschlüssel. Fügen Sie Attribute für Name, Fachbereich, Stockwerk und die Anzahl der Betten hinzu.
* **Erwartetes Ergebnis:** Eine Entität mit 5 Attributen und einem definierten Primary Key (PK).
* **Pro-Tipp:** Nutzen Sie für IDs immer den Datentyp `INT` mit einer Identity-Spezifikation (Auto-Inkrement), um manuelle Fehler bei der Schlüsselvergabe zu eliminieren.
* **Geschätzte Dauer:** 10 Minuten.

---

## Aufgabe 2: Patientenaufnahme & 1:n Beziehung (Level 2 - Applied)

* **Lernziel:** Erstellung von Fremdschlüsseln (FK) und Modellierung einer 1:n-Kardinalität.
* **Szenario:** Patienten müssen bei der Aufnahme einer Stammstation zugewiesen werden. Ein Patient liegt physisch immer nur auf einer Station, eine Station hat jedoch viele Patienten.
* **Aufgabenstellung:** Modellieren Sie die Entität `Patienten` mit den Attributen ID (PK), Nachname, Vorname, GebDatum, SVNummer und Geschlecht. Etablieren Sie eine 1:n-Beziehung zur Entität `Stationen`.
* **Erwartetes Ergebnis:** Die Entität `Patienten` besitzt einen Fremdschlüssel `StatID`, der auf die ID der Stationen-Tabelle verweist.
* **Pro-Tipp:** Die SVNummer in Österreich hat exakt 10 Stellen (4-stelliges Kürzel + 6-stelliges Geburtsdatum). Ein `CHAR(10)` ist hier performanter und sicherer als ein `VARCHAR`.
* **Geschätzte Dauer:** 15 Minuten.

---

## Aufgabe 3: Behandlungslogik & m:n Auflösung (Level 3 - Expert)

* **Lernziel:** Auflösung komplexer m:n-Beziehungen durch eine Assoziationstabelle (Verknüpfungstabelle) und Implementierung von Check-Constraints.
* **Szenario:** Das Controlling fordert eine detaillierte Leistungsverrechnung. Ein Patient kann von mehreren Ärzten behandelt werden, und ein Arzt behandelt viele Patienten.
* **Aufgabenstellung:** Entwerfen Sie eine Struktur zur Erfassung von Behandlungen. Erstellen Sie gedanklich die Entität `Aerzte` (ID, Nachname, Vorname, Fachrichtung, StatID). Lösen Sie die m:n-Beziehung zwischen `Patienten` und `Aerzte` durch eine neue Entität `Behandlungen` auf. Diese muss das Behandlungsdatum, den DiagnoseCode (ICD-10) und die anfallenden Kosten erfassen. Kosten dürfen niemals negativ sein.
* **Erwartetes Ergebnis:** Drei verknüpfte Entitäten. `Behandlungen` fungiert als Assoziationstabelle mit zwei Fremdschlüsseln (PatID, ArztID) und einem Check-Constraint für die Kosten.
* **Pro-Tipp:** Vermeiden Sie zusammengesetzte Primärschlüssel (Composite Keys) in Assoziationstabellen, wenn diese später referenziert werden sollen. Ein eigener Surrogate Key (`ID INT IDENTITY`) für die Tabelle `Behandlungen` erleichtert zukünftige Erweiterungen (z.B. für eine Tabelle "Medikation_pro_Behandlung").
* **Geschätzte Dauer:** 25 Minuten.

---

### Datei 2: `AKH_Loesungen_Modul2_ERM.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 2: ERM & Datenbankdesign (Generiertes DDL)
-- =========================================================================

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Fundament der Stationen (Level 1)
-- -------------------------------------------------------------------------
CREATE TABLE Stationen (
    ID INT IDENTITY(1,1) PRIMARY KEY,       -- Surrogate Key, Auto-Inkrement
    Name NVARCHAR(100) NOT NULL,
    Fachbereich NVARCHAR(100) NOT NULL,
    Stockwerk INT NOT NULL,
    BettenAnzahl INT CHECK (BettenAnzahl > 0) -- Logische Validierung: Keine negativen Betten
);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Patientenaufnahme & 1:n Beziehung (Level 2)
-- -------------------------------------------------------------------------
CREATE TABLE Patienten (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nachname NVARCHAR(100) NOT NULL,
    Vorname NVARCHAR(100) NOT NULL,
    GebDatum DATE NOT NULL,
    SVNummer CHAR(10) UNIQUE NOT NULL,      -- Eindeutigkeit der Sozialversicherungsnummer erzwingen
    Geschlecht CHAR(1) CHECK (Geschlecht IN ('M', 'W', 'D')),
    StatID INT FOREIGN KEY REFERENCES Stationen(ID) NULL -- FK zu Stationen. NULL erlaubt, falls Patient noch nicht zugewiesen ist.
);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Behandlungslogik & m:n Auflösung (Level 3)
-- -------------------------------------------------------------------------

-- 1. Voraussetzung: Entität Aerzte erstellen
CREATE TABLE Aerzte (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nachname NVARCHAR(100) NOT NULL,
    Vorname NVARCHAR(100) NOT NULL,
    Titel NVARCHAR(50),
    Fachrichtung NVARCHAR(100) NOT NULL,
    StatID INT FOREIGN KEY REFERENCES Stationen(ID) -- Ein Arzt ist meist einer Hauptstation zugeteilt
);
GO

-- 2. Auflösung der m:n Beziehung (Patienten <-> Aerzte) durch Assoziationstabelle
CREATE TABLE Behandlungen (
    ID INT IDENTITY(1,1) PRIMARY KEY,       -- Surrogate Key statt Composite PK (PatID + ArztID)
    PatID INT FOREIGN KEY REFERENCES Patienten(ID),
    ArztID INT FOREIGN KEY REFERENCES Aerzte(ID),
    Datum DATETIME2 NOT NULL,               -- DATETIME2 ist präziser und ressourcenschonender als DATETIME
    DiagnoseCode NVARCHAR(20),              -- Ausreichend für ICD-10 (z.B. "I10.00")
    Kosten DECIMAL(18,2) CHECK (Kosten >= 0), -- Kritischer Check: Negativbuchungen auf Datenbankebene verhindern
    Status NVARCHAR(50) DEFAULT 'Abgeschlossen'
);
GO

```

