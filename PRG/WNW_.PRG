Local loexcel
Local mizd

Local mizdkod

#Define FALSE .F.
zad='НЕТ В СПРАВОЧНИКЕ'
Publ Arra m[20],mm[20]
Local iinormw,iirasz,iitpz,iMRASZ,iiinormw,iiirasz,iiitpz,iiMRASZ
Stor 0 To m
Store 0 To iinormw,iirasz,iitpz,iMRASZ,iiinormw,iiirasz,iiitpz,iiMRASZ
Do Form f_izd_vib To cRibf

*!*	select * from izd where ribf = cRibf into cursor c_izd
*!*	m.Naim_izd = c_izd.im
*!*	m.ribf = c_izd.ribf

m.naim_izd = get_izd_im_by_ribf(cRibf)
m.ribf = cRibf
m.mizdkod = get_izd_kod_by_ribf(cRibf)

Wait Window Nowait 'Запускаем Excel'
loexcel = Createobject('Excel.Application')
loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\wnw.xls')
loexcel.displayalerts = .F.

*!*	loexcel.visible = .t.


Local firstpass
*!*	firstpass = .t.
firstpass = 0
Local nnom
nnom = 11

Local hh,rr
hh = SQLConnect('sqldb','sa','111')
If hh > 0
	rr = SQLExec(hh,'select * from ktfull where shw=?m.mizdkod','cddkt')
	If rr = -1
		eodbc('wnw_ sele1')
	Endif
	SQLDisconnect(hh)
Else
	eodbc('wnw_ conn1')
Endif
Release hh,rr
*!*	brow
Select Distinct ;
	d_u,kornw,poznw,naimw,kornd,poznd,naimd, ;
	mar1,mar2,mar3,mar4,mar5,mar6,mar7,mar8,mar9,mar10,mar11,mar12,mar13,mar14,mar15,mar16,mar17,mar18,mar19,mar20, ;
	kodm,rozma,rozmb,kolz;
	from cddKT Where !Empt(mar1) And !Empt(poznd) And d_u <= 3 ;
	order By kornw,kornd Into Cursor CKT
Select CKT
Go Top
*!*	BROWSE
*!*	retu
If Recc() > 0
	Do While !Eof()

		Select CKT
		Wait Window Nowait 'Выполнено ' + Alltrim(Str(100*Recno()/Reccount())) + '%'

		nau=naimw
		riu=poznw
		knu=kornw
		nad=naimd
		rid=poznd
		knd=kornd
		kdu = d_u

		m[1]=mar1
		m[2]=mar2
		m[3]=mar3
		m[4]=mar4
		m[5]=mar5
		m[6]=mar6
		m[7]=mar7
		m[8]=mar8
		m[9]=mar9
		m[10]=mar10
		m[11]=mar11
		m[12]=mar12
		m[13]=mar13
		m[14]=mar14
		m[15]=mar15
		m[16]=mar16
		m[17]=mar17
		m[18]=mar18
		m[19]=mar19
		m[20]=mar20
		str_p=Str(mar1,4)+'-'+Iif(mar2#0,Allt(Str(mar2,4)),'')
		If mar3#0
			str_p=str_p+'-'+Allt(Str(mar3,4))
		Endif
		If mar4#0
			str_p=str_p+'-'+Allt(Str(mar4,4))
		Endif
		If mar5#0
			str_p=str_p+'-'+Allt(Str(mar5,4))
		Endif
		If mar6#0
			str_p=str_p+'-'+Allt(Str(mar6,4))
		Endif
		If mar7#0
			str_p=str_p+'-'+Allt(Str(mar7,4))
		Endif
		If mar8#0
			str_p=str_p+'-'+Allt(Str(mar8,4))
		Endif
		If mar9#0
			str_p=str_p+'-'+Allt(Str(mar9,4))
		Endif
		If mar10#0
			str_p=str_p+'-'+Allt(Str(mar10,4))
		Endif
		If mar11#0
			str_p=str_p+'-'+Allt(Str(mar11,4))
		Endif
		If mar12#0
			str_p=str_p+'-'+Allt(Str(mar12,4))
		Endif
		If mar13#0
			str_p=str_p+'-'+Allt(Str(mar13,4))
		Endif
		If mar14#0
			str_p=str_p+'-'+Allt(Str(mar14,4))
		Endif
		If mar15#0
			str_p=str_p+'-'+Allt(Str(mar15,4))
		Endif
		If mar16#0
			str_p=str_p+'-'+Allt(Str(mar16,4))
		Endif
		If mar17#0
			str_p=str_p+'-'+Allt(Str(mar17,4))
		Endif
		If mar18#0
			str_p=str_p+'-'+Allt(Str(mar18,4))
		Endif
		If mar19#0
			str_p=str_p+'-'+Allt(Str(mar19,4))
		Endif
		If mar20#0
			str_p=str_p+'-'+Allt(Str(mar20,4))
		Endif
		Store 0 To mm
		ind =1
		Do While ind < 21
			If !Empty(m[ind])
				ii=1
				Do While ii < 21
*!*	      			WAIT WINDOW 'ind='+STR(ind,2)+' m[ind]='+STR(m[ind],4)+' ii='+STR(ii,2)+' mm[ii]='+STR(mm[ii],4)
					If mm[ii] = 0
						mm[ii] = m[ind]
					Endif
					If m[ind] = mm[ii]
						Exit
					Endif
*!*	    	  		WAIT WINDOW 'ind='+STR(ind,2)+' m[ind]='+STR(m[ind],4)+' ii='+STR(ii,2)+' mm[ii]='+STR(mm[ii],4)
					ii=ii+1
				Enddo
			Endif
			ind = ind + 1
		Enddo

		mkodm=kodm
		mrozma=rozma
		mrozmb=rozmb
		mkolz =kolz
		nmat=Space(52)
*!*			if mkodm#0
*!*				select KODM,NAIM from MATER where KODM=MKODM into cursor C_MAT
*!*				if recc() > 0
*!*					nmat=naim
*!*				endif
*!*				use in C_MAT
*!*			endif

		nmat = get_mater(mkodm)

*!*	      	if firstpass=1
		loexcel.ActiveWindow.SelectedSheets.HPageBreaks.Add(loexcel.Range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)))
*!*						*** вывести шапку
		loexcel.Range(loexcel.Cells(1,1),loexcel.Cells(8,9)).Select
		loexcel.Selection.Copy
		loexcel.Range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)).Select
		loexcel.Selection.PasteSpecial(-4104,-4142,.F.,.F.)
*!*				firstpass = 0
*!*			endif
*!*
*!*					*** прописать заголовки
		au='норм времени и расценок на изделие : '+Alltrim(m.ribf)+' '+Alltrim(naim_izd)
		loexcel.Cells(nnom+1,1).Value = au
		loexcel.Range(loexcel.Cells(nnom+1,1),loexcel.Cells(nnom+1,7)).Select
		loexcel.Selection.merge
		loexcel.Selection.Font.Bold = .T.
		loexcel.Selection.Font.Size = 8

		au='узел(деталь) кор. № '+Iif(Empt(knd),Allt(knu)+' '+Allt(nau)+' '+Allt(riu),Allt(knd)+' '+Allt(nad)+' '+Allt(rid))
		loexcel.Cells(nnom+2,1).Value = au
		loexcel.Range(loexcel.Cells(nnom+2,1),loexcel.Cells(nnom+2,7)).Select
		loexcel.Selection.merge
		loexcel.Selection.Font.Bold = .T.
		loexcel.Selection.Font.Size = 8

		If kdu = 1
			If mrozmb > 0
				au = Allt(nmat)+' '+Alltrim(Str(mrozma,6,1))+'x'+Allt(Str(mrozmb,6,1),'')+Alltrim(Str(mkolz,6,1))
			Else
				au = Allt(nmat)+'           '+Alltrim(Str(mrozma,6,1))+'      '+Alltrim(Str(mkolz,6,1))
			Endif
			loexcel.Cells(nnom+4,1).Value = au
		Endif
		loexcel.Range(loexcel.Cells(nnom+4,1),loexcel.Cells(nnom+4,7)).Select
		loexcel.Selection.merge
		loexcel.Selection.Font.Bold = .T.
		loexcel.Selection.Font.Size = 8

		loexcel.Cells(nnom+5,1).Value = 'Mаршрут '+str_p
		loexcel.Range(loexcel.Cells(nnom+5,1),loexcel.Cells(nnom+5,7)).Select
		loexcel.Selection.merge
		loexcel.Selection.Font.Bold = .T.
		loexcel.Selection.Font.Size = 8
		nnom = nnom + 8

		ind=1
		Do While ind < 21
			If Empty(mm[ind])
				Exit
			Endif
*!*				select poznd,mar,NORMW,RR,SETKA,NTO,KTO,KODO,TPZ,KRNO from TE ;
*!*					where poznd=rid and mar=mm[ind] ;
*!*					order by nto ;
*!*					into cursor CTE

			Local hh,rr
			hh = SQLConnect('sqldb','sa','111')
			If hh > 0
				Local fff
				fff = mm[ind]
				rr = SQLExec(hh,'select poznd,mar,normw,rr,setka,nto,kto,kodo,tpz,krno '+;
					'from te where rtrim(poznd)=rtrim(?rid) and mar=?fff '+;
					'order by nto','cte')
				If rr = -1
					eodbc('wnw_ sele3')
				Endif
				SQLDisconnect(hh)
			Else
				eodbc('wnw_ conn3')
			Endif
			Release hh,rr

			Select cte
			If Recc() > 0

				Local inormw,irasz,itpz,mrasz
				Local nkto As String
				Local nkodo As String

				Select Distinct nto,kto,kodo,krno,rr From cte Into Cursor c80
				Scan All

					inormw = 0
					irasz = 0
					itpz = 0
					mrasz = 0

					Local msum
					msum = 0
					Select * From cte Where nto = c80.nto Into Cursor c90
					Scan All
						msum = msum + c90.normw
						itpz = itpz + c90.tpz

*!*							mrasz=0
*!*	*sele dengi from tarif where vidts = c90.setka and
*!*	*rr = c90.rr into curs ctar

						Local h,r
						h = SQLConnect('sqldb','sa','111')
						If h > 0
							r = SQLExec(h,	'select dengi from tarif where vidts=?c90.setka '+;
								'and rr=?c90.rr','ctar')
							If r = -1
								eodbc('wnw_ sele5')
							Endif
							SQLDisconnect(h)
						Else
							eodbc('wnw_ conn5')
						Endif
						Release h,r

						Select ctar
						If Reccount()>0
							mrasz = dengi * c90.normw
							irasz = irasz + mrasz
						Endif
						Use In ctar

						nkto = get_kto_naim_by_kod(c80.kto)
						nkodo = Alltrim(c80.kodo)



					Endscan
					Use In c90
					inormw = msum
					loexcel.Cells(nnom,1).Value = m[ind]
					loexcel.Cells(nnom,2).Value = c80.nto
					loexcel.Cells(nnom,3).Value = nkto
					loexcel.Cells(nnom,4).Value = nkodo

					loexcel.Cells(nnom,5).Value = c80.krno
					loexcel.Cells(nnom,6).Value = c80.rr
					loexcel.Cells(nnom,7).Value = Iif(itpz<>0,Alltrim(Str(itpz,9,3)),'')
					loexcel.Cells(nnom,8).Value = Iif(inormw<>0,Alltrim(Str(inormw,9,3)),'')
					loexcel.Cells(nnom,9).Value = Iif(irasz<>0,Alltrim(Str(irasz,9,2))  ,'')

					nnom = nnom + 1
					iitpz    = iitpz    + itpz
					iinormw  = iinormw  + inormw
					iirasz   = iirasz   + irasz
					iiitpz   = iiitpz   + itpz
					iiinormw = iiinormw + inormw
					iiirasz  = iiirasz  + irasz

				Endscan
				Use In c80
			Endif
			Use In cte
			ind = ind + 1
		Enddo
		loexcel.Cells(nnom,3).Value = 'ИТОГО по детали(узлу)'
		loexcel.Cells(nnom,7).Value = Alltrim(Str(iitpz,9,3))
		loexcel.Cells(nnom,8).Value = Alltrim(Str(iinormw,9,3))
		loexcel.Cells(nnom,9).Value = Alltrim(Str(iirasz,9,2))
		Store 0 To iinormw,iirasz,iitpz,iMRASZ
		nnom = nnom + 1
		Select CKT
		Skip
	Enddo
Endif
*!*	nnom = nnom + 1
*!*	loexcel.Cells(nnom,3).Value = 'ИТОГО ПО ИЗДЕЛИЮ'
*!*	loexcel.Cells(nnom,7).Value = Alltrim(Str(iiitpz,9,3))
*!*	loexcel.Cells(nnom,8).Value = Alltrim(Str(iiinormw,9,3))
*!*	loexcel.Cells(nnom,9).Value = Alltrim(Str(iiirasz,9,2))
Use In CKT
Wait Window Nowait 'ОТЧЕТ ГОТОВ !'
loexcel.Visible = .T.

Use In cddKT



*!*				local mmar,gonextmar
*!*				local ssumtpz,ssumop,ssumcena
*!*
*!*				store 0 to ssumtpz,ssumop,ssumcena
*!*
*!*				mmar = cmar.kod
*!*				wait window nowait 'Участок '+str(cmar.kod,5)+' : '+alltrim(cmar.im)
*!*				*** пропустить участок если его нет в КТС
*!*				gonextmar = .f.
*!*				select * from kt ;
*!*					where shw = mizd and ;
*!*					inlist(mmar,mar1,mar2,mar3,mar4,mar5,mar6,mar7,mar8,mar9,mar10,mar11,mar12,mar13,mar14,mar15,mar16,mar17,mar18,mar19,mar20);
*!*					into cursor c100
*!*				if reccount()=0
*!*					gonextmar = .t.
*!*				else
*!*					*** пропустить участок если его нет в te
*!*					select * from te,kt where te.poznd == kt.poznd and te.mar = mmar and kt.shw = mizd into cursor c101
*!*					if reccount()=0
*!*						gonextmar = .t.
*!*					endif
*!*					use in c101
*!*				endif
*!*				use in c100
*!*				if !gonextmar
*!*					*** новая строка (не в первом случае)
*!*					if !firstpass
*!*						loExcel.ActiveWindow.SelectedSheets.HPageBreaks.Add(loExcel.Range(loExcel.Cells(nnom,1),loExcel.Cells(nnom,1)))
*!*						*** вывести шапку
*!*						loExcel.Range(loExcel.Cells(1,1),loExcel.Cells(11,5)).Select
*!*						loExcel.Selection.Copy
*!*						loExcel.Range(loExcel.Cells(nnom,1),loExcel.Cells(nnom,1)).Select
*!*						loExcel.Selection.PasteSpecial(-4104,-4142,.f.,.f.)
*!*					endif
*!*					firstpass = .f.
*!*					*** прописать заголовки
*!*					if thisform.opvid.value = 1
*!*						loexcel.cells(nnom+5,4).value = 'ПО ОБОРУДОВАНИЮ'
*!*						loExcel.Range(loExcel.Cells(nnom+5,4),loExcel.Cells(nnom+5,4)).Select
*!*						loExcel.Selection.Font.Bold = .t.
*!*						loExcel.Selection.Font.Size = 11
*!*					else
*!*						loexcel.cells(nnom+5,4).value = 'ПО ПРОФЕССИЯМ'
*!*						loExcel.Range(loExcel.Cells(nnom+5,4),loExcel.Cells(nnom+5,4)).Select
*!*						loExcel.Selection.Font.Bold = .t.
*!*						loExcel.Selection.Font.Size = 11
*!*					endif
*!*
*!*					*** написать в заголовке изделие
*!*					loExcel.Cells(nnom+6,1).value = 'Изделие: '+get_izd_ribf_by_kod(mizd)+' '+get_izd_im_by_kod(mizd)
*!*
*!*					*** написать в заголовке участок
*!*					loExcel.Cells(nnom+7,1).value = 'Участок: '+str(cmar.kod,5)+' '+cmar.im
*!*					nnom = nnom+11
*!*					*** выбираем профессии
*!*					select * from dosp where vid = 5 and kod <> 0 order by im into cursor cprof
*!*					scan all
*!*						*** пропустить профессию если она не используется
*!*						local gonext
*!*						gonext = .f.
*!*						select * from te where mar = cmar.kod and kodp = cprof.kod into cursor c100
*!*						if reccount()=0
*!*							gonext = .t.
*!*						endif
*!*						use in c100
*!*						if !gonext
*!*							*** временные переменные
*!*							local d,tr,cena
*!*							store 0 to d,tr,cena
*!*							*** для подсчета переменные
*!*							local sumcena,sumtpz,sumop
*!*							store 0 to sumcena,sumtpz,sumop
*!*							*** выбираем из te
*!*							select kt.koli, te.*;
*!*								from force te inner join kt on alltrim(te.poznd) == alltrim(kt.poznd);
*!*								where ;
*!*								te.kodp = cprof.kod and;
*!*								te.mar  = cmar.kod and;
*!*								kt.shw = mizd;
*!*								into cursor cte
*!*							scan all
*!*								tr = cte.koli * cte.normw
*!*								d = get_dengi(cte.setka,cte.rr)
*!*								cena = tr*d
*!*								*** накапливаем сумму
*!*								sumcena = sumcena + cena
*!*								sumop = sumop + tr
*!*								sumtpz = sumtpz + cte.tpz
*!*							endscan
*!*							use in cte
*!*							***
*!*							*** print line
*!*							loexcel.cells(nnom,1).value = cprof.kod
*!*							loexcel.cells(nnom,2).value = cprof.im
*!*
*!*							loExcel.Cells(nnom,3).value = sumtpz
*!*							loExcel.Cells(nnom,4).value = sumop
*!*							loExcel.Range(loExcel.Cells(nnom,3),loExcel.Cells(nnom,4)).Select
*!*							loExcel.Selection.NumberFormat = '0.000'
*!*
*!*							loExcel.Cells(nnom,5).value = sumcena
*!*							loExcel.Range(loExcel.Cells(nnom,5),loExcel.Cells(nnom,5)).Select
*!*							loExcel.Selection.NumberFormat = '0.00'
*!*							*** накапливаем суммы
*!*							ssumtpz  = ssumtpz + round(sumtpz,3)
*!*							ssumop   = ssumop + round(sumop,3)
*!*							ssumcena = ssumcena + round(sumcena,2)
*!*
*!*							*** inc counter
*!*							nnom = nnom+1
*!*						endif
*!*					endscan
*!*					*** выводим итоги по маршруту
*!*					loExcel.Cells(nnom,2).Value = 'ИТОГО'
*!*
*!*					loExcel.Cells(nnom,3).value = ssumtpz
*!*					loExcel.Cells(nnom,4).value = ssumop
*!*					loExcel.Cells(nnom,5).value = ssumcena
*!*
*!*					nnom = nnom+1
*!*					***
*!*					use in cprof
