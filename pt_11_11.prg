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
   wait 'HET TAKO� �O����� !!!' wind
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
			*wait '�� ������ '+c_kt.poznd+' � �������� '+str(m[mars],4)+' ������ ���������� !!! ' wind
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
   wait 'mkttp'+mkttp+' c_kt.poznd'+c_kt.poznd+' ��� ��������� � TE' wind
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
         wait '������������ ������, ���� ���������' wind
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
      wait '��� � TE ���������� �� �������� '+mkttp+' '+alltrim(c_kt.poznd)+' '+str(o[ind],4) wind
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
	   	   	soder = '������ ������ �������� �������'
	      	ENDIF
		      IF m[mars] = 213
		      	soder = '������ ������ �������� ���������'
	   	   ENDIF
		      IF m[mars] = 215 or m[mars] = 604
		      	soder = '���������� ����������� ������ �������� ��������'
	   	   ENDIF
		      IF m[mars] = 223
		      	soder = '�������� ������ �������� �������'
	   	   ENDIF
	      	IF INLIST(m[mars], 341, 11042, 4042, 9142, 9242)
	      		soder = '��������� ������� � ������������ � ������������ �������'
		      ENDIF
		      IF m[mars] = 433
	   	   	soder = '���������� �������� �������' 
	      	ENDIF
		      IF m[mars] = 1024
*!*			      	WAIT WINDOW '1024'
		      	soder = '����������� �������� �������' 
	   	   ENDIF
		      IF m[mars] = 1046
		      	soder = '�������� ��������� � ������ �������'
		      ENDIF
		      IF m[mars] = 1109
		      	soder = '������������ ������(����), �������� ���������� �������' 
		      ENDIF
		      IF INLIST(m[mars],  1440, 1540, 1640, 4141, 4240, 4241, 4440,9140, 9240)
		      	soder = '������� ���� � ������������ � ������������ �������' 
		      ENDIF
		      IF m[mars] = 4340
		      	soder = '��������� ������ �� ������������� ����������' 
		      ENDIF
		      IF m[mars] = 6022
		      	soder = '���������� ������ ���������������� ��������' 
		      ENDIF
		      IF m[mars] = 8043
		      	soder = '���������� ���� �������� �������' 
		      ENDIF
		      IF m[mars] = 9206
		      	soder = '�������� ��������� �� ������������� �������� �������' 
		      ENDIF
		      IF m[mars] = 9238
		      	soder = '������ ��������� �������� �������'
		      ENDIF
		      IF m[mars] = 9247
		      	soder = '������ ������� �������� �������'
		      ENDIF
		      IF m[mars] = 9248
		      	soder = '���������� ���� �������� �������'
		      ENDIF
		      IF m[mars] = 9249
		      	soder = '������������ ������� � ������������ � ������� ������������'
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
wait window ' ����� ������ ����������' nowa
	                                   
IF c_te.kto = 418
	SELECT kornd,naimd,nrmd,pri1 FROM KT WHERE poznw=c_kt.poznd AND pri1 = c_te.pri AND pri2 = 0 ORDER BY pri1 INTO CURSOR c_kt_sw 
	soder = ''
	SCAN
		IF c_kt_sw.pri1 = 0
			m.buk = '�'
			m.ss = '�������������� ������(����) ��� ������ � ���������������� �� ������� ����� ��������'
			INSERT INTO ptt FROM memv
		ENDIF
		IF c_kt_sw.pri1 > 0
			m.buk = '�'
			m.ss = '�������������� ������(����) ���������������� ���� � '+ALLTRIM(STR(c_kt_sw.pri1)) ;
					+' ��� ������ � ���������������� �� ������� ����� ��������'
			INSERT INTO ptt FROM memv
		endif
		soder = '���. '+ALLTRIM(c_kt_sw.kornd)+ ' ' + ;
				ALLTRIM(c_kt_sw.naimd)+ ' ' + ;
				ALLTRIM(STR(c_kt_sw.nrmd,12,5))+ ' ' + ;
				ALLTRIM(STR(c_kt_sw.kol,5))
		m.buk = '�'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
	ENDSCAN
	USE IN c_kt_sw
	soder_t='T������ ������' 
  	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
	soder_t='���������' 
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv	
	soder_t='����-�����' 
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv					
ENDIF
IF c_te.kto = 130
	soder = '1. �������� ������ � ������ ������ � ���� ����� �� ������� �����������, �������� �������� ������������� ���������� � �������' 
	DO stroka_o
	soder = '2. �������� �������� �� ������, ������ �������� ��������� ������� ����������' 
	DO stroka_o
	soder = '3. ����������������� �������� ��������� ������� ����� ������� �� ����� 24 ���.' 
	DO stroka_o
ENDIF
IF c_te.kto = 101	
	soder='��������� ������ ��� ������ �������� �������'
	DO stroka_o
ENDIF 		
IF c_te.kto = 9011
	soder = '1. ���������� ��������� ������ ������'
	DO stroka_o
	soder = '2. ������� ��������������� ������� '
	DO stroka_o
	IF !EMPTY(c_te.osn) 
		soder = '3. ���������� ������ � �������������� '
		DO stroka_o
	ELSE
		soder = '3. ��������� ������ �� �������� '
		DO stroka_o	
	endif	
	soder = '4. ������� ������ �������� �������  '
	DO stroka_o
	soder = '���������� ����� '+ALLTRIM(STR(c_te.ip))+', ���������� ����� ������� '+ALLTRIM(STR(shag,6,2))
	DO stroka_o
	soder = '����������: ������� ����������� ���������� �������� ������������ ������� ����� 100-150 ����� '
	DO stroka_o
endif
IF c_te.kto = 108
	soder = '������� �������� �������� ������� (��� �������������)'
	DO stroka_o
ENDIF
IF c_te.kto = 200
	soder = '1. ��������� ������������ ������������ ������� ����� �� ���� ������������, ���������� �� �������'
	DO stroka_o
	soder = '2. ��������� ����� � ������� ������ �� ����������. ��������� ������� ����� ������ ����� ����� ����������'
	soder = soder +' (����������� ���������� �� ����� 3:2. ������� ������� �� ������ ���� ����� 20 % ������� ������.'
	DO stroka_o
	soder = '3. ��������� ������� ���������� ���� �� ������������ �������'
	soder = soder +' 4. ��� ����������� �������� ������ �� ��������������� ����� ������� ������� ����������� ���������� � ������ ��� ������'
	soder = soder +' �������� ���������������. ��� ���� ���������� ������ ����������� �� ��������� ��������� ��� �� ���� ������������ �������'
	DO stroka_o	
endif
*       ����� ������
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
***************************************************************************************************
*********************	� � � � � � � � � �   � � � � � � � �    ******************************
PROCEDURE F_prof_Slif
wait '� � � � � � � � � �   � � � � � � � � ' WINDOW NOWAIT 
IF INLIST(70,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
	soder =ALLT(STR(c_te.NTP))+'. '+' ��������� ������� '
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
      kuku = kuku +IIF(c_te.ug#0,'; ���� '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
retu
***************************************************************************************************
*********************	� � � � � � � � � � � �   � � � � � � � �    ******************************
PROCEDURE F_koord_Slif
wait '� � � � � � � � � � � �   � � � � � � � �' WINDOW NOWAIT 
IF INLIST(52,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' ��������� �������� ���������� '
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
   	kuku = kuku +IIF(c_te.ug#0,'; ���� '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
		
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(53,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
	OR INLIST(54,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
	OR INLIST(55,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
	soder =ALLT(STR(c_te.NTP))+'. '+' ��������� ������� ����������� '
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
      kuku = kuku +IIF(c_te.ug#0,'; ���� '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
retu
*********************	� � � � � � � � � � �  -  � � � � � � � � �  ******************************
PROCEDURE F_k_r
wait '� � � � � � � � � � �  -  � � � � � � � � �' WINDOW NOWAIT 
IF INLIST(49,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' ����������, ��������, �����������, �����������, ���������� ���������� D '
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
      kuku = kuku +IIF(c_te.ug#0,'; ���� '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(50,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' ����������, ��������, ���������� ���������� D '
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
      kuku = kuku +IIF(c_te.ug#0,'; ���� '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(51,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' ��������� ������� � ����������� D '
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
      kuku = kuku +IIF(c_te.ug#0,'; ���� '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(11,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' ��������������������� ������ � ���������� '
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
	soder =ALLT(STR(c_te.NTP))+'. '+' ��������� ������, ������������� ���  ����� '
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
      kuku = kuku +IIF(c_te.ug#0,'; ���� '+ALLTRIM(STR(c_te.ug,3)),'')  
	endif
	soder = soder + kuku
	DO stroka_o 
ENDIF
IF INLIST(13,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
	soder =ALLT(STR(c_te.NTP))+'. '+' ��������� ������������� ������ '
	DO stroka_o 
endif
RETU
***************************************************************************************************
***************************************************************************************************
*********************	� � � � � � - � � � � � � � � � � � �  ************************************
PROCEDURE F_O_S
wait '� � � � � � - � � � � � � � � � � � �' WINDOW NOWAIT 

soder =ALLT(STR(c_te.NTP))+'. '+' ��������� '+ALLTRIM(STR(c_te.ip,2))+' �����������, ���������� �������:'
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
   kuku = kuku +IIF(c_te.ug#0,'; ���� '+ALLTRIM(STR(c_te.ug,3)),'') ;
            +IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
            +IIF(c_te.sh<>0,'; Ra '+allt(str(c_te.sh,7,3)),'')
endif
soder = soder + kuka
DO stroka_o 
RETU
***************************************************************************************************
*********************	� � � � � � � � ***********************************************************
PROCEDURE TERM
IF INLIST(c_te.kto, 5010, 5050, 5060, 5100)
	SELECT * FROM DOSP WHERE vid=38 AND kod = te_kto INTO CURSOR c_dosp7
	IF RECCOUNT() > 0
		SODER = ALLTRIM(c_dosp7.sim)
		soder = soder + 'HRC ���������� '+ALLTRIM(STR(c_te.tvr,4))
		soder = soder + IIF(c_te.glub>0, ' �������� '+ALLTRIM(STR(c_te.glub)),'')
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
		m.buk = '�'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
		USE IN c_mat
	ENDSCAN
	USE IN c_kt_kornd
ENDIF
RETURN 

***************************************************************************************************
***************	� � � � �   � � � � � � � � *****************************************************

***************	� � � � � � � � � � *************************************************************
PROCEDURE GALWAN
wait ' � � � � � � � � � �  ' WINDOW NOWAIT 
soder = ''
IF INLIST(c_te.kto, 7100, 7135, 7141, 7172, 7174)
	SELECT * FROM DOSP WHERE vid=7 AND kod = c_te.kto INTO CURSOR c_dosp7
	IF RECCOUNT() > 0
		SODER = ALLTRIM(c_dosp7.sim)
		soder = soder + '�������� '+ALLTRIM(STR(c_te.sp,8,4))+'��.�'
		soder = soder + IIF(c_te.glub>0, ' �������� '+ALLTRIM(STR(c_te.glub)),'')
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
		m.buk = '�'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
		USE IN c_mat
	ENDSCAN
	USE IN c_kt_kornd
ENDIF
RETURN 
***********************************����� ����������************************************************
***************************************************************************************************
*************************************** � � � � � � � � �  ****************************************
PROCEDURE SHTAMP
WAIT WINDOW '���������' nowait 
SELECT * FROM KTU WHERE ttp=LEFT(c_te.kttp,11) AND kof =1 ORDER BY pri INTO CURSOR c_ktu 
IF RECCOUNT() > 0
	SCAN
		IF INLIST(NPP,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
			soder = c_ktu.dop
			m.buk = '�'
			m.ss  = soder
			INSERT INTO ptt FROM memv
		ENDIF
	ENDSCAN
ENDIF
USE IN c_ktu
RETURN 
***************************************************************************************************
**************************************** � � � � � � � �  *****************************************
PROCEDURE slesar
wait '� � � � � � � �  ' window nowait 
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
		m.buk = '�'
		m.ss  = soder
		INSERT INTO ptt FROM memv
	ENDSCAN
ENDIF
USE IN c_ktu
retu
***************************************************************************************************
**************************************** � � � � � � � � �*****************************************
PROCEDURE valz
wait '� � � � � � � � �  ' window nowait 
SELECT * FROM KTU WHERE ttp=LEFT(c_te.kttp,11) AND kof=2 ORDER BY pri INTO CURSOR c_ktu 
IF RECCOUNT() > 0
	SCAN
		IF INLIST(NPP,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
			soder = c_ktu.dop
			m.buk = '�'
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
**************************************** � � � � � � � �  � � � � � � *****************************
PROCEDURE slesar_PR
wait '� � � � � � � �  � � � � � � ' WINDOW  NOWAIT
IF te_vid=46
	IF INLIST(90,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '��������� ��������� �� �����'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(148,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '��������� �������� ��������� �� �����'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(91,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(92,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '������� ��������� ������� �� ���������'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(102,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '������� ��������� ������� �� ��������� � �� �����'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(93,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '������� ������ �� ��������� � �� ����� �������'
		INSERT INTO ptt FROM memv
	ENDIF
	 IF INLIST(94,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '������� �������� ������ �� ���������� ������'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(95,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '������� �������� ������ �������'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(96,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '������� �������� ��������� �� ��������� �� ������'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(97,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '��������� ������ ��������� �� ����� �������'
		INSERT INTO ptt FROM memv
	ENDIF
ENDIF
IF te_vid=42
	IF INLIST(80,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(81,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(82,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = '�'
		m.ss  = '������� ������(����) �� ����������� � �����'
		INSERT INTO ptt FROM memv
	endif	
ENDIF
IF te_vid=48
	IF INLIST(123,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(124,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(125,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = '�'
		m.ss  = '��������� �����������(�) ������, ���������� ������������� Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	endif	
	IF INLIST(129,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(130,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(131,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = '�'
		m.ss  = '���������� �����������(�) ������, ���������� ������������� Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	endif	
	IF INLIST(145,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(146,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(147,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = '�'
		m.ss  = '���������� �����������(�) ������, ���������� ������������� Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(134,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(135,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(136,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(137,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) 
		m.buk = '�'
		m.ss  = '���������� �����������(�) ������, ���������� ������������� Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	endif	
	IF INLIST(109,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(110,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)  
		m.buk = '�'
		m.ss  = '��������� �����������(�) ������, ���������� ������������� Ra = '+ALLTRIM(STR(c_te.sh,7,3))
		INSERT INTO ptt FROM memv
	ENDIF	
ENDIF
IF te_vid = 44
	IF INLIST(90,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '��������� ������ ����� �������� �� ������� �������� ��������, �����, �����'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(144,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '��������� ������ ������ �������� �� ������� �������� ��������, �����, �����'
		INSERT INTO ptt FROM memv
	endif
ENDIF
IF te_vid = 43
	IF INLIST(83,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '���������� �������������� ����� ������'
		INSERT INTO ptt FROM memv
	endif
	IF INLIST(83,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '���������� �������������� ����� ��� �����'
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
		m.buk = '�'
		m.ss  = '��������� ��������, ���������� ������� '+ALLTRIM(STR(c_te.rozma,6,1))+'x'+ALLTRIM(STR(c_te.rozmb,6,1))
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(111,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(112,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		OR ;
		INLIST(138,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		 OR ;
		INLIST(139,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)  
		m.buk = '�'
		m.ss  = '������� ����������� ���������� � �����(����)'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(141,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '������������� ������ ��� ��������'
		INSERT INTO ptt FROM memv
	ENDIF
	IF INLIST(142,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8) ;
		or INLIST(143,c_te.US1,c_te.US2,c_te.US3,c_te.US4,c_te.US5,c_te.US6,c_te.US7,c_te.US8)
		m.buk = '�'
		m.ss  = '������ ����������� ����� �������'
		INSERT INTO ptt FROM memv
	ENDIF
ENDIF
retu
************************************  ����� � � � � � � � �  � � � � � � **************************
***************************************************************************************************
**************************************** � � � � � � �  *******************************************
PROCEDURE OKRASKA
wait '� � � � � � �  ' WINDOW  NOWAIT
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
	soder = '�������� ������(����) ������� '+' '+IM9+' �������� '+ALLTRIM(STR(C_TE.SP,8,4))+' '+zwet+' ������'
	m.buk = '�'
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
		m.buk = '�'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
		USE IN c_mat
	ENDSCAN
	USE IN c_kt_kornd
endif
retu

*********************************** �����  � � � � � � �  *****************************************
***************************************************************************************************
********************************** � � � � � � � � � **********************************************
PROCEDURE ZAGOT
wait '� � � � � � � � �  ' WINDOW NOWAIT 
soder = ' '
IF c_te.nto = 5
	IF c_kt.kolz>1
		soder= '��������� ��������� ��������� �� '+ALLTRIM(STR(c_kt.kolz))+' �������, ���������� ������� '+ALLTRIM(STR(c_kt.rozma,6,1))+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1))+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')+'� ������ '+c_kt.primech
		do stroka_o
	ELSE
		soder= '��������� ���������, ���������� ������� '+ALLTRIM(STR(c_kt.rozma,6,1))+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1))+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')+'� ������ '+c_kt.primech
		do stroka_o
	endif	
	
*!*		wait window 'do stroka_o 5'
	soder_t = '������� ���� 7502; �������������� 250 ���� 166, ������� �� - 180 ���� 5378-66 '
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
	soder_t = '����-����� � ����������������, �������� ��� � ���� 12.4.010-075'
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
ENDIF

IF c_te.nto = 10
	IF c_kt.kolz>1
		soder= '�������� ��������� ��������� �� '+ALLTRIM(STR(c_kt.kolz))+' �������, ���������� ������� '+ALLTRIM(STR(c_kt.rozma,6,1))+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1))+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')
		do stroka_o
	ELSE
		soder= '�������� ���������, ���������� ������� '+ALLTRIM(STR(c_kt.rozma,6,1))+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1))+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')
		do stroka_o
	endif	
	
	soder_t = '������� ���� 7502; �������������� 250 ���� 166, ������� �� - 180 ���� 5378-66 '
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
	soder_t = '����-����� � ����������������, �������� ��� � ���� 12.4.010-075'
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
endif
IF c_te.nto = 15
	soder= '�������������� ��������� 5 % �� ������, ���������� ������� ' ;
		+ALLTRIM(STR(c_kt.rozma,6,1)) ;
		+' - '+ALLTRIM(STR(c_kt.tocha,4,2)) ;
		+IIF(c_kt.rozmb<>0,'x'+ALLTRIM(STR(c_kt.rozmb,6,1)) ;
		+' - '+ALLTRIM(STR(c_kt.tochb,4,2)),'')
	do stroka_o
	soder_t = '������� ���� 7502; �������������� 250 ���� 166, ������� �� - 180 ���� 5378-66 '
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
ENDIF
IF c_te.nto = 20
	soder= '����������� ��������� �� ���������������� �������� '
	do stroka_o
	soder_t = '����-����� � ����������������, ���������, �������� ��� � ���� 12.4.010-075'
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
ENDIF
RETURN 
*********************************** ����� � � � � � � � � � *************************************
***************************************************************************************************
********************************** � � � � � � � � ************************************************
PROCEDURE F_TOK_VINT
wait ' � � � � � � � �  ' WINDOW  NOWAIT 
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
*!*		soder = ' � '+allt(str(m.d,6,2))+'  �� � '+allt(str(m.dbk,6,2))+' �������� '+ALLTRIM(STR(m.ds,6,2))
*!*		do stroka_o
	soder='���������� �������: �'+ALLTRIM(STR(m.dbk,6,2))
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
	kuku = kuku +IIF(m.ug>0,'; �='+ALLTRIM(STR(m.ug)),'') ;
					+IIF(m.rad>0,'; r='+ALLTRIM(STR(m.rad,5,1)),'')
	soder = soder + kuku
	do stroka_o
ENDIF
IF m.kko = 4 OR m.kko = 9
*!*		soder = ' � '+allt(str(m.d,6,2))+'  �� � '+allt(str(m.dbk,6,2))+' �� ����� '+ALLTRIM(STR(m.ds,6,2))
*!*		do stroka_o
	soder='������������ �������: �'+ALLTRIM(STR(m.dbk,6,2))
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
	kuku = kuku +IIF(m.ug>0,'; �='+ALLTRIM(STR(m.ug)),'') ;
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
	soder='���������� �������: � '+allt(str(m.d,6,2))
	if !empt(m.tocd1) 
		if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
			or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
			kuku = kuku +'+-'+allt(m.tocd1)
		else
			kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
		endif		
	ENDIF
	kuku = ''
	kuku = kuku +IIF(m.ug>0,'; �='+ALLTRIM(STR(m.ug)),'') ;
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
*!*		soder = ' � '+allt(str(m.d,6,2))+'  �� � '+allt(str(m.dbk,6,2))+' �� ����� '+ALLTRIM(STR(m.ds,6,2))
*!*		do stroka_o
	soder='������������ �������: �'+ALLTRIM(STR(m.dbk,6,2))
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
	soder = ALLTRIM(m.ip,2)+' ���(�) ���������� �������: �'+ALLTRIM(STR(m.dbk,6,2))
	kuku = ''
	if !empt(m.tocd1) 
		if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
			or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
			kuku = kuku +'+-'+allt(m.tocd1)
		else
			kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
		endif		
	ENDIF
	kuku = kuku +'; �='+ ALLTRIM(STR(m.ds,6,2))
	f m.sh#0
	  	if m.sh=>10
    		kuku=kuku+'; Rz='+allt(str(m.sh,7,3))
	  	else
			kuku=kuku+'; Ra='+allt(str(m.sh,7,3))
	  	endif
	ENDIF
	kuku = kuku +IIF(m.ug>0,'; �='+ALLTRIM(STR(m.ug)),'') ;
					+IIF(m.rad>0,'; r='+ALLTRIM(STR(m.rad,5,1)),'')
	soder = soder + kuku
	do stroka_o
ENDIF
IF m.kko = 24 OR m.kko = 25
	soder = ' M '+allt(str(m.d,6,2))+' �������� '+ALLTRIM(STR(m.ds,6,2))
	do stroka_o
ENDIF
IF m.kko = 26
	soder='���������� �������: '
	kuku = ''
	kuku = kuku +IIF(m.ug>0,'; �='+ALLTRIM(STR(m.ug)),'') ;
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
	soder = ' G '+subs(sh_,1,1)+' '+subs(sh_,2,1)+'\'+subs(sh_,4,1)+'"'+'  �������� '+ALLTRIM(STR(m.ds,6,2))
	do stroka_o
endif
RETURN 

*********************************** ����� �������-����������� *************************************
***************************************************************************************************
***************************************************************************************************
********************************** � � � � � � � � � **********************************************
PROCEDURE F_SWERL
wait ' � � � � � � � � �  ' WINDOW NOWAIT 
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
	soder =soder +' '+ALLTRIM(STR(ip))+' ���.' ;
		+ '���������� �������: �'+allt(str(m.D,6,2))
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
		+' '+ALLTRIM(STR(ip))+' ���. �� ' ;
		+ '���������� �������: �'+allt(str(m.D,6,2))
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
		+' '+ALLTRIM(STR(ip))+' ���.' ;
		+ '���������� �������: �'+allt(str(m.D,6,2))
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
	soder =soder + ' '+ALLTRIM(STR(ip))+' ���. �������� ��������'
	do stroka_o
endif
IF INLIST(m.kko, 6,7,8) 
	kuku = ''
	soder =soder ;
		+' '+ALLTRIM(STR(ip))+' ���.' ;
		+ '���������� �������: �'+allt(str(m.D,6,2))
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
		+' '+ALLTRIM(STR(ip))+' ���.' ;
		+ '���������� �������: S='+allt(str(m.shag,6,2)) ;
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
	soder =soder + ' ���. �������� ���������� �������'
	do stroka_o
endif
RETURN 
*********************************** ����� � � � � � � � � �   *************************************
***************************************************************************************************
*********************************** � � � � � � � � � *********************************************
PROCEDURE F_FREZA
wait '� � � � � � � � �  ' WINDOW NOWAIT 
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
kuku='���������� �������:'
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
	kuku=kuku+IIF(m.ug#0,'; ���� '+ALLTRIM(STR(m.ug,3)),'')+IIF(m.rad#0,'; R='+ALLTRIM(STR(m.rad,3)),'') ;
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
************************************����� ���������************************************************
 
***************************************************************************************************
*********************************** � � � � �� - � � � � � � � � � � � � **************************
PROCEDURE  F_K_S

WAIT WINDOW ' � � � � �� - � � � � � � � � � � � �' NOWAIT 
	 
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
   soder=soder+' ����������� ' 
endif
do stroka_o
soder='���������� ������� �'
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
*********************************** ����� � � � � � � - � � � � � � � � � � � � *******************
***************************************************************************************************
*********************************** � � � � � � - � � � � � � � � � � � � *************************
***************************************************************************************************
PROCEDURE F_P_S

WAIT WINDOW ' � � � � � � - � � � � � � � � � � � � ' nowait

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
	      	SODER=MSIM+STR(m.kob)+' ������� � '+IIF(m.ip>1,' '+ALLTRIM(STR(m.ip))+' ������','')
	      ELSE
	      	SODER=MSIM+' ������ � '+IIF(m.ip>1,ALLTRIM(STR(m.ip))+' ������','')
	      ENDIF 
			do stroka_o
		   soder='���������� �������: '+ALLTRIM(STR(dbk,6,2))	&&	+ALLTRIM(tocd1)+ALLTRIM(tocd11) 
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
		      soder_t='������� ������������� ���� 9378-75'
				m.buk = 'T'
				m.ss  = soder_t
				INSERT INTO ptt FROM memv
		   ENDIF

RETURN 
***************************************************************************************************
*********************************** ����� � � � � � � - � � � � � � � � � � � � *******************
***************************************************************************************************
*********************************** � � � � � � - � � � � � � � � � � � � *************************
***************************************************************************************************
PROCEDURE F_W_S  
WAIT WINDOW '� � � � � � - � � � � � � � � � � � �  ' NOWAIT 
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
soder=soder+', ���������� �'+ALLTRIM(STR(dbk,6,2))	&&	+ALLTRIM(tocd1)+ALLTRIM(tocd11) 
kuku = ''
if !empt(m.tocd1) 
   if asc(left(m.tocd1,1))>64 and asc(left(m.tocd1,1))<91 or asc(left(m.tocd1,1))>96 and asc(left(m.tocd1,1))<123 ;
   		or asc(left(m.tocd1,1))>191 and asc(left(m.tocd1,1))<256     
   	kuku = kuku +'+-'+allt(m.tocd1)
   else
   	kuku = kuku +' '+allt(m.tocd1)+iif(empty(m.tocd11),+'',+' '+ALLTRIM(m.tocd11)) 
   endif		
endif
soder = soder +', �������������� Ra='+ALLTRIM(str(m.sh,7,3))+'; l='+ALLTRIM(STR(M.ds,5)) 	&&	+ALLTRIM(toch1)+ALLTRIM(toch11)  
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
*********************************** ����� � � � � � � - � � � � � � � � � � � � *******************

***************************************************************************************************
*********************************** � � � � � � � � � � � � � *************************************
***************************************************************************************************
PROCEDURE F_Z_F

WAIT WINDOW '� � � � � � � � � � � � �' NOWAIT 
		   
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
*	WAIT WINDOW '� � � � � � � � � � � � �  vid='+STR(c_te.vid)+' kko='+STR(m.kko)
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
      soder=SODER+' '+ALLTRIM(STR(M.KE,3))+' ������(�); ������ ' ;
      +allt(str(m.KA,2)) ;
      +'; Ra=';
      +ALLTRIM(STR(m.sh,5,2))+'; ��������� ������� �������� �������'
   endif
endif
do stroka_o
RETURN 
***************************************************************************************************
*********************************** ����� ������������� *******************************************

***************************************************************************************************
***********************************   *************************************
***************************************************************************************************

***************************************************************************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_a

m.buk 	= '�'
m.ceh 	= c_te.mar
m.oper   = c_te.nto
m.od		= ''
INSERT INTO ptt FROM memv
   
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_b
SELECT c_te
m.buk 	= '�'
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
m.buk = '�'
*!*	m.ss  = ' �OT � '+str(n_i,2)
INSERT INTO ptt FROM memv
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_o
*!*	WAIT WINDOW 'stroka_o'
if len(soder)>120
   stroka_1=substr(soder,1,119) 
   m.buk = '�'
	m.ss  = stroka_1
	INSERT INTO ptt FROM memv
   
   stroka_2=substr(soder,120)
   m.buk = '�'
	m.ss  = stroka_2
	INSERT INTO ptt FROM memv
ELSE
	m.buk = '�'
	m.ss  = soder
	INSERT INTO ptt FROM memv
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
PROCEDURE SWARKA
wait window ' ����� ������' nowa
	                                   
IF c_te.kto = 418
	SELECT kornd,naimd,nrmd,kol FROM KT WHERE poznd=c_te.poznd and d_u=1 or poznw=c_te.poznd AND d_u=2 ORDER BY kornd INTO CURSOR c_kt_kornd 
	soder = '�������������� ������(�������) ��� ������  � ���������������� �� ������� ����� �������� '
	m.buk = '�'
	m.ss  = soder
	INSERT INTO ptt FROM memv
	soder = ''
	SCAN
		soder = '���. '+ALLTRIM(c_kt_kornd.kornd)+ ' ' + ;
				ALLTRIM(c_kt_kornd.naimd)+ ' ' + ;
				ALLTRIM(STR(c_kt_kornd.nrmd,12,5))+ ' ' + ;
				ALLTRIM(STR(c_kt_kornd.kol,5))
		m.buk = '�'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
	ENDSCAN
	
	soder_t='T������ ������' 
  	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv
	soder_t='���������' 
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv	
	soder_t='����-�����' 
	m.buk = 'T'
	m.ss  = soder_t
	INSERT INTO ptt FROM memv					
   USE IN c_kt_kornd
ENDIF
IF c_te.kto = 130
	soder = '�������� ����������� ������ � ����������� � ��� ����������� ������� �� ������� �����������, ������� ������, ����� � ������ �� ������ �� ����� 30 ��.' 
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
	soder='���������� ������ ���. '+ALLTRIM(c_kt_kornd.kornd)+ ' ' + ;
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
	soder = '������� ���� ���� '+' ������ '+allt(STR(c_te.L1,6,3))+im_cw+' � ����� '+ALLTRIM(STR(c_te.shag,4)) ;
		+' ������� '+allt(str(c_te.ka,4,1))
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
		m.buk = '�'
		m.ss  = soder
		INSERT INTO ptt FROM memv
		soder = ''
	ENDSCAN
	use in c_kt_5
ENDIF 		
IF c_te.kto = 109
	IF INLIST(33,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15) ;
	   or INLIST(34,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
	   soder = '��������� ������� ��� � ����������� � ��� ����������� �� ����� �������������� �������'
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
		soder = '������� � ���������� ������� ���� ���������� � ������� ��������� � ��������� �������'
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
		soder = '�������� ��� �����'
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
		soder = '������� � ���������� ������� ���� ���������� � ������� ��������� � ��������� �������'
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
		soder = '�������� ��� �����'
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
	soder = '1. ��������� �������� ����������� ���� ���������, �������, �������, �������, ��������� � ������� �� �����������'
	DO stroka_o
	soder = '2. ��������� ������������ ������������ ���� ��������'
	DO stroka_o
	IF INLIST(6,te.us1,te.us2,te.us3,te.us4,te.us5,te.us6,te.us7,te.us8,te.us9,te.us10,te.us11,te.us12,te.us13,te.us14,te.us15)
		soder = '�������� ��� �����'
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
		soder = '�������� ��� �����'
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
		soder = '�������� ��� �����'
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
		soder = '�������� ��� �����'
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
		soder = '�������� ��� �����'
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
		soder = '1. ���������� ����������� ������� �� �������������� �����������, ��������� �� ������.'
		DO stroka_o
		soder = '2. ��������� ������� ����� '+ALLTRIM(STR(c_te.v,5,3))+' ���.�'
		DO stroka_o
		soder = '3. ��������� ������� � ����� � ������� 1 ����.'
		DO stroka_o
		soder = '4. ��������� ���������� ���� ���� ����� ������� ���� ���������'
		DO stroka_o
		soder = '5. ����� ���� �� ����������� �������'
		DO stroka_o
		soder = '6. �������� ������� �� �������� ����� �� �� ��������� ������� ������������ ������'
		DO stroka_o
	endif
ENDIF
*       ����� ������
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
 
	 