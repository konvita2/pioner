* печать ведомости технологических отходов
local npp
npp=1

create cursor cout(;
	np n(8),;
	kodm n(10),;
	naimm c(80),;
	dat d,;
	no n(8),;
	nl n(8),;
	ra n(12),;
	rb n(12),;
	ves n(12,3);
)

select * from ostatki;
	where pri=0;
	order by kod,nlista,nost;
	into cursor cc
if reccount()>0
	scan all
		* ход формирования
		wait window nowait 'Выполнено '+alltrim(str(100*recno()/reccount()))+'%' 
		* переносим данные
		select cout
		scatter memvar 		
		np = npp
		kodm = cc.kod
		naimm = get_mater(cc.kod)
		dat = cc.dat_o
		no = cc.nost
		nl = cc.nlista
		ra = cc.ra
		rb = cc.rb	
		ves = cc.ra * cc.rb * get_mater_tm(cc.kod) * get_mater_uv(cc.kod) / 1000000	
		insert into cout from memvar 
		npp = npp+1
	endscan	
else
	wait window 'Нет данных для формирования отчета!' 
	use in cc
	return
endif	
use in cc

wait window nowait 'Готово' 
select cout
report form r_printost preview	

use in cout