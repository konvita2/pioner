Lparameters parmod,parpoznd,parnto,parmar

Local hh,rr

* create
Create Cursor ccte (ntp N(2), us N(3), nus c(40), us2 N(3), nus2 c(40), ld N(6), ;
	ds N(5), sh N(7,3), kob N(3),  shag N(6,2), krno N(2), normw N(12,6))
If parmod='edi'
	* fill cursor
	hh = SQLConnect('sqldb','sa','111')
	If hh = 0
		eodbc('tokar_prg conn')
	Endif

	*select * from te where alltrim(poznd) == alltrim(poznd_) and nto = parnto order by ntp into cursor cc100
	rr = SQLExec(hh,'select * from te where rtrim(poznd) = rtrim(?m.parpoznd) and nto = ?m.parnto order by ntp','cc100')
	If rr = -1
		eodbc('tokar_prg_te sele')
	Endif

	Scan All
		Local ntp,kko,kkos

		m.ntp 	= cc100.ntp
		m.us 	= cc100.us1
		m.us2 	= cc100.us2
*!*	wait window 'us='+str(m.us)+' us2='+str(m.us2)
		Local hhh,rrsql
		hhh = SQLConnect('sqldb','sa','111')
		If hhh>0
			rrsql = SQLExec(hhh,"select im from KTU where left(ttp,11)='06024.55201' AND KOF=19 and npp=?m.us",'c_ktu_prg')
			If rrsql = -1
				eodbc('get_instr sele')
			Endif
			Select c_ktu_prg
			If Reccount()>0
				m.nus = c_ktu_prg.im
			Else
				m.nus = ''
			Endif
			Use In c_ktu_prg
			
			rrsql = SQLExec(hhh,"select im from KTU where left(ttp,11)='06024.55201' and kof=20 and npp=?m.us2",'c_ktu_prg')
			If rrsql = -1
				eodbc('get_instr sele')
			Endif
			Select c_ktu_prg
			If Reccount()>0
				m.nus2 = c_ktu_prg.im
			Else
				m.nus2 = ''
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('get_instr conn')
		endif
*!*			wait window str(m.us)+'   '+m.nus
		m.ld	= cc100.ld
		m.ds	= cc100.ds
		m.sh 	= cc100.sh
		m.kob 	= cc100.kob
		m.shag 	= cc100.shag
		m.krno 	= cc100.krno

		m.normw	= cc100.normw
		Insert Into ccte From Memvar
	Endscan
	Use In cc100
Endif
Do Form f_slesar_proch_new With parmod,parpoznd,parnto,parmar
