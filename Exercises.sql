--Gyakorló feladatsor:

--Oszlop hozzáadása : datum + ido : oszlop törlése

ALTER TABLE Rendeles
ADD Hatarido date

UPDATE Rendeles
SET Hatarido = DATEADD(month, 1, Datum)

ALTER TABLE Rendeles
DROP COLUMN Hatarido

--Melyik kategóriából származott legnagyobb bevétel előző negyedévben?

SELECT TOP 1 SUM(EladasiAr * MegrendeltMennyiseg) AS TeljesBevetel
FROM Termek
INNER JOIN RendeltTermek ON Termek.TermekAzonosito = RendeltTermek.TermekAzonosito
INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito
WHERE DATEPART(qq, Datum) = DATEPART(qq, GETDATE())
GROUP BY KategoriaNev
ORDER BY TeljesBevetel DESC

--Mennyi az AFA erteke negyedevenkent az aktualis evre

SELECT SUM(Osszeg - RendelesKoltseg) AS Afa, DATEPART(qq, Datum) AS Negyedev
FROM Rendeles
WHERE YEAR(Datum) = YEAR(GETDATE())
GROUP BY DATEPART(qq, Datum)

SELECT SUM(RendelesKoltseg) AS Afa, DATEPART(qq, Datum) AS Negyedev
FROM Rendeles
WHERE YEAR(Datum) = YEAR(GETDATE())
GROUP BY DATEPART(qq, Datum)

SELECT Osszeg, RendelesKoltseg, (Osszeg - RendelesKoltseg), Datum
FROM Rendeles
WHERE DATEPART(qq, Datum) = '1' AND YEAR(Datum) = YEAR(GETDATE())

--Előző hónapban több mint 1500 lejre adtunk el most meg semmit

SELECT TermekNev 
FROM Termek
INNER JOIN RendeltTermek ON Termek.TermekAzonosito = RendeltTermek.TermekAzonosito
INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito
WHERE MONTH(Datum) = MONTH(GETDATE())-1 AND YEAR(Datum) = YEAR(GETDATE())
GROUP BY TermekNev
HAVING SUM(EladasiAr * MegrendeltMennyiseg) > 1500

INTERSECT

SELECT TermekNev FROM Termek WHERE TermekNev
NOT IN (SELECT TermekNev
FROM Termek
INNER JOIN RendeltTermek ON Termek.TermekAzonosito = RendeltTermek.TermekAzonosito
INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito
WHERE YEAR(Datum) = YEAR(GETDATE()) AND MONTH(Datum) = MONTH(GETDATE())
GROUP BY TermekNev)

--Eljárás, mely megdragítja az adott kategóriába tartozó termékeket X%-al

--Megvan a tarolt eljarasokban

--az ev legnepszerutlenebb termeke

SELECT TermekNev, COUNT(*)
FROM Termek 
INNER JOIN RendeltTermek ON termek.TermekAzonosito = RendeltTermek.TermekAzonosito
INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito
WHERE YEAR(Datum) = YEAR(GETDATE()) 
GROUP BY TermekNev
ORDER BY COUNT(*) ASC
