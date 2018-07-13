open database db

select * from tttm into cursor c50
scan all
	update mater set cena = c50.cena where kodm = c50.kodm
endscan 
use in c50

close databases 