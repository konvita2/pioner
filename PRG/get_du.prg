lparameters parDu
local mres
mres = ''

do	case
	case	parDu = 1
		mres = 'Основные'
	case	parDu = 4
		mres = 'Покупные'
	case	parDu = 5
		mres = 'Вспомогательные'
endcase 

return mres 

