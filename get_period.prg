* выводит период в виде "Январь 2007 г."
lparameters parGod,parMes
local smes
local res

res = ''

do	case
	case	parMes = 1
		smes = 'Январь'
	case	parMes = 2
		smes = 'Февраль'
	case	parMes = 3
		smes = 'Март'
	case	parMes = 4
		smes = 'Апрель'
	case	parMes = 5
		smes = 'Май'
	case	parMes = 6
		smes = 'Июнь'
	case	parMes = 7
		smes = 'Июль'
	case	parMes = 8
		smes = 'Август'
	case	parMes = 9
		smes = 'Сентябрь'
	case	parMes = 10
		smes = 'Октябрь'
	case	parMes = 11
		smes = 'Ноябрь'
	case	parMes = 12
		smes = 'Декабрь'
	otherwise
		smes = ''
endcase  

res = smes + ' ' + alltrim(str(parGod)) + ' г.'

return res