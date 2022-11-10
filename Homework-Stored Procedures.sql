--Allapot mezo atallitasa

ALTER PROCEDURE kiszallitva
AS
BEGIN
	UPDATE Rendeles
	SET Allapot = 'True'
END;

EXECUTE kiszallitva;

--adott rendeles allapotanak atallitasa

CREATE PROCEDURE rendelesKiszallitva
(@id VARCHAR(13))
AS
BEGIN
		IF (SELECT COUNT(*) FROM Rendeles WHERE RendelesAzonosito = @id) <> 1
			PRINT 'Nem letezik a termek';
		ELSE
			BEGIN
				UPDATE Rendeles
				SET Allapot = 'True'
				WHERE RendelesAzonosito = @id
			END
END;

EXECUTE rendelesKiszallitva '000001';

--adott rendeles allapotanak atallitasa es a bearamlo penz visszateritese

CREATE PROCEDURE rendelesKiszallitvaOsszegVissza
(@id VARCHAR(13),
@osszeg money OUTPUT)
AS
BEGIN
	IF (SELECT COUNT(*) FROM Rendeles WHERE RendelesAzonosito = @id) <> 1
			PRINT 'Nem letezik a termek';
		ELSE
			BEGIN
				UPDATE Rendeles
				SET Allapot = 'True'
				WHERE RendelesAzonosito = @id
			END
	@osszeg = SELECT Osszeg FROM Rendeles WHERE RendelesAzonosito = @id
END

DECLARE @bearamloPenz VARCHAR(30)

EXEC rendelesKiszallitvaOsszegVissza
	@id =  '0000001',
	@osszeg = @bearamloPenz OUTPUT

SELECT @bearamloPenz AS Bearamlo