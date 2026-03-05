### Datei 1: `AKH_Uebungen_Modul8_Formatierung.md`

# Übungssatz: Modul 8 – Sortierung & Formatierung

Die rohen Datenbankausgaben sind für medizinisches Personal schwer lesbar. Dieser Übungssatz trainiert die kritische Datenaufbereitung für das Frontend.

## Aufgabe 1: Europäische Datumsstandards & Multi-Sortierung (Level 1 - Basic)

* **Lernziel:** Anwendung von `ORDER BY` über mehrere Ebenen und Konvertierung von ISO-Datumsformaten in den lokalen Standard.
* **Szenario:** Die Verwaltung fordert ein gedrucktes Telefonbuch der Patienten. Das Geburtsdatum muss zwingend im österreichischen Standard (TT.MM.JJJJ) vorliegen.
* **Aufgabenstellung:** Selektieren Sie `Nachname`, `Vorname` und `GebDatum` aus der Tabelle `Patienten`. Formatieren Sie das `GebDatum` in das Format `dd.MM.yyyy`. Sortieren Sie die resultierende Liste alphabetisch nach dem Nachnamen und bei Gleichstand nach dem Vornamen.
* **Erwartetes Ergebnis:** Eine formatierte, lexikografisch korrekt sortierte Liste.
* **Pro-Tipp:** Die T-SQL Funktion `FORMAT(Datum, 'dd.MM.yyyy')` ist komfortabel, birgt aber bei großen Datenmengen signifikante Performance-Einbußen. Evidenzbasierte Best Practice für Hochleistungssysteme ist `CONVERT(VARCHAR, Datum, 104)`.
* **Geschätzte Dauer:** 10 Minuten.

---

## Aufgabe 2: String-Manipulation für Dienstpläne (Level 2 - Applied)

* **Lernziel:** Verknüpfung von Zeichenketten (`CONCAT`) und Extraktion von Teilstrings (`LEFT` / `SUBSTRING`).
* **Szenario:** Das KIS (Krankenhausinformationssystem) benötigt für den Dienstplan ein stark verkürztes Namensformat für Ärzte: "Titel Nachname, V." (z.B. "Prof. Müller, A.").
* **Aufgabenstellung:** Generieren Sie aus der Tabelle `Aerzte` eine einzige Spalte namens `AnzeigeName`. Extrahieren Sie den ersten Buchstaben des Vornamens. Verbinden Sie den (optionalen) Titel, den Nachnamen und den initialen Vornamen mit den korrekten Leerzeichen und Satzzeichen.
* **Erwartetes Ergebnis:** Eine Spalte mit dem exakt formatierten Kurznamen für alle verzeichneten Ärzte.
* **Pro-Tipp:**  Die Nutzung des `+` Operators für Strings führt zu einem `NULL`-Ergebnis, wenn ein einziger Bestandteil (wie der Titel) `NULL` ist. Die Funktion `CONCAT()` wandelt `NULL` intern in leere Strings um und ist daher die fehlertolerantere Wahl.
* **Geschätzte Dauer:** 15 Minuten.

---

## Aufgabe 3: Klinische Zeitdifferenzen messen (Level 3 - Expert)

* **Lernziel:** Berechnung von Zeitintervallen mittels `DATEDIFF` und `GETDATE()` zur Überwachung von Liegezeiten oder Behandlungsaltern.
* **Szenario:** Das Controlling überwacht offene Behandlungsfälle. Es muss berechnet werden, wie viele Tage eine Behandlung exakt in der Vergangenheit liegt, um Verjährungen bei der Abrechnung zu verhindern.
* **Aufgabenstellung:** Nutzen Sie die Tabelle `Behandlungen`. Geben Sie die `ID`, den `DiagnoseCode` und das `Datum` aus. Berechnen Sie die Differenz in Tagen zwischen dem Behandlungsdatum und der aktuellen Systemzeit (`GETDATE()`). Nennen Sie die Spalte `Tage_Vergangen`. Sortieren Sie die Liste so, dass die ältesten Behandlungen ganz oben stehen.
* **Erwartetes Ergebnis:** Eine chronologisch absteigend sortierte Liste (ältester Fall zuerst) mit der exakten Tagesdifferenz zur Gegenwart.
* **Pro-Tipp:** `DATEDIFF(day, Start, Ende)` zählt ausschließlich die überschrittenen Mitternachtsgrenzen, nicht die absoluten 24-Stunden-Zyklen. Wenn eine medizinisch kritische Liegedauer (z.B. für Antibiotika-Gaben) ermittelt werden muss, ist `DATEDIFF(hour, Start, Ende) / 24.0` die präzisere Methode.
* **Geschätzte Dauer:** 15 Minuten.

---

### Datei 2: `AKH_Loesungen_Modul8_Formatierung.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 8: Sortierung & Formatierung
-- =========================================================================

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Europäische Datumsstandards & Multi-Sortierung (Level 1)
-- -------------------------------------------------------------------------
SELECT 
    Nachname,
    Vorname,
    CONVERT(VARCHAR, GebDatum, 104) AS GebDatum_AT -- 104 entspricht dem deutschen/österreichischen Format (dd.mm.yyyy)
FROM 
    Patienten
ORDER BY 
    Nachname ASC, 
    Vorname ASC;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: String-Manipulation für Dienstpläne (Level 2)
-- -------------------------------------------------------------------------
SELECT 
    -- LTRIM entfernt ein potenziell führendes Leerzeichen, falls der Titel NULL ist
    LTRIM(CONCAT(Titel, ' ', Nachname, ', ', LEFT(Vorname, 1), '.')) AS AnzeigeName
FROM 
    Aerzte
ORDER BY 
    Nachname ASC;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Klinische Zeitdifferenzen messen (Level 3)
-- -------------------------------------------------------------------------
SELECT 
    ID,
    DiagnoseCode,
    Datum,
    DATEDIFF(day, Datum, GETDATE()) AS Tage_Vergangen
FROM 
    Behandlungen
ORDER BY 
    Tage_Vergangen DESC; -- Älteste Datensätze zuerst (höchste Differenz)
GO

```
