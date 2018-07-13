lparameters parShwz
local res

res = ctod('')

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
				res = sqlresult.data_z
		endcase 

		sqldisconnect(hh)
	else
		eodbc()
	endif
endif

if !isnull(res)
	if res < date(2000,1,1)
		res = ctod('')
	endif
endif

return res