### Datei 1: `AKH_Uebungen_Modul11_Views_CTEs.md`

# Übungssatz: Modul 11 – Fortgeschrittene Konzepte (Professionalisierung)

Dieses Modul fokussiert sich auf die Wartbarkeit und Kapselung von Logik, um komplexe medizinische Berichte für die
Verwaltung bereitzustellen.

# Aufgabe 1: Kapselung in Views

### Lernziel

Erstellung einer `VIEW` zur Vereinfachung komplexer Join-Strukturen.

### Szenario

Die Stationsleitung benötigt regelmäßig eine Liste der aktuellen Belegungen inklusive Arzt-Informationen. Statt jedes
Mal drei Tabellen manuell zu verknüpfen, soll eine "virtuelle Tabelle" erstellt werden.

### Aufgabenstellung

Erstellen Sie eine View namens `vw_Patienten_Uebersicht`. Diese soll den Vornamen und Nachnamen des Patienten, den Namen
der Station und den Nachnamen des zugewiesenen Arztes enthalten.

### Erwartetes Ergebnis

Eine dauerhaft gespeicherte View, die mit `SELECT * FROM vw_Patienten_Uebersicht` wie eine Tabelle abgefragt werden
kann.

### Tipp

Views speichern keine Daten physisch (außer indexierte Views), sondern nur den Abfrageplan. Sie sind ideal, um
Sicherheitskonzepte umzusetzen, indem man Nutzern nur Zugriff auf die View statt auf die zugrunde liegenden Rohdaten
gewährt.


---

# Aufgabe 2: Strukturierung mit CTEs

### Lernziel

Nutzung von `CTEs` (Common Table Expressions) zur Verbesserung der Lesbarkeit gegenüber Subqueries.

### Szenario

Das Finanz-Reporting soll eine Liste aller Patienten ausgeben, deren Behandlungskosten über dem Klinik-Durchschnitt
liegen. Die Logik aus Modul 10 soll nun lesbar strukturiert werden.

### Aufgabenstellung

Schreiben Sie eine Abfrage unter Verwendung eines `WITH`-Statements (CTE). Berechnen Sie im CTE den Durchschnittswert
der Kosten. Nutzen Sie diesen Wert in der Hauptabfrage, um die Patienten und ihre Kosten zu filtern.

### Erwartetes Ergebnis

Ein strukturierter SQL-Block, der die Logik von der finalen Selektion trennt.

### Tipp

CTEs machen Code modular. Während Subqueries oft "von innen nach außen" gelesen werden müssen, erlaubt eine CTE einen
linearen Lesefluss von oben nach unten.



---

# Aufgabe 3: Korrelierte Subqueries

### Lernziel

Verständnis der zeilenweisen Interaktion zwischen Haupt- und Unterabfrage.

### Szenario

Die ärztliche Direktion möchte für jeden Patienten wissen, wie hoch seine letzte Behandlung im Vergleich zu *seinen
eigenen* durchschnittlichen Behandlungskosten war.

### Aufgabenstellung

Erstellen Sie eine Abfrage auf `Behandlungen`. Geben Sie `PatID`, `Datum` und `Kosten` aus. Fügen Sie eine berechnete
Spalte hinzu, die mittels einer korrelierten Subquery den Durchschnitt der Kosten *nur für diesen spezifischen
Patienten* ermittelt.

### Erwartetes Ergebnis

Eine Liste, bei der in jeder Zeile der individuelle Durchschnitt des jeweiligen Patienten als Vergleichswert steht.

### Tipp

Im Gegensatz zu unkorrelierten Subqueries wird eine korrelierte Subquery für jede Zeile der äußeren Abfrage neu
evaluiert. Bei sehr großen Datenmengen im AKH kann dies die Performance beeinträchtigen. Hier sind oft Window
Functions (wie `AVG() OVER(...)`) die effizientere, fortgeschrittene Alternative.


---

### Datei 2: `AKH_Loesungen_Modul11_Views_CTEs.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 11: Fortgeschrittene Konzepte
-- =========================================================================
USE
AKH_Wien;
GO
-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Kapselung in Views
-- -------------------------------------------------------------------------
GO
CREATE VIEW vw_Patienten_Uebersicht AS
SELECT p.Vorname  AS Patient_Vorname,
       p.Nachname AS Patient_Nachname,
       s.Name     AS Station,
       a.Nachname AS Behandelnder_Arzt
FROM Patienten p
         LEFT JOIN
     Stationen s ON p.StatID = s.ID
         LEFT JOIN
     Behandlungen b ON p.ID = b.PatID
         LEFT JOIN
     Aerzte a ON b.ArztID = a.ID;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Strukturierung mit CTEs
-- -------------------------------------------------------------------------
WITH KostenStatistik AS (
    -- Die CTE berechnet den globalen Wert vorab
    SELECT AVG(Kosten) AS Schnitt
    FROM Behandlungen
)
SELECT p.Nachname,
       b.Kosten,
       ks.Schnitt AS Globaler_Durchschnitt
FROM Patienten p
         JOIN
     Behandlungen b ON p.ID = b.PatID
         CROSS JOIN
     KostenStatistik ks -- Verbindet den einen Skalarwert mit allen Zeilen
WHERE b.Kosten > ks.Schnitt;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Korrelierte Subqueries
-- -------------------------------------------------------------------------
SELECT b1.PatID,
       b1.Datum,
       b1.Kosten,
       (
           -- Die Subquery referenziert die äußere Tabelle (b1)
           SELECT AVG(b2.Kosten)
           FROM Behandlungen b2
           WHERE b2.PatID = b1.PatID) AS Patienten_Eigen_Durchschnitt
FROM Behandlungen b1
ORDER BY b1.PatID;
GO

```
