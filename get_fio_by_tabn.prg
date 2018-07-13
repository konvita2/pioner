lparameters parTabn
local svres,hh,rr

svres = space(35)

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from kadry where tn = ?partabn')
	do	case
		case	rr = -1
			eodbc()
		case 	rr = 0
			svres = space(35)
		case	rr > 0
			svres = sqlresult.fio
	endcase 
	sqldisconnect(hh)
else
	eodbc()
endif

return m.svRes