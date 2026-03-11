### Demo 1: Kapselung & Abstraktion durch Views

**Konzept:** Erstellung einer virtuellen Tabelle zur Vereinfachung von Zugriffen und zur Erhöhung der Sicherheit.
**Evidenz:** Views persistieren standardmäßig keine physischen Daten, sondern speichern den zugrunde liegenden Abfrageplan. Dies ist ein kritisches Sicherheitsinstrument: Benutzer erhalten Leserechte auf die View, bleiben aber von den rohen Basis-Tabellen isoliert.

```sql
-- Tabellen: Aerzte, Stationen
-- Ziel: Eine wiederverwendbare Übersicht der Ärzteschaft und ihrer Stammstationen.
GO
CREATE VIEW vw_Aerzte_Stationen AS
SELECT 
    a.Titel,
    a.Nachname,
    a.Fachrichtung,
    s.Name AS Stammstation,
    s.Stockwerk
FROM 
    Aerzte a
INNER JOIN 
    Stationen s ON a.StatID = s.ID;
GO

-- Aufruf durch den Endanwender (komplexe JOIN-Logik bleibt verborgen)
SELECT * FROM vw_Aerzte_Stationen WHERE Stockwerk = 3;

```

---

### Demo 2: Modulare Abfragen mit CTEs

**Konzept:** Strukturierung komplexer Aggregationen durch Common Table Expressions.
**Evidenz:** Verschachtelte Subqueries zwingen den Entwickler, Code "von innen nach außen" zu interpretieren. CTEs etablieren stattdessen einen linearen, modularen Lesefluss (Top-Down), was die Wartbarkeit des Codes bei komplexen Metriken signifikant erhöht.

```sql
-- Tabelle: Stationen
-- Ziel: Ermittlung der kumulierten Bettenkapazität pro Fachbereich und Filterung der Großbereiche.
WITH StationStats AS (
    -- 1. Modul: Die CTE aggregiert die Metriken vorab
    SELECT 
        Fachbereich,
        SUM(BettenAnzahl) AS Gesamtbetten
    FROM 
        Stationen
    GROUP BY 
        Fachbereich
)
-- 2. Modul: Die Hauptabfrage greift auf die aufbereitete CTE zu
SELECT 
    Fachbereich,
    Gesamtbetten
FROM 
    StationStats
WHERE 
    Gesamtbetten > 50; 
GO

```

---

### Demo 3: Korrelierte Subqueries (Der RBAR-Effekt)

**Konzept:** Zeilenweise Parameterübergabe zwischen Haupt- und Unterabfrage.
**Evidenz:** Bei einer korrelierten Subquery wird die innere Abfrage iterativ für *jede einzelne* Zeile der äußeren Abfrage neu evaluiert. In großen Datenbanken wie dem KIS des AKH führt dieses Row-By-Agonizing-Row (RBAR) Verhalten zu extremen Performance-Einbußen.

```sql
-- Tabellen: Aerzte, Behandlungen
-- Ziel: Abfrage des jeweils aktuellsten Behandlungsdatums pro Arzt.
SELECT 
    a.Nachname,
    a.Fachrichtung,
    (
        -- Die Subquery wird für jeden Arzt (a.ID) einzeln ausgeführt
        SELECT MAX(b.Datum) 
        FROM Behandlungen b 
        WHERE b.ArztID = a.ID 
    ) AS Letzte_Behandlung
FROM 
    Aerzte a;
GO

```