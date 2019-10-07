USE [Sistema_Banco]
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetDatosUsuario]    Script Date: 9/16/2019 9:56:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <09-09-2019>
-- Description:	<Obtencion de datos de usuario>
-- =============================================
ALTER PROCEDURE [dbo].[CASP_GetDatosUsuario] 

	@Usuario nvarchar(100),
	@Clave nvarchar(100)
AS
BEGIN
	
	SET NOCOUNT ON

	BEGIN TRY

		IF @Usuario = ''
		BEGIN
			return -100001
		END

		IF @Clave = ''
		BEGIN
			return -100002
		END
	
		SELECT CA.Numero_Cuenta, C.Nombre
		FROM dbo.Cliente C, dbo.CuentaAhorro CA
		WHERE (C.Usuario = @Usuario and C.Clave = @Clave) and (CA.idCliente = C.id)
		
	END TRY

	BEGIN CATCH
		return @@ERROR * -1
	END CATCH
END