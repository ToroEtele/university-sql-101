Select VezetekNev, KeresztNev FROM Vasarlo WHERE Bank = 'CEC Banc'

Select VezetekNev, KeresztNev FROM Vasarlo WHERE Email LIKE '%yahoo.com'

--kik rendeltek a termékből

Select DISTINCT VezetekNev, KeresztNev FROM Vasarlo
INNER JOIN Rendeles ON Vasarlo.VasarloAzonosito = Rendeles.VasarloAzonosito
INNER JOIN RendeltTermek ON Rendeles.RendelesAzonosito = RendeltTermek.RendelesAzonosito
WHERE TermekAzonosito = 'AD0001'

