Lparameters parmod,KODKT_,poznd_,parkto,parmar
If Inlist(parmar,1139,7039,9139,9239)

	*!*	WAIT WINDOW 'parmod='+parmod+' poznd='+poznd_+'  parnto='+STR(parnto)='  parmar='+STR(parmar)
	* create
	Create Cursor ccte (kod N(10),ntp N(10), katet N(4,1), dlina N(6), tipsh c(10), ;
		us1 N(4), us2 N(4), us3 N(4), us4 N(4), us5 N(4), rr N(1), kto N(5), kodo c(12), ;
		kodp N(4), tpz N(12,6), mar N(4), normw N(12,6), us1s c(50), us2s c(50), us3s c(50), us4s c(50), us5s c(50))
	Do Case

		Case parmod = 'edi'
			* fill cursor
			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
				rrsql = SQLExec(hhh,'select distinct  tocd1,ka  from te  where rtrim(poznd) = rtrim(?poznd_) And kto = ?parkto','cCC100')
				If rrsql = -1
					eodbc('SWARKA edi Select TE')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('SWARKA edi TE conn')
			Endif

			*!*			brow
			Scan All

				hhh = SQLConnect('sqldb','sa','111')
				If hhh > 0
					rrsql = SQLExec(hhh,'select * from te  where rtrim(poznd) = rtrim(?poznd_) And kto = ?parkto and tocd1=?ccc100.tocd1 and ka=?ccc100.ka','CC100')
					If rrsql = -1
						eodbc('SWARKA edi Select TE')
					Endif
					SQLDisconnect(hhh)
				Else
					eodbc('SWARKA edi TE conn')
				Endif


				Local kod,ntp,kko,kkos

				m.kod 	= cc100.kod
				m.ntp 	= cc100.ntp
				m.katet = cc100.ka
				m.dlina = cc100.rasz
				m.tipsh	= cc100.tocd1
				m.us1	= cc100.us1
				m.us1s	= get_us(m.us1)
				m.us2	= cc100.us2
				m.us2s	= get_us(m.us2)
				m.us3	= cc100.us3
				m.us3s	= get_us(m.us3)
				m.us4	= cc100.us4
				m.us4s	= get_us(m.us4)
				m.us5	= cc100.us5
				m.us5s	= get_us(m.us5)
				m.rr	= cc100.rr
				m.kto	= cc100.kto
				m.kodo	= cc100.kodo
				m.kodp	= cc100.kodp
				m.tpz	= cc100.tpz
				m.mar	= cc100.mar
				m.normw = cc100.normw

				Insert Into ccte From Memvar
			Endscan
			Use In cc100
			Use In ccc100
	Endcase
	Do Form f_swarka_new With parmod,KODKT_,poznd_,parkto,parmar
Else
	=Messagebox("Ïנמגונüועו סממעגועסעגטו ÒÅÕÍÎËÎÃÈÈ גארולף חאןנמסף ÐÀÑ×ÅÒ ÍÅÂÎÇÌÎÆÅÍ",0+48)
Endif
