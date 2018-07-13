Lparameters parmod,poznd_,parnto,parmar,parbi
Local hh,rr
*!*	wait window 'freza_new.prg'
* create
Create Cursor ccte (ntp N(10), poznd c(30), nto n(3), kko N(10), kkos c(100), ri N(10), ris c(40),;
	toch N(5), ds N(9,1), rr1 N(6,1), tocd1 c(7), tocd11 c(7), rr2 N(6,1), toch2 c(7), toch21 c(7), glub N(4,1),;
	ip N(2), ug N(3), rad N(5,1), sh N(7,3), us N(4,1), kob N(3), normw N(12,6))

Create Cursor IZ_TE (kod N(10), poznd c(30), nto n(3), metka N(1), rozma N(12,6), rozmb N(12,6), ntp N(10), kko N(10), kkos c(100), ri N(10), ris c(40),;
	ds N(9,1), d N(6,2), dbk N(6,2), tocd1 c(7), tocd11 c(7), glub N(4,1),;
	ip N(2), shag N(6,2), ug N(3), rad N(5,1), sh N(7,3), us N(4,1), kob N(3), normw N(12,6),;
	toch1 c(7), toch11 c(7))
* fill cursor
If parbi<>1
	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*	select * from te where alltrim(poznd) == alltrim(poznd_) and nto = parnto order by ntp into cursor cc100
		rr = SQLExec(hhh,'select * from te where rtrim(poznd) = rtrim(?m.poznd_) and nto = ?m.parnto order by ntp','cc100')
		If rr = -1
			eodbc('FREZA_prg_te sele')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('FREZA_prg conn')
	Endif

	Scan All
		Local kod,ntp,kko,kkos

		m.ntp = cc100.ntp
		m.kko = cc100.kko
		m.kkos = get_kko2(m.kko,3)
		m.ri = cc100.kodi
		m.ris = get_izu(3,m.kko,m.ri)
		m.toch = cc100.toch
		m.ds = cc100.ds
		m.rr1 = cc100.rr1
		m.tocd1 = cc100.tocd1
		m.tocd11 = cc100.tocd11
		m.rr2 = cc100.rr2
		m.toch2 = cc100.toch2
		m.toch21 = cc100.toch21
		m.glub = cc100.glub
		m.ip = cc100.ip
		m.ug = cc100.ug
		m.rad = cc100.rad
		m.sh = cc100.sh
		m.us = cc100.us
		m.kob = cc100.kob
		m.normw = cc100.normw

		Insert Into ccte From Memvar
	Endscan
	Use In cc100
Else
	Do Form f_bi_NEW WITH 3,parmar
	SELECT * FROM ccte  INTO CURSOR cparam
*!*		poznd_=cparam.poznd
	parnto=cparam.nto
	USE IN cparam
Endif
Do Form f_freza_new With parmod,poznd_,parnto,parmar,parbi

Use In ccte
