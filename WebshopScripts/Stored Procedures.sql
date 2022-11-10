/* írjunk egy tárolt eljárást, mely minen termékünket megdrágítja 10%-al*/
ALTER PROCEDURE arEmeles
AS
BEGIN
	UPDATE Termek
	SET EgysegAr = EgysegAr*1.1
END;

EXECUTE arEmeles;

/* írjunk egy tárolt eljárást, mely adott értékkel drágítja meg a termékeket.*/

ALTER PROCEDURE arEmelesValtozoval
(@szazalek SMALLINT)
AS
BEGIN
	UPDATE Termek
	SET EgysegAr = EgysegAr*(1 + @szazalek/100)
END;

EXECUTE arEmelesValtozoval 10;

/* írjunk egy tárolt eljárást, mely adott értékkel drágítja meg az adott kategoriaban levő termékeket.*/

CREATE PROCEDURE arEmelesValtozokkal
(@szazalek SMALLINT, @kategoria NVARCHAR(50))
AS
BEGIN
	UPDATE Termek
	SET EgysegAr = EgysegAr*(1 + @szazalek/100)
	WHERE Termek.KategoriaNev = @kategoria
END;

EXECUTE arEmelesValtozokkal 10, Nike

/*Ugyanez, csak ellenőrizzük, hogy létezik-e a kategória?*/

CREATE PROCEDURE arEmelesValtozokkalEllenorzessel
(@szazalek SMALLINT, @kategoria NVARCHAR(50))
AS
BEGIN
	IF (SELECT COUNT(*) FROM Termek WHERE KategoriaNev = @kategoria) > 0
		/*UPDATE Termek
		SET EgysegAr = EgysegAr*(1 + @szazalek/100)
		WHERE Termek.KategoriaNev = @kategoria*/
		PRINT 'Létezik a kategória';

	ELSE
		PRINT 'Nem létezik a kategória';
END;

EXECUTE arEmelesValtozokkalEllenorzessel 10, Nike

/*------------------------------------------------------*/

CREATE PROCEDURE arEmelesValtozokkalEllenorzesselExist
(@szazalek SMALLINT, @kategoria NVARCHAR(50))
AS
BEGIN
	IF EXISTS(SELECT KategoriaNev FROM Termek WHERE KategoriaNev = @kategoria)
		BEGIN
			PRINT 'Létezik a kategória';
			UPDATE Termek
			SET EgysegAr = EgysegAr*(1 + @szazalek/100)
			WHERE Termek.KategoriaNev = @kategoria
		END
	ELSE
		BEGIN
			PRINT 'Nem létezik a kategória';
		END
END;

/*Akkor kell begin-end ha */

/*írjunk egy eljárást amely kiszámolja az aktuális év x negyedévének a bevételét.*/

ALTER PROCEDURE sumNegyedev
(@negyedev SMALLINT)
AS
BEGIN
	DECLARE @osszeg INT

	IF @negyedev >5 OR @negyedev < 1
		PRINT 'A negyedév 1 és 4 között kell legyen.'
	ELSE
	BEGIN
		SELECT @osszeg =  SUM(Osszeg) FROM Rendeles
		WHERE DATEPART(qq, Datum) = @negyedev
		PRINT 'A negyedév bevétele: ' + CONVERT(VARCHAR(10), @osszeg)
		/*WHERE YEAR(Datum) = YEAR(GETDATE())
		WHERE (MONTH(Datum) < 3*@negyedev AND MONTH(Datum) >= 3*(@negyedev-1))*/
	END
END;

EXEC sumNegyedev 2

/*Egy bizonyos termekbol mennyi bevetelunk szarmazik*/

ALTER PROCEDURE sumTermekBevetel
(@termekID VARCHAR(13),
@negyedev SMALLINT,
@osszeg INT OUTPUT)
AS
BEGIN
	DECLARE @darab INT
	IF @negyedev >5 OR @negyedev < 1
		BEGIN
			PRINT 'A negyedév 1 és 4 között kell legyen.'
		END

	IF (SELECT COUNT(*) FROM Termek WHERE TermekAzonosito = @termekID) > 0
		BEGIN
			PRINT 'Létezik a termék';
			SELECT @darab = SUM (MegrendeltMennyiseg) FROM RendeltTermek 
			INNER JOIN Rendeles ON RendeltTermek.RendelesAzonosito = Rendeles.RendelesAzonosito
			WHERE RendeltTermek.TermekAzonosito = @termekID AND DATEPART(qq, Datum) = @negyedev;

			SELECT @osszeg = SUM(EladasiAr * @darab) FROM Termek WHERE TermekAzonosito = @termekID;
			PRINT @osszeg
		END
	ELSE
		PRINT 'Nem létezik a termék';
END;

DECLARE @osszegVissza INT;
DECLARE @osszegVissza1 INT;

EXEC sumTermekBevetel 
	@termekID = 'AD0001',
	@negyedev = 1,
	@osszeg = @osszegVissza OUTPUT;

EXEC sumTermekBevetel 
	@termekID = 'AD0001',
	@negyedev = 2,
	@osszeg = @osszegVissza1 OUTPUT;

SELECT @osszegVissza AS ElsoNegyedev, @osszegVissza1 AS MasodikNegyedev;

DECLARE @szazalek INT;

IF (@osszegVissza > @osszegVissza1)
	BEGIN
		SET @szazalek = ((@osszegVissza - @osszegVissza1) / @osszegVissza1)*100;
		PRINT 'Az elso negyedev ' + CONVERT(VARCHAR(20), @szazalek) +' -al nagyobb a bevetel'
	END
ELSE IF (@osszegVissza = @osszegVissza1)
	PRINT 'A ket negyedevben egyenlo a bevetel a termekbol'
ELSE
	BEGIN
		SET @szazalek = ((@osszegVissza1 - @osszegVissza) / @osszegVissza)*100;
		PRINT 'A masodik negyedev ' + CONVERT(VARCHAR(20), @szazalek) +' %-al nagyobb a bevetel'
	END

/*Hetvegi rendelesek szama*/

/*Adott honapra megmondja ki a legjobb ugyfelunk*/

ALTER PROCEDURE legjobbUgyfel
(@honap SMALLINT,
@nev VARCHAR(30) OUTPUT)
AS
BEGIN
	DECLARE @tmp VARCHAR(30)

	SELECT TOP 1 @tmp = Rendeles.VasarloAzonosito
	FROM Rendeles
	WHERE MONTH(Datum) = @honap
	GROUP BY Rendeles.VasarloAzonosito
	ORDER BY SUM(Rendeles.RendelesKoltseg) DESC

	SELECT @nev = CONCAT(KeresztNev, ' ', VezetekNev) FROM Vasarlo WHERE VasarloAzonosito = @tmp
END

DECLARE @legjobbVasarlo VARCHAR(30)

EXEC legjobbUgyfel
	@honap =  3,
	@nev = @legjobbVasarlo OUTPUT

SELECT @legjobbVasarlo AS LegjobbKliens


