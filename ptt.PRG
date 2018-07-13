
on key label f12 retu 
priv mnaim,kod_izd
priv detup,detun
priv kuku
LOCAL DOSP_KOD,PASSED_VID
*!*	fl='pt.txt'
publ o[100]
public k[15]
public uslovi[15]
local mpozn,mshw,iribf,msim
priv mkttp
bil='nou'
bil60='nou'
do FORm f_IZD_vib TO mribf
SELECT * from izd WHERE RIBF=MRIBF INTO CURSOR c_izd

do form f_un with 'ПЕЧАТЬ СКВОЗНАЯ', 'ПЕЧАТЬ 1 ТЕХНОЛОГИИ' TO M_
if m_ = 0
   retu - 1
endif
*wait 'm_='+str(m_,2) wind
ppn=0
pn =0

forma='3 '
n_i=0
e_n_d='nou'
if m_=2
	forma='3 '
   PASSED_VID=''
   do fORM F_WIB_TP TO PASSED_VID
   *!*WITH PASSED_VID 
   *!*wait window ' POSLE DO FORM F_WIB_TP PASSED_VID='+PASSED_VID
   *!*SELE * FROM DOSP WHERE VID = 35 AND KOD = DOSP_KOD INTO CURS C_DOSP35 
   *browse
   mkttp=PASSED_VID
   
 	DLINA_KTTP=LEN(ALLTRIM(MKTTP))
*!*	 	wait window '!!!!!   mkttp='+mkttp+'    DLINA='+STR(DLINA_KTTP)
*!*	 RETU
   do form f_un with ' 1 ДЕТАЛЬ ',' ВСЕ ИЗДЕЛИЕ' to d_i
   if d_i=1
*!*	      kod_izd='ДП 1.5.02.00.00'
      do form f_ribf with c_izd.kod to mribf  
   endif
	if d_i=1
      wait window 'mribf='+mribf nowait 
      SELECT * FROM kt WHERE shw=c_izd.kod AND alltrim(poznd)==alltrim(mribf) AND !empt(mar1) AND d_u<3 INTO CURSOR C_KT
*!*	      WAIT WINDOW 'KT brow'
*!*	      brow
   ELSE
      SELECT * FROM kt WHERE ;
             shw=c_izd.kod ;
             AND !empt(mar1) ;
             AND d_u<3 ;
             INTO CURSOR C_KT
*!*	             WAIT WINDOW 'KT brow'
*!*			BROW
   endif
   
   if recc() = 0
      wait 'HET TAKOЙ ПOЗИЦИИ !!!' wind
      return - 1
   endif
   
   fl='pt.txt'

   WAIT WINDOW "!!!!!!!!!!!    Документ формируется...!!!!!!!!!!!!!!" && NOWAIT   
   
   set print to &fl
   set device to print
   select C_KT 
   
   SCAN ALL 
   
      if empt(C_KT.poznd)
         detup=C_KT.poznw
         detun=C_KT.naimw
      else
         detup=C_KT.poznd
         detun=C_KT.naimd
      endif
      
      sele KTTP,POZND from te where ;
           left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
           and alltrim(poznd)=alltrim(mribf) ; 
                      into curs C_TE
*!*	                      WAIT WINDOW 'TE brow'
*!*	                      brow
      if reccount() > 0
         use in c_te
         sele gr,sort,tm,dm,ps,naim from MATER ;
              where kodm = c_kt.kodm ;
              into curs C_MATER
*!*				WAIT WINDOW 'MATER brow'
*!*				BROW          
         mnaim=c_mater.naim
         kuku=allt(str(C_KT.ROZMA,6,1))
         if C_KT.ROZMB#0
            kuku=kuku+'x'+allt(str(C_KT.ROZMB,6,1))
         endif
         sele c_kt
         do forma_3
         ppn=0
         pn =0
         do ptp
*!*	         wait window ' do ptp ppn='+str(ppn)+' pn='+str(pn)
         if forma='3 '
            if ppn<33
               do while ppn<33
                  ppn=ppn+1
                  pn=pn+1
                  @prow()+1,0  say '|   |   |                                                                                    |'
               enddo
               do a
               do mok
            endif   
         else
            if pn<51
               do while pn<51
                  ppn=ppn+1
                  pn=pn+1
                  @prow()+1,0  say '|   |                                                                                |'
               enddo
               do moka
            endif
         endif
      else
         use in c_te
         wait window 'нет иформации в экономической базе по указанн_м технологии и детали'
         RETURN 
      endif
   ENDSCAN 
   use in c_kt
   use in c_mater
else                    && сквозная печать
   *wait ' сквозная печать ' wind
   do form f_un with ' 1 ДЕТАЛЬ ',' ВСЕ ИЗДЕЛИЕ' to d_i
   if empty(d_i) 
      retu-1
   endif
   
   if d_i=1
      do form f_ribf with c_izd.kod to mribf  
   endif
   
   if empty(mribf) 
      retu-1
   endif
 
   if d_i=1
      SELECT * FROM kt WHERE ;
             shw=c_izd.kod ;
             AND poznd=mribf ;
             AND !empt(mar1) ;
             AND d_u<3 ;
             INTO CURSOR C_KT
*!*	      WAIT WINDOW 'KT brow'
*!*			BROW
   ELSE
      SELECT * FROM kt WHERE ;
             shw=c_izd.kod ;
             AND !empt(mar1) ;
             AND d_u<3 ;
             INTO CURSOR C_KT
             WAIT WINDOW 'KT brow'
*!*			BROW
   endif
   if RECC() = 0
      wait 'HET ТАКОЙ ПОЗИЦИИ !!!' wind
      return-1 
   endif
   
   fl='pt.txt'
  
   WAIT WINDOW "Документ формируется..." NOWAIT   

   set print to &fl
   set device to print
   forma='3 '
   
   SCAN ALL 
   	arra m[20]
   	store 0 to m
		detup=poznd
      detun=naimd
      
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
      sele gr,sort,KODM,tm,dm,ps,naim from MATER ;
           where koDm = c_kt.kodm ;
           into curs C_MATER
      mnaim=c_mater.naim
      kuku=allt(str(C_KT.ROZMA,6,1))
      if C_KT.ROZMB#0
         kuku=kuku+'x'+allt(str(C_KT.ROZMB,6,1))
      endif
      sele C_KT
      
      forma='3 '
      do forma_3
      *wait ' l=233 pn =0 ' wind
      pn=0
      ppn=0
      mars=1
      do while mars<21
         *wait 'mars='+str(mars,4)+' m[mars]='+str(m[mars],4) wind
         if m[mars]#0
            sele * from TE where ;
                 mar=m[mars] ;
                 and poznd=C_KT.poznd ;
                 into curs C_TE
            go top
            mkttp=c_te.kttp
            if !empt(kttp)
               do ptp
            else
               *wait 'по детали '+c_kt.poznd+' и маршруту '+str(m[mars],4)+' пустой техпроцесс !!! ' wind
            endif
         endif
         mars=mars+1
      enddo
      if forma='3a'
         do while pn<51
            Pn =pn +1
            @prow()+1,0  say '| | |                                                                                |'
         enddo
         do moka
      else
         *wait 'kuku !!!' wind
         do while pn<33
            Pn =pn +1
            @prow()+1,0  say '|  |  |                                                                                 |'
            *wait window 'pn='+str(pn)
         enddo
         do a
         do mok
      endif
      
   ENDSCAN 
   use in c_kt
   use in c_mater
   use in c_te
endif
*wait 'endif forma='+forma+' pn='+str(pn,3) wind
*if forma='3a'
*   do while pn<52
*      Pn =pn +1
*      @prow()+1,0  say '| | |                                                                                 |'
*   enddo
*   do mok
*else
*   *wait 'kuku !!!' wind
*   do while pn<29
*      Pn =pn +1
*      @prow()+1,0  say '|  |  |                                                                                 |'
*   enddo
*   do a
*   do mok
*endif
SET PRIN TO 
set devi to scree
WAIT WINDOW "Формирование документа окончено." NOWAIT  
            loWord=CreateObject("Word.Application")       
            loWord.Application.visible=.T.
            WITH loWord
            	.Documents.open(sys(005)+sys(2003)+'\pt.txt',.f.,.t.,.f.,'','',.t.,'','',4,1251)
            	.DisplayAlerts=.F.
            ENDWITH 
            RELEASE loWord  
on key
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc ptp
WAIT WINDOW 'proc PTP'+mkttp
if left(mkttp,11)='06024.01271'
	DO F_GALWAN
ENDIF
if left(mkttp,11)='06024.50141'
	IF mkttp='06024.50141.00001'
		DO F_TOK_VINT
	ENDIF
	IF mkttp='06024.50141.00003'
		DO F_FREZA
	ENDIF
	IF mkttp='06024.50141.00004'
		DO F_K_S
	ENDIF
	IF mkttp='06024.50141.00005'
		DO F_P_S
	ENDIF
	IF mkttp='06024.50141.00024'
		DO F_W_S
	ENDIF
	IF mkttp='06024.50141.00025' or mkttp='06024.50141.00026' or mkttp='06024.50141.00027'
		DO F_Z_F
	ENDIF
ENDIF
if left(mkttp,11)='06024.55201'
ENDIF
if left(mkttp,11)='06024.55241'
	DO ZAGOT
ENDIF
if left(mkttp,11)='06024.55250'
	DO F_TERM
ENDIF
if left(mkttp,11)='06024.55265'
	DO SHTAMP
ENDIF
if left(mkttp,11)='06024.55273'
	DO OKRASKA
ENDIF
if left(mkttp,11)='06024.55290'
	IF mkttp='06024.55290.00011'
		DO SWARKA_KONT
	ELSE
		DO SWARKA
	ENDIF
ENDIF
***************	Г А Л Ь В А Н И К А *************************************************************
PROCEDURE F_GALWAN
wait 'proc F_GALWAN  ' wind
publ o[100]
store 0 to o
WAIT WINDOW 'BROW TE'
sele * FROM TE ;
          WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) and poznd=c_kt.poznd ;
          order BY NTO,NTP ;
          INTO CURS C_TE
brow 
go top
ind=1
if recc()=0
   wait 'mkttp'+mkttp+' c_kt.poznd'+c_kt.poznd+' нет иформации в TE' wind
   retu
ENDIF 
do while .not.eof()
   wait 'nto='+str(nto,3) wind
	ind=1
   do while nto#o[ind] OR o[ind]#0
      wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
      if o[ind]=nto
         exit
      endif
      if o[ind]=0 &&nto
         o[ind]=nto
         exit
      endif
      ind=ind+1
      if ind>100
         wait 'недостаточно памяти, надо расширить' wind
         exit
      endif
   enddo
   skip
enddo
ind=1
WAIT WINDOW 'do while o[ind]#0'
do while o[ind]#0
   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
   sele * FROM TE ;
           WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
           and poznd=c_kt.poznd ;
           and nto=o[ind] ;
           ORDER BY NTP ;
           INTO CURS C_TE 
	WAIT 'sele TE left(mkttp,DLINA_KTTP)='+left(mkttp,DLINA_KTTP)+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3) WIND
   sum  normw,tpz to itogt,itpz
   if ITOGT = 0
      wait 'нет в TE информации по операции '+left(mkttp,DLINA_KTTP)+' '+alltrim(c_kt.poznd)+' '+str(o[ind],4) wind
   else
      go top
      scat memv
      *wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto) 
		use in C_TE
      ikto=''
      WAIT WINDOW 'if m.kto#0'
      if m.kto#0
         sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
         if RECC()>0
            ikto=left(C_DOSP_7.im,20)
         else
            ikto=allt(str(m.kto,5))
            ikto=LEFT(ikto+' нет в DOSP vid 7',20)
         endif
         use in C_DOSP_7
      endif
      imarka=''
      inaim =''
      if !empt(m.kodo)
         sele marka,naim from obor where MARKA=m.kodo into curs c_obor
         if recc() > 0
            imarka=marka
            inaim =naim
         else
            imarka=m.kodo+space(3)
            inaim='нет в каталоге оборудов.'
         endif
         use in c_obor
      endif
      do stroka_b
      
   	ikodp=space(14)
	   if m.kodp#0
	      sele * FROM DOSP WHERE vid=5 and kod=m.kodp INTO CURS C_DOSP_5
   	   if RECC()>0
      	   ikodp=left(im,14)
	      else
   	      ikodp=allt(str(m.kodp,4))
      	   ikodp=rfix(ikodp+' нет в DOSP vid 5',14)
	      endif
   	   use in C_DOSP_5
	   endif 
   	do stroka_e
	   
     	select * FROM TE where left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                                and poznd=c_kt.poznd ;
                                and nto=o[ind] into cursor C_TE
	   sele C_TE
   	scat memv
   	*wait 'm.kto='+str(m.kto,4) wind
		if m.shag#0
         kuk=kuk+'M '+allt(str(m.D,6,2))
      endif
      if m.dbk#0
         if mvid=3 OR mvid=5
               kuk=kuk+' ДО P-PA '+allt(str(m.dbk,6,1))
         else
               kuk=kuk+' ДО ф '+allt(str(m.dbk,6,1))
         endif
      endif
   
      if m.toch#0
         kuk=kuk+' ДЛИНОЙ '+allt(str(m.toch,3))+';'
   	ENDIF
*!*	      if left(mkttp,11)#'06024.55273' AND left(mkttp,11)#'06024.01271' AND left(mkttp,11)#'06024.55250' 
   	   soder=KUK
      	do stroka_o
	      soder='ВЫДЕРЖАВ РАЗМЕРЫ:'
   	   do stroka_o
*!*		   endif
   	sele c_te
	   go top
   	do while .not.eof() 
      	scat memv
	      KUKA=' '
   	   IF m.thisform.d#0 or m.RR2#0 or m.dbk#0 or m.toch#0
            KUKA=kuka+IIF(m.toch#0,allt(STR(m.toch,6,1)),'');
                     +IIF(m.thisform.d#0,allt(STR(m.thisform.d,6,1)),'');
                     +IIF(!empt(m.toCH1),' +'+allt(m.toCH1),'');
                     +IIF(!empt(m.toCH11),' '+allt(m.toCH11),'') ;
                                                +IIF(!empt(m.thisform.d),' ; ','')

            KUKA=kuka+IIF(m.rr2#0,' '+allt(STR(thisform.ds,6,1)),'');
                     +IIF(!empt(m.toCH2),'+'+allt(m.toCH2),'');
                     +IIF(!empt(m.toCH21),' '+allt(m.toCH21),'')
            KUKA=kuka+IIF(m.dbk#0,'; '+allt(STR(m.dbk,6,1)),'');
                     +IIF(!empt(m.toCD1),'+'+allt(m.toCd1),'');
                     +IIF(!empt(m.toCd11),' '+allt(m.toCd11),'')
         if m.sh#0
            if m.sh=>10
                  kuka=kuka+'; Rz '+allt(str(m.sh,7,3))
            else
                  kuka=kuka+'; Ra '+allt(str(m.sh,7,3))
            endif
         endif
         soder=KUKa
         do stroka_o
         sele c_te
      	skip
   	enddo
	   sele c_te
   	go top
	endif

   sele DIST KODI FROM TE WHERE ;
                           left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                           and poznd=c_kt.poznd ;
                           and nto=o[ind] ;
                           AND KODI<>0 ;
                           INTO CURS ire
   SCAN
      ikodir=''
      select KODI, IM, PRI from INSTR ;
                WHERE kodi=ire.KODI and pri=1 ;
                into cursor C_KODI
         *BROW
		         
      if RECC() > 0
      	SCAN
            ikodir=im
            soder_t=allt(ikodir)
            do stroka_t
			ENDSCAN         
      else
         ikodir='реж.инструм-та '+allt(str(ire.kodi,3))+' нет в INSTR '
		ENDIF
      use in C_KODI
   endscan
   use in IRE
      
   select DIST KODIM from TE where ;
                           left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                           and poznd=c_kt.poznd ;
                           and nto=o[ind] ;
                           AND KODIM<>0 ;
                           into cursor IME
   SCAN
      ikodim=''
      select KODI,PRI,IM FROM INSTR ;
              WHERE kodi=ime.kodim and pri=2 ;
              INTO CURS C_KODIM
			       
      if RECC()>0
			SCAN	       
               ikodim=im
               soder_t=allt(ikodim)
               do stroka_t
         ENDSCAN 
      else
         ikodim='мерит.инструм-та '+allt(str(ime.kodim,3))+' нет в INSTR '
		endif
		        
      use in C_KODIM
   endscan
   use in ime
   select DIST KODID from TE where ;
               left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                           and poznd=c_kt.poznd ;
                           and nto=o[ind] ;
                           AND KODID<>0 ;
                           into cursor IDO
   SCAN
          ikodid=''
           select KODI,PRI,IM from INSTR ;
              WHERE kodi=ido.KODId and pri=3 ;
              into cursor C_KODID
           
	           if RECC()>0
 	              SCAN
							ikodid=im
   	           		soder_t=allt(ikodid)
   	           		do stroka_t
   	           ENDSCAN
	           else
	             ikodid='доп.инструм-та '+allt(str(ido.kodi,3))+' нет в INSTR '
	           endif
 	        
 	        use in C_KODID
   endscan
   use in ido
   ind=ind+1
ENDDO 
RETURN 
***********************************КОНЕ ГАЛЬВАНИКИ*************************************************
***************************************************************************************************

********************************** Т О К А Р Н Ы Е ************************************************
PROCEDURE F_TOK_VINT
store 0 to o
*!*	WAIT WINDOW 'BROW TE'
sele * FROM TE ;
       WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) and poznd=c_kt.poznd ;
       order BY NTO,NTP ;
       INTO CURS C_TE
*!*	brow 
itpz=0
SUM c_te.tpz to itpz
go top
ind=1
if recc()=0
   wait 'mkttp'+mkttp+' c_kt.poznd'+c_kt.poznd+' нет иформации в TE' wind
   RETURN 
ENDIF 
do while .not.eof()
   wait 'nto='+str(nto,3) wind
   ind=1
   do while nto#o[ind] OR o[ind]#0
*!*	      wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
      if o[ind]=nto
         exit
      endif
      if o[ind]=0 &&nto
         o[ind]=nto
         exit
      endif
      ind=ind+1
      if ind>100
         wait 'недостаточно памяти, надо расширить' wind
         exit
      endif
   enddo
   skip
enddo
ind=1
*!*	WAIT WINDOW 'do while o[ind]#0'
do while o[ind]#0
*!*	   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
   sele * FROM TE ;
        WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        ORDER BY NTP ;
        INTO CURS C_TE 
*!*	   	   WAIT 'sele TE left(mkttp,DLINA_KTTP)='+left(mkttp,DLINA_KTTP)+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3) WIND
   sum  normw,tpz to itogt,itpz
   if ITOGT = 0
      wait 'нет в TE информации по операции '+left(mkttp,DLINA_KTTP)+' '+alltrim(c_kt.poznd)+' '+str(o[ind],4) wind
   else
	   go top
   	DO WHILE !EOF()
   		scat memv
	   	*wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto) 
	
		   ikto=''
	   	
		   if m.kto#0
	   	   sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
	      	if RECC()>0
	         	ikto=left(C_DOSP_7.im,20)
		      else
	   	      ikto=allt(str(m.kto,5))
	      	   ikto=LEFT(ikto+' нет в DOSP vid 7',20)
		      endif
	   	   use IN C_DOSP_7
		   endif
	   	imarka=''
		   inaim =''
	   	if !empt(m.kodo)
	      	sele marka,naim from obor where MARKA=m.kodo into curs c_obor
		      if recc() > 0
	   	      imarka=marka
	      	   inaim =naim
		      else
	   	      imarka=m.kodo+space(3)
	      	   inaim='нет в каталоге оборудов.'
		      endif
	   	   use in c_obor
		   endif
	   	do stroka_b
			IF m.ntp = 1
		      sele * FROM DOSP WHERE vid=7 and kod=m.kto into curs c_dosp7
		      niot=''
		      if recc()>0
		         niot=ALLTRIM(c_dosp7.im)
		      endif
		      use in c_dosp7
		      do stroka_g
				do stroka_d
		   	ikodp=space(14)
			   if m.kodp#0
		   	   sele * FROM DOSP WHERE vid=5 and kod=m.kodp INTO CURS C_DOSP_5
		      	if RECC()>0
			         ikodp=left(im,14)
		   	   else
		      	   ikodp=allt(str(m.kodp,4))
		         	ikodp=rfix(ikodp+' нет в DOSP vid 5',14)
			      endif
		   	   use in C_DOSP_5
			   endif 
		   	do stroka_e
	  		endif
		   *wait 'm.kto='+str(m.kto,4) wind
	   	KUK=''
		   *wait 'm.kttp='+m.kttp wind
			msim=''
		   mvid=1
	  		if m.kko#0
	      	sele * from pt where vid=mvid and kko=m.kko into curs c_pt
		      go top
	   	   if .not.eof()
	     		   msim=allt(im)
		 	   else
	  	         msim=''
	   	   endif
	      	use in c_pt 
		   ENDIF
		   IF m.ntp=1
			   sele * FROM DOSP WHERE vid=31 and US=1 INTO CURS C_DOSP31
	      	if RECC()>0
		         SODER=ALLTRIM(im)+''+ALLTRIM(SIM)
	   	   else
	         	SODER=' нет в DOSP vid 31 US 1'
		      ENDIF
		      do stroka_o
	   	   use in C_DOSP31
		   ENDIF 
		   soder=ALLT(STR(M.NTP))+'.'+MSIM
*!*		   	do stroka_o
			KUK=SODER
			if m.shag#0
	      	kuk=kuk+'M '+allt(str(m.D,6,2))
		   endif
	   	if m.shag#0
	         kuk=kuk+'M '+allt(str(m.D,6,2))+';'
		   else
	   		kuk=kuk+' Ф '+allt(str(m.d,6,2))+';'
		   endif
			if m.dbk#0
	         kuk=kuk+' до Ф '+allt(str(m.dbk,6,1))+';'
		   endif
	   	if m.toch#0
	      	kuk=kuk+' длиной '+allt(str(m.toch,3))+';'
		   ENDIF
	  		soder=KUK
		   do stroka_o
			soder='выдержавая размеры: '
		   do stroka_o
	   	KUKA=' '
*!*				IF thisform.d#0 or thisform.ds#0 or m.dbk#0 or m.toch#0
*!*		   	   KUKA=kuka+IIF(m.toch#0,allt(STR(m.toch,6,1)),'');
*!*		               +IIF(m.thisform.d#0,allt(STR(m.thisform.d,6,1)),'');
*!*		               +IIF(!empt(m.toCH1),' +'+allt(m.toCH1),'');
*!*		               +IIF(!empt(m.toCH11),' '+allt(m.toCH11),'') ;
*!*		                                          +IIF(!empt(m.thisform.d),' ; ','')
*!*		      	KUKA=kuka+IIF(thisform.ds#0,' '+allt(STR(thisform.ds,6,1)),'');
*!*		               +IIF(!empt(m.toCH2),'+'+allt(m.toCH2),'');
*!*		               +IIF(!empt(m.toCH21),' '+allt(m.toCH21),'')
*!*			      KUKA=kuka+IIF(m.dbk#0,'; '+allt(STR(m.dbk,6,1)),'');
*!*		               +IIF(!empt(m.toCD1),'+'+allt(m.toCd1),'');
*!*		               +IIF(!empt(m.toCd11),' '+allt(m.toCd11),'')
		   IF m.dbk#0 or m.toch#0
	   	   KUKA=kuka+'Ф'+ALLTRIM(STR(m.dbk,6,2))+' '+allt(m.tocd1)+' '+ALLTRIM(m.tocd11);
	               +'; L='+ALLTRIM(STR(m.toch,6,2))+' '+allt(m.toch1)+' '+allt(toch11);
	              +'; У='+ALLTRIM(STR(m.ug))+'; r='+ALLTRIM(STR(m.rad,5,1)) ;
	                                          +'; s='+ALLTRIM(STR(m.shag,6,2))
	                                          
			   if m.sh#0
	      	   if m.sh=>10
	            	kuka=kuka+'; Rz '+allt(str(m.sh,7,3))
	         	else
		            kuka=kuka+'; Ra '+allt(str(m.sh,7,3))
	   	      endif
	      	endif
		   	soder=KUKa
			   do stroka_o
		   ENDIF
	    
	   	sele DIST KODI FROM TE WHERE ;
	                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
	                        and poznd=c_kt.poznd ;
	                        and nto=o[ind] ;
	                        AND KODI<>0 ;
	                        INTO CURS ire
		  	SCAN
	   	   ikodir=''
		      select KODI, IM, PRI from INSTR ;
	             WHERE kodi=ire.KODI and pri=1 ;
	             into cursor C_KODI
	      	*BROW
			   if RECC() > 0
	   	   	SCAN
	      		   ikodir=im
	   	   	   soder_t=allt(ikodir)
		         	do stroka_t
					ENDSCAN         
	   	   else
	   		   ikodir='реж.инструм-та '+allt(str(ire.kodi,3))+' нет в INSTR '
				ENDIF
	   	   use in C_KODI
		   endscan
			use in IRE
			select DIST KODIM from TE where ;
	                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
	                        and poznd=c_kt.poznd ;
	                        and nto=o[ind] ;
	                        AND KODIM<>0 ;
	                        into cursor IME
			SCAN
	      	ikodim=''
		      select KODI,PRI,IM FROM INSTR ;
	           WHERE kodi=ime.kodim and pri=2 ;
	           INTO CURS C_KODIM
				if RECC()>0
					SCAN	       
	         	   ikodim=im
		            soder_t=allt(ikodim)
	   	         do stroka_t
	      	   ENDSCAN 
		      else
	   	   	ikodim='мерит.инструм-та '+allt(str(ime.kodim,3))+' нет в INSTR '
				endif
			   use in C_KODIM
	   	endscan
		   use in ime
			select DIST KODID from TE where ;
	            left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
	                        and poznd=c_kt.poznd ;
	                        and nto=o[ind] ;
	                        AND KODID<>0 ;
	                        into cursor IDO
			SCAN
	   	   ikodid=''
	      	select KODI,PRI,IM from INSTR ;
	           WHERE kodi=ido.KODId and pri=3 ;
	           into cursor C_KODID
		      if RECC()>0
	 		      SCAN
						ikodid=im
		     			soder_t=allt(ikodid)
		     			do stroka_t
			      ENDSCAN
	   	   else
	      	   ikodid='доп.инструм-та '+allt(str(ido.kodi,3))+' нет в INSTR '
		      endif
	 		   use in C_KODID
			endscan
			use in ido
		
	      if m.sh#0
	         soder_t='ОБРАЗЦЫ ШЕРОХОВАТОСТИ ГОСТ 9378-75'
	         do stroka_t
	   	endif
	   
     		sele c_te
      	SKIP
      enddo
   ENDIF 
   USE IN C_TE 
   ind=ind+1
enddo

RETURN 

*********************************** КОНЕЦ ТОКАРНО-ВИНТОРЕЗНОЙ *************************************
***************************************************************************************************
*********************************** Ф Р Е З Е Р Н Ы Е *********************************************
PROCEDURE F_FREZA
store 0 to o
WAIT WINDOW 'frezerni BROW TE'
sele * FROM TE ;
       WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) and poznd=c_kt.poznd ;
       order BY NTO,NTP ;
       INTO CURS C_TE
brow 
go top
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
         o[ind]=nto
         exit
      endif
      ind=ind+1
      if ind>100
         wait 'недостаточно памяти, надо расширить' wind
         exit
      endif
   enddo
   skip
enddo
ind=1
*!*	WAIT WINDOW 'do while o[ind]#0'
do while o[ind]#0
*!*	   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
   sele * FROM TE ;
        WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        ORDER BY NTP ;
        INTO CURS C_TE 
   	   WAIT 'sele TE left(mkttp,DLINA_KTTP)='+left(mkttp,DLINA_KTTP) ;
   	   											+' c_kt.poznd='+c_kt.poznd ;
   	   											+' O='+str(O[IND],3) ;
   	   											WIND
   		
   sum  normw,tpz to itogt,itpz
   if ITOGT = 0
      wait 'нет в TE информации по операции '+left(mkttp,DLINA_KTTP) ;
      												+' '+alltrim(c_kt.poznd) ;
      												+' '+str(o[ind],4) wind
   else
   go top
   scat memv
   *wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto) 
	use in C_TE
   ikto=''
   WAIT WINDOW 'if m.kto#0'
   if m.kto#0
      sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
      if RECC()>0
         ikto=left(C_DOSP_7.im,20)
      else
         ikto=allt(str(m.kto,5))
         ikto=LEFT(ikto+' нет в DOSP vid 7',20)
      endif
      use in C_DOSP_7
   endif
   imarka=''
   inaim =''
   if !empt(m.kodo)
      sele marka,naim from obor where MARKA=m.kodo into curs c_obor
      if recc() > 0
         imarka=marka
         inaim =naim
      else
         imarka=m.kodo+space(3)
         inaim='нет в каталоге оборудов.'
      endif
      use in c_obor
   endif
   do stroka_b
   WAIT WINDOW 'мехобработка FREZ BROW DOSP'
   sele * FROM DOSP WHERE vid=7 and kod=m.kto into curs c_dosp7
   BROW
   niot=''
   if recc()>0
      niot=obor
   endif
   use in c_dosp7
   do stroka_g
	do stroka_d
          
   ikodp=space(14)
   if m.kodp#0
      sele * FROM DOSP WHERE vid=5 and kod=m.kodp INTO CURS C_DOSP_5
      if RECC()>0
         ikodp=left(im,14)
      else
         ikodp=allt(str(m.kodp,4))
         ikodp=rfix(ikodp+' нет в DOSP vid 5',14)
      endif
      use in C_DOSP_5
   endif 
   do stroka_e
   WAIT WINDOW 'мехобработка FREZA ='+MKTTP
   select * FROM TE where left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                          and poznd=c_kt.poznd ;
                          and nto=o[ind] into cursor C_TE
	sele C_TE
   *   brow
   scat memv
   *wait 'm.kto='+str(m.kto,4) wind
   KUK=''
   mvid=3
  	if m.kto#0
      sele * from pt where vid=mvid and kko=m.kko into curs c_pt
      go top
      if .not.eof()
   	   msim=allt(im)
	   else
         msim=''
      endif
      use in c_pt 
   endif
	if m.toch # 0
      kuk=kuk+' ФРЕЗЕРОВАТЬ '+iif(m.ip>1,Allt(str(m.ip,2))+' '+MSIM,'')+' C P-PA ' +allt(str(m.D,2))
   endif
   if m.shag#0
      kuk=kuk+'M '+allt(str(m.D,6,2))
   endif
   if m.dbk#0
      kuk=kuk+' ДО P-PA '+allt(str(m.dbk,6,1))
	ENDIF
   if m.toch#0
      kuk=kuk+' ДЛИНОЙ '+allt(str(m.toch,3))+';'
   ENDIF
   if m.ds#0
         kuk=kuk+' ШИРИНОЙ '+allt(str(m.ds,5))+';'
   ENDIF
    
   soder=KUK
   do stroka_o
	soder='ВЫДЕРЖАВ РАЗМЕРЫ:'
   do stroka_o
   
   sele c_te
	go top
   do while .not.eof() 
      scat memv
      KUKA=' '
   	IF m.RR1#0 or m.RR2#0 or m.dbk#0 or m.toch#0
         KUKA=kuka+IIF(m.toch#0,allt(STR(m.toch,6,1)),'');
                  +IIF(m.rr1#0,allt(STR(m.rr1,6,1)),'');
                  +IIF(!empt(m.toCH1),' +'+allt(m.toCH1),'');
                  +IIF(!empt(m.toCH11),' '+allt(m.toCH11),'') ;
                                             +IIF(!empt(m.RR1),' ; ','')
         KUKA=kuka+IIF(m.rr2#0,' '+allt(STR(m.rr2,6,1)),'');
                  +IIF(!empt(m.toCH2),'+'+allt(m.toCH2),'');
                  +IIF(!empt(m.toCH21),' '+allt(m.toCH21),'')
         KUKA=kuka+IIF(m.dbk#0,'; '+allt(STR(m.dbk,6,1)),'');
                  +IIF(!empt(m.toCD1),'+'+allt(m.toCd1),'');
                  +IIF(!empt(m.toCd11),' '+allt(m.toCd11),'')
   	   if m.sh#0
	         if m.sh=>10
               kuka=kuka+'; Rz '+allt(str(m.sh,7,3))
            else
               kuka=kuka+'; Ra '+allt(str(m.sh,7,3))
            endif
         endif
      	soder=KUKa
   	   do stroka_o
	   ENDIF
      sele c_te
      skip
   enddo
   sele c_te
	go top
	sele DIST KODI FROM TE WHERE ;
                           left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                           and poznd=c_kt.poznd ;
                           and nto=o[ind] ;
                           AND KODI<>0 ;
                           INTO CURS ire
   SCAN
	   ikodir=''
      select KODI, IM, PRI from INSTR ;
                WHERE kodi=ire.KODI and pri=1 ;
                into cursor C_KODI
      *BROW
	   if RECC() > 0
      	SCAN
      	   ikodir=im
   	      soder_t=allt(ikodir)
	         do stroka_t
			ENDSCAN         
      else
   	   ikodir='реж.инструм-та '+allt(str(ire.kodi,3))+' нет в INSTR '
		ENDIF
      use in C_KODI
   endscan
	use in IRE
	select DIST KODIM from TE where ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODIM<>0 ;
                        into cursor IME
	SCAN
      ikodim=''
      select KODI,PRI,IM FROM INSTR ;
           WHERE kodi=ime.kodim and pri=2 ;
           INTO CURS C_KODIM
		if RECC()>0
			SCAN	       
            ikodim=im
            soder_t=allt(ikodim)
            do stroka_t
         ENDSCAN 
      else
      	ikodim='мерит.инструм-та '+allt(str(ime.kodim,3))+' нет в INSTR '
		endif
	   use in C_KODIM
   endscan
   use in ime
	select DIST KODID from TE where ;
               left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                           and poznd=c_kt.poznd ;
                           and nto=o[ind] ;
                           AND KODID<>0 ;
                           into cursor IDO
	SCAN
   ikodid=''
   select KODI,PRI,IM from INSTR ;
             WHERE kodi=ido.KODId and pri=3 ;
             into cursor C_KODID
           
      if RECC()>0
         SCAN
				ikodid=im
  	     		soder_t=allt(ikodid)
  	     		do stroka_t
  	      ENDSCAN
      else
         ikodid='доп.инструм-та '+allt(str(ido.kodi,3))+' нет в INSTR '
      endif
      use in C_KODID
  	endscan
  	use in ido
		
   if m.sh#0
      soder_t='ОБРАЗЦЫ ШЕРОХОВАТОСТИ ГОСТ 9378-75'
      do stroka_t
   endif
    	  
   ind=ind+1
enddo

RETURN 
************************************КОНЕЦ ФРЕЗЕРНЫХ************************************************
 
***************************************************************************************************
*********************************** К Р У Г ЛО - Ш Л И Ф О В А Л Ь Н Ы Е **************************
PROCEDURE  F_K_S
store 0 to o
WAIT WINDOW 'BROW TE KRUGLO-SHLIF'
sele * FROM TE ;
       WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) and poznd=c_kt.poznd ;
       order BY NTO,NTP ;
       INTO CURS C_TE
*!*	brow 
go top
ind=1
if recc()=0
*!*	   wait 'mkttp'+mkttp+' c_kt.poznd'+c_kt.poznd+' нет иформации в TE' wind
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
         o[ind]=nto
         exit
      endif
      ind=ind+1
      if ind>100
         wait 'недостаточно памяти, надо расширить' wind
         exit
      endif
   enddo
   skip
enddo
ind=1
*!*	WAIT WINDOW 'do while o[ind]#0'
do while o[ind]#0
   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
   sele * FROM TE ;
        WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        ORDER BY NTP ;
        INTO CURS C_TE 
   	  WAIT 'sele TE left(mkttp,DLINA_KTTP)='+left(mkttp,DLINA_KTTP)+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3) WIND
   sum  normw,tpz to itogt,itpz
   if ITOGT = 0
      wait 'нет в TE информации по операции '+left(mkttp,DLINA_KTTP)+' '+alltrim(c_kt.poznd)+' '+str(o[ind],4) wind
   else
   	go top
	   scat memv
   	*wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto) 
		use in C_TE
   	ikto=''
*!*		   WAIT WINDOW 'if m.kto#0'
   	if m.kto#0
      	sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
	      if RECC()>0
   	      ikto=left(C_DOSP_7.im,20)
      	else
         	ikto=allt(str(m.kto,5))
	         ikto=LEFT(ikto+' нет в DOSP vid 7',20)
   	   endif
      	use in C_DOSP_7
	   endif
   	imarka=''
	   inaim =''
   	if !empt(m.kodo)
      	sele marka,naim from obor where MARKA=m.kodo into curs c_obor
	      if recc() > 0
   	      imarka=marka
      	   inaim =naim
	      else
   	      imarka=m.kodo+space(3)
      	   inaim='нет в каталоге оборудов.'
	      endif
   	   use in c_obor
	   endif
   	do stroka_b
*!*				WAIT WINDOW 'штамповка или слесарка или мехобработка BROW DOSP'
   	sele * FROM DOSP WHERE vid=7 and kod=m.kto into curs c_dosp7
      BROW
	   niot=''
   	if recc()>0
         niot=obor
	   endif
   	use in c_dosp7
      do stroka_g
		do stroka_d
	           
   	ikodp=space(14)
	   if m.kodp#0
   	   sele * FROM DOSP WHERE vid=5 and kod=m.kodp INTO CURS C_DOSP_5
      	if RECC()>0
	         ikodp=left(im,14)
   	   else
      	   ikodp=allt(str(m.kodp,4))
	         ikodp=rfix(ikodp+' нет в DOSP vid 5',14)
   	   endif
      	use in C_DOSP_5
	   endif 
   	do stroka_e
*!*		   WAIT WINDOW 'мехобработка KRUGLO-SHLIF ='+MKTTP
   	if m.kku#0
      	IF MKTTP='06024.50141.00004'			&&	kruglo shlif
         	sele * FROM DOSP WHERE vid=31 and kod=m.kku and us=4 INTO CURS C_DOSP_31
*!*		         WAIT WINDOW 'DOSP 31  US=4 BROW'
   	      if RECC()>0
      	      soder=alltrim(C_DOSP_31.IM)+alltrim(C_DOSP_31.SIM)
         	   do stroka_o
*!*	            	WAIT WINDOW '!!!!!!!!!!!!!!!!!!!!do stroka_o'+soder
	         else
   	         soder='по ККУ '+allt(str(m.kku,5))+' нет информации в DOSP'
      	      do stroka_o
         	endif
	         use in C_DOSP_31
			ENDIF	              
   	ENDIF
		select * FROM TE where left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                          and poznd=c_kt.poznd ;
                          and nto=o[ind] into cursor C_TE
		sele C_TE
   	*   brow
	   scat memv
   	*wait 'm.kto='+str(m.kto,4) wind
   	
   	KUK=''
      *wait 'm.kttp='+m.kttp wind
		if left(m.kttp,11)='06024.50141'
   	   msim=''
	   endif
	   mvid=4
  		if m.kto#0
      	sele * from pt where vid=mvid and kko=m.kko into curs c_pt
         go top
	      if .not.eof()
   		   msim=allt(im)
	   	else
         	msim=''
         endif
	      use in c_pt 
   	endif
		if m.shag#0
      	kuk=kuk+'M '+allt(str(m.D,6,2))
      endif
	   if m.dbk#0
		   kuk=kuk+' ДО ф '+allt(str(m.dbk,6,1))
      endif
     
   ENDIF
   
   if m.toch#0
      kuk=kuk+' ДЛИНОЙ '+allt(str(m.toch,3))+';'
   ENDIF
      
	soder=KUK
	do stroka_o
   soder='ВЫДЕРЖАВ РАЗМЕРЫ:'
   do stroka_o
  
   sele c_te
	go top
	do while .not.eof() 
      scat memv
      KUKA=' '
   	IF m.RR1#0 or m.RR2#0 or m.dbk#0 or m.toch#0
         KUKA=kuka+IIF(m.toch#0,allt(STR(m.toch,6,1)),'');
                     +IIF(m.rr1#0,allt(STR(m.rr1,6,1)),'');
                     +IIF(!empt(m.toCH1),' +'+allt(m.toCH1),'');
                     +IIF(!empt(m.toCH11),' '+allt(m.toCH11),'') ;
                                                +IIF(!empt(m.RR1),' ; ','')
         KUKA=kuka+IIF(m.rr2#0,' '+allt(STR(m.rr2,6,1)),'');
                    +IIF(!empt(m.toCH2),'+'+allt(m.toCH2),'');
                     +IIF(!empt(m.toCH21),' '+allt(m.toCH21),'')
         KUKA=kuka+IIF(m.dbk#0,'; '+allt(STR(m.dbk,6,1)),'');
                     +IIF(!empt(m.toCD1),'+'+allt(m.toCd1),'');
                     +IIF(!empt(m.toCd11),' '+allt(m.toCd11),'')
     	   if m.sh#0
            if m.sh=>10
                  kuka=kuka+'; Rz '+allt(str(m.sh,7,3))
	         else
                 kuka=kuka+'; Ra '+allt(str(m.sh,7,3))
            endif
         endif
         soder=KUKa
      	do stroka_o
   	ENDIF
	   sele c_te
      skip
   enddo
   USE IN c_te
       
   sele DIST KODI FROM TE WHERE ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODI<>0 ;
                        INTO CURS ire
  	SCAN
      ikodir=''
      select KODI, IM, PRI from INSTR ;
             WHERE kodi=ire.KODI and pri=1 ;
             into cursor C_KODI
      *BROW
	   if RECC() > 0
      	SCAN
      	   ikodir=im
   	      soder_t=allt(ikodir)
	         do stroka_t
			ENDSCAN         
      else
   	   ikodir='реж.инструм-та '+allt(str(ire.kodi,3))+' нет в INSTR '
		ENDIF
      use in C_KODI
   endscan
	use in IRE
	select DIST KODIM from TE where ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODIM<>0 ;
                        into cursor IME
	SCAN
      ikodim=''
      select KODI,PRI,IM FROM INSTR ;
           WHERE kodi=ime.kodim and pri=2 ;
           INTO CURS C_KODIM
		if RECC()>0
			SCAN	       
            ikodim=im
            soder_t=allt(ikodim)
            do stroka_t
         ENDSCAN 
      else
      	ikodim='мерит.инструм-та '+allt(str(ime.kodim,3))+' нет в INSTR '
		endif
	   use in C_KODIM
   endscan
   use in ime
	select DIST KODID from TE where ;
            left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODID<>0 ;
                        into cursor IDO
	SCAN
      ikodid=''
      select KODI,PRI,IM from INSTR ;
           WHERE kodi=ido.KODId and pri=3 ;
           into cursor C_KODID
        
      if RECC()>0
 	         SCAN
				ikodid=im
	     		soder_t=allt(ikodid)
	     		do stroka_t
	      ENDSCAN
      else
         ikodid='доп.инструм-та '+allt(str(ido.kodi,3))+' нет в INSTR '
      endif
 	   use in C_KODID
	endscan
	use in ido
	
   if m.sh#0
      soder_t='ОБРАЗЦЫ ШЕРОХОВАТОСТИ ГОСТ 9378-75'
      do stroka_t
   endif
   ind=ind+1
enddo

RETURN 
***************************************************************************************************
*********************************** КОНЕЦ К Р У Г ЛО - Ш Л И Ф О В А Л Ь Н Ы Е ********************


***************************************************************************************************
*********************************** П Л О С К О - Ш Л И Ф О В А Л Ь Н Ы Е *************************
***************************************************************************************************
PROCEDURE F_P_S
store 0 to o
WAIT WINDOW ' PLOSKA SHLIF BROW TE'
sele * FROM TE ;
       WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) and poznd=c_kt.poznd ;
       order BY NTO,NTP ;
       INTO CURS C_TE
brow 
go top
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
         o[ind]=nto
         exit
      endif
      ind=ind+1
      if ind>100
         wait 'недостаточно памяти, надо расширить' wind
         exit
      endif
   enddo
   skip
enddo
ind=1
*!*	WAIT WINDOW 'do while o[ind]#0'
do while o[ind]#0
   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
   sele * FROM TE ;
        WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        ORDER BY NTP ;
        INTO CURS C_TE 
*!*	   	  WAIT 'sele TE left(mkttp,DLINA_KTTP)='+left(mkttp,DLINA_KTTP)+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3) WIND
   sum  normw,tpz to itogt,itpz
   if ITOGT = 0
      wait 'нет в TE информации по операции '+left(mkttp,DLINA_KTTP)+' '+alltrim(c_kt.poznd)+' '+str(o[ind],4) wind
   else
   	go top
	   scat memv
   	*wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto) 
		use in C_TE
   	ikto=''
	   if m.kto#0
      	sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
	      if RECC()>0
   	      ikto=left(C_DOSP_7.im,20)
      	else
         	ikto=allt(str(m.kto,5))
	         ikto=LEFT(ikto+' нет в DOSP vid 7',20)
   	   endif
      	use in C_DOSP_7
	   endif
   	imarka=''
	   inaim =''
   	if !empt(m.kodo)
      	sele marka,naim from obor where MARKA=m.kodo into curs c_obor
	      if recc() > 0
   	      imarka=marka
      	   inaim =naim
	      else
   	      imarka=m.kodo+space(3)
      	   inaim='нет в каталоге оборудов.'
	      endif
   	   use in c_obor
	   endif
   	do stroka_b
          
*!*			WAIT WINDOW 'штамповка или слесарка или мехобработка BROW DOSP'
	   sele * FROM DOSP WHERE vid=7 and kod=m.kto into curs c_dosp7
*!*	   	BROW
      niot=''
	   if recc()>0
   	   niot=obor
      endif
	   use in c_dosp7
   	do stroka_g
		do stroka_d
	   ikodp=space(14)
	   if m.kodp#0
   	   sele * FROM DOSP WHERE vid=5 and kod=m.kodp INTO CURS C_DOSP_5
      	if RECC()>0
	         ikodp=left(im,14)
   	   else
      	   ikodp=allt(str(m.kodp,4))
         	ikodp=rfix(ikodp+' нет в DOSP vid 5',14)
	      endif
   	   use in C_DOSP_5
	   endif 
   	do stroka_e
*!*	   	WAIT WINDOW 'мехобработка='+MKTTP
*!*	      if m.kku#0
*!*	         WAIT WINDOW ' PLOSKA SHLIF m.kku='+STR(m.kku)+'brow DOSP 31 US=5'
*!*		      sele * FROM DOSP WHERE vid=31 and kod=m.kku and us=5 INTO CURS C_DOSP_31
*!*	        	BROW
*!*		      if RECC()>0
*!*	   	     	soder=alltrim(C_DOSP_31.IM)+' '+alltrim(C_DOSP_31.SIM)+ALLTRIM(STR(M.KOB))+'детали(й) '
*!*	        	   do stroka_o
*!*					sele * FROM DOSP WHERE vid=30 and kod=m.kku and us=5 INTO CURS C_DOSP_30
*!*	   	  	   WAIT WINDOW 'DOSP 30  US=5 BROW'
*!*		        	soder=alltrim(C_DOSP_30.IM)+' '+ALLTRIM(STR(M.IP))+' поверхность(й)'
*!*		         do stroka_o
*!*	   	   else
*!*	           	soder='по ККУ '+allt(str(m.kku,5))+' нет информации в DOSP'
*!*	      	   do stroka_o
*!*	        	endif
*!*		      use in C_DOSP_30
*!*			   use in C_DOSP_31
*!*			ENDIF
	   select * FROM TE where left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                          and poznd=c_kt.poznd ;
                          and nto=o[ind] into cursor C_TE
		sele C_TE
   	*   brow
	   scat memv
   	*wait 'm.kto='+str(m.kto,4) wind
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
	   soder='выдержав размеры: '+ALLTRIM(STR(dbk,6,2))+ALLTRIM(tocd1)+ALLTRIM(tocd11) ;
   	  		+'; '+ALLTRIM(STR(dbk,6,2))+ALLTRIM(toch1)+ALLTRIM(toch11)
	   do stroka_o
	   
	ENDIF 
	USE IN c_te
    
   sele DIST KODI FROM TE WHERE ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODI<>0 ;
                        INTO CURS ire
  	SCAN
      ikodir=''
      select KODI, IM, PRI from INSTR ;
             WHERE kodi=ire.KODI and pri=1 ;
             into cursor C_KODI
      *BROW
	   if RECC() > 0
      	SCAN
      	   ikodir=im
   	      soder_t=allt(ikodir)
	         do stroka_t
			ENDSCAN         
      else
   	   ikodir='реж.инструм-та '+allt(str(ire.kodi,3))+' нет в INSTR '
		ENDIF
      use in C_KODI
   endscan
	use in IRE
	select DIST KODIM from TE where ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODIM<>0 ;
                        into cursor IME
	SCAN
      ikodim=''
      select KODI,PRI,IM FROM INSTR ;
           WHERE kodi=ime.kodim and pri=2 ;
           INTO CURS C_KODIM
		if RECC()>0
			SCAN	       
            ikodim=im
            soder_t=allt(ikodim)
            do stroka_t
         ENDSCAN 
      else
      	ikodim='мерит.инструм-та '+allt(str(ime.kodim,3))+' нет в INSTR '
		endif
	   use in C_KODIM
   endscan
   use in ime
	select DIST KODID from TE where ;
            left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODID<>0 ;
                        into cursor IDO
	SCAN
      ikodid=''
      select KODI,PRI,IM from INSTR ;
           WHERE kodi=ido.KODId and pri=3 ;
           into cursor C_KODID
        
      if RECC()>0
 	         SCAN
				ikodid=im
	     		soder_t=allt(ikodid)
	     		do stroka_t
	      ENDSCAN
      else
         ikodid='доп.инструм-та '+allt(str(ido.kodi,3))+' нет в INSTR '
      endif
 	   use in C_KODID
	endscan
	use in ido
	if m.sh#0
      soder_t='ОБРАЗЦЫ ШЕРОХОВАТОСТИ ГОСТ 9378-75'
      do stroka_t
   endif
   ind=ind+1
enddo

RETURN 

***************************************************************************************************
*********************************** КОНЕЦ П Л О С К О - Ш Л И Ф О В А Л Ь Н Ы Е *******************

***************************************************************************************************
*********************************** В Н У Т Р И - Ш Л И Ф О В А Л Ь Н Ы Е *************************
***************************************************************************************************

PROCEDURE F_W_S  
store 0 to o
*!*	WAIT WINDOW 'В Н У Т Р И - Ш Л И Ф О В А Л Ь Н Ы Е  BROW TE'
sele * FROM TE ;
       WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) and poznd=c_kt.poznd ;
       order BY NTO,NTP ;
       INTO CURS C_TE
*!*	brow 
go top
ind=1
if recc()=0
   wait 'mkttp'+mkttp+' c_kt.poznd'+c_kt.poznd+' нет иформации в TE' wind
   RETURN 
ENDIF 
do while .not.eof()
*!*	   wait 'nto='+str(nto,3) wind
   ind=1
   do while nto#o[ind] OR o[ind]#0
      wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
      if o[ind]=nto
         exit
      endif
      if o[ind]=0 &&nto
         o[ind]=nto
         exit
      endif
      ind=ind+1
      if ind>100
         wait 'недостаточно памяти, надо расширить' wind
         exit
      endif
   enddo
   skip
enddo
ind=1
*!*	WAIT WINDOW 'do while o[ind]#0'
do while o[ind]#0
	*!*	   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
   sele * FROM TE ;
        WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        ORDER BY NTP ;
        INTO CURS C_TE 
   	   WAIT 'sele TE left(mkttp,DLINA_KTTP)='+left(mkttp,DLINA_KTTP)+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3) WIND
   sum  normw,tpz to itogt,itpz
   if ITOGT = 0
      wait 'нет в TE информации по операции '+left(mkttp,DLINA_KTTP)+' '+alltrim(c_kt.poznd)+' '+str(o[ind],4) wind
   else
   	go top
	   scat memv
   	*wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto) 
		use in C_TE
   	ikto=''
		*!*		   WAIT WINDOW 'if m.kto#0'
   	if m.kto#0
      	sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
	      if RECC()>0
   	      ikto=left(C_DOSP_7.im,20)
      	else
         	ikto=allt(str(m.kto,5))
	         ikto=LEFT(ikto+' нет в DOSP vid 7',20)
   	   endif
      	use in C_DOSP_7
	   endif
   	imarka=''
	   inaim =''
   	if !empt(m.kodo)
      	sele marka,naim from obor where MARKA=m.kodo into curs c_obor
	      if recc() > 0
   	      imarka=marka
      	   inaim =naim
	      else
   	      imarka=m.kodo+space(3)
      	   inaim='нет в каталоге оборудов.'
	      endif
   	   use in c_obor
	   endif
   	do stroka_b
		*WAIT WINDOW 'штамповка или слесарка или мехобработка BROW DOSP'
      sele * FROM DOSP WHERE vid=7 and kod=m.kto into curs c_dosp7
	   *BROW
   	niot=''
      if recc()>0
	      niot=obor
   	endif
      use in c_dosp7
	   do stroka_g
		do stroka_d
	         
   	ikodp=space(14)
	   if m.kodp#0
   	   sele * FROM DOSP WHERE vid=5 and kod=m.kodp INTO CURS C_DOSP_5
      	if RECC()>0
	         ikodp=left(im,14)
   	   else
      	   ikodp=allt(str(m.kodp,4))
         	ikodp=rfix(ikodp+' нет в DOSP vid 5',14)
	      endif
   	   use in C_DOSP_5
	   endif 
   	do stroka_e
*!*		   && мехобработка	&& wnutri shlif
*!*			if m.kku#0
*!*				sele * FROM DOSP WHERE vid=31 and kod=m.kku and us=24 INTO CURS C_DOSP_31
*!*	   		if RECC()>0
*!*		   	   soder=alltrim(C_DOSP_31.IM)+alltrim(C_DOSP_31.SIM)
*!*		         do stroka_o
*!*	   	   else
*!*	      		soder='по ККУ '+allt(str(m.kku,5))+' нет информации в DOSP'
*!*	      		do stroka_o
*!*	   	   endif
*!*			   use in C_DOSP_31
*!*			ENDIF    
   endif
	select * FROM TE where left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                          and poznd=c_kt.poznd ;
                          and nto=o[ind] into cursor C_TE
	sele C_TE
   *   brow
   scat memv
   
   KUK=''
   if m.kko#0
      sele * from pt where vid=24 and kko=m.kko into curs c_pt
      go top
      if .not.eof()
    	   msim=allt(im)
      else
	      msim=''
      endif
      use in c_pt 
   endif
	soder=msim+', выдерживая D'+ALLTRIM(STR(dbk,6,2))+ALLTRIM(tocd1)+ALLTRIM(tocd11) ;
		+', шероховатость (Rz(a))'+ALLTRIM(str(m.sh,7,3))+', на длине '+ALLTRIM(STR(M.ds,5)) ;
		+ALLTRIM(toch1)+ALLTRIM(toch11)  
	do stroka_o
	
   
*!*	   soder=KUK
*!*	   do stroka_o
*!*		soder='ВЫДЕРЖАВ РАЗМЕРЫ:'
*!*	   do stroka_o
*!*	   sele c_te
*!*		go top
*!*		do while .not.eof() 
*!*	      scat memv
*!*	      KUKA=' '
*!*	   	IF m.RR1#0 or m.RR2#0 or m.dbk#0 or m.toch#0
*!*	         KUKA=kuka+IIF(m.toch#0,allt(STR(m.toch,6,1)),'');
*!*	                     +IIF(m.rr1#0,allt(STR(m.rr1,6,1)),'');
*!*	                     +IIF(!empt(m.toCH1),' +'+allt(m.toCH1),'');
*!*	                     +IIF(!empt(m.toCH11),' '+allt(m.toCH11),'') ;
*!*	                                                +IIF(!empt(m.RR1),' ; ','')
*!*	         KUKA=kuka+IIF(m.rr2#0,' '+allt(STR(m.rr2,6,1)),'');
*!*	                    +IIF(!empt(m.toCH2),'+'+allt(m.toCH2),'');
*!*	                     +IIF(!empt(m.toCH21),' '+allt(m.toCH21),'')
*!*	         KUKA=kuka+IIF(m.dbk#0,'; '+allt(STR(m.dbk,6,1)),'');
*!*	                     +IIF(!empt(m.toCD1),'+'+allt(m.toCd1),'');
*!*	                     +IIF(!empt(m.toCd11),' '+allt(m.toCd11),'')
*!*	     	   if m.sh#0
*!*	            if m.sh=>10
*!*	                  kuka=kuka+'; Rz '+allt(str(m.sh,7,3))
*!*		         else
*!*	                 kuka=kuka+'; Ra '+allt(str(m.sh,7,3))
*!*	            endif
*!*	         endif
*!*	         soder=KUKa
*!*	      	do stroka_o
*!*	   	ENDIF
*!*		   sele c_te
*!*	      skip
*!*	   enddo
	
   USE IN  c_te
    
   sele DIST KODI FROM TE WHERE ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODI<>0 ;
                        INTO CURS ire
  	SCAN
      ikodir=''
      select KODI, IM, PRI from INSTR ;
             WHERE kodi=ire.KODI and pri=1 ;
             into cursor C_KODI
      *BROW
	   if RECC() > 0
      	SCAN
      	   ikodir=im
   	      soder_t=allt(ikodir)
	         do stroka_t
			ENDSCAN         
      else
   	   ikodir='реж.инструм-та '+allt(str(ire.kodi,3))+' нет в INSTR '
		ENDIF
      use in C_KODI
   endscan
	use in IRE
	select DIST KODIM from TE where ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODIM<>0 ;
                        into cursor IME
	SCAN
      ikodim=''
      select KODI,PRI,IM FROM INSTR ;
           WHERE kodi=ime.kodim and pri=2 ;
           INTO CURS C_KODIM
		if RECC()>0
			SCAN	       
            ikodim=im
            soder_t=allt(ikodim)
            do stroka_t
         ENDSCAN 
      else
      	ikodim='мерит.инструм-та '+allt(str(ime.kodim,3))+' нет в INSTR '
		endif
	   use in C_KODIM
   endscan
   use in ime
	select DIST KODID from TE where ;
            left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODID<>0 ;
                        into cursor IDO
	SCAN
      ikodid=''
      select KODI,PRI,IM from INSTR ;
           WHERE kodi=ido.KODId and pri=3 ;
           into cursor C_KODID
        
      if RECC()>0
 	         SCAN
				ikodid=im
	     		soder_t=allt(ikodid)
	     		do stroka_t
	      ENDSCAN
      else
         ikodid='доп.инструм-та '+allt(str(ido.kodi,3))+' нет в INSTR '
      endif
 	   use in C_KODID
	endscan
	use in ido
	if m.sh#0
		soder_t='ОБРАЗЦЫ ШЕРОХОВАТОСТИ ГОСТ 9378-75'
      do stroka_t
   endif
 	   
   ind=ind+1
enddo
RETURN 
***************************************************************************************************
*********************************** КОНЕЦ В Н У Т Р И - Ш Л И Ф О В А Л Ь Н Ы Е *******************

***************************************************************************************************
*********************************** З У Б О О Б Р А Б О Т К А *************************************
***************************************************************************************************
PROCEDURE F_Z_F

store 0 to o
WAIT WINDOW 'З У Б О О Б Р А Б О Т К А'
sele * FROM TE ;
       WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) and poznd=c_kt.poznd ;
       order BY NTO,NTP ;
       INTO CURS C_TE
brow 
go top
ind=1
if recc()=0
   wait 'mkttp'+mkttp+' c_kt.poznd'+c_kt.poznd+' нет иформации в TE' wind
   RETURN 
ENDIF 
do while .not.eof()
*!*	   wait 'nto='+str(nto,3) wind
   ind=1
   do while nto#o[ind] OR o[ind]#0
      wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
      if o[ind]=nto
         exit
      endif
      if o[ind]=0 &&nto
         o[ind]=nto
         exit
      endif
      ind=ind+1
      if ind>100
         wait 'недостаточно памяти, надо расширить' wind
         exit
      endif
   enddo
   skip
enddo
ind=1
*!*	WAIT WINDOW 'do while o[ind]#0'
do while o[ind]#0
*!*	   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
   sele * FROM TE ;
        WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        ORDER BY NTP ;
        INTO CURS C_TE 
			WAIT 'sele TE left(mkttp,DLINA_KTTP)='+left(mkttp,DLINA_KTTP)+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3) WIND
   sum  normw,tpz to itogt,itpz
   if ITOGT = 0
      wait 'нет в TE информации по операции '+left(mkttp,DLINA_KTTP)+' '+alltrim(c_kt.poznd)+' '+str(o[ind],4) wind
   else
   	go top
	   scat memv
   	*wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto) 
		use in C_TE
   	ikto=''
*!*		   WAIT WINDOW 'if m.kto#0'
   	if m.kto#0
      	sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
	      if RECC()>0
   	      ikto=left(C_DOSP_7.im,20)
      	else
         	ikto=allt(str(m.kto,5))
	         ikto=LEFT(ikto+' нет в DOSP vid 7',20)
   	   endif
      	use in C_DOSP_7
	   endif
   	imarka=''
	   inaim =''
   	if !empt(m.kodo)
      	sele marka,naim from obor where MARKA=m.kodo into curs c_obor
	      if recc() > 0
   	      imarka=marka
      	   inaim =naim
	      else
   	      imarka=m.kodo+space(3)
      	   inaim='нет в каталоге оборудов.'
	      endif
   	   use in c_obor
	   endif
   	do stroka_b
*!*		
*!*			WAIT WINDOW 'штамповка или слесарка или мехобработка BROW DOSP'
      sele * FROM DOSP WHERE vid=7 and kod=m.kto into curs c_dosp7
*!*		   BROW
   	niot=''
      if recc()>0
	      niot=obor
   	endif
      use in c_dosp7
	   do stroka_g
		do stroka_d
	           
   	ikodp=space(14)
	   if m.kodp#0
   	   sele * FROM DOSP WHERE vid=5 and kod=m.kodp INTO CURS C_DOSP_5
      	if RECC()>0
	         ikodp=left(im,14)
   	   else
      	   ikodp=allt(str(m.kodp,4))
         	ikodp=rfix(ikodp+' нет в DOSP vid 5',14)
	      endif
   	   use in C_DOSP_5
	   endif 
   	do stroka_e
	     	
   endif
	select * FROM TE where left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                          and poznd=c_kt.poznd ;
                          and nto=o[ind] into cursor C_TE
	sele C_TE
   scat memv
*!*	   wait '2048' wind
*!*	   brow  
   KUK=''
*!*	   wait '2051 m.kttp='+m.kttp wind
	mvid=0   
   if left(m.kttp,17)='06024.50141.00025'
      mvid=25
   endif
	if left(m.kttp,17)='06024.50141.00026'
      mvid=26
   endif
   if left(m.kttp,17)='06024.50141.00027'
      mvid=27
   endif
   if m.kko#0
      WAIT WINDOW ' PT BROW m.kko='+STR(m.kko,4)+' mvid='+STR(mvid,4)+' m.ka='+STR(m.ka)
      sele * from pt where vid=mvid and kko=m.kko into curs c_pt
      brow
      if RECCOUNT() > 0
     	   msim=allt(im)
   	else
	      msim=''
      endif
		use in c_pt   
     	if m.KA#0
         soder=msim+' '+ALLTRIM(STR(M.KE,3))+' зубъев(а); модуль ' ;
         +allt(str(m.KA,2)) ;
         +'; шероховатостью Rz(a) ';
         +ALLTRIM(STR(m.sh,5,2))+'; длина зуба '+allt(str(m.ds,2))
         do stroka_o
	   endif
      sele c_te
      skip
   endif
	USE IN c_te
*!*	   wait '2079' wind
   sele DIST KODI FROM TE WHERE ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODI<>0 ;
                        INTO CURS ire
  	SCAN
      ikodir=''
      select KODI, IM, PRI from INSTR ;
             WHERE kodi=ire.KODI and pri=1 ;
             into cursor C_KODI
      *BROW
	   if RECC() > 0
      	SCAN
      	   ikodir=im
   	      soder_t=allt(ikodir)
	         do stroka_t
			ENDSCAN         
      else
   	   ikodir='реж.инструм-та '+allt(str(ire.kodi,3))+' нет в INSTR '
		ENDIF
      use in C_KODI
   endscan
	use in IRE
	select DIST KODIM from TE where ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODIM<>0 ;
                        into cursor IME
	SCAN
      ikodim=''
      select KODI,PRI,IM FROM INSTR ;
           WHERE kodi=ime.kodim and pri=2 ;
           INTO CURS C_KODIM
		if RECC()>0
			SCAN	       
            ikodim=im
            soder_t=allt(ikodim)
            do stroka_t
         ENDSCAN 
      else
      	ikodim='мерит.инструм-та '+allt(str(ime.kodim,3))+' нет в INSTR '
		endif
	   use in C_KODIM
   endscan
   use in ime
	select DIST KODID from TE where ;
            left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODID<>0 ;
                        into cursor IDO
	SCAN
      ikodid=''
      select KODI,PRI,IM from INSTR ;
           WHERE kodi=ido.KODId and pri=3 ;
           into cursor C_KODID
        
      if RECC()>0
 	         SCAN
				ikodid=im
	     		soder_t=allt(ikodid)
	     		do stroka_t
	      ENDSCAN
      else
         ikodid='доп.инструм-та '+allt(str(ido.kodi,3))+' нет в INSTR '
      endif
 	   use in C_KODID
	endscan
	use in ido
	
      if m.sh#0
         soder_t='ОБРАЗЦЫ ШЕРОХОВАТОСТИ ГОСТ 9378-75'
         do stroka_t
   	endif
   	   
   ind=ind+1
enddo

RETURN 
***************************************************************************************************
*********************************** КОНЕЦ ЗУБООБРАБОТКИ *******************************************

***************************************************************************************************
***********************************   *************************************
***************************************************************************************************

PROCEDURE SWARKA_KONT
RETURN 

***************************************************************************************************
    
wait 'proc ptp не сварка  ' wind
  
store 0 to o
WAIT WINDOW 'BROW TE'
sele * FROM TE ;
       WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) and poznd=c_kt.poznd ;
       order BY NTO,NTP ;
       INTO CURS C_TE
brow 
go top
ind=1
if recc()=0
   wait 'mkttp'+mkttp+' c_kt.poznd'+c_kt.poznd+' нет иформации в TE' wind
   RETURN 
ENDIF 
do while .not.eof()
   wait 'nto='+str(nto,3) wind
   ind=1
   do while nto#o[ind] OR o[ind]#0
      wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
      if o[ind]=nto
         exit
      endif
      if o[ind]=0 &&nto
         o[ind]=nto
         exit
      endif
      ind=ind+1
      if ind>100
         wait 'недостаточно памяти, надо расширить' wind
         exit
      endif
   enddo
   skip
enddo
ind=1
WAIT WINDOW 'do while o[ind]#0'
do while o[ind]#0
   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
   sele * FROM TE ;
        WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
        and poznd=c_kt.poznd ;
        and nto=o[ind] ;
        ORDER BY NTP ;
        INTO CURS C_TE 
   	   WAIT 'sele TE left(mkttp,DLINA_KTTP)='+left(mkttp,DLINA_KTTP)+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3) WIND
   sum  normw,tpz to itogt,itpz
   if ITOGT = 0
      wait 'нет в TE информации по операции '+left(mkttp,DLINA_KTTP)+' '+alltrim(c_kt.poznd)+' '+str(o[ind],4) wind
   else
   	go top
	   scat memv
   	*wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto) 
		use in C_TE
   	ikto=''
	   WAIT WINDOW 'if m.kto#0'
   	if m.kto#0
      	sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
	      if RECC()>0
   	      ikto=left(C_DOSP_7.im,20)
      	else
         	ikto=allt(str(m.kto,5))
	         ikto=LEFT(ikto+' нет в DOSP vid 7',20)
   	   endif
      	use in C_DOSP_7
	   endif
   	imarka=''
	   inaim =''
   	if !empt(m.kodo)
      	sele marka,naim from obor where MARKA=m.kodo into curs c_obor
	      if recc() > 0
   	      imarka=marka
      	   inaim =naim
	      else
   	      imarka=m.kodo+space(3)
      	   inaim='нет в каталоге оборудов.'
	      endif
   	   use in c_obor
	   endif
   	do stroka_b
	   if left(mkttp,11)='06024.55265' or left(mkttp,11)='06024.55201' or left(mkttp,11)='06024.50141'
            && штамповка или слесарка или  мехобработка
			WAIT WINDOW 'штамповка или слесарка или мехобработка BROW DOSP'
	      sele * FROM DOSP WHERE vid=7 and kod=m.kto into curs c_dosp7
   	   BROW
      	niot=''
	      if recc()>0
   	      niot=obor
      	endif
	      use in c_dosp7
   	   do stroka_g
			do stroka_d
	   endif        
   	ikodp=space(14)
	   if m.kodp#0
   	   sele * FROM DOSP WHERE vid=5 and kod=m.kodp INTO CURS C_DOSP_5
      	if RECC()>0
	         ikodp=left(im,14)
   	   else
      	   ikodp=allt(str(m.kodp,4))
         	ikodp=rfix(ikodp+' нет в DOSP vid 5',14)
	      endif
   	   use in C_DOSP_5
	   endif 
   	do stroka_e
	   if left(mkttp,11)='06024.50141'	&& мехобработка
   	   WAIT WINDOW 'мехобработка='+MKTTP
      	if m.kku#0
         	IF MKTTP='06024.50141.00004'			&&	kruglo shlif
            	sele * FROM DOSP WHERE vid=31 and kod=m.kku and us=4 INTO CURS C_DOSP_31
	            WAIT WINDOW 'DOSP 31  US=4 BROW'
   	         if RECC()>0
      	         soder=alltrim(C_DOSP_31.IM)+alltrim(C_DOSP_31.SIM)
         	      do stroka_o
            	   WAIT WINDOW '!!!!!!!!!!!!!!!!!!!!do stroka_o'+soder
	            else
   	            soder='по ККУ '+allt(str(m.kku,5))+' нет информации в DOSP'
      	         do stroka_o
         	   endif
            	use in C_DOSP_31
				ENDIF	              
   	     	IF MKTTP='06024.50141.00005'				&& ploska shlif
   		      WAIT WINDOW ' PLOSKA SHLIF m.kku='+STR(m.kku)+'brow DOSP 31 US=5'
	      	   sele * FROM DOSP WHERE vid=31 and kod=m.kku and us=5 INTO CURS C_DOSP_31
            	BROW
	            if RECC()>0
   	         	soder=alltrim(C_DOSP_31.IM)+' '+alltrim(C_DOSP_31.SIM)+ALLTRIM(STR(M.KOB))+'ДЕТАЛИ(Й) '
      	   	   do stroka_o
						sele * FROM DOSP WHERE vid=30 and kod=m.kku and us=5 INTO CURS C_DOSP_30
   		   	   WAIT WINDOW 'DOSP 30  US=5 BROW'
	            	soder=alltrim(C_DOSP_30.IM)+' '+ALLTRIM(STR(M.IP))+' ПОВЕРХНОСТЬ(Й)'
	               do stroka_o
   	         else
      	      	soder='по ККУ '+allt(str(m.kku,5))+' нет информации в DOSP'
         		   do stroka_o
      	   	endif
	   	      use in C_DOSP_30
		         use in C_DOSP_31
				ENDIF	
				IF MKTTP='06024.50141.00024'				&& wnutri shlif
	      	   sele * FROM DOSP WHERE vid=31 and kod=m.kku and us=24 INTO CURS C_DOSP_31
   		      if RECC()>0
	   	         soder=alltrim(C_DOSP_31.IM)+alltrim(C_DOSP_31.SIM)
	               do stroka_o
   	         else
      	   	   soder='по ККУ '+allt(str(m.kku,5))+' нет информации в DOSP'
      		      do stroka_o
   	      	endif
		         use in C_DOSP_31
				ENDIF	                
      	ENDIF
	   ENDIF    
   	if left(mkttp,11)='06024.55265' or left(mkttp,11)='06024.55201'
      	&& штамповка или слесарка
	      sele * FROM TE WHERE left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        AND !EMPT(US1) ;
                        and nto=o[ind] INTO CURS C_TE
   	   scatter memv
   		uslovi[1] = m.us1
		   uslovi[2] = m.us2
   	   uslovi[3] = m.us3
      	uslovi[4] = m.us4
	      uslovi[5] = m.us5
   		uslovi[6] = m.us6
	   	uslovi[7] = m.us7
	      uslovi[8] = m.us8
   	   uslovi[9] = m.us9
      	uslovi[10]= m.us10
	   	uslovi[11]= m.us11
		   uslovi[12]= m.us12
   	   uslovi[13]= m.us13
	      uslovi[14]= m.us14
   	   uslovi[15]= m.us15
			iid=1
	   	do while iid<16
		      sele * from KTU where left(ttp,11)=left(mkttp,11) and npp=uslovi[iid] into curs c_ktu
      	   k[iid]=pri
         	use in c_ktu
	         *wait '1 iid='+str(iid,2)+' uslovi[iid]='+str(uslovi[iid])+' K[IiD]='+str(k[iid]) wind
   	   	iid=iid+1
   		enddo
		   iid=1
   	   DO WHILE IiD<16
      	   III=1
         	do while .T.
				if iid=k[III]
            	select * from KTU where left(ttp,11)=left(mkttp,11) ;
                        and npp=uslovi[iii] ;
                        and kof=1 ;
                        and pri=k[iii] into cursor c_ktu
               *wait 'iid='+str(iid,2)+' NPP=uslovi[iid]='+str(uslovi[iid],2)+' pri=k[iid]='+STR(K[IiD],2)+' '+LEFT(Im,15) wind
               *@prow()+1,0 say 'PRI='+STR(k[iid],2)+' npp=uslovi[iid]='+str(uslovi[iid],2)+' '+IM
               *SELE 23
         	   if recc()>0
      	         soder=alltrim(c_ktu.im)
   	            do stroka_o
	               EXIT
               endif
            endif
            iII=iII+1
         	if iii>15
      	      exit
   	      endif
	      enddo
         IiD=IiD+1
      ENDIF
   endif
	select * FROM TE where left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                          and poznd=c_kt.poznd ;
                          and nto=o[ind] into cursor C_TE
	sele C_TE
   *   brow
   scat memv
   *wait 'm.kto='+str(m.kto,4) wind
   if left(mkttp,11)='06024.55265'           && штамповка
   	KUK=''
	   if m.D#0
         kuk=kuk+' '+allt(str(m.D,2))+'+ OTB.'
         endif
         sim=''
      	if m.kto#0
   	      sele * FROM DOSP WHERE vid=7 and kod=m.kto INTO CURS C_DOSP_7
	         if RECC()>0
               msim=allt(sim)
            else
            	msim=str(m.kto,5)+' нет в DOSP, vid 7'
         	endif
      	   use in C_DOSP_7
   	   endif
	      if m.ip#0
            kuk=kuk+' '+msim+' ЗА '+Allt(str(m.ip,2))+' ХОД(ОВ) ПРЕССА '
         endif
      	if m.shag#0
   	      kuk=kuk+'С ШАГОМ ПОДАЧИ '+allt(str(SHAG,6,2))+';'
	      endif
         soder=KUK
         do stroka_o
        	KUKA=' '
      	IF m.RR1#0 OR m.RR2#0
         	KUKA=kuka+IIF(m.rr1#0,allt(STR(m.rr1,6,1)),'')+' ';
                  +IIF(!empt(m.toCH1),'+'+allt(m.toCH1),'')+' ';
                  +IIF(!empt(m.toCH11),allt(m.toCH11),'')
         	KUKA=kuka+';'+IIF(m.rr2#0,' '+allt(STR(m.rr2,6,1)),'')+' ';
                      +IIF(!empt(m.toCH2),'+'+allt(m.toCH2),'')+' ';
                      +IIF(!empt(m.toCH21),allt(m.toCH21),'')
   	   ENDIF
	   ENDIF
	ENDIF   
   if left(mkttp,11)='06024.55273'           && окраска
      *wait window 'okpacka' +str(m.kto)
      && 4  SP - "площадь покрітия"
      && 5  SH#0  - "площадь изоляции"
      && 2  KLP    "класс покрытия
      && 3  GR - группа сложности"
      &&    shag - шаг механич.изоляц.
      && 1  CW   - печатать цвет  с классификатора vid=40,а перед этим печатать  с vid=10  im
      &&    KODI - DOSP VID=41 приспособление   в графу -
      &&    инструмент - (кисть ,шпатель в ---)
      KUK=''
      if m.kto=146
      	if m.sh#0
   	      kuk=kuk+' ПЛОЩАДЬ ИЗОЛЯЦИИ'+allt(str(m.sh,7,3))
	      endif
      endif
      if m.kto=7311
         if m.sp#0
         	kuk=kuk+' ПЛОЩАДЬ ГРУНТОВАНИЯ '+allt(str(m.sp,8,4))+' КЛАСС ПОКРЫТИЯ '+str(klp,1)+' ГРУППА СЛОЖНОСТИ '+str(m.gr,1)
      	endif
   	endif
	   if m.kto=4130
         if m.sp#0
            kuk=kuk+' ПЛОЩАДЬ ШЛИФОВАНИЯ '+allt(str(m.sp,8,4))+' КЛАСС ПОКРЫТИЯ '+str(klp,1)+' ГРУППА СЛОЖНОСТИ '+str(m.gr,1)
         endif
   	endif
	   if m.kto=7352
         if m.sp#0
            kuk=kuk+' ПЛОЩАДЬ ШПАТЛЕВАНИЯ '+allt(str(m.sp,8,4))+' КЛАСС ПОКРЫТИЯ'+str(klp,1)+' ГРУППА СЛОЖНОСТИ '+str(m.gr,1)
         endif
      endif
      if m.kto=4148
   	   if m.sp#0
	         kuk=kuk+' ПЛОЩАДЬ ШЛИФОВАНИЯ '+allt(str(m.sp,8,4))+' КЛАСС ПОКРЫТИЯ'+str(klp,1)+' ГРУППА СЛОЖНОСТИ '+str(m.gr,1)
         endif
      endif
      if m.kto=7361
         if m.sp#0
            sele *FROM DOSP WHERE vid=40 and kod=m.cw INTO CURS C_DOSP_40
            if RECC()>0
         	   kuk=kuk+' '+allt(im)+' ПЛОЩАДЬ ПОКРЫТИЯ'+allt(str(m.sp,8,4))+' КЛАСС ПОКРЫТИЯ '+str(klp,1)+' ГРУППА СЛОЖНОСТИ '+str(m.gr,1)
      	   else
   	         kuk=kuk+' '+allt(str(m.cw,3))+' нет в DOSP vid 40 '+' КЛАСС ПОКРЫТИЯ'+allt(str(m.sp,8,4))+' ГРУППА СЛОЖНОСТИ '+str(klp,1)+' +-+--+ --+|-+--+ '+str(m.gr,1)
	         endif
            use in C_DOSP_40
         endif
      endif
   	*   soder=KUK
	   *   do stroka_o
   ENDIF
   if left(mkttp,11)='06024.55201' OR left(mkttp,11)='06024.50141'
                           && слесарн_е или  мехобработка
      KUK=''
      *wait 'm.kttp='+m.kttp wind
   	if left(m.kttp,11)='06024.50141'
         msim=''
	   endif
      mvid=0   
      if left(m.kttp,17)='06024.50141.00001'
         mvid=1
      endif
   	if left(m.kttp,17)='06024.50141.00002'
         mvid=2
	   endif
      if left(m.kttp,17)='06024.50141.00003'
         mvid=3
      endif
      if left(m.kttp,17)='06024.50141.00004'
         mvid=4
   	endif
	   if left(m.kttp,17)='06024.50141.00005'
         mvid=5
      endif
      if left(m.kttp,17)='06024.50141.00007'
         mvid=7
      endif
   	if left(m.kttp,17)='06024.50141.00009'
         mvid=9
	   endif
      if left(m.kttp,17)='06024.50141.00024'
         mvid=24
      endif
      if left(m.kttp,17)='06024.50141.00025'
         mvid=25
   	endif
	   if left(m.kttp,17)='06024.50141.00026'
         mvid=26
      endif
      if left(m.kttp,17)='06024.50141.00027'
         mvid=27
      endif
   	if m.kto#0
         sele * from pt where vid=mvid and kko=m.kko into curs c_pt
         go top
         if .not.eof()
      	   msim=allt(im)
   	   else
	         msim=''
         endif
         use in c_pt 
      endif
		if left(m.kttp,11)='06024.55201' and m.ip#0
      	kuk=kuk+' '+allt(str(m.ip,2))+' OTB.' && Ф ' +allt(str(m.Dbk,2)) 
   	endif
	   if left(m.kttp,11)#'06024.55201'
         if m.toch # 0
            if mvid=3 or mvid=5
               if mvid=3
               	kuk=kuk+' ФРЕЗЕРОВАТЬ '+iif(m.ip>1,Allt(str(m.ip,2))+' '+MSIM,'')+' C P-PA ' +allt(str(m.D,2))
            	else
         	      kuk=kuk+' '+MSIM+' '+iif(m.ip>1,Allt(str(m.ip,2)),'')+' C P-PA ' +allt(str(m.D,2))
      	      endif
   	      else
	            *kuk=kuk+' '+MSIM+' '+iif(m.ip>1,Allt(str(m.ip,2)),'')+' OTB. Ф ' +allt(str(m.D,2))
               if m.d#0
                  kuk=kuk+' '+MSIM+' Ф ' +allt(str(m.D,2))
               else  
            	   kuk=kuk+' '+MSIM+'  OTB. Ф ' +allt(str(m.Dbk,2)) 
         	   endif
      	   endif
   	   endif
	   endif
      if m.shag#0
         kuk=kuk+'M '+allt(str(m.D,6,2))
      endif
      if m.dbk#0
   	   if mvid=3 OR mvid=5
            kuk=kuk+' ДО P-PA '+allt(str(m.dbk,6,1))
	      else
            kuk=kuk+' ДО ф '+allt(str(m.dbk,6,1))
         endif
      endif
   else
	   if m.ip#0
         kuk=kuk+' '+allt(str(m.ip,2))+' OTB.'
      endif
      if m.shag#0
         kuk=kuk+'M '+allt(str(m.D,6,2))+';'
      else
         kuk=kuk+' Ф '+allt(str(m.d,6,2))+';'
   	endif
	   if m.dbk#0
         kuk=kuk+' ДО Ф '+allt(str(m.dbk,6,1))+';'
      endif
   ENDIF
   IF left(mkttp,11)='06024.50141.00025' OR left(mkttp,17)='06024.50141.00026' OR left(mkttp,17)='06024.50141.00027' 
   	soder=KUK
   	if m.KA#0
         kuk=kuk+' ВЫСОТОЙ '+allt(str(m.KA,2))+' '+STR(M.KE,3)+' ЗУБЬЕВ'
	   endif
   ENDIF
   if m.toch#0
      kuk=kuk+' ДЛИНОЙ '+allt(str(m.toch,3))+';'
   ENDIF
   IF left(mkttp,11)#'06024.50141.00004' AND left(mkttp,17)#'06024.50141.00024'
	   if m.ds#0
         kuk=kuk+' ШИРИНОЙ '+allt(str(m.ds,5))+';'
      endif
   ENDIF
   if left(mkttp,11)#'06024.55273' AND left(mkttp,11)#'06024.01271' AND left(mkttp,11)#'06024.55250' 
   	soder=KUK
   	do stroka_o
	   soder='ВЫДЕРЖАВ РАЗМЕРЫ:'
      do stroka_o
   endif
   sele c_te
	go top
	do while .not.eof() 
      scat memv
      KUKA=' '
   	IF m.RR1#0 or m.RR2#0 or m.dbk#0 or m.toch#0
         KUKA=kuka+IIF(m.toch#0,allt(STR(m.toch,6,1)),'');
                     +IIF(m.rr1#0,allt(STR(m.rr1,6,1)),'');
                     +IIF(!empt(m.toCH1),' +'+allt(m.toCH1),'');
                     +IIF(!empt(m.toCH11),' '+allt(m.toCH11),'') ;
                                                +IIF(!empt(m.RR1),' ; ','')
         KUKA=kuka+IIF(m.rr2#0,' '+allt(STR(m.rr2,6,1)),'');
                    +IIF(!empt(m.toCH2),'+'+allt(m.toCH2),'');
                     +IIF(!empt(m.toCH21),' '+allt(m.toCH21),'')
         KUKA=kuka+IIF(m.dbk#0,'; '+allt(STR(m.dbk,6,1)),'');
                     +IIF(!empt(m.toCD1),'+'+allt(m.toCd1),'');
                     +IIF(!empt(m.toCd11),' '+allt(m.toCd11),'')
     	   if m.sh#0
            if m.sh=>10
                  kuka=kuka+'; Rz '+allt(str(m.sh,7,3))
	         else
                 kuka=kuka+'; Ra '+allt(str(m.sh,7,3))
            endif
         endif
         soder=KUKa
      	do stroka_o
   	ENDIF
	   sele c_te
      skip
   enddo
   sele c_te
   go top
   
*!*	      if left(mkttp,11)#'06024.55241'  		&& заготовительные
*!*	         if !empt(m.osn)
*!*	            sele * from DOSP where vid=41 and kod=m.osn into curs c_dosp_41
*!*	            if recc()>0
*!*	                  ikodosn=im+' '+sim
*!*	            else
*!*	                  ikodosn=str(m.osn,3)+' - НЕТ ТАКОЙ ОСНАСТКИ !!!'
*!*	            endif
*!*	            use in c_dosp_41
*!*	            soder_t=alltrim(ikodosn)
*!*	            do stroka_t
*!*	         endif
*!*	      endif
   if left(mkttp,DLINA_KTTP)='06024.55265'            && холодная штамповка
      sele c_te
   	mosn=osn
	   if mosn#0
         sele kod,im from press where kod=mosn into curs c_press
         if recc()>0
         	soder_t='ШТАМП '+allt(im)
      	   do stroka_t
   	   endif
	      use in c_press
      endif
   endif
   sele DIST KODI FROM TE WHERE ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODI<>0 ;
                        INTO CURS ire
  	SCAN
      ikodir=''
      select KODI, IM, PRI from INSTR ;
             WHERE kodi=ire.KODI and pri=1 ;
             into cursor C_KODI
      *BROW
	   if RECC() > 0
      	SCAN
      	   ikodir=im
   	      soder_t=allt(ikodir)
	         do stroka_t
			ENDSCAN         
      else
   	   ikodir='реж.инструм-та '+allt(str(ire.kodi,3))+' нет в INSTR '
		ENDIF
      use in C_KODI
   endscan
	use in IRE
	select DIST KODIM from TE where ;
                        left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODIM<>0 ;
                        into cursor IME
	SCAN
      ikodim=''
      select KODI,PRI,IM FROM INSTR ;
           WHERE kodi=ime.kodim and pri=2 ;
           INTO CURS C_KODIM
		if RECC()>0
			SCAN	       
            ikodim=im
            soder_t=allt(ikodim)
            do stroka_t
         ENDSCAN 
      else
      	ikodim='мерит.инструм-та '+allt(str(ime.kodim,3))+' нет в INSTR '
		endif
	   use in C_KODIM
   endscan
   use in ime
	select DIST KODID from TE where ;
            left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                        and poznd=c_kt.poznd ;
                        and nto=o[ind] ;
                        AND KODID<>0 ;
                        into cursor IDO
	SCAN
      ikodid=''
      select KODI,PRI,IM from INSTR ;
           WHERE kodi=ido.KODId and pri=3 ;
           into cursor C_KODID
        
      if RECC()>0
 	         SCAN
				ikodid=im
	     		soder_t=allt(ikodid)
	     		do stroka_t
	      ENDSCAN
      else
         ikodid='доп.инструм-та '+allt(str(ido.kodi,3))+' нет в INSTR '
      endif
 	   use in C_KODID
	endscan
	use in ido
	if left(mkttp,11)='06024.50141' or left(mkttp,11)='06024.55201'
                               && мехобработка или слесарка
      if m.sh#0
         soder_t='ОБРАЗЦЫ ШЕРОХОВАТОСТИ ГОСТ 9378-75'
         do stroka_t
   	endif
   endif
 	   if left(mkttp,11)='06024.55273' and m.kto=7361
 	      soder_t=allt(ikodi)+'; ОБРАЗЦЫ ПОКРЫТИЙ; КАТАЛОГ ЦВЕТОВ'
      do stroka_t
   endif
   ind=ind+1
enddo


retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc p_n
ppn=ppn+1
Pn =pn +1
*@prow()+1,0 say 'ppn='+str(ppn,3)+'        pn='+str(pn,3)+'     '+forma
*wait 'forma='+forma+' Pn='+str(pn,3) wind
if forma='3 '
   *wait 'forma='+forma+' pn='+str(pn,3) wind
   if pn>31
      forma='3a'
      do a
      do mok
      do forma_3a
      *wait 'proc p_n forma=3 pn>30 l=322 pn =0 ' wind
      pn=0
   endif
else
   if pn>50
      do moka
      forma='3a'
      do forma_3a
      *wait 'proc p_n forma=3a pn>50 l=329 pn =0 ' wind
      pn=0
   endif
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_b

do p_n
soder_b='|'+iif(mar#0,str(mar,10),space(10));
           +' '+iif(nto#0,str(nto,10),space(10));
           +' '+iif(kto#0,str(kto,5),space(5));
           +' '+ikto
if forma='3 '
   @ prow()+1,0 say '|   |   |A'+str(ppn,2)+soder_b
   @prow(),93 say '|'
else
   @ prow()+1,0 say '|A'+str(ppn,2)+soder_b
   @ prow(),85 say '|'
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_g

do p_n
if forma='3 '
   @ prow()+1,0 say  '|   |   |A'+str(ppn,2)+'| ИOT № '+str(n_i,2)
   @ prow(),93 say '|'
else
   @prow()+1,0 say  '|A'+str(ppn,2)+'| ИOT № '+str(n_i,2)
   @ prow(),85 say '|'
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_d
do p_n
if forma='3 '
   @ prow()+1,0 say  '|   |   |Б'+str(ppn,2)+'| '+imarka+' '+inaim
   @ prow(),93 say '|'
else
   @ prow()+1,0 say  '|Б'+str(ppn,2)+'| '+imarka+' '+inaim
   @ prow(),85 say '|'
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_e

do p_n
soder_e='| '+ikodp;
            +' '+iif(rr#0,str(rr,1),space(1));
            +' '+iif(setka#0,str(setka,4),space(4));
            +' '+iif(kolr#0,str(kolr,1),space(1));
            +' '+iif(kob#0,str(kob,6),space(6));
            +'      мин.'+' '+iif(itogt#0,str(itogt,7,3),space(7));
            +space(6)   +iif(itpz#0,str(itpz,5,1),'     ')
if forma='3 '
   @ prow()+1,0 say '|   |   |Б'+str(ppn,2)+soder_e
   @ prow(),93 say '|'
else
   @ prow()+1,0 say '|Б'+str(ppn,2)+soder_e
   @ prow(),85 say '|'
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_o
*!*	WAIT WINDOW 'stroka_o'
if forma='3 '
*!*	   WAIT WINDOW 'stroka_o forma 3'
   if len(soder)>80
      stroka_1=substr(soder,1,79) 
      do p_n
      @ prow()+1,0 say '|   |   |O'+str(ppn,2)+'| '+stroka_1
      @ prow(),93 say '|'
      stroka_2=substr(soder,80)
      do p_n
*!*	      if forma='3 '
         @ prow()+1,0 say '|   |   |O'+str(ppn,2)+'| '+stroka_2
         @ prow(),93 say '|'
*!*	      else
*!*	         @ prow()+1,0 say '|O'+str(ppn,2)+'| '+stroka_2
*!*	         @ prow(),85 say '|'
*!*	      endif

*!*			WAIT WINDOW '!!!! print stroka_o forma 3'
*!*	   	WAIT WINDOW stroka_1
*!*		   WAIT WINDOW stroka_2
   else
      do p_n
*!*	      WAIT WINDOW '!!!! print stroka_o forma 3'+alltrim(soder)
      @ prow()+1,0 say '|   |   |O'+str(ppn,2)+'| '+alltrim(soder)
      @ prow(),93 say '|'
   ENDIF
   
else
*!*	    WAIT WINDOW 'sele forma ne 3'
   if len(soder)>72
      stroka_1=substr(soder,1,71) 
      do p_n
      @ prow()+1,0 say '|O'+str(ppn,2)+'| '+stroka_1
      @ prow(),85 say '|'
      stroka_2=substr(soder,72)
      do p_n
      @ prow()+1,0 say '|O'+str(ppn,2)+'| '+stroka_2
      @ prow(),85 say '|'
   else
      do p_n
      @ prow()+1,0 say '|O'+str(ppn,2)+'| '+alltrim(soder)
      @ prow(),85 say '|'
   endif
endif

retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc stroka_t

do p_n
if forma='3 '
   @ prow()+1,0 say  '|   |   |T'+str(ppn,2)+'| '+soder_t
   @ prow(),93 say '|'
else
   @ prow()+1,0 say  '|T'+str(ppn,2)+'| '+soder_t
   @ prow(),85 say '|'
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

proc forma_3

*!*	WAIT WINDOW 'proc forma_3'
@prow()+1,55 say 'ГOCT 3.1118-82 фOPMA 3'
@prow()+1,0 say '|-------|------------------------------------------------------------------------------------|'
@prow()+1,0 say '|   |   | CAПP "Cпектр"                       |                       |         |            |'
@prow()+1,0 say '|   |   |------------------------------------------------------------------------------------|'
@prow()+1,0 say '|   |   | ОАО "КИРОВОГРАДСКИЙ ЗАВОД ДОЗИРУЮЩИХ АВТОМАТОВ"                                    |'
@prow()+1,0 say '|   |   |------------------------------------------------------------------------------------|'
@prow()+1,0 say '|   |   | '+rfix(detun,60)+'|         |            |'
@prow()+1,0 say '|   |   |------------------------------------------------------------------------------------|'
@prow()+1,0 say '|   |   |M01| '+mnaim+'|          |'
@prow()+1,0 say '|   |   |------------------------------------------------------------------------------------|'
@prow()+1,0 say '|   |   |   |   Kод         | EB |   MД   |  EH   |    H.расх. |  KИM   |                    |'
@prow()+1,0 say '|   |   |M02|-----------------------------------------------------------|                    |'
@prow()+1,0 say '|   |   |   |                  кг '+str(wag,7,3)+'     1   '+str(nrmd,10,5)+'   | '+iif(nrmd#0,str(wag/nrmd,5,3),'     ')+'  |                    |'
@prow()+1,0 say '|   |   |---------------------------------------------------------------|                    |'
@prow()+1,0 say '|   |   |   | код заготовки |  профиль и размер        |   KД   |   MЗ  |                    |'
@prow()+1,0 say '|   |   |M03|-----------------------------------------------------------|                    |'
@prow()+1,0 say '|   |   |                   | '+rfix(kuku,23)+'  |  '+str(kol,3)+'  |'+str(mz,8,5)+'|                    |'
@prow()+1,0 say '|   |   |------------------------------------------------------------------------------------|'
@prow()+1,0 say '|   |   | B |цех |   уч.  | рм | опер| код, наименование операции                   |        |'
@prow()+1,0 say '|   |   |---------------------------------------------------------------------------|        |'
@prow()+1,0 say '|   |   | Г |   обозначение документа                                               |        |'
@prow()+1,0 say '|   |   |---------------------------------------------------------------------------|        |'
@prow()+1,0 say '|   |   | Д |     код, наименование оборудования                                    |        |'
@prow()+1,0 say '|---|---|---------------------------------------------------------------------------|        |'
@prow()+1,0 say '|   |   | E | CM | Проф   | P | УT  | KP | KOИД | EH  |  OП | K шт | T пз   | T шт  |        |'
@prow()+1,0 say '|   |   |------------------------------------------------------------------------------------|'
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc a
@prow()+1,0 say '|--------------------------------------------------------------------------------------------|'
@prow()+1,0 say '| | | |        |    |        |         |     |Pазработал |           |          |            |'
@prow()+1,0 say '| | | |--------------------------------------------------------------------------------------|'
@prow()+1,0 say '| | | |        |    |        |         |     |Проверил   |           |          |            |'
@prow()+1,0 say '| | | |--------------------------------------------------------------------------------------|'
@prow()+1,0 say '| | | |        |    |        |         |     |Формиров   |           |          |            |'
@prow()+1,0 say '| | | |--------------------------------------------------------------------------------------|'
@prow()+1,0 say '| | | |        |    |        |         |     |           |           |          |            |'
@prow()+1,0 say '| | | |--------------------------------------------------------------------------------------|'
@prow()+1,0 say '| | | |        |    |        |         |     |H.контр.   |           |          |            |'
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc mok
@prow()+1,0 say '|--------------------------------------------------------------------------------------------|'
@prow()+1,0 say '|   |  MOK     |                                                     |          |            |'
@prow()+1,0 say '|--------------------------------------------------------------------------------------------|'
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc forma_3a

*!*	WAIT WINDOW 'proc forma_3A'
@prow()+1,55 say 'ГOCT 3.1118-82 ФOPMA 3a'
@prow()+1,0 say '|------------------------------------------------------------------------------------|   |   |'
@prow()+1,0 say '|    | '+detup+' '+left(detun,41)+'|    |    |     |   |   |'
@prow()+1,0 say '|------------------------------------------------------------------------------------|   |   |'
@prow()+1,0 say '| B | цех|   уч.  | рм | опер| код, наименование операции                   |        |   |   |'
@prow()+1,0 say '|---------------------------------------------------------------------------|        |   |   |'
@prow()+1,0 say '| Г |   обозначение документа                                               |        |   |   |'
@prow()+1,0 say '|---------------------------------------------------------------------------|        |   |   |'
@prow()+1,0 say '| Д |     код, наименование оборудования                                    |        |   |   |'
@prow()+1,0 say '|---------------------------------------------------------------------------|        |   |   |'
@prow()+1,0 say '| E | CM | Проф   |  P | УT  | KP |KOИД |  EH | OП  | K шт|  T пз  | T шт   |        |   |   |'
@prow()+1,0 say '|---------------------------------------------------------------------------|        |   |   |'
@prow()+1,0 say '|Л/M| наименование детали,сб.ед. или материала                              |        |   |   |'
@prow()+1,0 say '|---------------------------------------------------------------------------|        |   |   |'
@prow()+1,0 say '|Л/M| обозначение, код                 | OПП |  EB | EH  |  KИ    | H.расх. |        |   |   |'
@prow()+1,0 say '|------------------------------------------------------------------------------------|   |   |'
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc moka
@prow()+1,0 say '|------------------------------------------------------------------------------------|'
@prow()+1,0 say '|   |  MOK     |                                             |          |            |'
@prow()+1,0 say '|------------------------------------------------------------------------------------|'
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
PROCEDURE swarka
if left(mkttp,11)='06024.55290'
   * сварка 
   *wait window 'proc ptp пошла сварка'
    sele * FROM  TTO ;
           WHERE ;
           left(ttp,11)=left(mkttp,11) and !empt(op) ;
           ORDER BY NFM ;
           INTO CURS C_TTO
      *brow
   n_i=0
   go top
   do while .not.eof()
      *wait 'TTO op='+str(op,4) window nowai
      bil='nou'
      bil60='nou'
      mnfm = nfm
      N_I  = IN
      sele * FROM KTO ;
             WHERE ;
             left(NAMTTP,11)=left(mkttp,11) ;
             and op=c_tto.op ;
             INTO CURS C_KTO
      go top
      if RECC() > 0 
            *wait 'KTO op='+str(op,4) window nowai
         sele * from TE where ;
                left(kttp,DLINA_KTTP)=left(mkttp,DLINA_KTTP) ;
                and poznd=c_kt.poznd ;
                and nto=c_tto.op into curs C_TE
            *WAIT 'sele 5 left(mkttp,11)='+left(mkttp,11)+' c_kt.poznd='+c_kt.poznd+' nto='+str(c_tto.op,3) WIND
         sum  normw,tpz to itogt,itpz
         select c_te
         go top  
         if itogt#0
            *   brow
            SCAN ALL 
              *@prow()+1,0 say poznd+' '+str(nto,4)+str(us1,3)+str(us2,3)+str(us3,3)+str(us4,3)+str(us5,3)+str(us6,3)+str(us7,3)+str(us8,3)
*              mmkttp=kttp
*              mkto =kto
*              mkodo=kodo
               sele * FROM DOSP ;
                      WHERE ;
                      vid=7 and kod=c_te.kto ;
                      INTO CURS C_DOSP_7
               IKTO = space(20)
               if reccount()>0
                  ikto=left(C_DOSP_7.im,20)
               ENDIF
               use in C_DOSP_7
               
               sele MARKA,NAIM FROM OBOR ;
                    WHERE marka=c_te.kodo ;
                    INTO CURS C_OBOR
               if RECC()>0
                  imarka=marka
                  inaim =naim
               else
                  imarka=space(10)
                  inaim =space(25)
               endif
               use in c_obor
               sele C_TE
               wait 'TE nto='+str(nto,3) window nowa
               IF NTO#60
                  if bil='nou'
                     do stroka_b
                     do stroka_g
                     do stroka_d
                     ikodp=space(14)
                     if kodp#0
                        mkodp=kodp
                        sele * FROM DOSP ;
                               WHERE vid=5 and kod=mkodp ;
                               INTO CURS C_DOSP_5
                        ikodp=left(C_DOSP_5.im,14)
                        use in C_DOSP_5
                     ENDIF   
                     select C_TE
                     do stroka_e
                                   
                     store 0 to k,uslovi
                     *wait window 'uslovi(1)='+str(uslovi(1))
                      
                     uslovi[1] = c_te.us1
                     uslovi[2] = c_te.us2
                     uslovi[3] = c_te.us3
                     uslovi[4] = c_te.us4
                     uslovi[5] = c_te.us5
                     uslovi[6] = c_te.us6
                     uslovi[7] = c_te.us7
                     uslovi[8] = c_te.us8
                     uslovi[9] = c_te.us9
                     uslovi[10]= c_te.us10
                     uslovi[11]= c_te.us11
                     uslovi[12]= c_te.us12
                     uslovi[13]= c_te.us13
                     uslovi[14]= c_te.us14
                     uslovi[15]= c_te.us15
                     
                     ind=1
                     do while ind<16
                        if uslovi[ind]#0
                           sele * from KTU where left(ttp,11)=left(c_te.kttp,11) and npp=uslovi[ind] ;
                             into curs c_ktu
                           go top
                           k[ind]=pri
                           *wait '1 ind='+str(ind,2)+' uslovi[ind]='+str(uslovi[ind])+' K[IND]='+str(k[ind]) wind
                        endif
                        ind=ind+1
                     enddo
                     ind=1
                     DO WHILE IND<16
                        III=1
                        do while .T.
                           if ind=k[III]
                              sele * from KTU where left(ttp,11)=left(c_te.kttp,11) and npp=uslovi[iii] and pri=k[iii] and kof=1
                              go top
                              *wait 'ind='+str(ind,2)+' NPP=uslovi[ind]='+str(uslovi[ind],2)+' pri=k[ind]='+STR(K[IND],2)+' '+LEFT(Im,15) wind
                              *@prow()+1,0 say 'PRI='+STR(k[ind],2)+' npp=uslovi[ind]='+str(uslovi[ind],2)+' '+IM
                              if .not.eof()
                                 soder=alltrim(im)
                                 do stroka_o
                                 @prow()+1,0 say '| | |O'+str(ppn,2)+'| '+alltrim(im)
                                 EXIT
                              endif
                           endif
                           iII=iII+1
                           if iii>15
                              exit
                           endif
                        enddo
                        IND=IND+1
                     ENDDO
                     bil='bil'
                  endif
               ELSE
                     * 60 операция
                  SELE c_te
                  wait '60 операция bil60='+bil60 wind
                  if bil60='nou'
                     mip  =ip
                     mkodi=kodi
                     mkodim=kodim
                     mkodid=kodid
                     mdav=dav
                     mrr1=rr1
                     mrr2=rr2
                     mrr3=rr3
                     mTOCH1=TOCH1
                     mTOCH2=TOCH2
                     mTOCH3=TOCH3
                     mTOCH11=TOCH11
                     mTOCH21=TOCH21
                     mTOCH31=TOCH31
                     sele c_te
                     do stroka_b
                     do stroka_g
                     sele marka,naim from OBOR where marka=c_te.kodo into curs c_obor
                     if recc()>0
                        imarka=marka
                        inaim =naim
                     else
                        imarka=space(10)
                        inaim =space(25)
                     endif
                     use in c_obor
                     sele c_te
                     do stroka_d
                     ikodp=space(14)
                     if c_te.kodp # 0
                        mkodp=kodp
                        sele * from DOSP where vid=5 and kod=mkodp into curs c_dosp_5
                        if recc()>0
                           ikodp=left(im,14)
                        endif
                        use in c_dosp_5
                        sele c_te
                     endif
                     do stroka_e
                     soder='ДВУОКИСЬ УГЛЕРОДА ГАЗООБРАЗНАЯ ГОСТ 8050-85'
                     do stroka_o
                     mke=ke
                     mcw=cw
                     sele * from NORMMAT where kodm=mke into curs c_normmat
                     *wait 'kod=ke'+str(mke,4) wind
                     *brow
                     if recc()=0
                        mnaim='нет в справочнике NORMMAT               '
                        mde=0
                        *mgost='нет ГOCTа'
                        mgost=''
                     else
                        mnaim=naim
                        mde=de
                        mgost=''
                        *mgost='нет ГOCTа'
                     endif
                     use in c_normmat
                     soder=allt(mnaim)+' + '+str(mde,4,2)+' '+mgost
                     do stroka_o
                     bil60='bil'
                     
                     mvid=0 
                     if c_te.kttp='КЗ.01290.00003'
                        mvid=28
                     endif
                     if c_te.kttp='КЗ.01290.00002'
                        mvid=27
                     endif
                     if c_te.kttp='КЗ.01290.00004'
                        mvid=29
                     endif
                     if c_te.kttp='КЗ.01290.00001'
                        mvid=25
                     endif
                     *wait 'kod=cw'+str(mcw,4) wind
                     select * from DOSP where vid=mvid and kod=mcw into cursor c_dosp
                     *brow
                     if recc()=0
                        ish='HET B CПPABOЧHИKE'
                     else
                        ish=im
                     endif
                     use in c_dosp
                     sele c_te
                     soder='CBAPИTЬ УЗEЛ ШBOM-'+allt(ish)
                     do stroka_o
                     if L1>0 or IP>0 or KA>0
                        soder= ; 
                           '; ДЛИНА ШВА-'+allt(str(l1,6,3));
                           +'; КОЛ-ВО ШВОВ-'+allt(str(ip,2));
                           +iif(shag#0,"; ШАГОМ-"+allt(str(shag,3)),'');
                           +'KATET ШBA - '+allt(str(ka,2))
                        do stroka_o
                     ENDIF
                  else
                     *wait ' else 60 операция bil60='+bil60 wind
                     sele c_te
                     mcw=cw
                     MVID=0
                     if c_te.kttp='КЗ.01290.00003'
                        mvid=28
                     endif
                     if c_te.kttp='КЗ.01290.00002'
                        mvid=27
                     endif
                     if c_te.kttp='КЗ.01290.00004'
                        mvid=29
                     endif
                     if c_te.kttp='КЗ.01290.00001'
                        mvid=25
                     endif
                     *wait 'kod=cw'+str(mcw,4) wind
                     select * from DOSP where vid=mvid and mcw=kod into cursor c_dosp
                     *brow
                     ish=im
                     use in C_DOSP
                     select C_TE
                     if recc()>0
                        if L1>0 or IP>0 or SHAG>0 or KA>0
                           soder=' ДЛИНА ШВА '+allt(str(l1,6,3));
                              +'; KОЛ-ВО ШВОВ '+str(ip,2);
                              +iif(shag#0,"; ШАГОМ "+str(shag,3),'');
                              +' KATET ШBA - '+allt(str(ka,2))
                           do stroka_o
                        endif
                     ENDIF
                  endif
               endif
               sele c_te
               if nto=125
                  soder_t='ЛИНЕЙКА ГОСТ 427-75 ; КАТЕТОМЕР KO.2785-69'
                  do stroka_t
               endif
                   
            ENDSCAN 
            if c_te.nto=60
               soder=iif(mip#0,'КОЛ-BO ПОВОРОТОВ УЗЛА '+str(mip,2),'')
               do stroka_o
               *wait 'dav='+str(mdav,4) wind
               if mdav#0
                  soder='давление для испытания '+str(mdav,4,1)
                  do stroka_o
               endif
               kuka=''
               IF mRR1#0 OR mRR2#0 OR mRR3#0
                  KUKA=kuka+IIF(mRR1#0,allt(STR(mRR1,6,1)),'')+' ';
                           +IIF(!empt(mTOCH1),'+'+allt(mTOCH1),'')+' ';
                           +IIF(!empt(mTOCH11),allt(mTOCH11),'')
                  KUKA=kuka+';'+IIF(mRR2#0,' '+allt(STR(mRR2,6,1)),'')+' ';
                               +IIF(!empt(mTOCH2),'+'+allt(mTOCH2),'')+' ';
                               +IIF(!empt(mTOCH21),allt(mTOCH21),'')
                  KUKA=kuka+';'+IIF(mRR3#0,' '+allt(STR(mRR3,6,1)),'')+' ';
                               +IIF(!empt(mTOCH3),'+'+allt(mTOCH3),'')+' ';
                               +IIF(!empt(mTOCH31),allt(mTOCH31),'')
               ENDIF
               soder='ВЫДЕРЖАВ РАЗМЕРЫ| '+iif( empt(kuka),'СОГЛАСНО ЧЕРТЕЖА;','')
               do stroka_o
               if !empt(kuka)
                  soder=KUKA
                  do stroka_o
               endif
               ikodi=''
               if mkodi#0
                  sele * from DOSP where vid=41 and kod=mkodi into curs c_dosp41
                  ikodi=allt(im)+' '+allt(sim)
                  use in c_dosp41
               endif
               sele c_te
               soder_t=allt(ikodi)
               do stroka_t
               soder_t='КОМПЛЕКТ МЕРИТЕЛЬНОГО ИНСТРУМЕНТА СВАРЩИКА '
               do stroka_t
            endif
         endif
      ELSE
          wait window 'нет в TE информации по '+left(mkttp,11)+' c_kt.poznd='+allt(c_kt.poznd)+' nto='+str(c_tto.op,3) nowai
      endif
      sele C_TTO 
      skip
   enddo
   USE IN C_KTO
      *       конец сварки
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    