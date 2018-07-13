*lparameters parGod

* ============================================
* Экпорт ЛЗК в 1С
* пока что выгружаются все введенные лимитки
* ============================================ 

local mlimit

mlimit = getnastr('limpath')

*** очистка файла ЛЗК
wait window nowait 'Очистка файла limit.dbf'
set safety off 
select 0
use (mlimit) alias limit exclusive 
zap
use 

*** заполнение файла limit.dbf
local hh,rr,mgod

*mgod = parGod

hh = sqlconnect('sqldb','sa','111')
if hh <= 0
	eodbc('exp_limit conn')
	return
endif
rr = sqlexec(hh,'select * from ras where vvod=1 order by dat,sklad1','c22')
if rr = -1
	eodbc('exp_limit sele1')
endif	

select c22
scan all
	wait window nowait 'Выгружено лимиток '+alltrim(str(100*recno('c22')/reccount('c22')))+'%' 
	
	*select * from dvigen where nom = c22.nom and nom1 = c22.nom1 into cursor c33
	rr = sqlexec(hh,'select * from dvigen where nom = ?c22.nom and nom1 = ?c22.nom1','c33')
	if rr = -1
		eodbc('exp_limit sele2')
	endif
	
	select c33
	scan all
		local mdid
		select did from (mlimit) order by did into cursor c44
		if reccount()>0
			mdid = 1+c44.did
		else
			mdid = 1
		endif
		use in c44
			
		
		insert into (mlimit) ;
			(did,ndoc,dat,sklad1,sklad2,;
			 vid,cherez,kodm,nsk,kol,;
			 cena,shwz,ei,note,izm,;
			 shw,kol1,oboz,part,dpart;
			 );
			values;
			(mdid,alltrim(str(c22.nom))+'.'+alltrim(str(c22.nom1)),c22.dat,c33.sklad1,c33.sklad2,;
			 0,'',c33.kodm,c33.nsk,c33.kol,;
			 c33.summ/c33.kol, c22.shwz, get_mater_ei1(c33.kodm),'',.f.,;
			 get_izd_kod_by_shwz(c22.shwz), 0, '', c33.partname, c33.partdate; 
			 )
	endscan
	use in c33
endscan 	
use in c22

use in limit