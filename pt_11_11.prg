PARAMETERS nozap_kt,izd_par
*!*	WAIT WINDOW 'pt.prg nozap_kt='+STR(nozap_kt)
create cursor ptt (;
	id n(10),;
	buk c(1),;
	pozn c(30),;
	poznd c(30),;
	naimd c(70),;
	kttp c(40),;
	kodms c(80),;
	ss c(100),;
	kod n(4),;
	eb c(5),;
	md n(11,5),;
	rash n(11,5),;
	kim n(5,3),;
	kz c(15),;
	pir c(30),;
	kd n(3,1),;
	mz n(11,5),;
	ceh n(4),;
	oper n(4),;
	knop c(35),;
	od c(50),;
	knob c(43),;
	prof n(3),;
	p n(1),;
	ut n(2),;
	kp n(1),;
	koid n(3),;
	tpz n(4,1),;
	tsht n(10,6);	
)
*!*	brow
on key label f12 retu 
priv mnaim,kod_izd
priv detup,detun

LOCAL DOSP_KOD,PASSED_VID

publ o[100]
publ m[20]
public k[15]
public uslovi[15]
local mpozn,mshw,iribf,msim
priv mkttp
mkttp=''

*!*	do FORm f_IZD_vib TO mribf
*!*	SELECT * from izd WHERE RIBF=MRIBF INTO CURSOR c_izd
*!*	do form f_ribf with c_izd.kod to mribf  
*!*	      wait window 'mribf='+mribf   
*!*	SELECT * FROM kt WHERE shw=c_izd.kod AND alltrim(poznd)==alltrim(mribf) AND !empt(mar1) AND d_u<3 INTO CURSOR C_KT
SELECT * FROM kt WHERE kod=nozap_kt INTO CURSOR C_KT
*!*	brow
if recc() = 0
   wait 'HET TAKOЙ ПOЗИЦИИ !!!' wind
   return - 1
endif

*!*	USE IN c_izd
  
select C_KT

m.pozn  = c_kt.pozn
m.poznd = c_kt.poznd
m.naimd = c_kt.naimd
m.md 	  = c_kt.wag
m.rash  = c_kt.nrmd
m.kim   = iif(c_kt.nrmd#0,c_kt.wag/c_kt.nrmd,0)
m.kz = ''
IF !EMPTY(c_kt.kodzag)
	SELECT * FROM dosp WHERE vid=56 AND kod=c_kt.kodzag into CURSOR c_dosp
	m.kz    = ALLTRIM(c_dosp.im)
	USE IN c_dosp
endif
m.pir   = allt(STR(c_kt.rozma,6,1))+iif(c_kt.tocha<>0,allt(str(c_kt.tocha,4,2)),'')+ ;
	iif(c_kt.rozmb<>0,'x'+allt(STR(c_kt.rozmb,6,1)),'')+ ;
	iif(c_kt.tochb<>0,' '+allt(str(c_kt.tochb,4,2)),'')
m.kd    = 1
m.mz    = c_kt.mz 
*!*	SCAN ALL 
store 0 to m
select c_kt
m[1] =mar1
m[2] =mar2
m[3] =mar3
m[4] =mar4
m[5] =mar5
m[6] =mar6
m[7] =mar7
m[8] =mar8
m[9] =mar9
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

sele gr,sort,KODM,tm,dm,ps,naim,ei from MATER ;
     where koDm = c_kt.kodm ;
     into curs C_MATER

m.kodms = c_mater.naim
m.eb    = c_mater.ei

INSERT INTO ptt FROM memv
    
mars=1
do while mars<21
   *wait 'mars='+str(mars,4)+' m[mars]='+str(m[mars],4) wind
  	sele * from TE where ;
        mar=m[mars] ;
        and poznd=C_KT.poznd ;
        into curs c_tee
        
*!*	                 brow
  	if RECCOUNT()>0 AND !empt(kttp)
  	 	mkttp=c_tee.kttp
		USE IN c_tee
     	do ptp
   ELSE
   	USE IN c_tee
			*wait 'по детали '+c_kt.poznd+' и маршруту '+str(m[mars],4)+' пустой техпроцесс !!! ' wind
   ENDIF
   mars=mars+1
enddo
use in c_kt
use in c_mater
*!*	select * from ptt
DO printptt
on key
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc ptp
store 0 to o
 
sele * FROM TE WHERE ;
		mar=m[mars] ;
      and poznd=C_KT.poznd ;
      order BY NTO,NTP ;
      INTO CURS C_TEO
 
ind=1
if recc()=0
   wait 'mkttp'+mkttp+' c_kt.poznd'+c_kt.poznd+' нет иформации в TE' wind
   RETURN 
ENDIF 
do while .not.eof()
*!*	   wait 'nto='+str(nto,3) wind
   ind=1
   do while nto#o[ind] OR o[ind]#0
*!*	      wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
      if o[ind]=nto
         exit
      endif
      if o[ind]=0 &&nto
         o[ind]=c_teo.nto
         exit
      endif
      ind=ind+1
      if ind>100
         wait 'недостаточно памяти, надо расширить' wind
         exit
      endif
   enddo
   skip
ENDDO
USE IN C_TEO
ind=1

do while o[ind]#0
*!*	   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
   sele * FROM TE WHERE  ;
        mar=m[mars] ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        ORDER BY NTP ;
        INTO CURS C_TE
*!*	        if mar = 9226
*!*	        	browse
*!*	        	 WAIT 'sele TE mkttp='+mkttp+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3)+str(ind) WIND
*!*	        endif
*!*	        brow 
*!*	   	  WAIT 'sele TE mkttp='+mkttp+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3)+str(ind) WIND
   sum  normw,tpz to itogt,itpz
   if ITOGT = 0
      wait 'нет в TE информации по операции '+mkttp+' '+alltrim(c_kt.poznd)+' '+str(o[ind],4) wind
   else
	   go top
   	DO WHILE !EOF()
   		scat memv
	   	*wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto) 
		   if c_te.ntp < 2
				m.knop = ''
		   	if m.kto#0
	   	   	sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
		      	if RECC()>0
		         	m.knop= ALLTRIM(STR(C_DOSP_7.kod))+' '+C_DOSP_7.im
	   	      	IF INLIST(LEFT(m.kttp,11),'06024.01271','06024.55273','06024.55250')
	      	   		m.knop = m.knop + ' '+m.kttp
	         		endif
					endif         	
		      ENDIF
	         DO stroka_a
	      	m.knob = ''
			   if !empt(m.kodo)
	      		sele marka,naim from obor where MARKA=m.kodo into curs c_obor
		      	if recc() > 0
	   	      	m.knob = ALLTRIM(c_obor.marka)+' '+allt(c_obor.naim)
					endif     
		   	   use in c_obor
			   endif
	   		do stroka_b
		   endif
			
	      IF inli(m[mars],212,213,215,604,341,11042,4042,9142,9242,433,1024,1046,1109,1440,1540,1640) ;
	      	OR inli(m[mars],4141,4240,4241,44440,9140,9240,4340,6022,8043,9206,9238,9247,9248,9249)
		      IF m[mars] = 212
	   	   	soder = 'Точить деталь согласно чертежа'
	      	ENDIF
		      IF m[mars] = 213
		      	soder = 'Точить деталь согласно программы'
	   	   ENDIF
		      IF m[mars] = 215 or m[mars] = 604
		      	soder = 'Обработать поверхности детали согласно прграммы'
	   	   ENDIF
		      IF m[mars] = 223
		      	soder = 'Накатать резьбу согласно чертежа'
	   	   ENDIF
	      	IF INLIST(m[mars], 341, 11042, 4042, 9142, 9242)
	      		soder = 'Упаковать изделие в соответствии с требованиями чертежа'
		      ENDIF
		      IF m[mars] = 433
	   	   	soder = 'Прессовать согласно чертежа' 
	      	ENDIF
		      IF m[mars] = 1024
*!*			      	WAIT WINDOW '1024'
		      	soder = 'Гравировать согласно чертежа' 
	   	   ENDIF
		      IF m[mars] = 1046
		      	soder = 'Отрезать заготовку в размер чертежа'
		      ENDIF
		      IF m[mars] = 1109
		      	soder = 'Пескоструить деталь(узел), выполняя требования чертежа' 
		      ENDIF
		      IF INLIST(m[mars],  1440, 1540, 1640, 4141, 4240, 4241, 4440,9140, 9240)
		      	soder = 'Собрать узел в соответствии с требованиями чертежа' 
		      ENDIF
		      IF m[mars] = 4340
		      	soder = 'Поизвести работы по предпродажной подготовке' 
		      ENDIF
		      IF m[mars] = 6022
		      	soder = 'Обработать деталь электоэрозионным способом' 
		      ENDIF
		      IF m[mars] = 8043
		      	soder = 'Изготовить тару согласно чертежа' 
		      ENDIF
		      IF m[mars] = 9206
		      	soder = 'Вырезать заготовку на виброножницах согласно чертежа' 
		      ENDIF
		      IF m[mars] = 9238
		      	soder = 'Ковать заготовку согласно чертежа'
		      ENDIF
		      IF m[mars] = 9247
		      	soder = 'Пошить изделие согласно чертежа'
		      ENDIF
		      IF m[mars] = 9248
		      	soder = 'Изготовить тару согласно чертежа'
		      ENDIF
		      IF m[mars] = 9249
		      	soder = 'Размагнитить изделие в соответствии с типовым техпроцессом'
		      ENDIF
		      DO stroka_o
		      SODER = ''
	    	else	
				if left(mkttp,11)='06024.01271'
					DO GALWAN
				ENDIF
				IF c_te.kttp='06024.50141.00001'
					DO F_TOK_VINT
				ENDIF
				IF c_te.kttp='06024.50141.00003'
					DO F_FREZA
				ENDIF
				IF c_te.kttp='06024.50141.00004'
					DO F_K_S
				ENDIF
				IF c_te.kttp='06024.50141.00005'
					DO F_P_S
				ENDIF
				IF c_te.kttp='06024.50141.00008'
					DO F_koord_Slif
				ENDIF
				IF c_te.kttp='06024.50141.00009'
*!*						wait window 'DO F_SWERL'
					DO F_SWERL
				ENDIF
				IF c_te.kttp='06024.50141.00024'
					DO F_W_S
				ENDIF
				if c_te.kttp = '06024.50141.00006'
					DO F_O_S
				ENDIF
				if c_te.kttp = '06024.50141.00007'
					DO F_K_R
				ENDIF
				IF c_te.kttp='06024.50141.00025' or c_te.kttp='06024.50141.00026' or c_te.kttp='06024.50141.00027'
					DO F_Z_F
				ENDIF
				if mkttp='06024.55201.00001'
					DO SLESAR
				ENDIF
				if mkttp='06024.55201.00002'
					DO valz
				ENDIF
				IF INLIST(mkttp,'06024.55201.00010','06024.55201.00011','06024.55201.00012','06024.55201.00013', ;
									 '06024.55201.00014','06024.55201.00015','06024.55201.00016','06024.55201.00017')
					DO SLESaR_PR
				endif
				if left(mkttp,11)='06024.55241'
					DO ZAGOT
				ENDIF
				if left(mkttp,11)='06024.55250'
					DO TERM
				ENDIF
				if left(mkttp,11)='06024.55265'
					DO SHTAMP
				ENDIF
				if left(mkttp,11)='06024.55273'
					DO OKRASKA
				ENDIF
		 		IF mkttp='06024.55290.00011'
	 				DO SWARKA_KONT
	 	  		ENDIF 
				IF INLIST(mkttp,'06024.55290.00010','06024.55290.00014','06024.55290.00012')		
					DO SWARKA
				ENDIF
			endif	
			sele c_te
      	SKIP
      enddo
   ENDIF 
   USE IN C_TE
   sele dist mar,poznd,nto,osn FROM TE WHERE  ;
        mar=m[mars] ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        INTO CURS C_TE
   scan
   	IF c_te.osn<>0 
	      select KOD,IM,NAIM from PRESS ;
	         	WHERE kod=c_te.osn ;
	           	into cursor C_KODIO
	      if RECC()>0
		      SCAN
	  	  			soder_t=allt(c_kodio.im)+' '+allt(c_kodio.naim)
	  				m.buk = 'T'
					m.ss  = soder_t
					INSERT INTO ptt FROM memv
		      ENDSCAN
	     	endif
		   use in c_kodio
		ENDIF
	endscan		
	USE IN c_te
	sele dist mar,poznd,nto,kodi,kttp FROM TE WHERE  ;
        mar=m[mars] ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        INTO CURS C_TE
   scan
	   IF C_TE.KODI<>0 
			ikodir=''
	      select KODI, IM, PRI from INSTR ;
	            WHERE kodi=c_te.KODI and pri=1 ;
	            into cursor C_KODI
		   if RECC() > 0
	      	SCAN
	     		   ikodir=im
	      	   soder_t=allt(ikodir)
		        	m.buk = 'T'
					m.ss  = soder_t
					INSERT INTO ptt FROM memv
				ENDSCAN         
	     	ENDIF
	      use in C_KODI
		ENDIF 
	ENDSCAN
	USE IN c_te	
	sele dist mar,poznd,nto,kodim FROM TE WHERE  ;
        mar=m[mars] ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        INTO CURS C_TE
   scan
		IF c_te.KODIM<>0 
       	ikodim=''
	      select KODI,PRI,IM FROM INSTR ;
   	      	WHERE kodi=C_TE.kodim and pri=2 ;
		        	INTO CURS c_IME
			if RECC()>0
				SCAN	       
	     			ikodim=im
			     	soder_t=allt(ikodim)
	   	      m.buk = 'T'
					m.ss  = soder_t
					INSERT INTO ptt FROM memv
  	   	   ENDSCAN 
   		endif
		   use in c_ime
	   ENDIF
	ENDSCAN
	USE IN c_te 
	sele dist mar,poznd,nto,kodid FROM TE WHERE  ;
        mar=m[mars] ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        INTO CURS C_TE
   scan
		IF KODID<>0 
      	select KODI,PRI,IM from INSTR ;
	         	WHERE kodi=c_te.KODId and pri=3 ;
	           	into cursor C_KODID
	      if RECC()>0
		      SCAN
	  	  			soder_t=allt(C_KODID.IM)
	  				m.buk = 'T'
					m.ss  = soder_t
					INSERT INTO ptt FROM memv
		      ENDSCAN
	     	endif
		   use in c_kodid
		ENDIF
	ENDSCAN
	USE IN c_te	 
   ind=ind+1
enddo
RETURN 
***************************************************************************************************
PROCEDURE SWARKA_KONT
wait window ' пошла сварка контактная' nowa
	                                   
IF c_te.kto = 418
	SELECT kornd,naimd,nrmd,pri1 FROM KT WHERE poznw=c_kt.poznd AND pri1 = c_te.pri AND pri2 = 0 ORDER BY pri1 INTO CURSOR c_kt_sw 
	soder = ''
	SCAN
		IF c_kt_sw.pri1 = 0
			m.buk = 'О'
			m.ss = 'Скомплектовать детали(узлы) под сварку и транспортировать на рабочее место сварщика'
			INSERT INTO ptt FROM memv
		ENDIF
		IF c_kt_sw.pri1 > 0
			m.buk = 'О'
			m.ss = 'Скомплектовать детали(узлы) технологического узла № '+ALLTRIM(STR(c_kt_sw.pri1)) ;
					+' под сварку и транспортировать на рабочее место сварщика'
			INSERT INTO ptt FROM memv
		endif
		soder = 'поз. '+ALLTRIM(c_kt_sw.kornd)+ ' ' + ;
				ALLTRIM(c_kt_sw.naimd)+ ' ' + ;
				ALLTRIM(STR(c_kt_sw.nrmd,12,5))+ ' ' + ;
				ALLTRIM(STR(c_kt_sw.kol,5))
		m.buk = 'К'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
	ENDSCAN
	USE IN c_kt_sw
	soder_t='Tележка ручная' 
  	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
	soder_t='Погрузчик' 
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv	
	soder_t='Кран-балка' 
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv					
ENDIF
IF c_te.kto = 130
	soder = '1. Очистить детали в местах сварки с двух сторо от жировых загрязнений, остатков эмульсии лакокрасочных материалов и окалины' 
	DO stroka_o
	soder = '2. Зачистку провести на ширину, равную величине нахлестки сварных соединений' 
	DO stroka_o
	soder = '3. Продолжительность хранения очищенных деталей перед сваркой не более 24 час.' 
	DO stroka_o
ENDIF
IF c_te.kto = 101	
	soder='Разметить деталь под сварку согласно чертежа'
	DO stroka_o
ENDIF 		
IF c_te.kto = 9011
	soder = '1. Установить параметры режима сварки'
	DO stroka_o
	soder = '2. Сварить технологические образцы '
	DO stroka_o
	IF !EMPTY(c_te.osn) 
		soder = '3. Установить деталь в приспособление '
		DO stroka_o
	ELSE
		soder = '3. Выставить детали по разметке '
		DO stroka_o	
	endif	
	soder = '4. сварить деталь согласно чертежа  '
	DO stroka_o
	soder = 'Количество точек '+ALLTRIM(STR(c_te.ip))+', расстояние между точками '+ALLTRIM(STR(shag,6,2))
	DO stroka_o
	soder = 'Примечание: рабочую поверхность электродов зачищать шлифовальной шкуркой через 100-150 точек '
	DO stroka_o
endif
IF c_te.kto = 108
	soder = 'Удалить наружные выплески металла (при необходимости)'
	DO stroka_o
ENDIF
IF c_te.kto = 200
	soder = '1. Проверить соответствие расположения сварных точек на узле расположению, указанному на чертеже'
	DO stroka_o
	soder = '2. Проверить форму и размеры вмятин от электродов. Отпечатки сварных точек должны иметь форму окружности'
	soder = soder +' (допускается овальность не более 3:2. Глубина вмятины не должна быть более 20 % толщины детали.'
	DO stroka_o
	soder = '3. Проверить размеры сваренного узла на соответствие чертежу'
	soder = soder +' 4. Для определения качества сварки по технологической пробе образцы следует подвергнуть разрушению в тисках или других'
	soder = soder +' зажимных приспособлениях. При этом разрушение должно происходить по основному материалу или по зоне термического влияния'
	DO stroka_o	
endif
*       конец сварки
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
***************************************************************************************************
*********************	П Р О Ф И Л Ь Н А Я   Ш Л И Ф О В К А    ******************************
PROCEDURE F_prof_Slif
wait 'П Р О Ф И Л Ь Н А Я   Ш Л И Ф О В К А ' WINDOW NOWAIT 
IF INLIST(70,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
	soder =ALLT(STR(c_te.NTP))+'. '+' Шлифовать профиль '
	kuku = '  '
	IF c_te.dbk#0 or c_te.toch#0
   	KUKu=kuku + ALLTRIM(STR(c_te.dbk,6,2))+' '+allt(c_te.tocd1)+' '+ALLTRIM(c_te.tocd11) ; 
            +'; '+ALLTRIM(STR(c_te.rr1,6,2))	&&	+' '+allt(c_te.toch1)+' '+allt(toch11)
      IF !EMPTY(m.toch1)
      	DO toch1_
      endif
    
		kuku = kuku +'; '+ALLTRIM(STR(c_te.rr2,6,2))
		IF !EMPTY(m.toch2)
				DO toch2_  
		endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr3,6,2))		 
	   if !empt(m.toch3)
	   	DO toch3_ 
   	endif	 
      kuku = kuku +IIF(c_te.ug#0,'; угол '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
retu
***************************************************************************************************
*********************	К О О Р Д И Н А Т Н А Я   Ш Л И Ф О В К А    ******************************
PROCEDURE F_koord_Slif
wait 'К О О Р Д И Н А Т Н А Я   Ш Л И Ф О В К А' WINDOW NOWAIT 
IF INLIST(52,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' Шлифовать сквозные отверствия '
	kuku = ''
	IF c_te.dbk#0 or c_te.toch#0
   	KUKu=kuku +'D '+ALLTRIM(STR(c_te.dbk,6,2))
   	if !empt(m.tocd1) 
		DO tocd1_
   	endif
   	kuku = kuku +'; '+ALLTRIM(STR(c_te.rr1,6,2))
   	if !empt(m.toch1) 
   		DO toch1_		
   	endif
		kuku = kuku +'; '+ALLTRIM(STR(c_te.rr2,6,2))
	 	if !empt(m.toch2) 
			DO toch2_
   	endif
   	kuku = kuku +'; '+ALLTRIM(STR(c_te.rr3,6,2))		 
   	if !empt(m.toch3) 
   		DO toch3_
   	endif
   	kuku = kuku +IIF(c_te.ug#0,'; угол '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
		
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(53,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
	OR INLIST(54,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
	OR INLIST(55,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
	soder =ALLT(STR(c_te.NTP))+'. '+' Шлифовать сложные поверхности '
	kuku = '  '
	IF c_te.dbk#0 or c_te.toch#0
   	kuku = kuku + ALLTRIM(STR(c_te.dbk,6,2))	&&+' '+allt(c_te.tocd1)+' '+ALLTRIM(c_te.tocd11)
   	if !empt(m.tocd1) 
   		DO tocd1_		
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr1,6,2))	&&	+' '+allt(c_te.toch1)+' '+allt(toch11) 
      if !empt(m.toch1) 
   		DO toch1_	
   	endif
		kuku = kuku +'; '+ALLTRIM(STR(c_te.rr2,6,2))	&&	+'; '+ALLTRIM(c_te.toch2)+ALLTRIM(c_te.toch21)  
		if !empt(m.toch2) 
   		DO toch2_	
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr3,6,2))		&&+'; '+ALLTRIM(STR(c_te.rr2,6,2))+'; '+ALLTRIM(c_te.toch3)+ALLTRIM(c_te.toch31) 	 
	   if !empt(m.toch3)
	   	DO tosh3_ 
   	endif 
      kuku = kuku +IIF(c_te.ug#0,'; угол '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
retu
*********************	К О О Р Д И Н А Т Н О  -  Р А С Т О Ч Н Ы Е  ******************************
PROCEDURE F_k_r
wait 'К О О Р Д И Н А Т Н О  -  Р А С Т О Ч Н Ы Е' WINDOW NOWAIT 
IF INLIST(49,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' Центровать, сверлить, рассверлить, зенкеровать, развернуть отверствия D '
	kuku = '  '
	IF c_te.dbk#0 or c_te.toch#0
   	KUKu=kuku + ALLTRIM(STR(c_te.dbk,6,2))	&&	+' '+allt(c_te.tocd1)+' '+ALLTRIM(c_te.tocd11) 
   	if !empt(m.tocd1) 
   		DO tocd1_	
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr1,6,2))	&&	+' '+allt(c_te.toch1)+' '+allt(toch11) 
      if !empt(m.toch1) 
   		DO toch1_
   	endif
		kuku = kuku +'; '+ALLTRIM(STR(c_te.rr2,6,2))	&&		+'; '+ALLTRIM(c_te.toch2)+ALLTRIM(c_te.toch21) 
		if !empt(m.toch2) 
   		DO toch2_	
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr3,6,2))		 
   	if !empt(m.toch3) 
   		DO toch3_	
	   endif	&&+'; '+ALLTRIM(STR(c_te.rr2,6,2))+'; '+ALLTRIM(c_te.toch3)+ALLTRIM(c_te.toch31)  
      kuku = kuku +IIF(c_te.ug#0,'; угол '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(50,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' Центровать, сверлить, развернуть отверствия D '
	kuku = ''
	IF c_te.dbk#0 or c_te.toch#0
   	KUKu=kuku + ALLTRIM(STR(c_te.dbk,6,2))	&&+' '+allt(c_te.tocd1)+' '+ALLTRIM(c_te.tocd11)
   	if !empt(m.tocd1) 
   		DO tocd1_	
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr1,6,2))	&&	+' '+allt(c_te.toch1)+' '+allt(toch11) 
      if !empt(m.toch1) 
   		DO toch1_	
   	endif
		kuku = kuku +'; '+ALLTRIM(STR(c_te.rr2,6,2))	&& 	+'; '+ALLTRIM(c_te.toch2)+ALLTRIM(c_te.toch21)  
		if !empt(m.toch2) 
   		DO toch2_	
   	endif
   	kuku = kuku +'; '+ALLTRIM(STR(c_te.rr3,6,2))		&&	+'; '+ALLTRIM(STR(c_te.rr2,6,2))+'; '+ALLTRIM(c_te.toch3)+ALLTRIM(c_te.toch31)  	 
	   if !empt(m.toch3) 
   		DO toch3_	
   	endif
      kuku = kuku +IIF(c_te.ug#0,'; угол '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(51,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' Расточить выточки в отверствиях D '
	kuku = ''
	IF c_te.dbk#0 or c_te.toch#0
   	KUKu=kuku + ALLTRIM(STR(c_te.dbk,6,2))	&&	+' '+allt(c_te.tocd1)+' '+ALLTRIM(c_te.tocd11) 
   	if !empt(m.tocd1) 
   		DO tocd1_
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr1,6,2))	&&	+' '+allt(c_te.toch1)+' '+allt(toch11) 
      if !empt(m.toch1) 
   		DO toch1_
   	endif
		kuku = kuku +'; '+ALLTRIM(STR(c_te.rr2,6,2))	&&	+'; '+ALLTRIM(c_te.toch2)+ALLTRIM(c_te.toch21)  
		if !empt(m.toch2) 
   		DO toch2_
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr3,6,2))		&&	+'; '+ALLTRIM(STR(c_te.rr2,6,2))+'; '+ALLTRIM(c_te.toch3)+ALLTRIM(c_te.toch31)	 
	   if !empt(m.toch3) 
   		DO toch3_	
   	endif  
      kuku = kuku +IIF(c_te.ug#0,'; угол '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(11,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' Разметитьпараллельные прямые и окружности '
	kuku = ''
	IF c_te.dbk#0 or c_te.toch#0
   	KUKu=kuku + ALLTRIM(STR(c_te.dbk,6,2))	&&	+' '+allt(c_te.tocd1)+' '+ALLTRIM(c_te.tocd11)
   	if !empt(m.tocd1) 
   		DO tocd1_	
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr1,6,2))	&&	+' '+allt(c_te.toch1)+' '+allt(toch11) 
      if !empt(m.toch1) 
   		DO toch1_	
   	endif
		kuku = kuku +'; '+ALLTRIM(STR(c_te.rr2,6,2))	&&	+'; '+ALLTRIM(c_te.toch2)+ALLTRIM(c_te.toch21)  
		if !empt(m.toch2) 
   		do toch2_	
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr3,6,2))		&&+'; '+ALLTRIM(STR(c_te.rr2,6,2))+'; '+ALLTRIM(c_te.toch3)+ALLTRIM(c_te.toch31) 	 
	   if !empt(m.toch3) 
   		DO toch3_	
	   endif	 
      kuku = kuku +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(12,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' Разметить прямые, расположенные под  углом '
	kuku = ''
	IF c_te.dbk#0 or c_te.toch#0
   	KUKu=kuku + ALLTRIM(STR(c_te.dbk,6,2))	&&	+' '+allt(c_te.tocd1)+' '+ALLTRIM(c_te.tocd11)
   	if !empt(m.tocd1) 
   		DO tocd1_	
   	endif
      kuku = kuk +'; '+ALLTRIM(STR(c_te.rr1,6,2))	&&	+' '+allt(c_te.toch1)+' '+allt(toch11) 
      if !empt(m.toch1) 
   		DO toch1_	
   	endif
		kuku = kuku +'; '+ALLTRIM(STR(c_te.rr2,6,2))	&&	+'; '+ALLTRIM(c_te.toch2)+ALLTRIM(c_te.toch21)  
		if !empt(m.toch2) 
   		DO toch2_
   	endif
      kuku = kuku +'; '+ALLTRIM(STR(c_te.rr3,6,2))		&&	+'; '+ALLTRIM(STR(c_te.rr2,6,2))+'; '+ALLTRIM(c_te.toch3)+ALLTRIM(c_te.toch31)	 
	   if !empt(m.toch3) 
   		DO toch3_
	   endif	  
      kuku = kuku +IIF(c_te.ug#0,'; угол '+ALLTRIM(STR(c_te.ug,3)),'')  
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(13,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' Разметить криволинейный контур '
	DO stroka_o 
endif
RETU
***************************************************************************************************
***************************************************************************************************
*********************	О П Т И К О - Ш Л И Ф О В А Л Ь Н Ы Е  ************************************
PROCEDURE F_O_S
wait 'О П Т И К О - Ш Л И Ф О В А Л Ь Н Ы Е' WINDOW NOWAIT 

soder =ALLT(STR(c_te.NTP))+'. '+' Шлифовать '+ALLTRIM(STR(c_te.ip,2))+' поверхности, выдерживая размеры:'
kuku = ''
IF c_te.dbk#0 or c_te.toch#0
   KUKA=kuka + ALLTRIM(STR(c_te.dbk,6,2))	&&	+' '+allt(c_te.tocd1)+' '+ALLTRIM(c_te.tocd11) 
   if !empt(m.tocd1) 
		DO tocd1_	
  	endif
   kuku = kuku +'; '+ALLTRIM(STR(c_te.rr1,6,2))	&&	+' '+allt(c_te.toch1)+' '+allt(toch11) if !empt(m.toch1) 
	IF !EMPTY(m.toch1)
		DO toch1_
	endif	
	kuku = kuku +'; '+ALLTRIM(STR(c_te.rr2,6,2))	   
	if !empt(m.toch2) 
  		DO toch2_		
  	endif
   kuku = kuku +'; '+ALLTRIM(STR(c_te.rr3,6,2))		&&	+'; '+ALLTRIM(STR(c_te.rr2,6,2))+'; '+ALLTRIM(c_te.toch3)+ALLTRIM(c_te.toch31)	 
   if !empt(m.toch3) 
   	DO toch3_f	
   endif	  
   kuku = kuku +IIF(c_te.ug#0,'; угол '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
endif
soder = soder + kuka
DO stroka_o 
RETU
***************************************************************************************************
*********************	Т Е Р М И Ч К А ***********************************************************
PROCEDURE TERM
IF INLIST(c_te.kto, 5010, 5050, 5060, 5100)
	SELECT * FROM DOSP WHERE vid=38 AND kod = te_kto INTO CURSOR c_dosp7
	IF RECCOUNT() > 0
		SODER = ALLTRIM(c_dosp7.sim)
		soder = soder + 'HRC твердостью '+ALLTRIM(STR(c_te.tvr,4))
		soder = soder + IIF(c_te.glub>0, ' глубиной '+ALLTRIM(STR(c_te.glub)),'')
		do stroka_o
	ENDIF
	USE IN c_dosp7
	SELECT kornd,nrmd, poznd,d_u,KODM FROM KT WHERE ;
				poznd =c_te.poznd ;
				AND d_u=5 ;
				ORDER BY kornd ;
				INTO CURSOR c_kt_kornd 
	soder = ''
	SCAN
		SELECT * FROM mater WHERE kodm = c_kt_kornd.kodm INTO CURSOR c_mat
*!*			WAIT WINDOW 'MATER'
*!*			brow
		IF RECCOUNT() > 0
			ma = ALLTRIM(c_mat.naim)
		ELSE
			ma = ''
		ENDIF
		soder = ma+ ' ' + ;
				ALLTRIM(c_MAT.ei)+ ' ' + ;
				ALLTRIM(STR(c_kt_kornd.nrmd,12,5))
		m.buk = 'К'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
		USE IN c_mat
	ENDSCAN
	USE IN c_kt_kornd
ENDIF
RETURN 

***************************************************************************************************
***************	К О Н Е Ц   Т Е Р М И Ч К А *****************************************************

***************	Г А Л Ь В А Н И К А *************************************************************
PROCEDURE GALWAN
wait ' Г А Л Ь В А Н И К А  ' WINDOW NOWAIT 
soder = ''
IF INLIST(c_te.kto, 7100, 7135, 7141, 7172, 7174)
	SELECT * FROM DOSP WHERE vid=7 AND kod = c_te.kto INTO CURSOR c_dosp7
	IF RECCOUNT() > 0
		SODER = ALLTRIM(c_dosp7.sim)
		soder = soder + 'площадью '+ALLTRIM(STR(c_te.sp,8,4))+'кв.м'
		soder = soder + IIF(c_te.glub>0, ' толщиной '+ALLTRIM(STR(c_te.glub)),'')
		do stroka_o
	ENDIF
	USE IN c_dosp7
	SELECT DISTINCT KODM,poznd,d_u FROM KT WHERE ;
				poznd =c_te.poznd ;
				AND d_u=5 ;
				INTO CURSOR c_kt_kornd 
*!*		brow
	soder = ''
	SCAN
		SELECT * FROM mater WHERE kodm = c_kt_kornd.kodm INTO CURSOR c_mat
*!*			WAIT WINDOW 'MATER'
*!*			brow
		IF RECCOUNT() > 0
			ma = c_mat.naim
		ELSE
			ma = ''
		ENDIF
		soder = ma+ SPACE(35) + ;
				ALLTRIM(c_MAT.ei)+ SPACE(10) + ;
				ALLTRIM(STR(c_kt_kornd.nrmd,12,5))
		m.buk = 'К'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
		USE IN c_mat
	ENDSCAN
	USE IN c_kt_kornd
ENDIF
RETURN 
***********************************КОНЕЦ ГАЛЬВАНИКИ************************************************
***************************************************************************************************
*************************************** Ш Т А М П О В К А  ****************************************
PROCEDURE SHTAMP
WAIT WINDOW 'ШТАМПОВКА' nowait 
SELECT * FROM KTU WHERE ttp=LEFT(c_te.kttp,11) AND kof =1 ORDER BY pri INTO CURSOR c_ktu 
IF RECCOUNT() > 0
	SCAN
		IF INLIST(NPP,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
			soder = c_ktu.dop
			m.buk = 'О'
			m.ss  = soder
			INSERT INTO ptt FROM memv
		ENDIF
	ENDSCAN
ENDIF
USE IN c_ktu
RETURN 
***************************************************************************************************
**************************************** С Л Е С А Р К А  *****************************************
PROCEDURE slesar
wait 'С Л Е С А Р К А  ' window nowait 
SELECT * FROM KTU WHERE ttp=LEFT(c_te.kttp,11) ;
		AND kof=1 ;
		and INLIST(NPP, c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		ORDER BY pri INTO CURSOR c_ktu 
*!*	wait window ;
*!*	' us1='+str(c_te.us1,2)+' us2='+str(c_te.us2,2)+' us3'+str(c_te.us3,2)+' us4='+str(c_te.us4,2)+' us5='+str(c_te.us5,2)+ ;
*!*	' us6='+str(c_te.us6,2)+' us7='+str(c_te.us7,2)+' us8='+str(c_te.us8,2)
*!*	brow
IF RECCOUNT() > 0
	SCAN
		soder = c_ktu.dop
		m.buk = 'О'
		m.ss  = soder
		INSERT INTO ptt FROM memv
	ENDSCAN
ENDIF
USE IN c_ktu
retu
***************************************************************************************************
**************************************** В А Л Ь Ц О В К А*****************************************
PROCEDURE valz
wait 'В А Л Ь Ц О В К А  ' window nowait 
SELECT * FROM KTU WHERE ttp=LEFT(c_te.kttp,11) AND kof=2 ORDER BY pri INTO CURSOR c_ktu 
IF RECCOUNT() > 0
	SCAN
		IF INLIST(NPP,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
			soder = c_ktu.dop
			m.buk = 'О'
			m.ss  = soder
			IF !EMPTY(soder)
				INSERT INTO ptt FROM memv
			endif
		ENDIF
	ENDSCAN
ENDIF
USE IN c_ktu
RETURN
***************************************************************************************************
**************************************** С Л Е С А Р К А  П Р О Ч А Я *****************************
PROCEDURE slesar_PR
wait 'С Л Е С А Р К А  П Р О Ч А Я ' WINDOW  NOWAIT
IF te_vid=46
	IF INLIST(90,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Зачистить заготовку от шлака'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(148,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Зачистить фасонную заготовку от шлака'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(91,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(92,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Править заготовку вручную по плоскости'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(102,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Править заготовку вручную по плоскости и на ребро'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(93,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Править полосу по плоскости и на ребро вручную'
		INSERT INTO ptt FROM memv
	ENDIF
	 IF INLIST(94,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Править фасонный прокат на правильном прессе'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(95,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Править фасонный прокат вручную'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(96,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Править листовую заготовку по плоскости на прессе'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(97,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Зачистить кромки заготовки от грата вручную'
		INSERT INTO ptt FROM memv
	ENDIF
ENDIF
IF te_vid=42
	IF INLIST(80,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(81,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(82,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = 'О'
		m.ss  = 'Промыть деталь(узел) от загрязнений в ванне'
		INSERT INTO ptt FROM memv
	endif	
ENDIF
IF te_vid=48
	IF INLIST(123,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(124,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(125,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = 'О'
		m.ss  = 'Шлифовать поверхность(и) детали, выдерживая шероховатьсть Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	endif	
	IF INLIST(129,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(130,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(131,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = 'О'
		m.ss  = 'Матировать поверхность(и) детали, выдерживая шероховатьсть Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	endif	
	IF INLIST(145,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(146,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(147,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = 'О'
		m.ss  = 'Полировать поверхность(и) детали, выдерживая шероховатьсть Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(134,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(135,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(136,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(137,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = 'О'
		m.ss  = 'Глянцевать поверхность(и) детали, выдерживая шероховатьсть Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	endif	
	IF INLIST(109,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(110,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)  
		m.buk = 'О'
		m.ss  = 'Крацевать поверхность(и) детали, выдерживая шероховатьсть Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	ENDIF	
ENDIF
IF te_vid = 44
	IF INLIST(90,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Галтовать детали сухим способом до полного удаления заусенок, грата, шлака'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(144,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Галтовать детали мокрым способом до полного удаления заусенок, грата, шлака'
		INSERT INTO ptt FROM memv
	endif
ENDIF
IF te_vid = 43
	IF INLIST(83,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Установить маркировальные бирки пайкой'
		INSERT INTO ptt FROM memv
	endif
	IF INLIST(83,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Установить маркировальные бирки без пайки'
		INSERT INTO ptt FROM memv
	endif		
ENDIF
IF te_vid = 47
	IF INLIST(101,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(106,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(107,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		 OR ;
		INLIST(108,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)  
		m.buk = 'О'
		m.ss  = 'Раскроить материал, выдерживая размеры '+ALLTRIM(STR(c_te.rozma,6,1))+'x'+ALLTRIM(STR(c_te.rozmb,6,1))
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(111,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(112,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(138,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		 OR ;
		INLIST(139,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)  
		m.buk = 'О'
		m.ss  = 'Уложить упаковочные докуметнты в пакет(тару)'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(141,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Комплектовать детали для упаковки'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(142,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		or INLIST(143,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = 'О'
		m.ss  = 'Оббить упаковочные ящики досками'
		INSERT INTO ptt FROM memv
	ENDIF
ENDIF
retu
************************************  КОНЕЦ С Л Е С А Р К А  П Р О Ч А Я **************************
***************************************************************************************************
**************************************** О К Р А С К А  *******************************************
PROCEDURE OKRASKA
wait 'О К Р А С К А  ' WINDOW  NOWAIT
IF INLIST(c_te.kto,7311,7328,7360,7361,7362,7363,7378,7386,7410)
*!*		WAIT WINDOW ALLTRIM(C_TE.KTTP)
	SELECT * FROM DOSP WHERE VID=9 AND SIM=C_TE.KTTP INTO CURSOR C_9
	IF RECCOUNT()>0
		IM9=ALLTRIM(IM)
	ELSE
		IM9=''
	ENDIF
	USE IN C_9
	SELECT SIM FROM DOSP WHERE vid = 40 AND kod = c_te.cw INTO curs  c_cw
	IF rec()> 0
		zwet = ALLTRIM(c_cw.sim)
	ELSE
		zwet = ''
	ENDIF
	USE IN c_cw
	soder = 'окрасить деталь(узел) краской '+' '+IM9+' площадью '+ALLTRIM(STR(C_TE.SP,8,4))+' '+zwet+' цветом'
	m.buk = 'О'
	m.ss  = soder
	INSERT INTO ptt FROM memv
	SELECT kornd,nrmd, poznd,d_u,KODM FROM KT WHERE ;
				poznd =c_te.poznd ;
				AND d_u=5 ;
				ORDER BY kornd ;
				INTO CURSOR c_kt_kornd 
	soder = ''
	SCAN
		SELECT * FROM mater WHERE kodm = c_kt_kornd.kodm INTO CURSOR c_mat
*!*			WAIT WINDOW 'MATER'
*!*			brow
		IF RECCOUNT() > 0
			ma = ALLTRIM(c_mat.naim)
		ELSE
			ma = ''
		ENDIF
		soder = ma+ ' ' + ;
				ALLTRIM(c_MAT.ei)+ ' ' + ;
				ALLTRIM(STR(c_kt_kornd.nrmd,12,5))
		m.buk = 'К'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
		USE IN c_mat
	ENDSCAN
	USE IN c_kt_kornd
endif
retu

*********************************** КОНЕЦ  О К Р А С К А  *****************************************
***************************************************************************************************
********************************** З А Г О Т О В К А **********************************************
PROCEDURE ZAGOT
wait 'З А Г О Т О В К А  ' WINDOW NOWAIT 
soder = ' '
IF c_te.nto = 5
	IF c_kt.kolz>1
		soder= 'Разметить групповую заготовку на '+ALLTRIM(STR(c_kt.kolz))+' деталей, выдерживая размеры '+ALLTRIM(STR(c_kt.rozma,6,1))+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1))+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')+'с учетом '+c_kt.primech
		do stroka_o
	ELSE
		soder= 'Разметить заготовку, выдерживая размеры '+ALLTRIM(STR(c_kt.rozma,6,1))+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1))+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')+'с учетом '+c_kt.primech
		do stroka_o
	endif	
	
*!*		wait window 'do stroka_o 5'
	soder_t = 'Рулетка ГОСТ 7502; штангенциркуль 250 ГОСТ 166, угломер УН - 180 ГОСТ 5378-66 '
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
	soder_t = 'Кран-балка с электротельфером, рукавицы тип А ГОСТ 12.4.010-075'
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
ENDIF

IF c_te.nto = 10
	IF c_kt.kolz>1
		soder= 'Отрезать групповую заготовку на '+ALLTRIM(STR(c_kt.kolz))+' деталей, выдерживая размеры '+ALLTRIM(STR(c_kt.rozma,6,1))+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1))+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')
		do stroka_o
	ELSE
		soder= 'Отрезать заготовку, выдерживая размеры '+ALLTRIM(STR(c_kt.rozma,6,1))+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1))+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')
		do stroka_o
	endif	
	
	soder_t = 'Рулетка ГОСТ 7502; штангенциркуль 250 ГОСТ 166, угломер УН - 180 ГОСТ 5378-66 '
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
	soder_t = 'Кран-балка с электротельфером, рукавицы тип А ГОСТ 12.4.010-075'
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
endif
IF c_te.nto = 15
	soder= 'Контролировать заготовку 5 % от партии, выдерживая размеры ' ;
		+ALLTRIM(STR(c_kt.rozma,6,1)) ;
		+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1)) ;
		+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')
	do stroka_o
	soder_t = 'Рулетка ГОСТ 7502; штангенциркуль 250 ГОСТ 166, угломер УН - 180 ГОСТ 5378-66 '
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
ENDIF
IF c_te.nto = 20
	soder= 'Переместить заготовки по технологическому маршруту '
	do stroka_o
	soder_t = 'Кран-балка с электротельфером, погрузчик, рукавицы тип А ГОСТ 12.4.010-075'
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
ENDIF
RETURN 
*********************************** КОНЕЦ З А Г О Т О В К А *************************************
***************************************************************************************************
********************************** Т О К А Р Н Ы Е ************************************************
PROCEDURE F_TOK_VINT
wait ' Т О К А Р Н Ы Е  ' WINDOW  NOWAIT 
soder = ''
IF m.ntp=1
   sele * FROM DOSP WHERE vid=31 and kod=c_te.kku  and US=c_te.vid INTO CURS C_DOSP31
	if RECC()>0
      SODER=ALLTRIM(im)+' '+ALLTRIM(SIM)
      do stroka_o
   endif   
      
   use in C_DOSP31
ENDIF
soder = ''
if m.kko=0 or m.kko=12 AND m.dbk=0
else
	sele * from pt where vid=c_te.vid and kko=m.kko into curs c_pt
   if RECCOUNT() > 0
  	   soder = allt(im)
 	endif
	use in c_pt 
ENDIF
soder = ALLT(STR(M.NTP))+'. '+soder 
do stroka_o

IF m.kko = 1 OR m.kko = 12 
*!*		soder = ' Ф '+allt(str(m.d,6,2))+'  до Ф '+allt(str(m.dbk,6,2))+' глубиной '+ALLTRIM(STR(m.ds,6,2))
*!*		do stroka_o
	soder='выдерживая размеры: Ф'+ALLTRIM(STR(m.dbk,6,2))
	kuku=''
	if !empt(m.tocd1) 
		if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
			or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
			kuku = kuku +'+-'+allt(m.tocd1)
		else
			kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
		endif		
	ENDIF
	kuku = kuku + '; l=' +ALLTRIM(STR(m.ds,6,2))
	if m.sh#0
	   if m.sh=>10
	     	kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
	  	else
			kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
	   endif
	ENDIF
	kuku = kuku +IIF(m.ug>0,'; У='+ALLTRIM(STR(m.ug)),'') ;
					+IIF(m.rad>0,'; r='+ALLTRIM(STR(m.rad,5,1)),'')
	soder = soder + kuku
	do stroka_o
ENDIF
IF m.kko = 4 OR m.kko = 9
*!*		soder = ' Ф '+allt(str(m.d,6,2))+'  до Ф '+allt(str(m.dbk,6,2))+' на длину '+ALLTRIM(STR(m.ds,6,2))
*!*		do stroka_o
	soder='выдерживаяая размеры: Ф'+ALLTRIM(STR(m.dbk,6,2))
	kuku=''
	if !empt(m.tocd1) 
		if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
			or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
			kuku = kuku +'+-'+allt(m.tocd1)
		else
			kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
		endif		
	ENDIF
	kuku = kuku + ', l=' + ALLTRIM(STR(m.ds,6,2))
	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
			or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256     
			kuku = kuku +'+-'+allt(m.toch1)
	else
			kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
	endif
	if m.sh#0
	   if m.sh=>10
	     	kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
	  	else
			kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
	   endif
	ENDIF
	kuku = kuku +IIF(m.ug>0,'; У='+ALLTRIM(STR(m.ug)),'') ;
					+IIF(m.rad>0,'; r='+ALLTRIM(STR(m.rad,5,1)),'')
	soder = soder + kuku
	do stroka_o				
ENDIF
if m.kko = 6 
	kuku = ''
	if !empt(m.tocd1)
		kuku = kuku +ALLTRIM(STR(m.tocd1,6,2))
		if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
			or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256     
			kuku = kuku +'+-'+allt(m.toch1)
		else
			kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
		endif
	endif
	kuku = ''
	if m.sh#0
	   if m.sh=>10
	     	kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
	  	else
			kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
	   endif
	ENDIF
	soder = soder + kuku
	do stroka_o
ENDIF

IF m.kko = 7 or m.kko = 8
	soder='выдерживая размеры: Ф '+allt(str(m.d,6,2))
	if !empt(m.tocd1) 
		if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
			or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
			kuku = kuku +'+-'+allt(m.tocd1)
		else
			kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
		endif		
	ENDIF
	kuku = ''
	kuku = kuku +IIF(m.ug>0,'; У='+ALLTRIM(STR(m.ug)),'') ;
					+IIF(m.rad>0,'; r='+ALLTRIM(STR(m.rad,5,1)),'')  
   if m.sh#0
	  	if m.sh=>10
    		kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
	  	else
			kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
	  	endif
	ENDIF      	
	do stroka_o
ENDIF

IF m.kko > 15 and  m.kko <20
*!*		soder = ' Ф '+allt(str(m.d,6,2))+'  до Ф '+allt(str(m.dbk,6,2))+' на длину '+ALLTRIM(STR(m.ds,6,2))
*!*		do stroka_o
	soder='выдерживаяая размеры: Ф'+ALLTRIM(STR(m.dbk,6,2))
	kuku=''
	if !empt(m.tocd1) 
		if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
			or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
			kuku = kuku +'+-'+allt(m.tocd1)
		else
			kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
		endif		
	ENDIF
	kuku = kuku + ALLTRIM(STR(m.ds,6,2))
	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
			or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256     
			kuku = kuku +'+-'+allt(m.toch1)
		else
			kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
	if m.sh#0
	   if m.sh=>10
	     	kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
	  	else
			kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
	   endif
	ENDIF
	do stroka_o				
ENDIF

IF m.kko > 19 AND m.kko < 24
	soder = ALLTRIM(m.ip,2)+' паз(ы) выдерживая размеры: Ф'+ALLTRIM(STR(m.dbk,6,2))
	kuku = ''
	if !empt(m.tocd1) 
		if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
			or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
			kuku = kuku +'+-'+allt(m.tocd1)
		else
			kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
		endif		
	ENDIF
	kuku = kuku +'; в='+ ALLTRIM(STR(m.ds,6,2))
	f m.sh#0
	  	if m.sh=>10
    		kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
	  	else
			kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
	  	endif
	ENDIF
	kuku = kuku +IIF(m.ug>0,'; У='+ALLTRIM(STR(m.ug)),'') ;
					+IIF(m.rad>0,'; r='+ALLTRIM(STR(m.rad,5,1)),'')
	soder = soder + kuku
	do stroka_o
ENDIF
IF m.kko = 24 OR m.kko = 25
	soder = ' M '+allt(str(m.d,6,2))+' глубиной '+ALLTRIM(STR(m.ds,6,2))
	do stroka_o
ENDIF
IF m.kko = 26
	soder='выдерживая размеры: '
	kuku = ''
	kuku = kuku +IIF(m.ug>0,'; У='+ALLTRIM(STR(m.ug)),'') ;
					+IIF(m.rad>0,'; r='+ALLTRIM(STR(m.rad,5,1)),'')  
   if m.sh#0
	  	if m.sh=>10
    		kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
	  	else
			kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
	  	endif
	ENDIF      	
	do stroka_o
ENDIF
IF m.kko > 33 and m.kko < 40
	sh_ = STR(m.shag,4,1)
	soder = ' G '+subs(sh_,1,1)+' '+subs(sh_,2,1)+'\'+subs(sh_,4,1)+'"'+'  глубиной '+ALLTRIM(STR(m.ds,6,2))
	do stroka_o
endif
RETURN 

*********************************** КОНЕЦ ТОКАРНО-ВИНТОРЕЗНОЙ *************************************
***************************************************************************************************
***************************************************************************************************
********************************** С В Е Р Л О В К А **********************************************
PROCEDURE F_SWERL
wait ' С В Е Р Л О В К А  ' WINDOW NOWAIT 
soder = ''
IF m.ntp=1
   sele * FROM DOSP WHERE vid=31 and kod=c_te.kko  and US=c_te.vid INTO CURS C_DOSP31
	if RECC()>0
      SODER=ALLTRIM(im)+' '+ALLTRIM(SIM)
      do stroka_o
   endif   
      
   use in C_DOSP31
ENDIF
soder = ''
if m.kko#0
	sele * from pt where vid=c_te.vid and kko=m.kko into curs c_pt
   if RECCOUNT() > 0
  	   soder = allt(im)
*!*	  	   wait window 'SWERLOWKA '+SODER
 	endif
	use in c_pt 
ENDIF
soder =ALLT(STR(M.NTP))+'. '+soder
IF m.kko =1
	kuku = ''
	soder =soder +' '+ALLTRIM(STR(ip))+' отв.' ;
		+ 'выдерживая размеры: Ф'+allt(str(m.D,6,2))
	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
		or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256      
		kuku = kuku +'+-'+allt(m.toch1)
	else
		kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
	ENDIF
	kuku = kuku +'; '+allt(str(m.ds,6,2))
   if c_te.sh#0
	   if m.sh=>10
	     	kuku = kuku+'; Rz='+allt(str(m.sh,7,3))
	  	else
			kuku = kuku+'; Ra='+allt(str(m.sh,7,3))
	   endif
	endif	
   soder = soder + kuku
   DO stroka_o 				
endif
IF m.kko = 2
	kuku = ''
	soder =soder ;
		+' '+ALLTRIM(STR(ip))+' отв. до ' ;
		+ 'выдерживая размеры: Ф'+allt(str(m.D,6,2))
	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
		or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256      
		kuku = kuku +'+-'+allt(m.toch1)
	else
		kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
	ENDIF
	kuku = kuku +'; '+allt(str(m.ds,6,2))
   
	if c_te.sh#0
	   if m.sh=>10
	     	kuku = kuku+'; Rz '+allt(str(m.sh,7,3))
	  	else
			kuku = kuku+'; Ra '+allt(str(m.sh,7,3))
	   endif
	   
	ENDIF
	soder = soder + kuku
   DO stroka_o 	
ENDIF
IF INLIST(m.kko, 3,11,12,13,14)
	kuku = ''
	soder =soder ;
		+' '+ALLTRIM(STR(ip))+' отв.' ;
		+ 'выдерживая размеры: Ф'+allt(str(m.D,6,2))
	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
		or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256      
		kuku = kuku +'+-'+allt(m.toch1)
	else
		kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
	ENDIF
	kuku = kuku +'; '+allt(str(m.ds,6,2))
   
	if c_te.sh#0
	   if m.sh=>10
	     	kuku = kuku+'; Rz '+allt(str(m.sh,7,3))
	  	else
			kuku = kuku+'; Ra '+allt(str(m.sh,7,3))
	   endif
	   
	ENDIF
	soder = soder + kuku
   DO stroka_o 	
ENDIF
IF m.kko = 5
	kuku = ''
	soder =soder + ' '+ALLTRIM(STR(ip))+' отв. согласно разметки'
	do stroka_o
endif
IF INLIST(m.kko, 6,7,8) 
	kuku = ''
	soder =soder ;
		+' '+ALLTRIM(STR(ip))+' отв.' ;
		+ 'выдерживая размеры: Ф'+allt(str(m.D,6,2))
	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
		or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256      
		kuku = kuku +'+-'+allt(m.toch1)
	else
		kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
	ENDIF
	
	if c_te.sh#0
	   if m.sh=>10
	     	kuku = kuku+'; Rz '+allt(str(m.sh,7,3))
	  	else
			kuku = kuku+'; Ra '+allt(str(m.sh,7,3))
	   endif
	   
	ENDIF
	soder = soder + kuku
   DO stroka_o 	
endif
IF INLIST(m.kko, 9,10) 
	kuku = ''
	soder =soder ;
		+' '+ALLTRIM(STR(ip))+' отв.' ;
		+ 'выдерживая размеры: S='+allt(str(m.shag,6,2)) ;
		+'; l='+ALLTRIM(str(m.ds,7,1)) 
	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
		or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256      
		kuku = kuku +'+-'+allt(m.toch1)
	else
		kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
	ENDIF
	
	if c_te.sh#0
	   if m.sh=>10
	     	kuku = kuku+'; Rz '+allt(str(m.sh,7,3))
	  	else
			kuku = kuku+'; Ra '+allt(str(m.sh,7,3))
	   endif
	ENDIF
	soder = soder + kuku
   DO stroka_o 	
endif
IF m.kko = 15
	soder =soder + ' отв. согласно требований чертежа'
	do stroka_o
endif
RETURN 
*********************************** КОНЕЦ С В Е Р Л О В К И   *************************************
***************************************************************************************************
*********************************** Ф Р Е З Е Р Н Ы Е *********************************************
PROCEDURE F_FREZA
wait 'Ф Р Е З Е Р Н Ы Е  ' WINDOW NOWAIT 
soder = ''
IF m.ntp=1
   sele * FROM DOSP WHERE vid=31  and kod=c_te.kku and US=c_te.vid INTO CURS C_DOSP31
	if RECC()>0
      SODER=ALLTRIM(im)+' '+ALLTRIM(SIM)
      do stroka_o
   endif   
   use in C_DOSP31
ENDIF
soder = ''
*WAIT WINDOW 'kko='+STR(m.kko)
if m.kko#0
   sele * from pt where vid=c_te.vid and kko=m.kko into curs c_pt
   if RECCOUNT() > 0
	   soder = allt(im)
   endif
   use in c_pt 
ENDIF
soder =ALLT(STR(M.NTP))+'. '+soder
do stroka_o
soder=''
kuku='выдерживая размеры:'
*!*	IF  m.toch#0 OR m.RR1#0 OR rr2<>0
*!*	   kuku=kuku+IIF(m.toch#0,allt(STR(m.toch,6,1)),'') 	&&	+IIF(!empt(m.toCH1),' +'+allt(m.toCH1),'')+IIF(!empt(m.toCH11),' '+allt(m.toCH11),'') 
*!*	   if !empt(m.toch1) 
*!*	   	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
*!*	   		or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256      
*!*	   		kuku = kuku +'+-'+allt(m.toch1)+';'
*!*	   	else
*!*	   		kuku = kuku +' +'+allt(m.toch1)+iif(empty(m.toch11),+'',+' -'+ALLTRIM(m.toch11))+';' 
*!*	   	endif		
*!*	  	endif
*!*	   kuku=kuku+IIF(m.rr1#0,' '+allt(STR(m.rr1,6,1)),'')	&&+IIF(!empt(m.toCD1),'+'+allt(m.toCd1),'')+IIF(!empt(m.toCd11),' '+allt(m.toCd11),'')
  	if !empt(m.rr1)
  		kuku = kuku +' '+allt(STR(m.rr1,6,1)) 
   	if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
   		or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256      
   		kuku = kuku +'+-'+allt(m.tocd1)+';'
   	else
   		kuku = kuku +' +'+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' -'+ALLTRIM(m.tocd11))+';' 
   	endif		
   endif         
   kuku=kuku+IIF(m.rr2#0,allt(STR(m.rr2,6,1)),'')
   if asc(left(m.toch2,1))>64 and asc(left(m.toch2,1))<91 or asc(left(m.toch2,1))>96 and asc(left(m.toch2,1))<123 ;
   		or asc(left(m.toch2,1))>191 and asc(left(m.toch2,1))<256      
   		kuku = kuku +'+-'+allt(m.toch2)+';'
   	else
   		kuku = kuku +' +'+allt(m.toch2)+iif(empty(m.toch21),+'',+' -'+ALLTRIM(m.toch21))+';' 
   	ENDIF
   endif	
   if !empt(m.toch) 
   	kuku = kuku +' '+allt(STR(m.toch,6,1)) 
   	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
   		or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256      
   		kuku = kuku +'+-'+allt(m.toch1)+';'
   	else
   		kuku = kuku +' +'+allt(m.toch1)+iif(empty(m.toch11),+'',+' -'+ALLTRIM(m.toch11))+';' 
   	endif		
  	endif	
*!*	*!*	            +IIF(!empt(m.toCH2),' +'+allt(m.toCH2),'');
*!*	*!*	            +IIF(!empt(m.toCH21),' '+allt(m.toCH21),'') 
*!*	endif	   	   
IF m.rad#0 or m.ug#0
	kuku=kuku+IIF(m.ug#0,'; угол '+ALLTRIM(STR(m.ug,3)),'')+IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
	         +IIF(m.shag#0, '; s='+ALLTRIM(STR(m.shag,6,2)), '')
endif	   	   
if m.sh#0
   if m.sh=>10
      kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
   else
      kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
   endif
endif
soder=kuku
do stroka_o
RETURN 
************************************КОНЕЦ ФРЕЗЕРНЫХ************************************************
 
***************************************************************************************************
*********************************** К Р У Г ЛО - Ш Л И Ф О В А Л Ь Н Ы Е **************************
PROCEDURE  F_K_S

WAIT WINDOW ' К Р У Г ЛО - Ш Л И Ф О В А Л Ь Н Ы Е' NOWAIT 
	 
soder = ''
IF m.ntp=1
   sele * FROM DOSP WHERE vid=31 and kod=c_te.kku  and US=c_te.vid INTO CURS C_DOSP31
	if RECC()>0
      SODER=ALLTRIM(im)+' '+ALLTRIM(SIM)
      do stroka_o
   endif   
      
   use in C_DOSP31
ENDIF
soder = ''
*WAIT WINDOW 'vid='+STR(c_te.vid)+' kko='+STR(m.kko)
if m.kko#0
	sele * from pt where vid=c_te.vid and kko=m.kko into curs c_pt
*!*		brow
   if RECCOUNT() > 0
  		   soder = allt(im)
   endif
	use in c_pt 
ENDIF
soder =ALLT(STR(M.NTP))+'. '+soder
*!*	KUK=SODER
*wait 'm.kto='+str(m.kto,4)+' m.kttp='+m.kttp wind
if m.dbk#0
   soder=soder+' поверхность ' 
endif
do stroka_o
soder='выдерживая размеры Ф'
kuku=''
IF m.dbk#0
	kuku=kuku+IIF(m.dbk#0,'; '+allt(STR(m.dbk,6,1)),'') 		&&	+IIF(!empt(m.toCD1),'+'+allt(m.toCd1),'')+IIF(!empt(m.toCd11),' '+allt(m.toCd11),'')
	if !empt(m.tocd1) 
   	if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
   		or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256    
   		kuku = kuku +'+-'+allt(m.tocd1)
	  	else
   		kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
   	endif	
	endif
   kuku=kuku+IIF(m.ds#0,'; '+allt(STR(m.ds,6,1)),'');
            +IIF(!empt(m.toch3),'+'+allt(m.toch3),'');
            +IIF(!empt(m.toch31),' '+allt(m.toch31),'')
endif	                  
if m.sh#0
   if m.sh=>10
      kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
   else
		kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
   endif
endif
soder=SODER+kuku
do stroka_o
RETURN 
***************************************************************************************************
*********************************** КОНЕЦ К Р У Г Л О - Ш Л И Ф О В А Л Ь Н Ы Е *******************
***************************************************************************************************
*********************************** П Л О С К О - Ш Л И Ф О В А Л Ь Н Ы Е *************************
***************************************************************************************************
PROCEDURE F_P_S

WAIT WINDOW ' П Л О С К О - Ш Л И Ф О В А Л Ь Н Ы Е ' nowait

soder = ''
IF m.ntp=1
   sele * FROM DOSP WHERE vid=31 and kod=c_te.kku  and US=c_te.vid INTO CURS C_DOSP31
	if RECC()>0
      SODER=ALLTRIM(im)+' '+ALLTRIM(SIM)
      do stroka_o
   endif   
      
   use in C_DOSP31
ENDIF
soder = ''
*WAIT WINDOW 'vid='+STR(c_te.vid)+' kko='+STR(m.kko)
if m.kko#0
	sele * from pt where vid=c_te.vid and kko=m.kko into curs c_pt
*!*		brow
   if RECCOUNT() > 0
  		   soder = allt(im)
   endif
	use in c_pt 
ENDIF
soder =ALLT(STR(M.NTP))+'. '+soder
KUK=SODER
*wait 'm.kto='+str(m.kto,4)+' m.kttp='+m.kttp wind
*!*	if m.dbk#0	   	
			KUK=''
	      if m.kKo#0
	         sele * from pt where vid=5 and kko=m.kko into curs c_pt
	         go top
	         if .not.eof()
	      	   msim=allt(im)
	   	   else
		         msim=''
	         endif
	         use in c_pt 
	      ENDIF
	      IF m.kob>1
	      	SODER=MSIM+STR(m.kob)+' деталей с '+IIF(m.ip>1,' '+ALLTRIM(STR(m.ip))+' сторон','')
	      ELSE
	      	SODER=MSIM+' деталь с '+IIF(m.ip>1,ALLTRIM(STR(m.ip))+' сторон','')
	      ENDIF 
			do stroka_o
		   soder='выдерживая размеры: '+ALLTRIM(STR(dbk,6,2))	&&	+ALLTRIM(tocd1)+ALLTRIM(tocd11) 
		   if !empt(m.tocd1) 
   			if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
   		or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256    
		   		soder = soder +'+-'+allt(m.tocd1)
   			else
		   		soder = soder +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
   			endif		
		   endif
	   	soder = soder +'; '+ALLTRIM(STR(dbk,6,2))	&&	+ALLTRIM(toch1)+ALLTRIM(toch11)
	   	if !empt(m.toch1) 
		   	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
   		or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256     
   				kuku = +'+-'+allt(m.toch1)
		   	else
   				kuku = +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
		   	endif		
		  	endif
		  	soder = soder + kuku
		   do stroka_o
			if m.sh#0
		      soder_t='ОБРАЗЦЫ ШЕРОХОВАТОСТИ ГОСТ 9378-75'
				m.buk = 'T'
				m.ss  = soder_t
				INSERT INTO ptt FROM memv
		   ENDIF

RETURN 
***************************************************************************************************
*********************************** КОНЕЦ П Л О С К О - Ш Л И Ф О В А Л Ь Н Ы Е *******************
***************************************************************************************************
*********************************** В Н У Т Р И - Ш Л И Ф О В А Л Ь Н Ы Е *************************
***************************************************************************************************
PROCEDURE F_W_S  
WAIT WINDOW 'В Н У Т Р И - Ш Л И Ф О В А Л Ь Н Ы Е  ' NOWAIT 
soder = ''
IF m.ntp=1
   sele * FROM DOSP WHERE vid=31 and US=c_te.vid INTO CURS C_DOSP31
	if RECC()>0
      SODER=ALLTRIM(im)+' '+ALLTRIM(SIM)
      do stroka_o
   endif   
	
   use in C_DOSP31
ENDIF
soder = ''
*WAIT WINDOW 'kko='+STR(m.kko)
if m.kko#0
	sele * from pt where vid=c_te.vid and kko=m.kko into curs c_pt
   if RECCOUNT() > 0
	   soder = allt(im)
   endif
	use in c_pt 
ENDIF
soder =ALLT(STR(M.NTP))+'. '+soder
soder=soder+', выдерживая Ф'+ALLTRIM(STR(dbk,6,2))	&&	+ALLTRIM(tocd1)+ALLTRIM(tocd11) 
kuku = ''
if !empt(m.tocd1) 
   if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
   		or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
   	kuku = kuku +'+-'+allt(m.tocd1)
   else
   	kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
   endif		
endif
soder = soder +', шероховатостью Ra='+ALLTRIM(str(m.sh,7,3))+'; l='+ALLTRIM(STR(M.ds,5)) 	&&	+ALLTRIM(toch1)+ALLTRIM(toch11)  
if !empt(m.toch1) 
	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
   		or asc(left(m.toch1,1))>191 and asc(left(m.toch1,1))<256    
   	kuku = kuku +'+-'+allt(m.toch1)
   else
   	kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
   endif		
endif
do stroka_o
RETURN 
***************************************************************************************************
*********************************** КОНЕЦ В Н У Т Р И - Ш Л И Ф О В А Л Ь Н Ы Е *******************

***************************************************************************************************
*********************************** З У Б О О Б Р А Б О Т К А *************************************
***************************************************************************************************
PROCEDURE F_Z_F

WAIT WINDOW 'З У Б О О Б Р А Б О Т К А' NOWAIT 
		   
soder = ''
IF m.ntp=1
   sele * FROM DOSP WHERE vid=31 and kod=c_te.kku  and US=c_te.vid INTO CURS C_DOSP31
	if RECC()>0
      SODER=ALLTRIM(im)+' '+ALLTRIM(SIM)
      do stroka_o
   endif   
      
   use in C_DOSP31
ENDIF
soder = ''
if m.kko#0
*	WAIT WINDOW 'З У Б О О Б Р А Б О Т К А  vid='+STR(c_te.vid)+' kko='+STR(m.kko)
	sele * from pt where vid=c_te.vid and kko=m.kko into curs c_pt
*	BROW
   if RECCOUNT() > 0
  		   soder = allt(im)
   endif
	use in c_pt 
ENDIF
soder =ALLT(STR(M.NTP))+'. '+soder
if m.kko#0
*!*			      WAIT WINDOW ' PT BROW m.kko='+STR(m.kko,4)+' mvid='+STR(mvid,4)+' m.ka='+STR(m.ka)
   if m.KA#0
      soder=SODER+' '+ALLTRIM(STR(M.KE,3))+' зубъев(а); модуль ' ;
      +allt(str(m.KA,2)) ;
      +'; Ra=';
      +ALLTRIM(STR(m.sh,5,2))+'; остальные размеры согласно чертежа'
   endif
endif
do stroka_o
RETURN 
***************************************************************************************************
*********************************** КОНЕЦ ЗУБООБРАБОТКИ *******************************************

***************************************************************************************************
***********************************   *************************************
***************************************************************************************************

***************************************************************************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_a

m.buk 	= 'А'
m.ceh 	= c_te.mar
m.oper   = c_te.nto
m.od		= ''
INSERT INTO ptt FROM memv
   
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_b
SELECT c_te
m.buk 	= 'Б'
m.prof 	= c_te.kodp
m.p    	= c_te.rr
m.ut   	= c_te.setka
m.kp  	= c_te.krno
m.koid	= c_te.kob
m.tpz		= itpz
*m.tsht	= c_te.normw
*IF INLIST(LEFT(mkttp,11),'06024.55273')
	m.tsht	= itogt
*endif
INSERT INTO ptt FROM memv
   
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_g
m.buk = 'А'
*!*	m.ss  = ' ИOT № '+str(n_i,2)
INSERT INTO ptt FROM memv
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_o
*!*	WAIT WINDOW 'stroka_o'
if len(soder)>120
   stroka_1=substr(soder,1,119) 
   m.buk = 'О'
	m.ss  = stroka_1
	INSERT INTO ptt FROM memv
   
   stroka_2=substr(soder,120)
   m.buk = 'О'
	m.ss  = stroka_2
	INSERT INTO ptt FROM memv
ELSE
	m.buk = 'О'
	m.ss  = soder
	INSERT INTO ptt FROM memv
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
PROCEDURE SWARKA
wait window ' пошла сварка' nowa
	                                   
IF c_te.kto = 418
	SELECT kornd,naimd,nrmd,kol FROM KT WHERE poznd=c_te.poznd and d_u=1 or poznw=c_te.poznd AND d_u=2 ORDER BY kornd INTO CURSOR c_kt_kornd 
	soder = 'скомплектовать детали(подузлы) под сварку  и транспортировать на рабочнн место сварщика '
	m.buk = 'К'
	m.ss  = soder
	INSERT INTO ptt FROM memv
	soder = ''
	SCAN
		soder = 'поз. '+ALLTRIM(c_kt_kornd.kornd)+ ' ' + ;
				ALLTRIM(c_kt_kornd.naimd)+ ' ' + ;
				ALLTRIM(STR(c_kt_kornd.nrmd,12,5))+ ' ' + ;
				ALLTRIM(STR(c_kt_kornd.kol,5))
		m.buk = 'К'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
	ENDSCAN
	
	soder_t='Tележка ручная' 
  	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
	soder_t='Погрузчик' 
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv	
	soder_t='Кран-балка' 
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv					
   USE IN c_kt_kornd
ENDIF
IF c_te.kto = 130
	soder = 'Очистить свариваемые кромки и прилегающие к ним поверхности деталей от жировых загрязнений, окисных пленок, грязи и краски на ширину не менее 30 мм.' 
	DO stroka_o
	IF INLIST(1,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=476 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF
	IF INLIST(2,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=462 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  =ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF
	IF INLIST(80,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=230 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF
	IF INLIST(3,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi = 322 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF
	IF INLIST(5,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=329 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF
	IF INLIST(5,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=477 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF
	
	SELECT im FROM INSTR WHERE kodi=469 INTO CURSOR c_kodi
	IF RECCOUNT() > 0
		m.ss  = ALLTRIM(c_kodi.im)
		m.buk = 'T'
		INSERT INTO ptt FROM memv	
	endif	
 	USE IN c_kodi
ENDIF
IF c_te.kto = 9043	
	SELECT kornd,naimd,nrmd,kol FROM KT WHERE poznw=c_te.poznd AND d_u=2 or poznd=c_te.poznd and d_u=1 ORDER BY kornd INTO CURSOR c_kt_kornd 
	SELECT * FROM KTU WHERE kto = 9043 AND (npp=>47 AND npp <= 56 OR npp=70) ORDER BY npp ;
		INTO CURSOR c_9043
	SCAN all
		IF INLIST(c_9043.npp, te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
			m.buk = 'T'
			m.ss  = ALLTRIM(c_9043.im)
			INSERT INTO ptt FROM memv	
		endif
	endscan
	USE IN c_9043
	soder='Прихватить детали поз. '+ALLTRIM(c_kt_kornd.kornd)+ ' ' + ;
				ALLTRIM(c_kt_kornd.naimd)+ ' ' + ;
				ALLTRIM(STR(c_kt_kornd.nrmd,12,5))+ ' ' + ;
				ALLTRIM(STR(c_kt_kornd.kol,5))
	DO stroka_o
	
	IF INLIST(6, te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=63 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF
	IF INLIST(7, te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=37 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF	
	IF INLIST(9, te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=33 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF	
	SELECT im FROM INSTR WHERE kodi=339 INTO CURSOR c_kodi
	IF RECCOUNT() > 0
		m.ss  = ALLTRIM(c_kodi.im)
		m.buk = 'T'
		INSERT INTO ptt FROM memv	
	endif	
 	USE IN c_kodi

	SELECT im FROM dosp WHERE vid=c_te.vid AND kod=c_te.cw INTO CURSOR c_cw
	IF RECCOUNT()>0
		im_cw=c_cw.im
	ELSE
		im_cw=''
	endif
	USE IN c_cw
	soder = 'сварить узел швом '+' длиной '+allt(STR(c_te.L1,6,3))+im_cw+' с шагом '+ALLTRIM(STR(c_te.shag,4)) ;
		+' катетом '+allt(str(c_te.ka,4,1))
	use in c_kt_kornd
	
	SELECT kornd,naimd,nrmd FROM KT WHERE poznw=c_te.poznd AND d_u=5 ORDER BY kornd INTO CURSOR c_kt_5 
	
	soder = ''
	SCAN
		SELECT * FROM mater WHERE kodm = c_kt_5.kodm INTO CURSOR c_mat
		IF RECCOUNT() > 0
			ma = ALLTRIM(c_mat.naim)
		ELSE
			ma = ''
		ENDIF
		USE IN c_mat
		soder = ma+ ' ' + ;
				ALLTRIM(c_kt_5.ei)+ ' ' + ;
				ALLTRIM(STR(c_kt_5.nrmd,12,5))
		m.buk = 'К'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
	ENDSCAN
	use in c_kt_5
ENDIF 		
IF c_te.kto = 109
	IF INLIST(33,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15) ;
	   or INLIST(34,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
	   soder = 'Зачистить сварные швы и прилегающие к ним поверхности от брызг расплавленного металла'
	   DO stroka_o
	endif   
	IF INLIST(34,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=462 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF
	IF INLIST(33,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		SELECT im FROM INSTR WHERE kodi=457 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
 		USE IN c_kodi
	ENDIF
	
	SELECT im FROM INSTR WHERE kodi=469 INTO CURSOR c_kodi
	IF RECCOUNT() > 0
		m.ss  = ALLTRIM(c_kodi.im)
		m.buk = 'T'
		INSERT INTO ptt FROM memv	
	endif	
	USE IN c_kodi
	IF INLIST(28,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = 'Наплывы и неровности сварных швов обработать с плавным переходом к основному металлу'
		DO stroka_o
		IF INLIST(4,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
			SELECT im FROM INSTR WHERE kodi=457 INTO CURSOR c_kodi
			IF RECCOUNT() > 0
				m.ss  = ALLTRIM(c_kodi.im)
				m.buk = 'T'
				INSERT INTO ptt FROM memv	
			endif	
 			USE IN c_kodi
 		ENDIF
 		SELECT im FROM INSTR WHERE kodi=469 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
		USE IN c_kodi
	ENDIF
	IF INLIST(29,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = 'Усиление шва снять'
		DO stroka_o
		IF INLIST(4,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
			SELECT im FROM INSTR WHERE kodi=457 INTO CURSOR c_kodi
			IF RECCOUNT() > 0
				m.ss  = ALLTRIM(c_kodi.im)
				m.buk = 'T'
				INSERT INTO ptt FROM memv	
			endif	
 			USE IN c_kodi
 		ENDIF
 		SELECT im FROM INSTR WHERE kodi=469 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
		USE IN c_kodi
	ENDIF	
ENDIF
IF c_te.kto = 4237
	IF INLIST(28,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = 'Наплывы и неровности сварных швов обработать с плавным переходом к основному металлу'
		DO stroka_o
		SELECT im FROM INSTR WHERE kodi=469 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
		USE IN c_kodi
	ENDIF
	IF INLIST(29,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = 'Усиление шва снять'
		DO stroka_o
		SELECT im FROM INSTR WHERE kodi=469 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
		USE IN c_kodi
	ENDIF	
ENDIF
IF c_te.kto = 200
	soder = '1. Проверить качество свариваемых швов визуально, наплывы, подрезы, трещины, непровары и прожеги не допускаются'
	DO stroka_o
	soder = '2. Проверить соответствие свариваемого узла черртежу'
	DO stroka_o
	IF INLIST(6,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = 'Усиление шва снять'
		DO stroka_o
		SELECT im FROM INSTR WHERE kodi=463 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
		USE IN c_kodi
	ENDIF	
	IF INLIST(8,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = 'Усиление шва снять'
		DO stroka_o
		SELECT im FROM INSTR WHERE kodi=514 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
		USE IN c_kodi
	ENDIF
	IF INLIST(999,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = 'Усиление шва снять'
		DO stroka_o
		SELECT im FROM INSTR WHERE kodi=386 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
		USE IN c_kodi
	ENDIF	
	IF INLIST(9,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = 'Усиление шва снять'
		DO stroka_o
		SELECT im FROM INSTR WHERE kodi=33 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
		USE IN c_kodi
	ENDIF
	IF INLIST(7,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = 'Усиление шва снять'
		DO stroka_o
		SELECT im FROM INSTR WHERE kodi=37 INTO CURSOR c_kodi
		IF RECCOUNT() > 0
			m.ss  = ALLTRIM(c_kodi.im)
			m.buk = 'T'
			INSERT INTO ptt FROM memv	
		endif	
		USE IN c_kodi
	ENDIF
	
	IF INLIST(27,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = '1. Установить свариваемую емкость на горизонтальную поверхность, выставить по уровню.'
		DO stroka_o
		soder = '2. Наполнить емкость водой '+ALLTRIM(STR(c_te.v,5,3))+' куб.м'
		DO stroka_o
		soder = '3. Выдержать емкость с водой в течении 1 часа.'
		DO stroka_o
		soder = '4. Проверить отсутстыие течи воды вдоль сварных швов визуально'
		DO stroka_o
		soder = '5. Слить воду из проверяемой емкости'
		DO stroka_o
		soder = '6. Высушить емкость от остатков влаги на по верхности изделия естественной сушкой'
		DO stroka_o
	endif
ENDIF
*       конец сварки
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
PROCEDURE toch1_
if !empt(m.toch1) 
	if asc(left(m.toch1,1))>64 and asc(left(m.toch1,1))<91 or asc(left(m.toch1,1))>96 and asc(left(m.toch1,1))<123 ;
 		or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
		kuku = kuku +'+-'+allt(m.toch1)
	else
   	kuku = kuku +' '+allt(m.toch1)+iif(empty(m.toch11),+'',+' '+ALLTRIM(m.toch11)) 
   endif		
ENDIF
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *    
PROCEDURE toch2_
if asc(left(m.toch2,1))>64 and asc(left(m.toch2,1))<91 or asc(left(m.toch2,1))>96 and asc(left(m.toch2,1))<123 ;
	or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
	kuku = kuku +'+'+allt(m.toch2)+'-'+ALLTRIM(m.toch2)
else
	kuku = kuku +' '+allt(m.toch2)+iif(empty(m.toch21),+'',+' '+ALLTRIM(m.toch21)) 
ENDIF
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
PROCEDURE toch3_
if asc(left(m.toch3,1))>64 and asc(left(m.toch3,1))<91 or asc(left(m.toch3,1))>96 and asc(left(m.toch3,1))<123 ;
	or asc(left(m.toch3,1))>191 and asc(left(m.toch3,1))<256      
		kuku = kuku +'+'+allt(m.toch3)+'-'+ALLTRIM(m.toch3)
else
		kuku = kuku +' '+allt(m.toch3)+iif(empty(m.toch31),+'',+'; '+ALLTRIM(m.toch31)) 
endif		
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
PROCEDURE tocd1_
if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
   or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
   kuku = kuku +'+-'+allt(m.tocd1)
else
	kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
ENDIF
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
 
	 