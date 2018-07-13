lparameters parShwz
local res

res = 0

if !empty(parshwz)
	local hh
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		local rr
		rr = sqlexec(hh,'select * from izd where rtrim(shwz) = rtrim(?parshwz)')
		do	case
			case	rr = -1
				eodbc()
			otherwise
				select sqlresult 
				if reccount()>0				
					res = sqlresult.partz1
				endif	
		endcase 

		sqldisconnect(hh)
	else
		eodbc()
	endif
endif

return res


