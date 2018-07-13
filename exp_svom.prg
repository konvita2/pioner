* Експорт сводной ведомости материалов на изделие
local lnID

set safety off 
use svom exclusive 
zap
use

m.lnID = 1
select dist shw,pozn from kt order by pozn into cursor c_izd
scan all
	wait window nowait 'Изделие '+c_izd.pozn
	select dist mm.kodm, mm.naim, mm.ei from mater mm, kt ;
		where mm.kodm = kt.kodm and shw = c_izd.shw and mm.kodm < m.glMater ;
		order by naim ;
		into cursor c_kodm
	scan all
		select ;
			sum(wag*koli) as sumwag, ;
			sum(mz*koli) as summz, ;
			sum(nrmd*koli) as sumnrmd ;
		from ;
			kt ;
		where ;
			kodm = c_kodm.kodm and shw = c_izd.shw ;
		into ;
			cursor c_sum
		if reccount()>0	
			insert into svom ;
				(did,shw,pozn,kodm,naim,ei,nrmd,wag,mz) ;
				values ;
				(m.lnID,c_izd.shw,c_izd.pozn,c_kodm.kodm, ;
				c_kodm.naim,c_kodm.ei,c_sum.sumnrmd,c_sum.sumwag,c_sum.summz)
			m.lnID = m.lnID+1		
		endif
		use in c_sum		
	endscan	
	use in c_kodm
endscan
use in c_izd

wait window nowait 'Сброс СВОМ завершен...'