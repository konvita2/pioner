* Печать ведомости нетехнологических остатков
local npp
create cursor cout;
	(;
		np n(4),;
		kodm n(6),;
		naimmat c(80),;
		vsum n(12,3);
	)
	
npp = 1	
select kod,sum(ra*rb) as plos from ostatki;
	where pri=2 or pri=3;
	order by kod;
	group by kod;
	into cursor cost	
if reccount()>0
	scan all
		select cout
		scatter memvar 
		np = npp
		kodm = cost.kod
		naimmat = get_mater(cost.kod)
		vsum = cost.plos * get_mater_tm(cost.kod) * get_mater_uv(cost.kod) / 1000000
		insert into cout from memvar
		npp = npp+1
	endscan 
else
	wait window 'Нет данных для формирования отчета!' 
	use in cost
	use in cout
	return
endif	

use in cost

select cout
report form r_printnetech01 preview
	
use in cout
	
	