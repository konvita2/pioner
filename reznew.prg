procedure rez
*LOCAL KT_WW,variant_,y,kolwrad
publ KT_WW,variant_,y,kolwrad,n_a,n_b
STORE 0 TO n_a,n_b,variant_
	do form f_un with 'РАССЧИТАТЬ','ПЕЧАТАТЬ ОСТАТКИ' to d_u

	do	case
		case	m.d_u = 1
			do	form_ost
		case	m.d_u = 2
			do	p_o
		case	m.d_u < 1
			return
	endcase
RELEASE KT_WW,variant_,y,kolwrad,n_a,n_b
	return
endproc 

***********************************************
* ПЕЧАТЬ ОСТАТКОВ
proc p_o

fl='rez.txt'

WAIT WINDOW "Документ формируется..." NOWAIT 

set print to &fl
set device to print
@prow()+1,0 say  'ТЕХНОЛОГИЧЕСКИЕ ОСТАТКИ ПО СОСТОЯНИЮ НА '+dtoc(date())
@prow()+1,0 say  ''
@prow()+1,0 say  '---------------------------------------------------'
@prow()+1,0 say  ' N :    N    : Размеры     Bec                     '
@prow()+1,0 say  'п/п:(остатка):                                     '
@prow()+1,0 say  '---------------------------------------------------'
npp=0
iwes=0

local svItog,svWes,svFirst,svKol

sele naim,kodm,tm,uv from mater where sort=1 order by kodm ;
     into curs c_mater
scan
   m.svFirst = .t.
   m.svItog = 0
   m.svKol = 0
   sele *, ra*rb*c_mater.tm*c_mater.uv/1000000 as wes from ostatki where pri=0 and kod=c_mater.kodm ;
        order by wes ;
        into curs c_ostatki
   if recc() > 0
   	  @prow()+1,0 say ''
      @prow()+1,0 say STR(c_mater.kodm,4)+' '+c_mater.naim
      scan
         npp=npp+1
         scat memv
         
         * проверяем выводить ли ИТОГИ
         if !m.svFirst .and. round(m.svWes,3) <> round(m.wes,3) 
         	* выводим итоги
			@prow()+1,0 say '       Итого '+str(m.svKol,4)+' шт. '+str(m.svItog,10,3)      		   	
			@prow()+1,0 say ''
			m.svItog = 0
			m.svKol = 0
         endif
         
         *wes=ra*rb*c_mater.tm*c_mater.uv/1000000
         iwes=iwes+wes
         svItog = svItog+wes
         svKol = svKol+1
         m.svWes = wes
         @prow()+1,0 say str(npp,3)+' '+str(m.nlista,5)+' '+str(m.nost,3) ;
                             +' '+rfix(allt(str(ra))+'x'+allt(str(rb)),9) ;
                             +' '+str(wes,8,3)
                             
		 m.svFirst = .f.                             
         
      endscan
      
      * выводим итоги
	  @prow()+1,0 say '       Итого '+str(m.svKol,4)+' шт. '+str(m.svItog,10,3)      		   	
	  @prow()+1,0 say '--------------------------------'
	      
      @prow()+1,0 say 'ИТОГО '+space(18)+str(iwes,8,3)

   endif
   use in c_ostatki
   
endscan
use in c_mater
set print to
set device to screen
LOCAL loWord
loWord = CREATEOBJECT ('Word.Application')  
WITH loWord
	.DOcuments.Open(sys(5)+SYS(2003)+'\rez.txt',.f.,.f.,.f.,'','',.t.,'','',0,1251)
	.DisplayAlerts = .F.
ENDWITH
loWord.Visible = .t.
*loWord.activeWindow.SelectedSheets.PrintPreview
return 

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
procedure form_ost

do form f_un with 'ПО ВСЕМ МАТЕРИАЛАМ','ПО 1 МАТЕРИАЛУ' to wse_1

if wse_1 < 1
	return -1
endif

if wse_1 = 2
   do form f_mater_vib with 'cho' to m.kodm
ENDIF

do form f_un with 'ПО СВИ В ЗАПУСКЕ','ПО ПРОИЗВОДСТВУ' to KT_WW

if KT_WW < 1
	return -1
endif

LOCAL ARRAY max_nozap[1] 
STORE 0 TO MAX_NOZAP

fl='rez.txt'

WAIT WINDOW "Документ формируется..." NOWAIT 

set print to &fl
set device to print

delete from raschet

* сохранить расчитанные ранее ОСТАТКИ данные
if file('t_sav')
	delete from t_sav
endif	
select * from ostatki into table t_sav
select 0

npp      = 0
ikt_wag  = 0
ikt_nrmd = 0
ikt_mz   = 0
n_lista  = 0
n_nost   = 0

if wse_1=1
   sele * from mater where sort=1 and kodm>0 and kodm < m.glMater into curs c_mater
else
   sele * from mater where kodm=m.kodm into curs c_mater
endif

scan
   mat_kod =kodm
   mat_kodm=kodm
   mat_naim=naim
   mat_dp  =dp
   mat_shp =shp
   ra_=mat_dp
   rb_=mat_shp
   if ra_=0 or rb_=0
      wait wind 'ПО КОДУ'+' '+str(kodm,4)+' !!! ВВЕДИ РАЗМЕРЫ ЛИСТА ' && NOWAIT
   ENDIF
   bil=0
   
   IF KT_WW=1
   	sele * from KT ;
   		where koli>0 and kodm1=mat_kodm order by nrmd into curs c_kt
	ELSE   		
   		sele * from WW ;
   		where KOL-KZP>0 and kodm=mat_kodm order by nrmd into curs c_kt
	ENDIF   		
   *brow fiel shw,poznw,poznd,kornd,kodm
   *brow
   scan
      
      sele * from IZD ;
             where kod=c_kt.shw and !empt(shwz) and !empt(data_p) ;
             into curs c_izd
      * brow       
      if recc()> 0
         *BROW
         *   brow fiel poznd,kodm,rozma,rozmb,koli
         *   sele shw,poznd,kornd,kodm,rozma,rozmb,nrmd,koli from kt where ;
         *   order by kodm,nrmd desc into curs ckt
         izd_kod   =kod
         izd_ribf  =ribf
         izd_shwz  =shwz
         izd_partz1=partz1
         izd_partz2=partz2
         izd_naim  =im
         if bil=0
            do shapka
         endif
         sele c_kt
         IF kt_ww = 1
	         kt_poznd=poznd
	         kt_naimd=naimd
	         kt_kornd=kornd
	         kt_kodm =kodm1
	         kt_rozma=rozma
	         kt_rozmb=rozmb
	         IF ROZMA<ROZMB
	            kt_rozma=rozmB
	            kt_rozmb=rozmA
	         ENDIF
	         kt_kolz =kolZ
	         kt_koliz=koli
	         kt_wag  =wag
	         kt_nrmd =nrmd
	         kt_mz   =mz
	      else  
	      	kt_poznd=poznd
	         kt_kornd=kornd
	         kt_kodm =kodm
	         kt_rozma=rozma
	         kt_rozmb=rozmb
	         IF ROZMA<ROZMB
	            kt_rozma=rozmB
	            kt_rozmb=rozmA
	         ENDIF
	         kt_kolz =kolZ
	         kt_koliz=kol-kzp
  	         kt_wag  =wag
	         kt_nrmd =nrmd
	         kt_mz   =mz 
			endif
         PROGR_=KT_KOLIZ*(izd_PARTZ2-izd_PARTZ1+1)
         *WAIT WIND '!!!!! 73 '+poznd+' PROGR_='+STR(PROGR_,3)+' rozma='+ALLT(STR(rozma))+' rozmb='+ALLT(STR(rozmb))
         rezat_=progr_
         *sele kod,kodm,sort,dp,shp from mater where kodm=kt_kodm and sort=1 ;
         *sele * from ostatki where ;
         *            kod=mat_kod and ra>kt_rozma and rb>kt_rozmb into curs cost
         do while .t.
            sele * from OSTATKI ;
                   where kod=mat_kod and ra-130>kt_rozma and rb-130>kt_rozmb and pri=0 ;
                   into curs c_ostatki
            go top
            if .not.eof()
               update OSTATKI set pri=1 where nozap=c_ostatki.nozap
               ra_=c_ostatki.ra
               rb_=c_ostatki.rb
               n_lista=c_ostatki.nlista
               n_nost =c_ostatki.nost
               *wait wind '92 выборка с остатков RA_='+ALLT(STR(RA_))+' rb_='+ALLT(STR(RB_)) ;
               * +' rozma='+ALLT(STR(kt_rozma))+' rozmb='+ALLT(STR(kt_rozmb))
               *update ostatki set pri=1 where nlista=cost.nlista and nost=cost.nost
            else
               publ arra max_nl[1]
               store 0 to max_nl
               SELECT * FROM raschet INTO CURSOR c_n_lista
               IF RECCOUNT()>0
	               SELE max(nlista) FROM raschet INTO array max_nl
	               n_lista=max_nl[1]+1
               ELSE
               	n_lista=1
               endif
               USE IN c_n_lista
               
               n_nost =0
               RA_=mat_dp
               RB_=mat_shp
               IF RA_ < KT_ROZMA OR RB_ < KT_ROZMB
                  WAIT  'НЕПРИЕМЛЕМЫЕ РАЗМЕРЫ ЗАГОТОВКИ ' WIND
                  wait wind 'МАТЕРИАЛ  RA_='+ALLT(STR(mat_dp))+' rb_='+ALLT(STR(mat_shp)) ;
                   +' ЗАГОТОВКА rozma='+ALLT(STR(kt_rozma))+' rozmb='+ALLT(STR(kt_rozmb))
                  
                  RETU-1
               ENDIF
               *   wait wind '200 выборка с листа  RA_='+ALLT(STR(mat_dp))+' rb_='+ALLT(STR(mat_shp)) ;
               *    +' rozma='+ALLT(STR(kt_rozma))+' rozmb='+ALLT(STR(kt_rozmb))
            ENDIF
            USE IN c_ostatki
            n_a=0
            RA_1=0
            RB_1=0
            RA_2=0
            RB_2=0
            RA_3=0
            RB_3=0
            n1a=0
            n2a=0
            IF ra_ > KT_ROZMA AND rb_ > KT_ROZMB    && РЕЗКА ПО ДЛИНЕ   

              
               N1a=int(ra_/KT_ROZMA)
               N2a=int(rb_/KT_ROZMB)
               N_A=N1a*N2a
  					 ***	1 заготовка с листа         
 	         	IF n_a=1
 	         	   WAIT WINDOW 'variant=1 ПО ДЛИНЕ'
 	         	   variant_=1
 	         	   RA_1=RA_-N1a*kt_ROZMA   &&1-й отход
                  RB_1=kt_ROZMB*N2a
                  RA_2=RA_             && 2-й отход
                  RB_2=rb_-N2a*kt_ROZmB
 	         	ENDIF
  				ELSE					&&	РЕЗКА ПО ШИРИНЕ	  	         
  					
               N1b=int(rb_/KT_ROZMA)
               N2b=int(ra_/KT_ROZMB)
  					N_b=N1b*N2b 
  					wait wind '307 N_B='+ALLT(STR(N_B)      
 	         	IF n_b=1
 	         	   WAIT WINDOW 'variant=1 ПО ширине'
 	         	   variant_=1
 	         	   RA_1=RA_-N1b*kt_ROZMB   &&1-й отход
                  RB_1=kt_ROZMA*N2b
                  RA_2=RA_             && 2-й отход
                  RB_2=rb_-N2b*kt_ROZMA
 	         	ENDIF
 	         ENDIF
 	         
 	         
				***	больше 1 заготовка в 1 ряду
 	         
 	         ** 2 variant
 	         
					  
            IF ra_ > KT_ROZMA AND rb_ > KT_ROZMB    && РЕЗКА ПО ДЛИНЕ   

               
               N1a=int(ra_/KT_ROZMA)
               N2a=int(rb_/KT_ROZMB)
               N_A=N1a*N2a
  					         
 	         	IF n_a > 1
 	         	   variant_=2
 	         	   WAIT WINDOW 'variant=2 ПО ДЛИНЕ'
 	         	   RA_1=RA_-N1a*kt_ROZMA   &&1-й отход
                  RB_1=kt_ROZMB*N2a
                  RA_2=RA_             && 2-й отход
                  RB_2=rb_-N2a*kt_ROZmB
 	         	ENDIF
  				ELSE					&&	РЕЗКА ПО ШИРИНЕ	  	         
  					
               N1b=int(rb_/KT_ROZMA)
               N2b=int(ra_/KT_ROZMB)
  					N_b=N1b*N2b  
  					wait wind '339 N_B='+ALLT(STR(N_B)      
 	         	IF n_b > 1
 	         	   variant_=2
 	         	   WAIT WINDOW 'variant=2 ПО шир'
 	         	   RA_1=RA_-N1b*kt_ROZMB   &&1-й отход
                  RB_1=kt_ROZMA*N2b
                  RA_2=RA_             && 2-й отход
                  RB_2=rb_-N2b*kt_ROZMA
 	         	ENDIF
 	         ENDIF
 	         
            ** 3 variant
 	         
					  
            IF ra_ > KT_ROZMA AND rb_ > KT_ROZMB    && РЕЗКА ПО ДЛИНЕ   

               
               N1a=int(ra_/KT_ROZMA)
               N2a=int(rb_/KT_ROZMB)
               N_A=N1a*N2a
  					         
 	         	IF n_a > 1
 	         	   variant_ = 3
 	         	   WAIT WINDOW 'variant=3 ПО ДЛИНЕ'
 	         	   y = INT(kt_rozma * kt_koliz / ra_)
 	         	   
 	         	   RA_1=RA_- N1a * kt_ROZMA / y  && 1-й отход
                  RB_1=kt_ROZMB * y
                  RA_2=RA_             && 2-й отход
                  RB_2=rb_- n2a * kt_ROZmB / y
 	         	ENDIF
  				ELSE					&&	РЕЗКА ПО ШИРИНЕ	  	         
  					
               N1b=int(rb_/KT_ROZMA)
               N2b=int(ra_/KT_ROZMB)
  					N_b=N1b*N2b  
  					wait wind '375 N_B='+ALLT(STR(N_B)      
 	         	IF n_b > 1
 	         	   variant_ = 3
 	         	   WAIT WINDOW 'variant=3 ПО ширине'
 	         	   y = INT(kt_rozmb * kt_koliz / rb_)
 	         	   RA_1=RA_- y * kt_ROZMB   && 1-й отход
                  RB_1=kt_ROZMA * N1b * y
                  RA_2=RA_             && 2-й отход
                  RB_2=rb_- n2b * kt_ROZMA / y
 	         	ENDIF
 	         ENDIF
 	            
 	            
 	          ** 	4  variant
 	         
					  
            IF ra_ > KT_ROZMA AND rb_ > KT_ROZMB    && РЕЗКА ПО ДЛИНЕ   

               
               N1a=int(ra_/KT_ROZMA)
               N2a=int(rb_/KT_ROZMB)
               N_A=N1a*N2a
  					         
 	         	IF n_a > 1
 	         	   variant_ = 4
 	         	   WAIT WINDOW 'variant=4 ПО ДЛИНЕ'
 	         	   y = kt_rozma * kt_koliz / ra_
 	         	   IF MOD(y,1) # 0
	 	         	   
	 	         	   kolwrad = INT(ra_ / kt_rozma)					&& кол_во деталей в 1 ряду
	 	         	   kolne   = kt_koliz - (kolwrad * INT(y)) 	&& кол_во деталей в последнем ряду
	 	         	   RA_1 = RA_- kt_ROZMA * kolwrad  				&& 1-й отход
	               	RB_1 = rb_ - kt_rozmb * kolwrad
	               	RA_2 = RA_ - kt_rozma * kolne             && 2-й отход
	               	RB_2 = kt_ROZmB 
	               	RA_3 = RA_                                && 3-й отход
	               	RB_3 = rb_ - kt_ROZmB * (y + 1)
                  endif
 	         	ENDIF
  				ELSE					&&	РЕЗКА ПО ШИРИНЕ	  	         
  					
 	         	N1b=int(rb_/KT_ROZMA)
               N2b=int(ra_/KT_ROZMB)
  					N_b=N1b*N2b  
  					wait wind '419 N_B='+ALLT(STR(N_B)      
					IF n_b>1
 	         	   variant_ = 4
 	         	   WAIT WINDOW 'variant=4 ПО шириНЕ'
 	         	   y = kt_rozmb * kt_koliz / rb_
 	         	   IF MOD(y,1) # 0
	 	         	   
	 	         	   kolwrad = INT(rb_ / kt_rozmb)
	 	         	   kolne   = kt_koliz - (kolwrad * INT(y)) 
	 	         	   
	 	         	   RA_1 = RA_- kt_ROZMB * kolwrad  				&& 1-й отход
	               	RB_1 = rb_ - kt_rozmA * kolwrad
	               	RA_2 = RA_ - kt_rozmB * kolne             && 2-й отход
	               	RB_2 = kt_ROZmA 
	               	RA_3 = RA_                                 && 3-й отход
	               	RB_3 = rb_ - kt_ROZMA * (y + 1)
                  endif
 	         	endif
 	         ENDIF
                   
            
*!*	            IF ra_ > KT_ROZMA AND rb_ > KT_ROZMB    && РЕЗКА ПО ДЛИНЕ    аҐ§Є  Ї® ¤«Ё­Ґ
*!*	*!*	               N1a=int((ra_-130)/KT_ROZMA)
*!*	*!*	               N2a=int((rb_-130)/KT_ROZMB)
*!*	               N_A=N1a*N2a
*!*	               N1a=int(ra_/KT_ROZMA)
*!*	               N2a=int(rb_/KT_ROZMB)
*!*	               *wait wind '219 N_A='+ALLT(STR(N_A))
*!*	               *if n_a=0
*!*	               *   wait wind '120 N1A='+ALLT(STR(N1A))+' = ra_-130 '+ALLT(STR(ra_-130))+' / kt_rozma '+ALLT(STR(kt_rozma))
*!*	               *   wait wind '121 N2A='+ALLT(STR(N2A))+' = rb_-130 '+ALLT(STR(rb_-130))+' / kt_rozmb '+ALLT(STR(kt_rozmb))
*!*	               *   wait wind '122 N1A='+ALLT(STR(N1A))+' N2A='+ALLT(STR(N2A))+' N_A='+ALLT(STR(N_A))
*!*	               *endif
*!*	            endif
*!*	            n_b=0
*!*	            n1b=0
*!*	            n2b=0
*!*	            IF rb_ > KT_ROZMA AND ra_ > KT_ROZMB     && РЕЗКА ПО ШИРИНЕ 	аҐ§Є  Ї® иЁаЁ­Ґ
*!*	*!*	               N1b=int((rb_-130)/kt_ROZMA)
*!*	*!*	               N2b=int((ra_-130)/kt_ROZMB)
*!*						N1b=int(rb_/kt_ROZMA)
*!*	               N2b=int(ra_/kt_ROZMB)
*!*	               N_b=N1b*N2b
*!*	               *wait wind '233 N_B='+ALLT(STR(N_B))
*!*	               *if n_b=0
*!*	               *   wait wind '133 N1b='+ALLT(STR(N1b))+' = ra_-130 '+ALLT(STR(rb_-130))+' / kt_rozma '+ALLT(STR(kt_rozma))
*!*	               *   wait wind '134 N2b='+ALLT(STR(N2b))+' = rb_-130 '+ALLT(STR(rb_-130))+' / kt_rozmb '+ALLT(STR(kt_rozmb))
*!*	               *   wait wind '135 N1B='+ALLT(STR(N1B))+' N2B='+ALLT(STR(N2B))+' N_B='+ALLT(STR(N_B))
*!*	               *endif
*!*	            endif
            w_r=IIF(N_A>N_B,'w_a','w_b')  && ў аЁ в а бзҐв 
            MAX_KOL=IIF(N_A>N_B,N_A,N_B)  && max_kol ¬ е Є®«-ў® гб«.§ Ј®в®ў®Є б «Ёбв 
            if max_kol=0
               wait wind '141 вариант расчета'+w_r;
                                     +' max_kol='+allt(str(max_kol));
                                     +' rezat_='+allt(str(rezat_))
               retu-1
            endif
            if w_r='w_a'
               **************  РЕЗ ПО ДЛИНЕ ЗАГОТОВКИ
               if max_kol < rezat_
                  rezat_=rezat_-max_kol
                  koli_=max_kol && rezat_
                  *AIT WIND '!!! 136 A max_kol<rezat_='+str(max_kol)+'<'+str(rezat_)
                  * есть ли остатки после резки полного листа
                  RA_1=RA_-N1a*kt_ROZMA   &&1-й отход
                  RB_1=kt_ROZMB*N2a
                  RA_2=RA_             && 2-й отход
                  RB_2=rb_-N2a*kt_ROZmB
                  **  переход на новый лист или отходы -KOLI=N_A или N_B
                  *WAIT WIND '146 ra_1='+STR(ra_1,5);
                  *        +' ra_1='+STR(ra_1,5);
                  *        +' rb_1='+STR(rb_1,5);
                  *        +' ra_2='+STR(ra_2,5);
                  *        +' rb_2='+STR(rb_2,5)
               else
                  kolo=iif(mod(rezat_,n1a)>0,1,0)
                  kol_r=INT(rezat_/N1a)+kolo        && kol_r количество рядов
                  *WAIT WIND '154 KOL_R=INT(rezat_/N1a)+kolo ';
                  *     +ALLT(STR(KOL_R))+'= rezat_ '+ALLT(STR(rezat_)) ;
                  *     +' n1a '+ALLT(STR(n1a)) ;
                  *     +' kolo '+ALLT(STR(kolo))
                  kol_d_wnzr=(N1a+rezat_)-kol_r*N1a  && kol_d_wnzr  кол-во в 
                                                 *  неполностью резаном ряде
                  *WAIT WIND ' 160 N1a='+str(n1a,2) ;
                  *       +' rezat_='+STR(rezat_,2);
                  *       +'kol_r='+str(kol_r,2);
                  *       +' !!!'+str(kol_d_wnzr,2)
                  if N1a = rezat_
                     RA_1=RA_-N1a*kt_ROZMA   &&1-й отход
                     RB_1=kt_ROZMB
                     ***** koli=rezat_  на новый лист(остаток) не переходим
                     RB_3= rb_-kt_ROZMB    &&  3-й отход
                     RA_3=ra_
                     *WAIT WIND '170 N1a=rezat_'+str(n1a,2) ;
                     *     +' ra_1='+STR(ra_1,5);
                     *     +' rb_1='+STR(rb_1,5);
                     *     +' ra_3='+STR(ra_3,5);
                     *     +' rb_3='+STR(rb_3,5);
                     *     +' rezat_='+STR(rezat_,2)
                     koli_=rezat_
                     rezat_=0
                  endif
                  if n1a < rezat_
                     *WAIT WIND '!!!!! 180 n1a< rezat_' ;
                     *     +' N1a='+allt(str(n1a)) ;
                     *     +' rezat_='+allt(str(rezat_))
                     RA_1=ra_-N1a*kt_ROZMA   &&1-й оход
                     RB_1=kol_r*kt_ROZMB
                     kol_d_wnzr=(N1a+rezat_)-kol_r*N1a  && kol_d_wnzr  кол-во
                     *rezat_= n1a*kol_r -rezat_ -N1a+kol_d_wnzr
                     koli_=progr_-rezat_
                     rezat_=0
                     *WAIT WIND '!!!!! 189 ' ;
                     *     +' rezat_='+allt(str(rezat_)) ;
                     *     +' =  n1a*kol_r '+allt(str(n1a)) ;
                     *     +'*'+ allt(str(n1a*kol_r)) ;
                     *     +' kol_d_wnzr '+ALLT(STR(kol_d_wnzr))
                     *if last()=27
                     *   retu
                     *endif
                     RA_2=ra_-(kol_d_wnzr*kt_ROZMA)-(ra_-N1a*kt_ROZMA)    && 2-й отход
                     RB_2=kt_ROZmB
                     RB_3= rb_-kol_r*kt_ROZMB    &&  3-й отход 
                     RA_3=ra_
                     *WAIT WIND '201 ';
                     *     +' ra_1='+allt(STR(ra_1));
                     *     +' rb_1='+allt(STR(rb_1));
                     *     +' ra_2='+allt(STR(ra_2));
                     *     +' rb_2='+allt(STR(rb_2));
                     *     +' ra_3='+allt(STR(ra_3));
                     *     +' rb_3='+allt(STR(rb_3))
                  endif
                  if N1a > rezat_ and rezat_ > 0
                     RA_1=ra_-rezat_*kt_ROZMA   &&1-й отход
                     RB_1=rezat_*kt_ROZMB
                     RB_3= RB_-rezat_*kt_ROZMB    &&  3-й  отход
                     RA_3=ra_
                     ***** koli=rezat_ на новый лист(остаток) не переходим
                     koli_=rezat_
                     rezat_=0
                     *WAIT WIND '217 N1a>rezat_'+str(n1a,2) ;
                     *     +' ra_1='+allt(STR(ra_1));
                     *     +' rb_1='+allt(STR(rb_1));
                     *     +' ra_3='+allt(STR(ra_3));
                     *     +' rb_3='+allt(STR(rb_3))
                  endif
               endif
            else
               **********    РЕЗ ПО ШИРИНЕ ЗАГОТОВКИ
               if max_kol<= rezat_
                  rezat_=rezat_-max_kol
                  koli_=max_kol && rezat_
                  *AIT WIND '226 b max_kol<=rezat_='+str(max_kol)+'<'+str(rezat_)
                  * есть ли остатки после резки полного листа
                  RA_1=ra_-N2b*kt_ROZMb   &&1-й отход
                  *WAIT WIND '232 ra_1='+allt(str(ra_1)) ;
                  *        +' =  ra_='+allt(STR(ra_));
                  *        +'   n1b='+allt(STR(n2b));
                  *        +'   kt_rozmb='+allt(STR(kt_rozmb))
                  RB_1=kt_ROZMa*N1b
                  *WAIT WIND '237 rb_1='+allt(str(rb_1)) ;
                  *        +'   kt_rozma='+allt(STR(kt_rozma));
                  *        +'   n1b='+allt(STR(n2b))
                  RA_2=ra_             && 2-й отход
                  *WAIT WIND '241 ra_2='+allt(str(ra_2)) ;
                  *        +'   ra_='+allt(STR(ra_))
                  RB_2=RB_-N1b*kt_ROZma
                  *WAIT WIND '244 rb_2='+allt(str(rb_2)) ;
                  *        +' rb_='+allt(STR(rb_));
                  *        +' n1b='+allt(STR(n1b));
                  *        +' kt_rozma='+allt(STR(kt_rozma))
                  ***  переход на новый лист или отход  -KOLI=N_A или N_B
               else
                  kolo=iif(mod(rezat_,n2b)>0,1,0)
                  kol_r=int(rezat_/N2b)+kolo    && kol_r кол-во рядов
                  *WAIT WIND '252 KOL_R=INT(rezat_/N2b)+kolo '+ALLT(STR(KOL_R))+'= rezat_ '+ALLT(STR(rezat_)) ;
                  *                  +' n1b '+ALLT(STR(n2b))+' kolo '+ALLT(STR(kolo))
                  kol_d_wnzr=(N2b+rezat_)-kol_r*N2b  && kol_d_wnzr  кол-во заготовок в незаконченном ряде
                  *WAIT WIND '255 N2b='+str(n2b,2) ;
                  *       +'rezat_='+str(rezat_,2);
                  *       +'kol_r='+str(kol_r,2);
                  *       +'!!! '+str(kol_d_wnzr,2)
                  if N2b=rezat_
                     RA_1=ra_-N2b*kt_ROZMB   &&1-й отход
                     RB_1=kt_ROZMA
                     RB_3= rb_-kt_ROZMA    &&  3-й отход
                     RA_3=ra_
                     *WAIT WIND '264 N2b=rezat_'+str(n2b,2) ;
                     *        +' ra_1='+STR(ra_1,5);
                     *        +' rb_1='+STR(rb_1,5);
                     *        +' ra_3='+STR(ra_3,5);
                     *        +' rb_3='+STR(rb_3,5)
                     koli_=rezat_
                     rezat_=0
                  endif
                  if N2b<rezat_
                     RA_1=ra_-N2b*kt_ROZMB   &&1-й отход
                     RB_1=kol_r*kt_ROZMA
                     kol_d_wnzr=(N2b+rezat_)-kol_r*N2b  && kol_d_wnzr  кол-во;
                     RA_2=ra_-(kol_d_wnzr*kt_ROZMB)-(ra_-N2b*kt_ROZMB)    && 2-й отход
                     RB_2=kt_ROZmA
                     RB_3= RB_-kol_r*kt_ROZMA    &&  3-й отход 
                     RA_3=ra_
                     koli_=rezat_
                     rezat_=0 &&rezat_ - n2b*kol_r - kol_d_wnzr
                     *WAIT WIND '282 N2b<rezat_'+str(n2b,2) ;
                     *        +' ra_1='+STR(ra_1,5);
                     *        +' rb_1='+STR(rb_1,5);
                     *        +' ra_2='+STR(ra_2,5);
                     *        +' rb_2='+STR(rb_2,5);
                     *        +' ra_3='+STR(ra_3,5);
                     *        +' rb_3='+STR(rb_3,5);
                     *        +' kol_d_wnzr ='+ALLT(STR(kol_d_wnzr))
                  endif
                  if N2b > rezat_ and rezat_ > 0
                     RA_1=ra_-rezat_*kt_ROZMB   &&1-й отход
                     *WAIT WIND '293 RA_1=ra_-rezat_*kt_ROZMB ';
                     *        +' ra_1='+allt(STR(ra_1));
                     *        +' ra_='+allt(STR(ra_));
                     *        +' n2b='+allt(STR(n2b));
                     *        +' kt_rozmb='+allt(STR(kt_rozmb))

                     RB_1=kt_ROZMA
                     RB_3= rb_-kt_ROZMA    &&  3-й отход 
                     RA_3=ra_
                     *WAIT WIND '302 N1a>rezat_'+str(n1a,2) ;
                     *        +' ra_1='+STR(ra_1,5);
                     *        +' rb_1='+STR(rb_1,5);
                     *        +' ra_3='+STR(ra_3,5);
                     *        +' rb_3='+STR(rb_3,5)
                     koli_=rezat_
                     rezat_=0
                  endif
               endif
            endif
            do write_
            if rezat_=0
               exit
            endif
         enddo
      endif
      USE IN c_izd
      
   endscan
   use in c_kt
   
endscan
USE IN c_mater
@prow()+1,0 say 'ИТОГО КИС(по нормативу) '+str(roun(ikt_wag/ikt_nrmd,3),5,3)
@prow()+1,0 say        ' '+'Масса по КД '+str(ikt_wag,8,3)
@prow()+1,0 say        ' '+'Расход нормативный'+str(ikt_nrmd,8,3)
@prow()+1,0 say        ' '+'Масса заготовок '+str(ikt_mz,8,3)
clos data
s_listow=0
s_zag   =0
w_listow=0
w_zag   =0
sele nlista,nost,kod from raschet where nost=0 into curs c_list
scan
   nlista_=nlista
   kod_=kod
   sele kodm,dp,shp,tm,uv from mater where kodm=kod_ INTO CURS c_MAT
   uv_mat=0
   if recc() > 0
      *brow
      s_mat=dp*shp
      wag_mat=dp*shp*tm*uv/1000000
      *wait  'wag_mat=dp*shp*tm*uv/1000000 ='+str(wag_mat,8,3) ;
      *                                   +' '+str(dp,4) ;
      *                                   +' '+str(shp,4) ;
      *                                   +' '+str(tm,5,2) ;
                                         + ' '+str(uv,3) wind
      uv_mat=uv
      w_listow=w_listow+wag_mat
      *wait  'Норма расхода по факту ='+str(w_listow,8,3)
   endif
   use in c_mat
   sele rozma,rozmb,koli,nlista from raschet where nlista=nlista_ into curs c_ost_sum
   sum rozma*rozmb*koli to s1_zag
   wag_zag= s1_zag*uv_mat/1000000
   use in c_ost_sum
   s_listow=s_listow+s_mat
   s_zag   =s_zag   +s1_zag
   w_zag   =w_zag   +wag_zag
   
ENDSCAN 
use in c_list
@prow()+1,0 say 'Норма расхода по факту '+str(w_listow,8,3)
*@prow()+1,0 say '«листов   площадь  '+str(s_listow,8,3)+' ўҐб '+str(w_listow,8,3)
*@prow()+1,0 say 'заготовок площадь  '+str(s_zag,8,3)+' ўҐб '+str(w_zag,8,3)
@prow()+1,0 say 'КИС по факту '+str(ikt_wag/w_listow,8,3)
*use in cizd
set print to
set device to screen
LOCAL loWord
loWord = CREATEOBJECT ('Word.Application')  
WITH loWord
	.DOcuments.Open(sys(5)+SYS(2003)+'\rez.txt',.f.,.f.,.f.,'','',.t.,'','',0,1251)
	.DisplayAlerts = .F.
ENDWITH
loWord.Visible = .t.
*loWord.activeWindow.SelectedSheets.PrintPreview
*on key

	local lcMsg
	m.lcMsg = 	'Принять расчитанные значения? '+;
				'Если вы ответите ДА, предыдущие данные будут утеряны?'
	if messagebox(m.lcMsg,4,'ПОДТВЕРДИТЕ!') = 6
		
	else
		delete from ostatki
		use ostatki again
		append from t_sav
		use
	endif			
	
return


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc write_
publ arra max_no[1]
store 0 to max_no
SELECT * FROM OSTATKI INTO CURSOR C_N_OST
IF RECCOUNT()>0 
	SELE max(nost) FROM ostatki where nlista=n_lista INTO array max_no
	N_NOST =max_no[1]+1
ELSE
	N_NOST=1
ENDIF
WAIT WINDOW 'N_NOST='+STR(N_NOST)
USE IN C_N_OST
*!*	SELE * FROM RASCHET INTO CURS CRAS
*!*	SCAT MEMV BLAN
*!*	USE IN CRAS
   npp=npp+1
*!*	   M.DATR=DATE()
*!*	   M.NLISTA=n_lista
*!*	   WAIT WINDOW '11111!!!!! N_NOST'+STR(N_NOST)

*!*	   
*!*	   M.NOST =n_nost
*!*	      WAIT WINDOW '11111!!!!! M.NOST'+STR(M.NOST)
*!*	   M.KORND=KT_KORND
*!*	   M.KOD  =MAT_KOD
*!*	   M.ROZMA=KT_ROZMA
*!*	   M.ROZMB=KT_ROZMB
*!*	   M.rezat=rezat_
*!*	   M.SHWZ =IZD_SHWZ
*!*	   m.progr=progr_
*!*	   M.KOLi =koli_
*!*	   M.RA   =ra_
*!*	   M.Rb   =rb_
*!*	   *m.pri  =???
	   m.usl  =IIF(N_A>N_B,1,2)
* pri = ?????
*shw  = ?????
*mkod = ?????
   INSERT INTO  RASCHET (DATR, NLISTA,  NOST,   KORND,    KOD,   ROZMA,   ROZMB,PROGR, KOLI,     SHWZ,   KOLZ,RA, RB,   USL,  variant) ; 
   		VALUES 	      (DATE(),n_lista,n_nost,kt_kornd,mat_kod,kt_rozma,kt_rozmb,progr_,koli_,izd_shwz,kt_kolz,ra_,rb_,m.usl,variant_)    
   ikt_wag  =ikt_wag  +kt_wag *koli_
   ikt_nrmd =ikt_nrmd +kt_nrmd*koli_
   ikt_mz   =ikt_mz   +kt_mz  *koli_

   if RA_1>130 and rb_1>130
      n_NOST =N_nost+1
      M.RA   =ra_1
      M.Rb   =rb_1
      if ra_1 < rb_1
         M.Ra   =rb_1
         M.Rb   =ra_1
      endif
   endif
   
   SELECT * FROM OSTATKI INTO CURSOR C_max_nozap
   IF RECCOUNT()>0
   	   SELE max(nozap) FROM ostatki INTO array max_nozap
	   m.nozap = max_nozap[1]+1
   ELSE
   		M.NOZAP=1 
   ENDIF
   USE IN C_MAX_NOZAP
   *WAIT WINDOW ' m.nozap='+STR(M.NOZAP)
*!*	   *m.pri  =???

   insert into ostatki  (nozap,dat_o,  kod, Ra, Rb, nlista,  nost) VALUES ; 
   					  (m.nozap,DATE(),kt_kodm,ra_,rb_,n_lista,n_nost)
   @prow()+1,0 say str(npp,3)+' '+str(n_lista,5)+' '+str(n_nost,3)+' '+rfix(allt(str(ra_))+'x'+allt(str(rb_)),9) ;
       +' '+izd_ribf+' '+izd_shwz+' '+kt_poznd+' '+kt_kornd+' '+str(progr_,3)+' '+str(koli_,3) ;
       +'    '+rfix(allt(str(KT_rozma))+'x'+allt(str(KT_rozmb)),9) 	&&;
       +iif(RA_1>130 and rb_1>130, ;
       +' '+rfix(allt(str(ra_1))+'x'+allt(str(rb_1)),9);
                              +str(N_LISTA,5)+' '+str(N_nost,3),'')

   @prow()+1,12 say ' '+izd_naim+' '+kt_naimd

if RA_2>130 and rb_2>130
*!*	   M.NOST =m.nost+1
   n_NOST =n_nost+1
   M.RA   =ra_2
   M.Rb   =rb_2
   if ra_2<rb_2
      M.RA   =rb_2
      M.Rb   =ra_2
   endif
   m.dat_o=date()
   
   *insert into ostatki from memv
   * pri = ???
    insert into ostatki  (nozap,dat_o, kod,     ra,  rb, nlista,   nost) VALUES ; 
   					   (m.nozap,DATE(),kt_kodm,m.ra,m.rb,n_lista,n_nost)
*!*	   @prow(),104 say rfix(allt(str(ra_2))+'x'+allt(str(rb_2)),9) ;
*!*	                              +str(M.NLISTA,5)+' '+str(m.nost,3)
endif
if RA_3>130 and rb_3>130
   n_NOST =n_nost+1
   M.RA   =ra_3
   M.Rb   =rb_3
   if ra_3<rb_3
      M.RA   =rb_3
      M.Rb   =ra_3
   endif
   m.dat_o=date()
    
   *insert into ostatki from memv
   * pri=???
    insert into ostatki  (nozap,dat_o, kod,     ra,  rb, nlista,  nost) VALUES ; 
   					   (m.nozap,DATE(),kt_kodm,m.ra,m.rb,n_lista,n_nost)
	   if RA_2>130 and rb_2>130
	      @prow()+1,0 say space(104) +rfix(allt(str(ra_3))+'x'+allt(str(rb_3)),9) ;
	                              +str(N_LISTA,5)+' '+str(n_nost,3)
	   else
	      @prow(),104 say rfix(allt(str(ra_3))+'x'+allt(str(rb_3)),9) ;
                              +str(n_LISTA,5)+' '+str(n_nost,3)
   endif
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc shapka
@prow()+1,0 say  '            ВЕДОМОСТЬ'
@prow()+1,0 say  ' оперативного РАСКРОЯ прямоугольных деталей с ЛИСТА '+str(mat_kod,4)+' '+allt(mat_naim)
@prow()+1,0 say  ''
@prow()+1,0 say  '-------------------------------------------------------------------------------------------------------------------------'
@prow()+1,0 say  ' № :    №    : Размеры :   ИЗДЕЛИЕ                  : ЗАГОТОВКА                 :Прогр.:К-во : Размеры :Остатки :   №    '
@prow()+1,0 say  '   :  листа  :         :                            :                           : за - :с по-:заготовки:L     В :остатка '
@prow()+1,0 say  'п/п:(остатка):         :                            :                           :пуска :лосы :         :        :        '
@prow()+1,0 say  '-------------------------------------------------------------------------------------------------------------------------'
bil=bil+1
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*	proc f1mat_
*	*wait 'proc f1mat   ' wind
*	on key
*	sele 4
*	set filt to sort=1
*	go top
*	defi wind wv from 1,1 to 21,77 title 'ЊЂ’…ђ€Ђ‹' double shad colo sche 10
*	acti wind wv
*	on key label Enter do f1m
*	*wait 'f1mat  mgr,msort,msp,msh='+str(mgr,4)+str(msort,4)+str(msp,4)+str(msh,4) wind
*	brow fiel kodm,NAIM:H='ЌЂ€Њ…ЌЋ‚ЂЌ€…',tm:H='’®«й',dm:H='„Ё ¬.',nsort:H='ь б®ав.',dp:H='„«.',shp:H='Ёа' in wind wv noed
*	set filt to
*	rele wind wv
*	ON KEY
*	keyb '{Enter}'
*	set CURS on
*	retu
*	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*	proc f1m
*	m.kodm=kodm
*	keyb '{ctrl+w}'
*	return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *