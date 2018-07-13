lparameters parShwz
local res

res = ctod('')

if !empty(parshwz)
	local hh
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		local rr
		rr = sqlexec(hh,'select * from izd where rtrim(shwz) = rtrim(?parshwz)','sql1')
		do	case
			case	rr = -1
				eodbc()
			case	rr > 0	
				res = sql1.dat_td
				res = iif(res < date(2000,1,1),ctod(''),ttod(res))
		endcase 

		use in sql1
		sqldisconnect(hh)
	else
		eodbc()
	endif
endif

return res