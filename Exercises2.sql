--1.Feladat Hány nap késés van a ki nem fizetett számlákon?

SELECT SZAM_SZ, DATEDIFF(day, HATARIDO, GETDATE()) AS NapKeses
FROM SZFE
WHERE TARTOZAS <> 0

--2.feladat A 20016-os év legnépszerűbb termékéből rendeljünk még 100-at.

DECLARE @NEV nvarchar(20)

SET @NEV = (SELECT TOP 1 NEV AS LegnepszerubbTermek
FROM CIKK
INNER JOIN SZSE ON CIKK.KOD = SZSE.CIKK_KOD
INNER JOIN SZFE ON SZSE.SZAM_SZ = SZFE.SZAM_SZ
WHERE YEAR(SZFE.DATUM) = 2016
GROUP BY NEV
ORDER BY COUNT(*) DESC)

UPDATE CIKK
SET ALLAPOT = '10'
WHERE NEV = @NEV

--SELECT * FROM CIKK WHERE NEV = @NEV

--3.Feladat Írjanak tárolt eljárást, amely megkap paraméterként egy termékkódot és visszatéríti, hogy az illető termékből milyen értékben adtunk el?

ALTER PROCEDURE sumTermekBevetel
(@termekID NVARCHAR(20),
@osszeg FLOAT OUTPUT)
AS
BEGIN
	SELECT @osszeg = SUM(MENNYISEG * ELAD_AR)
	FROM SZSE
	WHERE CIKK_KOD = @termekID
END

DECLARE @osszegVissza FLOAT;

EXEC sumTermekBevetel 
	@termekID = '12001480',
	@osszeg = @osszegVissza OUTPUT;

SELECT @osszegVissza AS BevetelTermek



--EZ NINCS FELTOLTVE
--Csak at kellett irni a nevet kodra

DECLARE @KOD nvarchar(20)

SET @KOD = (SELECT TOP 1 CIKK_KOD AS LegnepszerubbTermek
FROM SZSE
INNER JOIN SZFE ON SZSE.SZAM_SZ = SZFE.SZAM_SZ
WHERE YEAR(SZFE.DATUM) = 2016
GROUP BY CIKK_KOD
ORDER BY COUNT(*) DESC)

SELECT * FROM CIKK WHERE KOD = @KOD

UPDATE CIKK
SET ALLAPOT = '10'
WHERE KOD = @KOD
