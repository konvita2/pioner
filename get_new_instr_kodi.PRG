* получить новый код для справочника инструментов
local res,hh,rr

hh = sqlconnect('sqldb','sa','111')
if hh>0
	rr = sqlexec(hh,'select kodi from instr order by kodi','cdcc')
	if rr = -1
		eodbc('het_new_instr_kodi sele')
	endif

	select cdcc
	if reccount()>0
		go bottom
		res = cdcc.kodi + 1
	else
		res = 1	
	endif
	
	use in cdcc
	sqldisconnect(hh)
else
	eodbc('get_new_instr_kodi conn')
endif

return res

* ///////////////////////////////////////
*!*	local lnRes,svWA

*!*	m.svWA = select(0)
*!*	select 0

*!*	select * from instr into cursor c818
*!*	if reccount()>0
*!*		local a[1]
*!*		select max(kodi) from instr into array a
*!*		m.lnRes = a[1]+1
*!*	else
*!*		m.lnRes = 1
*!*	endif
*!*	use in c818

*!*	select (m.svWA)

*!*	return m.lnRes
