lparameters parShwz
local res,hh,rr

res = space(30)

if !empty(parshwz)
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		rr = sqlexec(hh,'select * from izd where rtrim(shwz) = rtrim(?parshwz)')
		do	case
			case	rr = -1
				eodbc()
			case	rr > 0
				res = sqlresult.ribf	
		endcase 
		sqldisconnect(hh)		
	else
		eodbc()
	endif
endif

return alltrim(res)
