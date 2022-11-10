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