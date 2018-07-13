*КЛАССИФИКАТОР МАТЕРИАЛОВ
proc mat
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
   sele 4
   do case
      case m_mat=1                                     && Ввод
           do ins_tov
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
              sele 4
              set filt to
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
              @ 2,0 prom ' ПО ХИМСОСТАВУ    '
              @ 3,0 prom ' ПО ПОСТАВКЕ      '
              @ 4,0 prom ' КОНТЕКСТНIЙ ПОИСК'
              @ 5,0 prom ' ПО N КАРТОЧКИ    '
              @ 6,0 prom ' ПО КОДУ          '
              @ 7,0 prom ' ВIХОД            '
              menu to m0
              rele wind w33
              acti wind w4
              sele 4
              set order to inaim
              DO WHILE .T.
                 DO CASE
                    CASE M0=0.OR.M0=8.OR.LAST()=27
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
                         SELE 4
                         set filt to gr=mgr
                         go top
                         on key
                         SET CURSOR OFF
                         brow fiel kodm:H='№ карт.'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
                         SELE 1
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
                         SELE 4
                         set filt to SORT=mSORT
                         go top
                         SET CURSOR OFF
                         brow fiel kodm:H='№ карт.'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
                         SELE 1
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
                         SELE 4
                         set filt to SP=mSP
                         go top
                         SET CURSOR OFF
                         brow fiel kodm:H='№ карт.'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
                         SELE 1
                         SET FILT TO
                    CASE M0=4
                         on key
                         sele 1
                         set filt to Vid=23.and.KOD#0
                         go top
                         defi wind wv from 5,1 to 16,75 title 'СТАНДАРТ ХИМСОСТАВА' double shad colo sche 10
                         acti wind wv
                         SET CURSOR OFF
                         on key label Enter do eee
                         brow fiel kod:H='Код',im:H=' НАИМЕНОВАНИЕ ',sim:H='ГОСТ',us  in wind wv noed
                         msh=kodv
                         on key
                         rele wind wv
                         SELE 4
                         set filt to SH=mSH
                         go top
                         SET CURSOR OFF
                         brow fiel kodm:H='№ карт.'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
                         SELE 1
                         SET FILT TO
                    CASE M0=5
                         do f7mat
                         if last()#27
                            SELE 4
                            set filt to kodm=mkodm
                            go top
                            on key
                            SET CURSOR OFF
                            brow fiel kodm:H='№ карт.'  wind w2 noedit when Ekr()
                            rele wind w1,w2,w4
                         endi
                    CASE M0=6
                         defi wind w_3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                         acti wind w_3
                         @1,2  say ' Введите N'
                         mkodm=0
                         @1,46 get mkodm
                         read
                         rele wind w_3
                         SELE 4
                         set filt to kodm=mkodm
                         go top
                         on key
                         SET CURSOR OFF
                         brow fiel kodm:H='№ карт.'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
                    CASE M0=7
                         defi wind w_3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                         acti wind w_3
                         @1,2  say ' Введите шифр'
                         mkod=space(11)
                         @1,46 get mkod
                         read
                         rele wind w_3
                         SELE 4
                         set filt to kod=mkod
                         go top
                         on key
                         SET CURSOR OFF
                         brow fiel kodm:H='№ карт.'  wind w2 noedit when Ekr()
                         rele wind w1,w2,w4
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
           sele 4
           set order to inaim
           DO WHILE .T.
              DO CASE
                 CASE M0=0.OR.M0=4.OR.LAST()=27
                      rele wind w1,w2,w4
                      EXIT
                 CASE M0=1
                      on key
                      do f7mat
                      SELE 4
                      set filt to kodm=mkodm
                      go top
                      do rabota
                 CASE M0=2
                      defi wind w_3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                      acti wind w_3
                      @1,2  say ' Введите N'
                      mkodm=0
                      @1,46 get mkodm
                      read
                      rele wind w_3
                      SELE 4
                      set filt to kodm=mkodm
                      go top
                      do rabota
                 CASE M0=3
                      defi wind w_3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                      acti wind w_3
                      @1,2  say ' Введите шифр'
                      mkod=space(11)
                      @1,46 get mkod
                      read
                      rele wind w_3
                      SELE 4
                      set filt to kod=mkod
                      go top
                      do rabota
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
              sele 4
              set order to inaim
              *set filt to gr=mgr.and.sort=ns
              set filt to gr=mgr
              go top
              if .not.eof()
                 @prow()+1,0 say imgr
                 do while .not.eof()
                    *@prow()+1,0 say str(kodm,4)+' 'str(kodm,4)+' '+naim+' '+ei+' '+str(kol,8,3)+' '+str(cena,8,2)+' '+str(uv,6,3)
                    npp=npp+1
                    @prow()+1,0 say str(npp,4)+' '+str(kodm,4);
                                              +' '+str(gr,2);
                                              +' '+str(sort,3);
                                              +' '+str(sp,3);
                                              +' '+str(sh,3);
                                              +' '+kod;
                                              +' '+left(naim,60);
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
           defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
           acti wind w3
           @1,2  prom ' наименование '
           @1,46 prom ' шифр'
           menu to n_k
           rele wind w3
           if n_k=1
              sele 4
              set filt to
              go top
              do while .not.eof()
                 kuku=''
                 scat memv
                 sele 1
                 set filt to
                 ngr=''
                 if m.gr#0
                    set order to ivk
                    seek str(26,4)+str(m.gr,4)
                    ngr=im
                 endif
                 isort=''
                 if m.sort#0
                    seek str(21,4)+str(m.sort,4)
                    isort=im
                 endif
                 nsp=''
                 if m.sp#0
                    seek str(22,4)+str(m.sp,4)
                    nsp=im
                 endif
                 nsh=''
                 if m.sh#0
                    seek str(23,4)+str(m.sh,4)
                    nsh=im
                 endif
                 if m.sort=1.or.m.sort=4.or.m.sort=16
                    kuku=allt(str(m.tm,6,2))+'x'+allt(str(m.shp,6))+'x'+allt(str(m.dp,5))
                 endif
                 if m.sort=5
                    kuku=allt(str(m.tm,6,2))+'x'+allt(str(m.dp,5))
                 endif
                 if m.sort=2.or.m.sort=13.or.m.sort=15
                    kuku=allt(str(m.dm,5,1))+'x'+allt(str(m.dp,5))
                 endif
                 if (m.sort=>6.and.m.sort=<12).or.m.sort=14
                    kuku=allt(str(m.nsort,5,1))+'x'+allt(str(m.dp,5))
                 endif
                 m.naim=allt(isort)+' '+kuku+' '+allt(nsp)+' '+allt(nsh)
                 sele 4
                 repl naim with m.naim
                 skip
              enddo
           else
              sele 4
              set filt to
              go top
              do while .not.eof()
                 kod_=strt(str(gr,2)+str(sort,3)+str(sp,3)+str(sh,3),' ','0')
                 repl kod with kod_
                 sele 4
                 skip
              enddo
           endif
      case m_mat=6.or.m_mat=0
           exit
   endcase &&m_mat
enddo
rele wind wmat
rest scre from emat
sele 4
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
sele 4
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
sele 4
scat memv
@ 0,1 say 'Склад                                   N док-та        'colo gr+/bg
@ 1,1 say 'Код ОКПО                                                'colo gr+/bg
@ 2,1 say 'Поставщик                                               'colo gr+/bg
@ 3,1 say 'Признак поставки                                        'colo gr+/bg
@ 4,1 say 'Группа                                                  'colo gr+/bg
@ 5,1 say 'Сортамент                                               'colo gr+/bg
@ 6,1 say 'Стандарт поставки                                       'colo gr+/bg
@ 7,1 say 'Стандарт химсостава                                     'colo gr+/bg
@ 8,1 say 'Порядк.(№ склад.карт.)                  Код             'colo gr+/bg
@ 9,1 say 'Наименование                                            'colo gr+/bg
@10,1 say 'по накладной                                            'colo gr+/bg
@11,1 say 'Толщина (мм)                            Диаметр(мм)     'colo gr+/bg
@12,1 say 'Номер сортамента                                        'colo gr+/bg
@13,1 say 'Длина в поставке(мм)                                    'colo gr+/bg
@14,1 say 'Ширина в поставке(мм)                                   'colo gr+/bg
@15,1 say 'Площадь сечения(кв.мм)                  Удельний вес    'colo gr+/bg
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
seek str(23,4)+str(m.sh,4)
nsh=im
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
if m.sh#0
   @ 7,21 say str(M.sh,3)  +' '+nsh
else
   @ 7,21 say space(44)
endif
@ 8,20 say M.kodm
@ 8,50 say M.kod
@ 9,0  say m.naim
@10,14 say m.OBOZ
@11,15 say M.tm
@11,52 say M.dm pict '999.9'
@12,26 say M.nsort
@13,26 say M.dp
@14,26 say M.shp
@15,26 say M.ps
@15,55 say M.uv pict '999999'
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
   @11,15 get M.tm
   @11,52 get M.dm pict '999.9'
   @12,26 get M.nsort
   @13,26 get M.dp
   @14,26 get M.shp
   @15,26 get M.ps
   @15,55 get M.uv
   @16,26 get M.ei
   @17,26 get M.cena
   @18,26 get M.kol
   @18,46 get M.DATA_p
   @19,8  get M.OSTATOK
   @19,30 get M.SALDO_O
   @19,46 get M.DATA_O
   read
 @ 4,20 say M.kodm
 @ 4,50 say M.kod
 @ 5,0  say m.naim
 @ 6,24 say m.OBOZ
 @ 7,15 say M.tm
 @ 7,46 say M.dm
 @ 8,26 say M.nsort
 @ 9,26 say M.dp
 @10,26 say M.shp
 @11,26 say M.ps
 @12,26 say M.ei
 @13,26 say M.cena
 @14,26 say M.kol
 @15,26 say M.DATA_p
 @16,26 say M.OSTATOK
 @17,26 say M.SALDO_O
 @18,26 say M.DATA_O
 @19,26 say M.uv
 on key
              defi wind w_w from 15,5 to 17,75 double shad colo gr+/b
              acti wind w_w
              @ 0,2  prom ' Ввести в базу '
              @ 0,46 prom ' Hет '
              menu to m_m
              rele wind w_w
              if m_m=1                              && Ввести в базу
   sele 4
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

