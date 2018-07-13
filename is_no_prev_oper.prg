* данная процедура проверяет есть ли для данной детали
* в ww операции незапланированные или недопланированные
* parameters:
* shwz, poznd, kornd, nto
lparameters parShwz,parPoznd,parKornd,parNto
local mres
mres = .t.

select * from ww where;
	kolz <> kzp and;
	alltrim(shwz) == alltrim(parShwz) and;
	alltrim(poznd) == alltrim(parPoznd) and;
	alltrim(kornd) == alltrim(parKornd) and;
	nto < parNto ;
	into cursor c12
if reccount()>0	
	mres = .f.
endif
use in c12	

return mres
