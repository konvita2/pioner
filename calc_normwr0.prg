* ===============================
* выполн€ет переасчет норм по списанию в базе kt
local ans,vno,vto

ans = messagebox('¬ыполнить перерасчет норм расхода по списанию?',4+32)

if ans = 6
	* получить самую большую дату порезки
	dimension d[1]
	select max(dat_o) as maxdat from ostatki into array d
	maxdat = d[1]

	* собираем нетехнологические отходы
	create cursor c_nto (kodm n(8), sumnto n(15,5))
	*
	select * from ostatki ;
		where pri=2 and dat_o = maxdat;
		into cursor c500
	scan all
		vno = get_ves_by_kodm_ra_rb(c500.kod,c500.ra,c500.rb) 
		insert into c_nto (kodm,sumnto) values (c500.kod,vno)		
	endscan	
	use in c500	
	
	*select c_nto
	*brow
	*
	select kodm,sum(sumnto) as sumnto from c_nto group by kodm into cursor c_ntosum
	*select c_ntosum
	*brow
	
	* собираем технологические отходы
	create cursor c_to (kodm n(8), sumto n(15,5))
	*
	select * from ostatki ;
		where pri=0 and dat_o = maxdat;
		into cursor c500
	scan all
		vto = get_ves_by_kodm_ra_rb(c500.kod,c500.ra,c500.rb) 
		*insert into c_to (kodm,sumto) values (c500.kod,vto)		
		insert into c_to (kodm,sumto) values (c500.kod,0)		
	endscan	
	use in c500	
	*select c_to
	*brow
	*
	select kodm,sum(sumto) as sumto from c_to group by kodm into cursor c_tosum
	*select c_tosum
	*brow
	
	*получаем суммы всех заготовок по соответствующему коду материала
	select kod,sum(koli*get_ves_by_kodm_ra_rb(kod,rozma,rozmb)) as ssum ;
		from raschet ;
		group by kod;
		into cursor c_vz

	wait window nowait 'ѕеребираем заготовки...' 
	select * from raschet order by kod into cursor c_ras
	scan all
		local nr,vz,vno,vto,svz
		
		wait window nowait 'ѕеребираем заготовки '+str(recno()/reccount()*100,5)+'%' 
		
		vz = get_ves_by_kodm_ra_rb(c_ras.kod,c_ras.rozma,c_ras.rozmb)
		
		select * from c_ntosum where kodm = c_ras.kod into cursor ccc
		vno = ccc.sumnto
		use in ccc
	
		select * from c_tosum where kodm = c_ras.kod into cursor ccc
		vto = ccc.sumto
		use in ccc
		
		select * from c_vz where kod = c_ras.kod into cursor ccc
		svz = ccc.ssum
		use in ccc 
		
		nr = vz + vz*(vno+vto)/svz
		
		update kt set ;
			normwr0 = nr;
			where kornd = c_ras.kornd and shw = get_izd_kod_by_shwz(c_ras.shwz)

	endscan
	use in c_ras		
			 
 	use in c_vz		
	use in c_to
	use in c_tosum		
	use in c_ntosum
	use in c_nto
	wait window nowait '√отово' 	
endif

return