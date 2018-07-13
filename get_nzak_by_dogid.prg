lparameters pardogid 
local hh,rr,res

res = '   '

hh = sqlconnect('sqldb','sa','111')
if hh>0
	rr = sqlexec(hh,'select * from izd where dogid=?pardogid','cdc1')
	if rr <> -1
	
		select cdc1
		if reccount()>0	
			go top
			if !empty(cdc1.shwz)	
				res = get_nzak_by_shwz(cdc1.shwz)	
			endif
		endif	
		
	else
		eodbc('get_nzak_by_dogid sele')
	endif
	sqldisconnect(hh)
else
	eodbc('get_nzak_by_dogid conn')
endif

return res

