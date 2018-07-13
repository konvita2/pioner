*** напечатать маршрут по ww по shwz начиная с указанного машрута
*** как в get_mar_by_poznd_cut_123
lparameters parShwz,parKornd,parMar
local mshwz,mmar,mres,mold,mkornd

mshwz = parShwz
mmar = parMar
mres = ''
mold = -1
mkornd = parKornd

*!*	select mar,nto from ww where alltrim(shwz) == alltrim(mshwz) 
*!* and alltrim(kornd) == alltrim(mkornd);
*!*		order by nto into cursor cc55

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select mar,nto from ww where rtrim(shwz)=rtrim(?mshwz) and '+;
					'rtrim(kornd)=rtrim(?mkornd)','cc55')
	if rr = -1
		eodbc('get_mar_by_poznd_cut_ww sele')
	endif	
	
	if reccount()>0
		locate for mar = mmar
		scan rest
			* add if no this
			if cc55.mar <> mold
				mres = mres + iif(empty(mres),'','-') + alltrim(str(cc55.mar))
				mold = cc55.mar
			endif	
		endscan 	
	endif
	use in cc55	
					
	sqldisconnect(hh)
else
	eodbc('get_mar_by_poznd_cut_ww conn')
endif
release hh,rr	

return mres