* печать справочников
Lparameters parSpr

Do Case
		*!*		case	m.parSpr = 'grupmat' 	&& группы материалов
		*!*	        ** create curs
		*!*	        create cursor spr_temp (kod n(5), im c(50))
		*!*	        ** select
		*!*	        select * from db!v_dosp26 where kod <> 9999 ;
		*!*	            order by im ;
		*!*	            into cursor c_dosp
		*!*	        scan all
		*!*	            select spr_temp
		*!*	            append blank
		*!*	            replace kod with c_dosp.kod
		*!*	            replace im with c_dosp.im
		*!*	            select c_dosp
		*!*	        endscan
		*!*	        ** prepare headers
		*!*	        m.glPar1 = 'ГРУППЫ МАТЕРИАЛОВ'
		*!*	        ** open report wait
		*!*	        report form r_spr_dosp_2 preview
		*!*	        ** close curs
		*!*	        use in spr_temp
		*!*	        use in c_dosp
		*!*
		*!*		case	m.parSpr = 'sortmat' 	&& сортамент
		*!*	        ** create curs
		*!*	        create cursor spr_temp (kod n(5), im c(50), us c(25))
		*!*	        ** select
		*!*	        select * from db!v_dosp21 where kod <> 9999 ;
		*!*	            order by im ;
		*!*	            into cursor c_dosp
		*!*	        scan all
		*!*	            select spr_temp
		*!*	            append blank
		*!*	            replace kod with c_dosp.kod
		*!*	            replace im with c_dosp.im
		*!*	            replace us with str(int(c_dosp.us))
		*!*	            select c_dosp
		*!*	        endscan
		*!*	        ** prepare headers
		*!*	        m.glPar1 = 'СОРТАМЕНТЫ МАТЕРИАЛОВ'
		*!*	        m.glPar2 = 'КОД ГРУППЫ'
		*!*	        m.glPar3 = 'us'
		*!*	        ** open report wait
		*!*	        report form r_spr_dosp_3 preview
		*!*	        ** close curs
		*!*	        use in spr_temp
		*!*	        use in c_dosp
		*!*
		*!*		case	m.parSpr = 'stmat' 	&& стандарт поставки
		*!*	        ** create curs
		*!*	        create cursor spr_temp (kod n(5), im c(50), us c(25))
		*!*	        ** select
		*!*	        select * from db!v_dosp22 where kod <> 9999 ;
		*!*	            order by im ;
		*!*	            into cursor c_dosp
		*!*	        scan all
		*!*	            select spr_temp
		*!*	            append blank
		*!*	            replace kod with c_dosp.kod
		*!*	            replace im with c_dosp.im
		*!*	            replace us with str(int(c_dosp.us))
		*!*	            select c_dosp
		*!*	        endscan
		*!*	        ** prepare headers
		*!*	        m.glPar1 = 'СТАНДАРТЫ ПОСТАВКИ МАТЕРИАЛОВ'
		*!*	        m.glPar2 = 'КОД СОРТАМЕНТА'
		*!*	        m.glPar3 = 'us'
		*!*	        ** open report wait
		*!*	        report form r_spr_dosp_3 preview
		*!*	        ** close curs
		*!*	        use in spr_temp
		*!*	        use in c_dosp
		*!*
		*!*		case	m.parSpr = 'shmat' 	&& стандарт химсостава
		*!*	        ** create curs
		*!*	        create cursor spr_temp (kod n(5), im c(50), us c(25), sim c(25))
		*!*	        ** select
		*!*	        select * from db!v_sh where kod <> 9999 ;
		*!*	            order by im ;
		*!*	            into cursor c_dosp
		*!*	        scan all
		*!*	            select spr_temp
		*!*	            append blank
		*!*	            replace kod with c_dosp.kod
		*!*	            replace im with c_dosp.im
		*!*	            replace us with str(int(c_dosp.us))
		*!*	            replace sim with c_dosp.sim
		*!*	            select c_dosp
		*!*	        endscan
		*!*	        ** prepare headers
		*!*	        m.glPar1 = 'СТАНДАРТЫ ХИМСОСТАВА МАТЕРИАЛОВ'
		*!*	        m.glPar2 = 'ОБОЗНАЧЕНИЕ'
		*!*	        m.glPar4 = 'КОД СОРТАМ.'
		*!*	        ** open report wait
		*!*	        report form r_spr_dosp_4 preview
		*!*	        ** close curs
		*!*	        use in spr_temp
		*!*	        use in c_dosp

	Case	m.parSpr = 'prof' 	&& профессии
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50))
		nammat = ''
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=5 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 5 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Профессии'
		** open report wait
		Report Form r_spr_dosp_2 Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Case	m.parSpr = 'ttp' 	&& типовые техпроцессы
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50), us c(25), sim c(25))
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=9 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 9 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Replace us With Str(Int(c_dosp.us))
			Replace sim With c_dosp.sim
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Типовые технологические техпроцессы'
		m.glPar2 = 'Обозначение'
		m.glPar4 = '№ сх. порез.'
		** open report wait
		Report Form r_spr_dosp_4 Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Case	m.parSpr = 'tarsetka' 	&& тарифные сетки
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50))
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=12 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 12 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Тарифные сетки'
		** open report wait
		Report Form r_spr_dosp_2 Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Case	m.parSpr = 'podr' 	&& подразделения
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50), us c(25), obor c(25))
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=2 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 2 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Replace us With Str(Int(c_dosp.us))
			Replace obor With c_dosp.obor
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Подразделения'
		m.glPar2 = 'Коеф. загр. уч.'
		m.glPar4 = 'Врем. пролеж.'
		** open report wait
		Report Form r_spr_dosp_us_obor Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Case    m.parSpr = 'vidobor'     && виды оборудования
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50))
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=11 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 11 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Виды оборудования'
		** open report wait
		Report Form r_spr_dosp_2 Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Case    m.parSpr = 'techoper'     && коды технологических операций
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50), obor c(25), sim c(25))
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=7 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 7 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Replace obor With ''  &&c_dosp.obor
			Replace sim With ''   &&c_dosp.sim
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Коды технологических операций'
		m.glPar2 = ''
		m.glPar4 = ''
		** open report wait
		Report Form r_spr_dosp_sim_obor Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Case    m.parSpr = 'prichizm'     && причины изменений
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50))
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=4 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 4 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Причины изменений'
		** open report wait
		Report Form r_spr_dosp_2 Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Case    m.parSpr = 'ust'     && места установки
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50), us c(25), sim c(25))
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=30 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 30 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Replace us With Str(Int(c_dosp.us))
			Replace sim With c_dosp.sim
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Места установки'
		m.glPar2 = 'Шероховатость'
		m.glPar4 = 'Вид обработки'
		** open report wait
		Report Form r_spr_dosp_4 Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Case    m.parSpr = 'sposob'     && способ установки
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50), us c(25), sim c(25))
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=31 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 31 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Replace us With Str(Int(c_dosp.us))
			Replace sim With c_dosp.sim
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Способ установки'
		m.glPar2 = 'Доп. данные'
		m.glPar4 = 'Вид обработки'
		** open report wait
		Report Form r_spr_dosp_4 Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Case    m.parSpr = 'harust'     && характер установки
		** create curs
		Create Cursor spr_temp (kod N(5), im c(50), us c(25), sim c(25))
		** select
		Local hhh,rrr
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,'select * from DOSP where vid=32 and kod>0 and kod <>9999 order by im','c_dosp')
			If rrr = -1
				eodbc('pech_spr DOSP 32 selection')
				SQLDisconnect(hhh)
				Return-1
			Endif
		Else
			eodbc('pech_spr connection')
			Return
		Endif
		Select c_dosp
		Scan All
			Select spr_temp
			Append Blank
			Replace kod With c_dosp.kod
			Replace im With c_dosp.im
			Replace us With Str(Int(c_dosp.us))
			Replace sim With c_dosp.sim
			Select c_dosp
		Endscan
		** prepare headers
		m.glPar1 = 'Характер установки'
		m.glPar2 = 'Доп. данные'
		m.glPar4 = 'Вид обработки'
		** open report wait
		Report Form r_spr_dosp_4 Preview
		** close curs
		Use In spr_temp
		Use In c_dosp

	Otherwise
		Wait Window Nowait 'Указан неправильный справочник!'
Endcase

* show report
