* новая версия программы
* в отличие от shwzras здесь происходит формирование сразу
* по нескольким кодам запуска, перечисленным в списке изделий плана имитационной базы
lparameters parNom

local mnom
mnom = parNom

local hh,rr

hh = sqlcn()
if hh > 0

	rr = sqlexec(hh,"select * from imit where rtrim(shwz)<>'' and nom=?mnom",'ci')
	if rr = -1
		eodbc('form_shwzimi_new_sql sele1')
	else
		select ci
		if reccount()>0
			* очистить предыдущую базу
			wait window nowait 'Очистка предыдущих значений'

			*select dist shwz from imit where nom = mnom and !empty(shwz) into cursor cdel
			rr = sqlexec(hh,"select distinct shwz from imit where nom=?mnom and rtrim(shwz)<>''",'cdel')
			if rr = -1
				eodbc('form_shwzimi_new_sql sele2')
			else
				scan all
					*delete from shwzimi where alltrim(shwz) == alltrim(cdel.shwz)

					mmd = cdel.shwz
					rr = sqlexec(hh,'delete from shwzimi where rtrim(shwz)=rtrim(?mmd)')
					if rr = -1
						eodbc('form_shwzimi_new_sql dele')
					endif
				endscan
				use in cdel
			endif

			* заполнить
			select ci
			scan all
				

				* получаем код изделия
				local lcShw
				lcShw = ci.izd

				*  определяем сколько изделий в запуске
				*  kol1
				local lnKol1
				lnKol1 = ci.kol

				rr = sqlexec(hh,'select distinct mater.kodm, mater.naim as maternaim, '+;
						'mater.kod, mater.ei, mater.sklad as matersklad, '+;
						'kt.mar1, kt.d_u from mater, kt where kt.shw=?lcshw and '+;
						'kt.kodm=mater.kodm and kt.kodm<>0 order by maternaim','cc30')
				if rr = -1
					eodbc('form_shwzimi_new sele')
				endif
				
				select cc30
				scan all
				
					wait window nowait 'Заполнение ' + ci.shwz + ' ' +alltrim(str(100*recno()/reccount()))+'%'
				
					*** выборка норм
					do case
						case	cc30.d_u = 1 .or. cc30.d_u = 5
								rr = sqlexec(hh,'select sum(koli * nrmd) as snrmd, '+;
									'sum(koli) as skoli from kt where kt.kodm=?cc30.kodm and '+;
									'kt.shw=?lcshw and mar1=?cc30.mar1','cc40')
								if rr = -1
									eodbc('form_shwzimi_new sele5')
								endif
				
						case	cc30.d_u = 4
								rr = sqlexec(hh,'select sum(kol1 * koli / kol) as snrmd,'+;
									'sum(koli) as skoli from kt where kt.kodm=?cc30.kodm and '+;
									'kt.shw=?lcshw and mar1=?cc30.mar1','cc40')
								if rr = -1
									eodbc('form_shwzimi_new sele6')
								endif

					endcase

					*local hh1,rr

					* mnn = get_du_by_kod_kodm(ci.izd,cc30.kodm)
					mnn = get_du_by_sklad(cc30.matersklad)
					
					mmkodm = cc30.kodm
					mmsnrmd = cc40.snrmd
					mmshwz = ci.shwz
					mmmar1 = cc30.mar1
					mmskoli = cc40.skoli
										
					rr = sqlexec(hh,'insert into shwzimi '+;
						'(kodm,kolizd,kol1,shwz,mar1,du,koli) '+;
						'values '+;
						'(?mmkodm,?lnKol1,?mmsnrmd,?mmshwz,?mmmar1,?mnn,?mmskoli)')
					if rr = -1
						eodbc('form_shwzimi_new_sql inse')
					else

					endif

					*release hh1,rr

					use in cc40

				endscan
				use in cc30
			endscan
		else
			wait window nowait 'В имитационной базе нет плана с номером '+str(mnom)
		endif
		use in ci
	endif

	sqldisconnect(hh)
else
	eodbc('form_shwzimi_new_sql conn')
endif

wait window nowait 'Эталонная база (имитационная) сформирована!'

return
