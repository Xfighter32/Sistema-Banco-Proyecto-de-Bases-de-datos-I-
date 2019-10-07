USE [Sistema_Banco]
GO
/****** Object:  StoredProcedure [dbo].[CASP_GetIdMoneda]    Script Date: 10/7/2019 10:25:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Austin Hakanson>
-- Create date: <09-09-2019>
-- Description:	<Procedimiento almacenado para 
-- obtener el id de moneda pasando un simbolo 
-- por paramentro>
-- =============================================
ALTER PROCEDURE	[dbo].[CASP_GetIdMoneda]
	-- Add the parameters for the stored procedure here
	@Simbolo nvarchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT id
	FROM Moneda
	WHERE @Simbolo = Simbolo
END
