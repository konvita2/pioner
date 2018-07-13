lparameters parKornd,parShwz 
local izdkod,res

res = 0

select * from izd ;
	where alltrim(shwz) == alltrim(parShwz) ;
		and !empty(shwz) ;
	into cursor c301
if reccount()>0
	izdkod = c301.kod
	select * from kt where shw = izdkod ;
		and !empty(kornd) and alltrim(kornd) == alltrim(parKornd) ;
		into cursor c302
	if reccount()>0
		res = c302.wag
	endif	
	use in c302	
endif	
use in c301		

return res