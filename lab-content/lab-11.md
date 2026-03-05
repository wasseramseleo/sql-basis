### Datei 1: `AKH_Uebungen_Modul12_Abschlussprojekt.md`

# Finales Kursprojekt: AKH-Reporting Dashboard

Das Abschlussmodul bündelt alle Kompetenzen der letzten drei Tage zu einem zusammenhängenden Management-Dashboard. Sie übernehmen die Rolle des Lead Data Analysts und liefern der Klinikleitung geschäftskritische Kennzahlen.

## Die Mission: Der "Shift-Leader-Report"

Die Klinikleitung benötigt ein konsolidiertes Reporting-Skript, das vier zentrale Fragestellungen beantwortet. Achten Sie auf **sauberen Code**, **aussagekräftige Aliase** und **korrekte Datentypen**.

---

### Teilaufgabe 1: Die Auslastungs-Analyse (Komplexer Join & Aggregation)

* **Szenario:** Welche Stationen sind am stärksten belegt?
* **Aufgabenstellung:** Erstellen Sie eine Liste aller Stationen. Geben Sie den Namen der Station, das Stockwerk und die Anzahl der aktuell zugewiesenen Patienten aus. Berechnen Sie zusätzlich die "Auslastungsquote" in Prozent (Patienten / BettenAnzahl * 100).
* **Erwartung:** Eine Liste, sortiert nach der höchsten Auslastungsquote.

### Teilaufgabe 2: Finanzielle Performance nach Fachbereich (Grouping & Having)

* **Szenario:** Das Controlling muss wissen, welche medizinischen Fachbereiche die höchsten Umsätze generieren.
* **Aufgabenstellung:** Gruppieren Sie alle Behandlungen nach dem `Fachbereich` der Station. Berechnen Sie die Summe der Kosten und die Anzahl der Behandlungen. Berücksichtigen Sie nur "Abgeschlossene" Behandlungen und zeigen Sie nur Fachbereiche an, die mehr als 5.000,00 Euro Gesamtumsatz erzielt haben.

### Teilaufgabe 3: Patienten-Risiko-Profil (Subqueries & DQL)

* **Szenario:** Identifikation von Patienten mit überdurchschnittlich häufigen Krankenhausaufenthalten.
* **Aufgabenstellung:** Finden Sie alle Patienten (Vorname, Nachname), die öfter im System vorkommen als der Durchschnitt aller Patienten. Nutzen Sie hierfür eine Subquery oder eine CTE zur Ermittlung des Durchschnitts der Behandlungen pro Patient.

### Teilaufgabe 4: Das "Ärzte-Dashboard" (String- & Datumsfunktionen)

* **Szenario:** Eine Übersicht für das Personalbüro.
* **Aufgabenstellung:** Erstellen Sie eine Liste aller Ärzte. Formatieren Sie den Namen als "NACHNAME, Vorname (Titel)". Berechnen Sie in einer weiteren Spalte, wie viele Behandlungen dieser Arzt im aktuellen Kalenderjahr bereits durchgeführt hat.

---

**Pro-Tipp für das Review:**
Ein Senior Database Architect achtet nicht nur auf das Ergebnis, sondern auf die Wartbarkeit. Nutzen Sie Kommentare (`--`), einheitliche Einrückungen und aussagekräftige Tabellen-Aliase (`p` für Patienten, `s` für Stationen).

**Geschätzte Dauer:** 60 - 90 Minuten.

---

### Datei 2: `AKH_Loesungen_Modul12_Abschlussprojekt.sql`

```sql
-- =========================================================================
-- FINALE MUSTERLÖSUNG: AKH-Reporting Dashboard
-- Autor: Senior Database Architect
-- =========================================================================

/* TEIL 1: Auslastungs-Analyse
   Techniken: LEFT JOIN, Aggregation, Mathematische Berechnung
*/
SELECT 
    s.Name AS Stationsname,
    s.Stockwerk,
    COUNT(p.ID) AS Patienten_Anzahl,
    s.BettenAnzahl,
    -- CAST auf DECIMAL verhindert eine Integer-Division (Ergebnis 0)
    CAST(COUNT(p.ID) AS DECIMAL(5,2)) / s.BettenAnzahl * 100 AS Auslastung_Prozent
FROM 
    Stationen s
LEFT JOIN 
    Patienten p ON s.ID = p.StatID
GROUP BY 
    s.Name, s.Stockwerk, s.BettenAnzahl
ORDER BY 
    Auslastung_Prozent DESC;
GO

/* TEIL 2: Finanzielle Performance nach Fachbereich
   Techniken: Multi-Join, WHERE, HAVING, SUM
*/
SELECT 
    s.Fachbereich,
    SUM(b.Kosten) AS Gesamtumsatz,
    COUNT(b.ID) AS Behandlungsanzahl
FROM 
    Behandlungen b
JOIN 
    Aerzte a ON b.ArztID = a.ID
JOIN 
    Stationen s ON a.StatID = s.ID
WHERE 
    b.Status = 'Abgeschlossen'
GROUP BY 
    s.Fachbereich
HAVING 
    SUM(b.Kosten) > 5000.00
ORDER BY 
    Gesamtumsatz DESC;
GO

/* TEIL 3: Patienten-Risiko-Profil
   Techniken: CTE, Subquery in WHERE
*/
WITH PatientenFrequenz AS (
    SELECT PatID, COUNT(*) AS Anzahl
    FROM Behandlungen
    GROUP BY PatID
)
SELECT 
    p.Vorname, 
    p.Nachname, 
    pf.Anzahl AS Behandlungen_Gesamt
FROM 
    Patienten p
JOIN 
    PatientenFrequenz pf ON p.ID = pf.PatID
WHERE 
    pf.Anzahl > (SELECT AVG(CAST(Anzahl AS DECIMAL(10,2))) FROM PatientenFrequenz);
GO

/* TEIL 4: Ärzte-Dashboard
   Techniken: String-Funktionen, Datums-Filter
*/
SELECT 
    UPPER(a.Nachname) + ', ' + a.Vorname + ISNULL(' (' + a.Titel + ')', '') AS Arzt_Formatiert,
    COUNT(b.ID) AS Behandlungen_Heuer
FROM 
    Aerzte a
LEFT JOIN 
    Behandlungen b ON a.ID = b.ArztID 
    AND YEAR(b.Datum) = YEAR(GETDATE()) -- Filtert direkt im JOIN für korrekte 0-Werte
GROUP BY 
    a.Nachname, a.Vorname, a.Titel
ORDER BY 
    Behandlungen_Heuer DESC;
GO

```
