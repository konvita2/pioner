* получить объем материала который списан по лзк по шифру запуска
lparameters parShwz,parKodm

local res

res = 0

select sum(kol) as skol ;
	from matrast;
	where;
		alltrim(shwz) == alltrim(parShwz);
		and !empty(shwz);
		and kodm = parKodm;
	into cursor c14	
if reccount()>0
	res = c14.skol
else
	res = 0
endif	
	
use in c14	

return res