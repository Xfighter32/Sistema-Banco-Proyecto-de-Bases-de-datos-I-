USE [Sistema_Banco]
GO
/****** Object:  StoredProcedure [dbo].[CASP_ActualizarBeneficiario]    Script Date: 10/6/2019 10:22:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <15-09-2019>
-- Description:	<SP para actualizar los datos de 1 usuario>
-- =============================================

ALTER PROCEDURE [dbo].[CASP_ActualizarBeneficiario]
	-- Parametros de los otros beneficiarios
	@Porcentaje1 int,
	@Documento_Identificacion1 nvarchar(100),
	@Porcentaje2 int,
	@Documento_Identificacion2 nvarchar(100),

	-- Parametros del potencial NUEVO Beneficiario
	@Nombre nvarchar(100),
	@Nuevo_Nombre nvarchar(100),
	@Parentesco nvarchar(3),
	@Porcentaje int,
	@Tipo_Documento_Identificacion nvarchar(100),
	@Nuevo_Tipo_Documento_Identificacion nvarchar(100),
	@Documento_Identificacion nvarchar(50),
	@Nuevo_Documento_Identificacion nvarchar(50),
	@Email nvarchar(100),
	@Telefono1 int,
	@Telefono2 int,
	@Numero_Cuenta nvarchar(50),
	@Fecha_Nacimiento date
AS
BEGIN

-- Se verifica que los parametros no vengan en NULL

	IF @Porcentaje1 IS NULL
	BEGIN
		SET @Porcentaje1 = 0
	END

	IF @Documento_Identificacion1 IS NULL
	BEGIN
		SET @Documento_Identificacion1 = 0
	END

	IF @Porcentaje2 IS NULL
	BEGIN
		SET @Porcentaje2 = 0
	END

	IF @Documento_Identificacion2 IS NULL
	BEGIN
		SET @Documento_Identificacion2 = 0
	END

	IF @Nombre IS NULL
	BEGIN
		return -100003
	END

	IF @Nuevo_Nombre IS NULL
	BEGIN
		return -100003
	END

	IF @Parentesco IS NULL
	BEGIN
		return -100004
	END

	IF @Porcentaje IS NULL
	BEGIN
		return -100005
	END

	IF @Tipo_Documento_Identificacion IS NULL
	BEGIN
		return -100006
	END

	IF @Nuevo_Tipo_Documento_Identificacion IS NULL
	BEGIN
		return -100006
	END

	IF @Documento_Identificacion IS NULL
	BEGIN
		return -100007
	END

	IF @Nuevo_Documento_Identificacion IS NULL
	BEGIN
		return -100007
	END

	IF @Email IS NULL
	BEGIN
		return -100008
	END

	IF @Telefono1 IS NULL
	BEGIN
		return -100009
	END

	IF @Telefono2 IS NULL
	BEGIN
		return -100010
	END

	IF @Numero_Cuenta IS NULL
	BEGIN
		return -100011
	END

	IF @Fecha_Nacimiento IS NULL
	BEGIN
		return -100012
	END
	
IF EXISTS(SELECT B.id
		FROM Beneficiario B
		WHERE B.Nombre = @Nombre and B.Numero_Cuenta = @Numero_Cuenta
		and B.Documento_Identificacion = @Documento_Identificacion and B.Activo = 1)
	BEGIN

		-- Se calcula la suma de los porcentajes de los beneficiarios
		DECLARE @SumaPorcentaje int

		SELECT @SumaPorcentaje = SUM(B.Porcentaje)
		FROM dbo.Beneficiario B
		WHERE B.Numero_Cuenta = @Numero_Cuenta AND B.Activo = 1	

		-- Se verifica que el porcentaje ingresado no sea superior a 100
		IF (@Porcentaje > 100) 
		BEGIN
			return -100013 --  EL porcentaje ingresado es mayor a 100
		END
		
		IF (@Porcentaje + @Porcentaje1 + @Porcentaje2) <= 100
		BEGIN
			DECLARE @temp TABLE 
				(
				idCuenta int,
				idParentesco int,
				idTipoID int,
				Nombre nvarchar (100),
				Parentesco nvarchar (3),
				Porcentaje int,
				Activo int,
				Fecha_Desactivacion date,
				Tipo_Documento_Identificacion nvarchar (100),
				Documento_Identificacion nvarchar(50),
				Email nvarchar (100),
				Telefono1 int,
				Telefono2 int,
				Numero_Cuenta nvarchar(50),
				Fecha_Nacimiento date
				)

			INSERT INTO @temp 
			SELECT CA.id, P.id, TID.id, @Nuevo_Nombre, P.Nombre, @Porcentaje, B.Activo, B.Fecha_Desactivacion,
					@Nuevo_Tipo_Documento_Identificacion, @Nuevo_Documento_Identificacion, @Email, @Telefono1,
					@Telefono2, @Numero_Cuenta, convert(datetime, @Fecha_Nacimiento, 103)
			FROM CuentaAhorro CA, Parentesco P, TipoID TID, Beneficiario B
			WHERE CA.Numero_Cuenta = @Numero_Cuenta and P.Nombre = @Parentesco and
					TID.Nombre = @Nuevo_Tipo_Documento_Identificacion and B.Numero_Cuenta = @Numero_Cuenta 
					and B.Documento_Identificacion = @Documento_Identificacion
			UNION ALL
			SELECT B.idCuenta, B.idParentesco, B.idTipoID, B.Nombre, B.Parentesco, @Porcentaje1, B.Activo, 
					B.Fecha_Desactivacion, B.Tipo_Documento_Identificacion, B.Documento_Identificacion, 
					B.Email, B.Telefono1, B.Telefono2, B.Numero_Cuenta,convert(datetime, B.Fecha_Nacimiento, 103)
			FROM Beneficiario B
			WHERE B.Numero_Cuenta = @Numero_Cuenta and B.Documento_Identificacion = @Documento_Identificacion1
			UNION ALL
			SELECT B.idCuenta, B.idParentesco, B.idTipoID, B.Nombre, B.Parentesco, @Porcentaje2, B.Activo,
					B.Fecha_Desactivacion, B.Tipo_Documento_Identificacion, B.Documento_Identificacion, 
					B.Email, B.Telefono1, B.Telefono2, B.Numero_Cuenta, convert(datetime, B.Fecha_Nacimiento, 103)
			FROM Beneficiario B
			WHERE B.Numero_Cuenta = @Numero_Cuenta and B.Documento_Identificacion = @Documento_Identificacion2

			SELECT t.idCuenta, t.idParentesco, t.idTipoID, t.Nombre, t.Parentesco, t.Porcentaje, t.Activo,
					t.Fecha_Desactivacion, t.Tipo_Documento_Identificacion, t.Documento_Identificacion,
					t.Email, t.Telefono1, t.Telefono2, t.Numero_Cuenta, convert(datetime, t.Fecha_Nacimiento, 103)
			FROM @temp t

			-- Se seleccionan los id correctos de acuerdo con los parametros
			DECLARE @idParentesco int
			DECLARE @idTipoID int
			DECLARE @idCuenta int
			SELECT @idParentesco = P.id FROM Parentesco P  WHERE P.Nombre = @Parentesco
			SELECT @idTipoID = TID.id FROM TipoID TID  WHERE TID.Nombre = @Nuevo_Tipo_Documento_Identificacion
			SELECT @idCuenta = CA.id FROM CuentaAhorro CA  WHERE CA.Numero_Cuenta = @Numero_Cuenta

			---- Se procede a actualizar la tabla de beneficiarios
			UPDATE Beneficiario
			SET idCuenta = t.idCuenta,
				idParentesco = t.idParentesco,
				idTipoID = t.idTipoID,
				Nombre = t.Nombre,
				Parentesco = t.Parentesco,
				Porcentaje = t.Porcentaje,
				Tipo_Documento_Identificacion =  t.Tipo_Documento_Identificacion ,
				Documento_Identificacion = t.Documento_Identificacion,
				Email = t.Email,
				Telefono1 = t.Telefono1,
				Telefono2 = t.Telefono2,
				Numero_Cuenta = t.Numero_Cuenta,
				Fecha_Nacimiento =convert(datetime, t.Fecha_Nacimiento, 103)
			FROM Beneficiario B
				 INNER JOIN @temp t
				 ON B.Numero_Cuenta = t.Numero_Cuenta
				 and B.Documento_Identificacion = @Documento_Identificacion
		END
		ELSE
			BEGIN
				return -100014 -- Los porcentajes no suman exactamente 100
			END
	END
ELSE
	BEGIN
		return -100015 -- No se encontro una combinacion Nombre-Numero_Cuenta-Documento_Identificacion
						-- que hiciera pareja en la BD
	END

	SELECT *
	FROM Beneficiario
END
