* получить имя статуса наряда 
* по номеру статуса
lparameters pNum

local res
res = ''

do case
	case pNum = 0
		res = 'Предварительный'
	case pNum = 1
		res = 'Закрыт'	
endcase

return res


