### Demo 1: Das zukunftssichere INSERT

**Konzept:** Anlage neuer Datensätze mit explizitem Spalten-Mapping.
**Evidenz:** Die Unterlassung der Spaltendefinition (`INSERT INTO Tabelle VALUES...`) ist ein kritischer Architekturfehler. Bei der geringsten strukturellen Änderung (z. B. einer neuen Spalte) bricht der Code auf Produktionsebene unweigerlich ab.

```sql
-- Tabelle: Stationen
-- Ziel: Sichere Anlage einer neuen Triage-Station im Erdgeschoss.
INSERT INTO Stationen (
    Name, 
    Fachbereich, 
    Stockwerk, 
    BettenAnzahl
)
VALUES (
    'Notaufnahme', 
    'Triage & Erstversorgung', 
    0, 
    15
);

```

---

### Demo 2: UPDATE mit Sicherheitsnetz (Transaktionen)

**Konzept:** Gezielte Datenmodifikation unter dem Schutz einer Transaktion.
**Evidenz:** Ein `UPDATE` ohne `WHERE`-Klausel ist ein systematischer GAU, der alle Datensätze einer Tabelle überschreibt. Das Kapseln in `BEGIN TRAN` ermöglicht eine Verifizierung, bevor die Daten physisch auf die Festplatte geschrieben (`COMMIT`) oder im Fehlerfall verworfen (`ROLLBACK`) werden.

```sql
-- Tabelle: Aerzte
-- Ziel: Beförderung eines Arztes (Titel-Update) mit expliziter ID-Filterung.
BEGIN TRAN;

UPDATE Aerzte
SET 
    Titel = 'Prim. Dr.'
WHERE 
    ID = 4; -- Strikte Identifikation über den Primary Key

-- Validierung der betroffenen Zeilen durchführen...
-- COMMIT TRAN;   -- Bestätigen
-- ROLLBACK TRAN; -- Verwerfen

```

---

### Demo 3: Anatomie des Löschens (DELETE)

**Konzept:** Entfernen spezifischer Datensätze auf Basis von Prädikaten.
**Evidenz:** `DELETE` ist eine vollständig im Transaction Log protokollierte DML-Operation. Dies erlaubt Rollbacks und gezieltes Filtern, verbraucht aber bei Massenlöschungen massiv I/O-Ressourcen im Vergleich zu DDL-Befehlen wie `TRUNCATE`.

```sql
-- Tabelle: Behandlungen
-- Ziel: Stornierung einer fälschlicherweise erfassten Behandlung.
BEGIN TRAN;

DELETE FROM Behandlungen
WHERE 
    ID = 1042 
    AND Status = 'Storniert'; -- Doppelter Filter als Best Practice

-- COMMIT TRAN;

```