# Übungssatz: Modul 12 – AKH-Reporting

Die Mission: Sie agieren als Lead Data Analyst. Die Klinikleitung benötigt einen konsolidierten "Shift-Leader-Report",
der geschäftskritische Fragestellungen evidenzbasiert beantwortet.

---

## Aufgabe 1: Die Auslastungs-Analyse

### Lernziel

Anwendung von Outer Joins, mathematischen Berechnungen auf Zeilenebene und der Aggregation von Metriken.

### Szenario

Die Klinikleitung benötigt dringend eine valide Übersicht zur aktuellen Bettenauslastung, um Engpässe auf den
bettenführenden Stationen datengestützt zu identifizieren.

### Aufgabenstellung

Verknüpfen Sie die Entitäten `Stationen` und `Patienten`. Ermitteln Sie für jede Station den Namen, das zugehörige
Stockwerk und die absolute Anzahl der aktuell physisch zugewiesenen Patienten. Leiten Sie daraus eine berechnete Spalte
für die prozentuale "Auslastungsquote" ab. Diese Quote berechnet sich aus dem Quotienten von zugewiesenen Patienten und
der maximalen Bettenanzahl, multipliziert mit 100. Sichern Sie die Berechnung durch einen expliziten `CAST` auf einen
Dezimal-Datentyp ab, um systematische Integer-Divisionen (die zu Null-Werten führen) zu blockieren. Sortieren Sie das
finale Ergebnis absteigend nach der höchsten Auslastungsquote.

### Erwartetes Ergebnis

Eine priorisierte Liste aller Stationen und ihrer prozentualen Auslastung.

### Tipp

Der Einsatz eines `LEFT JOIN` ist hier architektonisch zwingend. Würden Sie auf einen `INNER JOIN` zurückgreifen, fielen
komplett leere Stationen mit einer Auslastung von 0 % vollständig aus dem Raster der Klinikleitung.

---

## Aufgabe 2: Finanzielle Performance nach Fachbereich

### Lernziel

Kombination multipler Joins mit der strikten Trennung von Zeilen-Filtern (`WHERE`) und Gruppen-Filtern (`HAVING`).

### Szenario

Das Controlling fordert eine finanzielle Rentabilitätsprüfung der medizinischen Abteilungen.

### Aufgabenstellung

Aggregieren Sie die Tabelle `Behandlungen` auf Basis des Attributes `Fachbereich` aus der Tabelle `Stationen`. Ermitteln
Sie die kumulierten Gesamtkosten sowie die absolute Anzahl der erbrachten Behandlungen pro Fachbereich. Beschränken Sie
die zugrunde liegende Datenmenge vor der mathematischen Aggregation strikt auf Behandlungen mit dem Status '
Abgeschlossen'. Filtern Sie das gruppierte Endergebnis anschließend so, dass ausschließlich Fachbereiche ausgewiesen
werden, die einen Gesamtumsatz von mehr als 5.000,00 Euro erwirtschaftet haben.

### Erwartetes Ergebnis

Eine aggregierte, nach Umsatz absteigend sortierte Liste der rentabelsten Fachbereiche.

---

## Aufgabe 3: Patienten-Risiko-Profil

### Lernziel

Analyse dynamischer Schwellenwerte mithilfe von Common Table Expressions (CTEs) und Unterabfragen.

### Szenario

Zur Prävention von "Drehtüreffekten" (auffällig häufige Wiederaufnahmen) verlangt das Qualitätsmanagement eine
Identifikation von Hochrisiko-Patienten.

### Aufgabenstellung

Identifizieren Sie alle Patienten (Ausgabe von Vorname, Nachname und absoluter Behandlungsanzahl), deren individuelle
Besuchsfrequenz den globalen Durchschnitt aller im System erfassten Behandlungen pro Patient übersteigt. Verwenden Sie
eine CTE, um zunächst die absolute Frequenz pro Patient zu ermitteln. Gleichen Sie diesen aggregierten Wert anschließend
in der Filterbedingung der Hauptabfrage mit dem dynamisch berechneten, globalen Durchschnitt ab.

### Erwartetes Ergebnis

Eine exakte Liste jener Patienten, die signifikant öfter behandelt wurden als der statistische Durchschnitt.

---

## Aufgabe 4: Das "Ärzte-Dashboard"

### Lernziel

Sichere Zeichenketten-Manipulation und der korrekte Einsatz von Datumsfiltern bei Outer Joins.

### Szenario

Das Personalbüro benötigt für die anstehenden Leistungs- und Jahresgespräche ein Dashboard zur ärztlichen
Behandlungsdichte.

### Aufgabenstellung

Selektieren Sie den gesamten Personalstamm aus der Tabelle `Aerzte`. Generieren Sie eine formatierte Namensspalte, die
den Nachnamen in Großbuchstaben, gefolgt von einem Komma, dem Vornamen und dem in Klammern gesetzten Titel ausgibt (z.
B. "MÜLLER, Anna (Prof. Dr.)"). Fangen Sie `NULL`-Werte beim Titel sauber ab. Berechnen Sie in einer separaten Spalte
die exakte Anzahl der Behandlungen, die der jeweilige Arzt im aktuell laufenden Kalenderjahr durchgeführt hat.
Behandlungsfreie Ärzte müssen zwingend mit dem Wert 0 aufscheinen. Sortieren Sie das Dashboard absteigend nach der
Leistungsdichte.

### Erwartetes Ergebnis

Eine bereinigte, formatierte Übersicht des gesamten medizinischen Personals mit der Jahresleistung.

### Tipp

Wenn Sie einen Datumsfilter (z. B. das laufende Jahr) bei einem `LEFT JOIN` in die `WHERE`-Klausel schreiben, verwandelt
der Optimizer die Abfrage faktisch in einen `INNER JOIN` – Ärzte mit 0 Behandlungen verschwinden. Setzen Sie den Filter
direkt in die `ON`-Bedingung des Joins.