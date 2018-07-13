* сброс изделий в 555

* select kod,im,ribf,shwz from izd into cursor c_izd

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select kod,im,ribf,shwz from izd','c_izd')
	if rr = -1
		eodbc('sbros_izdel sele')
	endif
	sqldisconnect(hh)
else
	eodbc('sbros_izdel conn')
endif
release hh,rr

scan all
	insert into 555 ;
		(kodm, naim, ei,oboz,shwz) ;
		values ;
		(c_izd.kod,c_izd.im, 'izdel', c_izd.ribf, c_izd.shwz)
endscan

use in c_izd

