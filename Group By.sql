--Feladatok GROUP BY-al

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

/*Kategoriankent hany termek van*/
SELECT COUNT(*) AS TermekekSzama, KategoriaNev AS Kategoria
FROM Termek
GROUP BY KategoriaNev

/*Melyik kategoriaban van legalabb 2 termek*/
SELECT COUNT(*) AS TermekekSzama, KategoriaNev AS Kategoria
FROM Termek
GROUP BY KategoriaNev
HAVING COUNT(*) >= 2

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


--Házi feladat:

/*4.Feladat: XY ugyfel hanyszor rendelt az egyes kategoriakbol legalább egy terméket.*/
SELECT Kategoria.KategoriaNev,COUNT(*) AS RendelesekSzama FROM Kategoria 
INNER JOIN Termek ON Termek.KategoriaNev = Kategoria.KategoriaNev
INNER JOIN RendeltTermek ON RendeltTermek.TermekAzonosito = Termek.TermekAzonosito
INNER JOIN Rendeles ON Rendeles.RendelesAzonosito = RendeltTermek.RendelesAzonosito
WHERE VasarloAzonosito = '1111111'
GROUP BY Kategoria.KategoriaNev