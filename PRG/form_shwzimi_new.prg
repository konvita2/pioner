* нова€ верси€ программы
* в отличие от shwzras здесь происходит формирование сразу
* по нескольким кодам запуска, перечисленным в списке изделий плана имитационной базы
lparameters parNom

local mnom
mnom = parNom

select * from imit where !empty(shwz) and nom = mnom into cursor ci
if reccount()>0
	* очистить предыдущую базу
	wait window nowait 'ќчистка предыдущих значений'
	select dist shwz from imit where nom = mnom and !empty(shwz) into cursor cdel
	scan all
		delete from shwzimi where alltrim(shwz) == alltrim(cdel.shwz)	
	endscan 
	use in cdel 
	* заполнить 
	select ci
	scan all
		wait window nowait '«аполнение '+alltrim(str(100*recno()/reccount()))+'%'
		
		* получаем код издели€
		local lcShw
		lcShw = ci.izd

		*  определ€ем сколько изделий в запуске 	
		*  kol1
		local lnKol1
		lnKol1 = ci.kol
		
		* выбираем по материалам
*!*			select ;
*!*				dist mater.kodm, mater.naim, mater.kod, mater.ei, kt.mar1, kt.d_u;		
*!*				from mater,kt;
*!*				where;
*!*					kt.shw = m.lcShw ;
*!*					and kt.kodm = mater.kodm;
*!*					and kt.kodm <> 0;
*!*				order by mater.naim ;	
*!*				into curs cc30
		
		local hh,rr
		hh = sqlconnect('sqldb','sa','111')
		if hh > 0
			rr = sqlexec(hh,'select distinct mater.kodm, mater.naim as maternaim, '+;
							'mater.kod, mater.ei, '+;
							'kt.mar1, kt.d_u from mater, kt where kt.shw=?lcshw and '+;
							'kt.kodm=mater.kodm and kt.kodm<>0 order by maternaim','cc30')
			if rr = -1
				eodbc('form_shwzimi_new sele')
			endif		
			sqldisconnect(hh)
		else
			eodbc('form_shwzimi_new conn')
		endif		
		release hh,rr
		
		scan all
			*** выборка норм
			do case
				case	cc30.d_u = 1 .or. cc30.d_u = 5	
*!*						select sum(koli * nrmd) as snrmd, sum(koli) as skoli;
*!*							from kt;
*!*							where;
*!*							kt.kodm = cc30.kodm;
*!*							and kt.shw = m.lcShw;
*!*							and mar1 = cc30.mar1;
*!*							into curs cc40
					local hh,rr
					hh = sqlconnect('sqldb','sa','111')
					if hh > 0
						rr = sqlexec(hh,'select sum(koli * nrmd) as snrmd, '+;
										'sum(koli) as skoli from kt where kt.kodm=?cc30.kodm and '+;
										'kt.shw=?lcshw and mar1=?cc30.mar1','cc40')
						if rr = -1
							eodbc('form_shwzimi_new sele5')	
						endif									
						sqldisconnect(hh)
					else
						eodbc('form_shwzimi_new conn5')
					endif					
					release hh,rr	
				
				case	cc30.d_u = 4
*!*	*!*						select sum(kol1 * koli / kol) as snrmd, sum(koli) as skoli;
*!*	*!*							from kt;
*!*	*!*							where;
*!*	*!*							kt.kodm = cc30.kodm;
*!*	*!*							and kt.shw = m.lcShw;
*!*	*!*							and mar1 = cc30.mar1;
*!*	*!*							into curs cc40
					local hh,rr
					hh = sqlconnect('sqldb','sa','111')
					if hh > 0
						rr = sqlexec(hh,'select sum(kol1 * koli / kol) as snrmd,'+;
										'sum(koli) as skoli from kt where kt.kodm=?cc30.kodm and '+;
										'kt.shw=?lcshw and mar1=?cc30.mar1','cc40')
						if rr = -1
							eodbc('form_shwzimi_new sele6')
						endif										
						sqldisconnect(hh)
					else
						eodbc('form_shwzimi_conn6')
					endif
					
					release hh,rr	
						
			endcase
			*** newid
		    select * from shwzimi order by id into cursor cc44
		    if reccount()>0
		        go bottom
		        newid = cc44.id+1
		    else
		        newid = 1
		    endif
		    use in cc44	
			*** write into shwzimi
			insert into shwzimi;
				(id,kodm,kolizd,kol1,shwz,mar1,du,koli);
				values;
				(newid,cc30.kodm,lnKol1,cc40.snrmd,ci.shwz,cc30.mar1,get_du_by_kod_kodm(ci.izd,cc30.kodm),cc40.skoli)
			*** close cc40
			use in cc40
		endscan 	
		use in cc30		
	endscan 
else
	wait window nowait '¬ имитационной базе нет плана с номером '+str(mnom) 	
endif
use in ci

wait window nowait 'Ёталонна€ база (имитационна€) сформирована!' 

return
***************************************************
* нова€ верси€ формировател€ эталонной базы по 
* шифру запуска
lparameters parShwz

local ans

* проверить есть ли еще шифр запуска
select * from shwzras where alltrim(shwz) == alltrim(parShwz) ;
    and !empty(shwz) ;
    into cursor cc10
if reccount()>0
    ans = messagebox('¬ базе потребностей материалов такой код уже есть! «аменить его?',4+32)
    if ans <> 6
        wait window nowait 'Ѕаза потребности в материалах не было сформирована!'
        return
    else
        wait window nowait '”дал€ютс€ существующие записи'
        delete from shwzras where alltrim(shwz)	== alltrim(parShwz)
    endif
endif
use in cc10

* получаем код издели€
local lcShw
lcShw = get_izd_kod_by_shwz(parShwz)

*  определ€ем сколько изделий в запуске 	
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
    wait window nowait '“акого издели€ нет'
endif
use in cc50

* выбираем по материалам
select ;
	dist mater.kodm, mater.naim, mater.kod, mater.ei, kt.mar1, kt.d_u;		
	from mater,kt;
	where;
		kt.shw = m.lcShw ;
		and kt.kodm = mater.kodm;
		and kt.kodm <> 0;
	order by mater.naim ;	
	into curs cc30
scan all
	*** progress
	wait window nowait '¬ыполнено '+str(100*recno()/reccount(),3)+'%' 
	*** выборка норм
	do case
		case	cc30.d_u = 1 .or. cc30.d_u = 5	
			select sum(koli * nrmd) as snrmd, sum(koli) as skoli;
				from kt;
				where;
				kt.kodm = cc30.kodm;
				and kt.shw = m.lcShw;
				and mar1 = cc30.mar1;
				into curs cc40
		case	cc30.d_u = 4
			select sum(kol1 * koli / kol) as snrmd, sum(koli) as skoli;
				from kt;
				where;
				kt.kodm = cc30.kodm;
				and kt.shw = m.lcShw;
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
		(id,kodm,kolizd,kol1,shwz,mar1,du,koli);
		values;
		(newid,cc30.kodm,lnKol1,cc40.snrmd,parShwz,cc30.mar1,get_du_by_shwz_kodm(parShwz,cc30.kodm),cc40.skoli)
	*** close cc40
	use in cc40
endscan 	
use in cc30	

wait window nowait 'ƒобавление в эталонную базу завершено' 
	
		