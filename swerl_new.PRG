Lparameters parmod,poznd_,parnto,parmar,parbi
*!*	wait window 'program swerl_new '+parmod+'  '+poznd_+'  '+str(parnto)+'  '+str(parmar)
Local hhh,rr

* create
Create Cursor ccte (ntp N(10), poznd c(30), nto n(3), kko N(10), kkos c(100), ri N(10), ris c(40),;
	d N(6,2), toch1 c(7), toch11 c(7), ip N(3), ds N(5,1), shag N(6,2), glub N(4,1), sh N(7,3), normw N(12,6))

Create Cursor IZ_TE (kod N(10), poznd c(30), nto n(3), metka N(1), rozma N(12,6), rozmb N(12,6), ntp N(10), kko N(10), kkos c(100), ri N(10), ris c(40),;
	ds N(9,1), d N(6,2), dbk N(6,2), tocd1 c(7), tocd11 c(7), glub N(4,1),;
	ip N(3), shag N(6,2), ug N(3), rad N(5,1), sh N(7,3), us N(4,1), kob N(3), normw N(12,6),;
	toch1 c(7), toch11 c(7))
* fill cursor
*!*	select * from te where alltrim(poznd) == alltrim(poznd_) and nto = parnto order by ntp into cursor cc100
If parbi<>1
	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		rr = SQLExec(hhh,'select * from TE where rtrim(poznd)=rtrim(?m.poznd_) and nto=?parnto order by ntp','cc100')
		If rr = -1
			eodbc('swerl_prg_te sele')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('FREZA_prg conn')
	Endif
	Scan All
		Local kod,ntp,kko,kkos

		m.ntp = cc100.ntp
		m.kko = cc100.kko
		m.kkos = get_kko(m.kko,9)
		m.ri = cc100.kodi
		m.ris = get_izu(9,m.kko,m.ri)
		m.d = cc100.d
		m.toch1 = cc100.toch1
		m.toch11 = cc100.toch11
		m.ip = cc100.ip
		m.ds = cc100.ds
		m.shag = cc100.shag
		m.glub = cc100.glub
		m.sh = cc100.sh
		m.normw = cc100.normw

		Insert Into ccte From Memvar
	Endscan
	Use In cc100
Else
*!*		WAIT WINDOW 'swerl_new Do Form f_bi WITH 9,parmar'
	Do Form f_bi_NEW WITH 9,parmar
	SELECT * FROM ccte  INTO CURSOR cparam

	parnto=cparam.nto
	USE IN cparam
Endif
Do Form f_swerl_new With parmod,poznd_,parnto,parmar,parbi

Use In ccte









