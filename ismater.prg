* test if mater record exist
lparameters parkodm
local hh,rr,res

res = .f.

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select top 1 * from mater','cdd1mat')
	if rr = -1
		eodbc('ismater sele')
	endif
	
	select cdd1mat
	if reccount()>0
		res = .t.	
	endif
	
	use in cdd1mat
	sqldisconnect(hh)
else
	eodbc('ismater conn')
endif

return res
