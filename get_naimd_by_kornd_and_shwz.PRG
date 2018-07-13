lparameters parKornd,parShwz
local izdkod,res
local hh,rr

res = ''

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select top 1 naimd from ktshwz '+;
			'where rtrim(kornd) = rtrim(?parKornd) and '+;
			'rtrim(shwz) = rtrim(?parshwz)','cdktt')
	if rr = -1
		eodbc('get_naimd_by_kornd_and_shwz sele')	
	endif
	select cdktt
	if reccount()>0
		res = cdktt.naimd
	endif
	use in cdktt		
	sqldisconnect(hh)
else
	eodbc('get_naimd_by_kornd_and_shwz conn')
endif

return res
