

* * * * * * * * * * * * * * * * * * * * * * * * * * * * **ДАТА ПОСЛЕДНЕЙ МОДИФИКАЦИИ    03/11/2003
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc ukm
publ nzap,ikodpp,bmes,bgod
*save scre to sza
defi wind wwod from 8,10 to 13,34 double shad colo sche 10 && w+/w
do while .t.
   acti wind wwod
   SET CURSOR ON
   @0,0 prompt ' Учет комплектации     '
   @1,0 prompt ' Печать                '
   @2,0 prompt ' Каталог комплектующих '
   @3,0 prompt ' Выход                 '
   menu to menutmc
   SET CURSOR OFF
   do case
      case menutmc=4.or.menutmc=0.or.last()=27
           exit
      case menutmc=1
           on key
           do u_zap
      case menutmc=2
           on key
           do p_zap
      case menutmc=3
           on key
           do Kmat
   endcase
enddo
@ 0,0 clear to 24,79
rele wind wwod
*rest scre from sza
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc u_zap
save scre to scrzap
publ mmm
defi wind wza from 10,20 to 14,44 double shad colo sche 10 && w+/w
do while .t.
   acti wind wza
   SET CURSOR ON
   @0,0 prompt ' Ввод расхода запасов  '
   @1,0 prompt ' Учет остатков запасов '
   @2,0 prompt ' Выход                 '
   menu to menuzap
   SET CURSOR OFF
   do case
      case menuzap=0.or.menuzap=3
           exit
      case menuzap=1
           do rash_tmc
      case menuzap=2
           do osttov
   endcase
enddo
rele wind wza
rest scre from scrzap
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
********* ввод РАСХОДА *************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*ДАТА ПОСЛЕДНЕЙ МОДИФИКАЦИИ    26/08/2002
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc Rash_tmc
*on key label Ctrl-O do otladka with sys(16)
publ namediz, nrec,bcena
publ array ras(50),ar1(50)
store 0 to ras
m.doc=space(6)
m.n_plat=space(6)
*m.date={  /  /  }
m.datar=date()
publ kodm,nametov
   defi wind yn from 15,19 to 17,63 double shad colo sche 5
   acti wind yn
   nsk_=0
   @ 0,0 say ' Введите N складской карточки'
   @ 0,31 get nsk_
   read
   deac wind yn
if last()=27
   retu
endif
do while.t.
   on key
   defi wind wp from 10,1 to 22,79 title '-  Т М Ц  -' double shad colo sche 10
   acti wind wP
   sele 29
   set filt to
   set order to ikodm
   set key to nsk_
   go top
   set cursor off
   on key label Enter do wwod_ras
   brow fiel nsk:H='№ с\к',naim:R:42:H='Наименование',ostatok:H='Остаток',cena:H='Цена',data_o:H='Дата' noed in wind wp
   on key
   rele wind wp
   if lastkey()#27
      wait ' перед do wwod_ras' wind
      do wwod_ras
   endif
   deac wind w1,wp,era
   defi wind yn from 12,19 to 15,63 double shad colo sche 5
   acti wind yn
   @ 0,1 say 'Ввод расхода продолжить ?'
   @ 1,12 prom '  Да  '
   @ 1,26 prom '  Нет  '
   menu to yeno
   deac wind yn
   if yeno=2.or.yeno=0.or.lastkey()=27
      exit
   endif
enddo

return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc wwod_ras
if last()#27
   mostatok=ostatok
   if ostatok#0
      set cursor off
      @ 2,1 say 'Наименование              себестоим.  количество        остаток '
      SELE 29
      @ 4,1 say left(naim,30)+' '+str(cena,10,2)+'  '+allt(str(kol,10,3))+ '           '+str(ostatok,6)
      if lastkey()#27
         sele 32
         do Ekr_ras
      endif
      set escape on
      deac wind era
   else
      wait 'Нечего расходовать.' wind
      deac wind era
   endif
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc Ekr_ras
on key
zag='Ввод РАСХОДА'
do while .t.
   define window w2 from 1,38 to 17,78 title ' ОТПУСКАЕМ ' double shad close colo sche 10
   acti wind w2
   @  1,1 say 'Отпущено                 ' colo gr+/bg
   @  5,1 say 'Документ                 ' colo gr+/bg
   @  6,1 say 'Изделие                  ' colo gr+/bg
   @  7,1 say 'Отпускная цена           ' colo gr+/bg
   @  8,1 say 'Количество               ' colo gr+/bg
   @  9,1 say 'Дата cписания            ' colo gr+/bg
   sele 32
   scat memv blan
   SELE 29
   *m.cena=cena
   scat memv
   kudak=7
   kuda=1
   set cursor on
   do while .t.
      do while .t.
         do case
            case kuda=1                             &&
                 if lastkey()=27
                    exit
                 endif
                 on key label uparrow do wwerh
                 *on key label F1 do f1pp
                 do f1pp
                 @ 2,1 get m.kodpp
                 read
                 @ 2,1 say left(ikodpp,35) colo w+/bg
                 kuda=kuda+1
            case kuda=2                               && НОМЕР ТТН
                 on key label uparrow do wwerh
                 @ 5,22 get m.doc
                 read
                 @ 5,22 say m.doc colo w+/bg
                 kuda=kuda+1
            case kuda=3                              && объект списания
                 on key label F1 do f1izd
                 on key label uparrow do wwerh
                 @ 6,17 get m.shwz
                 read
                 sele 8
                 SET ORDER TO ISHWZ
                 SEEK m.shwz
                 vvs=iif(FOUN(),im,space(20))
                 @ 6,17 say vvs colo w+/bg
                 kuda=kuda+1
            case kuda=4                              && ОТПУСКНАЯ ЦЕНА
                 otp=0
                 on key label uparrow do wwerh
                 @ 7,21 get m.cena
                 read
                 @ 7,21 say m.cena colo w+/bg
                 kuda=kuda+1
            case kuda=5                              && КОЛИЧЕСТВО
                 do while.t.
                    on key label uparrow do wwerh
                    m.kol=0
                    @ 8,21 get m.kol  pict '999999.999'
                    read
                    if m.kol>mostatok
                       wait 'ПЕРЕБОР!!! Остаток равен '+str(mostatok,10,3) wind
                    else
                       exit
                    endif
                 enddo
                 @ 8,21 say m.kol   colo w+/bg
                 kuda=kuda+1
            case kuda=6                              && ДАТА ОТГРУЗКИ
                 on key label uparrow do wwerh
                 @ 9,20 get m.DATar
                 read
                 @ 9,20 say m.DATar  colo w+/bg
                 kuda=kuda+1
         endcase
         if kuda<1 .or.kuda=kudak.OR.lastkey()=27
            on key
            exit
         endif
      enddo
      defi wind ws from 16,5 to 19,75 double shad colo sche 5 title zag
      acti wind ws
      @ 1,2  prom'Ввести в базу       '
      @ 1,24 prom'Возврат на изменение'
      @ 1,46 prom'Отмена              '
      menu to mm
      rele wind ws
      rele wind w2
      do case
         case mm=1                              && Ввести в базу
                 sele 32
                 appe blan
                 *WAIT 'M.SHWZ='+M.SHWZ WIND
                 gath memv
                 SELE 29
                 repl ostatok with ostatok-m.kol
                 exit
         case mm=2                             && Отмена ввода/ корректировки
              kuda=1
         case mm=3                             && Отмена ввода/ корректировки
              exit
      endcase
   enddo
   on key
   exit
enddo
return .t.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*** Выбор товара
proc rasnn
*on key
m.kodm=kodm
keyb '{ctrl+w}'
keyb '{Enter}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc avar
defi wind avar from 5,48 to 10,79 colo w+/r
acti wind avar
@ 0,1 say  '  Hет БД &fila               '
@ 1,1  say '  Работать невозможно ! ! !  '
@ 2,1  say '  Hажмите любую клавишу...   '
k=inkey(0)
rele wind avar
cancel
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc osttov
*on key label Ctrl-O do otladka with sys(16)
SAVE SCRE TO SOWA
defi wind ost from 13,34 to 17,63 in screen double colo sche 5
acti wind ost
@ 0,0  prompt ' Отсортирован по позиции  '
@ 1,0  prompt ' Отсортирован по наимен-ю '
@ 2,0  prompt ' Выход                    '
menu to mum
rele wind ost
fl='osttov.txt'
acti wind good
@ 0,1 say 'Файл '+fl+' формируется'
@ 1,1 say 'Ждите...              '
set print to &fl
set device to print
@prow()+1,1 say '                Остатки товаров по складу на '+dtoc(date())
@prow()+1,0 say '---------------------------------------------------------------------------------------------'
@prow()+1,0 say ' N п/п: Дата   :  Наименование                                              : остаток:  цена '
@prow()+1,0 say ' N к.у: оприх. :    ЕИ                                                      :        :       '
@prow()+1,0 say '---------------------------------------------------------------------------------------------'
on key
SELE 29
if mum=1
   set order to ikodm
else
   set order to inaim
endif
set key to
go top
ind=0
do while .not.eof()
   if ostatok>0
      ind=ind+1
   endif
   skip
enddo
kolza=ind
if kolza=0
    wait 'НЕТ ОСТАТКОВ !!!' wind
    deac WIND GOOD
    retu
endif
*wait 'kolza='+str(kolza,3) wind
publ arra kodm_[kolza]
store 0 to kodm_
go top
ind=0
do while .not.eof()
   if ostatok>0
      ind=ind+1
      *wait 'ind='+str(ind,3) wind
      kodm_[ind]=kodm
   endif
   skip
enddo
npp=0
ITOG1=0
ITOG2=0
ind=1
do while ind=<kolza
   SELE 29
   set order to ikodm
   seek kodm_[ind]
   npp=npp+1
   @prow()+1,0 say str(npp,4)+' '+dtoc(data_p)+' '+naim+' ';
                +str(ostatok,6,2)+str(cena,7,2)
   @prow()+1,0 say str(nsk,5)+space(11)+ei
         ITOG1=ITOG1+OSTATOK*CENA
   ind=ind+1
enddo
@prow()+2,0 say 'ИТОГО на сумму'+space(68)+STR(ITOG1,10,2)
on key
deac wind good
set device to scre
do pech
rest scre from sowa
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
** * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc Find_t
on key
r=recno()
namtov=space(7)
defi wind w4 from 16,2 to 19,32 titl 'П О И С К ' double shad colo sche 5
acti wind w4
set cursor on
do case
  case ff=1
    @ 0,1 say' Введите наименование товара '
    @ 1,1 get namtov
    read
    rele wind w4
    set cursor off
    SELE 29
    set order to inat
    seek alltrim(namtov)
    on key label Enter do namt
    on key label F7 do find_t
    on key label Ins do ins_KM
endcase
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc namt
mkodm=kodm
m.kodm=kodm
mnaim =naim
nametov=naim
keyb '{ctrl+w}'
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* РАБОТА СО СПРАВОЧНИКАММИ
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc menuu
para ij
defi wind men from 3+ij,51 to 8+ij,74 shad colo sche 4
acti wind men
@ 0,0  prompt ' Просмотр справочника '
@ 1,0  prompt ' Внесение изменений   '
@ 2,0  prompt ' Печать справочника   '
@ 3,0  prompt ' Выход                '
menu to m0
deac wind men
retu m0
***********************************************************
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc Del_ras
on key
dl=0
r=recno()
defi wind w3 from 18,5 to 21,75 double shad colo sche 5
acti wind w3
@ 0,1 say ' Товар                                Цена  Количество '
scat memv
SELE 29
set order to ikod
seek m.kod
bname=naim
sele 32
@ 1,1  say bname
@ 1,32 say m.cena
@ 1,44 say m.kol
defi wind del from 13,19 to 16,45 in screen double colo sche 5
acti wind del
@ 0,1 say 'Запись будет удалена'
@ 1,2 prompt ' Нет   '
@ 1,16 prompt'  Да   '
menu to ss
do case
   case ss=2
        delete
        on key label Del do Del_ras
        dl=1
   case ss=1
        on key label Del do Del_ras
endcase
deac wind del,w3
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*** Передвижение по окну ввода/корректировки
proc wwerh
kuda=kuda-2
keyb '{Enter}'
retu
***********************************************************
proc fact_begin
  @ prow()+1,0 say '       Н А К Л А Д Н А  № '+bndok
  @ prow()+1,0 say '                      '+dtoc(bdata)
  @ prow()+1,0 say 'Вiдпущено   НПК ООО "АСКЕНН"  '
  @ prow()+1,0 say 'Одержав '+left(ikodpp,30)
  @ prow()+1,0 say 'Через '+cherez
  @ prow()+1,0 say ''
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc fact_hat
  @ prow()+1,0 say '╔═══╤════════════════════════════╤══════╤═════════╤══════════╤═════════╗'
  @ prow()+1,0 say '║No │ Найменування               │  Од. │ Фактично│   Цiна,  │   Сума, ║'
  @ prow()+1,0 say '║п/п│                            │вимiру│вiдпущено│  без ПДВ │ без ПДВ ║'
  @ prow()+1,0 say '╠═══╪════════════════════════════╪══════╪═════════╪══════════╪═════════╣'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc fact_body
  npp=npp+1
  sele 32
  bkodm=kodm
  select 4
  set filt to
  set order to ikodm
  seek str(bkodm,4)
  namtovar=naim
  namediz=ei
  select 32
  cena_b=roun(cena/((100+procnds)/100),2)
  s  =roun(cena*kol,2)
  s_b=roun(cena_b*kol,2)
  s_nds=s-s_b
  @ prow()+1,0 say '║'+str(npp,3)+'│'+left(namtovar,28)+'│ '+lfix(namediz,5)+'│ '+str(kol,8,3)+'│ '+str(cena_b,8,2)+' │ '+str(s_b,8,2)+'║'
  summa_ =summa_ +s
  sum_b  =sum_b  +s_b
  sum_nds=sum_nds+s_nds
  skip
return

proc fact_end
  @ prow()+1,0 say '║----------------------------------------------------------------------║'
  @ prow()+1,0 say '║                                             Всього без ПДВ │'+str(sum_b,9,2)+'║ '
  @ prow()+1,0 say '║                                                  ПДВ (__%) │'+str(sum_nds,9,2)+'║ '
*  summa_=summ+sum_nds
  @ prow()+1,0 say '║                                        Загальна сума з ПДВ │'+str(summa_,9,2)+'║ '
  @ prow()+1,0 say '╚══════════════════════════════════════════════════════════════════════╝'
  @ prow()+1,0 say 'Всього вiдпущено'
  @ prow()+1,0 say 'на суму '+Rfix(MoneyToStr(Sum_b,12,2),60)
  @ prow()+1,0 say '║----------------------------------------------------------------------║'
  @ prow()+1,0 say '║   Керiвник ____________________       Гол.бухгалтер _________________║'
  @ prow()+1,0 say '║   Вiдпустив____________________       Одержав _______________________║'
  @ prow()+1,0 say '╚══════════════════════════════════════════════════════════════════════╝'
  @ prow()+1,0 say ''
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc p_zap
save scre to scrzap
do while .t.
   defi wind pe from 11,18 to 18,50 double shad colo w+/w
   acti wind pe
   SET CURSOR ON
   @0,0 prompt ' Hакладная                     '
   @1,0 prompt ' Лимитно-заборная карта        '
   @2,0 prompt ' Оборотная ведомость ТМЦ       ' && oborot
   @3,0 prompt ' Сводка о поступлении ТМЦ      '
   @4,0 prompt ' Сводка о выдаче ТМЦ           '
   @5,0 prompt ' Выход                         '
   menu to menup
   rele wind pe
   SET CURSOR OFF
   save scre to scr3
   do case
      case menup=0.or.menup=6
           exit
      case menup=1
           publ nampost,namplat,namban1,namban2,brs1,brs2,bmfo1,bmfo2,summ,sum_nds,allrec_sf,allpag_sf
           store 0 to bkodpp,strnum,pagenum,summ,sum_nds,s_nac,s_tr,s_nds,pr_tr,allrec_sf,allpag_sf
           define window w2 from 7,20 to 15,66 title ' Н А К Л А Д Н А Я ' shad close colo sche 10
           acti wind w2
           && Накладная на отпуск
           @ 0,1 say '№ документа                     '  colo gr+/bg
           @ 1,1 say 'Дата                            ' colo gr+/bg
           @ 2,1 say 'Вiдпущено                       ' colo gr+/bg
           @ 3,1 say '                                ' colo gr+/bg
           @ 4,1 say 'Через                           ' colo gr+/bg
           acti wind w2
           kudak=3
           kuda=1
           bndok=space(6)
           cherez=space(20)
           ser=space(5)
           nd=1
           sd=space(10)
           ddata=date()
           set cursor on
           do while .t.
              do while .t.
                 do case
                    case kuda=1                               && N док-та
                         bdata=date()
                         @0,22 get bndok
                         read
                         @0,22 SAY bndok
                         sele 32
                         set filt to doc=bndok
                         go top
                         if .not.eof()
                            bdata=datar
                            msklad=sklad
                         else
                            wait 'не было расхода по такому документу' wind
                            retu
                         endif
                         @1,22 SAY bdata
                         bkodpp=kodpp
                         bpriz=priz
                         if priz=1
                            sele 1
                            set order to ivk
                            seek str(2,4)+str(bkodpp,4)
                            ikodpp='не бывает такого склада'
                            if foun()
                               ikodpp=rtrim(im)
                            endif
                         else
                            sele 17
                            set filt to kodpp=bkodpp
                            go top
                            ikodpp='не бывает такого постащ.-потреб.'
                            if .not.eof()
                               ikodpp=rtrim(imya)
                            endif
                         endif
                         @ 3,1 say left(ikodpp,35) colo w+/bg
                         kuda=kuda+1
                    case kuda=2                               && через
                         @ 4,22 get cherez
                         read
                         @ 4,22 SAY cherez
                         kuda=kuda+1
                 endcase
                 if kuda<1 .or.kuda=kudak.OR.lastkey()=27
                    on key
                    exit
                 endif
              enddo
              defi wind ws from 16,5 to 19,75 double shad colo sche 5
              acti wind ws
              @ 1,2  prom'Создать накладную   '
              @ 1,24 prom'Возврат на изменение'
              @ 1,46 prom'Отмена              '
              menu to m
              rele wind ws
              do case
                 case m=1                              && Создать накладную
                      select 32
                      *set key to dtoc(bdata)+str(bkodpp,5)
                      set filt to doc=bndok
                      go top
                      fl='nakl.txt'
                      defi wind good from 16,20 to 20,60 shad colo sche 5
                      acti wind good
                      @ 0,1 say 'Файл '+fl+' формируется'
                      @ 1,1 say 'Ждите...               '
                      set print to
                      set device to file &fl
                      *pagenum=1
                      *@ prow(),96 say 'F Лист  '+str(pagenum,3)
                      SELE 29
                      go top
                      procnds=20
                      do fact_begin
                      do fact_hat
                      npp =0
                      summa_ =0
                      sum_nds=0
                      sum_b  =0
                      sele 32
                      set filt to doc=bndok
                      go top
                      do while .not. eof()
                         do fact_body
                      enddo
                      do fact_end
                      set print to
                      set device to screen
                      deac wind good,w2
                      do pech
                      exit
                 case m=2                             && Отмена ввода/ корректировки
                      kuda=1
                 case m=3                             && Отмена ввода/ корректировки
                      deac wind w2
                      exit
              endcase
           enddo
      case menup=2
           sele 77
           use dosp26
           set filt to
           go top
           do while .not.eof()
             dele
             skip
           enddo
           sele 1
           set order to ivi
           set key to str(26,4)
           go top
           do while .not.eof()
             if kod#0
                scat memv
                sele 77
                appe blan
                gath memv
                sele 1
             endif
             skip
           enddo
           do f1izd
           define window w2 from 11,20 to 14,56 title ' Л И М И Т К А ' shad close colo sche 10
           acti wind w2
           && лимитка на отпуск
           @ 0,1 say '№ документа                     '  colo gr+/bg
           @ 1,1 say 'Дата                            ' colo gr+/bg
           kudak=3
           kuda=1
           bndok=space(6)
           nd=1
           ddata=date()
           set cursor on
           do while .t.
             do while .t.
                do case
                   case kuda=1                               && N док-та
                        bdata=date()
                        @0,22 get bndok
                        read
                        @0,22 SAY bndok
                        kuda=kuda+1
                   case kuda=2                               && через
                        @ 1,22 get ddata
                        read
                        @ 1,22 SAY ddata
                        kuda=kuda+1
                endcase
                if kuda<1 .or.kuda=kudak.OR.lastkey()=27
                   on key
                   exit
                endif
             enddo
             defi wind ws from 15,25 to 23,55 double shad colo sche 5
             acti wind ws
             @ 0,0 prom 'Форма Ф.60  '
             @ 1,0 prom 'Форма Ф.60 a'
             @ 2,0 prom 'Форма Ф.60 б'
             @ 3,0 prom 'Форма Ф.60 в'
             @ 4,0 prom 'Форма Ф.60 г'
             @ 5,0 prom 'Форма Ф.60 д'
             menu to m
             rele wind ws
             do case
                case m=1                              &&
                     fl='f_60.txt'
                     defi wind good from 16,20 to 20,60 shad colo sche 5
                     acti wind good
                     @ 0,1 say 'Файл '+fl+' формируется'
                     @ 1,1 say 'Ждите...               '
                     set print to
                     set device to file &fl
                     do sha
                     @ prow()+1,0 say ' (кооперацiя виготовлення без порiзки заготовок)                                                               Форма Ф.60'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say 'N скл:                                          :    :       :  До  :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say 'карт.: Позначення та найменування по КД         : Од.: Норма :отри- :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say 'Кор N:                                          :вим.: на од : мання:        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '   1 :          2                               : 3  :    4  :   5  :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------'
                     *wait 'mpozn='+mpozn wind
                     sele 2
                     set filt to
                     sele 29
                     set filt to
                     set order to inaim
                     set key to
                     go top
                     do while .not.eof()
                        if kodm#0
                           mkodm=kodm
                           ikodm=naim
                           nr=0
                           sele 2
                           set order to ipmz
                           set filt to pozn=mpozn.and.kodm=mkodm.and.zo=0.and.mar2=52
                           *set key to mpozn+str(mkodm,4)+str(0,1)
                           go top
                           if .not.eof()
                              *brow  fiel kodm,poznd,kol,wag,rozma,rozmb,nrmd
                              @prow()+1,0 say str(mkodm,4)+' '+ikodm
                              *sele 2
                              do while .not.eof()
                                 if mar2=52
                                    @prow()+1,0 say kornd+' '+poznd;
                                           +' '+naimd;
                                           +'  '+'шт.';
                                           +'  '+str(koli*(mpartz2-mpartz1+1),3)
                                 endif
                                 skip
                              enddo
                           endif
                        endif
                        sele 29
                        skip
                     enddo
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     @ prow()+1,0 say ''
                     set print to
                     set device to screen
                     deac wind good,w2
                     do pech
                     sele 77
                     use
                     exit
                case m=2                              && Создать накладную
                     fl='f_60a.txt'
                     defi wind good from 16,20 to 20,60 shad colo sche 5
                     acti wind good
                     @ 0,1 say 'Файл '+fl+' формируется'
                     @ 1,1 say 'Ждите...               '
                     set print to
                     set device to file &fl
                     do sha
                     @ prow()+1,0 say '(кооперацiя виготовлення з порiзкою заготовок)                                                                                                   Форма Ф.60a'
                     @ prow()+1,0 say '------------------------------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '   Код     :                                                             :    :             :    До    :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say ' N склад.  : Найменування                                                : Од.:    Норма    :  отри-   :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say '   карт.   :    ТМЦ                                                      :вим.:    на од    :   мання  :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '------------------------------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '     1     :          2                                                  : 3  :       4     :     5    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '------------------------------------------------------------------------------------------------------------------------------------------------------------'
                     npp=0
                     summa=0
                     sele 4
                     set order to ikodm
                     set filt to
                     set key to
                     sele 77
                     *set order to ivi
                     go top
                     do while .not. eof()
                        gr_ =kod
                        imgr=im
                        *@ prow()+1,0 say imgr
                        sele 1
                        set order to ivi
                        set key to str(21,4)
                        go top
                        do while .not.eof()
                           sort_=kod
                           imsort=im
                           sele 2
                           set order to igsz
                           *inde on STR(shw,6)+str(gr,3)+str(sort,3)+STR(ZO,1)+str(kodm,4)    tag igsZ
                           *set key to STR(mshw,6)+str(gr_,3)+str(sort_,3)+STR(0,1)
                           set filt to shw=mshw.and.gr=gr_;
                                               .and.sort=sort_;
                                               .and.zo=0;
                                               .and.(mar1=63.or.mar2=>51.and.mar2=<59.or.mar3=>51.and.mar3=<59);
                                               .and.!empt(poznd)

                           go top
                           scat memv
                           otp_=0
                           if .not.eof()
                              *brow
                              otp_=0
                              bil=0
                              na_1=0
                              skip
                              do while .not.eof()
                                 if m.kolz#0
                                    *wait 'm.koli='+str(m.koli,4) wind
                                    *wait 'm.nrmd='+str(m.nrmd,8,2) wind
                                    *wait 'na_1='+str(na_1,8,2) wind
                                    na_1=na_1+m.kolI*m.nrmd
                                 endif
                                 if kodm#m.kodm
                                    sele 32
                                    set filt to
                                    set order to isk
                                    set key to mshwz+str(m.kodm,4)
                                    go top
                                    sum kol to otp_
                                    sele 4
                                    set order to ikodm
                                    *wait '1 m.kodm='+str(m.kodm,5) wind
                                    seek m.kodm
                                    *brow
                                    if foun()
                                       ei_   =ei
                                       kod_  =kod
                                       naim_=naim
                                       oboz_=oboz
                                    else
                                       ei_='*****'
                                       kod_='********'
                                       naim_=repl('*',62)
                                       oboz_=repl('*',54)
                                    endif
                                    npp=npp+1
                                    if bil=0
                                       @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                       bil=1
                                    endif
                                    kol_=mpartz2-mpartz1+1
                                    *wait 'naim='+naim_ wind
                                    *wait 'ei='+ei_ wind
                                    *wait 'na_1='+str(na_1,10,4) wind
                                    *wait 'kol_='+str(kol_,10,4) wind
                                    *wait 'na_1/kol_='+str(na_1/kol_,10,4) wind
                                    *wait 'otp_='+str(otp_,10,4) wind
                                    *wait 'na_1-otp_='+str(na_1-otp_,10,4) wind
                                    @ prow()+1,0 say kod_;
                                                     +' '+naim_;
                                                     +' '+ei_;
                                                     +' '+str(na_1/kol_,10,4);
                                                     +' '+str(na_1-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4) && +space(8)+m_kd2
                                    na_1=0
                                    otp_=0
                                 endif
                                 sele 2
                                 scat memv
                                 skip
                              enddo
                              if m.kolz#0
                                 na_1=na_1+m.kolI*m.nrmd
                              endif
                              if kodm#m.kodm
                                 sele 32
                                 set filt to
                                 set order to isk
                                 set key to mshwz+str(m.kodm,4)
                                 go top
                                 sum kol to otp_
                                 sele 4
                                 set order to ikodm
                                 *   wait '2 m.kodm='+str(m.kodm,5) wind
                                 seek m.kodm
                                 *brow
                                    if foun()
                                       ei_   =ei
                                       kod_  =kod
                                       naim_=naim
                                       oboz_=oboz
                                    else
                                       ei_='!!!!!'
                                       kod_='!!!!!!!!'
                                       naim_=repl('!',62)
                                       oboz_=repl('!',54)
                                    endif
                                 npp=npp+1
                                 if bil=0
                                    @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                    bil=1
                                 endif
                                 @ prow()+1,0 say kod_;
                                                     +' '+naim_;
                                                     +' '+ei_;
                                                     +' '+str(na_1/(mpartz2-mpartz1+1),10,4);
                                                     +' '+str(na_1-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
*                                    @ prow()+1,0 say str(m.kodm,4) &&+space(8)+m_kd2
                                 na_1=0
                                 otp_=0
                              endif
                           endif
                           sele 1
                           skip
                        enddo
                        sele 77
                        skip
                     enddo
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     @ prow()+1,0 say chr(12)
                     do sha
                     @ prow()+1,0 say 'ДОДАТКОВО                                                                                                                    Форма Ф.60a'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '   Код     :                                      :    :             :    До    :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say ' N склад.  : Найменування                         : Од.:    Норма    :  отри-   :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say '   карт.   :    ТМЦ                               :вим.:    на од    :   мання  :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '     1     :          2                           : 3  :       4     :     5    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     npp=0
                     summa=0
                     sele 77
                     *set order to ivi
                     go top
                     do while .not. eof()
                        gr_ =kod
                        imgr=im
                        *@ prow()+1,0 say imgr
                        sele 1
                        set order to ivi
                        set key to str(21,4)
                        go top

                        do while .not.eof()
                           sort_=kod
                           imsort=im
                           *@ prow()+1,0 say '!!!!! '+imsort
                           sele 2
                           set order to igsZ
                           *set key to STR(mshw,6)+str(gr_,3)+str(sort_,3)+STR(1,1)
                           set filt to shw=mshw.and.gr=gr_;
                                               .and.sort=sort_;
                                               .and.zo=1;
                                               .and.(mar1=63.or.mar2=>51.and.mar2=<59.or.mar3=>51.and.mar3=<59);
                                               .and.!empt(poznd)
                           go top
                           *BROW
                           scat memv
                           otp_=0
                           if .not.eof()
                              otp_=0
                              bil=0
                              na_1=0
                              skip
                              do while .not.eof()
                                 if m.kolz#0
                                    na_1=na_1+m.kolI*m.nrmd
                                 endif
                                 if kodm#m.kodm
                                    sele 32
                                    set filt to
                                    set order to isk
                                    set key to mshwz+str(m.kodm,4)
                                    go top
                                    sum kol to otp_
                                    *wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
                                    sele 4
                                    set order to ikodm
                                    seek m.kodm
                                    mater_=naim
                                    ei_   =ei
                                    kod_  =kod
                                    m_kd1=space(40)
                                    m_kd2=space(40)
                                    m_kd=naim
                                    koko=at('\',m_kd)
                                    if koko#0
                                       m_kd1=rfix(left(m_kd,koko-1),40)
                                       m_kd2=subs(m_kd,koko+1)
                                    endif
                                    npp=npp+1
                                    if bil=0
                                       @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                       bil=1
                                    endif
                                    kol_=mpartz2-mpartz1+1
                                    @ prow()+1,0 say kod_;
                                                     +' '+m_kd1;
                                                     +' '+ei_;
                                                     +' '+str(na_1/kol_,10,4);
                                                     +' '+str(na_1-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4)+space(8)+m_kd2
                                    na_1=0
                                    otp_=0
                                 endif
                                 sele 2
                                 scat memv
                                 skip
                              enddo
                                 if m.kolz#0
                                    na_1=na_1+m.kolI*m.nrmd
                                 endif
                              if kodm#m.kodm
                                 sele 32
                                 set filt to
                                 set order to isk
                                 set key to mshwz+str(m.kodm,4)
                                 go top
                                 sum kol to otp_
                                 sele 4
                                 set order to ikodm
                                 seek m.kodm
                                 mater_=oboz
                                 kod_  =kod
                                 ei_   =ei
                                 m_kd1=space(40)
                                 m_kd2=space(40)
                                 m_kd=naim
                                 koko=at('\',m_kd)
                                 if koko#0
                                    m_kd1=rfix(left(m_kd,koko-1),40)
                                    m_kd2=subs(m_kd,koko+1)
                                 endif
                                 npp=npp+1
                                 if bil=0
                                    @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                    bil=1
                                 endif
                                 @ prow()+1,0 say kod_;
                                                     +' '+m_kd1;
                                                     +' '+ei_;
                                                     +' '+str(na_1/(mpartz2-mpartz1+1),10,4);
                                                     +' '+str(na_1-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4)+space(8)+m_kd2
                                 na_1=0
                                 otp_=0
                              endif
                           endif
                           sele 1
                           skip
                        enddo
                        sele 77
                        skip
                     enddo
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     @ prow()+1,0 say ''
                     set print to
                     set device to screen
                     deac wind good,w2
                     do pech
                     sele 77
                     use
                     exit
                case m=3                             && Отмена ввода/ корректировки
                     fl='f_60b.txt'
                     defi wind good from 16,20 to 20,60 shad colo sche 5
                     acti wind good
                     @ 0,1 say 'Файл '+fl+' формируется'
                     @ 1,1 say 'Ждите...               '
                     set print to
                     set device to file &fl
                     do sha
                     @ prow()+1,0 say ' (кооперацiя виготовлення з порiзкою заготовок)                                                                       Форма Ф.60 б'
                     @ prow()+1,0 say '----------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say ' N : Кор. :                                          : Од.: К-ть   :До отри-::Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say 'п/п:  N   : Позначення та найменування по КД         :вим.:у виробi: мання  ::ранiше  :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис: вiдп.:'
                     @ prow()+1,0 say '---------------------------------------------------------------------------------------------------------------------------------:'
                     @ prow()+1,0 say ' 1 :  2   :          3                               : 4  :   5    :   6    :    7    :  8 :  9  :   10 : 11 : 12  :  13  :  14  :'
                     @ prow()+1,0 say '---------------------------------------------------------------------------------------------------------------------------------:'
                     npp=0
                     summa=0
                     sele 2
                     set order to ipoznd
                     set filt to shw=mshw.and.zo=0;
                                         .and.(mar3=52.or.mar3=57)
                     go top
                     if .not.eof()
                        do while .not.eof()
                           npp=npp+1
                           @ prow()+1,0 say str(npp,3);
                                               +' '+kornd;
                                               +' '+poznd;
                                               +' '+naimd;
                                               +' '+ei;
                                               +' '+str(koli,4);
                                               +' '+str(koli*(mpartz2-mpartz1+1),8)

                           skip
                        enddo
                     endif
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     @ prow()+1,0 say ''
                     do sha
                     @ prow()+1,0 say 'ДОДАТКОВО                                                                                                                Форма Ф.60б'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '   Код     :                                      :    :             :    До    :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say ' N склад.  : Найменування                         : Од.:    Норма    :  отри-   :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say '   карт.   :    ТМЦ                               :вим.:    на од    :   мання  :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '     1     :          2                           : 3  :       4     :     5    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     npp=0
                     summa=0

                     set order to ipoznd
                     set filt to shw=mshw.and.zo=1;
                                         .and.(mar3=52.or.mar3=57)
                     go top
                     if .not.eof()
                        do while .not.eof()
                           npp=npp+1
                           @ prow()+1,0 say str(npp,3);
                                               +' '+kornd;
                                               +' '+poznd;
                                               +' '+naimd;
                                               +' '+ei;
                                               +' '+str(koli,4);
                                               +' '+str(koli*(mpartz2-mpartz1+1),8)
                           sele 2
                           skip
                        enddo
                     endif
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     set print to
                     set device to screen
                     deac wind good,w2
                     do pech
                     sele 77
                     use
                     exit
                case m=4                             && Отмена ввода/ корректировки
                     fl='f60v.txt'
                     defi wind good from 16,20 to 20,60 shad colo sche 5
                     acti wind good
                     @ 0,1 say 'Файл '+fl+' формируется'
                     @ 1,1 say 'Ждите...               '
                     set print to
                     set device to file &fl
                     do sha
                     @ prow()+1,0 say '(комплектуючi та покупнi)                                                                                                                    Форма Ф60 в'
                     @ prow()+1,0 say '--------------------------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '   Код     :                                                         :    :             :    До    :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say ' N склад.  : Найменування                                            : Од.:    Норма    :  отри-   :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say '   карт.   :    ТМЦ                                                  :вим.:    на од    :   мання  :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '--------------------------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '     1     :          2                                              : 3  :       4     :     5    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '--------------------------------------------------------------------------------------------------------------------------------------------------------'
                     npp=0
                     summa=0
                     SELE 1
                     set filt to
                     SELE 32
                     set filt to
                     sele 77
                     *set order to ivi
                     go top
                     do while .not. eof()
                        gr_ =kod
                        imgr=im
                        *@ prow()+1,0 say imgr
                        sele 1
                        set order to ivi
                        set key to str(21,4)
                        go top
                        do while .not.eof()
                           sort_=kod
                           imsort=im
                           sele 2
                           set order to igsz
                           *inde on STR(shw,6)+str(gr,3)+str(sort,3)+str(kodm,4)+STR(ZO,1)    tag igsZ
                           *set key to STR(mshw,6)+str(gr_,3)+str(sort_,3)+STR(0,1)
                           set filt to shw=mshw.and.gr=gr_;
                                              .and.sort=sort_;
                                              .and.zo=0;
                                             .and.kodm>m.glMater
                           *select KODM, koli from kt where shw=mshw;
                           *and gr=gr_ and sort=sort_ and zo=0 and kodm>m.glMater;
                           *into cursor curs1
                           *sele curs1
                           go top
                           scat memv
                           otp_=0
                           if .not.eof()
                              otp_=0
                              bil=0
                              na_1=0
                              skip
                              do while .not.eof()
                                 na_1=na_1+m.kolI
                                 *if m.kodm=2512
                                    *wait 'na_1='+str(na_1,3)+' m.kodm='+str(m.kodm,5) wind
                                 *endif
                                 if kodm#m.kodm
                                    sele 32
                                    set order to isk
                                    set key to mshwz+str(m.kodm,4)
                                    sum kol to otp_
                                    sele 29
                                    set order to ikodm
                                    seek m.kodm
                                    naim_ =naim
                                    ei_   =ei
                                    kod_  =kod
                                    npp=npp+1
                                    if bil=0
                                       @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                       bil=1
                                    endif
                                    kol_=mpartz2-mpartz1+1
                                    @ prow()+1,0 say kod_;
                                                     +' '+naim_;
                                                     +' '+ei_;
                                                     +' '+str(na_1,10,4);
                                                     +' '+str(na_1*(mpartz2-mpartz1+1)-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4) &&+space(8)+m_kd2
                                    na_1=0
                                    otp_=0
                                 endif
                                 sele 2
                                 *sele curs1
                                 scat memv
                                 *WAIT 'SELE CURS1 SCAT SKIP' WIND
                                 skip
                              enddo
                              na_1=na_1+m.kolI
                              if kodm#m.kodm
                                 sele 32
                                 set order to isk
                                 set key to mshwz+str(m.kodm,4)
                                 go top
                                 sum kol to otp_
                                 sele 29
                                 set order to ikodm
                                 seek m.kodm
                                 naim_=naim
                                 kod_ =kod
                                 ei_  =ei
                                 npp=npp+1
                                 if bil=0
                                    @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                    bil=1
                                 endif
                                 @ prow()+1,0 say kod_;
                                                     +' '+naim_;
                                                     +' '+ei_;
                                                     +' '+str(na_1,10,4);
                                                     +' '+str(na_1*(mpartz2-mpartz1+1)-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4) &&+space(8)+m_kd2
                                 na_1=0
                                 otp_=0
                              endif
                           endif
                           sele 1
                           skip
                        enddo
                        sele 77
                        skip
                     enddo
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     @ prow()+1,0 say ''
                     do sha
                     @ prow()+1,0 say 'ДОДАТКОВО                                                                                                                  Форма Ф60в'
                     @ prow()+1,0 say '--------------------------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '   Код     :                                                         :    :             :    До    :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say ' N склад.  : Найменування                                            : Од.:    Норма    :  отри-   :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say '   карт.   :    ТМЦ                                                  :вим.:    на од    :   мання  :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '--------------------------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '     1     :          2                                              : 3  :       4     :     5    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '--------------------------------------------------------------------------------------------------------------------------------------------------------'

                     npp=0
                     summa=0
                     sele 77
                     *set order to ivi
                     go top
                     do while .not. eof()
                        gr_ =kod
                        imgr=im
                        *@ prow()+1,0 say imgr
                        sele 1
                        set order to ivi
                        set key to str(21,4)
                        go top
                        do while .not.eof()
                           sort_=kod
                           imsort=im
                           *@ prow()+1,0 say '!!!!! '+imsort
                           sele 2
                           set order to igsZ
                           set filt to shw=mshw.and.gr=gr_.and.sort=sort_.and.zo=0.and.kodm>m.glMater
                           *set key to STR(mshw,6)+str(gr_,3)+str(sort_,3)+STR(1,1)
                           *select KODM, koli from kt where shw=mshw;
                           *and gr=gr_ and sort=sort_ and zo=0 and kodm>m.glMater;
                           *INTO CURSOR CURS1
                           go top
                           *BROW
                           scat memv
                           otp_=0
                           if .not.eof()
                              otp_=0
                              bil=0
                              na_1=0
                              skip
                              do while .not.eof()
                                 na_1=na_1+m.kolI
                                 if kodm#m.kodm
                                    sele 32
                                    set order to isk
                                    set key to mshwz+str(m.kodm,4)
                                    sum kol to otp_
                                    sele 29
                                    set order to ikodm
                                    seek m.kodm
                                    naim_=naim
                                    ei_  =ei
                                    kod_ =kod
                                    npp=npp+1
                                    if bil=0
                                       @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                       bil=1
                                    endif
                                    kol_=mpartz2-mpartz1+1
                                    @ prow()+1,0 say kod_;
                                                     +' '+naim_;
                                                     +' '+ei_;
                                                     +' '+str(na_1,10,4);
                                                     +' '+str(na_1*(mpartz2-mpartz1+1)-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4) &&+space(8)+m_kd2
                                    na_1=0
                                    otp_=0
                                 endif
                                 sele 2
                                 *SELE CURS1
                                 scat memv
                                 skip
                              enddo
                              na_1=na_1+m.kolI
                              if kodm#m.kodm
                                 sele 32
                                 set order to isk
                                 set key to mshwz+str(m.kodm,4)
                                 sum kol to otp_
                                 sele 29
                                 set order to ikodm
                                 seek m.kodm
                                 naim_=naim
                                 mater_=oboz
                                 kod_  =kod
                                 ei_   =ei
                                 npp=npp+1
                                 if bil=0
                                    @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                    bil=1
                                 endif
                                 @ prow()+1,0 say kod_;
                                         +' '+naim_;
                                         +' '+ei_;
                                         +' '+str(na_1,10,4);
                                         +' '+str(na_1*(mpartz2-mpartz1+1)-otp_,10,4);
                                         +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4) &&+space(8)+m_kd2
                                 na_1=0
                                 otp_=0
                              endif
                           endif
                           sele 1
                           skip
                        enddo
                        sele 77
                        skip
                     enddo
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     @ prow()+1,0 say ''
                     set print to
                     set device to screen
                     deac wind good,w2
                     do pech
                     sele 77
                     use
                     exit
                case m=5                             && Отмена ввода/ корректировки
                     defi wind god from 10,14 to 18,55 double shad titl ' УЧАСТОК ' colo sche 10
                     acti wind god
                     @ 0,0 prom koo[1]
                     @ 1,0 prom koo[2]
                     @ 2,0 prom koo[3]
                     @ 3,0 prom koo[4]
                     @ 4,0 prom koo[5]
                     @ 5,0 prom koo[6]
                     @ 6,0 prom koo[7]
                     menu to uch
                     u_=uch+50
                     rele wind god
                     fl='f60g.txt'
                     defi wind good from 16,20 to 20,60 shad colo sche 5
                     acti wind good
                     @ 0,1 say 'Файл '+fl+' формируется'
                     @ 1,1 say 'Ждите...               '
                     set print to
                     set device to file &fl
                     do sha
                     @ prow()+1,0 say '(послуги по маршруту виготовлення '+koo[uch]+' Форма Ф.60г'
                     @ prow()+1,0 say '---------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say ' N : Кор. :                                          : Од.: К-ть   :До отри-:Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say 'п/п:  N   : Позначення та найменування по КД         :вим.:у виробi: мання  :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say '   :      :                                          :    :        :        :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '----------------------------------------------------------------------------:----------------------------------------------------'
                     @ prow()+1,0 say ' 1 :  2   :          3                               : 4  :   5    :   6    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '---------------------------------------------------------------------------------------------------------------------------------'
                     npp=0
                     summa=0
                     sele 2
                     set order to ipoznd
                     set filt to shw=mshw.and.zo=0;
                     .and.(mar4=u_.or.mar5=u_.or.mar6=u_.or.mar7=u_.or.mar8=u_.or.mar9=u_.or.mar10=u_)
                     go top
                     if .not.eof()
                        do while .not.eof()
                           npp=npp+1
                           @ prow()+1,0 say str(npp,3);
                                               +' '+kornd;
                                               +' '+poznd;
                                               +' '+naimd;
                                               +' '+ei;
                                               +' '+str(koli,4);
                                               +' '+str(koli*(mpartz2-mpartz1+1),8)

                           skip
                        enddo
                     endif
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     @ prow()+1,0 say ''
                     do sha
                     @ prow()+1,0 say 'ДОДАТКОВО (послуги по маршруту виготовлення '+koo[uch]+' Форма Ф.60г'
                     @ prow()+1,0 say '---------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say ' N : Кор. :                                          : Од.: К-ть   :До отри-:Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say 'п/п:  N   : Позначення та найменування по КД         :вим.:у виробi: мання  :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say '   :      :                                          :    :        :        :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '----------------------------------------------------------------------------:----------------------------------------------------'
                     @ prow()+1,0 say ' 1 :  2   :          3                               : 4  :   5    :   6    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '---------------------------------------------------------------------------------------------------------------------------------'


                     npp=0
                     summa=0

                     set order to ipoznd
                     set filt to shw=mshw.and.zo=1;
                     .and.(mar4=u_.or.mar5=u_.or.mar6=u_.or.mar7=u_.or.mar8=u_.or.mar9=u_.or.mar10=u_)
                     go top
                     if .not.eof()
                        do while .not.eof()
                           npp=npp+1
                           @ prow()+1,0 say str(npp,3);
                                               +' '+kornd;
                                               +' '+poznd;
                                               +' '+naimd;
                                               +' '+ei;
                                               +' '+str(koli,4);
                                               +' '+str(koli*(mpartz2-mpartz1+1),8)
                           sele 2
                           skip
                        enddo
                     endif
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     set print to
                     set device to screen
                     deac wind good,w2
                     do pech
                     sele 77
                     use
                     exit

                case m=6                             && Отмена ввода/ корректировки
                     fl='f60d.txt'
                     defi wind good from 16,20 to 20,60 shad colo sche 5
                     acti wind good
                     @ 0,1 say 'Файл '+fl+' формируется'
                     @ 1,1 say 'Ждите...               '
                     set print to
                     set device to file &fl
                     do sha
                     @ prow()+1,0 say '(кооперацiя виготовлення без порiзки заготовок)                                                                                Ф.60д '
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '   Код     :                                      :    :             :    До    :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say ' N склад.  : Найменування                         : Од.:    Норма    :  отри-   :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say '   карт.   :    ТМЦ                               :вим.:    на од    :   мання  :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '     1     :          2                           : 3  :       4     :     5    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     npp=0
                     summa=0
                     sele 77
                     *set order to ivi
                     go top
                     do while .not. eof()
                        gr_ =kod
                        imgr=im
                        *@ prow()+1,0 say imgr
                        sele 1
                        set order to ivi
                        set key to str(21,4)
                        go top
                        do while .not.eof()
                           sort_=kod
                           imsort=im
                           if gr_=1.and.sort_=1
                              *wait 'gr='+str(gr_,4)+' sort='+str(sort_,4) wind
                           endif
                           sele 2
                           set order to igsz
                           *inde on STR(shw,6)+str(gr,3)+str(sort,3)+str(kodm,4)+STR(ZO,1)    tag igsZ
                           *set key to STR(mshw,6)+str(gr_,3)+str(sort_,3)+STR(0,1)
                           set filt to shw=mshw.and.gr=gr_.and.sort=sort_.and.zo=0.and.mar2=52
                           go top
                           if gr_=1.and.sort_=1
                              *brow
                           endif
                           scat memv
                           otp_=0
                           if .not.eof()
                              *brow
                              otp_=0
                              bil=0
                              na_1=0
                              skip
                              do while .not.eof()
                                 if m.kolz#0
                                    na_1=na_1+m.kolI*m.nrmd
                                 endif
                                 *IF M.KODM=1122
                                 *   wait 'm.kolI*m.nrmd/m.kolz=';
                                 *   +' '+str(m.kolI,3);
                                 *   +' '+str(m.nrmd,8,3);
                                 *   +' '+str(m.kolz,3);
                                 *   +' =  '+str(na_1,8,3);
                                 *    wind
                                 *endif
                                 if kodm#m.kodm
                                    sele 32
                                    set filt to
                                    set order to isk
                                    set key to mshwz+str(m.kodm,4)
                                    go top
                                    sum kol to otp_
                                    *if eof()
                                    *   WAIT 'm.kodm='+str(m.kodm,4)+' MSHWZ='+MSHWZ+' нет в RASHOD!!' WIND
                                    *else
                                    *   wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
                                    *endif
                                    *brow
                                    *wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
                                    sele 4
                                    set order to ikodm
                                    seek m.kodm
                                    mater_=naim
                                    ei_   =ei
                                    kod_  =kod
                                    m_kd1=space(40)
                                    m_kd2=space(40)
                                    m_kd=naim
                                    koko=at('\',m_kd)
                                    if koko#0
                                       m_kd1=rfix(left(m_kd,koko-1),40)
                                       m_kd2=subs(m_kd,koko+1)
                                    endif
                                    npp=npp+1
                                    if bil=0
                                       @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                       bil=1
                                    endif
                                    kol_=mpartz2-mpartz1+1
                                    @ prow()+1,0 say kod_;
                                                     +' '+m_kd1;
                                                     +' '+ei_;
                                                     +' '+str(na_1/kol_,10,4);
                                                     +' '+str(na_1-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4)+space(8)+m_kd2
                                    na_1=0
                                    otp_=0
                                 endif
                                 sele 2
                                 scat memv
                                 skip
                              enddo
                              if m.kolz#0
                                 na_1=na_1+m.kolI*m.nrmd
                              endif
                                 *IF M.KODM=1122
                                 *   wait 'enddo m.kolI*m.nrmd/m.kolz=';
                                 *   +' '+str(m.kolI,3);
                                 *   +' '+str(m.nrmd,8,3);
                                 *   +' '+str(m.kolz,3);
                                 *   +' =  '+str(na_1,8,3);
                                 *    wind
                                 *endif
                              if kodm#m.kodm
                                 sele 32
                                 set filt to
                                 set order to isk
                                 set key to mshwz+str(m.kodm,4)
                                 go top
                                 sum kol to otp_

                                    *go top
                                    *if eof()
                                    *   WAIT 'm.kodm='+str(m.kodm,4)+' MSHWZ='+MSHWZ+' нет в RASHOD!!' WIND
                                    *else
                                    *   wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
                                    *endif
                                 *brow
                                 sele 4
                                 set order to ikodm
                                 seek m.kodm
                                 mater_=oboz
                                 kod_  =kod
                                 ei_   =ei
                                 m_kd1=space(40)
                                 m_kd2=space(40)
                                 m_kd=naim
                                 koko=at('\',m_kd)
                                 if koko#0
                                    m_kd1=rfix(left(m_kd,koko-1),40)
                                    m_kd2=subs(m_kd,koko+1)
                                 endif
                                 npp=npp+1
                                 if bil=0
                                    @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                    bil=1
                                 endif
                                 @ prow()+1,0 say kod_;
                                                     +' '+m_kd1;
                                                     +' '+ei_;
                                                     +' '+str(na_1/(mpartz2-mpartz1+1),10,4);
                                                     +' '+str(na_1-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4)+space(8)+m_kd2
                                 na_1=0
                                 otp_=0
                              endif
                           endif
                           sele 1
                           skip
                        enddo
                        sele 77
                        skip
                     enddo
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     @ prow()+1,0 say ''
                     do sha
                     @ prow()+1,0 say 'ДОДАТКОВО'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '   Код     :                                      :    :             :    До    :Oтримано:   Вiдпущено     :   Вiдпущено     :Всього:'
                     @ prow()+1,0 say ' N склад.  : Найменування                         : Од.:    Норма    :  отри-   :ранiше  :-----------------:-----------------: вiдп.:'
                     @ prow()+1,0 say '   карт.   :    ТМЦ                               :вим.:    на од    :   мання  :        :К-ть: Дата:Пiдпис:К-ть: Дата:Пiдпис:      :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     @ prow()+1,0 say '     1     :          2                           : 3  :       4     :     5    :    6   :  7 :  8  :   9  : 10 :  11 :  12  :  13  :'
                     @ prow()+1,0 say '-------------------------------------------------------------------------------------------------------------------------------------'
                     npp=0
                     summa=0
                     sele 77
                     *set order to ivi
                     go top
                     do while .not. eof()
                        gr_ =kod
                        imgr=im
                        *@ prow()+1,0 say imgr
                        sele 1
                        set order to ivi
                        set key to str(21,4)
                        go top
                        do while .not.eof()
                           sort_=kod
                           imsort=im
                           *@ prow()+1,0 say '!!!!! '+imsort
                           sele 2
                           set order to igsZ
                           *set key to STR(mshw,6)+str(gr_,3)+str(sort_,3)+STR(1,1)
                           set filt to shw=mshw.and.gr=gr_.and.sort=sort_.and.zo=1.and.mar2=52
                           go top
                           *BROW
                           scat memv
                           otp_=0
                           if .not.eof()
                              otp_=0
                              bil=0
                              na_1=0
                              skip
                              do while .not.eof()
                                 if m.kolz#0
                                    na_1=na_1+m.kolI*m.nrmd
                                 endif
                                 *IF M.KODM=1122
                                 *   wait 'm.kolI*m.nrmd/m.kolz=';
                                 *   +' '+str(m.kolI,3);
                                 *   +' '+str(m.nrmd,8,3);
                                 *   +' '+str(m.kolz,3);
                                 *   +' =  '+str(na_1,8,3);
                                 *    wind
                                 *endif
                                 if kodm#m.kodm
                                    sele 32
                                    set filt to
                                    set order to isk
                                    set key to mshwz+str(m.kodm,4)
                                    go top
                                    sum kol to otp_
                                    *if eof()
                                    *   WAIT 'm.kodm='+str(m.kodm,4)+' MSHWZ='+MSHWZ+' нет в RASHOD!!' WIND
                                    *else
                                    *   wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
                                    *endif
                                    *brow
                                    *wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
                                    sele 4
                                    set order to ikodm
                                    seek m.kodm
                                    mater_=naim
                                    ei_   =ei
                                    kod_  =kod
                                    m_kd1=space(40)
                                    m_kd2=space(40)
                                    m_kd=naim
                                    koko=at('\',m_kd)
                                    if koko#0
                                       m_kd1=rfix(left(m_kd,koko-1),40)
                                       m_kd2=subs(m_kd,koko+1)
                                    endif
                                    npp=npp+1
                                    if bil=0
                                       @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                       bil=1
                                    endif
                                    kol_=mpartz2-mpartz1+1
                                    @ prow()+1,0 say kod_;
                                                     +' '+m_kd1;
                                                     +' '+ei_;
                                                     +' '+str(na_1/kol_,10,4);
                                                     +' '+str(na_1-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4)+space(8)+m_kd2
                                    na_1=0
                                    otp_=0
                                 endif
                                 sele 2
                                 scat memv
                                 skip
                              enddo
                                 if m.kolz#0
                                    na_1=na_1+m.kolI*m.nrmd
                                 endif
                                 *IF M.KODM=1122
                                 *   wait 'enddo m.kolI*m.nrmd/m.kolz=';
                                 *   +' '+str(m.kolI,3);
                                 *   +' '+str(m.nrmd,8,3);
                                 *   +' '+str(m.kolz,3);
                                 *   +' =  '+str(na_1,8,3);
                                 *    wind
                                 *endif
                              if kodm#m.kodm
                                 sele 32
                                 set filt to
                                 set order to isk
                                 set key to mshwz+str(m.kodm,4)
                                 go top
                                 sum kol to otp_

                                    *go top
                                    *if eof()
                                    *   WAIT 'm.kodm='+str(m.kodm,4)+' MSHWZ='+MSHWZ+' нет в RASHOD!!' WIND
                                    *else
                                    *   wait 'm.kodm='+str(m.kodm,4)+' otp_='+str(otp_,6,2) wind
                                    *endif
                                 *brow
                                 sele 4
                                 set order to ikodm
                                 seek m.kodm
                                 mater_=oboz
                                 kod_  =kod
                                 ei_   =ei
                                 m_kd1=space(40)
                                 m_kd2=space(40)
                                 m_kd=naim
                                 koko=at('\',m_kd)
                                 if koko#0
                                    m_kd1=rfix(left(m_kd,koko-1),40)
                                    m_kd2=subs(m_kd,koko+1)
                                 endif
                                 npp=npp+1
                                 if bil=0
                                    @ prow()+1,0 say allt(imgr)+' '+allt(imsort)
                                    bil=1
                                 endif
                                 @ prow()+1,0 say kod_;
                                                     +' '+m_kd1;
                                                     +' '+ei_;
                                                     +' '+str(na_1/(mpartz2-mpartz1+1),10,4);
                                                     +' '+str(na_1-otp_,10,4);
                                                     +' '+iif(otp_#0,str(otp_,10,3),'')
                                    @ prow()+1,0 say str(m.kodm,4)+space(8)+m_kd2
                                 na_1=0
                                 otp_=0
                              endif
                           endif
                           sele 1
                           skip
                        enddo
                        sele 77
                        skip
                     enddo
                     @ prow()+1,0 say '   Начальник БК                         О.А.Панченко'
                     @ prow()+1,0 say ''
                     set print to
                     set device to screen
                     deac wind good,w2
                     do pech
                     sele 77
                     use
                     exit
             endcase
             deac wind w2
             exit
           enddo
           retu
      case menup=3
           do oborotkm
      case menup=4               && сводка о поступлении ТМЦ
           do wwodmes
           do wwodgod
           fl='pri.txt'
           acti wind good
           @ 0,1 say 'Файл '+fl+' формируется'
           @ 1,1 say 'Ждите...              '
           set print to &fl
           set device to print
           @prow()+1,1 say '         Сводка о поступлении ТМЦ по складу '
           @prow()+1,1 say '                за '+me[bmes]+' '+str(bgod,4)+' г.'
           @prow()+1,0 say '---------------------------------------------------------------------:'
           @prow()+1,0 say 'N п/п:N с\к:Наименование      :  ЕИ :Дата пост. : К-во   : Сумма пост.'
           @prow()+1,0 say '---------------------------------------------------------------------:'
           sup=0
           npp=0
           SELE 29
           set order to inada
           set filt to mont(data_p)=bmes.and.year(data_p)=bgod
           go top
           do while .not.eof()
              imat=left(naim,20)
              mediz  =ei
              npp=npp+1
              @ prow()+1,0 say str(npp,3)+' '+str(nsk,7)+' '+left(imat,20);
              +' '+mediz+' '+dtoc(data_p)+' '+str(kol,8,3)+' '+str(cena*kol,10,2)
              sup=sup+cena*kol
              SKIP
           ENDDO
           @prow()+1,1 say 'ИТОГО  '
           @prow(),58 say sup pict '9999999.99'
           deac wind good
           set device to scre
           do pech
           SELE 29
           set filt to
      case menup=5                      && расход ТМЦ
           do wwodmes
           do wwodgod
           fl='ras.txt'
           acti wind good
           @ 0,1 say 'Файл '+fl+' формируется'
           @ 1,1 say 'Ждите...              '
           set print to &fl
           set device to print
           @prow()+1,1 say '        Сводка о выдаче ТМЦ со склада '
           @prow()+1,1 say '                за '+me[bmes]+' '+str(bgod,4)+' г.'
           @prow()+1,0 say '--------------------------------------------------------------------------------'
           @prow()+1,0 say 'N п/п: N партии : Наименование ТМЦ                             :№ док. :  К-во  '
           @prow()+1,0 say '  Дата оп:Изделие                    :Потребитель              :  ЕИ   : Сумма  '
           @prow()+1,0 say '--------------------------------------------------------------------------------'
           npp=0
           sur=0
           sele 32
           set filt to mont(datar)=bmes.and.year(datar)=bgod
           sum kol to sur
           go top
           do while .not.eof()
              scat memv
              sele 8
              set order to ishwz
              seek m.shwz
              if foun()
                 namizd=left(im,30)
                 z1=partz1
                 z2=partz2
              else
                 namizd=space(30)
                 z1=0
                 z2=0
              endif
              SELE 29
              set order to ikodm
              seek m.kodm
              if foun()
                 imat=naim
              else
                 imat='нет в справочнике   '
                 ipp=imat
              endif
              mediz  =left(ei,3)
              if m.priz=2
                 sele 17
                 set filt to kodpp=m.kodpp
                 go top
                 if .not.eof()
                    ipp=left(imya,30)
                 endif
              else
                 sele 1
                 set order to ivk
                 seek str(2,4)+str(m.kodpp,4)
                 ipp='не бывает такого склада'
                 if foun()
                    ipp=left(im,30)
                 endif
              endif
              sele 32
              npp=npp+1
              @ prow()+1,0 say str(npp,3)+space(1)+str(z1,5)+' - '+allt(str(z2,5))
              @ prow(),17 say left(imat,45)+'   '+doc+' '+str(kol,8,3)
              @ prow()+1,0 say dtoc(datar)+' '+namizd+' '+ipp+'   '+mediz+' '+str(cena*kol,10,2)
              SKIP
           ENDDO
           @prow()+1,1 say 'ИТОГО '
           @prow(),60 say sur pict '9999999.99'
           deac wind good
           set device to scre
           do pech
   endcase
   rest scre from scr3
enddo
rest scre from scrzap
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc f1pp
on key
defi wind w33 from 15,5 to 17,75 double shad colo sche 10 && gr+/b
acti wind w33
m.priz=1
@0,0 prom '        Подраз-ния  пред-тия          '
@0,38 prom ' Другие организации            '
menu to m.priz
*wait 'm.priz='+str(m.priz,1) wind
rele wind w33
if m.priz=2
   sele 17
   set order to inam
   set filt to
   go top
   defi wind wv from 5,34 to 16,76 title 'Добавить - Ins  Поиск - F7' double shad colo sche 10
   acti wind wv
   on key label F7  do find_pp
   on key label Ins do ins_post
   on key label Del do Del_post
   on key label Enter do poo
   brow fiel imya:H='Поставщики, потребители' in wind wv noed
   on key
   rele wind wv
   *keyb '{Enter}'
else
   sele 1
   set order to ivi
   set filt to vid=2.and.kod#0
   go top
   *loca for left(im,3)='Скл'
   defi wind wv from 5,34 to 16,76 title 'ВЫБОР - Enter' double shad colo sche 10
   acti wind wv
   on key label Enter do sss
   brow fiel im:H='Поставщики, потребители' in wind wv noed
   set filt to
   on key
   rele wind wv
   *keyb '{Enter}'
endif
on key
retu .f.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc Ins_post
sele 17
set order to kdp
go bott
bkodpp=kodpp
scat memv blank
m.kodpp=bkodpp+1
on key
do while .t.
   defi wind w3 from 16,5 to 23,75 double shad colo sche 5 title 'Ввод новой записи'
   acti wind w3
   @ 0,1 say ' Код   Hаименование предприятия    Адрес'
   @ 2,1 say ' Банк                              Р/с              МФО'
   @ 4,1 say ' Код по ЕДРПОУ    Индивид.налог.№' &&    № свидетельства'
   set cursor on
   @ 1,1  say m.kodpp pict '99999'
   @ 1,8  get m.imya
   @ 1,30 get m.adr
   @ 3,1  get m.rekv
   @ 3,33 get m.nrs
   @ 3,48 get m.mfo
   @ 5,1  get m.edrpou
   @ 5,21 get m.ipn
   *@ 5,35 get m.nsv
   read
   @ 5,2  prom'Ввести в базу       '
   @ 5,24 prom'Возврат на изменение'
   @ 5,46 prom'Отмена строки       '
   menu to m
   do case
      case m=1                           && Внести в базу
           append blank
           gather memv
           exit
      case m=2                           && Возврат на корректировку
      case m=3                           && Отмена
           on key label F7 do find_pp
           on key label Ins do ins_post
           on key label Enter do poo
           exit
   endcase
enddo
on key label F7 do find_pp
on key label Ins do ins_post
on key label Enter do poo
set cursor off
rele wind w3
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc poo
on key
m.kodpp=kodpp
ikodpp =imya
keyb '{ctrl+w}'
return
proc sss
m.kodpp=kod
ikodpp =im
keyb '{ctrl+w}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc Find_pp
on key
r=recno()
namtov=space(6)
defi wind w3 from 18,2 to 22,52 titl 'П О И С К ' double shad colo sche 5
acti wind w3
set cursor on
       @ 0,1 say ' Введите наименование контрагента '
       @ 1,1 get namtov
       read
       sele 17
       set order to inam
       seek alltrim(namtov)
       on key label F7 do find_pp
       on key label Enter do poo
rele wind w3
set cursor off
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc Del_post
defi wind w3 from 16,11 to 21,58 double shad colo sche 5
acti wind w3
@ 0,1 say ' Код   Hаименование предприятия        '
@ 2,1 say ' Банк                              Р/с '
@ 1,1  say kodpp pict '99999'
@ 1,8  say imya
@ 3,1  say rekv
@ 3,33 say nrs
defi wind del from 12,19 to 15,45 in screen double colo sche 5
acti wind del
@ 0,1 say 'Запись будет удалена'
@ 1,2 prompt ' Нет   '
@ 1,16 prompt' Да    '
menu to ss
if ss=2
   delete
   on key label F7 do find_pp
   on key label Ins do ins_post
   on key label Del do Del_post
   on key label Enter do poo
endif
deac wind del,w3
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
***********************************************************
*КЛАССИФИКАТОР МАТЕРИАЛОВ
proc Kmat
on key
publ kodv,imv,ngr
defi wind wmat from 12,15 to 19,40 title 'wmat' double shad colo w+/w
save scre to emat
do while .t.
   acti wind wmat
   @ 0,0 prompt ' Ввод в справочник '
   @ 1,0 prompt ' Просмотр          '
   @ 2,0 prompt ' Изменения         '
   @ 3,0 prompt ' Печать            '
   @ 4,0 prompt ' формировать       '
   @ 5,0 prompt ' Выход             '
   menu to m_mat
   if lastkey()=27
      exit
   endif
   SELE 29
   do case
      case m_mat=1                                     && Ввод
           do ins_KM
      case m_mat=2                               && Просмотр
           defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
           acti wind w3
           @1,2  prom '   ВСЕ    '
           @1,46 prom ' выборочно'
           menu to m_w_n
           rele wind w3
           define window w4 from 1,11 to 22,79 title 'Каталог материалов'  double close colo sche 10
           define window w1 from 1,0 to 16,9 title '  W1  ' double close colo sche 10
           define window w2 from 0,0 to 16,9 in window w1 title '  W2  ' double fill '█' colo sche 10
           if m_w_n=1
              acti wind w4
              SELE 29
              set order to inaim
              set filt to
              set key to
              go top
              on key
              SET CURSOR OFF
              brow fiel kodm:H='№ ксу'  wind w2 noedit when Ekr()
              on key
              rele wind w1,w2,w4
           else
              defi wind w33 from 14,25 to 23,45 double shad colo gr+/b &&title zag
              acti wind w33
              @ 0,0 prom ' ПО ГРУППЕ        '
              @ 1,0 prom ' ПО СОРТАМЕНТУ    '
              @ 2,0 prom ' ПО ПОСТАВКЕ      '
              @ 3,0 prom ' КОНТЕКСТНIЙ ПОИСК'
              @ 4,0 prom ' ПО N КАРТОЧКИ    '
              @ 5,0 prom ' ПО КОДУ          '
              @ 6,0 prom ' ВIХОД            '
              menu to m0
              rele wind w33
              acti wind w4
              SELE 29
              set order to inaim
              DO WHILE .T.
                 DO CASE
                    CASE M0=0.OR.M0=7.OR.LAST()=27
                         rele wind w1,w2,w4
                         EXIT
                    CASE M0=1
                         on key
                         sele 1
                         set order to ivi
                         set filt to Vid=26 .and. Kod # 0
                         go top
                         defi wind wv from 5,33 to 16,75 title 'ГРУППА МАТЕРИАЛОВ' double shad colo sche 10
                         acti wind wv
                         on key label Enter do eee
                         brow fiel kod:H='Код',im:H='Hаименование',us in wind wv noed
                         on key
                         mgr=kodv
                         rele wind wv
                         SELE 29
                         set order to inaim
                         set key to
                         set filt to gr=mgr
                         go top
                         on key
                         SET CURSOR OFF
                         brow fiel kodm:H='№ ксу'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
                         SELE 1
                         SET FILT TO
                         SELE 29
                         SET FILT TO
                    CASE M0=2
                         on key
                         sele 1
                         set filt to Vid=21.and.KOD#0
                         go top
                         defi wind wv from 5,33 to 16,75 title 'СОРТАМЕНТ' double shad colo sche 10
                         acti wind wv
                         SET CURSOR OFF
                         on key label Enter do eee
                         brow fiel kod:H='Код',im:H=' НАИМЕНОВАНИЕ ',us  in wind wv noed
                         msort=kodv
                         on key
                         rele wind wv
                         SELE 29
                         set filt to SORT=mSORT
                         go top
                         SET CURSOR OFF
                         brow fiel kodm:H='№ ксу'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
                         SELE 1
                         SET FILT TO
                         SELE 29
                         SET FILT TO
                    CASE M0=3
                         on key
                         sele 1
                         set filt to Vid=22.and.KOD#0
                         go top
                         defi wind wv from 5,1 to 16,75 title 'СТАНДАРТ ПОСТАВКИ' double shad colo sche 10
                         acti wind wv
                         SET CURSOR OFF
                         on key label Ins   do ins_sp
                         on key label Enter do eee
                         brow fiel kod:H='Код',im:H=' НАИМЕНОВАНИЕ ',sim:H='ГОСТ',us  in wind wv noed
                         msp=kodv
                         *wait 'msp='+str(msp,2)  wind
                         on key
                         rele wind wv
                         SELE 29
                         set filt to SP=mSP
                         go top
                         SET CURSOR OFF
                         brow fiel kodm:H='№ ксу'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
                         SELE 1
                         SET FILT TO
                         SELE 29
                         SET FILT TO
                    CASE M0=4
                         do f7km
                         if last()#27
                         
                            SELE 29
                            set filt to kodm=mkodm
                            go top
                            SET CURSOR OFF
                            brow fiel kodm:H='№ карт.'  wind w2 noedit when Ekr()
                            rele wind w1,w2,w4
                            SELE 29
                            SET FILT TO
                         endif
                    CASE M0=5
                         defi wind w_3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                         acti wind w_3
                         @1,2  say ' Введите N'
                         mkodm=0
                         @1,46 get mkodm
                         read
                         rele wind w_3
                         SELE 29
                         set filt to kodm=mkodm
                         go top
                         on key
                         SET CURSOR OFF
                         brow fiel kodm:H='№ ксу'  wind w2 noedit when Ekr()
                         SELE 29
                         SET FILT TO
                         rele wind w1,w2,w4
                    CASE M0=6
                         defi wind w_3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                         acti wind w_3
                         @1,2  say ' Введите шифр'
                         mkod=space(11)
                         @1,46 get mkod
                         read
                         rele wind w_3
                         SELE 29
                         set filt to kod=mkod
                         go top
                         on key
                         SET CURSOR OFF
                         brow fiel kodm:H='№ ксу'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
                         SELE 29
                         SET FILT TO
                 ENDCASE
              ENDDO
           endif
           on key
      case m_mat=3                                     && Внесение изменений
           defi wind w33 from 16,25 to 21,45 double shad colo gr+/b &&title zag
           acti wind w33
           @ 0,0 prom ' КОНТЕКСТНIЙ ПОИСК'
           @ 1,0 prom ' ПО N КАРТОЧКИ    '
           @ 2,0 prom ' ПО КОДУ          '
           @ 3,0 prom ' ВIХОД            '
           menu to m0
           rele wind w33
           SELE 29
           set order to inaim
           DO WHILE .T.
              DO CASE
                 CASE M0=0.OR.M0=4.OR.LAST()=27
                      rele wind w1,w2,w4
                      EXIT
                 CASE M0=1
                      do f7km
                      if last()#27
                         SELE 29
                         set filt to kodm=mkodm
                         go top
                         do rabota
                         sele 29
                         set filt to
                      endif
                 CASE M0=2
                      defi wind w_3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                      acti wind w_3
                      @1,2  say ' Введите N'
                      mkodm=0
                      @1,46 get mkodm
                      read
                      rele wind w_3
                      if last()#27
                         SELE 29
                         set filt to kodm=mkodm
                         go top
                         do rabota
                         SELE 29
                         set filt to
                      endif
                 CASE M0=3
                      defi wind w_3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                      acti wind w_3
                      @1,2  say ' Введите шифр'
                      mkod=space(11)
                      @1,46 get mkod
                      read
                      rele wind w_3
                      if last()#27
                         SELE 29
                         set filt to kod=mkod
                         go top
                         do rabota
                         SELE 29
                         set filt to
                      endif
              ENDCASE
           ENDDO
           on key
      case m_mat=4                                     && Печать
           on key
           fl='mat.txt '
           *set color to w+/r
           set cursor off
           acti wind good
           @ 0,1 say 'Файл '+fl+' для печати формируется'
           @ 1,1 say 'Ждите...'
           set print to &fl
           set device to print
           @prow()+1,0 say'                            КАТАЛОГ МАТЕРИАЛIВ '
           @prow()+1,0 say 'станом на '+dtoc(date())
           @prow()+1,0 say '-----------------------------------------------------------------------------------------------------------------------------------------'
           @prow()+1,0 say ' №   №   Гр. Сорт Х/с Сп   Шифр      Наименування  по ГОСТ                                        Найменування                           '
           @prow()+1,0 say 'п/п карт                                                                                          по накл                                '
           @prow()+1,0 say '-----------------------------------------------------------------------------------------------------------------------------------------'
           sele 1
           set filt to Vid=26.and.Kod#0
           go top
           do while .not. eof()
              npp=0
              mgr=kod
              imgr=im
              SELE 29
              set order to inaim
              *set filt to gr=mgr.and.sort=ns
              set filt to gr=mgr
              go top
              if .not.eof()
                 @prow()+1,0 say imgr
                 do while .not.eof()
                    *@prow()+1,0 say str(kodm,4)+' 'str(kodm,4)+' '+naim+' '+ei+' '+str(kol,8,3)+' '+str(cena,8,2)
                    npp=npp+1
                    @prow()+1,0 say str(npp,4)+' '+str(kodm,4);
                                              +' '+str(gr,2);
                                              +' '+str(sort,3);
                                              +' '+str(sp,3);
                                              +' '+kod;
                                              +' '+naim;
                                              +' '+oboz
                                       skip
                 enddo
              endif
              sele 1
              skip
           enddo
           set print on
           set device to screen
           do pech
           deac wind good
           sele 1
           set filt to


      case m_mat=5
           SELE 29
           set filt to
           go top
           do while .not.eof()
              kod_=strt(str(gr,2)+str(sort,3)+str(sp,3),' ','0')
              repl kod with kod_
              SELE 29
              skip
           enddo
      case m_mat=6.or.m_mat=0
           exit
   endcase &&m_mat
enddo
rele wind wmat
rest scre from emat
SELE 29
set filt to
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Экран просмотра
proc Ekr
do Ekr4 with 2
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc Ekr3
do Ekr4 with 3
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc rabota
on key
define window w4 from 1,11 to 22,79 title '' Double close colo sche 10
define window w1 from 1,0 to 19,9 title '' double close colo w+/w
define window w2 from 0,0 to 19,9 in window w1 title'            ' double fill '█' colo sche 10
acti wind w4
SELE 29
SET CURSOR OFF
on key label Enter do Ekr4 with 3
*on key label Del do Del_kart
*go top
brow fiel kodm:H='№ карточки'  wind w2 noedit when Ekr()
rele wind w1,w2,w4
on key
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc Ekr4
para p
* 2- просмотр
* 3- внесение изменений + Enter
*on key
*wait 'p='+str(p,2) wind
SELE 29
scat memv
@ 0,1 say 'Склад                                   N док-та        'colo gr+/bg
@ 1,1 say 'Код ОКПО                                                'colo gr+/bg
@ 2,1 say 'Поставщик                                               'colo gr+/bg
@ 3,1 say 'Признак поставки                                        'colo gr+/bg
@ 4,1 say 'Группа                                                  'colo gr+/bg
@ 5,1 say 'Сортамент                                               'colo gr+/bg
@ 6,1 say 'Стандарт поставки                                       'colo gr+/bg
@ 7,1 say '                                                        'colo gr+/bg
@ 8,1 say 'Порядк.(№ склад.карт.)                  Код             'colo gr+/bg
@ 9,1 say 'Наименование                                            'colo gr+/bg
@10,1 say 'по накладной                                            'colo gr+/bg
@11,1 say '                                                        'colo gr+/bg
@12,1 say '                                                        'colo gr+/bg
@13,1 say '                                                        'colo gr+/bg
@14,1 say '                                                        'colo gr+/bg
@15,1 say '                                                        'colo gr+/bg
@16,1 say 'Единица измерения                                       'colo gr+/bg
@17,1 say 'Цена за единицу грн.коп.                                'colo gr+/bg
@18,1 say 'Поступление  К-во                       Дата            'colo gr+/bg
@19,1 say 'Остаток Кол-во        Сальдо            Дата            'colo gr+/bg
sele 1
set filt to
set order to ivk
seek str(26,4)+str(m.gr,4)
ngr=im
seek str(21,4)+str(m.sort,4)
isort=im
seek str(22,4)+str(m.sp,4)
nsp=im
if m.gr#0
   @ 4,20 say str(M.GR,2)  +' '+ngr
else
   @ 4,20 say space(43)
endif
if m.sort#0
   @ 5,20 say str(M.sort,3)+' '+isort
else
   @ 5,20 say space(44)
endif
if m.sp#0
   @ 6,20 say str(M.sp,3)  +' '+nsp
else
   @ 6,20 say space(44)
endif
@ 8,20 say M.kodm
@ 8,50 say M.kod
@ 9,0  say m.naim
@10,14 say m.OBOZ
@16,26 say M.ei
@17,26 say M.cena
@18,26 say M.kol
@18,46 say M.DATA_p
@19,8  say M.OSTATOK pict '999999.999'
@19,30 say M.SALDO_O pict '999999.999'
@19,46 say M.DATA_O
if p=3
   set cursor on
   @10,14 GET m.OBOZ
   @16,26 get M.ei
   @17,26 get M.cena
   @18,26 get M.kol
   @18,46 get M.DATA_p
   @19,8  get M.OSTATOK
   @19,30 get M.SALDO_O
   @19,46 get M.DATA_O
   read
 @ 4,50 say M.kod
 @ 5,0  say m.naim
 @ 6,24 say m.OBOZ
 @12,26 say M.ei
 @13,26 say M.cena
 @14,26 say M.kol
 @15,26 say M.DATA_p
 @16,26 say M.OSTATOK
 @17,26 say M.SALDO_O
 @18,26 say M.DATA_O
 on key
              defi wind w_w from 15,5 to 17,75 double shad colo gr+/b
              acti wind w_w
              @ 0,2  prom ' Ввести в базу '
              @ 0,46 prom ' Hет '
              menu to m_m
              rele wind w_w
              if m_m=1                              && Ввести в базу
   SELE 29
   gath memv
   *retu
   endif
on key
endif
if m_mat=3
*   on key label Del do Del_kart
   on key label Enter do Ekr4 with 3
endif
return .t.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
**** Удаление записи
Proc Del_kart
on key
dl=0
r=recno()
defi wind w3 from 18,19 to 21,45 double shad colo gr+/b
acti wind w3
@ 0,1 say'  N карт. Дата выдачи'
@ 1,2  say nkart colo w+/b
@ 1,11 say dkart1 colo w+/b
defi wind del from 13,19 to 16,45 in screen double colo gr+/b
acti wind del
@ 0,1 say 'Запись будет удалена'
*set color to gr+/r,gr+/b
@ 1,2 prompt '  Да   '
@ 1,16 prompt' Hет   '
menu to ss
deac wind del
do case
   case ss=2
        delete
*        on key label Del do Del_kart
        on key label Enter do Ekr4 with 3
   case ss=1
*        on key label Del do Del_kart
        on key label Enter do Ekr4 with 3
endcase
deac wind w3
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
menu to ss
deac wind del
do case
   case ss=2
        delete
*        on key label Del do Del_kart
        on key label Enter do Ekr4 with 3
        dl=1
   case ss=1
*        on key label Del do Del_kart
        on key label Enter do Ekr4 with 3
endcase
deac wind w3
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*** Передвижение по окну ввода/корректировки
proc wwerh
kuda=kuda-2
keyb '{Enter}'
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc eee
imv=im
kodv=kod
keyb '{ctrl+w}'
*on key
return
* для удобного поиска и записи ТМЦ необходимо вид=26 "группа материалов"светить
* на экран полностю
*  выбрав по ключу определенную группу материалов (кроме тех позиций где
*   условия=0 )вибираем ее код в условиях "классификатора сортамент вид=21"который
*   соответствует  коду 26 виду
 *  если условия равны 0 то светим все сортаментные позиции с кодом "0" отсекая
 * таким образом лишнюю информацию
 *  в вид=22 (госты поставок) посколько они оригинальные  буде стоять в условиях
 * код с классификатора 21
 *  в вид=23 (госты химсостава)посколько они соответствуют групе материалов
 *  в условиях будет проставлен код вида 26
 * Ввод в условия видов 21,22и 23 необходимо учесть при появлении новой записи
 *После окончательного доввода ТМЦ необходимо светить по формированию с
 *МАТЕR и KM  (полную запись обозначения) для
 *дальнейшей его корректировки и правильной записи в базу
  * * * * * * * * * * * * * * * * * * * * * * * *
proc sha
                        @ prow()+1,0 say ' Склад №'+space(60)+'Виправлення, змiни i доповнення'
                        @ prow()+1,0 say ' ЛIМIТНО-ЗАБIРНА КАРТА № '+bndok+space(36)+' забороненi катeгорично'
                        @ prow()+1,0 say ' Дата виписки '+dtoc(bdata)+space(43)+' Змiни i доповнення вносить'
                        @ prow()+1,0 say 'Шифр заказу '+mshwz+space(48)+'спецiалiст БК з пiдписом'
                        @ prow()+1,0 say 'Кiлькiсть виробiв '+str(mpartz2-mpartz1+1,4)+' N '+allt(str(mpartz1,4))+'-'+allt(str(mpartz2,4))
retu