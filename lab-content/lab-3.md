### Datei 1: `AKH_Uebungen_Modul4_DQL_Basic.md`

# Übungssatz: Modul 4 – Erste Selektionen & Syntax-Regeln

## Aufgabe 1: Die SELECT-Anatomie & Aliase (Level 1 - Basic)

* **Lernziel:** Grundstruktur der Datenabfrage und Umbenennung von Spalten für Endanwender.
* **Szenario:** Der Empfangsschalter benötigt eine gut lesbare Liste aller registrierten Patienten. Technische Spaltennamen sind für das Personal verwirrend.
* **Aufgabenstellung:** Erstellen Sie eine `SELECT`-Abfrage auf die Tabelle `Patient`. Geben Sie die Spalten `Vorname`, `Nachname` und `SVNummer` aus. Vergeben Sie mittels `AS` für die SVNummer den Alias `Sozialversicherungsnummer` und für den Nachnamen den Alias `Familienname`.
* **Erwartetes Ergebnis:** Eine Ergebnismenge mit drei Spalten und angepassten Spaltenüberschriften.
* **Pro-Tipp:** Aliase mit Leerzeichen (z.B. `AS [Meine Spalte]`) sind möglich, verursachen aber in nachgelagerten Reporting-Tools oft Probleme. Verzichten Sie auf Leerzeichen oder nutzen Sie Underscores.
* **Geschätzte Dauer:** 5 Minuten.

---

## Aufgabe 2: Literale & Mathematische Berechnungen (Level 2 - Applied)

* **Lernziel:** Einfügen von statischen Werten (Literalen) und Durchführen einfacher Berechnungen auf Zeilenebene.
* **Szenario:** Das Controlling fordert eine Ad-hoc-Auswertung zur Altersstruktur. Da das exakte Alter komplex zu berechnen ist, reicht vorerst eine Schätzung basierend auf dem Geburtsjahr. Zudem muss in jeder Zeile der fixe Standort "AKH Wien" ausgegeben werden.
* **Aufgabenstellung:** Rufen Sie `Vorname` und `Nachname` aus der Tabelle `Patient` ab. Fügen Sie eine statische Spalte (Literal) mit dem Wert `'AKH Wien'` und dem Alias `Krankenhaus` hinzu. Berechnen Sie das ungefähre Alter durch Subtraktion des Geburtsjahres vom aktuellen Jahr (`YEAR(GETDATE()) - YEAR(GebDatum)`). Nennen Sie diese Spalte `Alter_Geschätzt`.
* **Erwartetes Ergebnis:** Eine Tabelle mit vier Spalten pro Patient, inklusive des statischen Strings und der mathematischen Berechnung.
* **Pro-Tipp:** Die Funktion `YEAR()` isoliert das Jahr aus einem Datum. Beachten Sie: Für medizinisch exakte Altersberechnungen (z.B. für Medikamentendosierungen) ist diese Methode ungeeignet, da sie den Geburtsmonat und -tag ignoriert. Hierfür wird in der Praxis `DATEDIFF` in Kombination mit einer Tagesprüfung verwendet.
* **Geschätzte Dauer:** 15 Minuten.

---

## Aufgabe 3: Logische Verarbeitungsreihenfolge (Level 3 - Expert)

* **Lernziel:** Verständnis der Diskrepanz zwischen SQL-Schreibweise (Syntax) und der internen Engine-Ausführung (Logical Processing Order).
* **Szenario:** Ein Junior-Entwickler versucht, alle Patienten zu filtern, die schätzungsweise älter als 50 Jahre sind. Er schreibt `WHERE Alter_Geschätzt > 50` und erhält einen Syntaxfehler.
* **Aufgabenstellung:**  Analysieren Sie, warum die `WHERE`-Klausel einen im `SELECT` definierten Alias nicht erkennt. Schreiben Sie die Abfrage aus Aufgabe 2 so um, dass nur Patienten angezeigt werden, deren geschätztes Alter größer als 50 ist.
* **Erwartetes Ergebnis:** Eine funktionierende Abfrage, die beweist, dass die Logik der `WHERE`-Klausel *vor* der `SELECT`-Klausel ausgeführt wird.
* **Pro-Tipp:** Der SQL Server verarbeitet Abfragen in dieser Reihenfolge: `FROM` -> `WHERE` -> `GROUP BY` -> `HAVING` -> `SELECT` -> `ORDER BY`. Da `SELECT` erst nach `WHERE` ausgeführt wird, existiert der Alias zum Zeitpunkt der Filterung schlichtweg noch nicht. Sie müssen die Berechnung im `WHERE` wiederholen.
* **Geschätzte Dauer:** 15 Minuten.

---

### Datei 2: `AKH_Loesungen_Modul4_DQL_Basic.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 4: Erste Selektionen & Syntax-Regeln
-- =========================================================================

-- -------------------------------------------------------------------------
-- Setup: Testdaten für Modul 4 (Manuelle Dateneingabe laut Curriculum)
-- -------------------------------------------------------------------------
-- Falls Tabellen leer sind, fügen wir Basisdaten ein, um Constraints zu prüfen
INSERT INTO Station (Name, Stockwerk) 
VALUES ('Kardiologie', 3), ('Onkologie', 5);

INSERT INTO Patient (Nachname, Vorname, GebDatum, SVNummer, StatID)
VALUES 
('Müller', 'Anna', '1965-04-12', '1234120465', 1),
('Bauer', 'Josef', '1988-11-23', '5678231188', 2),
('Huber', 'Maria', '1940-01-05', '9012050140', 1);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Die SELECT-Anatomie & Aliase (Level 1)
-- -------------------------------------------------------------------------
SELECT 
    Vorname, 
    Nachname AS Familienname, 
    SVNummer AS Sozialversicherungsnummer
FROM 
    Patient;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Literale & Mathematische Berechnungen (Level 2)
-- -------------------------------------------------------------------------
SELECT 
    Vorname, 
    Nachname, 
    'AKH Wien' AS Krankenhaus,                      -- Literal (statischer Wert)
    YEAR(GETDATE()) - YEAR(GebDatum) AS Alter_Geschaetzt -- Einfache Berechnung
FROM 
    Patient;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Logische Verarbeitungsreihenfolge (Level 3)
-- -------------------------------------------------------------------------
-- FEHLERHAFT: WHERE Alter_Geschaetzt > 50 (Alias ist hier noch unbekannt)
-- KORREKT: Berechnung muss in der WHERE-Klausel wiederholt werden.

SELECT 
    Vorname, 
    Nachname, 
    YEAR(GETDATE()) - YEAR(GebDatum) AS Alter_Geschaetzt
FROM 
    Patient
WHERE 
    (YEAR(GETDATE()) - YEAR(GebDatum)) > 50; 
GO

```

Möchten Sie als nächstes die Übungsreihe für Tag 2, Modul 5 (Daten-Setup, `WHERE`-Filterung & NULL-Logik) konzipieren?