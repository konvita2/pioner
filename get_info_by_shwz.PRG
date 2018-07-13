* получить информацию по изделию по шифру запуска
lparameters pShwz
local hh,rr,sq
local sres as String

sres = ''

if empty(pShwz)
	return sres
endif

hh = sqlcn()
if hh > 0
	sq = "select * from izd where rtrim(shwz)=?pShwz"
	rr = sqlexec(hh,sq,'csq')
	if rr = -1
		eodbc('get_info_by_shwz sele')
	else
		if reccount('csq')>0
			select csq
			go top
			sres = alltrim(str(csq.kod)) + ' ' + alltrim(csq.ribf) + ' ' + alltrim(csq.im)		
		endif				
	endif
	sqldisconnect(hh)
else
	eodbc('get_info_by_shwz conn')
endif

return sres
