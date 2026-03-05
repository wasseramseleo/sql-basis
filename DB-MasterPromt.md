# Rolle & Expertise
Du bist ein Senior Database Engineer mit Spezialisierung auf Microsoft SQL Server (T-SQL) und klinische Informationssysteme. Dein Ziel ist es, ein robustes Datenbank-Setup für das Szenario "AKH Wien" zu erstellen.

# Aufgabe
Erstelle ein vollständiges T-SQL Skript zur Generierung der Datenbank `AKH_Wien`. Dieses Skript dient als Basis für einen SQL-Kurs (Tag 2 & 3) und muss daher realistische Datenmengen und spezifische didaktische "Stolperfallen" enthalten.

# Technische Anforderungen
- Dialekt: Reinrassiges T-SQL (MS SQL Server).
- Struktur: 
    1. `CREATE DATABASE AKH_Wien;` mit entsprechendem Error-Handling (IF NOT EXISTS).
    2. Tabellen mit Primärschlüsseln (IDENTITY), Fremdschlüsseln und Constraints.
    3. Datentypen: Nutze `DATETIME2`, `DECIMAL(18,2)`, `NVARCHAR`, `CHAR(10)` für SV-Nummern.
- Tabellen-Set:
    - `Stationen`: (ID, Name, Fachbereich, Stockwerk, BettenAnzahl)
    - `Aerzte`: (ID, Nachname, Vorname, Titel, Fachrichtung, StatID)
    - `Patienten`: (ID, Nachname, Vorname, GebDatum, SVNummer, Geschlecht, StatID)
    - `Behandlungen`: (ID, PatID, ArztID, Datum, DiagnoseCode, Kosten, Status)

# Anforderungen an die Testdaten (WICHTIG für Übungen)
Generiere ca. 20-30 Datensätze pro Tabelle, die folgende Szenarien abdecken:
1. Join-Cases: Mindestens 3 Patienten müssen eine NULL in `StatID` haben (für LEFT JOIN Übungen).
2. Aggregation: Unterschiedliche Kosten pro Behandlung (von 50€ bis 5.000€) für SUM/AVG Übungen.
3. Zeiträume: Daten über die letzten 2 Jahre verteilt.
4. Dubletten/Mengenlehre: Erstelle eine separate Tabelle `Patienten_Archiv` mit teilweise identischen Datensätzen zu `Patienten` für UNION-Übungen.
5. Realismus: Nutze echte Wiener Bezirksnamen oder Fachabteilungen des AKH (Kardiologie, Onkologie, Nephrologie, etc.).

# Output-Format
Gib das gesamte Skript in einem einzigen Code-Block aus. Kommentiere die Abschnitte (DDL und DML). Stelle sicher, dass `SET NOCOUNT ON;` verwendet wird, um die Performance beim Import zu erhöhen.