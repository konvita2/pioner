lparameters parmod,parpoznd,parnto,parmar

local hh,rr

* create
create cursor ccte (ntp n(2), kko N(4), nkko c(50), kob n(3), d n(6,2), dbk n(6,2), tocd1 c(7), tocd11 c(7), ;
				ds n(5), toch1 c(7), toch11 c(7), sh n(7,3), gr n(1), ngr n(4,1),  normw n(12,6))

* fill cursor
hh = sqlconnect('sqldb','sa','111')
if hh = 0
	eodbc('tokar_prg conn')
endif

*select * from te where alltrim(poznd) == alltrim(poznd_) and nto = parnto order by ntp into cursor cc100
rr = sqlexec(hh,'select * from te where rtrim(poznd) = rtrim(?m.parpoznd) and nto = ?m.parnto order by ntp','cc100')
if rr = -1
	eodbc('tokar_prg_te sele')
endif

scan all

	m.ntp 	= cc100.ntp
	m.kko	= cc100.kko
	m.nkko	= get_kko(m.kko,24)

	m.kob 	= cc100.kob	
	
	m.d		= cc100.d
	m.dbk	= cc100.dbk
	m.tocd1 = cc100.tocd1
	m.tocd11= cc100.tocd11
	
	m.ds	= cc100.ds
	m.toch1 = cc100.toch1
	m.toch11= cc100.toch11
	
	m.sh 	= cc100.sh
	m.gr 	= cc100.gr	
	IF m.gr=1
		m.ngr = 12.5
	ENDIF
	IF m.gr=2
		m.ngr = 16
	endif
	IF m.gr=3
		m.ngr = 25
	endif
	m.normw	= cc100.normw
	insert into ccte from memvar 
endscan 
use in cc100

do form f_w_s_new with parmod,parpoznd,parnto,parmar

use in ccte