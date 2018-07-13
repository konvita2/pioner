proc ml
zad1=space(7)
local arra m[10]
stor 0 to m
do form f_izd_vib_shwz to mshwz
SELECT * from izd WHERE shwz=mshwz INTO CURSOR c_izd

do form f_un with '  изделие  ','  узел/деталь  ' to i_u
*@ 0,10 say '  формировать на  '

defi wind oboz from 9,30 to 11,75 double shad colo sche 5 &&w+/g+
acti wind oboz
if i_u=2
   set cursor on
   @ 0,0 say  ' Введите обозначение:'
   @ 0,23 get mpozn
   read
endif
deac wind oboz
if last()=27
   retu
endif
fl='ml.txt'
WAIT WINDOW NOWAIT 'Файл '+fl+' формируется. Ждите...'
set print to &fl
set device to print

if i_u=1
   sele * from kt where shw=c_izd.kod order by poznw,poznd into curs c_kt
else
   sele * from kt where shw=c_izd.kod .and. (poznw=mpozn.or.poznd=mpozn);
          order by poznw,poznd into curs c_kt
endif
SELECT c_kt
go top
porno=0
do while .not.eof()
   wait wind poznd nowait
   mnaimw=naimw
   mpoznw=poznw
   mkornw=kornw
   mnaimd=naimd
   mpoznd=poznd
   mkornd=kornd
   mkolz =kolz
   mnrmd =nrmd
   mrozma=rozma
   m1=mar1
   m2=mar2
   m3=mar3
   m4=mar4
   m5=mar5
   m6=mar6
   m7=mar7
   m8=mar8
   m9=mar9
   m10=mar10
   m[1]=m1
   m[2]=m2
   m[3]=m3
   m[4]=m4
   m[5]=m5
   m[6]=m6
   m[7]=m7
   m[8]=m8
   m[9]=m9
   m[10]=m10
   str_p=str(m1,4)+'-'+iif(m2#0,allt(str(m2,4)),'')
   if m3#0
      str_p=str_p+'-'+allt(str(m3,4))
   endif
   if m4#0
      str_p=str_p+'-'+allt(str(m4,4))
   endif
   if m5#0
      str_p=str_p+'-'+allt(str(m5,4))
   endif
   if m6#0
      str_p=str_p+'-'+allt(str(m6,4))
   endif
   if m7#0
      str_p=str_p+'-'+allt(str(m7,4))
   endif
   if m8#0
      str_p=str_p+'-'+allt(str(m8,4))
   endif
   if m9#0
      str_p=str_p+'-'+allt(str(m9,4))
   endif
   if m10#0
      str_p=str_p+'-'+allt(str(m10,4))
   endif
   porno=porno+1
   *@prow(),10 say  name_firm
   @prow(),10 say  '"OOO HTП ACKEHH"'
   @prow(),0 say '                                 Маршрутный лист № '+allt(str(porno,4))+'  от '+dtoc(C_IZD.data_p)
   @prow(),0 say '      Изделие '+rtri(c_izd.im)+' '+rtri(c_izd.ribf)
   @prow(),0 say '      Обозначение узла '+' '+rtri(mpoznw)+' '+rtri(mnaimw);
                  +' Короткий № '+kornw
   @prow(),0 say '      Обозначение детали '+' '+rtri(mpoznd)+' '+rtri(mnaimd)+' Короткий № '+kornd+' Маршрут '+str_p
   @prow(),0 say '-------------------------------------------------------------------------------------------------------------'
   @prow(),0 say '      Материал                       Размер заготовки           : Норма расх.на 1 дет.:'
   @prow(),0 say '-------------------------------------------------------------------------------------------------------------'
   *wait 'mshwz='+mshwz+'mpoznd ='+mpoznd wind
   sele * from ww where shwz=c_izd.shwz .and. poznd=mpoznd into curs c_ww
   SELECT c_ww
   go top
   if recc() = 0
      @prow(),0 say allt(c_izd.shwz)+' '+mpoznd+' НЕТ ТАКОЙ ПОЗИЦИИ  В ПРОИЗВОДСТВЕННОЙ БАЗЕ'
      @prow(),0 say chr(12)
   else
      
      nmat=space(52)
      if cww.kodm#0
         SELECT kodm,naim from mater WHERE kodm=cww.kodm INTO CURSOR cmat
         if RECCOUNT()>0
            nmat=naim
         endif
         sele cww
         if mkolz>1
            roz='40+'+allt(STR(mrozma/mkolz,6))+' x N '
         else
            roz=allt(STR(mrozma,6,1))
         endif
         @prow(),0 say nmat+' '+roz;
                        +iif(rozmb#0,'x'+allt(str(rozmb,6,1)),'')
         @prow(),70 say str(mnrmd,10,5)+space(10)
         *@prow(),70 say str(nrmd,10,5)+space(10)+str(nrmd*(mpartz2-mpartz1+1),10,5)
      endif
      @prow(),0 say '-------------------------------------------------------------------------------------------------------------------'
      @prow(),0 say ' №  : №   Наименование    :Оборуд.:   Выдано   :  Принято:Ш.:Контролер:   :  Норма :Т пз :Расценка:Исполнитель:Дата'
      @prow(),0 say 'цеха:        операции     :       :  в работу  :         :бр:         :   :        :     :грн.коп.:таб№.Ф.И.О :    '
      @prow(),0 say ' уч.:                     :       :------------:---------:  :         :р-д:        :     :        :           :    '
      @prow(),0 say '    :                     :       : дата   к-во:годн.брак:  :         :   :  мин.  :мин. :        :           :    '
      @prow(),0 say '-------------------------------------------------------------------------------------------------------------------'
      @prow(),0 say ' '
      sele c_kt
      ind=0
      do while .t.
         ind=ind+1
         *wait 'ind='+str(ind,4) wind
         if ind>10 .or.m[ind]=0
            exit
         endif
         *sele 11
         *set order to ispm
         *set key to mshwz+mpoznd+str(m[ind],4)
         SELECT * from ww where shwz=c_izd.shwz.and.poznd=mpoznd.and.mar=m[ind] ;
                   into CURSOR c_ww
         go top
         if recc() > 0
            do while .not.eof()
               scat memv
               sele * from te where ;
                      poznd=mpoznd.and.mar=m[ind] into curs c_te
               *set key to poznd+str(m[ind],4)
               go top
               irasz=0
               if recc() > 0
                  do while .not.eof()
                     sele * from tarif where vidts=m.setka and rr=m.rr into curs c_tarif
                     if recc() > 0
                        MRASZ = c_tarif.dengi * m.normw / 60
                        irasz = irasz + mrasz
                     endif
                     use in c_tarif
                     sele c_te
                     skip
                  enddo
                 
               endif
               use in c_te
               SELECT vid,kod,im FROM dosp WHERE vid=7 AND kod=m.kto INTO CURSOR cdosp7
               if recc()>0
                  nnto=im
               else
                  nnto=zad1
               ENDIF
               USE IN cdosp7
               sele c_ww
               @prow(),0 say str(mar,4)+':'+str(nto,4)+' '+left(nnto,16);
                                         +':'+M.kodo+':';
                                         +iif(kto>199.and.kto<400,'  % контроля от партии '+str(proc,3)+space(7),space(33));
                                         +str(rr,1);
                                         +':'+str(normw,8,3);
                                         +':'+str(tpz,5,1);
                                         +':'+str(irasz,9,3)
               @prow(),0 say '-------------------------------------------------------------------------------------------------------------------'
               @prow(),0 say ' '
               sele c_ww
               skip
            enddo
            
         else
            @prow(),0 say str(m[ind],4)
            @prow(),0 say '-------------------------------------------------------------------------------------------------------------------'
            @prow(),0 say ' '
         endif && sele 11
      enddo
      @prow(),0 say chr(12)

   endif
   use in c_ww
   sele c_kt
   skip
ENDDO
use in c_kt
USE IN c_izd
set print to
set device to screen

WAIT WINDOW "Формирование документа окончено." NOWAIT  
		     loWord=CreateObject("Word.Application")       
            loWord.Application.visible=.T.
            WITH  loWord
            	.Documents.open(sys(5)+sys(2003)+"\ppz.txt",.f.,.t.,.f.,'','',.t.,'','',4,1251)
            	.DisplayAlerts=.F.
            ENDWITH 
            RELEASE loWord  
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
