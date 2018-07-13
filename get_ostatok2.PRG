lparameters parSkl,parDat,parKodm
local res
local hh
local pskl,pdat,pkodm,pres

res = 0

hh = sqlconnect('sqldb','sa','111')
if hh <> 0

	pskl = parSkl
	pdat = parDat
	pkodm = parKodm
	
	local retcode
	
	pres = 11
	retcode = sqlexec( hh, 'exec my_get_ostatok2 ?pskl, ?pdat, ?pkodm, ?@pres' )
	
	
	res = pres

	sqldisconnect(hh)
endif

return res



*!*	* получить остаток по складу, дате, коду материала
*!*	lparameters parSkl,parDat,parKodm
*!*	local res,dvig

*!*	res = 0

*!*	* собрать остатки
*!*	select * from ostatok where sklad_id = parSkl and dat = parDat and kodm = parKodm;
*!*		into cursor cost1
*!*	scan all
*!*		res = res + cost1.kol
*!*	endscan
*!*	use in cost1

*!*	* вытянуть движения
*!*	dvig = 0
*!*	select * from dvigen where sklad1 = parSkl and dat = parDat and kodm = parKodm ;
*!*		into cursor cdvig1
*!*	scan all
*!*		dvig = dvig + cdvig1.kol
*!*	endscan
*!*	use in cdvig1

*!*	res = res - dvig

*!*	return res
