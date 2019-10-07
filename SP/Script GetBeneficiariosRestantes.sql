USE [Sistema_Banco]
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetBeneficiariosRestantes]    Script Date: 10/7/2019 2:54:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <10/6/19>
-- Description:	<SP para obtener beneficiarios distintaos al seleccionado para modificar de una cuenta >
-- =============================================
ALTER PROCEDURE [dbo].[CASP_GetBeneficiariosRestantes]
	-- Parametros
	@Numero_Cuenta nvarchar(50),
	@DocID_Beneficiario_Modificar nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT B.Nombre, B.Porcentaje
	FROM Beneficiario B
	WHERE B.Documento_Identificacion != @DocID_Beneficiario_Modificar 
		  and B.Numero_Cuenta = @Numero_Cuenta and B.Activo = 1
END
