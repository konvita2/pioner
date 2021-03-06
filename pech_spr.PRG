* ������ ������������
lparameters parSpr

do	case
	case	m.parSpr = 'grupmat' 	&& ������ ����������
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
        m.glPar1 = '������ ����������'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'sortmat' 	&& ���������
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
        m.glPar1 = '���������� ����������'
        m.glPar2 = '��� ������'
        m.glPar3 = 'us'
        ** open report wait
        report form r_spr_dosp_3 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'stmat' 	&& �������� ��������
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
        m.glPar1 = '��������� �������� ����������'
        m.glPar2 = '��� ����������'
        m.glPar3 = 'us'
        ** open report wait
        report form r_spr_dosp_3 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'shmat' 	&& �������� ����������
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
        m.glPar1 = '��������� ���������� ����������'
        m.glPar2 = '�����������'
        m.glPar4 = '��� ������.'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'prof' 	&& ���������
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
        m.glPar1 = '���������'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
        
	case	m.parSpr = 'ttp' 	&& ������� �����������
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
        m.glPar1 = '������� ��������������� �����������'
        m.glPar2 = '�����������'
        m.glPar4 = '� ��. �����.'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
	case	m.parSpr = 'tarsetka' 	&& �������� �����
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
        m.glPar1 = '�������� �����'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
        
	case	m.parSpr = 'podr' 	&& �������������
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
        m.glPar1 = '�������������'
        m.glPar2 = '����. ����. ��.'
        m.glPar4 = '����. ������.'        
        ** open report wait
        report form r_spr_dosp_us_obor preview
        ** close curs	
        use in spr_temp 
        use in c_dosp	
	
    case    m.parSpr = 'vidobor'     && ���� ������������
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
        m.glPar1 = '���� ������������'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
        
    case    m.parSpr = 'techoper'     && ���� ��������������� ��������
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
        m.glPar1 = '���� ��������������� ��������'
        m.glPar2 = ''
        m.glPar4 = ''        
        ** open report wait
        report form r_spr_dosp_sim_obor preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
    
    case    m.parSpr = 'prichizm'     && ������� ���������
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
        m.glPar1 = '������� ���������'
        ** open report wait
        report form r_spr_dosp_2 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
        
    case    m.parSpr = 'ust'     && ����� ���������
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
        m.glPar1 = '����� ���������'
        m.glPar2 = '�������������'
        m.glPar4 = '��� ���������'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
    
    case    m.parSpr = 'sposob'     && ������ ���������
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
        m.glPar1 = '������ ���������'
        m.glPar2 = '���. ������'
        m.glPar4 = '��� ���������'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
    
    case    m.parSpr = 'harust'     && �������� ���������
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
        m.glPar1 = '�������� ���������'
        m.glPar2 = '���. ������'
        m.glPar4 = '��� ���������'        
        ** open report wait
        report form r_spr_dosp_4 preview
        ** close curs    
        use in spr_temp 
        use in c_dosp    
    
    otherwise
		wait window nowait '������ ������������ ����������!'
endcase	

* show report
