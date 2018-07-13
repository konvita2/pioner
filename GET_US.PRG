* получить расшифровку условия по коду
Lparameters parKodu

Local res
If parKodu>0
	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		rrr = SQLExec(hhh,"select im from KTU where LEFT(TTP,11)='06024.55290' AND npp = ?parKodu",'C_us')
		If rrr = -1
			eodbc('det_us.prg Select KTU')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('det_us.prg conn')
	Endif
	If Reccount()>0
		res = c_us.im
	Else
		res = ''
	Endif
	Use In c_us
Else
	res = ''
Endif
Return res
