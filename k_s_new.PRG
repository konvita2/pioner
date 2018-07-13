Lparameters parmod,poznd_,parnto,parmar

Local hh,rr

* create
Create Cursor ccte (ntp N(2), kko N(4), nkko c(50), kob N(3), d N(6,2), dbk N(6,2), tocd1 c(7), tocd11 c(7), ds N(5), ;
	toch3 c(7), toch31 c(7), sh N(7,3), normw N(12,6))

If parmod='edi'
	* fill cursor
	hh = SQLConnect('sqldb','sa','111')
	If hh = 0
		eodbc('tokar_prg conn')
	Endif

	*select * from te where alltrim(poznd) == alltrim(poznd_) and nto = parnto order by ntp into cursor cc100
	rr = SQLExec(hh,'select * from te where rtrim(poznd) = rtrim(?m.poznd_) and nto = ?m.parnto order by ntp','cc100')
	If rr = -1
		eodbc('tokar_prg_te sele')
	Endif

	Scan All
		Local ntp,kko,kkos

		m.ntp 	= cc100.ntp
		m.kko 	= cc100.kko
		m.nkko	= get_kko(m.kko,4)
		m.kob 	= cc100.kob
		m.ip 	= cc100.ip

		m.d		= cc100.d
		m.dbk	= cc100.dbk
		m.tocd1 = cc100.tocd1
		m.tocd11= cc100.tocd11

		m.ds	= cc100.ds
		m.toch = cc100.toch
		m.toch1 = cc100.toch1
		m.toch11= cc100.toch11
		m.sh 	= cc100.sh
		m.glub 	= cc100.glub
		m.shag 	= cc100.shag
		m.normw	= cc100.normw
		Insert Into ccte From Memvar
	Endscan
	Use In cc100
Endif
*!*	do form f_kontra_grid with parmod,poznd_,parnto,parmar
Do Form f_k_s_new With parmod,poznd_,parnto,parmar
