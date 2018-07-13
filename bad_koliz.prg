proc koliz
LOCAL cRibf, cShwz, oForm, lcNoInfoOnIzd, lcNeVpisIzd, lcRaschetNeVozm, ;
	  lcCtuzElem, lcNePropUzel,lcNePropKompl, lcRashProvNePoln, lsWA
	  
DO FORM f_izd_vib TO cRibf
lsWA = SELECT()
SELECT * from db!v_izd where ribf=cRibf into curs c_izd
mribf= ribf
mshw = kod
mim = im
*wait 'mshw='+str(mshw,3)+' '+MRIBF wind

*USE IN C_IZD
*USE IN izd
***********************************
DO FORM wait
sele shw from db!v_kt where shw=mshw into curs ckt
if recc()=0
   lcNoInfoOnIzd = 'НЕТ  ИНФОРМАЦИИ  ПО  ИЗДЕЛИЮ !!!'
   _screen.ActiveForm.lbMessage.Caption = lcNoInfoOnIzd  
   *wait ' НЕТ ИНФОРМАЦИИ ПО ИЗДЕЛИЮ !!! ' wind
   use in ckt
   USE IN v_kt
   _screen.ActiveForm.Closable = .t.
   RETURN
    
ENDIF
USE IN v_kt
use in ckt
***********************************
FileName = 'errors.txt'

set device to PRINTER 
SET print to &filename
@PROW(),0 say DTOC(DATE())+' '+TIME() 
sele shw,d_u,koli from db!kt where shw=mshw and d_u=3 ;
     into curs ckt
if recc()=0
	lcNeVpisIzd = 'В  СТРУКТУРУ  НЕ  ВПИСАНО  САМО  ИЗДЕЛИЕ !!! '
	_screen.ActiveForm.lbMessage.Caption = lcNeVpisIzd
*   wait ' В СТРУКТУРУ НЕ ВПИСАНО САМО ИЗДЕЛИЕ !!! '+str(mshw,3) wind
   use in ckt
   USE IN db!v_kt
   _screen.ActiveForm.Closable = .t.
   retu
else
   if koli=0
      UPDATE kt SET koli = 1 where shw=mshw and d_u=3
      USE IN kt
   endif
endif
use in ckt
*USE IN db!v_kt
***********************************
sele shw from db!v_kt where shw=mshw and d_u=1 and kol=0 ;
     into curs ckt
if recc()>0
   lcRaschetNeVozm = 'КОЛИЧЕСТВО = 0.  РАСЧЕТ НЕВОЗМОЖЕН'
   _screen.ActiveForm.lbMessage.Caption = lcRaschetNeVozm 
   *wait '!!! КОЛИЧЕСТВО=0 РАСЧЕТ НЕВОЗМОЖЕН ' wind
   use in ckt
   SELECT shw,kornw,poznw,kornd,poznd,d_u,kodm,mar1,kol,koli ;
   from db!v_kt where shw=mshw and d_u=1 and kol=0 
   _screen.ActiveForm.Closable = .t.
   
   
ENDIF 
USE IN ckt
***********************************
sele shw, pozn, poznd, poznw, d_u, kol from db!v_kt where shw=mshw;&& and poznd<>' '&&!empt(poznd)
                    and d_u=2;
                    and poznd=poznw;
                    and kol<>0 into curs ckt&&!empt(kol)  into curs ckt
poznd_= poznd
if recc()>0
	lcRaschetNeVozm = 'УЗЕЛ = ПОДУЗЛУ. РАСЧЕТ НЕВОЗМОЖЕН '+ ALLTRIM(POZND_)
    _screen.ActiveForm.lbMessage.Caption = lcRaschetNeVozm
   *wait '!!! УЗЕЛ = ПОДУЗЛУ. РАСЧЕТ НЕВОЗМОЖЕН '+POZND wind
    use in ckt
 *   USE IN db!v_kt
*!*	   SELECT kornw,poznw,kornd,poznd,d_u,kodm,mar1,kol,koli from kt where shw=mshw and LEFT(poznd,1)<>' ';&&!empt(poznd)
*!*	                    and d_u=2;
*!*	                    and poznd=poznw;
*!*	                    and kol<>0 &&into curs ckt &&!empt(kol)  into curs ckt
   _screen.ActiveForm.Closable = .t.
   retu
endif
use in ckt
***********************************
sele shw from db!v_kt where shw=mshw and pozn#mribf into curs ckt
if recc()>0
*   wait '!!! ПОД № '+STR(MSHW,3)+' В КТС СОВЕРШЕННО ЧУЖИЕ ЕЛЕМЕНТЫ. РАСЧЕТ НЕВОЗМОЖЕН' wind	
	lcCtuzElem = 'В  ИЗДЕЛИИ  №  '+STR(MSHW,3)+'  УЗЛЫ\ДЕТАЛИ ИЗ ДРУГОГО ИЗДЕЛИЯ. РАСЧЕТ НЕВОЗМОЖЕН'
	_screen.ActiveForm.lbMessage.Caption = lcCtuzElem 
   use in ckt
*   USE IN db!v_kt 
   _screen.ActiveForm.Closable = .t.
   RETURN
   ENDIF
USE IN ckt

_screen.ActiveForm.lbStarted.Caption = 'Начало процесса расчета...  '+ ALLTRIM(mim)+'  '+ mribf 
_screen.ActiveForm.lbMessage.Caption = ' ' 
*_screen.BackColor =7429647
_screen.Icon ='D:\ANDRIY\PROJECTS\VFOXPRO\BOHDAN\TITLE_BIG.ICO'
_screen.ActiveForm.TitleBar = 0

***********************************************************

* есть ли узлы в изделии?
sele * from db!v_kt where shw=mshw;
                   and LEFT(poznd,1)<>' ';&&!empt(poznd)
                   and d_u=2;
                   and kol#0;
                   and zo<2 into curs ckt
*brow
KOLZA=RECC()
USE IN ckt

D_=0
if KOLZA=0
  * wait wind "совсем нет узлов !!!"
   UPDATE kt set koli = kol WHERE shw=mshw AND d_u=1 AND kol#0     
*   USE IN db!v_kt
   USE IN kt
	_screen.ActiveForm.lbFinished.Caption = 'Расчет успешно завершен' 
	_screen.ActiveForm.Closable = .t.
	 
ELSE
   * создать пром. файл 
   DELETE FROM kt1
   UPDATE kt set koli = 0 WHERE shw=mshw AND kol<>0&&!EMPTY(kol)
   SELECT * from db!v_kt WHERE shw=mshw AND d_u=2 AND kol#0 AND zo<2 INTO CURSOR aaa &&!EMPTY(kol) AND zo<2 INTO CURSOR aaa 
   *BROWSE FIELDS shw,pozn,poznw,poznd,d_u,kol
   GO top
   SCAN
       SCATTER memv
       INSERT INTO kt1 FROM memv
   ENDSCAN
   USE IN aaa
   UPDATE KT1 SET PU=0
      
   wait 'расчет подузлов' wind

   *wait 'mshw='+str(mshw,3) wind
   select * from kt1 where pozn=poznw INTO CURSOR c_ku
   *brow fiel shw,pozn,poznw,poznd,kol,d_u,koli,pu
   ku=RECCOUNT()
   k_u=ku
   if ku>0
      local arra uzel[ku],poduzel[ku],k[ku],p_u[ku],nzap[ku] 
      store 0 to k,p_u, nzap
      store ' ' to uzel
      store ' ' to poduzel
      wait 'ku='+str(ku,2) wind
      ku=0
      go top
      do while .not.eof()
         ku=ku+1
         uzel[ku]   =poznw
         *wait 'ku='+str(ku,2) wind
         poduzel[ku]=poznd
         k[ku]      =kol
         nzap[ku]   =kod
         *wait 'uzel[ku]='+str(ku,2)+' '+uzel[ku]+' poduzel[ku]='+' '+poduzel[ku]+' '+str(nzap[ku],5) wind
         skip
      enddo
      USE IN c_ku
     * wait 'k_u='+str(k_u,5) wind
***********************************************************            
      ku=1
      * верхний уровень узлов, подузлов нет
      do while  ku<=k_u  
         *wait 'KU='+STR(KU,3)+'N='+str(nzap[ku],6)+' '+PODUZEL(KU) wind
         
         mmpoznw=poduzel[ku]
         SELECT * from kt1 WHERE poznw=mmpoznw;
                                 and LEFT(poznd,1)<>' ';&&!empt(poznd)
                                 and kol<>0;&&!empt(kol)
                                 and pu=0 INTO CURSOR CUWU&&empt(pu) INTO CURSOR CUWU
         if recc()=0
            UPDATE kt1 set koli = kol, pu=1 WHERE kod=nzap[ku]  AND koli=0&&EMPTY(KOLI)
            P_U[KU]=1
            wait '127 UPDATE БЕЗ ПОДУЗЛОВ N='+str(nzap[ku],6) WINDOW nowait
            *if last()=27
            *   retu
            *endif
         ENDIF
         USE IN CUWU
         ku=ku+1
      enddo
      
***********************************************************      
      bbi=0
      wait ' верхний цикл ' wind
      do while .t.                && верхний цикл
         SELECT * from kt1 WHERE koli=0 INTO CURSOR c_kt1&&EMPTY(koli) INTO CURSOR c_kt1
         kolzap=RECCOUNT()
         USE IN c_kt1
         *brow fiel kornd,poznw,poznd,kol,koli,pu
         if kolzap=0
            wait 'КОНЕЦ РАСЧЕТА ВХОДИМОСТИ УЗЛОВ' wind
  *          @ 2,1 say 'конец расчета        узлов' colo r+/bg
            exit
         ENDIF
         
         bbi=bbi+1
         wait ' bbi='+str(bbi,4) wind
         if last()=27
            retu
         endif
         ku=1
         do while  ku<=k_u        && нижний цикл
            IF P_U[KU]=0
	           mmpoznw=poduzel[ku]
               iii=0
        	   kk=k[ku]
               do while .t.   && накопление в последий подузел
	              *set filt to poznw=mmpoznw.and.empt(pu).and.empt(koli)
    	          SELECT kod,poznw,poznd,kol,koli,pu FROM kt1 WHERE;
        	             poznw=mmpoznw AND pu=0 AND koli=0;&&empt(pu) AND empt(koli) 
            	         INTO CURSOR cmm 
	              IF RECCOUNT()=0
	                 UPDATE kt1 set koli=kk, pu=1 WHERE kod=nzap[ku]
	                 USE IN cmm
	                 exit
	              endif
	              SELECT CMM
    	          go top
        	      WAIT 'mmpoznw= '+mmpoznw wind
        	      brow fiel poznw,poznd,kol,koli,pu
            	  if !EOF()              
  	                 do while .not.eof()
       	                iii=iii+1
        	            mmpoznw=poznd
       	                if iii=1
                           k2=kol
                        else
                           k2=k2*kol
                        endif
                        kk=k2
                        nomzap=kod
                        *wait '180 mmpoznw='+mmpoznw+' iii='+str(iii,3);
                        *   +' nomzap='+str(nomzap,6);
                        *   +' k2='+str(k2,6) wind
                        if last()=27
                           retu
                        ENDIF
                        
                        skip
                     enddo
                     *закрыть последний подузел вхождения
                     SELECT kod,poznw,poznd,kol,koli,pu FROM kt1 WHERE;
        	             poznw=mmpoznw AND pu=0 AND koli=0;&&empt(pu) AND empt(koli)  
            	         INTO CURSOR cdal
            	     *WAIT 'есть подузлы еще ???' wind
            	     *brow    
            	     IF RECCOUNT()=0
                  	    UPDATE kt1 set koli=kk, pu=1 WHERE kod=nomzap
                         *wait '196 закрыть последний подузел вхождения UPDATE';
                         *+' kk='+str(kk,3);
                         *+' nomzap='+str(nomzap,6) wind
                        IF LASTKEY()=27
                           retu 
                         ENDIF                    
                     ENDIF
                     USE IN Cdal 
                     *WAIT '197  закрыть пройденную цепочку' wind
                     * закрыть пройденную цепочку
                     *UPDATE data_tpp!kt1 set pu=1 WHERE poznw=mmpoznw AND empt(pu) AND empt(koli)
                      
                 else

                    SELECT kod,kol,koli FROM kt1 WHERE kod=nzap[ku] and koli=0;
                         INTO CURSOR c_u
                    IF RECCOUNT()>0
                        WAIT '194 UPDATE  kod=nzap[ku]'+STR(NZAP[KU],4)+' '+poduzel[ku]  wind
                        IF LASTKEY()=27
                           retu 
                        endif
                        UPDATE kt1 set koli=kol, pu=1 WHERE kod=nzap[ku] AND koli=0
                    ENDIF
                    USE IN c_u
                 ENDIF
                 USE IN cmm
                 *exit
               enddo      && конец накопление в последий подузел
            ENDIF
            ku=ku+1
         enddo    && конец нижний цикл
         
         *поготовить PU для следующего цикла
         WAIT 'поготовить PU для следующего цикла' wind 
         UPDATE kt1 set pu=0 WHERE koli=0

      enddo       && верхний цикл
   ELSE
      wait 'НЕТ УЗЛОВ' wind
*      @ 2,1 say 'НЕТ УЗЛОВ                 ' colo r+/bg
      USE IN c_ku
   ENDIF
***********************************************************   
* запись в КТ из КТ1 рассчитанных KOLI
*   WAIT '219 запись в КТ из КТ1 рассчитанных KOLI' wind
   SELECT * from kt1 WHERE koli>0 INTO CURSOR kt1_kt
   go top
   do while .not.eof()
      scat memv
      UPDATE kt set koli=m.koli, pu=0 WHERE kod=m.kod
      skip
   ENDDO
   USE IN kt1_kt
***********************************************************      
   
   wait 'расчет деталей и комплектующих' wind
*   @ 3,1 say 'расчет деталей и комплектующих' colo r+/bg
   sele shw,poznw,poznd,kodm,kornd,d_u,kol from db!v_kt where shw=mshw and d_u=1 ;
                            into curs CKT
   SELECT ckt
   go top
   if .not.eof()
      do while .not.eof()
         scat memv
         sele koli from db!v_kt where (d_u=2 or d_u=3);
                           and shw=m.shw and koli#0;&&!EMPTY(koli)
                           and poznd=m.poznw;
                           and zo<2 into curs cktd
         go top
         ikoli=koli
         *USE IN db!v_kt
         use in cktd
         IF ikoli=0
			IF !EMPTY(m.poznd)
             @PROW(),0 say 'не прописан узел '+m.poznw+'для детали '+m.poznd 
 				lcNePropUzel = 'не прописан узел '+m.poznw+'для детали '+m.poznd
 				_screen.ActiveForm.lbMessage.Caption = lcNePropUzel
            ELSE
                lcNePropKompl = 'Hе прописан узел  '+M.poznw+' для комплектующей '+STR(M.kodm,4)
                _screen.ActiveForm.lbMessage.Caption = lcNePropKompl
                 @PROW(),0 say 'Hе прописан узел  '+M.poznw+' для комплектующей '+str(M.kodm,4)
            endif
         ENDIF
         UPDATE kt set koli = kol*ikoli, pu=0 WHERE shw=m.shw and kornd=m.kornd  
         
         sele CKT
         skip
      enddo
      USE IN CKT
      *USE IN kt
   ENDIF
   
   sele  poznw,poznd,d_u,kodm,mar1,kol,koli from db!v_kt where shw=mshw;
                                                  and kol#0;&&!empt(kol)
                                                  and koli=0 into curs ckt
   if recc()>0
      lcRashProvNePoln = 'РАСЧЕТ ПРОВЕДЕН НЕ ПОЛНОСТЬЮ !!!!'
      _screen.ActiveForm.lbMessage.Caption = lcRashProvNePoln
      *brow  fiel poznw,poznd,d_u,kodm,mar1,kol,koli noedi &&
   ELSE 
   		 _screen.ActiveForm.lbFinished.Caption = 'Расчет успешно завершен'
   ENDIF
	   use in ckt
*	   USE IN db!v_kt
*	   USE IN v_izd
*	   USE IN kt1
*	   USE IN kt
*	   USE IN izd 
*	  
*	   USE IN CIZD
   
   _screen.ActiveForm.TitleBar = 1
   _screen.ActiveForm.Closable = .t.
	IF _screen.ActiveForm.lbFinished.Caption = 'Расчет успешно завершен'
	   _screen.ActiveForm.lbFinished.Caption = 'Расчет успешно завершен'
	   _screen.ActiveForm.Closable = .t.     
	ELSE 
   		SET PRINTER TO 
   		SET DEVICE TO SCREEN 
   		MODIFY COMMAND errors.txt noedit
	ENDIF 
	 
ENDIF
*dataenvironment(this).AutoCLOSETABLES = .t. 

SELECT(lsWA)




 


