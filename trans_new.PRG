Lparameters parmod,parkodkt,parpoznd,parnto,parmar

Local hh,rr

* create
Create Cursor ccte (ntp N(2), us N(3), nus c(40), wag n(12,5), ld n(6), krno n(1), kob n(4), normw N(12,6))
If parmod='edi'
	* fill cursor
	hh = SQLConnect('sqldb','sa','111')
	If hh = 0
		eodbc('kontra_prg conn')
	Endif

	*select * from te where alltrim(poznd) == alltrim(poznd_) and nto = parnto order by ntp into cursor cc100
	rr = SQLExec(hh,'select * from te where rtrim(poznd) = rtrim(?m.parpoznd) and nto = ?m.parnto order by ntp','cc100')
	If rr = -1
		eodbc('kontra_prg_te sele')
	Endif

	Scan All
		Local ntp,kko,kkos

		m.ntp 	= cc100.ntp
		m.us 	= cc100.us1
*!*			m.nus	= get_nus(m.us)

		Local hhh,rrsql
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrsql = SQLExec(hhh,"select im from KTU where LEFT(ttp,11)='06024.55001' and npp=?m.us",'C_TTP_im')
			If rrsql = -1
				eodbc('kontran m_get_us1 KTU Select')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('kontra m_get_us1 conn')
		Endif
		m.nus = c_ttp_im.im
		Use In c_ttp_im

		m.wag	= cc100.wag
		m.ld 	= cc100.ld
		m.krno 	= cc100.krno
		m.kob 	= cc100.kob
		m.normw	= cc100.normw
		Insert Into ccte From Memvar
	Endscan
	Use In cc100
	Select ccte
Endif
*!*	do form f_kontra_grid with parmod,poznd_,parnto,parmar
Do Form f_trans_new With parmod,parkodkt,parpoznd,parnto,parmar
