USE [Sistema_Banco]
GO
/****** Object:  StoredProcedure [dbo].[CASP_InicioSesion]    Script Date: 9/16/2019 9:58:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <7-09-2019>
-- Description:	<Validacion de inicio de sesion>
-- =============================================
ALTER PROCEDURE [dbo].[CASP_InicioSesion] 
	-- Add the parameters for the stored procedure here
	@Usuario nvarchar(100),
	@Clave nvarchar(100)
AS
BEGIN
	DECLARE @id int
	SET NOCOUNT ON

	BEGIN TRY

		IF @Usuario = ''
		BEGIN
			SET @Usuario = ' '
			return -100001
		END

		IF @Clave = ''
		BEGIN
			SET @Clave = ' '
			return -100002
		END
		
		IF EXISTS(
		SELECT CA.Numero_Cuenta, C.Nombre
		FROM dbo.Cliente C, dbo.CuentaAhorro CA
		WHERE (C.Usuario = @Usuario and C.Clave = @Clave) and (CA.idCliente = C.id)
		)
		BEGIN
			return 1
		END
		ELSE
			BEGIN
				return 2
			END
	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END