USE [Sistema_Banco]
GO
/****** Object:  StoredProcedure [dbo].[CASP_EliminarBeneficiario]    Script Date: 9/7/2019 4:28:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

-- Si ya existe un proceso de eliminacion, no haga otro mas
IF OBJECT_ID('CASP_EliminarBeneficiario') IS NOT NULL
BEGIN 
DROP PROC [CASP_EliminarBeneficiario] 
END

GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CASP_EliminarBeneficiario]
	-- Add the parameters for the stored procedure here
	@Numero_Cuenta nvarchar(50),
	@docID nvarchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		-- Se verifica primero que los parametros no vengan nulos

		IF @Numero_Cuenta = NULL
		BEGIN
			return -100001
		END

		IF @docID = NULL
		BEGIN
			return -100002
		END
		-- Si el beneficiario existe entonces 
		IF EXISTS (SELECT CA.id, P.id, TID.id, B.Nombre, B.Parentesco, B.Porcentaje, B.Activo,
						B.Fecha_Desactivacion, B.Tipo_Documento_Identificacion,
						B.Documento_Identificacion, B.Email, B.Telefono1,
						B.Telefono2, B.Numero_Cuenta, B.Fecha_Nacimiento
				   FROM dbo.Beneficiario B, CuentaAhorro CA, Parentesco P, TipoID TID
				   WHERE CA.Numero_Cuenta = @Numero_Cuenta and B.Documento_Identificacion = @docID)
		BEGIN
			UPDATE dbo.Beneficiario
			SET Activo = 0,
				Fecha_Desactivacion = CAST(getdate() as date)
			FROM dbo.Beneficiario B, CuentaAhorro CA
			WHERE CA.Numero_Cuenta = @Numero_Cuenta and B.Documento_Identificacion = @docID
		END

		ELSE
			BEGIN
				return -100003
			END

	END TRY

	BEGIN CATCH
		SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_MESSAGE() AS ErrorMessage
	END CATCH
END
