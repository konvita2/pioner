* печать справочников
lparameters parSpr

do	case
	case	m.parSpr = 'grupmat' 	&& группы материалов
        ** create curs
        create cursor spr_temp (kod n(5), im c(50))
        ** select
        select * from db!v_dosp26 where kod <> 9999 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'ГРУППЫ МАТЕРИАЛОВ'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'sortmat' 	&& сортамент
        ** create curs
        create cursor spr_temp (kod n(5), im c(50), us c(25))
        ** select
        select * from db!v_dosp21 where kod <> 9999 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            replace us with str(int(c_dosp.us))
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'СОРТАМЕНТЫ МАТЕРИАЛОВ'
        m.glPar2 = 'КОД ГРУППЫ'
        m.glPar3 = 'us'
        ** open report wait
        report form r_spr_dosp_3 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'stmat' 	&& стандарт поставки
        ** create curs
        create cursor spr_temp (kod n(5), im c(50), us c(25))
        ** select
        select * from db!v_dosp22 where kod <> 9999 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            replace us with str(int(c_dosp.us))
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'СТАНДАРТЫ ПОСТАВКИ МАТЕРИАЛОВ'
        m.glPar2 = 'КОД СОРТАМЕНТА'
        m.glPar3 = 'us'
        ** open report wait
        report form r_spr_dosp_3 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'shmat' 	&& стандарт химсостава
        ** create curs
        create cursor spr_temp (kod n(5), im c(50), us c(25), sim c(25))
        ** select
        select * from db!v_sh where kod <> 9999 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            replace us with str(int(c_dosp.us))
            replace sim with c_dosp.sim
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'СТАНДАРТЫ ХИМСОСТАВА МАТЕРИАЛОВ'
        m.glPar2 = 'ОБОЗНАЧЕНИЕ'
        m.glPar4 = 'КОД СОРТАМ.'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'prof' 	&& профессии
        ** create curs
        create cursor spr_temp (kod n(5), im c(50))
        ** select
        select * from db!v_dosp5 where kod <> 9999 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Профессии'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
        
	case	m.parSpr = 'ttp' 	&& типовые техпроцессы
        ** create curs
        create cursor spr_temp (kod n(5), im c(50), us c(25), sim c(25))
        ** select
        select * from db!v_dosp9 where kod <> 9999 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            replace us with str(int(c_dosp.us))
            replace sim with c_dosp.sim
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Типовые технологические техпроцессы'
        m.glPar2 = 'Обозначение'
        m.glPar4 = '№ сх. порез.'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'tarsetka' 	&& тарифные сетки
        ** create curs
        create cursor spr_temp (kod n(5), im c(50))
        ** select
        select * from dosp where kod <> 9999 and vid = 12 and kod <> 0 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Тарифные сетки'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
        
	case	m.parSpr = 'podr' 	&& подразделения
        ** create curs
        create cursor spr_temp (kod n(5), im c(50), us c(25), obor c(25))
        ** select
        select * from db!v_dosp2 where kod <> 9999 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            replace us with str(int(c_dosp.us))
            replace obor with c_dosp.obor
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Подразделения'
        m.glPar2 = 'Коеф. загр. уч.'
        m.glPar4 = 'Врем. пролеж.'        
        ** open report wait
        report form r_spr_dosp_us_obor preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
    case    m.parSpr = 'vidobor'     && виды оборудования
        ** create curs
        create cursor spr_temp (kod n(5), im c(50))
        ** select
        select * from dosp where kod <> 9999 and vid = 11 and kod <> 0 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Виды оборудования'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
        
    case    m.parSpr = 'techoper'     && коды технологических операций
        ** create curs
        create cursor spr_temp (kod n(5), im c(50), obor c(25), sim c(25))
        ** select
        select * from dosp where kod <> 9999 and kod <> 0 and vid = 7 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            replace obor with ''  &&c_dosp.obor
            replace sim with ''   &&c_dosp.sim
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Коды технологических операций'
        m.glPar2 = ''
        m.glPar4 = ''        
        ** open report wait
        report form r_spr_dosp_sim_obor preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
    
    case    m.parSpr = 'prichizm'     && причины изменений
        ** create curs
        create cursor spr_temp (kod n(5), im c(50))
        ** select
        select * from dosp where kod <> 9999 and vid = 4 and kod <> 0 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Причины изменений'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
        
    case    m.parSpr = 'ust'     && места установки
        ** create curs
        create cursor spr_temp (kod n(5), im c(50), us c(25), sim c(25))
        ** select
        select * from dosp where kod <> 9999 and kod <> 0 and vid = 30 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            replace us with str(int(c_dosp.us))
            replace sim with c_dosp.sim
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Места установки'
        m.glPar2 = 'Шероховатость'
        m.glPar4 = 'Вид обработки'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
    
    case    m.parSpr = 'sposob'     && способ установки
        ** create curs
        create cursor spr_temp (kod n(5), im c(50), us c(25), sim c(25))
        ** select
        select * from dosp where kod <> 9999 and kod <> 0 and vid = 31 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            replace us with str(int(c_dosp.us))
            replace sim with c_dosp.sim
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Способ установки'
        m.glPar2 = 'Доп. данные'
        m.glPar4 = 'Вид обработки'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
    
    case    m.parSpr = 'harust'     && характер установки
        ** create curs
        create cursor spr_temp (kod n(5), im c(50), us c(25), sim c(25))
        ** select
        select * from dosp where kod <> 9999 and kod <> 0 and vid = 32 ;
            order by im ;
            into cursor c_dosp
        scan all    
            select spr_temp
            append blank 
            replace kod with c_dosp.kod
            replace im with c_dosp.im
            replace us with str(int(c_dosp.us))
            replace sim with c_dosp.sim
            select c_dosp
        endscan    
        ** prepare headers
        m.glPar1 = 'Характер установки'
        m.glPar2 = 'Доп. данные'
        m.glPar4 = 'Вид обработки'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
    
    otherwise
		wait window nowait 'Указан неправильный справочник!'
endcase	

* show report
