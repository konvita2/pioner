lparameters parkod
local res

res = space(40)

if !empty(parkod)
	local hh
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		local rr
		rr = sqlexec(hh,'select * from izd where kod = ?parkod')
		do	case
			case	rr = -1
				eodbc()
			case	rr > 0	
				res = alltrim(sqlresult.im)
		endcase 

		sqldisconnect(hh)
	else
		eodbc()
	endif
endif

return res

