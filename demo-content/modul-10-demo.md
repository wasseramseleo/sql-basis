### Demo 1: Mengenoperationen (UNION vs. UNION ALL)

**Konzept:** Vertikale Kombination disparater Datenmengen.
**Evidenz:** Die Verwendung von `UNION` zwingt die Datenbank-Engine zu einer ressourcenintensiven `DISTINCT`-Sortierung in der `tempdb`, um Duplikate auszufiltern. `UNION ALL` verzichtet auf diese Prüfung und liefert maximale Performance.

```sql
-- Tabellen: Aerzte, Patienten
-- Ziel: Eine konsolidierte Namensliste aller im Krankenhaus registrierten Personen (Personal und Patienten).
SELECT 
    'Personal' AS Rolle,
    Nachname, 
    Vorname 
FROM 
    Aerzte
UNION ALL -- Evidenzbasierte Wahl für maximale I/O-Performance
SELECT 
    'Patient' AS Rolle,
    Nachname, 
    Vorname 
FROM 
    Patienten;

```

---

### Demo 2: Skalare Subquery (Unkorreliert)

**Konzept:** Dynamische Schwellenwert-Filterung.
**Evidenz:** Bei unkorrelierten Subqueries führt der Query Optimizer die innere Abfrage exakt einmal isoliert aus. Der berechnete skalare Wert (z. B. ein Durchschnitt) wird im Cache abgelegt und effizient auf die äußere Abfrage angewendet.

```sql
-- Tabelle: Stationen
-- Ziel: Identifikation von Großstationen, deren Bettenkapazität über dem Klinik-Durchschnitt liegt.
SELECT 
    Name, 
    Fachbereich, 
    BettenAnzahl
FROM 
    Stationen
WHERE 
    BettenAnzahl > (
        -- Innere Abfrage berechnet den globalen Skalarwert genau einmal
        SELECT AVG(BettenAnzahl) 
        FROM Stationen
    );

```

---

### Demo 3: Mengenfilter (Semi-Join Logik via IN)

**Konzept:** Existenzprüfungen ohne teure Joins.
**Evidenz:** Die Nutzung von `IN (Subquery)` ist architektonisch sauberer und performanter als ein `INNER JOIN` in Kombination mit `DISTINCT`. Die SQL-Engine wendet hier eine Semi-Join-Logik an: Sobald der erste Treffer in der Unterabfrage gefunden wird, bricht die Suche für den jeweiligen Datensatz ab.

```sql
-- Tabellen: Aerzte, Behandlungen
-- Ziel: Identifikation aller Ärzte, die jemals eine Behandlung storniert haben (Duplikate des Arztes vermeiden).
SELECT 
    Titel, 
    Nachname, 
    Fachrichtung
FROM 
    Aerzte
WHERE 
    ID IN (
        -- Subquery isoliert die Arzt-IDs, die Stornos aufweisen
        SELECT ArztID 
        FROM Behandlungen 
        WHERE Status = 'Storniert'
    );

```
