### Demo 1: Multi-Sortierung & Datumsformate

**Konzept:** Hierarchische Sortierung und ressourcenschonende Formatierung.
**Evidenz:** Die `FORMAT()`-Funktion greift auf die .NET CLR zurück und verbraucht massiv CPU-Zyklen. `CONVERT` mit Style `104` ist die performantere, native Methode für den europäischen Standard.

```sql
-- Tabelle: Patienten_Archiv
-- Ziel: Zeige alle archivierten Patienten, primär sortiert nach Geschlecht, sekundär nach Alter.
SELECT 
    SVNummer,
    Geschlecht,
    CONVERT(VARCHAR, GebDatum, 104) AS GebDatum_Deutsch 
FROM 
    Patienten_Archiv
ORDER BY 
    Geschlecht DESC, 
    GebDatum ASC;

```

---

### Demo 2: Ausfallsichere String-Manipulation

**Konzept:** Extrahieren und Verketten von Zeichenketten.
**Evidenz:** Der `+`-Operator korrumpiert den gesamten String zu `NULL`, sobald ein einziges Element `NULL` ist. `CONCAT()` ignoriert `NULL`-Werte systematisch und schützt vor Datenverlust in der Anzeige.

```sql
-- Tabelle: Stationen
-- Ziel: Generierung eines Kurzcodes für das KIS-System (z.B. "KAR-3 (Kardiologie)").
SELECT 
    Name,
    Fachbereich,
    Stockwerk,
    CONCAT(LEFT(Fachbereich, 3), '-', Stockwerk, ' (', Name, ')') AS Stations_Code
FROM 
    Stationen
ORDER BY 
    Stockwerk ASC;

```

---

### Demo 3: Datumsmathematik

**Konzept:** Messen von Zeitintervallen zur Gegenwart.
**Evidenz:** `DATEDIFF` berechnet keine exakten physikalischen Zeitspannen, sondern zählt ausschließlich die überschrittenen kalendarischen Grenzen (z. B. Jahreswechsel, Mitternacht). Dies ist entscheidend für Abrechnungslaufzeiten.

```sql
-- Tabelle: Patienten_Archiv
-- Ziel: Berechnung des kalendarischen Alters in Jahren und Monaten zur aktuellen Systemzeit.
SELECT 
    Nachname,
    GebDatum,
    DATEDIFF(year, GebDatum, GETDATE()) AS Alter_in_Jahren,
    DATEDIFF(month, GebDatum, GETDATE()) AS Alter_in_Monaten
FROM 
    Patienten_Archiv
ORDER BY 
    Alter_in_Jahren DESC;

```

