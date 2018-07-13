open database db
set procedure to procs
local savkodm,savsort,savgr,savkod

*** восстанавливаем группы
select * from mater where gr=0 into cursor c10
scan all
	savkodm = c10.kodm
	savsort = c10.sort
	savgr = get_grkod_by_sortkod(savsort)
	update mater set;
		gr = savgr;
		where kodm = savkodm
	wait window nowait 'Восстановление группы Материал '+get_mater(savkodm)
endscan
use in c10

*** перестраиваем коды
select * from mater into cursor c10
scan all
	savkodm = c10.kodm
	savkod = fpr2(c10.gr,c10.sort,c10.sp,c10.sh)
	update mater set;
		kod = savkod;
		where kodm = savkodm
	wait window nowait 'Перестройка кодов Материал '+get_mater(savkodm) 	
endscan
use in c10


wait window nowait 'ВСЕ!' 


close databases all
return 

* =========================================
*** получить по сортаменту группу материала
function get_grkod_by_sortkod(parsortkod)
	local mres
	mres = 0
	select * from db!v_sort where kod = parsortkod and kod <> 0 into cursor c100
	if reccount()>0
		mres = c100.us
	endif
	use in c100
	return mres
endfunc