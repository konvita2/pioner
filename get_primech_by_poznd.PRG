* получить примечание по poznd
lparameters parPoznd
local mpp,mres,mfound 

mpp = parPoznd
mres=''
mfound = .f.

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select top 1 * from kt where poznd=?parpoznd and d_u<4','ckti')
	if rr = -1
		eodbc('get_primech_by_poznd sele')
	endif

	select ckti
	if reccount()>0
		local f1,f2,f3,f4,f5
		f1 = iif(empty(ckti.primech), '',alltrim(ckti.primech)+'; ')	
		f2 = iif(empty(get_dosp56(ckti.kodzag)),'',alltrim(get_dosp56(ckti.kodzag))+'; ')
		f3 = iif(empty(ckti.pokr),'',alltrim(ckti.pokr)+'; ')
		f4 = iif(empty(ckti.gpokr),'',alltrim(ckti.gpokr)+'; ')
		f5 = iif(empty(ckti.twer),'',alltrim(ckti.twer))
		mres = f1 + f2 + f3 + f4 + f5	
	endif

	use in ckti
	sqldisconnect(hh)
else
	eodbc('get_primech_by_poznd conn')
endif


return mres

select ckti
*!*	seek parPoznd
*!*	do while found() and ckti.d_u < 4
*!*		seek parPoznd
*!*	enddo

seek parPoznd
if found() and ckti.d_u >= 4
	mfound = .f.
	do while !empty(ckti.poznd) and alltrim(ckti.poznd) == alltrim(parPoznd)
		if d_u < 4
			mfound = .t.
			exit
		endif
		skip
	enddo
else
	mfound = .t.
endif
	
if mfound
	local f1,f2,f3,f4,f5
	f1 = iif(empty(ckti.primech), '',alltrim(ckti.primech)+'; ')	
	f2 = iif(empty(get_dosp56(ckti.kodzag)),'',alltrim(get_dosp56(ckti.kodzag))+'; ')
	f3 = iif(empty(ckti.pokr),'',alltrim(ckti.pokr)+'; ')
	f4 = iif(empty(ckti.gpokr),'',alltrim(ckti.gpokr)+'; ')
	f5 = iif(empty(ckti.twer),'',alltrim(ckti.twer))
	mres = f1 + f2 + f3 + f4 + f5
endif

return mres
