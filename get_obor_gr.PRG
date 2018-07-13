lparameters parKodo
local res
local hh,rr

*select * from obor where alltrim(marka) == alltrim(parKodo) into cursor cc56
hh = sqlconnect('sqldb','sa','111')
if hh>0

	rr = sqlexec(hh,'select * from obor where rtrim(marka)=rtrim(?parkodo)','cc56')
	if rr = -1
		eodbc('get_obor_gr sele')
	endif	

	if reccount()>0
		res = cc56.gr
	else
		res = 0
	endif
	use in cc56
	
	sqldisconnect(hh)
else
	eodbc('get_obor_gr conn')
endif


return res