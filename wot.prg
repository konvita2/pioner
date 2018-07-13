*proc wot

local lddats
lddats=space(20)
local mtabn
mtabn=0

DO FORM f_wwod_data to lddats
datan=ctod(subs(lddats,1,10))
datak=ctod(subs(lddats,11))
*wait wind dtoc(datan)+' '+dtoc(datak) 
IF Empty(lddats)
  RETURN -1
ENDIF

do form f_kadry_vib to mtabn
IF mtabn = 0
  RETURN -1
ENDIF

sele fio,tn from kadry ;
     where tn = mtabn into curs ckadry

if recc() > 0
   bfio=fio
else
   bfio='В КАДРАХ ТАКАГО НЕТ'
endif
use in ckadry

sele * from nar ;
     where tabn = mtabn ;
                      and data_b => datan ;
                      and data_b =< datak ;
                      into curs cnar
go top
if eof()
   deac wind god
   wait 'НЕТ В НАРЯДАХ ИНФОРМАЦИИ ПО ТАБЕЛЬНОМУ '+str(mtabn,5) wind
   USE IN CNAR
   retu
else
   fl='wot.txt'
   
   WAIT WINDOW "Документ формирутся..." NOWAIT  
   set  print to &fl
   set  device to print
   @prow()+1,0 say ' '
   @prow()+1,0 say '                          НАРЯД'
   @prow()+1,0 say '              рабочего   таб. № '+str(mtabn,5)+' '+allt(bfio)
   @prow()+1,0 say '              за период '+dtoc(datan)+' - '+dtoc(datak)
   @prow()+1,0 say '-----------------------------------------------------------------------------------------------------------------'
   @prow()+1,0 say 'Дата       Шифр   Кор. №  Обозначение позиции Кол-во № оп. Наименов. Р-д     Норма    Расценка        ИТОГО      '
   @prow()+1,0 say '                   по КД                                   операции         времени                 труд. сумма  '
   @prow()+1,0 say '                                                                              мин,     грн.коп.      час грн.коп.'
   @prow()+1,0 say '-----------------------------------------------------------------------------------------------------------------'


   *brow fiel shwz,kornd,mar,nto,tabn
   i_t=0
   i_d=0
   *sele * FROM NAR WHERE ;
   *                     tabn=mtabn ;
   *                     and data_b => datan ;
   *                     and.data_b =< datak ;
   *                     INTO CURS CNAR
   SELE CNAR
   go top
   do while .not.eof()
      *BROW fiel shwz,kornd,mar,nto
      scat memv
      sele * FROM IZD WHERE ;
             shwz = m.shwz INTO CURS CIZD
      
      sele * FROM KT WHERE SHW = Cizd.kod AND KORND = m.kornd ;
             INTO CURS CKT 
      if RECC() > 0
         mnaimd=naimd
      else
         mnaimd='НЕТ ТАКОЙ ДЕТАЛИ В СВИ !!!'
      endif
      USE IN CKT
      nkto=space(14)
      if m.kto#0
         sele * from dosp ;
              where ;
              vid = 7 and kod = m.kto ;
              into curs cdosp
         if recc() > 0
            nkto=left(im,14)
         else
            nkto='НЕТ В КАТАЛОГЕ ТАКОГО КОДА '+ALLT(STR(M.KTO))
         endif
         use in cdosp 
      endif
      
      sele * from ww ;
           where  ;
           shwz = cnar.shwz and ;
           mar  = cnar.mar and ;
           nto  = cnar.nto and ;
           kornd= cnar.kornd ;
           into curs cww
      go top
      *brow fiel shwz,kornd,mar,nto,normw
      store 0 to ww_normw,wwnormw,mrasz
      if .not.eof()
         *wait 'inormw='+str(inormw,7,2) wind
         
      *   wwnormw=(normw+tpz/m.kzp)*m.kzp/60
         wwnormw=(normw+tpz/m.kzp)*m.kzp
         ww_normw=normw+tpz/m.kzp
                  
         sele * from tarif ;
              where ;
              vidts = cww.setka and rr = cww.rr ;
              into curs ctarif
         if recc() > 0
            MRASZ=dengi*ww_normw/60
            *MRASZ=dengi*ww_normw
         endif
         *if inormw#m.normw
          *wait '®Ўа вЁ ў­Ё¬ ­ЁҐ ­  ­®а¬г ўаҐ¬Ґ­Ё !!! ' wind
         *endif
         if empt(m.kornd)
            kor=m.kornw
            poz=m.poznw
         else
            kor=m.kornd
            poz=m.poznd
         endif
         sele cnar
         @prow()+1,0 say dtoc(data_b)+' '+shwz+' '+kor+' '+cww.poznd;
                                  +' '+str(kzp,3);
                                  +' '+str(nto,4);
                                  +' '+nkto;
                                  +' '+str(cww.rr,1);
                                  +' '+str(ww_normw,9,3);
                                  +' '+str(mrasz,10,4);
                                  +' '+str(wwnormw/60,9,3);
                                  +' '+str(mrasz*kzp,7,2)
         i_t=i_t+wwnormw/60
         i_d=i_d+mrasz*kzp
         @prow()+1,30 say mnaimd
      endif
      USE IN CIZD
      sele CNAR
      skip
   enddo
   USE IN CNAR
   @prow()+1,0 say 'ИТОГО'+space(91)+str(i_t,6,2)+'  '+str(i_d,7,2)
   
   set prin to
   set device to screen

   WAIT WINDOW "ФОРМИРОВАНИЕ ДОКУМЕНТА ЗАКОНЧЕНО" NOWAIT  
	        loWord=CreateObject("Word.Application")       
            loWord.Application.visible=.T.
            WITH  loWord
            	.Documents.open(sys(5)+sys(2003)+"\WOT.txt",.f.,.t.,.f.,'','',.t.,'','',4,1251)
            	.DisplayAlerts=.F.
            ENDWITH 
            RELEASE loWord  
endif


 *WAIT WINDOW "Формирование документа окончено." NOWAIT  
 *          loWord=CreateObject("Word.Application")       
 *          loWord.Application.visible=.T.
 *          WITH  loWord
 *           	.Documents.open("D:\a2\kp.txt")
 *           	.DisplayAlerts=.F.
 *          ENDWITH 
 *          RELEASE loWord            
        


retu
*                                  +' '+str(kzp*wwnormw/60,6,2);

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

