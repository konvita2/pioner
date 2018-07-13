* сформировать имитационную базу
lparameters parNom
local hh,rr
local sAsk,mshw,skoli,snrmd,skolizd
local newdu

hh = sqlcn()
if hh > 0
	* delete existing
	sAsk = 'УДАЛИТЬ И СФОРМИРОВАТЬ?'
	if messagebox(sAsk,4) = 6
		rr = sqlexec(hh,'delete from shwzimitp where nom=?parNom')
		if rr = -1
			eodbc('form_shwzimit_new dele')
		endif

		* form
		rr = sqlexec(hh,'select * from imittp where nom = ?parNom order by shw','cc_imitt')
		if rr = -1
			eodbc('form_shwzimit_new sele1')
		else
			select cc_imitt
			scan all
			
				waitproc(recno(),reccount(),'Выполнено ')

				mshw = cc_imitt.shw
				skolizd = cc_imitt.kol

				rr = sqlexec(hh,'select * from imitu where nom=?parNom and '+;
					'shw=?cc_imitt.shw order by poznw','cc_imitu')
				if rr = -1
					eodbc('form_shwzimit_new sele2')
				else
					select cc_imitu
					scan all
						rr = sqlexec(hh,'select kt.*,mater.naim as mnaim,'+;
							'mater.sklad as matersklad from kt,mater '+;
							'where kt.kodm = mater.kodm and '+;
							'(kt.d_u=1 or kt.d_u=4 or kt.d_u=5) and '+;
							'rtrim(kornw)<>rtrim(kornd) and shw=?mshw and kt.kodm<>0 and '+;
							'rtrim(poznw)=rtrim(?cc_imitu.poznw) '+;
							'order by poznw','cc_kt')
						if rr = -1
							eodbc('form_shwzimit_new sele3')
						else
							* получить перечень материалов
							select distinct kodm1 as kodm,mnaim,d_u,matersklad from cc_kt ;
								order by kodm1 into cursor cc_kodm

							* deb
							* browse

							* обрабатывать материалы
							select cc_kodm
							scan all

								skoli = 0
								snrmd = 0

								select * from cc_kt where kodm1 = cc_kodm.kodm and d_u=cc_kodm.d_u into cursor cc_mater
								scan all
									do case
										case cc_mater.d_u=1 .or. cc_mater.d_u=5
											skoli = skoli + cc_mater.koli
											snrmd = snrmd + cc_mater.koli * cc_mater.nrmd
										case cc_mater.d_u=4
											skoli = skoli + cc_mater.koli
											snrmd = snrmd + cc_mater.koli
									endcase
								endscan
								use in cc_mater

								* переделаем du так, чтобы он определялся по складу
								* хранения материала
																
								newdu = get_du_by_sklad(cc_kodm.matersklad)

								rr = sqlexec(hh,'insert into shwzimitp '+;
									'(nom,shw,poznw,naimw,kodm,kol1,du,koli,kolizd) '+;
									'values '+;
									'(?parNom,?cc_imitt.shw,?cc_imitu.poznw,?cc_imitu.naimw,?cc_kodm.kodm,'+;
									'?snrmd,?newdu,?skoli,?skolizd)')
								if rr = -1
									eodbc('form_shwzimit_new insert')
								endif
								
								* set recalc date
								mdper = datetime()
								rr = sqlexec(hh,'update imitp set dper=?mdper where nom=?parNom')
								if rr = -1
									eodbc('form_shwzimit_new insert1')
								endif

							endscan
							use in cc_kodm
							use in cc_kt
						endif

					endscan
					use in cc_imitu
				endif
			endscan
			use in cc_imitt
		endif

	endif

	wait window nowait 'ГОТОВО!' 	

	sqldisconnect(hh)
		
else
	eodbc('form_shwzimit_new conn')
endif
