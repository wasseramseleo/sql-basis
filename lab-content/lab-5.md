### Datei 1: `AKH_Uebungen_Modul6_Joins.md`

# Übungssatz: Modul 6 – Joins (Das Herz von SQL)

# Aufgabe 1: Stationsbelegung & INNER JOIN

### Lernziel
 Verknüpfung zweier Entitäten über Primär- und Fremdschlüssel zur Ermittlung von Schnittmengen.
### Szenario
 Für die Morgenbesprechung benötigt das ärztliche Personal eine lesbare Liste. Es sollen nur Patienten angezeigt werden, die physisch in einem Bett liegen.
## Aufgabenstellung
 Verknüpfen Sie die Tabellen `Patienten` und `Stationen` mittels `INNER JOIN`. Geben Sie den Vornamen, Nachnamen und die SVNummer des Patienten sowie den Namen der zugeordneten Station aus.
### Erwartetes Ergebnis
 Eine Tabelle, die exakt jene Patienten listet, bei denen die `StatID` einen gültigen Verweis auf die `Stationen`-Tabelle hat.
### Pro-Tipp
 Gewöhnen Sie sich sofort die Nutzung von Tabellen-Aliasen (z. B. `Patienten p`, `Stationen s`) an. Dies verhindert Mehrdeutigkeiten (`Ambiguous column name`), wenn beide Tabellen eine Spalte namens `ID` besitzen.
### Geschätzte Dauer
 10 Minuten.

---

# Aufgabe 2: Sorgenkinder & Anti-Joins

### Lernziel
 Anwendung von `LEFT JOIN` und `RIGHT JOIN` zur Identifikation fehlender Relationen ("Leere Schnittmengen").
### Szenario
 Das Bettenmanagement hat zwei kritische Fragen: Welche aufgenommenen Patienten warten noch auf dem Gang auf ein Bett? Und welche Stationen stehen aktuell komplett leer?
## Aufgabenstellung
 1. Schreiben Sie eine Abfrage mit `LEFT JOIN`, die alle `Patienten` auflistet, zu denen keine `Stationen`-ID existiert (Flurpatienten). Filtern Sie auf die fehlende Relation.
2. Schreiben Sie eine zweite Abfrage, die alle `Stationen` ausgibt, denen keine `Patienten` zugewiesen sind (Leere Betten).
### Erwartetes Ergebnis
 Zwei separate Abfragen. Die Filterung erfolgt zwingend über `IS NULL` auf der rechten Seite des Joins.
### Pro-Tipp
 Der sogenannte "Anti-Join" ist in der Praxis die effizienteste Methode zur Datenbereinigung und Fehleridentifikation. Er kombiniert einen Outer Join mit einer `WHERE ... IS NULL` Klausel auf den Primärschlüssel der verknüpften Tabelle.
### Geschätzte Dauer
 15 Minuten.

---

# Aufgabe 3: Peer-Groups & Der Self-Join

### Lernziel
 Abfragen einer Tabelle mit sich selbst zur Ermittlung von internen Relationen.
### Szenario
 Da die Tabelle `Aerzte` keine formelle Hierarchie-Spalte (wie `Oberarzt_ID`) aufweist, weichen wir auf horizontale Strukturen aus. Die Personalabteilung sucht für ein Mentoring-Programm nach "Peer-Groups" – also Ärzte, die auf derselben Station arbeiten.
## Aufgabenstellung
 Verknüpfen Sie die Tabelle `Aerzte` mit sich selbst (Self-Join). Finden Sie Arzt-Paare (Nachname 1, Nachname 2), die dieselbe `StatID` teilen. Schließen Sie aus, dass ein Arzt mit sich selbst gepaart wird. Verhindern Sie Spiegel-Duplikate (z.B. Paar A-B und Paar B-A).
### Erwartetes Ergebnis
 Eine Liste von Arzt-Kollegen, die sich eine Station teilen, ohne Redundanzen.
### Pro-Tipp
 Um Spiegel-Duplikate in einem Self-Join aufzulösen, verwendet man in der `ON`-Klausel einen Ungleichheits-Operator (`<` oder `>`) auf den Primärschlüssel statt eines reinen Not-Equals (`!=`). Das zwingt die Datenbank, jede Kombination exakt in einer Richtung auszuwerten.
### Geschätzte Dauer
 20 Minuten.

---

### Datei 2: `AKH_Loesungen_Modul6_Joins.sql`

```sql
-- =========================================================================
-- MUSTERLÖSUNG MODUL 6: Joins – Das Herz von SQL
-- =========================================================================

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 1: Stationsbelegung & INNER JOIN
-- -------------------------------------------------------------------------
SELECT 
    p.Vorname, 
    p.Nachname, 
    p.SVNummer, 
    s.Name AS Stationsname
FROM 
    Patienten p
INNER JOIN 
    Stationen s ON p.StatID = s.ID;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 2: Sorgenkinder & Anti-Joins
-- -------------------------------------------------------------------------

-- 2.1: Flurpatienten (Patienten ohne Station)
SELECT 
    p.ID AS PatientenID,
    p.Nachname, 
    p.Vorname
FROM 
    Patienten p
LEFT JOIN 
    Stationen s ON p.StatID = s.ID
WHERE 
    s.ID IS NULL; -- Der entscheidende Filter für den Anti-Join
GO

-- 2.2: Leere Stationen (Stationen ohne zugewiesene Patienten)
SELECT 
    s.ID AS StationsID,
    s.Name AS Stationsname
FROM 
    Stationen s
LEFT JOIN 
    Patienten p ON s.ID = p.StatID
WHERE 
    p.ID IS NULL;
GO

-- -------------------------------------------------------------------------
-- Lösung Aufgabe 3: Peer-Groups & Der Self-Join
-- -------------------------------------------------------------------------
-- Wir verwenden Aliase (a1, a2), um dieselbe Tabelle logisch zu trennen.
SELECT 
    a1.Nachname AS Arzt_1, 
    a2.Nachname AS Arzt_2, 
    s.Name AS Gemeinsame_Station
FROM 
    Aerzte a1
INNER JOIN 
    Aerzte a2 ON a1.StatID = a2.StatID 
    AND a1.ID < a2.ID -- Eliminiert Selbst-Paarungen (ID=ID) und Spiegelungen (ID>ID)
INNER JOIN 
    Stationen s ON a1.StatID = s.ID -- Optional: Holt noch den Klarnamen der Station
ORDER BY 
    s.Name, a1.Nachname;
GO

```
