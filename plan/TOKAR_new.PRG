Lparameters parmod,poznd_,parnto,parmar,parbi
Local hh,rr

* create
Create Cursor ccte (ntp N(10), poznd c(30), nto n(3), kko N(10), kkos c(40), ri N(10), ris c(40),;
	ds N(9,1), d N(6,2), dbk N(6,2), tocd1 c(7), tocd11 c(7), glub N(4,1),;
	ip N(2), shag N(6,2), ug N(3), rad N(5,1), sh N(7,3), us N(4,1), kob N(3), normw N(12,6),;
	toch1 c(7), toch11 c(7))

Create Cursor IZ_TE (kod N(10), poznd c(30), nto n(3), metka N(1), rozma N(12,6), rozmb N(12,6), ntp N(10), kko N(10), kkos c(40), ri N(10), ris c(40),;
	ds N(9,1), d N(6,2), dbk N(6,2), tocd1 c(7), tocd11 c(7), glub N(4,1),;
	ip N(2), shag N(6,2), ug N(3), rad N(5,1), sh N(7,3), us N(4,1), kob N(3), normw N(12,6),;
	toch1 c(7), toch11 c(7))
* fill cursor
If parbi<>1
	hh = SQLConnect('sqldb','sa','111')
	If hh = 0
		eodbc('tokar_prg conn')
	Endif


	*select * from te where alltrim(poznd) == alltrim(poznd_) and nto = parnto order by ntp into cursor cc100
	rr = SQLExec(hh,'select * from te where rtrim(poznd) = rtrim(?m.poznd_) and nto = ?m.parnto order by ntp','cc100')
	If rr = -1
		eodbc('tokar_prg_te sele')
	Endif

	Select cc100
	Scan All
		Local ntp,kko,kkos

		m.d 	= cc100.d
		m.dbk 	= cc100.dbk
		m.ds 	= cc100.ds
		m.glub	= cc100.glub
		m.ip 	= cc100.ip
		m.kko 	= cc100.kko
		m.kkos	= get_kko(m.kko,1)
		m.kob 	= cc100.kob
		m.normw = cc100.normw
		m.ntp 	= cc100.ntp
		m.rad 	= cc100.rad
		m.ri 	= cc100.kodi
		m.ris 	= get_instr(m.ri)
		m.sh 	= cc100.sh
		m.shag	= cc100.shag
		m.tocd1 = cc100.tocd1
		m.tocd11= cc100.tocd11
		m.ug 	= cc100.ug
		m.us 	= cc100.us
		m.toch1 = cc100.toch1
		m.toch11 = cc100.toch11

		Insert Into ccte From Memvar
	Endscan
	Use In cc100
Else
*!*		Do Form f_tok_bi WITH parmar
	Do Form f_bi_NEW WITH 1,parmar
*!*		wait wind 'prg posle do f_yok_bi sele ccte brow'
*!*		SELECT ccte
*!*		 brow
	SELECT * FROM ccte  INTO CURSOR cparam
*!*		poznd_=cparam.poznd
	parnto=cparam.nto
	USE IN cparam
Endif


Do Form f_tokar_new With parmod,poznd_,parnto,parmar,parbi

Use In ccte
