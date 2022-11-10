/*Házi Toró Etele*/

/*1.Feladat: 700 lejt meghaladó rendelések (1 táblás)*/
SELECT RendelesAzonosito, Osszeg FROM Rendeles WHERE Osszeg > 700

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