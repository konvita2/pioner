proc kont
do wwodmes
sele 37
use brut
set filt to mes=bmes
go top
bbalw=0
if .not.eof()
   bbalw=balw
else
   wait 'нет баланса времени (BRUT) по заданному месяцу !!!' wind
   brow
   set filt to mes=bmes
   go top
   bbalw=0
   if .not.eof()
      sele 37
      use
      wait 'введите баланс времени (BRUT) по заданному месяцу !!!' wind
      retu
   endif
endif
sele 37
use
fl='kont.txt '
acti wind good
@ 0,1 say 'Файл '+fl+' формируется'
@ 1,1 say 'Ждите...              '
set  print to &fl
set  device to print
* берем с WW все коды  технологические с код=200 и менее 399 смотрим код профессии
* берем трудоемкостьNORMW умножаем на количество деталей в запуске KOLI и тут же
* накапливаем трудоемкость при заданом % контроля PROC/100 с WW
* итоговую трудоемкость делим на фонд рабочего времени месяца c BRUT соответствующего
* месяца где код=месяцу ,а balw -времени т.е
* контролируемые параметры берем путем сложения их с TE и умножаем на количество
* деталей в запуске:ds,d,dbk,shag,rad,ug,rr1/2/3 каждый умноженый на IP
* в гальванике,термичке,окраске,параметров нет поэтому берем его за единицу
* в заготовительных работах kodp=138 одно poznd=2 ед. параметров
*необходимо считать по всем изделиям
sele 8
set order to iim
go top
do while .not.eof()
   mshwz=shwz
   mim  =im
   sele 11
   set filt to shwz=mshwz.and.kodp=>136.and.kodp<151
   go top
   if .not.eof()
      @prow()+1,0 say '                       Расчет'
      @prow()+1,0 say '                  потребности контролеров'
      @prow()+1,0 say '                 на план '+ME[BMES]+' 2002 г.'
      @prow()+1,0 say 'изделие '+mshwz+' '+mim
      @prow()+1,0 say '------------------------------------------------------------------------'
      @prow()+1,0 say '  №  :   Наименование :К-во контролир.:Трудоемкость:   %   :Количество :'
      @prow()+1,0 say '     :                :парам. при     :при заданом :контр. :           :'
      @prow()+1,0 say ' п.п.:   професии     :100 % контроле : % контроля :фактич.:контролеров:'
      @prow()+1,0 say '-----------------------------------------------------------------------─'
      npp=0
      kol_i=0
      kol_k=0
      *wait 'mshwz='+mshwz wind
      sele 1
      set order to ivi
      set filt to vid=5.and.kod>136.and.kod<151
      go top
      *brow
      do while .not.eof()
         mkodp=kod
         a=0
         *wait 'mkodp='+str(mkodp,5) wind
         ikodp=im
         sele 11              && WW
         set filt to shwz=mshwz.and.kodp=mkodp &&.and.kto=>200.and.kto<400
         go top
         *brow
         if .not.eof()
            mpoznd=poznd
            tr_zad=0
            tr_zad100=0
            do while .not.eof()
               *koli=kol-kzp
               trzad100=normw*koli
               trzad =normw*koli*proc/100
               kolk  =normw*koli*proc/100/60/bbalw
               tr_zad=tr_zad+trzad
               tr_zad100=tr_zad100+trzad100
               kol_k =kol_k +kolk
               sele 5
               set filt to poznd=mpoznd.and.kodp=mkodp &&.and.kto=>200.and.kto<400
               go top
               *brow fiel rr1,rr2,toch1,toch11,toch2,toch21,tocd11,toch3,toch31,ug,rad
               if .not.eof()
                  do while .not.eof()
                     if !empt(rr1)
                        a=a+1
                     endif
                     if !empt(rr2)
                        a=a+1
                     endif
                     if !empt(toch1)
                        a=a+1
                     endif
                     if !empt(toch11)
                        a=a+1
                     endif
                     if !empt(toch2)
                        a=a+1
                     endif
                     if !empt(toch21)
                        a=a+1
                     endif
                     if !empt(tocd1)
                        a=a+1
                     endif
                     if !empt(tocd11)
                        a=a+1
                     endif
                     if !empt(toch3)
                        a=a+1
                     endif
                     if !empt(toch31)
                        a=a+1
                     endif
                     if !empt(rr3)
                        a=a+1
                     endif
                     if !empt(ug)
                        a=a+1
                     endif
                     if !empt(rad)
                        a=a+1
                     endif
                     *wait 'poznd='+poznd+' '+' kodp='+str(kodp,3)+' kto='+str(kto,4)+' a='+str(a,3) wind
                     skip
                  enddo
               endif
               *wait 'poznd='+mpoznd+' '+' kodp='+str(mkodp,3) wind
               if mkodp=135.or.mkodp=138.or.mkodp=148
                  a=1
               endif
               sele 11
               skip
            enddo
            npp=npp+1
            proc_k=tr_zad/tr_zad100*100
            @prow()+1,0 say str(npp,3)+' '+left(ikodp,30)+' '+str(a,3)+' '+str(tr_zad,10,2)+' '+str(proc_k,8,2)+' '+str(kol_k,10,6)
            kol_i=kol_i+kol_k
         endif
         sele 1
         skip
         *wait 'sele 1 skip' wind
      enddo
   endif
   sele 8
   skip
enddo
@prow()+3,4 say 'ВСЕГО'
kol_i=roun(kol_i,3)
@prow(),60 say str(kol_i,10,3)
deac wind good
do pech
set device to screen
sele 1
set filt to
SELE 5
SET FILT TO
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


