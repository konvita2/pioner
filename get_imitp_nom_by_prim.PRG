lparameters pPrim
local hh,rr,res,sq

res = 0

hh = sqlcn()
if hh > 0
	sq = 'select * from imitp where rtrim(nam) = ?pPrim'
	rr = sqlexec(hh,sq,'sqlr')
	if rr = -1
		eodbc('get_imitp_nom_by_prim sele')
	else
		select sqlr
		if reccount()>0
			go top
			res = sqlr.nom
			use in sqlr
		endif
	endif
	sqldisconnect(hh)
else
	eodbc('get_imitp_nom_by_prim conn')
endif

return res