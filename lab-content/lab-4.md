Hier sind die Übungsunterlagen für Modul 5. Die Aufgaben erzwingen präzises Arbeiten mit der Prädikatenlogik von SQL.

---

### Datei 1: `AKH_Uebungen_Modul5_Filterung.md`

# Übungssatz: Modul 5 – Daten-Setup & Filterung

Nach dem erfolgreichen Restore des erweiterten AKH-Backups arbeiten wir nun mit der vollen Datenmenge.

## Aufgabe 1: Kostenkontrolle & Mengenfilter (Level 1 - Basic)

* **Lernziel:** Anwendung von `BETWEEN` und `IN` zur effizienten Filterung von Wertebereichen und Listen.
* **Szenario:** Die Buchhaltung reklamiert ungewöhnliche Schwankungen bei Standardbehandlungen. Es wird eine Prüfliste benötigt.
* **Aufgabenstellung:** Selektieren Sie alle Einträge aus der Tabelle `Behandlungen`. Filtern Sie die Ergebnisse so, dass nur Behandlungen mit `Kosten` zwischen 500,00 und 2000,00 Euro angezeigt werden. Schränken Sie die Ergebnismenge zusätzlich auf den `Status` 'Abgeschlossen' oder 'Storniert' ein. Nutzen Sie dafür die `IN`-Klausel.
* **Erwartetes Ergebnis:** Eine gefilterte Liste der Behandlungen.
* **Pro-Tipp:** `BETWEEN` schließt die Randwerte (500 und 2000) immer mit ein (inklusiv). Für exklusive Suchen müssen Sie `>`, `<` verwenden.
* **Geschätzte Dauer:** 10 Minuten.

---

## Aufgabe 2: Operator-Präzedenz bei AND/OR (Level 2 - Applied)

* **Lernziel:** Korrekte Klammersetzung bei der Kombination von `AND` und `OR`.
* **Szenario:** Die medizinische Forschung sucht für eine Studie zur Gendermedizin spezifische demografische Gruppen. Ein Skript eines Assistenzarztes liefert unplausible (viel zu viele) Ergebnisse.
* **Aufgabenstellung:** Fragen Sie die Tabelle `Patienten` ab. Finden Sie alle weiblichen ('W') oder diversen ('D') Patienten, die *nach* dem 31.12.1990 geboren wurden. Der Fehler im Arztskript war fehlende Klammersetzung. Beweisen Sie kritisches Denken und setzen Sie die logischen Operatoren korrekt.
* **Erwartetes Ergebnis:** Eine Liste junger Patientinnen und diverser Patienten. Keine männlichen Patienten, keine Personen geboren vor 1991.
* **Pro-Tipp:** `AND` bindet stärker als `OR` (ähnlich der Punkt-vor-Strich-Rechnung). Ohne Klammern wertet SQL zuerst die `AND`-Bedingung aus und hängt das `OR` unlimitiert an den Schluss.
* **Geschätzte Dauer:** 15 Minuten.

---

## Aufgabe 3: Die Three-Valued Logic Falle (Level 3 - Expert)

* **Lernziel:** Beherrschung der `NULL`-Logik und Vermeidung von Phantom-Ergebnissen.
* **Szenario:** Bei Engpässen im AKH werden Patienten vorübergehend auf Gängen ("Flurpatienten") geparkt, bevor sie einer offiziellen Station zugewiesen werden. Das Bettenmanagement braucht diese Liste akut.
* **Aufgabenstellung:** Suchen Sie in der Tabelle `Patienten` alle Personen, die aktuell keiner Station zugewiesen sind (die `StatID` ist leer). Probieren Sie testweise die Abfrage mit `WHERE StatID = NULL` aus. Korrigieren Sie den Code anschließend auf die nach SQL-Standard valide Syntax.
* **Erwartetes Ergebnis:** Eine Liste von Patienten ohne zugewiesene Station.
* **Pro-Tipp:**  SQL verwendet eine dreiwertige Logik (Three-Valued Logic: True, False, Unknown). `NULL` bedeutet "Unbekannt". Der Vergleich "Ist Unbekannt gleich Unbekannt?" (`= NULL`) ergibt niemals "True", sondern wieder "Unbekannt" (`NULL`). Daher filtert die Engine die Zeile aus. Die einzige korrekte Prüfung ist `IS NULL` oder `IS NOT NULL`.
* **Geschätzte Dauer:** 10 Minuten.

---

### Datei 2: `AKH_Loesungen_Modul5_Filterung.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 5: Daten-Setup & Filterung
-- =========================================================================

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Kostenkontrolle & Mengenfilter (Level 1)
-- -------------------------------------------------------------------------
SELECT 
    ID,
    PatID,
    ArztID,
    Datum,
    Kosten,
    Status
FROM 
    Behandlungen
WHERE 
    Kosten BETWEEN 500.00 AND 2000.00
    AND Status IN ('Abgeschlossen', 'Storniert');
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Operator-Präzedenz bei AND/OR (Level 2)
-- -------------------------------------------------------------------------
-- FALSCH (ohne Klammern): Liefert alle Diversen (egal welches Alter) 
-- UND weibliche Patienten nach 1990.
/*
SELECT * FROM Patienten 
WHERE Geschlecht = 'D' OR Geschlecht = 'W' AND GebDatum > '1990-12-31';
*/

-- KORREKT (mit Klammern): Isoliert die OR-Logik vor der AND-Prüfung.
SELECT 
    ID,
    Nachname,
    Vorname,
    GebDatum,
    Geschlecht
FROM 
    Patienten
WHERE 
    (Geschlecht = 'W' OR Geschlecht = 'D') 
    AND GebDatum > '1990-12-31';
GO

-- Alternative (und sauberere) Lösung mit IN:
SELECT 
    ID,
    Nachname,
    Vorname,
    GebDatum,
    Geschlecht
FROM 
    Patienten
WHERE 
    Geschlecht IN ('W', 'D') 
    AND GebDatum > '1990-12-31';
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Die Three-Valued Logic Falle (Level 3)
-- -------------------------------------------------------------------------
-- FEHLERHAFT (liefert 0 Zeilen, da NULL = NULL -> UNKNOWN ergibt):
-- SELECT * FROM Patienten WHERE StatID = NULL;

-- KORREKT:
SELECT 
    ID,
    Nachname,
    Vorname,
    SVNummer
FROM 
    Patienten
WHERE 
    StatID IS NULL;
GO

```

Soll ich als Nächstes die Übungen für Modul 6 (Joins – Das Herz von SQL) generieren, um die isolierten Tabellen endlich zusammenzuführen?