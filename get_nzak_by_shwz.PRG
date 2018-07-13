* получить номер заказа из шифра запуска
* цифры между последней и предпоследней точками
lparameters parshwz

local res
local nn,pos1,pos2

res = '   '

nn = occurs('.',parshwz)
if nn >=2 
	pos1 = rat('.',parshwz,2)
	pos2 = rat('.',parshwz,1)
	res = substr(parshwz,pos1+1,3)
	
else
	res = '   '
endif

return res