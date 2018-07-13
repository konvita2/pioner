Public Array me[12]
me[1]='яЌ¬ј–№'
me[2]='‘≈¬–јЋ№'
me[3]='ћј–“'
me[4]='јѕ–≈Ћ№'
me[5]='ћј…'
me[6]='»ёЌ№'
me[7]='»ёЋ№'
me[8]='ј¬√”—“'
me[9]='—≈Ќ“яЅ–№'
me[10]='ќ “№Ѕ–№'
me[11]='ЌќяЅ–№'
me[12]='ƒ≈ јЅ–№'

Local mes_, inw
Store 0 To mes_
bmes=Month(Date())
Do Form f_wwod With 0,bmes To mes_
If mes_= -1 Or mes_=0
	Return -1
Endif
Wait Window Nowait '«апускаем Excel'
loexcel = Createobject('Excel.Application')
loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\e_rpk.xls')
loexcel.displayalerts = .F.

Local firstpass
firstpass = .T.

Local nnom
nnom = 1
If !firstpass
	loexcel.ActiveWindow.SelectedSheets.HPageBreaks.Add(loexcel.Range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)))
	*** вывести шапку
	loexcel.Range(loexcel.Cells(1,1),loexcel.Cells(5,5)).Select
	loexcel.Selection.Copy
	loexcel.Range(loexcel.Cells(nnom,1),loexcel.Cells(nnom,1)).Select
	loexcel.Selection.PasteSpecial(-4104,-4142,.F.,.F.)
Endif

hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	rrr = SQLExec(hhh,'Select * From BRUT Where  mes=?mes_','c_brut')
	If rrr = -1
		eodbc('kont1 brut sele')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('kont1 brut conn')
Endif
If Reccount()=0
	Wait Wind  'нет баланса времени (BRUT) по заданному мес€цу. BBEƒ»TE !!!!!!'
	Return -1
endif
*!*	brow
bbalw=balw

* берем с WW все коды  технологические с код=200 и менее 399 смотрим код профессии
* берем трудоемкостьNORMW умножаем на количество деталей в запуске KOLI и тут же
* накапливаем трудоемкость при заданом % контрол€ PROC/100 с WW
* итоговую трудоемкость делим на фонд рабочего времени мес€ца c BRUT соответствующего
* мес€ца где код=мес€цу ,а balw -времени т.е
* контролируемые параметры берем путем сложени€ их с TE и умножаем на количество
* деталей в запуске:ds,d,dbk,shag,rad,ug,rr1/2/3 каждый умноженый на IP
* в гальванике,термичке,окраске,параметров нет поэтому берем его за единицу
* в заготовительных работах kodp=138 одно poznd=2 ед. параметров
*необходимо считать по всем издели€м
*!*	Sele * From izd Order By im Into Cursor c8
hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	rrr = SQLExec(hhh,"Select * From izd Where shwz<>'' And dogid > 0 Order By im",'c_izd')
	If rrr = -1
		eodbc('f_wkp ff p_c izd tmp')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('f_wkp ff p_c izd conn')
Endif
If Reccount()=0
	Wait Wind  'Ќ≈„≈ќ –ј——„»“џ¬ј“№!!!'
	Return -1
Endif
*!*	brow
Go Top
Do While .Not.Eof()
	Scatter Memvar
	mshwz=shwz
	mim  =im
	firstpass = .F.
	loexcel.Cells(nnom+2,1).Value = 'на план '+me[mes_]+' '+Str(Year(Date()),4)+' год'
	loexcel.Cells(nnom+3,1).Value = 'изделие: '+mshwz+' '+mim
	nnom = nnom + 5
	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
*!*			rrr = SQLExec(hhh,'Select poznd,kodp,nto,kolz,kzp,normw From WW where SHWZ=?MSHWZ And KODP>=72 AND KODP<=79','c_ww_prof')
		rrr = SQLExec(hhh,'Select * From WW where SHWZ=?MSHWZ And KODP>=72 AND KODP<=79','c_ww_prof')
		If rrr = -1
			eodbc('kont1 WW Sele')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('kont1 WW conn')
	endif
*!*		brow
	Go Top
	If .Not.Eof()

		*!*			@Prow()+1,0 Say '                       –асчет'
		*!*			@Prow()+1,0 Say '                  потребности контролеров'
		*!*			@Prow()+1,0 Say '                 на план '+Str(bmes)+' мес€ц'
		*!*			@Prow()+1,0 Say 'изделие '+mshwz+' '+mim
		*!*			@Prow()+1,0 Say '------------------------------------------------------------------------'
		*!*			@Prow()+1,0 Say '  є  :   Ќаименование : -во контролир.:“рудоемкость:   %   : оличество :'
		*!*			@Prow()+1,0 Say '     :                :парам. при     :при заданом :контр. :           :'
		*!*			@Prow()+1,0 Say ' п.п.:   професии     :100 % контроле : % контрол€ :фактич.:контролеров:'
		*!*			@Prow()+1,0 Say '------------------------------------------------------------------------'
		npp=0
		kol_i=0
		kol_k=0
		*wait 'mshwz='+mshwz wind

		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrsql = SQLExec(hhh,'select * from dosp Where vid=5 And kod>71 And kod<80 order by im','c1')
			If rrsql = -1
				eodbc('kontr1 DOSP5 select')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('kontr1 DOSP5 conn')
		Endif
		select c1
		Go Top
		*brow
		Do While .Not.Eof()
			Scatter Memvar
			mkodp=kod
			a=0
			*wait 'mkodp='+str(mkodp,5) wind
			ikodp=im
			
			Select * From c_ww_prof where SHWZ=?MSHWZ And KODP=?mkodp into cursor c_ww
			select c_ww
			Go Top
			*brow
			If .Not.Eof()
				Scatter Memvar
				mpoznd=c_ww.poznd
				tr_zad=0
				tr_zad100=0
				Do While .Not.Eof()
					Scatter Memvar
					*koli=kol-kzp
					trzad100=normw*koli
					trzad =normw*koli*Proc/100
					kolk  =normw*koli*Proc/100/60/bbalw
					tr_zad=tr_zad+trzad
					tr_zad100=tr_zad100+trzad100
					kol_k =kol_k +kolk

					hhh = SQLConnect('sqldb','sa','111')
					If hhh > 0
						*!*				   Sele   poznd,kttp,nto,kolz,kzp,normw From ww where poznd= c_te.poznd And kttp= c_te.kttp And nto= c_te.nto into Curs c_ww
						rrr = SQLExec(hhh,'Select * From TE where poznd=?mpoznd And kodp=?c_ww_prof.kodp','c_te')

						If rrr = -1
							eodbc('f_wkp fp_c WW Sele')
						Endif
						SQLDisconnect(hhh)
					Else
						eodbc('f_wkp fp_c WW conn')
					endif
					select c_te
					Go Top
*!*						brow fiel rr1,rr2,toch1,toch11,toch2,toch21,tocd11,toch3,toch31,ug,rad
					If .Not.Eof()
						Do While .Not.Eof()
							Scatter Memvar
							If !Empt(rr1)
								a=a+1
							Endif
							If !Empt(rr2)
								a=a+1
							Endif
							If !Empt(toch1)
								a=a+1
							Endif
							If !Empt(toch11)
								a=a+1
							Endif
							If !Empt(toch2)
								a=a+1
							Endif
							If !Empt(toch21)
								a=a+1
							Endif
							If !Empt(tocd1)
								a=a+1
							Endif
							If !Empt(tocd11)
								a=a+1
							Endif
							If !Empt(toch3)
								a=a+1
							Endif
							If !Empt(toch31)
								a=a+1
							Endif
							If !Empt(rr3)
								a=a+1
							Endif
							If !Empt(ug)
								a=a+1
							Endif
							If !Empt(rad)
								a=a+1
							Endif
							*wait 'poznd='+poznd+' '+' kodp='+str(kodp,3)+' kto='+str(kto,4)+' a='+str(a,3) wind
							Skip
						Enddo
					endif
					use in c_te
					*wait 'poznd='+mpoznd+' '+' kodp='+str(mkodp,3) wind
					If mkodp=135 Or mkodp=138 Or mkodp=148
						a=1
					Endif
					
					
					kol_i=kol_i+kol_k
					Sele c_ww
					Skip
				Enddo
			endif
			use in c_ww
			 
			proc_k=tr_zad/tr_zad100*100
*!*				@Prow()+1,0 Say Str(npp,3)+' '+Left(ikodp,30)+' '+Str(a,3)+' '+Str(tr_zad,10,2)+' '+Str(proc_k,8,2)+' '+Str(kol_k,10,6)
			npp=npp+1
			loexcel.cells(nnom,1).Value = npp
			loexcel.cells(nnom,2).Value = ikodp
			loexcel.cells(nnom,3).Value = a
			loexcel.cells(nnom,4).Value = tr_zad
*!*				loexcel.cells(nnom,5).Value = proc_k
			loexcel.cells(nnom,5).Value = kol_k
			nnom = nnom + 1
			Sele c1
			Skip
			*wait 'sele 1 skip' wind
		Enddo
		Use In c1
	Endif
	Use In c_ww_prof
	select c_IZD
	Skip
Enddo
*!*	@Prow()+3,4 Say '¬—≈√ќ'
kol_i=Roun(kol_i,3)
*!*	@Prow(),60 Say Str(kol_i,10,3)
			loexcel.cells(nnom,2).Value = '¬—≈√ќ'
			loexcel.cells(nnom,5).Value = kol_i
			Use In c_IZD
Wait Window Nowait 'ќ“„≈“ √ќ“ќ¬ !'
loexcel.Visible = .T.
*!*	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*!*	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *





*!*	*proc kont
*!*	*do wwodmes

*!*	bmes = inputbox("¬ведите мес€ц:","ћ≈—я÷")

*!*	*sele 37
*!*	*use brut
*!*	*set filt to mes=bmes
*!*	*go top

*!*	bmes = val(bmes)
*!*	select * from brut where mes = bmes into cursor c37
*!*	bbalw=0
*!*	if .not.eof()
*!*	    bbalw=balw
*!*	else
*!*	    wait 'нет баланса времени (BRUT) по заданному мес€цу !!!' wind
*!*	    retu
*!*	    *!*	   brow
*!*	    *!*	   set filt to mes=bmes
*!*	    *!*	   go top
*!*	    *!*	   bbalw=0
*!*	    *!*	   if .not.eof()
*!*	    *!*	      sele 37
*!*	    *!*	      use
*!*	    *!*	      wait 'введите баланс времени (BRUT) по заданному мес€цу !!!' wind
*!*	    *!*	      retu
*!*	    *!*	   endif
*!*	endif
*!*	sele c37
*!*	use
*!*	fl='kont.txt '
*!*	*acti wind good
*!*	*@ 0,1 say '‘айл '+fl+' формируетс€'
*!*	*@ 1,1 say '∆дите...              '
*!*	set  print to &fl
*!*	set  device to print
*!*	* берем с WW все коды  технологические с код=200 и менее 399 смотрим код профессии
*!*	* берем трудоемкостьNORMW умножаем на количество деталей в запуске KOLI и тут же
*!*	* накапливаем трудоемкость при заданом % контрол€ PROC/100 с WW
*!*	* итоговую трудоемкость делим на фонд рабочего времени мес€ца c BRUT соответствующего
*!*	* мес€ца где код=мес€цу ,а balw -времени т.е
*!*	* контролируемые параметры берем путем сложени€ их с TE и умножаем на количество
*!*	* деталей в запуске:ds,d,dbk,shag,rad,ug,rr1/2/3 каждый умноженый на IP
*!*	* в гальванике,термичке,окраске,параметров нет поэтому берем его за единицу
*!*	* в заготовительных работах kodp=138 одно poznd=2 ед. параметров
*!*	*необходимо считать по всем издели€м
*!*	sele * from izd order by im into cursor c8
*!*	*set order to iim
*!*	go top
*!*	do while .not.eof()
*!*	    scatter memvar
*!*	    mshwz=shwz
*!*	    mim  =im
*!*	    sele * from ww where shwz=mshwz.and.kodp=>136.and.kodp<151 into curs C_WW
*!*	    go top
*!*	    if .not.eof()

*!*	        @prow()+1,0 say '                       –асчет'
*!*	        @prow()+1,0 say '                  потребности контролеров'
*!*	        @prow()+1,0 say '                 на план '+str(bmes)+' мес€ц'
*!*	        @prow()+1,0 say 'изделие '+mshwz+' '+mim
*!*	        @prow()+1,0 say '------------------------------------------------------------------------'
*!*	        @prow()+1,0 say '  є  :   Ќаименование : -во контролир.:“рудоемкость:   %   : оличество :'
*!*	        @prow()+1,0 say '     :                :парам. при     :при заданом :контр. :           :'
*!*	        @prow()+1,0 say ' п.п.:   професии     :100 % контроле : % контрол€ :фактич.:контролеров:'
*!*	        @prow()+1,0 say '------------------------------------------------------------------------'
*!*	        npp=0
*!*	        kol_i=0
*!*	        kol_k=0
*!*	        *wait 'mshwz='+mshwz wind
*!*	        *sele 1
*!*	        *set order to ivi
*!*	        *set filt to vid=5.and.kod>136.and.kod<151
*!*	        select * from dosp where vid=5 and kod>136 and kod<151 order by im ;
*!*	        	into cursor c1
*!*	        go top
*!*	        *brow
*!*	        do while .not.eof()
*!*	        	scatter memvar
*!*	            mkodp=kod
*!*	            a=0
*!*	            *wait 'mkodp='+str(mkodp,5) wind
*!*	            ikodp=im
*!*	            *sele 11              && WW
*!*	            *set filt to shwz=mshwz.and.kodp=mkodp &&.and.kto=>200.and.kto<400
*!*	            select * from ww where shwz=mshwz and kodp=mkodp into cursor C_WW
*!*	            go top
*!*	            *brow
*!*	            if .not.eof()
*!*	            	scatter memvar
*!*	                mpoznd=poznd
*!*	                tr_zad=0
*!*	                tr_zad100=0
*!*	                do while .not.eof()
*!*	                	scatter memvar
*!*	                    *koli=kol-kzp
*!*	                    trzad100=normw*koli
*!*	                    trzad =normw*koli*proc/100
*!*	                    kolk  =normw*koli*proc/100/60/bbalw
*!*	                    tr_zad=tr_zad+trzad
*!*	                    tr_zad100=tr_zad100+trzad100
*!*	                    kol_k =kol_k +kolk
*!*	                    sele 5
*!*	                    set filt to poznd=mpoznd.and.kodp=mkodp &&.and.kto=>200.and.kto<400
*!*	                    select * from te where poznd=mpoznd and kodp=mkodp ;
*!*	                    	into cursor c5
*!*	                    go top
*!*	                    *brow fiel rr1,rr2,toch1,toch11,toch2,toch21,tocd11,toch3,toch31,ug,rad
*!*	                    if .not.eof()
*!*	                        do while .not.eof()
*!*		                        scatter memvar
*!*	                            if !empt(rr1)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(rr2)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(toch1)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(toch11)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(toch2)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(toch21)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(tocd1)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(tocd11)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(toch3)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(toch31)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(rr3)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(ug)
*!*	                                a=a+1
*!*	                            endif
*!*	                            if !empt(rad)
*!*	                                a=a+1
*!*	                            endif
*!*	                            *wait 'poznd='+poznd+' '+' kodp='+str(kodp,3)+' kto='+str(kto,4)+' a='+str(a,3) wind
*!*	                            skip
*!*	                        enddo
*!*	                    endif
*!*	                    *wait 'poznd='+mpoznd+' '+' kodp='+str(mkodp,3) wind
*!*	                    if mkodp=135.or.mkodp=138.or.mkodp=148
*!*	                        a=1
*!*	                    endif
*!*	                    sele 11
*!*	                    skip
*!*	                enddo
*!*	                npp=npp+1
*!*	                proc_k=tr_zad/tr_zad100*100
*!*	                @prow()+1,0 say str(npp,3)+' '+left(ikodp,30)+' '+str(a,3)+' '+str(tr_zad,10,2)+' '+str(proc_k,8,2)+' '+str(kol_k,10,6)
*!*	                kol_i=kol_i+kol_k
*!*	            endif
*!*	            sele c1
*!*	            skip
*!*	            *wait 'sele 1 skip' wind
*!*	        enddo
*!*	    endif
*!*	    sele c8
*!*	    skip
*!*	enddo
*!*	@prow()+3,4 say '¬—≈√ќ'
*!*	kol_i=roun(kol_i,3)
*!*	@prow(),60 say str(kol_i,10,3)
*!*	*deac wind good
*!*	*do pech
*!*	set device to screen
*!*	sele c1
*!*	set filt to
*!*	sele c5
*!*	set filt to
*!*	modify command kont.txt

*!*	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*!*	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
