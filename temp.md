# Aufgabe 3: Korrelierte Subqueries

### Lernziel

Verständnis der zeilenweisen Interaktion zwischen Haupt- und Unterabfrage.

### Szenario

Die ärztliche Direktion möchte für jeden Patienten wissen, wie hoch seine letzte Behandlung im Vergleich zu *seinen
eigenen* durchschnittlichen Behandlungskosten war.

### Aufgabenstellung

Erstellen Sie eine Abfrage auf `Behandlungen`. Geben Sie `PatID`, `Datum` und `Kosten` aus. Fügen Sie eine berechnete
Spalte hinzu, die mittels einer korrelierten Subquery den Durchschnitt der Kosten *nur für diesen spezifischen
Patienten* ermittelt.

### Erwartetes Ergebnis

Eine Liste, bei der in jeder Zeile der individuelle Durchschnitt des jeweiligen Patienten als Vergleichswert steht.

### Tipp

Im Gegensatz zu unkorrelierten Subqueries wird eine korrelierte Subquery für jede Zeile der äußeren Abfrage neu
evaluiert. Bei sehr großen Datenmengen im AKH kann dies die Performance beeinträchtigen. Hier sind oft Window
Functions (wie `AVG() OVER(...)`) die effizientere, fortgeschrittene Alternative.

