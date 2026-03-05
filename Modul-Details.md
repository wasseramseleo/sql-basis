### Modul 1 Details

* **Kontext:** Vom Papier-Archiv zur Datenbank. Wir klären, warum das AKH Wien nicht mit Excel-Listen operieren kann (Datenintegrität, Redundanz).
* **Lernziele:** Client-Server-Prinzip verstehen (SSMS ist nur die Fernbedienung), Datentypen-Wahl für medizinische Daten (Warum `DECIMAL` für Körpertemperatur? Warum `VARCHAR` für Namen?).
* **Vorhandenes Schema:** Keines (Initialisierung der Datenbank `AKH_Wien`).
* **Besonderheit:** Fokus auf den Unterschied zwischen dem Datenbank-Dienst und der GUI (SSMS).

### Modul 2 Details

* **Kontext:** Die visuelle Planung der AKH-Struktur. Wir modellieren die Beziehung zwischen Patienten und ihren Stammstationen.
* **Lernziele:** Primärschlüssel (Eindeutigkeit), Fremdschlüssel (Beziehung), Kardinalität (Ein Patient gehört zu einer Station, eine Station hat viele Patienten = 1:n).
* **Vorhandenes Schema:** Konzeptionell (Patient, Station).
* **Tool-Fokus:** Nutzung des **SSMS Database Diagram Tools** zur Visualisierung, bevor Code geschrieben wird.

### Modul 3 Details

* **Kontext:** Wir setzen den Bauplan aus Modul 2 physisch um. Die Datenbank wird "echt".
* **Lernziele:** `CREATE TABLE` mit korrekten Constraints (`PRIMARY KEY`, `NOT NULL`, `UNIQUE` für die Sozialversicherungsnummer). `ALTER TABLE` für nachträgliche Änderungen (z.B. Telefonnummer hinzufügen).
* **Vorhandenes Schema:**
* `Station` (StatID INT PK, Name VARCHAR(50), Stockwerk TINYINT)
* `Patient` (PatID INT PK, Nachname VARCHAR(50), Vorname VARCHAR(50), GebDatum DATE, SVNummer CHAR(10) UNIQUE, StatID INT FK)

* **Besonderheit:** Einführung von `IDENTITY(1,1)` für automatische IDs.

### Modul 4 Details

* **Kontext:** Die ersten Daten wurden (manuell über SSMS oder kleine `INSERTs`) erfasst. Jetzt wollen wir sie sehen.
* **Lernziele:** Grundstruktur `SELECT - FROM`. Spalten-Aliase (`AS`) für lesbare Reports. Mathematische Berechnungen (z.B. Alter schätzen aus Geburtsjahr).
* **Vorhandenes Schema:** `Patient`, `Station` (mit ca. 5-10 Testdatensätzen).
* **Besonderheit:** Fokus auf die korrekte Reihenfolge der SQL-Schreibweise vs. die logische Verarbeitungsreihenfolge (Warum kennt SELECT den Alias aus der WHERE-Klausel noch nicht?).


### Modul 5 Details

* **Kontext:** Wir verlassen die manuelle Dateneingabe. Die Teilnehmer spielen ein "Echtwelt"-Backup ein, das hunderte Patienten, Stationen und Diagnosen enthält.
* **Lernziele:** `RESTORE DATABASE` Grundlagen. Präzises Filtern mit der `WHERE`-Klausel. Logische Verknüpfungen (`AND`, `OR`) und Mengen-Filter (`IN`, `BETWEEN`).
* **Vorhandenes Schema (via Backup):**
* `Patient` (Stammdaten)
* `Station` (Kardiologie, Onkologie, etc.)
* `Behandlung` (BehandlungsID, PatID, ArztID, Datum, Kosten)


* **Besonderheit:** Fokus auf die **Dreiwertige Logik** (TRUE, FALSE, UNKNOWN). Warum `WHERE Entlassungsdatum = NULL` niemals Ergebnisse liefert und man `IS NULL` nutzen muss.

### Modul 6 Details

* **Kontext:** Datenzusammenführung für den Klinikalltag. "Welcher Patient liegt auf welcher Station?"
* **Lernziele:** `INNER JOIN` für Übereinstimmungen. `LEFT JOIN` für die Identifikation von "Sorgenkindern" (z. B. Patienten, die noch keiner Station zugewiesen wurden). Verständnis der Join-Logik über PK/FK-Beziehungen.
* **Vorhandenes Schema:**
* `Patient` n:1 `Station`
* `Patient` 1:n `Behandlung`
* `Behandlung` n:1 `Arzt`

* **Besonderheit:** Visualisierung der Schnittmengen. Wir identifizieren mittels `LEFT JOIN` leere Betten oder Patienten ohne zugewiesenen Primärarzt.

### Modul 7 Details

* **Kontext:** Management-Reporting. Wir berechnen Kennzahlen für die AKH-Leitung.
* **Lernziele:** Aggregatfunktionen (`SUM`, `AVG`, `COUNT`). Die `GROUP BY`-Klausel und ihre goldene Regel (jede Spalte im SELECT muss aggregiert oder gruppiert sein). Filtern von Gruppen mit `HAVING`.
* **Vorhandenes Schema:**
* `Behandlung` (Kosten, Behandlungsdauer)
* `Patient` (Krankenkasse)


* **Besonderheit:** Unterschied zwischen `COUNT(*)` (alle Zeilen) und `COUNT(Spaltenname)` (ignoriert NULLs) am Beispiel von Telefonnummern oder Versicherungsdaten.

### Modul 8 Details

* **Kontext:** Die Daten für den menschlichen Betrachter (Ärzte/Verwaltung) aufbereiten.
* **Lernziele:** `ORDER BY` (auch über mehrere Spalten). String-Funktionen (`CONCAT`, `SUBSTRING`) für Namenskombinationen. Datumsfunktionen (`DATEDIFF`, `GETDATE()`) zur Berechnung der Liegedauer.
* **Vorhandenes Schema:** Gesamte Datenbank.
* **Besonderheit:** T-SQL Spezifika wie `FORMAT()` oder `CONVERT()` für europäische Datumsformate (TT.MM.JJJJ), die im AKH-Umfeld Standard sind.


### Modul 9 Details

* **Kontext**: Der Klinikalltag ist dynamisch. Wir bilden den Prozess von der Patientenaufnahme (`INSERT`) über die Verlegung oder Datenkorrektur (`UPDATE`) bis hin zur Archivierung oder fehlerhaften Datensatzlöschung (`DELETE`) ab.
* **Lernziele**: Sicherer Umgang mit Datenänderungen. Verständnis für die Unumkehrbarkeit von Löschbefehlen ohne Transaktionen. Unterscheidung zwischen dem Löschen von Inhalten (`DELETE`) und dem Zurücksetzen von Tabellen (`TRUNCATE`).
* **Vorhandenes Schema**: Alle Stammdaten- und Bewegungstabellen (`Patient`, `Behandlung`, `Arzt`).
* **Besonderheit**: Die "Goldene Regel" des `UPDATE`: Niemals ohne `WHERE`-Klausel arbeiten! Wir simulieren den "GAU" (alle Patienten entlassen) und besprechen, wie man sich davor schützt.

### Modul 10 Details

* **Kontext**: Das AKH hat verschiedene Datenquellen. Wir führen das aktuelle Patientenregister mit dem historischen Archiv zusammen und führen fortgeschrittene Vergleiche durch (z. B. "Welche Behandlungen kosten mehr als der Durchschnitt?").
* **Lernziele**: Vertikales Zusammenführen von Ergebnissen mit `UNION` und `UNION ALL`. Einsatz von Subqueries als Filterkriterium in der `WHERE`-Klausel.
* **Vorhandenes Schema**: `Patient`, `Behandlung`, sowie eine zusätzliche Struktur `Patient_Archiv` für die Mengenoperationen.
* **Besonderheit**: Performance-Unterschied zwischen `UNION` (Duplikatprüfung) und `UNION ALL` sowie die Lesbarkeit von verschachtelten Abfragen.

### Modul 11 Details

* **Kontext**: Professionalisierung der Abfragen. Wir bereiten häufig benötigte Berichte so vor, dass sie für die Verwaltung einfach abrufbar sind.
* **Lernziele**: Erstellung von `VIEWS` (virtuelle Tabellen) für komplexe Joins. Einführung in `CTEs` (Common Table Expressions) für eine logische Abfragestruktur statt tiefer Verschachtelung.
* **Vorhandenes Schema**: Gesamte Datenbank.
* **Besonderheit**: Dieses Modul dient als Puffer für schnelle Teilnehmer. Es zeigt, wie man "schönen" und wartbaren SQL-Code schreibt, der über das Basis-Niveau hinausgeht.

### Modul 12 Details

* **Kontext**: Die Teilnehmer schlüpfen in die Rolle eines Daten-Analysten für die Klinikleitung. Sie erstellen ein Set an "Shift-Leader-Reports".
* **Lernziele**: Selbstständige Anwendung aller gelernten Techniken (Joins, Filter, Aggregation, Sortierung). Code-Review und Optimierung der Lesbarkeit.
* **Vorhandenes Schema**: Die komplette `AKH_Wien` Datenbank.
* **Besonderheit**: Fokus auf Transferleistung. Statt einer Prüfung gibt es ein gemeinsames Review der Lösungen, bei dem Best Practices (z. B. Kommentierung, Benennungskonventionen) im Vordergrund stehen.
