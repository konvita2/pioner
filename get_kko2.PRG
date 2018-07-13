lparameters parKko,parUs
Local res
*!*	nn = get_kko(this.value,3)

Local hhh,rr
hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	rr = SQLExec(hhh,'select im,sim from DOSP where vid=30 and kod = ?parKko and us = ?parUs','cc83')
	If rr = -1
		eodbc('tokar_prg_te sele')
	Endif
	If Reccount()>0
		res = Alltrim(cc83.im) + ' '+Alltrim(cc83.sim)
	Else
		res = ''
	Endif
	Use In cc83
	SQLDisconnect(hhh)
Else
	eodbc('freza t_Tpz conn')
ENDIF

RETURN res