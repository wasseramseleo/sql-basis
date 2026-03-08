# Curriculum: SQL Basiskurs (WIFI Wien)

**Dauer:** 3 Tage (24 LE) | **Setting:** Online (MS Teams / SSMS) | **Projekt:** AKH Wien Patientendaten

---

## Tag 1: Fundamente & Struktur (DDL & ERM)

*Ziel: Verständnis für relationale Logik und physische Tabellenerstellung.*

### Vormittag (09:00 – 12:00)

* **Modul 1: Einführung & Architektur**
* Relationenmodell: Was bedeutet "Relational"?
* Client-Server-Prinzip (SQL Server vs. Management Studio).
* Datentypen im SQL Server (INT, VARCHAR, DATETIME, DECIMAL).


* **Modul 2: ERM & Datenbankdesign (Theorie & Praxis)**
* Entitäten und Attribute am Beispiel "Patient" und "Station".
* Primärschlüssel (PK) und Fremdschlüssel (FK).
* Kardinalitäten (1:n, m:n auflösen).
* **Praxis:** Erstellen eines ER-Diagramms direkt im **SSMS Database Diagram Tool**.



### Nachmittag (13:00 – 17:00)

* **Modul 3: DDL – Die Geburtsstunde der DB**
* `CREATE TABLE`: Manuelle Erstellung der AKH-Stammdaten (Patienten, Ärzte).
* `ALTER` & `DROP`: Strukturänderungen im laufenden Betrieb.
* Constraints: `NOT NULL`, `UNIQUE`, `CHECK`.


* **Modul 4: Erste Selektionen & Syntax-Regeln**
* Die `SELECT`-Anatomie.
* Literale, Aliase (`AS`) und einfache Berechnungen.
* **Praxis:** Manuelle Dateneingabe kleiner Mengen zur Überprüfung der Constraints.



---

## Tag 2: Daten abfragen & Verknüpfen (DQL)

*Ziel: Beherrschung von Joins und Aggregationen auf Basis des AKH-Backups.*

### Vormittag (09:00 – 12:00)

* **Modul 5: Daten-Setup & Filterung**
* Restore des erweiterten AKH-Backups (Vorbereitete Datenmenge).
* `WHERE`-Klausel: Vergleichsoperatoren und Logik (`AND`, `OR`, `IN`, `BETWEEN`).
* NULL-Logik: Warum `IS NULL` überlebenswichtig ist.


* **Modul 6: Joins – Das Herz von SQL**
* `INNER JOIN`: Patienten und ihre Diagnosen verknüpfen.
* `LEFT / RIGHT JOIN`: Identifikation von Patienten ohne zugewiesene Betten.
* Self-Join (Optional/Expert): Hierarchien in der Ärzteschaft.

![img.png](img.png)

### Nachmittag (13:00 – 17:00)

* **Modul 7: Aggregation & Gruppierung**
* Aggregatfunktionen (`SUM`, `AVG`, `COUNT`, `MIN/MAX`).
* `GROUP BY`: Auswertungen pro Station oder Krankenkasse.
* `HAVING`: Filtern nach der Aggregation.


* **Modul 8: Sortierung & Formatierung**
* `ORDER BY`: Top-Listen erstellen.
* String-Funktionen & Datums-Manipulation.



---

## Tag 3: Manipulation & Fortgeschrittene Logik (DML & DQL+)

*Ziel: Datenpflege und Beherrschung komplexer Abfragestrukturen.*

### Vormittag (09:00 – 12:00)

* **Modul 9: DML – Daten verwalten**
* `INSERT INTO`: Aufnahme neuer Patienten.
* `UPDATE`: Korrektur von Entlassungsdaten (Vorsicht ohne `WHERE`!).
* `DELETE` vs. `TRUNCATE`.


* **Modul 10: Mengenoperationen & Subqueries**
* `UNION` / `UNION ALL`: Zusammenführen von Archiv- und Wirkdaten.
* Einfache Subqueries in der `WHERE`-Klausel.
* **Praxis:** "Finde alle Patienten, deren Kosten über dem Durchschnitt liegen."



### Nachmittag (13:00 – 17:00)

* **Modul 11: Fortgeschrittene Konzepte (Buffer / Optional)**
* Views: Speichern komplexer Abfragen für Berichte.
* Einführung in CTEs (Common Table Expressions) für bessere Lesbarkeit.
* Korrelierte Subqueries (falls Zeit/Niveau erlaubt).


* **Modul 12: Finales Kursprojekt "AKH-Reporting"**
* Eigenständige Erstellung eines Dashboards in SQL (Query-Sammlung).
* Review & Best Practices für sauberen Code.
* Kursabschluss & Feedback.
