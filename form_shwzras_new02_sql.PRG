* новая версия формирователя эталонной базы по
* шифру запуска (для второго маршрута)
lparameters parShwz

local ans
local hh,rr

hh = sqlconnect('sqldb','sa','111')
if hh > 0

	* проверить есть ли еще шифр запуска
	*!*	select * from shwzras02 where alltrim(shwz) == alltrim(parShwz) ;
	*!*	    and !empty(shwz) ;
	*!*	    into cursor cc10
	rr = sqlexec(hh,'select * from shwzras02 where rtrim(shwz)=rtrim(?parshwz)'+;
					"and rtrim(shwz)<>'' ",'cc10')
	if rr = -1
		eodbc("form_shwzras_new02_sql sele1")
	endif				
	if reccount()>0
		wait window nowait 'Удаляются существующие записи'
		* delete from shwzras02 where alltrim(shwz)	== alltrim(parShwz)
		rr = sqlexec(hh,'delete from shwzras02 where rtrim(shwz)=rtrim(?parshwz)')
		if rr = -1
			eodbc('form_shwzras_new02_sql dele2')
		endif
	endif
	use in cc10

	* получаем код изделия
	local lcShw
	lcShw = get_izd_kod_by_shwz(parShwz)

	*  определяем сколько изделий в запуске
	*  kol1
	local lnKol1
*!*		select * from izd ;
*!*			where ;
*!*			!empty(shwz) and ;
*!*			alltrim(shwz) == alltrim(parShwz);
*!*			into cursor cc50
*!*		if reccount()>0
*!*			lnKol1 = cc50.partz2 - cc50.partz1 + 1
*!*		else
*!*			lnKol1 = 0
*!*			wait window nowait 'Такого изделия нет'
*!*		endif
*!*		use in cc50

	lnKol1 = get_izd_kolzap_by_shwz(parshwz)
	
	* выбираем по материалам
*!*		select ;
*!*			dist mater.kodm, mater.naim, mater.kod, mater.ei, kt.mar1, kt.mar2, kt.d_u;
*!*			from mater,kt;
*!*			where;
*!*			kt.shw = m.lcShw ;
*!*			and kt.kodm = mater.kodm;
*!*			and kt.kodm <> 0;
*!*			order by mater.naim ;
*!*			into curs cc30
	rr = sqlexec(hh,'select distinct mater.kodm, mater.naim, mater.kod, mater.ei, '+;
					'kt.mar1,kt.mar2,kt.d_u from mater, kt where kt.shw = ?lcshw '+;
					'and kt.kodm=mater.kodm and kt.kodm<>0 order by mater.naim','cc30')					
	if rr = -1
		eodbc('form_shwzras_new02_sql sele3')
	endif
	scan all
		*** progress
		*wait window nowait 'Выполнено '+str(100*recno()/reccount(),3)+'%'
		waitproc(recno(),reccount(),'Формирование эталонной базы 2-го уровня')
		*** выборка норм
		do case
			case	cc30.d_u = 1 .or. cc30.d_u = 5
*!*					select sum(koli * nrmd) as snrmd, sum(koli) as skoli;
*!*						from kt;
*!*						where;
*!*						kt.kodm = cc30.kodm;
*!*						and kt.shw = m.lcShw;
*!*						and mar1 = cc30.mar1 and mar2 = cc30.mar2;
*!*						into curs cc40
				rr = sqlexec(hh,'select sum(koli * nrmd) as snrmd, sum(koli) as skoli from kt '+;
								'where kt.kodm=?cc30.kodm and kt.shw=?lcshw and mar1=?cc30.mar1 and '+;
								'mar2=?cc30.mar2','cc40')
				if rr = -1
					eodbc('form_shwzras_new02_sql sele4')
				endif	
			case	cc30.d_u = 4
*!*					select sum(kol1 * koli / kol) as snrmd, sum(koli) as skoli;
*!*						from kt;
*!*						where;
*!*						kt.kodm = cc30.kodm;
*!*						and kt.shw = m.lcShw;
*!*						and mar1 = cc30.mar1 and mar2 = cc30.mar2;
*!*						into curs cc40

				rr = sqlexec(hh,'select sum(kol1 * koli / kol) as snrmd, sum(koli) as skoli from kt '+;
								'where kt.kodm = ?cc30.kodm and kt.shw=?lcshw and mar1=?cc30.mar1 and '+;
								'mar2=?cc30.mar2','cc40')
				if rr=-1
					eodbc('form_shwzras_new02_sql sele5')
				endif				
				
		endcase
*!*			*** newid
*!*			select * from shwzras02 order by id into cursor cc44
*!*			if reccount()>0
*!*				go bottom
*!*				newid = cc44.id+1
*!*			else
*!*				newid = 1
*!*			endif
*!*			use in cc44
		
		local ppdu
		ppdu = get_du_by_shwz_kodm(parShwz,cc30.kodm)
		rr = sqlexec(hh,'insert into shwzras02 (kodm,kolizd,kol1,shwz,mar1,mar2,du,koli) values '+;
						'(?cc30.kodm,?lnkol1,?cc40.snrmd,?parshwz,?cc30.mar1,?cc30.mar2,?ppdu,?cc40.skoli)')
		if rr = -1
			eodbc('form_shwzras_new02_sql sele6')
		endif				
		
*!*			*** write into shwzras02
*!*			insert into shwzras02;
*!*				(id,kodm,kolizd,kol1,shwz,mar1,mar2,du,koli);
*!*				values;
*!*				(newid,cc30.kodm,lnKol1,cc40.snrmd,parShwz,cc30.mar1,cc30.mar2,
*!*				,cc40.skoli)
*!*			*** close cc40
		use in cc40
	endscan
	use in cc30

	sqldisconnect(hh)

	wait window nowait 'Добавление в эталонную базу 02 завершено'

else
	eodbc('form_shwzras_new02_sql conn')
endif