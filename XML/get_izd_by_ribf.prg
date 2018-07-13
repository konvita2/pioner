lparameters parRibf
local res

res = -1
if !empty(parribf)
	local hh
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		local rr
		rr = sqlexec(hh,'select * from izdfull where rtrim(ribf) = rtrim(?parribf)')
		do	case
			case	rr = -1
				eodbc()
			case	rr > 0
				res = sqlresult.kod
		endcase 	
		sqldisconnect(hh)
	else
		eodbc()
	endif
endif

return res

	
