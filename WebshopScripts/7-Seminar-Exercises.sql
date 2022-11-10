/*Mai rendelesek szama*/
SELECT COUNT(*) AS RendelesekSzamaMa
FROM Rendeles WHERE Datum = CONVERT(varchar(10), GETDATE(), 110)

/*Hany rendeles volt az elozo honapban*/
SELECT COUNT(*) AS RendelesekSzamaHonapban
FROM Rendeles WHERE MONTH(Datum) = MONTH(GETDATE()) -1

/*Elozo honap rendeleseinek osszerteke*/
SELECT SUM(Osszeg) AS RendelesekOsszege
FROM Rendeles WHERE MONTH(Datum) = MONTH(GETDATE()) -1

/*Havonta hany rendeles van*/
SELECT COUNT(*) AS RendelesekSzama, DATENAME(MONTH, Datum) AS Honap
FROM Rendeles 
GROUP BY DATENAME(MONTH, Datum);

/*Ugyfelek szama helysegekre bontva*/
SELECT COUNT(*) AS RendelesekSzama, Helyseg AS Helyseg
FROM Vasarlo
GROUP BY Helyseg

/*Melyik honapban volt legalabb 5 rendeles*/
SELECT COUNT(*) AS RendelesekSzama, DATENAME(MONTH, Datum) AS Honap
FROM Rendeles 
GROUP BY DATENAME(MONTH, Datum)
HAVING COUNT(*) > 5

/*Ki vett X termeket?*/
SELECT VezetekNev,KeresztNev 
FROM Vasarlo INNER JOIN Rendeles ON Vasarlo.VasarloAzonosito=Rendeles.VasarloAzonosito
INNER JOIN RendeltTermek ON RendeltTermek.RendelesAzonosito=Rendeles.RendelesAzonosito
INNER JOIN Termek ON RendeltTermek.TermekAzonosito=Termek.TermekAzonosito 
WHERE Termek.TermekAzonosito = 'JO0001'

INTERSECT

SELECT VezetekNev,KeresztNev 
FROM Vasarlo INNER JOIN Rendeles ON Vasarlo.VasarloAzonosito=Rendeles.VasarloAzonosito
INNER JOIN RendeltTermek ON RendeltTermek.RendelesAzonosito=Rendeles.RendelesAzonosito
INNER JOIN Termek ON RendeltTermek.TermekAzonosito=Termek.TermekAzonosito 
WHERE Termek.TermekAzonosito = 'JO0002'

/*Kategoriankent hany termek van*/
SELECT COUNT(*) AS TermekekSzama, KategoriaNev AS Kategoria
FROM Termek
GROUP BY KategoriaNev

/*Melyik kategoriaban van legalabb 2 termek*/
SELECT COUNT(*) AS TermekekSzama, KategoriaNev AS Kategoria
FROM Termek
GROUP BY KategoriaNev
HAVING COUNT(*) >= 2
