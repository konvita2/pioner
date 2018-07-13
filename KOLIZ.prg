proc koliz
LOCAL cRibf, cShwz, oForm, lcNoInfoOnIzd, lcNeVpisIzd, lcRaschetNeVozm, ;
	  lcCtuzElem, lcNePropUzel,lcNePropKompl, lcRashProvNePoln, lsWA
SET ALTERNATE ON 
 
DO FORM f_izd_vib TO cRibf

SELECT * from db!v_izd where ribf=cRibf into curs c_izd
mribf= ribf
mshw = kod
mim = im
*wait 'mshw='+str(mshw,3)+' '+MRIBF wind
***********************************
DO FORM wait
sele shw from db!v_kt where shw=mshw into curs ckt
if recc()=0
   lcNoInfoOnIzd = 'НЕТ  ИНФОРМАЦИИ  ПО  ИЗДЕЛИЮ !!!'
   _screen.ActiveForm.lbMessage.Caption = lcNoInfoOnIzd  
   *wait ' НЕТ ИНФОРМАЦИИ ПО ИЗДЕЛИЮ !!! ' wind
   use in ckt
   _screen.ActiveForm.Closable = .t.
   RETURN -1
ENDIF
use in ckt
**********************************
FileName = 'errors.txt'
set device to PRINTER 
SET print to &filename
@PROW(),0 say DTOC(DATE())+' '+TIME() 
sele shw,d_u,koli from db!v_kt where shw=mshw and d_u=3 and koli=0 ;
     into curs ckt
*brow
if recc()>0
*   sele shw,d_u,kol,koli from kt where shw=mshw and d_u=3 
   UPDATE kt SET koli = 1 where shw=mshw AND d_u=3
*   sele shw,d_u,kol,koli from kt where shw=mshw and d_u=3 
endif
use in ckt

***********************************
sele shw,kornw,poznw,kornd,poznd,d_u,kodm,mar1,kol,koli from db!v_kt where shw=mshw and d_u=1 and kol=0 ;
     into curs ckt
if recc()>0
   lcRaschetNeVozm = 'КОЛИЧЕСТВО = 0.  РАСЧЕТ НЕВОЗМОЖЕН'
   _screen.ActiveForm.lbMessage.Caption = lcRaschetNeVozm 
   *wait '!!! КОЛИЧЕСТВО=0 РАСЧЕТ НЕВОЗМОЖЕН ' wind
	SCAN
		SCATTER MEMVAR 
		@PROW(),0 say STR(m.shw,6)+' '+m.poznw+' '+m.kornd+' '+m.poznd 
	ENDSCAN 
   use in ckt
   SET DEVICE TO SCREEN 
   SET PRINTER TO 
   _screen.ActiveForm.Closable = .t.
ENDIF 
***********************************
sele shw, pozn, poznd, poznw, d_u, kol from db!v_kt where shw=mshw ;&&!empt(poznd)
                    and d_u=2;
                    and poznd=poznw;
                    and kol>0 into curs ckt
poznd_= poznd
if recc()>0
	lcRaschetNeVozm = 'УЗЕЛ = ПОДУЗЛУ. РАСЧЕТ НЕВОЗМОЖЕН '+ ALLTRIM(POZND_)
    _screen.ActiveForm.lbMessage.Caption = lcRaschetNeVozm
   *wait '!!! УЗЕЛ = ПОДУЗЛУ. РАСЧЕТ НЕВОЗМОЖЕН '+POZND wind
    use in ckt
   _screen.ActiveForm.Closable = .t.
   RETURN -1
endif
use in ckt
***********************************
sele shw from db!v_kt where shw=mshw and pozn#mribf into curs ckt
if recc()>0
*   wait '!!! ПОД № '+STR(MSHW,3)+' В КТС СОВЕРШЕННО ЧУЖИЕ ЕЛЕМЕНТЫ. РАСЧЕТ НЕВОЗМОЖЕН' wind	
	lcCtuzElem = 'В  ИЗДЕЛИИ  №  '+STR(MSHW,3)+'  УЗЛЫ\ДЕТАЛИ ИЗ ДРУГОГО ИЗДЕЛИЯ. РАСЧЕТ НЕВОЗМОЖЕН'
	_screen.ActiveForm.lbMessage.Caption = lcCtuzElem 
   use in ckt
  *USE IN db!v_kt 
   _screen.ActiveForm.Closable = .t.
   RETURN -1
   ENDIF
USE IN ckt

_screen.ActiveForm.lbStarted.Caption = 'процесс расчета...  '+ ALLTRIM(mim)+'  '+ mribf 
_screen.ActiveForm.lbMessage.Caption = ' ' 
*_screen.BackColor =7429647
_screen.Icon ='D:\ANDRIY\PROJECTS\VFOXPRO\BOHDAN\TITLE_BIG.ICO'
_screen.ActiveForm.TitleBar = 0

***********************************************************

* есть ли узлы в изделии?
sele * from db!v_kt where shw=mshw ;
                   and !empt(poznd) ;
                   and d_u=2 ;
                   and kol#0 ;
                   and zo<2 into curs ckt
*brow
KOLZA=RECC()
USE IN ckt
D_=0
if KOLZA=0
  * wait wind "совсем нет узлов !!!"
   UPDATE kt set koli = kol WHERE shw=mshw AND d_u=1 AND kol#0     
	_screen.ActiveForm.lbFinished.Caption = 'совсем нет узлов !!!' 
	_screen.ActiveForm.Closable = .t.
ELSE
   * создать пром. файл 
   IF !FILE('kt1.dbf')
   		WAIT WINDOW 'HET KT1.DBF'		
   		RETURN - 1
   else
	   DELETE FROM kt1
   endif
   *sele shw,d_u,kol,koli from kt where shw=mshw and d_u=3 
   UPDATE kt set koli = 0 WHERE shw=mshw AND kol>0 AND d_u < 3 
   *sele shw,d_u,kol,koli from kt where shw=mshw and d_u=3 
   SELECT * from db!v_kt WHERE shw=mshw AND d_u=2 AND kol#0 AND zo<2 INTO CURSOR aaa
   *BROWSE FIELDS shw,pozn,poznw,poznd,d_u,kol
   GO top
   SCAN
       SCATTER memv
		*WAIT 'm.kod='+STR(m.kod,6) wind
       INSERT INTO kt1 FROM memv
   ENDSCAN
   USE IN aaa
   UPDATE KT1 SET PU=0
	*wait 'расчет подузлов' WINDOW NOWAIT 
   *wait 'mshw='+str(mshw,3) wind
   select * from kt1 where pozn=poznw INTO CURSOR c_ku
   *brow fiel kod,shw,pozn,poznw,poznd,kol,d_u,koli,pu
   ku=RECCOUNT()
   k_u=ku
   if ku>0
      local arra uzel[ku],poduzel[ku],k[ku],p_u[ku],nzap[ku] 
      store 0 to k,p_u, nzap
      store ' ' to uzel
      store ' ' to poduzel
      *wait 'ku='+str(ku,2) wind
      ku=0
      go top
      do while .not.eof()
         ku=ku+1
         uzel[ku]   =poznw
         poduzel[ku]=poznd
         k[ku]      =kol
         nzap[ku]   =kod
		 * wait 'uzel[ku]='+str(ku,2)+' '+ALLTRIM(uzel[ku]);
		 * +' poduzel[ku]='+ALLTRIM(poduzel[ku])+' '+str(nzap[ku],5) wind
         skip
      enddo
      USE IN c_ku
      *wait 'k_u='+str(k_u,5) wind
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
            *wait '127 UPDATE БЕЗ ПОДУЗЛОВ N='+str(nzap[ku],6) wind
         ENDIF
         USE IN CUWU
         ku=ku+1
      enddo
      
***********************************************************      
      bbi=0
      *wait ' верхний цикл ' WINDOW NOWAIT 
      do while .t.                && верхний цикл
         SELECT * from kt1 WHERE koli=0 INTO CURSOR c_kt1&&EMPTY(koli) INTO CURSOR c_kt1
         kolzap=RECCOUNT()
         USE IN c_kt1
         *brow fiel kornd,poznw,poznd,kol,koli,pu
         if kolzap=0
            exit
         ENDIF
 
         bbi=bbi+1
         *wait ' bbi='+str(bbi,4) WINDOW NOWAIT 
         
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
        	      **wait 'mmpoznw= '+mmpoznw wind
        	      *brow fiel poznw,poznd,kol,koli,pu
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
                        skip
                     enddo
                     *закрыть последний подузел вхождения
                     SELECT kod,poznw,poznd,kol,koli,pu FROM kt1 WHERE;
        	             poznw=mmpoznw AND pu=0 AND koli=0;&&empt(pu) AND empt(koli)  
            	         INTO CURSOR cdal
            	     *wait 'есть подузлы еще ???' WINDOW NOWAIT 
            	     *brow    
            	     IF RECCOUNT()=0
                  	    UPDATE kt1 set koli=kk, pu=1 WHERE kod=nomzap
                         *wait '196 закрыть последний подузел вхождения UPDATE';
	                     *    +' kk='+str(kk,3);
	                     *    +' nomzap='+str(nomzap,6) WINDOW NOWAIT 
		                                        
                     ENDIF
                     USE IN Cdal 
                     *wait '197  закрыть пройденную цепочку' WINDOW nowait
                     * закрыть пройденную цепочку
                     UPDATE kt1 set pu=1 WHERE poznw=mmpoznw AND empt(pu) AND empt(koli)
                 else
                    SELECT kod,kol,koli FROM kt1 WHERE kod=nzap[ku] and koli=0;
                         INTO CURSOR c_u
                    IF RECCOUNT()>0
                        *wait '194 UPDATE  kod=nzap[ku]'+STR(NZAP[KU],4)+' '+poduzel[ku]  WINDOW NOWAIT 
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
         
         **wait 'поготовить PU для следующего цикла' wind 
         UPDATE kt1 set pu=0 WHERE koli=0

      enddo       && верхний цикл
   ELSE
      *wait 'НЕТ УЗЛОВ' wind
      USE IN c_ku
   ENDIF
***********************************************************   
* запись в КТ из КТ1 рассчитанных KOLI
*   *wait '219 запись в КТ из КТ1 рассчитанных KOLI' wind
   SELECT * from kt1 WHERE koli>0 INTO CURSOR kt1_kt
   go top
   *brow
   do while .not.eof()
      scat memv
      UPDATE kt set koli=m.koli, pu=0 WHERE kod=m.kod
      skip
   ENDDO
   USE IN kt1_kt
***********************************************************      
*   *wait 'расчет деталей и комплектующих' wind
*   @ 3,1 say 'расчет деталей и комплектующих' colo r+/bg
   sele shw,poznw,poznd,kodm,kornd,d_u,kol,koli,zo from db!v_kt where shw=mshw and d_u=1 ;
                            into curs CKT
   SELECT ckt
   go top
   if .not.eof()
      do while .not.eof()
         scat memv
         sele koli,d_u,shw,poznd,poznw,zo from kt where kt.d_u>1 ;
                           AND shw=M.shw;
                           and poznd=M.poznw;
                           and zo<2; 
                           into curs cktd
*	         IF m.poznd='5718060'
*	            brow
*	         endif
         SUM koli TO ikoli
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
          else
             UPDATE kt set koli = kol*ikoli, pu=0 WHERE kt.shw=m.shw and kt.kornd=m.kornd AND d_u=1 
          ENDIF
         sele CKT
         skip
      enddo
      USE IN CKT
   ENDIF
   
   sele  poznw,poznd,d_u,kodm,mar1,kol,koli from db!kt where shw=mshw;
                                                  and kol>0;
                                                and koli=0 into curs ckt
	 local norma  
	norma = 0  
   if recc()>0
   		norma=1
      lcRashProvNePoln = 'РАСЧЕТ ПРОВЕДЕН НЕ ПОЛНОСТЬЮ !!!!'
      _screen.ActiveForm.lbMessage.Caption = lcRashProvNePoln
      *brow  fiel poznw,poznd,d_u,kodm,mar1,kol,koli noedi &&
   ELSE 
   		 _screen.ActiveForm.lbFinished.Caption = 'Расчет успешно завершен'
   ENDIF
   USE IN ckt 
   _screen.ActiveForm.TitleBar = 1
   _screen.ActiveForm.Closable = .t.
   SET PRINTER TO 
   SET DEVICE TO SCREEN 
   IF norma=1
   MODIFY comm  errors.txt noedi
   endif
ENDIF

