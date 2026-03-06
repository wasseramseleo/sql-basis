# Aufgabe 1: Visuelles Datenbankdesign (ERM im SSMS)

### Lernziel

Anlage einer neuen Datenbank und visuelle Modellierung von Entitäten (Patienten, Stationen) inklusive Primärschlüsseln und 1:n-Kardinalität über das SSMS Database Diagram Tool.

### Szenario

Das Management des AKH Wien benötigt den Grundstock für das neue Patientensystem. Bevor Daten importiert werden, muss das physische Fundament in Form einer relationalen Struktur im SQL Server Management Studio (SSMS) gelegt werden.

### Aufgabenstellung

1. **Datenbankanlage:** Erstellen Sie im SSMS eine neue, leere Datenbank namens `AKH_Wien`.
2. **Diagramm-Setup:** Initialisieren Sie ein neues Datenbankdiagramm in dieser Datenbank.
3. **Entität Stationen:** Erstellen Sie visuell die Tabelle `Stationen`. Legen Sie die Attribute `ID` (als Primärschlüssel mit Auto-Inkrement), `Name`, `Fachbereich`, `Stockwerk` und `BettenAnzahl` an.
4. **Entität Patienten:** Erstellen Sie visuell die Tabelle `Patienten`. Legen Sie die Attribute `ID` (Primärschlüssel, Auto-Inkrement), `Nachname`, `Vorname`, `GebDatum`, `SVNummer`, `Geschlecht` und `StatID` an.
5. **Kardinalität (1:n):** Modellieren Sie die Beziehung so, dass ein Patient genau einer Station zugewiesen werden kann. Etablieren Sie dafür die FK-PK-Beziehung zwischen den beiden Tabellen. Speichern Sie das Schema ab.

### Erwartetes Ergebnis

Eine lauffähige Datenbank `AKH_Wien` mit einem gespeicherten ER-Diagramm, das die Tabellen `Stationen` und `Patienten` samt ihrer 1:n-Beziehung zeigt.

### Tipp

Nutzen Sie das Eigenschaftsfenster (F4) im SSMS, um die `Identity Specification` für IDs zu aktivieren. Dies schließt manuelle Fehler bei der Vergabe von Primärschlüsseln technisch aus.

### Geschätzte Dauer

15 Minuten.

---

### Musterlösung (Schritt-für-Schritt im SSMS)

**Schritt 1: Datenbank anlegen**

1. Öffnen Sie den *Object Explorer* im SSMS.
2. Führen Sie einen Rechtsklick auf den Ordner `Databases` aus und wählen Sie `New Database...`.
3. Tragen Sie im Feld *Database name* `AKH_Wien` ein und bestätigen Sie mit `OK`.

**Schritt 2: Database Diagram Tool initialisieren**

1. Erweitern Sie im *Object Explorer* die neu erstellte Datenbank `AKH_Wien`.
2. Führen Sie einen Rechtsklick auf den Ordner `Database Diagrams` aus und wählen Sie `New Database Diagram`.
3. Falls ein Warnhinweis erscheint, dass die Support-Objekte fehlen, bestätigen Sie diesen mit `Yes`.
4. Schließen Sie das Fenster "Add Table", da noch keine Tabellen existieren.

**Schritt 3: Tabelle `Stationen` erstellen**

1. Rechtsklick in die leere weiße Diagrammfläche -> `New Table...`.
2. Tabellenname: `Stationen`.
3. Spalten eintragen: `ID` (int), `Name` (nvarchar(100)), `Fachbereich` (nvarchar(100)), `Stockwerk` (int), `BettenAnzahl` (int).
4. **Primärschlüssel:** Rechtsklick auf den Zeilenkopf der Spalte `ID` -> `Set Primary Key`. (Ein Schlüsselsymbol erscheint).
5. **Auto-Inkrement:** Markieren Sie die Spalte `ID`. Drücken Sie `F4`, um die Properties zu öffnen. Suchen Sie `Identity Specification`, klappen Sie es auf und setzen Sie `(Is Identity)` auf `Yes`.

**Schritt 4: Tabelle `Patienten` erstellen**

1. Rechtsklick in die Diagrammfläche -> `New Table...`.
2. Tabellenname: `Patienten`.
3. Spalten eintragen: `ID` (int), `Nachname` (nvarchar(100)), `Vorname` (nvarchar(100)), `GebDatum` (date), `SVNummer` (char(10)), `Geschlecht` (char(1)), `StatID` (int).
4. Setzen Sie auch hier `ID` als Primary Key und aktivieren Sie analog zu Schritt 3 die `Identity Specification` auf `Yes`.

**Schritt 5: 1:n Beziehung etablieren**

1. Klicken Sie in der Tabelle `Stationen` auf den Zeilenkopf (das Feld vor dem Spaltennamen) der Spalte `ID`.
2. Halten Sie die linke Maustaste gedrückt und ziehen Sie den Cursor auf die Spalte `StatID` in der Tabelle `Patienten`. Lassen Sie die Maustaste los. 3. Es öffnet sich der Dialog *Tables and Columns*. Prüfen Sie, ob unter *Primary Key Table* `Stationen` mit `ID` und unter *Foreign Key Table* `Patienten` mit `StatID` steht.
3. Bestätigen Sie zweimal mit `OK`.
4. Drücken Sie `Strg + S`, um das Diagramm zu speichern (z.B. als `ERM_AKH_Basis`). Die Tabellen werden nun physisch in der Datenbank angelegt.