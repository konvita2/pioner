* определить du по номеру склада
* если нет подходящего склада
* считаем d_u = 1
* !!! считаем что еще надо корректировать

lparameters pSklad
local res

res = 1

if inlist(pSklad,20,22)
	res = 1
endif	

if inlist(pSklad,21)
	res = 4
endif	

return res
