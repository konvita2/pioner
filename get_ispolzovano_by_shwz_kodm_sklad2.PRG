* получить использованное количество материала 
* (применяется для незавершенки)
lparameters parshwz,parkodm,parsklad2
local res,hh,rr
local mobor

mobor = alltrim(str(parsklad2))
res = 0

hh = sqlconnect('sqldb','sa','111')
if hh>0

	* перебираем склады
	rr = sqlexec(hh,'select * from dosp where kod<>0 and vid=60 '+;
					'and rtrim(obor)=rtrim(?mobor)','cds')
	if rr <> -1
		select cds
		scan all
			* перебираем наряды
			rr = sqlexec(hh,'select * from nar where rtrim(shwz)=rtrim(?parshwz) and '+;
							'mar=?cds.kod and rascenka>0','cde')
			if rr <> -1
				select cde
				scan all
					* выбор для d_u=1
					rr = sqlexec(hh,'select * from ktshwz where rtrim(shwz)=rtrim(?parshwz) '+;
									'and rtrim(poznd)=rtrim(?cde.poznd) and d_u=1 '+;
									'and kodm=?parkodm','cdr')
					if rr <> -1			
						select cdr
						scan all
							res = res + cdr.nrmd * cde.kzp / iif(cdr.kolz=0,1,cdr.kolz)	
						endscan 
						use in cdr
					else
						eodbc('get_ispolzovano_by_shwz_kodm_sklad2 sele3')	
					endif
					* выбор для d_u=4
					rr = sqlexec(hh,'select * from ktshwz where rtrim(shwz)=rtrim(?parshwz) '+;
									'and rtrim(poznw)=rtrim(?cde.poznd) and d_u=4 and kodm=?parkodm','cdr')
					if rr <> -1
						select cdr
						scan all
							res = res + cdr.kol1 * cdr.koli / iif(cdr.kol=0,1,cdr.kol)						
						endscan 					
						use in cdr
					else
						eodbc('get_ispolzovano_by_shwz_kodm_sklad2 sele4')
					endif				
					* выбор для d_u=5
					rr = sqlexec(hh,'select * from ktshwz where rtrim(shwz)=rtrim(?parshwz) '+;
									'and rtrim(poznd)=rtrim(?cde.poznd) and d_u=5 and kodm=?parkodm','cdr')
					if rr <> -1
						select cdr
						scan all
							res = res + cdr.nrmd * cde.kzp						
						endscan 
						use in cdr
					else
						eodbc('get_ispolzovano_by_shwz_kodm_sklad2 sele5')
					endif									
				endscan 
				use in cde			
			else
				eodbc('get_ispolzovano_by_shwz_kodm_sklad2 sele2')
			endif	
		endscan 
		use in cds
	else
		eodbc('get_ispolzovano_by_shwz_kodm_sklad2 sele1')
	endif				

	sqldisconnect(hh)
else
	eodbc('get_ispolzovano_by_shwz_kodm,sklad2 conn')
endif

return res

