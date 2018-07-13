local art

select * from win\base2 ;
	where !empty(art);
	into cursor c100
scan all
	art = val(c100.art)
	if art <> 0
		update mater set naim = c100.matname where kodm = art
		wait window 'Установлено имя '+c100.matname+' kod '+str(art) 	
	endif	
endscan	
use in c100	