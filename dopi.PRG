 		Local mes_
		*Store 0 To mes_
		*bmes=Month(Date())
		*Do Form f_wwod With 0,bmes To mes_
		*If mes_= -1 Or mes_=0
		*	Return -1
		*Endif
		mes_=7
		Wait Window Nowait 'Запускаем Excel'
		loexcel = Createobject('Excel.Application')
		loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\e_swwi.xls')
		loexcel.displayalerts = .F.
		
		local firstpass
		firstpass = .t.

		local nnom
		nnom = 1
		if !firstpass
				loexcel.ActiveWindow.SelectedSheets.HPageBreaks.add(loexcel.range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)))
				*** вывести шапку
				loexcel.range(loexcel.Cells(1,1),loexcel.Cells(4,4)).select
				loexcel.selection.copy
				loexcel.range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)).select
				loexcel.selection.PasteSpecial(-4104,-4142,.f.,.f.)
		endif
		firstpass = .f.
		loexcel.Cells(nnom+2,3).value = ' '+me[mes_]+' '+Str(Year(Date()),4)+' год'
		nnom = nnom + 4
		*!*			fl='kp.txt'
		*!*			Wait Window "Документ формируeтся..." Nowait

		*!*			Set Print To &fl
		*!*			Set Device To Print
		*!*			@Prow()+1,0 Say '            Сводная ведомость вспомогательного инструмента'
		*!*			@Prow()+1,0 Say '            запуска - выпуска изделий  на план '
		*!*			@Prow()+1,0 Say '            '+me[mes_]+' '+Str(Year(Date()))+' год '
		*!*			@Prow()+1,0 Say '--------------------------------------------------------------'
		*!*			@Prow()+1,0 Say ' № :Учетный:    Наименование                           :Труд.:'
		*!*			@Prow()+1,0 Say 'п\п:  код  :                                           :работ:'
		*!*			@Prow()+1,0 Say '--------------------------------------------------------------'
		npp=0

		*!*			Sele pri,kodi,im,st,ns From Instr Where pri=3 Order By im ;
		*!*				into Curs c_instr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			*!*				   Sele   pri,kodi,im,st,ns From Instr Where pri=3 Order By im into Curs c_instr
			rrr = SQLExec(hhh,'select pri,kodi,im,st,ns From Instr Where pri=3 Order By im','c_instr')
			If rrr = -1
				eodbc('f_tokar_new Select getri')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('f_tokar_new conn getri')
		Endif
		Select c_instr
		Go Top
		Do While .Not.Eof()
			Wait Wind Nowa c_instr.im
			Scat Memv
			*!*				Sele poznd,kttp,nto From te Where Inlist(m.kodi,kodid,kodid1,kodid2)  ;
			*!*					into Curs c_te
			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
				*!*				   Select poznd,kttp,nto From te Where Inlist(m.kodi,kodim,kodim1,kodim2) into Curs c_te
				rrr = SQLExec(hhh,'Select poznd,kttp,nto From te Where (kodim=?m.kodi or kodim1=?m.kodi or kodim2=?m.kodi)','c_te')
				If rrr = -1
					eodbc('f_wkp TE p_c kp')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('f_wkp ff p_c TE conn')
			Endif
			Select c_te
			Go Top
			tr=0
			Do While .Not.Eof()

				*!*					Sele poznd,kttp,nto,kolz,kzp,normw From ww ;
				*!*						where ;
				*!*						poznd=c_te.poznd ;
				*!*						into Curs c_ww
				hhh = SQLConnect('sqldb','sa','111')
				If hhh > 0
					*!*				   Sele   poznd,kttp,nto,kolz,kzp,normw From ww where poznd= c_te.poznd into Curs c_ww
					rrr = SQLExec(hhh,'Select poznd,kttp,nto,kolz,kzp,normw From ww where poznd=?c_te.poznd','c_ww')
					If rrr = -1
						eodbc('f_wkp fp_c WW Sele')
					Endif
					SQLDisconnect(hhh)
				Else
					eodbc('f_wkp fp_c WW conn')
				Endif
				Go Top
				If .Not.Eof()
					kolz_kzp=kolz-kzp
				Else
					kolz_kzp=0
				Endif
				tr=tr+normw*kolz_kzp
				Use In c_ww
				Sele c_te
				Skip
			Enddo
			Use In c_te
			
			Sele c_instr
			If tr#0
*!*					@Prow()+1,0  Say Str(npp,4)+' '+Str(m.kodi,3);
*!*						+' '+im;
*!*						+' '+Str(tr,6,2)
				npp=npp+1
				loexcel.cells(nnom,1).Value = npp
				loexcel.cells(nnom,2).Value = m.kodi
				loexcel.cells(nnom,3).Value = im
				loexcel.cells(nnom,4).Value = tr
				nnom = nnom + 1
			Endif
			Skip
		Enddo
		Use In c_instr

		Wait Window Nowait 'ОТЧЕТ ГОТОВ !'
		loexcel.Visible = .T.

*!*		Case mm0=9                                        &&
*!*			Local mes_
*!*			Store 0 To mes_
*!*			bmes=Month(Date())
*!*			Do Form f_wwod With 0,bmes To mes_
*!*			If mes_= -1 Or mes_=0
*!*				Return -1
*!*			Endif
*!*			Wait Window Nowait 'Запускаем Excel'
*!*			loexcel = Createobject('Excel.Application')
*!*			loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\e_swo.xls')
*!*			loexcel.displayalerts = .F.
*!*			local firstpass
*!*			firstpass = .t.

*!*			local nnom
*!*			nnom = 1
*!*			if !firstpass
*!*					loexcel.ActiveWindow.SelectedSheets.HPageBreaks.add(loexcel.range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)))
*!*					*** вывести шапку
*!*					loexcel.range(loexcel.Cells(1,1),loexcel.Cells(4,4)).select
*!*					loexcel.selection.copy
*!*					loexcel.range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)).select
*!*					loexcel.selection.PasteSpecial(-4104,-4142,.f.,.f.)
*!*			endif
*!*			firstpass = .f.
*!*			loexcel.Cells(nnom+2,3).value = ' '+me[mes_]+' '+Str(Year(Date()),4)+' год'
*!*			nnom = nnom + 4
*!*			*!*			fl='kp.txt'
*!*			*!*			Wait Window "Документ формируeтся..." Nowait

*!*			*!*			Set Print To &fl
*!*			*!*			Set Device To Print
*!*			*!*			@Prow()+1,0 Say '     					Сводная ведомость оснастки '
*!*			*!*			@Prow()+1,0 Say ' 					запуска - выпуска изделий  на план '
*!*			*!*			@Prow()+1,0 Say '  				  '+me[mes_]+' '+Str(Year(Date()))+' год '
*!*			*!*			@Prow()+1,0 Say '--------------------------------------------------------------------------'
*!*			*!*			@Prow()+1,0 Say ' № :Учетный: Обозначение и наименование                             :Труд.:'
*!*			*!*			@Prow()+1,0 Say 'п\п:  код  :                                                        :работ:'
*!*			*!*			@Prow()+1,0 Say '---------------------------------------------------------------------------'
*!*			npp=0

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrr = SQLExec(hhh,'Select kod,im,naim From press Order By im','c_press')
*!*				If rrr = -1
*!*					eodbc('f_wkp TE p_c kp')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('f_wkp ff p_c TE conn')
*!*			Endif
*!*			Select c_press
*!*			Go Top
*!*			Do While .Not.Eof()
*!*				Wait Wind Nowa c_press.NAIM
*!*				If c_press.kod>0
*!*					Scat Memv
*!*					*!*				Sele poznd,kttp,nto,osn From te where osn = c_press.kod into Curs c_te
*!*					hhh = SQLConnect('sqldb','sa','111')
*!*					If hhh > 0
*!*						rrr = SQLExec(hhh,'Select poznd,kttp,nto,osn From te where osn =?c_press.kod','c_te')
*!*						If rrr = -1
*!*							eodbc('f_wkp TE p_c kp')
*!*						Endif
*!*						SQLDisconnect(hhh)
*!*					Else
*!*						eodbc('f_wkp ff p_c TE conn')
*!*					Endif
*!*					Select c_te
*!*					Go Top
*!*					tr=0
*!*					Do While .Not.Eof()
*!*						hhh = SQLConnect('sqldb','sa','111')
*!*						If hhh > 0
*!*							*!*				   Select poznd,kttp,nto,kolz,kzp,normw From ww where poznd=c_te.poznd into Cursor c_ww
*!*							rrr = SQLExec(hhh,'Select poznd,kttp,nto,kolz,kzp,normw From ww where poznd=?c_te.poznd','c_ww')
*!*							If rrr = -1
*!*								eodbc('f_wkp fp_c WW Sele')
*!*							Endif
*!*							SQLDisconnect(hhh)
*!*						Else
*!*							eodbc('f_wkp fp_c WW conn')
*!*						Endif
*!*						Go Top
*!*						If .Not.Eof()
*!*							kolz_kzp=kolz-kzp
*!*						Else
*!*							kolz_kzp=0
*!*						Endif
*!*						tr=tr+normw*kolz_kzp
*!*						Use In c_ww
*!*						Sele c_te
*!*						Skip
*!*					Enddo
*!*					Use In c_te

*!*					Sele c_press
*!*					If tr#0
*!*						npp=npp+1
*!*	*!*						@Prow()+1,0  Say Str(npp,4)+' '+Str(m.kod,3);
*!*	*!*							+'    '+im;
*!*	*!*							+' '+NAIM;
*!*	*!*							+' '+Str(tr,6,2)
*!*						loexcel.cells(nnom,1).Value = npp
*!*						loexcel.cells(nnom,2).Value = m.kod
*!*						loexcel.cells(nnom,3).Value = Alltrim(im)+' '+Alltrim(NAIM)
*!*						loexcel.cells(nnom,4).Value = tr
*!*						nnom = nnom + 1
*!*					Endif
*!*				Endif
*!*				Skip
*!*			Enddo
*!*			Use In c_press
*!*			Wait Window Nowait 'ОТЧЕТ ГОТОВ !'
*!*			loexcel.Visible = .T.
