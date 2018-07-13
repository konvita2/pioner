lparameters parId
local mres
mres = 0

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select nsk from ostatok where id = ?parid')
	do	case
		case	rr = -1
			eodbc()
			mres = 0
		case	rr = 0
			mres = 0
		case	rr > 0
			mres = sqlresult.nsk
	endcase 
	sqldisconnect(hh)
else
	eodbc()
	mres = 0
endif

return mres
