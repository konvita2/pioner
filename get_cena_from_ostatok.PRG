lparameters parKodm
local res

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select cena from ostatok where kodm = ?parkodm order by cena ')
	do	case
		case	rr = -1
			eodbc()
			res = 0
		case	rr = 0
			res = 0
		case	rr > 0
			select sqlresult
			go bottom
			res = sqlresult.cena
	endcase 
	
	sqldisconnect(hh)	
else
	eodbc()
	res = 0
endif

return res
