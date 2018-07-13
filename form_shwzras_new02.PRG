* новая версия формирователя эталонной базы по 
* шифру запуска (для второго маршрута)
lparameters parShwz

local ans

* проверить есть ли еще шифр запуска
select * from shwzras02 where alltrim(shwz) == alltrim(parShwz) ;
    and !empty(shwz) ;
    into cursor cc10
if reccount()>0
    wait window nowait 'Удаляются существующие записи'
    delete from shwzras02 where alltrim(shwz)	== alltrim(parShwz)
endif
use in cc10

* получаем код изделия
local lcShw
lcShw = get_izd_kod_by_shwz(parShwz)

*  определяем сколько изделий в запуске 	
*  kol1
local lnKol1
select * from izd ;
    where ;
    !empty(shwz) and ;
    alltrim(shwz) == alltrim(parShwz);
    into cursor cc50
if reccount()>0
    lnKol1 = cc50.partz2 - cc50.partz1 + 1
else
    lnKol1 = 0
    wait window nowait 'Такого изделия нет'
endif
use in cc50

* выбираем по материалам
select ;
	dist mater.kodm, mater.naim, mater.kod, mater.ei, kt.mar1, kt.mar2, kt.d_u;		
	from mater,kt;
	where;
		kt.shw = m.lcShw ;
		and kt.kodm = mater.kodm;
		and kt.kodm <> 0;
	order by mater.naim ;	
	into curs cc30
scan all
	*** progress
	*wait window nowait 'Выполнено '+str(100*recno()/reccount(),3)+'%' 
	waitproc(recno(),reccount(),'Формирование эталонной базы 2-го уровня')
	*** выборка норм
	do case
		case	cc30.d_u = 1 .or. cc30.d_u = 5	
			select sum(koli * nrmd) as snrmd, sum(koli) as skoli;
				from kt;
				where;
				kt.kodm = cc30.kodm;
				and kt.shw = m.lcShw;
				and mar1 = cc30.mar1 and mar2 = cc30.mar2;
				into curs cc40
		case	cc30.d_u = 4
			select sum(kol1 * koli / kol) as snrmd, sum(koli) as skoli;
				from kt;
				where;
				kt.kodm = cc30.kodm;
				and kt.shw = m.lcShw;
				and mar1 = cc30.mar1 and mar2 = cc30.mar2;
				into curs cc40
	endcase
	*** newid
    select * from shwzras02 order by id into cursor cc44
    if reccount()>0
        go bottom
        newid = cc44.id+1
    else
        newid = 1
    endif
    use in cc44	
	*** write into shwzras02
	insert into shwzras02;
		(id,kodm,kolizd,kol1,shwz,mar1,mar2,du,koli);
		values;
		(newid,cc30.kodm,lnKol1,cc40.snrmd,parShwz,cc30.mar1,cc30.mar2,get_du_by_shwz_kodm(parShwz,cc30.kodm),cc40.skoli)
	*** close cc40
	use in cc40
endscan 	
use in cc30	

wait window nowait 'Добавление в эталонную базу 02 завершено' 
	
		