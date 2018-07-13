* вывести наименование статуса лимитки одной позиции
lparameters pStatus
local res

res = ''

do case
	case pStatus = 0
		res = 'Предварительный'
	case pStatus = 10
		res = 'Отпечатан'
	case pStatus = 20
		res = 'Выдан'	
	case pStatus = 15
		res = 'Частично выдан'		
	case pStatus = 30
		res = 'Бухгалтерия'			
endcase

return res
