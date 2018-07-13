lparam parGod,parMes 
local dat1,dat2

* врем
dat1 = bmon(date(parGod,parMes,1))
dat2 = emon(date(parGod,parMes,1))

select * from db!v_zatr_1c where datab >= dat1 and datae <= dat2 ;
	into cursor c_zatr
	* ПЕРВАЯ запись shwz=''
	* 91
	local ssum91
	ssum91=0
	select * from c_zatr where alltrim(scet)='91' and s3kod<>13 and s2kod<>7 into cursor c500
	scan all
		ssum91 = ssum91+c500.do
	endscan
	use in c500 	
	* 92
	local ssum92
	ssum92=0
	select * from c_zatr where alltrim(scet)='92' and s3kod<>13 and s2kod<>7 into cursor c500
	scan all
		ssum92 = ssum92+c500.do
	endscan
	use in c500 	
	* sumzar1
	local smzar1
	smzar1 = 0
	select * from nar where data_b >= dat1 and data_b <= dat2 ;
		and alltrim(shwz) == 'СТРОЙКА' into cursor c500
	scan all
		smzar1=smzar1+c500.kzp*c500.rascenka
	endscan	
	use in c500	
	* grn91
	local g91,g92
	g91=0
	select nar.*,izd.cena from nar,izd where allt(nar.shwz) == allt(izd.shwz) and ;
		data_b >= dat1 and data_b <= dat2 and cena <> 0 and !empty(nar.shwz) ;
		into cursor c500
	scan all
		g91 = g91+c500.kzp*c500.rascenka
	endscan 	
	use in c500	
	g92=ssum92/g91
	g91=ssum91/g91	
	* делаем старыми прежние
	update zatrsum set ;
		old = .t. ;
		where god=parGod and mes=parMes and empty(shwz)		
	* пишем
	insert into zatrsum ;
		(god,mes,sum91,sum92,grn91,grn92,sumzar1,datsbros,datbeg,datend) ;
		values ;
		(parGod,parMes,ssum91,ssum92,g91,g92,smzar1,datetime(),dat1,dat2)	
	wait window nowait 'Внесены общие затраты'	
	
	* по шифрам затрат
	select distinct shwz from nar ;
		where ;
			!empty(shwz) and ;
			data_b >= dat1 and data_b <= dat2  ;
		into cursor c_shwz	
	scan all
		* sumlzk
		local slzk
		slzk=0
		select t.*,h.dat from matras h,matrast t ;
			where t.head_id = h.id ;
				and dat >= dat1 and dat <= dat2 ;
				and !empty(shwz) ;
				and alltrim(shwz)==alltrim(c_shwz.shwz) ;
			into cursor c_lzk	
		scan all
			slzk=slzk+c_lzk.cena*c_lzk.kol
		endscan
		use in c_lzk	
		* sumkt
		local kodizd,skt
		skt=0
		kodizd = get_izd_kod_by_shwz(c_shwz.shwz)
		select * from kt where kodm<>0 and shw=kodizd into cursor c_kt
		scan all
			skt=skt+c_kt.nrmd*c_kt.koli*get_cena_from_ostatok(c_kt.kodm)
		endscan
		use in c_kt
		* sumbuh
		local sbuh
		sbuh=0
		select * from db!v_zatr_1c ;
			where ;
				datab >= dat1 and datae <= dat2 ;
				and alltrim(scet) == '231' ;
				and !empty(s1nam) ;
				and alltrim(s1nam) == alltrim(c_shwz.shwz) ;
			into cursor c200
		scan all 
			sbuh=sbuh+c200.ko
		endscan	
		use in c200		  
		* з/п
		local zar
		zar=0
		select nar.*,izd.cena from nar,izd where allt(nar.shwz) == allt(izd.shwz) and ;
			data_b >= dat1 and data_b <= dat2 and cena <> 0 and alltrim(nar.shwz)==alltrim(c_shwz.shwz) ;
			into cursor c500
		scan all
			zar = zar+c500.kzp*rascenka
		endscan 	
		use in c500	
		* делаем старыми прежние
		update zatrsum set ;
			old = .t. ;
			where god=parGod and mes=parMes and !empty(shwz) ;
				and alltrim(shwz)==alltrim(c_shwz.shwz)		
		* пишем
		insert into zatrsum ;
			(god,mes,shwz,datsbros,sumzar,sumlzk,sumbuh,sumkt,datbeg,datend) ;
			values ;
			(parGod,parMes,c_shwz.shwz,datetime(),zar,slzk,sbuh,skt,dat1,dat2)			
		* 
		wait window nowait 'Внесены данные по '+alltrim(c_shwz.shwz)	
	endscan	
	use in c_shwz		
use in c_zatr	