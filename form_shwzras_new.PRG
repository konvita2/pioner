* нова€ верси€ формировател€ эталонной базы по
* шифру запуска
* возвращает ответ
lparameters parshwz
local res
res = 1

local ans

* проверить есть ли еще шифр запуска
select * from shwzras where alltrim(shwz) == alltrim(parshwz) ;
	and !empty(shwz) ;
	into cursor cc10
if reccount()>0
	ans = messagebox('¬ базе потребностей материалов такой код уже есть! «аменить его?',4+32)
	if ans <> 6
		wait window nowait 'Ѕаза потребности в материалах не было сформирована!'		
		res = 0
		return res
	else
		wait window nowait '”дал€ютс€ существующие записи'
		delete from shwzras where alltrim(shwz)	== alltrim(parshwz)
	endif
endif
use in cc10

* получаем код издели€
local lcshw
lcshw = get_izd_kod_by_shwz(parshwz)

*  определ€ем сколько изделий в запуске
*  kol1
local lnkol1
select * from izd ;
	where ;
	!empty(shwz) and ;
	alltrim(shwz) == alltrim(parshwz);
	into cursor cc50
if reccount()>0
	lnkol1 = cc50.partz2 - cc50.partz1 + 1
else
	lnkol1 = 0
	wait window nowait '“акого издели€ нет'
endif
use in cc50

* выбираем по материалам
select ;
	dist mater.kodm, mater.naim, mater.kod, mater.ei, kt.mar1, kt.d_u;
	from mater,kt;
	where;
	kt.shw = m.lcshw ;
	and kt.kodm = mater.kodm;
	and kt.kodm <> 0;
	and inlist(kt.d_u,1,4,5);
	order by mater.naim ;
	into curs cc30
scan all
	*** progress
	*wait window nowait '¬ыполнено '+str(100*recno()/reccount(),3)+'%'
	waitproc(recno(),reccount(),'‘ормирование эталонной базы 1-го уровн€')
	*** выборка норм
	do case
		case	cc30.d_u = 1 .or. cc30.d_u = 5
			select sum(koli * nrmd) as snrmd, sum(koli) as skoli;
				from kt;
				where;
				kt.kodm = cc30.kodm;
				and kt.shw = m.lcshw;
				and mar1 = cc30.mar1;
				into curs cc40
		case	cc30.d_u = 4
			select sum(kol1 * koli / kol) as snrmd, sum(koli) as skoli;
				from kt;
				where;
				kt.kodm = cc30.kodm;
				and kt.shw = m.lcshw;
				and mar1 = cc30.mar1;
				into curs cc40
	endcase
	*** newid
	select * from shwzras order by id into cursor cc44
	if reccount()>0
		go bottom
		newid = cc44.id+1
	else
		newid = 1
	endif
	use in cc44
	*** write into shwzras
	insert into shwzras;
		(id,kodm,kolizd,kol1,shwz,mar1,du,koli,dat);
		values;
		(newid,cc30.kodm,lnkol1,cc40.snrmd,parshwz,cc30.mar1,get_du_by_shwz_kodm(parshwz,cc30.kodm),cc40.skoli,date())
	*** close cc40
	use in cc40
endscan
use in cc30

*** запишем dattd дл€ данного издели€
wait window 'Ќе забудь добавить fix_izd_dattd' 

wait window nowait 'ƒобавление в эталонную базу завершено'

return res