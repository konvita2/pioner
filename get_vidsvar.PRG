
* ============================================
* получить строковое предстваление вида сварки
lparameters parVid
	local mres	
	mres = ''
	do	case	
		case	parVid = 1
			mres = 'Сварка дуговая'	
		case	parVid = 2
			mres = 'Сварка CO2'
		case	parVid = 3
			mres = 'Сварка аргонная'
	endcase 
return mres
