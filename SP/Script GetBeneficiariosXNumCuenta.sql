USE [Sistema_Banco]
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetBeneficiariosXNumCuenta]    Script Date: 9/30/2019 9:43:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CASP_GetBeneficiariosXNumCuenta]
	@NumeroCuenta nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT B.Nombre, P.Detalle as Parentesco, B.Porcentaje, B.Tipo_Documento_Identificacion,
			B.Documento_Identificacion, B.Email, B.Telefono1, B.Telefono2,
			B.Fecha_Nacimiento
	FROM Beneficiario B, Parentesco P
	WHERE B.Numero_Cuenta = @NumeroCuenta and B.idParentesco = P.id and B.Activo = 1
END
