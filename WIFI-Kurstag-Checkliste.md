# WIFI Kurstag Checkliste
## 🛠️ Technische Infrastruktur (Trainer-PC & MS Teams)

* [ ] **SQL Server Express:** Dienst läuft lokal am Trainer-PC.
* [ ] **SSMS (SQL Server Management Studio):** Aktuelle Version installiert und Verbindung zum lokalen Server erfolgreich.
* [ ] **Database Diagram Tool:** Einmalig in einer Test-DB initialisiert (erfordert oft zusätzliche Berechtigungen/Installation der Diagramm-Unterstützung).
* [ ] **MS Teams:** Meeting-Link erstellt und in Moodle oder per Mail an die 4 Teilnehmer versendet.
* [ ] **Zwei Bildschirme:** Setup prüfen – Screen 1 für die IDE (Live-Coding), Screen 2 für Teilnehmer-Galerie/Chat/Slides.

## 📂 Kursunterlagen & Moodle-Setup

* [ ] **Folien-Upload:** Alle Slide-Decks (Module 1-12) als PDF in Moodle hochgeladen.
* [ ] **DDL-Skripte (Tag 1):** Die `.sql`-Dateien mit den `CREATE TABLE`-Statements für die AKH-Struktur vorbereitet.
* [ ] **Datenbank-Backup (Tag 2):** Die `.bak`-Datei des AKH-Projekts auf Moodle bereitgestellt, damit Teilnehmer sie rechtzeitig downloaden können.
* [ ] **Übungsblätter:** Jedes Modul-Set als separates Dokument zum Download.
* [ ] **Cheat-Sheet:** Das einseitige SQL-Referenzblatt (Syntax-Übersicht) für die Teilnehmer vorbereitet.

## 🏥 AKH-Szenario Check (Der "Rote Faden")

* [ ] **Daten-Konsistenz:** Einmaliger Test-Lauf: Passt das Backup von Tag 2 zu den DDL-Skripten von Tag 1? (Spaltennamen, Datentypen).
* [ ] **Edge Cases:** Sind im Backup bewusst `NULL`-Werte und "verwaiste" Datensätze (z.B. Patienten ohne Station) für die Join-Übungen enthalten?.

## 📝 Organisatorisches

* [ ] **Teilnehmerliste:** Vorhanden für die Anwesenheitskontrolle (wichtig für die Zertifikatsausstellung).
* [ ] **Zeitplan:** Pausenzeiten (Mittag ca. 12:00 Uhr) im Kopf behalten.
* [ ] **Support-Kanal:** Kurzer Hinweis für Teilnehmer vorbereitet, wie sie bei technischen Problemen (z.B. SSMS Installation) Hilfe erhalten.

---

Starte das MS Teams Meeting 10 Minuten früher und mach einen kurzen "Screen-Sharing-Check". Nichts killt die Dynamik am Anfang mehr als: "Können Sie meinen SQL-Editor sehen?"
