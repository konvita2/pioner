lparameters parKod
local mres

do 	case	
	case	parKod = 1
		mres = 'Серийное производство'
	case	parKod = 2
		mres = 'Единичное производство'
	case	parKod = 3
		mres = 'Собственные нужды'
	case	parKod = 4
		mres = 'Сторонние организации'
	otherwise 
		mres = ''
endcase 

return mres