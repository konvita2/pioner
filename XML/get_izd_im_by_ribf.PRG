lparameters parRibf
local res

res = space(40)

if !empty(parribf)
	local hh
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		local rr
		rr = sqlexec(hh,'select * from izd where rtrim(ribf) = rtrim(?parribf)')
		do	case
			case	rr = -1
				eodbc()
			case	rr > 0
				res = sqlresult.im	
		endcase 

		sqldisconnect(hh)
	else
		eodbc()
	endif
endif

return res

