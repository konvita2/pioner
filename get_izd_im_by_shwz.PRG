lparameters parshwz

local res
res = space(40)

if !empty(parshwz)
	local hh
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		local rr
		rr = sqlexec(hh,'select * from izd where rtrim(shwz) = rtrim(?parshwz)')
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

return alltrim(res)
