Lparameters parPodr
Local res

hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	*!*					 Select * From dosp where vid = 2 And kod = parPodr into Cursor c911
	rrsql = SQLExec(hhh,'Select us From dosp where vid =60 And kod =?parPodr','C911')
	If rrsql = -1
		eodbc('F_KP btForm IZD Select')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('F_KP btForm Click IZD conn')
Endif
If Reccount()>0
	res = c911.us
Else
	res = 0
Endif
Use In c911

Return res


