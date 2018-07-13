CREATE cursor bud (NOZAP INT, INDEX_N INT, GOD INT, MES INT, PODR INT, PODRI C(50), MERO C(150), DEBET C(8), SUMMA_DE n(12,2), CREDIT C(8), SUMMA_CR n(12,2), SALDO n(12,2), TIP_SCHETA INT, TIP_ZATRAT INT)
*!*	local hhh,rrsql
*!*	hhh = SQLConnect('sqldb','sa','111')
*!*	If hhh > 0
*!*		rrr = SQLExec(hhh,'select * from BUDJET','BUD')
*!*		If rrr = -1
*!*			eodbc('BUDJET Sele')
*!*		Endif
*!*		SQLDisconnect(hhh)
*!*	Else
*!*		eodbc('BUDJET conn')
*!*	endif
*!*	brow
do form f_budjet_sql