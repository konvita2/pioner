Lparameters parmod,parkodkt,parpoznd,parnto,parmar
*parmod='add'
*poznd_='ฤฦ-012.01.00.000 ัม'
*parkodkt=128698
*parnto=1
*parmar=9239
Local hh,rr

* create
Create Cursor ccte (ntp N(2), us N(3), nus c(40), rad N(5,1), ug N(3),;
	kob N(3), sh N(7,3), ip N(2), shag N(6,2), rr1 N(6,1), toch1 c(7), toch11 c(7), rr2 N(6,1),;
	toch2 c(7), toch21 c(7), toch N(5), tocd1 c(7), tocd11 c(7), rr3 N(6,1), toch3 c(7), toch31 c(7), normw N(12,6))
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
		**m.nus	= get_nus(m.us)
		m.nus = m.us

		Local hhh,rrsql
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrsql = SQLExec(hhh,"select im from KTU where LEFT(ttp,11)='06024.55278' and npp=?m.us AND PRI=9",'C_TTP_im')
			If rrsql = -1
				eodbc('kontran m_get_us1 KTU Select')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('kontra m_get_us1 conn')
		Endif
		m.nus = c_ttp_im.im
		Use In c_ttp_im

		m.rad	= cc100.rad
		m.ug 	= cc100.ug
		m.kob 	= cc100.kob
		m.sh 	= cc100.sh
		m.ip 	= cc100.ip
		m.shag 	= cc100.shag
		m.rr1 	= cc100.rr1
		m.toch1 = cc100.toch1
		m.toch11= cc100.toch11
		m.rr2	= cc100.rr2
		m.toch2 = cc100.toch2
		m.toch21= cc100.toch21
		m.toch 	= cc100.toch
		m.tocd1 = cc100.tocd1
		m.tocd11= cc100.tocd11
		m.rr3 	= cc100.rr3
		m.toch3 = cc100.toch3
		m.toch31= cc100.toch31
		m.normw	= cc100.normw
		Insert Into ccte From Memvar
	Endscan
	Use In cc100
	Select ccte
Endif
*!*	do form f_kontra_grid with parmod,poznd_,parnto,parmar
Do Form f_kontra_new With parmod,parkodkt,parpoznd,parnto,parmar
