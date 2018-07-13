lparameters parKornd,parShwz
local izdkod,res

res = ''

izdkod = get_izd_kod_by_shwz(parShwz)
if izdkod <> 0
	select top 1 * from kt where shw = izdkod ;
		and !empty(kornd) and alltrim(kornd) == alltrim(parKornd) ;
		order by kod into cursor c302
	if reccount()>0
		res = c302.naimd
	endif
	use in c302
endif

return res
