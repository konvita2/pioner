lparameters parKodm
local res

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select top 1 * from ostatok where kodm = ?parkodm order by dat desc')
	do 	case
		case	rr = -1
			eodbc()
			res = 0
		case	rr = 0
			res = 0
		case	rr > 0
			res = sqlresult.nsk
	endcase
	sqldisconnect(hh)
else
	eodbc()
	res = 0
endif

return res
