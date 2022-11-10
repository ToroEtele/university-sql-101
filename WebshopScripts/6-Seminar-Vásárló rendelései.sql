USE Webshop

SELECT * FROM Rendeles INNER JOIN RendeltTermek ON Rendeles.RendelesAzonosito = RendeltTermek.RendelesAzonosito
WHERE VasarloAzonosito = '1111111'