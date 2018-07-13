* получить сумму выданного материала из dvigen
lparameters parshwz,parkodm,parsklad2
local hh,rr,res

res = 0

hh = sqlconnect('sqldb','sa','111')
if hh>0
	
	rr = sqlexec(hh,'select isnull(sum(summ),0) as ssumm from dvigen,ras where dvigen.nom=ras.nom and dvigen.nom1=ras.nom1 and '+;
					'rtrim(ras.shwz)=rtrim(?parshwz) and dvigen.kodm=?parkodm and dvigen.sklad2=?parsklad2','cdf')
	if rr <> -1
		res = cdf.ssumm	
		use in cdf	
	else
		eodbc('get_dvigen_sum_by_shwz_kodm_sklad2 sele')
	endif	
	
	sqldisconnect(hh)
else
	eodbc('get_dvigen_sum_by_shwz_kodm_sklad2 conn')
endif

return res