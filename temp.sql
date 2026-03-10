BEGIN TRANSACTION;

UPDATE Patienten
SET StatID = 2
WHERE Nachname = 'Gruber';

SELECT * FROM Patienten WHERE Nachname = 'Gruber';

ROLLBACK;