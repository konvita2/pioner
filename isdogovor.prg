* определяет относится ли данный шифр запуска 
* к определенному договору (предпоследняя группа цифр в шифре запуска)
lparameters parDog,parShwz
local nPoints,n1,n2
local sNom
local res

res = .f.

nPoints = occurs('.',parShwz)
if nPoints >= 2
	n1 = at('.',parShwz,nPoints-1)
	n2 = at('.',parShwz,nPoints)
	if n2 - n1 = 4
		sNom = substr(parShwz,n1+1,3)
		if sNom == parDog
			res = .t.	
		endif		
	endif	
endif	

return res


