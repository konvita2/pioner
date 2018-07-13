* получить код+обозн+наим изделия по shwz
lparameters parshwz
local res
local hh,rr

res = ''

if !empty(parshwz)

	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		rr = sqlexec(hh,'select * from izdfull where rtrim(shwz) = rtrim(?parshwz)','cdizd')
		if rr = -1
			eodbc('get_izd_info_by_shwz sele')
		endif

		select cdizd
		if reccount()>0
			res = alltrim(str(cdizd.kod)) + ' ' + alltrim(cdizd.ribf) + ' ' +;
				alltrim(cdizd.im)
		endif

		sqldisconnect(hh)
	else
		eodbc('get_izd_info_by_shwz conn')
	endif

endif


return res
