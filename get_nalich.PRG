* ===================================
* получить остаток материала по указанному
* складу на указанную дату
lparameters parSkl,parKodm,parDat
local mres
local hh,rr

mres = 0

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select isnull(sum(kol),0) as sumkol from ostatok where kodm = ?parkodm and '+;
					'sklad_id = ?parskl and dat = ?pardat','c56')
	if rr = -1
		eodbc('get_nalich sele')
	endif				
	select c56
	if reccount()>0
		mres = c56.sumkol
	endif
	use in c56
else
	eodbc('get_nalich conn')
endif

return mres	

