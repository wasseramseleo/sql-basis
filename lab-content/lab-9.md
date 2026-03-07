### Datei 1: `AKH_Uebungen_Modul10_Mengen_Subqueries.md`

# Übungssatz: Modul 10 – Mengenoperationen & Subqueries

# Aufgabe 1: Historische Datenfusion & Performance

### Lernziel

Vertikales Zusammenführen von Datensätzen und kritische Bewertung des Performance-Unterschieds zwischen `UNION` und
`UNION ALL`.

### Szenario

Die Rechtsabteilung fordert eine lückenlose Liste aller jemals vergebenen Sozialversicherungsnummern. Aktuelle und
archivierte Datensätze müssen kombiniert werden.

### Aufgabenstellung

Extrahieren Sie die Spalte `SVNummer` aus der Tabelle `Patienten` sowie aus der Tabelle `Patienten_Archiv`. Verbinden
Sie beide Abfragen einmal mittels `UNION` und in einer zweiten Abfrage mittels `UNION ALL`.

### Erwartetes Ergebnis

Zwei syntaktisch ähnliche Abfragen mit potenziell unterschiedlichen Zeilenanzahlen.

### Tipp

Nutzen Sie standardmäßig `UNION ALL`. Das einfache `UNION` erzwingt eine
ressourcenintensive Sortierung (`DISTINCT`-Operation) in der `tempdb`, um Duplikate zu entfernen. Setzen Sie es nur ein,
wenn Duplikatfreiheit fachlich zwingend erforderlich ist.


---

# Aufgabe 2: Anomalie-Erkennung via Subquery

### Lernziel

Einsatz unkorrelierter Subqueries in der `WHERE`-Klausel zur dynamischen Filterung.

### Szenario

Das Controlling sucht nach statistischen Ausreißern. Es sollen alle Behandlungen identifiziert werden, deren Kosten über
dem globalen Durchschnitt liegen.

### Aufgabenstellung

Selektieren Sie `ID`, `Datum` und `Kosten` aus der Tabelle `Behandlungen`. Verwenden Sie eine Subquery in der `WHERE`
-Klausel, um die durchschnittlichen Kosten aller Behandlungen dynamisch zu berechnen. Filtern Sie die Hauptabfrage so,
dass nur Behandlungen mit Kosten über diesem Durchschnitt angezeigt werden.

### Erwartetes Ergebnis

Eine Liste von Behandlungen, gefiltert durch einen dynamisch berechneten Schwellenwert.

### Tipp

Die Subquery auf der rechten Seite des Operators wird vom Query Optimizer (bei unkorrelierten Unterabfragen) exakt
einmal isoliert ausgeführt. Ihr Ergebnis wird gecacht und als skalarer Wert für den Filter der äußeren Abfrage
verwendet.


---

# Aufgabe 3: Mengenfilter ohne Joins

### Lernziel

Nutzung der `IN`-Klausel mit Subqueries als Alternative zu ressourcenintensiven `JOIN`- und `DISTINCT`-Operationen.

### Szenario

Die Finanzbuchhaltung benötigt die Namen jener Patienten, die extrem teure Behandlungen (Kosten > 2000,00 Euro)
verursacht haben. Die Ausgabe von Duplikaten (falls ein Patient mehrere teure Behandlungen hatte) muss vermieden werden.

### Aufgabenstellung

Fragen Sie `Nachname` und `Vorname` aus der Tabelle `Patienten` ab. Filtern Sie das Ergebnis über `WHERE ID IN (...)`.
Die Subquery muss die `PatID` aus der Tabelle `Behandlungen` liefern, bei denen die `Kosten` den Wert 2000 übersteigen.

### Erwartetes Ergebnis

Eine duplikatfreie Liste von Patientennamen.

### Tipp

Ein `INNER JOIN` in Kombination mit `DISTINCT` löst dieses Problem ebenfalls, erzwingt jedoch die Verarbeitung eines
teuren kartesischen Produkts im Hintergrund. Die `IN (Subquery)`- oder `EXISTS (Subquery)`-Methode erlaubt es der
Engine, die Suche nach dem ersten Treffer pro Patient abzubrechen (Semi-Join-Logik). Das ist messbar effizienter.


---

### Datei 2: `AKH_Loesungen_Modul10_Mengen_Subqueries.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 10: Mengenoperationen & Subqueries
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Historische Datenfusion & Performance
-- -------------------------------------------------------------------------

-- Variante A: UNION (Mit impliziter Duplikatprüfung -> Hoher CPU/I/O-Aufwand)
SELECT SVNummer
FROM Patienten
UNION
SELECT SVNummer
FROM Patienten_Archiv;
GO

-- Variante B: UNION ALL (Ohne Prüfung -> Maximale Performance)
SELECT SVNummer
FROM Patienten
UNION ALL
SELECT SVNummer
FROM Patienten_Archiv;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Anomalie-Erkennung via Subquery
-- -------------------------------------------------------------------------
SELECT ID,
       Datum,
       Kosten
FROM Behandlungen
WHERE Kosten > (
    -- Unkorrelierte Subquery berechnet den globalen Schnitt
    SELECT AVG(Kosten)
    FROM Behandlungen);
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Mengenfilter ohne Joins
-- -------------------------------------------------------------------------
SELECT Nachname,
       Vorname
FROM Patienten
WHERE ID IN (
    -- Subquery liefert die isolierte Menge an Patienten-IDs
    SELECT PatID
    FROM Behandlungen
    WHERE Kosten > 2000.00);
GO

```