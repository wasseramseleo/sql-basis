### Datei 1: `AKH_Uebungen_Modul7_Aggregation.md`

# Übungssatz: Modul 7 – Aggregation & Gruppierung

## Aufgabe 1: Finanzielle Kennzahlen & Skalare Aggregation (Level 1 - Basic)

* **Lernziel:** Anwendung grundlegender Aggregatfunktionen ohne Gruppierung.
* **Szenario:** Die ärztliche Direktion benötigt einen sofortigen, systemweiten Überblick über die abgerechneten Behandlungskosten.
* **Aufgabenstellung:** Analysieren Sie die Tabelle `Behandlungen`. Ermitteln Sie in einer einzigen Abfrage die Summe aller Kosten, die durchschnittlichen Kosten pro Behandlung, den höchsten abgerechneten Einzelbetrag und die Gesamtanzahl der dokumentierten Behandlungen.
* **Erwartetes Ergebnis:** Eine Tabelle mit exakt einer Zeile und vier Spalten (Gesamtkosten, Durchschnittskosten, Max_Kosten, Anzahl_Behandlungen).
* **Pro-Tipp:** Aggregatfunktionen (außer `COUNT(*)`) ignorieren `NULL`-Werte automatisch. Eine Durchschnittsberechnung über eine Spalte mit `NULL`-Werten verfälscht die Basis, da der Nenner schrumpft.
* **Geschätzte Dauer:** 10 Minuten.

---

## Aufgabe 2: Datenqualität & Die COUNT-Falle (Level 2 - Applied)

* **Lernziel:** Verständnis der `GROUP BY`-Klausel und Beweisführung für das unterschiedliche Verhalten von `COUNT(*)` versus `COUNT(Spalte)`.
* **Szenario:** Das Qualitätsmanagement prüft die Vollständigkeit der Stationszuweisungen. Es muss pro Geschlecht ausgewertet werden, wie viele Patienten registriert sind und wie viele davon tatsächlich einer Station zugewiesen wurden.
* **Aufgabenstellung:** Gruppieren Sie die Tabelle `Patienten` nach dem Attribut `Geschlecht`. Geben Sie das Geschlecht aus. Berechnen Sie daneben die absolute Anzahl der Patienten (`COUNT(*)`) und die Anzahl der Patienten mit einer gültigen Stationszuweisung (`COUNT(StatID)`).
* **Erwartetes Ergebnis:** Drei Zeilen (M, W, D). Die Spalte mit `COUNT(*)` wird bei Flurpatienten höhere Werte aufweisen als `COUNT(StatID)`.
* **Pro-Tipp:** Die "Goldene Regel" der Gruppierung lautet: Jede Spalte im `SELECT`, die nicht in einer Aggregatfunktion steht, *muss* zwingend im `GROUP BY` aufgeführt werden. SQL kann keine granularen und aggregierten Daten ohne Definition der Gruppierungsebene mischen.
* **Geschätzte Dauer:** 15 Minuten.

---

## Aufgabe 3: Kostenstellen-Reporting & HAVING (Level 3 - Expert)

* **Lernziel:** Kombination von Joins, Vorab-Filterung (`WHERE`), Aggregation (`GROUP BY`) und Post-Filterung (`HAVING`).
* **Szenario:** Das Controlling fordert einen Bericht: Welche Stationen generieren bei abgeschlossenen Behandlungen Gesamtkosten von mehr als 10.000,00 Euro?
* **Aufgabenstellung:** Verknüpfen Sie `Stationen`, `Aerzte` und `Behandlungen`. Filtern Sie vorab so, dass nur Behandlungen mit dem Status 'Abgeschlossen' berücksichtigt werden. Gruppieren Sie nach dem Namen der Station. Berechnen Sie die Summe der Kosten. Filtern Sie das gruppierte Endergebnis so, dass nur Stationen mit einer Kostensumme `> 10000` angezeigt werden. Sortieren Sie das Ergebnis absteigend nach den Kosten.
* **Erwartetes Ergebnis:** Eine Liste der kostenintensiven Stationen.
* **Pro-Tipp:** `WHERE` filtert Rohdaten, bevor sie aggregiert werden (Performance-Gewinn). `HAVING` filtert die bereits berechneten Gruppen. Verwenden Sie `HAVING` niemals für Kriterien, die bereits im `WHERE` geprüft werden könnten (z.B. `Status`).
* **Geschätzte Dauer:** 20 Minuten.

---

### Datei 2: `AKH_Loesungen_Modul7_Aggregation.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 7: Aggregation & Gruppierung
-- =========================================================================

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Finanzielle Kennzahlen & Skalare Aggregation (Level 1)
-- -------------------------------------------------------------------------
SELECT 
    SUM(Kosten) AS Gesamtkosten,
    AVG(Kosten) AS Durchschnittskosten,
    MAX(Kosten) AS Max_Kosten,
    COUNT(ID) AS Anzahl_Behandlungen -- COUNT(*) wäre hier ebenfalls valide
FROM 
    Behandlungen;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Datenqualität & Die COUNT-Falle (Level 2)
-- -------------------------------------------------------------------------
-- COUNT(*) zählt physische Zeilen (inklusive NULLs).
-- COUNT(StatID) zählt nur Zeilen, in denen StatID NICHT NULL ist.
SELECT 
    Geschlecht,
    COUNT(*) AS Patienten_Gesamt,
    COUNT(StatID) AS Patienten_Mit_Station
FROM 
    Patienten
GROUP BY 
    Geschlecht;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Kostenstellen-Reporting & HAVING (Level 3)
-- -------------------------------------------------------------------------
SELECT 
    s.Name AS Station,
    SUM(b.Kosten) AS Total_Kosten
FROM 
    Stationen s
INNER JOIN 
    Aerzte a ON s.ID = a.StatID
INNER JOIN 
    Behandlungen b ON a.ID = b.ArztID
WHERE 
    b.Status = 'Abgeschlossen'       -- 1. WHERE: Filtert unfertige Behandlungen VOR der Berechnung
GROUP BY 
    s.Name                           -- 2. GROUP BY: Definiert die Granularität
HAVING 
    SUM(b.Kosten) > 10000.00         -- 3. HAVING: Filtert die fertigen Aggregate
ORDER BY 
    Total_Kosten DESC;               -- 4. ORDER BY: Sortiert die finale Menge
GO

```
