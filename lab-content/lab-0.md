# Aufgabe 0: System-Check & Readiness

Bevor wir mit der Modellierung des AKH Wien beginnen, müssen wir sicherstellen, dass Ihre "Werkzeugkiste" voll funktionsfähig ist. In dieser Übung installieren wir die notwendige Software und testen die Verbindung zum Datenbank-Server.

## 1. Installation der Software

Für diesen Kurs benötigen wir den **Microsoft SQL Server** (die "Engine") und das **SQL Server Management Studio** (unser "Cockpit").

1. **SQL Server Express Edition:** Laden Sie die kostenlose Express-Version herunter und wählen Sie bei der Installation den Typ **"Basic"**.
2. **SQL Server Management Studio (SSMS):** Installieren Sie das SSMS, um eine grafische Oberfläche für Ihre Abfragen zu haben.

---

## 2. Der "Hello World" Verbindungstest

Sobald die Installation abgeschlossen ist, führen wir einen Funktionstest durch:

1. Öffnen Sie das **SSMS**.
2. Geben Sie im Feld **Servername** entweder `.` (ein Punkt), `localhost` oder den Namen Ihres PCs ein.
3. Wählen Sie **Windows-Authentifizierung**.
4. Klicken Sie auf **Verbinden**.
5. Öffnen Sie mit `Strg + N` ein neues Abfragefenster.

---

## 3. Test-Abfrage: System-Identifikation

Kopieren Sie den folgenden Code in Ihr Fenster und führen Sie ihn mit **F5** aus:

```sql
-- Test 1: Welche Version läuft bei mir?
SELECT @@VERSION AS Software_Version;

-- Test 2: Ist der Server bereit für Befehle?
SELECT GETDATE() AS Aktuelle_Systemzeit, 'Verbindung steht!' AS Status;

```

---

## 4. Erfolgskontrolle

Sie sind bereit für den Kurs, wenn:

* Im SSMS links im **Objekt-Explorer** ein grüner Pfeil am Servernamen erscheint.
* Die Abfrage oben eine Tabelle mit der installierten SQL-Version und der aktuellen Uhrzeit zurückgibt.
* Keine Fehlermeldungen in roter Schrift in den "Meldungen" erscheinen.

**Pro-Tipp:** Falls die Verbindung fehlschlägt, prüfen Sie in den Windows-Diensten (`services.msc`), ob der Dienst **"SQL Server (MSSQLSERVER)"** oder **"SQL Server (SQLEXPRESS)"** auf "Wird ausgeführt" steht.

---

