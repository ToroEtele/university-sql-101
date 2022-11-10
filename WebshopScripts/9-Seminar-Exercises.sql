/*X ügyfél rendelései*/
SELECT TermekNev FROM Termek
INNER JOIN RendeltTermek ON Termek.TermekAzonosito=RendeltTermek.TermekAzonosito
INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito=Rendeles.RendelesAzonosito
WHERE VasarloAzonosito = '1111116' 

SELECT Termek.TermekNev FROM TERMEK WHERE TermekAzonosito IN (SELECT RendeltTermek.TermekAzonosito
FROM RendeltTermek 
INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito WHERE VasarloAzonosito =  '1111116')

/*X ügyfél rendelései termekenkent*/

SELECT TermekNev, SUM(RendeltTermek.MegrendeltMennyiseg) AS Darab FROM Termek
INNER JOIN RendeltTermek ON Termek.TermekAzonosito=RendeltTermek.TermekAzonosito
INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito=Rendeles.RendelesAzonosito
WHERE VasarloAzonosito = '1111116' 
GROUP BY TermekNev

SELECT TermekAzonosito, SUM(RendeltTermek.MegrendeltMennyiseg) AS Darab 
FROM RendeltTermek INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito 
WHERE VasarloAzonosito = '1111116'
GROUP BY TermekAzonosito

SELECT TermekAzonosito, SUM(RendeltTermek.MegrendeltMennyiseg) AS Darab 
FROM RendeltTermek INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito 
WHERE VasarloAzonosito = '1111116' AND YEAR(Datum) = 2022
GROUP BY TermekAzonosito

/*Melyek azok a termekek amelyekből a vásárló sosem rendelt?*/

SELECT TermekNev FROM Termek
EXCEPT
SELECT Termek.TermekNev FROM TERMEK WHERE TermekAzonosito IN (SELECT RendeltTermek.TermekAzonosito
FROM RendeltTermek 
INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito WHERE VasarloAzonosito =  '1111116')

SELECT TermekNev FROM Termek WHERE TermekNev
NOT IN (SELECT Termek.TermekNev FROM TERMEK WHERE TermekAzonosito IN (SELECT RendeltTermek.TermekAzonosito
FROM RendeltTermek 
INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito WHERE VasarloAzonosito =  '1111116'))

/*RendeltTermek RendeltMennyiseg Ar - rendeles teljes aranak kiszamolasa termekenkent*/

SELECT	Termek.TermekNev, RendeltTermek.MegrendeltMennyiseg, Termek.EladasiAr,
		RendeltTermek.MegrendeltMennyiseg * Termek.EladasiAr AS OsszErtek,
		RendeltTermek.MegrendeltMennyiseg * Termek.EladasiAr * AfaKulcs / 100 AS TVA,
		RendeltTermek.MegrendeltMennyiseg * Termek.EladasiAr + RendeltTermek.MegrendeltMennyiseg * Termek.EladasiAr * AfaKulcs / 100 AS TeljesErt
FROM RendeltTermek 
INNER JOIN Termek ON RendeltTermek.TermekAzonosito = Termek.TermekAzonosito
INNER JOIN Kategoria ON Termek.KategoriaNev = Kategoria.KategoriaNev
WHERE RendelesAzonosito = '000021'

/*A rendelés teljes értéke. A rendelés tábla összeg mezőjébe kerül.*/

SELECT	SUM(RendeltTermek.MegrendeltMennyiseg * Termek.EladasiAr + RendeltTermek.MegrendeltMennyiseg * Termek.EladasiAr * AfaKulcs / 100) AS TeljesErt
FROM RendeltTermek 
INNER JOIN Termek ON RendeltTermek.TermekAzonosito = Termek.TermekAzonosito
INNER JOIN Kategoria ON Termek.KategoriaNev = Kategoria.KategoriaNev
WHERE RendelesAzonosito = '000021'

UPDATE Rendeles
SET Osszeg = (SELECT SUM(RendeltTermek.MegrendeltMennyiseg * Termek.EladasiAr + RendeltTermek.MegrendeltMennyiseg * Termek.EladasiAr * AfaKulcs / 100) AS TeljesErt
FROM RendeltTermek 
INNER JOIN Termek ON RendeltTermek.TermekAzonosito = Termek.TermekAzonosito
INNER JOIN Kategoria ON Termek.KategoriaNev = Kategoria.KategoriaNev
WHERE RendelesAzonosito = '000020')
WHERE RendelesAzonosito = '000020'