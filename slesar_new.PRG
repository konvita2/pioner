Lparameters parmod,parpoznd,parnto,parmar

Local hhh,rrsql

* create
Create Cursor ccte (ntp N(2), us N(3), nus c(40), us2 N(3), nus2 c(40), d N(6,2), tocd1 c(7), tocd11 c(7), glub N(4,1), ld N(4),;
	ds N(5), sh N(7,3), ip N(2), shag N(6,2), kob N(3) , rr1 N(6,1), toch1 c(7), toch11 c(7), rr2 N(6,1),;
	toch2 c(7), toch21 c(7), normw N(12,6))

* fill cursor
If parmod='edi'
	hhh = SQLConnect('sqldb','sa','111')
	If hhh>0
		rrsql = SQLExec(hhh,'select * from te where rtrim(poznd) = rtrim(?m.parpoznd) and nto = ?m.parnto order by ntp','cc100')
		If rrsql = -1
			eodbc('tokar_prg_te sele')
		Endif

		Scan All
			Local koko,kokos
			m.ntp 	= cc100.ntp
			m.us 	= cc100.us1
			*!*		m.nus	= get_nuss(m.us)

			If cc100.kto = 101
				koko = 13
				kokos = 17
				rrsql = SQLExec(hhh,"select im from KTU where left(ttp,11)='06024.55201' and (kof=13 or kof=21) and npp=?m.us",'c_ktu_prg')
				*!*				brow
				If rrsql = -1
					eodbc('get_instr sele')
				Endif
			Endif
			If cc100.kto = 108
				koko = 14
				kokos = 18
				rrsql = SQLExec(hhh,"select im from KTU where left(ttp,11)='06024.55201' and (kof=14 or kof=21) and npp=?m.us",'c_ktu_prg')
				*!*				brow
				If rrsql = -1
					eodbc('get_instr sele')
				Endif
			Endif
			If cc100.kto = 109
				koko = 12
				kokos = 16
				rrsql = SQLExec(hhh,"select im from KTU where left(ttp,11)='06024.55201' and kof=12 and npp=?m.us",'c_ktu_prg')
				*!*				brow
				If rrsql = -1
					eodbc('get_instr sele')
				Endif
			Endif
			If cc100.kto = 2156
				koko = 11
				kokos = 15
				rrsql = SQLExec(hhh,"select im from KTU where left(ttp,11)='06024.55201' and (kof=11 or kof=21) and npp=?m.us",'c_ktu_prg')
				*!*				brow
				If rrsql = -1
					eodbc('get_instr sele')
				Endif
			Endif

			m.us2 	= cc100.us2
			*wait window 'kto='+str(cc100.kto)+' left(ttp,11)=06024.55201 kof='+str(koko)+' npp='+str(m.us)

			
			Select c_ktu_prg
			If Reccount()>0
				m.nus = c_ktu_prg.im
			Else
				m.nus = ''
			Endif
			Use In c_ktu_prg
			rrsql = SQLExec(hhh,"select im from KTU where left(ttp,11)='06024.55201' and npp=?m.us2",'c_ktu_prg')
			If rrsql = -1
				eodbc('get_instr sele')
			Endif
			Select c_ktu_prg
			If Reccount()>0
				m.nus2 = c_ktu_prg.im
			Else
				m.nus2 = ''
			Endif
			Use In c_ktu_prg


			m.d		= cc100.d
			m.tocd1 = cc100.tocd1
			m.tocd11= cc100.tocd11

			m.glub 	= cc100.glub
			m.ld	= cc100.ld
			m.ds	= cc100.ds
			m.sh 	= cc100.sh
			m.ip 	= cc100.ip
			m.shag 	= cc100.shag
			m.kob 	= cc100.kob

			m.rr1 	= cc100.rr1
			m.toch1 = cc100.toch1
			m.toch11= cc100.toch11

			m.rr2	= cc100.rr2
			m.toch2 = cc100.toch2
			m.toch21= cc100.toch21

			m.normw	= cc100.normw
			Insert Into ccte From Memvar
		Endscan
		Use In cc100
		SQLDisconnect(hhh)
	Else
		eodbc('get_instr conn')
	Endif
Endif
Do Form f_slesar_new With parmod,parpoznd,parnto,parmar
