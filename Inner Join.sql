--Feladatok INNER JOIN-al

/*Ki vett X termeket?*/
SELECT VezetekNev,KeresztNev 
FROM Vasarlo INNER JOIN Rendeles ON Vasarlo.VasarloAzonosito=Rendeles.VasarloAzonosito
INNER JOIN RendeltTermek ON RendeltTermek.RendelesAzonosito=Rendeles.RendelesAzonosito
INNER JOIN Termek ON RendeltTermek.TermekAzonosito=Termek.TermekAzonosito 
WHERE Termek.TermekAzonosito = 'JO0001'

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

--Házi feladat:

/*2.Feladat: Kik rendeltek egy adott termekből Vasarlo -> Rendeles -> Rendelt Termek*/
SELECT KeresztNev, VezetekNev FROM Vasarlo WHERE VasarloAzonosito IN (SELECT VasarloAzonosito FROM Rendeles
INNER JOIN RendeltTermek ON Rendeles.RendelesAzonosito = RendeltTermek.RendelesAzonosito WHERE TermekAzonosito = 'JO0001' AND MONTH(Datum) = 5) 


/*3.Feladat: Kik nem rendeltek egy adott termekbol*/
SELECT VasarloAzonosito FROM Vasarlo
EXCEPT
SELECT VasarloAzonosito FROM Vasarlo WHERE VasarloAzonosito IN (SELECT VasarloAzonosito FROM Rendeles
INNER JOIN RendeltTermek ON Rendeles.RendelesAzonosito = RendeltTermek.RendelesAzonosito WHERE TermekAzonosito = 'JO0001')

SELECT VasarloAzonosito FROM Vasarlo WHERE VasarloAzonosito
NOT IN(SELECT VasarloAzonosito FROM Vasarlo WHERE VasarloAzonosito IN (SELECT VasarloAzonosito FROM Rendeles
INNER JOIN RendeltTermek ON Rendeles.RendelesAzonosito = RendeltTermek.RendelesAzonosito WHERE TermekAzonosito = 'JO0001'))

/*4.Feladat: XY ugyfel hanyszor rendelt az egyes kategoriakbol legalább egy terméket.*/
SELECT Kategoria.KategoriaNev,COUNT(*) AS RendelesekSzama FROM Kategoria 
INNER JOIN Termek ON Termek.KategoriaNev = Kategoria.KategoriaNev
INNER JOIN RendeltTermek ON RendeltTermek.TermekAzonosito = Termek.TermekAzonosito
INNER JOIN Rendeles ON Rendeles.RendelesAzonosito = RendeltTermek.RendelesAzonosito
WHERE VasarloAzonosito = '1111111'
GROUP BY Kategoria.KategoriaNev