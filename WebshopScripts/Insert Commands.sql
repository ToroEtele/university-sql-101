INSERT INTO dbo.Rendeles
	(RendelesAzonosito, RendelesKoltseg, Osszeg, RendelesSzama, Allapot, Datum, FizetesModja, VasarloAzonosito)
VALUES
	('000044', 500, 590, 1, 'false', '2022-01-20', 'Bank', 1111120)

INSERT INTO dbo.RendeltTermek
	(TermekAzonosito, RendelesAzonosito, MegrendeltMennyiseg)
VALUES
	('AD0001', '000044', 1)


/*SELECT COUNT(*) AS Darab FROM RendeltTermek*/