lparameters pNom
local hh,rr,res,sq

res = ''

hh = sqlcn()
if hh > 0
	sq = 'select * from imitp where nom = ?pNom'
	rr = sqlexec(hh,sq,'sqlr')
	if rr = -1
		eodbc('get_imitp_prim_by_nom sele')
	else
		select sqlr
		if reccount()>0
			go top
			res = sqlr.nam
			use in sqlr
		endif
	endif
	sqldisconnect(hh)
else
	eodbc('get_imitp_prim_by_nom conn')
endif

return res