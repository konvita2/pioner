lparameters parKod
local res

res = space(30)

if parkod > 0
	local hh
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		local rr
		rr = sqlexec(hh,'select top 1 * from izd where kod = ?parkod')
		do	case
			case	rr = -1
				eodbc()
			case	rr > 0
				res = alltrim(sqlresult.ribf)	
		endcase 
	
		sqldisconnect(hh)
	else
		eodbc()
	endif	
endif

return res

