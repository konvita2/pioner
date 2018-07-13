* получить участок план-задания по номеру и участку
*  а какой смысл имеет эта функция? :-)
lparameters parNzad,parMar
local mres

mres = 0
select * from pz where nzad = parNzad and mar = parMar into cursor c34
if reccount()>0
	mres = c34.mar
endif
use in c34

return mres

