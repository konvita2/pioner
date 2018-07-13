* получить сальдо из остатков (для спр мат для финдир)
*	входной параметр
*		parKodm
* 	выходной параметр
*		parKol
*		parSum
* 		parCen
*		parDat
lparameters parKodm,parKol,parSum,parCen,parDat
local mskl,mdat

parKol = 0
parSum = 0
parCen = 0
parDat = ctod('')

* получить склад по умолчанию
mskl = get_mater_sklad(parKodm)

* получить последнюю дату по которой есть этот материал

*select dist dat from ostatok where kodm = parKodm and kol>0 and sklad_id = mskl order by dat into cursor cdd

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0

	rr = sqlexec(hh,'select distinct dat from ostatok where kodm = ?parKodm and kol>0 and sklad_id = ?mskl order by dat','cdd')
	if rr = -1
		eodbc('get_saldo sele1')
	endif

	select cdd
	if reccount()>0
		go bottom
		mdat = cdd.dat
	else
		mdat = ctod('')
	endif
	use in cdd
*
	if !empty(mdat)
		local msum,mkol,mcena
		msum = 0
		mkol = 0
*		select * from ostatok where dat = mdat and kodm = parKodm and sklad_id = mskl into cursor cost

		rr = sqlexec(hh,'select * from ostatok where dat = ?mdat and kodm = ?parKodm and sklad_id = ?mskl','cost')
		if rr = -1
			eodbc('get_saldo sele2')
		endif
		
		select cost
		scan all
			msum = msum + cost.kol*cost.cena
			mkol = mkol + cost.kol
		endscan

		if mkol <> 0
			mcena = msum/mkol
		else
			mcena = 0
		endif	

		use in cost

		parKol = mkol
		parCen = mcena
		parSum = msum
		parDat = mdat
	endif

	sqldisconnect(hh)
else
	eodbc('get_saldo conn')
endif
