* =====================================
* задаем имя партии, дату, код материала,
* склад и получаем движение за день
lparameters parpart,pardat,parkodm,parsklad

local res,hh

res = 0

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local ppar,pdat,pkodm,psklad
	
	ppar = parpart
	pdat = pardat
	pkodm = parkodm
	psklad = parsklad
	
	local rc
	
	local aa
	aa = 0
	rc = sqlexec(hh,'{CALL my_get_kolras2(?ppar,?pdat,?pkodm,?psklad,?@aa)}')
	res = aa

	sqldisconnect(hh)
endif

return iif(isnull(res),0,res)

*!*	local res
*!*	res  = 0

*!*	select sum(kol) as sumkol;
*!*		from dvigen;
*!*		where partname = parpart and dat = pardat and ;
*!*		kodm = parkodm and sklad1 = parsklad;
*!*		into cursor ccvv
*!*	res = ccvv.sumkol
*!*	use in ccvv

*!*	return res


