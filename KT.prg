********    С В И    БАЗА  ************
proc Kt
SELE 4
SET FILT TO
defi wind good from 16,20 to 20,60 shad colo w+/bg
publ npozn,mshwot
bmes=mont(date())
save scree to skt
defi wind wwod from 3,10 to 17,38 double shad colo w+/w
do while .t.
   acti wind wwod
   @ 0,0 prompt ' Подетальный ввод          '
   @ 1,0 prompt ' Ввод вспомогат.материалов '
   @ 2,0 prompt ' Ввод комплект. материалов '
   @ 3,0 prompt ' Работа с БД               '
   @ 4,0 prompt ' Выборка по короткому N    '
   @ 5,0 prompt ' Выборка по обозначению    '
   @ 6,0 prompt ' Выборка по № извещения    '
   @ 7,0 prompt ' Модифицировать изделие    '
  *@ 8,0 prompt ' Дополнение техн-эк. БД    '
   @ 8,0 prompt ' Расчет кол-ва в изделии   '
   @ 9,0 prompt ' Удаление БД СВИ           '
   @10,0 prompt ' Установ.приоритетов сборки'
   @11,0 prompt ' Формир. машкомплекта      '
   @12,0 prompt ' Выход                     '
   menu to mm0
   do case
      case mm0=13.or.mm0=0.or.last()=27                 && Выход
           exit
      case mm0=1                                        && Пооперационный ввод
           on key
           define window wiza from 2,2 to 10,75 title 'Ввод ' double shad close colo sche 10
           acti wind wiza
           SET CURS ON
           @ 1,0 say 'Дата ввода'
           @ 2,0 say 'Шифр изделия'
           @ 3,0 say 'Короткий № узла'
           @ 4,0 say 'Обозначение узла'
           @ 5,0 say 'Наименование узла'
           @ 6,0 say 'Разработчик'
           sele 2
           scat memv blan
           m.datv=date()
           @ 1,24 get m.datv
           ribf_=space(20)
           im_=space(40)
           @ 2,14 get m.pozn when vgsm()
           @ 3,24 get M.KORNW
           m.poznw=m.pozn
           @ 4,24 say M.POZNW colo gr+/bg
           @ 4,24 get M.POZNW
           @ 5,24 get m.naimw
           @ 6,24 get m.razr
           read
*wait 'ribf_='+ribf_ wind
           deac wind wiza
           if last()=27
              exit
           endif
           define window w1 from 2,2 to 22,78 title 'Ввод СВИ и расчет норм рахода материалов' double shad close colo sche 10
           acti wind w1
           @ 0,1 say 'Дата ввода                          Разработчик            'colo gr+/bg
           @ 1,1 say 'Изделие                                                    'colo gr+/bg
           @ 2,1 say 'Корот.№ узла                        Шифр издeлия           'colo gr+/bg
           @ 3,1 say 'Узeл                                                       'colo gr+/bg
           @ 4,1 say 'Деталь-Узел                                                'colo gr+/bg
           @ 5,1 say 'Корот.№ детали                                             'colo gr+/bg
           @ 6,1 say 'Деталь                                                     'colo gr+/bg
           @ 7,1 say 'Кол_во в узле                                              'colo gr+/bg
           @ 8,1 say 'Кол-во с загот.                     Масса заготовки        'colo gr+/bg
           @ 9,1 say 'Mатериал                                                   'colo gr+/bg
           @10,1 say 'Разм.загот.-длина                                          'colo gr+/bg
           @11,1 say '(№ сортам.диам.шир.)                Масса детали           'colo gr+/bg
           @12,1 say 'Tиповый техпроцесс                                         'colo gr+/bg
           @13,1 say 'Расх.на ед.(кг,кв.м.)               Един.измер.            'colo gr+/bg
           @14,1 say 'Технол.маршрут                                             'colo gr+/bg
           @15,1 say '                                    N док-та               'colo gr+/bg
           @16,1 say '                                    Дата изм.док-та        'colo gr+/bg
           @17,1 say '                                    Причина                'colo gr+/bg
           @18,1 say 'Заменен ли материал??                                      'colo gr+/bg
           @ 0,12 say m.datv
           @ 0,52 say m.razr
           @ 1,10 say M.POZN+' '+npozn
           @ 2,15 say m.kornw
           @ 2,52 say m.shw
           @ 3,6  say M.POZNW+' '+M.NAIMW
           M.KORND=M.KORNW
           M.POZND=M.POZNW
           M.NAIMD=M.NAIMW
           M.KOL  =1
           @ 5,19 say M.KORND
           @ 6,8  say M.POZND
           @ 6,30 say M.NAIMD
           mmar=0
           do while .t.
              kudak=27
              kuda=1
              do while.t.
                 do case
                    case kuda=1                                     &&
                         on key label uparrow do wwerh
                         defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                         acti wind w3
                         *set color to gr+/b,gr+/g
                         @1,2  prom ' ДЕТАЛЬ '
                         @1,46 prom ' УЗЕЛ '
                         menu to m.d_u
                         rele wind w3
                         @ 4,19 say iif(m.d_u=2,'УЗЕЛ','ДЕТАЛЬ') colo w+/bg
                         kuda=kuda+1
                    case kuda=2                                     && Корот.№ детали
                         on key label uparrow do wwerh
                         @ 5,19 get M.KORND
                         read
                         sele 2
                         *wait  str(m.shw)+' '+m.kornw+' '+m.kornd wind
                         *brow fiel shw,kornw,kornd
                         set filt to shw=m.shw.and.kornw=m.kornw.and.kornd=m.kornd
                         go top
                         if .not.eof()
                            wait 'ДЕТАЛЬ УЖЕ ВВЕДЕНА !!!' wind
                            kuda=kuda-1
                         ENDIF
                         @ 5,19 say M.KORND colo w+/bg
                         kuda=kuda+1
                    case kuda=3                                    && Обозн. детали
                         on key label uparrow do wwerh
                         @ 6,8 get M.POZND
                         read
                         @ 6,8 say M.POZND colo w+/bg
                         kuda=kuda+1
                    case kuda=4                &&
                         on key label uparrow do wwerh
                         @ 6,30 get m.naimd
                         read
                         @ 6,30 say m.naimd  colo w+/bg
                         kuda=kuda+1
                    case kuda=5               &&
                         on key label uparrow do wwerh
                         @ 7,21 get m.kol
                         read
                         @ 7,21 say m.kol colo w+/bg
                         kuda=kuda+1
                    case kuda=6                &&
                         on key label uparrow do wwerh
                         @8,19 get m.kolz
                         read
                         @8,19 say m.kolz  colo w+/bg
                         kuda=kuda+1
                    case kuda=7                                   && Материал
                         on key label uparrow do wwerh
                         on key label f1 do f1mat
                         on key label f7 do f7mat
                         @9,10 get m.kodm pict '9999'
                         read
                         naimm=space(52)
                         iei=space(5)
                         mtm=0
                         if m.kodm#0
                            if !empt(m.poznw)
                               naimm=zad
                               sele 4
                               set order to ikodm
                               seek m.kodm
                               if foun()
                                  naimm=naim
                                  iei  =ei
                                  mtm  =tm
                               else
                                  sele 29
                                  set filt to kodm=m.kodm
                                  go top
                                  if .not.eof()
                                     naimm=naim
                                     iei  =ei
                                     mtm  =tm
                                  endif
                               endif
                               @ 9,10 say str(M.KODM,4)+' '+naimm colo w+/bg
                            endif
                         endif
                         @13,52 say iei                     colo w+/bg
                         kuda=kuda+1
                    case kuda=8             && длина
                         on key label uparrow do wwerh
                         @10,20 get m.rozma
                         read
                         if m.kolz>1
                            m.rozma=40+(m.rozma+5)*m.kolz
                         endif
                         @10,20 say m.rozma colo w+/bg
                         kuda=kuda+1
                    case kuda=9            &&
                         on key label uparrow do wwerh
                         @11,20 get m.rozmb
                         read
                         @11,20 sAY m.rozmb colo w+/bg
                         kuda=kuda+1
                    case kuda=10                  &&
                         on key label uparrow do wwerh
                         on key label F1 do f1ttp
                         @12,20 get m.kttp
                         read
                         if !empt(m.kttp)
                            sele 1
                            set order to ivs
                            seek str(9,4)+m.kttp
                            if foun()
                               nttp=im
                            else
                               nttp=zad
                            endif
                            *@12,20 say allt(m.kttp)+' '+rfix(NTTP,33) colo w+/bg
                            @12,20 say m.kttp+' '+rfix(NTTP,33) colo w+/bg
                         endif
                         kuda=kuda+1
                    case kuda=11            && расчет норм расхода мат-ла на 1 деталь
                         ** SELE 1, VID=9
                         ** ДЛЯ ВСЕХ SORT=1  ЗАПИСЫВАТЬ ОБОЗНАЧЕНИЕ  TM X SHP X DP
                         sele 1
                         set order to ivs
                         seek str(9,4)+m.kttp
                         mus=0
                         if foun()
                            mus=us
                         endif
                         sele 4
                         set order to ikodm
                         seek m.kodm
                         if !foun()
                            wait 'НЕТ ТАКОГО МАТЕРИАЛА!!!' wind
                         endif
                         ** для всех us 1 по 8 включительно в фомулах rozma и rozmb менять между собой
                         *и принимать ND ,болшего значения  nd1 и nd2 брать только целые числа
                         *WAIT 'sort='+str(sort,2)+' mus='+str(mus,1)+' m.rozma='+str(m.rozma,4)+' m.rozmb='+str(m.rozmb,4) WIND
                         if sort=1.or.sort=16
                            && 1 ВАРИАНТ
                            nd1=0
                            nd2=0
                            if mUS=1.and.mtm<=5.and.m.ROZMA>=90.and.m.ROZMB>=90
                               ND1=int(DP/ROZMA)
                               ND2=int(SHP/ROZMB)
                            endif
                            if mus=2.and.mtm<=5.m.ROZMA>90.and.m.ROZMB<90
                               ND1=int(DP/ROZMA)
                               ND2=int((SHP-90)/ROZMB)
                            endif
                            if mus=3.and.mtm<=5.and.m.ROZMA<89.and.m.ROZMB<89
                               ND1=int((DP-90)/ROZMA)
                               ND2=int((SHP-90)/ROZMB)
                            endif
                            if mus=4.and.mtm=>6.and.mtm<=30.and.m.ROZMA>=130.and.m.ROZMB>=130
                               ND1=int(DP/ROZMA)
                               ND2=int(SHP/ROZMB)
                            endif
                            if mus=5.and.mtm=>6.and.mtm<=30.and.m.ROZMA>=130.and.m.ROZMB<=129
                               ND1=int(DP/ROZMA)
                               ND2=int((SHP-130)/ROZMB)
                            endif
                            if mus=6.and.mtm=>6.and.mtm<=30.and.m.ROZMA<129.and.m.ROZMB<=130
                               ND1=int((DP-130)/ROZMA)
                               ND2=int((SHP-130)/ROZMB)
                            endif
                            if mus=7.and.mtm<=50
                               ND1=int(DP/(ROZMA+10))
                               ND2=int(SHP/(ROZMB+10))
                            endif
                            if mus=8.and.mtm>50
                               nD1=int(DP/(ROZMA+15))
                               nD2=int(SHP/(ROZMB+15))
                            endif
                            ND=ND1*ND2
                            M.NRMD=DP*SHP*TM*UV/1000000/ND
                            M.MZ=ROZMA*ROZMB*TM*UV/1000000
                            && 2 ВАРИАНТ
                            if mUS=1.and.mtm<=5.and.m.ROZMA>=90.and.m.ROZMB>=90
                               ND1=int(DP/ROZMB)
                               ND2=int(SHP/ROZMA)
                            endif
                            if mus=2.and.mtm<=5.m.ROZMA>90.and.m.ROZMB<90
                               ND1=int(SHP/ROZMA)
                               ND2=int((DP-90)/ROZMB)
                            endif
                            if mus=3.and.mtm<=5.and.m.ROZMA<89.and.m.ROZMB<89
                               ND1=int((DP-90)/ROZMB)
                               ND2=int((SHP-90)/ROZMA)
                            endif
                            if mus=4.and.mtm=>6.and.mtm<=30.and.m.ROZMA>=130.and.m.ROZMB>=130
                               ND1=int(DP/ROZMB)
                               ND2=int(SHP/ROZMA)
                            endif
                            if mus=5.and.mtm=>6.and.mtm<=30.and.m.ROZMA>=130.and.m.ROZMB<=129
                               ND1=int(DP/ROZMB)
                               ND2=int((SHP-130)/ROZMA)
                            endif
                            if mus=6.and.mtm=>6.and.mtm<=30.and.m.ROZMA<129.and.m.ROZMB>=130
                               ND1=int((DP-130)/ROZMB)
                               ND2=int(SHP/ROZMA)
                            endif
                            if mus=7.and.mtm<=50
                               ND1=int(DP/(ROZMB+10))
                               ND2=int(SHP/(ROZMA+10))
                            endif
                            if mus=8.and.mtm>50
                               nD1=int(DP/(ROZMB+15))
                               nD2=int(SHP/(ROZMA+15))
                            endif
                            ND_2=ND1*ND2
                            MNRMD=DP*SHP*TM*UV/1000000/ND_2
                            *MMZ=ROZMA*ROZMB*TM*UV/1000000
                            if nd_2>nd
                               *m.mmz =mmz
                               M.NRMD=MNRMD
                            endif
                         endif
                         **** ДЛЯ ВСЕХ СОРТАМЕНТОВ БОЛЕЕ 2 US=9 НИЖЕПЕРЕЧИСЛЕННОЕ
                         *****ВЗЯТЬ ЗА ОСНОВУ НО БЕЗ  ( 10 И 15 В ФОРМУЛЕ))
                         if mus=9
                            if sort=2.or.sort=13.or.sort=15
                               ** ДЛЯ SORT=2 (КРУГ) US=10 ПОР.ГАЗ ИЛИ ОТР.ПИЛАМИ   записыватьобозначение DM X DP
                               ND=int(DP/(ROZMA+20))
                               M.NRMD=3.14*DM*DM*UV*DP/ND/4000000
                               M.MZ=3.14*DM*DM*UV*ROZMA/4000000
                            endif
                            if sort=4
                               ** ДЛЯ ПОЛОСЫ   SORT=4
                               ND=int(DP/(ROZMA+10))
                               M.NRMD=TM*POL*UV*DP/ND/1000000
                               M.MZ=TM*POL*UV*ROZMA/1000000
                               *** записывать  обозначение полосы tm x pol x dp
                            endif
                            if sort=5
                               ** ДЛЯ SORT=5(КВАДРАТ ) записывать обозначение tm  x dp
                               ND=int(DP/(ROZMA+20))
                               M.NRMD=TM*TM*UV*DP/ND/1000000
                               M.MZ=  TM*TM*UV*ROZMA/1000000
                            endif
                            if (sort=>6.and.sort=<12).or.sort=14.OR.SORT=3
                               ND=int(DP/(ROZMA+20))
                               *** ДЛЯ ВСЕХ SORT>=6,КРОМЕ SORT=1,2,4,5  ЗАПИСЫВАТЬ ОБОЗНАЧЕНИЕ NSORT X DP
                               M.NRMD=DP*PS*UV/ND/1000000
                               M.MZ=ROZMA*PS*UV/1000000
                            endif
                         endif
                         if mus=10
                            if sort=2.or.sort=13.or.sort=15
                               ** ДЛЯ SORT=2 (КРУГ) US=10 НА ПРЕСНОЖНИЦАХ   записыватьобозначение DM X DP
                               ND=int(DP/ROZMA)
                               M.NRMD=3.14*DM*DM*UV*DP/ND/4000000
                               M.MZ=3.14*DM*DM*UV*ROZMA/4000000
                            endif
                            if sort=4
                               ** ДЛЯ ПОЛОСЫ   SORT=4
                               ND=int(DP/ROZMA)
                               M.NRMD=TM*POL*UV*DP/ND/1000000
                               M.MZ=TM*POL*UV*ROZMA/1000000
                               *** записывать  обозначение полосы tm x pol x dp
                            endif
                            if sort=5
                               ** ДЛЯ SORT=5(КВАДРАТ ) записывать обозначение tm  x dp
                               ND=int(DP/ROZMA)
                               M.NRMD=TM*TM*UV*DP/ND/1000000
                               M.MZ=  TM*TM*UV*ROZMA/1000000
                            endif
                            if (sort=>6.and.sort=<12).or.sort=14
                               ND=int(DP/ROZMA)
                               *** ДЛЯ ВСЕХ SORT>=6,КРОМЕ SORT=1,2,4,5  ЗАПИСЫВАТЬ ОБОЗНАЧЕНИЕ NSORT X DP
                               M.NRMD=DP*PS*UV/ND/1000000
                               M.MZ=ROZMA*PS/1000000
                            endif
                         endif
                         sele 2
                         @ 8,52 say m.mz   pict '9999.99999'
                         m.nrmd=m.nrmd/m.kolz
                         @13,22 get m.nrmd pict '9999.99999'
                         read
                         @13,22 say m.nrmd pict '9999.99999' colo w+/bg
                         kuda=kuda+1
                    case kuda=12           &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 1
                         @14,17 get M.mar1 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=13            &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 2
                         @14,22 get M.mar2 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=14           &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 3
                         @14,27 get M.mar3 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=15           &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 4
                         @14,32 get M.mar4 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=16           &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 5
                         @14,37 get M.mar5 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=17           &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 6
                         @14,42 get M.mar6 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=18           &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 7
                         @14,47 get M.mar7 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=19           &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 8
                         @14,52 get M.mar8 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=20           &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 9
                         @14,57 get M.mar9 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=21           &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 10
                         @14,62 get M.mar10 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=22               &&
                         on key label uparrow do wwerh
                         @11,52 get m.wag
                         read
                         @11,52 say m.wag  colo w+/bg
                         kuda=kuda+1
                    case kuda=23               &&
                         on key label uparrow do wwerh
                         @15,52 get m.ndok
                         read
                         @15,52 say m.ndok  colo w+/bg
                         kuda=kuda+1
                    case kuda=24               &&
                         on key label uparrow do wwerh
                         @16,57 get m.datz
                         read
                         @16,57 say m.datz colo w+/bg
                         kuda=kuda+1
                    case kuda=25               &&
                         on key label uparrow do wwerh
                         on key label F1 do f1pi
                         @17,42 get m.kpi pict '9999'
                         read
                         ikpi=space(30)
                         if m.kpi#0
                            sele 1
                            set order to ivk
                            seek str(4,4)+str(m.kpi,4)
                            if foun()
                               ikpi=im
                            else
                               ikpi=zad
                            endif
                         endif
                         @17,42 say str(m.kpi,4)+' '+ikpi colo w+/bg
                         kuda=kuda+1

                    case kuda=26               &&
                         on key label uparrow do wwerh
                         defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                         acti wind w3
                         @ 0,0  SAY 'Заменен ли материал??'
                         @ 1,0  prom ' ДА '
                         @ 1,12  prom ' НЕТ '
                         @ 1,46 prom ' РЕЗЕРВ '
                         menu to Z_O
                         M.ZO=Z_O-1
                         rele wind w3
                         @18,22 get m.ZO pict '9'
                         read
                         IF M.ZP=0
                            ZO_=' НЕТ   '
                         ENDIF
                         IF M.ZP=1
                            ZO_=' ДА    '
                         ENDIF
                         IF M.ZP=0
                            ZO_=' РЕЗЕРВ'
                         ENDIF
                         @18,22 SAY STR(m.ZO,1)+ZO_ colo w+/bg
                         kuda=kuda+1

                 endcase
                 if kuda<1 .or.kuda>=kudak.OR.lastkey()=27
                    on key
                    exit
                 endif
              ENdDO
              defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
              acti wind w3
              set color to gr+/b,gr+/g
              @1,2  prom ' Ввести в базу '
              @1,46 prom ' Hет '
              menu to m
              rele wind w3
              sele 2
              if m=1                              && Ввести в базу
                 APPEN BLAN
                 if m.pozn=m.poznw.and.m.pozn=m.poznw.and.m.pozn=m.poznd
                    m.d_u =3
                    m.koli=1
                    m.pu  =1
                 endif
                 gather memv
              endif
              mdatv =m.datv
              mrazr =m.razr
              MPOZN =M.POZN
              mkornw=m.kornw
              mnaimw=m.naimw
              mshw  =m.shw
              MPOZNW=M.POZNW
              mkornd=m.kornd
              MPOZND=M.POZND
              *SCAT MEMV BLAN
              defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
              acti wind w3
              set color to gr+/b,gr+/g
              @1,2  prom ' Продолжить ввод '
              @1,46 prom ' Выход '
              menu to m
              set colo to
              rele wind w3
              if m=2                             && Выход
                 exit
              ELSE
                 sele 2
                 *m.datv =mdatv
                 *m.razr =mrazr
                 *M.POZN =MPOZN
                 *m.kornw=mkornw
                 *m.naimw=mnaimw
                 *m.shw  =mshw
                 *M.POZNW=MPOZNW
                 *M.POZND=MPOZND
                 *m.kornd=mkornd
                 @0,12 say m.datv
                 @0,52 say m.razr
                 @1,15 say M.POZN+' '+npozn
                 @2,15 say m.kornw
                 @2,52 say m.shw
                 @3,24 say M.POZNW+' '+M.NAIMW
                 @6,8 say M.POZND
                 @5,19 say M.KORND
              endif
           enddo
           on key
           rele wind w1
      case mm0=2                               && ввод вспомогательных материалов
           on key
           define window wiza from 2,2 to 10,75 title 'Ввод ' double shad close colo sche 10
           acti wind wiza
           SET CURS ON
           @1,1 say ' Дата ввода'
           @2,1 say ' Шифр изделия'
           @4,1 say ' Обозначение узла'
           @6,1 say ' Разработчик'
           sele 2
           scat memv blan
           m.datv=date()
           @1,24 get m.datv
           @2,24 get m.pozn when vgsm()
           @4,24 get M.POZNW
           @6,24 get m.razr
           read
           deac wind wiza
           if last()=27
              exit
           endif
           define window w1 from 2,2 to 22,78 title 'Ввод СВИ и расчет норм рахода материалов' double shad close colo sche 10
           acti wind w1
           @ 0,1 say 'Дата ввода                          Разработчик            'colo gr+/bg
           @ 1,1 say 'Изделие                                                    'colo gr+/bg
           @ 2,1 say 'Обозн. узла                                                'colo gr+/bg
           @ 3,1 say 'Деталь-Узел                                                'colo gr+/bg
           @ 4,1 say 'Обозн. детали                                              'colo gr+/bg
           @ 5,1 say 'Кол-во с загот.                                            'colo gr+/bg
           @ 6,1 say 'Mатериал                                                   'colo gr+/bg
           @ 7,1 say 'Разм.загот.-длина                                          'colo gr+/bg
           @ 8,1 say '(№ сортам.диам.шир.)                                       'colo gr+/bg
           @ 9,1 say 'Расх.на ед.(кг,кв.м.)                                      'colo gr+/bg
           @10,1 say 'Технол.маршрут                                             'colo gr+/bg
           @11,1 say 'Кол-во в узле                                              'colo gr+/bg
           @12,1 say 'Един.измер.                                                'colo gr+/bg
           @0,12 say m.datv
           @0,52 say m.razr
           @1,15 say M.POZN+' '+npozn
           @2,24 say M.POZNW &&+' '+M.NAIMW
           do while .t.
              kudak=11
              kuda=1
              do while.t.
                 do case
                    case kuda=1                                     &&
                         on key label uparrow do wwerh
                         defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
                         acti wind w3
                         set color to gr+/b,gr+/g
                         @1,2  prom ' ДЕТАЛЬ '
                         @1,46 prom ' УЗЕЛ '
                         menu to m.d_u
                         rele wind w3
                         @ 3,19 say iif(m.d_u=2,'УЗЕЛ','ДЕТАЛЬ') colo w+/bg
                         kuda=kuda+1
                    case kuda=2                                    && Обозн. детали
                         on key label uparrow do wwerh
                         @ 4,14 get M.POZND
                         read
                         @ 4,14 say M.POZND colo w+/bg
                         kuda=kuda+1
                    case kuda=3                                   &&
                         on key label uparrow do wwerh
                         @5,22 get m.kolz
                         read
                         @5,22 say m.kolz  colo w+/bg
                         kuda=kuda+1
                    case kuda=4                                   && Материал
                         on key label uparrow do wwerh
                         on key label f1 do f1mat
                         on key label f7 do f7mat
                         @6,10 get m.kodm pict '9999'
                         read
                         naimm=space(52)
                         IEI=ZAD
                         if m.kodm#0
                            sele 4
                            set order to ikodm
                            seek m.kodm
                            if foun()
                               naimm=naim
                               iei  =ei
                               mtm  =tm
                            else
                               naimm=zad
                               iei  =zad
                               mtm  =0
                            endif
                            @ 6,10 say str(M.KODM,4)+' '+naimm colo w+/bg
                         endif
                         @12,12 say iei                     colo w+/bg
                         kuda=kuda+1
                    case kuda=5             && длина
                         on key label uparrow do wwerh
                         @7,20 get m.rozma
                         read
                         @7,20 say m.rozma colo w+/bg
                         kuda=kuda+1
                    case kuda=6            &&
                         on key label uparrow do wwerh
                         @8,20 get m.rozmb
                         read
                         @8,20 sAY m.rozmb colo w+/bg
                         kuda=kuda+1
                    case kuda=7             && расчет норм расхода мат-ла на 1 деталь
                         @ 9,20 get m.nrmd
                         read
                         @ 9,20 say m.nrmd colo w+/bg
                         kuda=kuda+1
                    case kuda=8            &&
                         on key label uparrow do wwerh
                         on key label f1 do f1mar with 1
                         @10,17 get M.mar1 pict '9999'
                         read
                         @10,17 say m.mar1 pict '9999' colo w+/bg
                         kuda=kuda+1
                    case kuda=9              &&
                         on key label uparrow do wwerh
                         @11,21 get m.kol
                         read
                         @11,21 say m.kol colo w+/bg
                         kuda=kuda+1
                    case kuda=10               &&
                         on key label uparrow do wwerh
                         @12,12 get m.ei
                         read
                         @12,12 say m.ei  colo w+/bg
                         kuda=kuda+1
                 endcase
                 if kuda<1 .or.kuda>=kudak.OR.lastkey()=27
                    on key
                    exit
                 endif
              ENdDO
              defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
              acti wind w3
              set color to gr+/b,gr+/g
              @1,2  prom ' Ввести в базу '
              @1,46 prom ' Hет '
              menu to m
              rele wind w3
              sele 2
              if m=1                              && Ввести в базу
                 sele 28
                 APPEN BLAN
                 gather memv
              endif
                 mdatv =m.datv
                 mrazr =m.razr
                 MPOZN =M.POZN
                 mkornw=m.kornw
                 mshw  =m.shw
                 MPOZNW=M.POZNW
                 MPOZND=M.POZND
                 SCAT MEMV BLAN
              defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
              acti wind w3
              set color to gr+/b,gr+/g
              @1,2  prom ' Продолжить ввод '
              @1,46 prom ' Выход '
              menu to m
              set colo to
              rele wind w3
              if m=2                             && Выход
                 exit
              ELSE
                 sele 2
                 m.datv =mdatv
                 m.razr =mrazr
                 M.POZN =MPOZN
                 m.kornw=mkornw
                 m.shw  =mshw
                 M.POZNW=MPOZNW
                 @0,12 say m.datv
                 @0,52 say m.razr
                 @1,15 say M.POZN+' '+npozn
                 @2,15 say m.kornw
                 @2,52 say m.shw
                 @3,24 say M.POZNW+' '+M.NAIMW
              endif
           enddo
           on key
           rele wind w1
      case mm0=3                               && комплектующие
           on key
           define window wiza from 2,2 to 10,75 title 'Ввод ' double shad close colo sche 10
           acti wind wiza
           SET CURS ON
           @1,1 say ' Дата ввода'
           @2,1 say ' Шифр изделия'
           @3,1 say ' Короткий № узла'
           @4,1 say ' Обозначение узла'
           @5,1 say ' Наименование узла'
           @6,1 say ' Разработчик'
           sele 2
           scat memv blan
           m.datv=date()
           @1,24 get m.datv
           @2,24 get m.pozn when vgsm()
           @3,24 get M.KORNW
           @4,24 get M.POZNW
           @5,24 get m.naimw
           @6,24 get m.razr
           read
           deac wind wiza
           if last()=27
              exit
           endif
           define window w1 from 2,2 to 22,78 title 'Ввод СВИ и расчет норм рахода материалов' double shad close colo sche 10
           acti wind w1
           @ 0,1 say 'Дата ввода                          Разработчик            'colo gr+/bg
           @ 1,1 say 'Изделие                                                    'colo gr+/bg
           @ 2,1 say 'Корот.№ узла                        Шифр издeлия           'colo gr+/bg
           @ 3,1 say 'Обозн. узла                         Наим.узла              'colo gr+/bg
           @ 4,1 say 'Корот.№ комплектующ.                                       'colo gr+/bg
           @ 7,1 say 'Комплектующая                                              'colo gr+/bg
           @12,1 say 'Технол.маршрут                                             'colo gr+/bg
           @13,1 say 'Кол-во в узле                       Един.измер.            'colo gr+/bg
           @14,1 say 'Дата изм.док-та                     N док-та               'colo gr+/bg
           @15,1 say 'Причина                                                    'colo gr+/bg
           @0,12 say m.datv
           @0,52 say m.razr
           @1,15 say M.POZN+' '+npozn
           @2,15 say m.kornw
           @2,52 say m.shw
           @3,24 say M.POZNW+' '+M.NAIMW
           do while .t.
              kudak=8
              kuda=1
              do while.t.
                 do case
                    case kuda=1                                    && кор.№. детали
                         on key label uparrow do wwerh
                         @ 4,14 get M.kOrND
                         read
                         @ 4,14 say M.kOrND colo w+/bg
                         kuda=kuda+1
                    case kuda=2                                     &&
                         on key label uparrow do wwerh
                         on key label f1 do f1km
                         @7,10 get m.kodm pict '9999'
                         read
                         naimm=space(52)
                         IEI=ZAD
                         if m.kodm#0
                            sele 29
                            set filt to kodm=m.kodm
                            go top
                            if .not.eof()
                               naimm=naim
                               iei  =ei
                            else
                               naimm=zad
                               iei  =zad
                            endif
                            @ 7,10 say str(M.KODM,4)+' '+naimm colo w+/bg
                         endif
                         @13,52 say iei                     colo w+/bg
                         kuda=kuda+1
                    case kuda=3           &&
                         on key label uparrow do wwerh
                         @12,17 get M.mar1 pict '9999'
                         read
                         kuda=kuda+1
                    case kuda=4              &&
                         on key label uparrow do wwerh
                         @13,21 get m.kol
                         read
                         @13,21 say m.kol colo w+/bg
                         kuda=kuda+1
                    case kuda=5               &&
                         on key label uparrow do wwerh
                         @14,17 get m.datz
                         read
                         @14,17 say m.datz colo w+/bg
                         kuda=kuda+1
                    case kuda=6               &&
                         on key label uparrow do wwerh
                         on key label F1 do f1pi
                         @15,12 get m.kpi
                         read
                         ikpi=space(30)
                         if m.kpi#0
                            sele 1
                            set order to ivk
                            seek str(4,4)+str(m.kpi,4)
                            if foun()
                               ikpi=im
                            else
                               ikpi=zad
                            endif
                         endif
                         @15,12 say str(m.kpi)+' '+ikpi colo w+/bg
                         kuda=kuda+1
                    case kuda=7               &&
                         on key label uparrow do wwerh
                         @14,52 get m.ndok
                         read
                         @14,52 say m.ndok  colo w+/bg
                         kuda=kuda+1
                 endcase
                 if kuda<1 .or.kuda>=kudak.OR.lastkey()=27
                    on key
                    exit
                 endif
              ENdDO
              defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
              acti wind w3
              set color to gr+/b,gr+/g
              @1,2  prom ' Ввести в базу '
              @1,46 prom ' Hет '
              menu to m
              rele wind w3
              sele 2
              if m=1                              && Ввести в базу
                 APPEN BLAN
                 m.d_u=1
                 m.poznd='                    '
                 gather memv
              endif
                 mdatv =m.datv
                 mrazr =m.razr
                 MPOZN =M.POZN
                 mkornw=m.kornw
                 mshw  =m.shw
                 MPOZNW=M.POZNW
                 SCAT MEMV BLAN
              defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
              acti wind w3
              set color to gr+/b,gr+/g
              @1,2  prom ' Продолжить ввод '
              @1,46 prom ' Выход '
              menu to m
              set color to
              rele wind w3
              if m=2                             && Выход
                 exit
              ELSE
                 sele 2
                 m.datv =mdatv
                 m.razr =mrazr
                 M.POZN =MPOZN
                 m.kornw=mkornw
                 m.shw  =mshw
                 M.POZNW=MPOZNW
                 @0,12 say m.datv
                 @0,52 say m.razr
                 @1,15 say M.POZN+' '+npozn
                 @2,15 say m.kornw
                 @2,52 say m.shw
                 @3,24 say M.POZNW+' '+M.NAIMW
              endif
           enddo
           on key
           rele wind w1
      case mm0=4                              && Работа с БД
           do f1izd
           if last()#27
              defi wind oboz from 8,15 to 11,60 double shad colo w+/w &&g
              acti wind oboz
              set cursor on
              mkorm=1
              @ 1,1 prom  ' ПО МАТЕРИАЛУ '
              @ 1,21 prom  ' BCE'
              menu to mkorm
              deac wind oboz
              if last()#27
                 if mkorm=2
                    sele 2
                    set filt to
                    set order to ishw
                    set key to mshw
                    go top
                    do rabota
                    sele 2
                    set key to
                 else
                    do f7mat
                    sele 2
                    set filt to
                    set order to iskodm
                    set key to str(mshw,6)+STR(mkodm,4)
                    go top
                    do rabota
                    sele 2
                    set key to
                 endif
              endif
           endif
      case mm0=5                              && Выборка по короткому N
           do f1izd
           defi wind oboz from 11,15 to 14,60 double shad colo w+/w &&g
           acti wind oboz
           set cursor on
           mkorn='1.0    '
           @ 1,1 say  ' Введите номер позиции:'
           @ 1,24 get mkorn
           read
           deac wind oboz
           if lastkey()#27
              sele 2
              set order to ikn
              set filt to shw=mshw.and.(kornd=mkorn.or.kornw=mkorn)
              go top
              do rabota
              sele 2
              set filt to
           endif
      case mm0=6                              && Выборка по обозначению
           do f1izd
           if last()#27
              defi wind oboz from 11,15 to 14,60 double shad colo w+/w &&g
              acti wind oboz
              set cursor on
              DO WHILE .T.
                 @ 1,1 say  ' Введите обозначение:'
                 @ 1,24 get mpozn
                 read
                 deac wind oboz
                 IF LAST()=27
                    EXIT
                 ENDIF
                 sele 2
                 set order to ipoz
                 set filt to shw=mshw.and.(poznw=mpozn.or.poznd=mpozn)
                 go top
                 if .not.eof()
                    do rabota
                 else
                    wait 'нет информации по '+mpozn wind
                 endif
              ENDDO
              sele 2
              set filt to
           endif
      case mm0=7                              && Выборка по № извещения
              defi wind oboz from 11,15 to 14,60 double shad colo w+/w &&g
              acti wind oboz
              set cursor on
              mndok=space(6)
              @ 1,1 say  ' Введите № извещения:'
              @ 1,24 get mndok
              read
              deac wind oboz
           if last()#27
              sele 2
              set order to indok
              set key to mndok
              go top
              if .not.eof()
                 do rabota
              else
                 wait 'нет информации по извещению '+mndok wind
              endif
              sele 2
              set key to
           endif
      case mm0=8                              && Размножение СВИ
           sele 8
           set filt to
           go top
           defi wind wv from 5,34 to 16,76 title ' ОТКУДА КОПИРОВАТЬ ??? ' double shad colo sche 10
           acti wind wv
           on key label Enter do f1iot
           brow fiel im:H='Hаименование',ribf:H='Обозначение',kod:H='код',shwz:H='пр-й щифр' in wind wv noed
           on key
           rele wind wv
           *keyb '{Enter}'
           if last()#27
              ttl=' НОВОЕ ИЗДЕЛИЕ!!!'
              do f1izd
              if last()#27
                 defi wind w3 from 15,5 to 19,75 double shad colo gr+/b &&title zag
                 acti wind w3
                 set color to gr+/b,gr+/g
                 set cursor on
                 @ 0,0 say  '  обозначение:'
                 @ 1,0 say  '  наименование:'
                 @ 2,0 say  '  код:'
                 set color to n/w,n/g
                 @ 0,17 say mpozn
                 @ 1,17 say mim
                 @ 2,17 say mshw
                 sele 2
                 set filt to shw=mshw
                 go top
                 if .not.eof()
                    wait 'УЖЕ ЕСТЬ '+str(MSHW,4)+' ИЗДЕЛИЕ !!!' wind
                 else
                    sele 2
                    set filt to shw=mshwot
                    go top
                    do while .not.eof()
                       nzap=recn()
                       scat memv
                       m.datv=date()
                       m.shw =mshw
                       m.pozn=mpozn
                       if m.kornw='1.0'
                          m.poznw=mpozn
                       endif
                       *@ 20,1 say m.pozn+' '+m.poznw
                       appe blan
                       gath memv
                       go nzap
                       skip
                    enddo
                 endif
                 wait 'модифицированное изделие сформировано' wind
              endif
           endif
           rele wind w3
      *case mm0=8                              &&
      *     do f1izd
      *     if last()#27
      *        defi wind oboz from 11,15 to 14,65 double shad colo w+/w &&g
      *        acti wind oboz
      *        set cursor on
      *        @ 1,0 say  'Введите обозначение детали'
      *        @ 1,28 get mpozn
      *        read
      *        deac wind oboz
      *        sele 5
      *        set filt to poznd=mpozn
      *        go top
      *        do while .not.eof()
      *           scat memv
      *           sele 2
      *           set filt to shw=mshw.and.poznd=m.poznd
      *           go top
      *           if .not.eof()
      *              m.kornw=kornw
      *              m.kornd=kornd
      *              m.kodm =kodm
      *              m.rozma=rozma
      *              m.rozmb=rozmb
      *              m.nrmd =nrmd
      *              m.mz   =mz
      *              m.wag  =wag
      *              m.kol  =kol
      *              m.kttp =kttp
      *              m.kolz =kolz
      *              SELE 5
      *              gath memv
      *           else
      *              wait 'ПОЗИЦИИ '+M.POZND+' НЕТ В СПЕЦИФИКАЦИИ' wind
      *           endif
      *           sele 5
      *           skip
      *        enddo
      *     endif
      case mm0=9                              && кол-во в изделии
           do koliz
      case mm0=10                             && удаление изделия из KT
           do f1izd
           if last()#27
              defi wind w3 from 15,5 to 18,75 double shad colo gr+/b &&title zag
              acti wind w3
              @0,2  SAY MRIBF+' '+MSHW
              set color to gr+/b,gr+/g
              @1,2  prom ' УДАЛЯЮ !!! '
              @1,46 prom ' НЕТ '
              menu to m_U
              rele wind w3
              IF M_U=1
                 sele 2
                 set filt to pozn=mribf
                 go top
                 if .not.eof()
                    do while .not.eof()
                       dele
                       skip
                    enddo
                    wait 'изделие '+mribf+'удалено из KT' wind
                 else
                    wait 'изделиЯ '+mribf+' нет в KT' wind
                 endif
              endif
           endif
      case mm0=11                              && удаление изделия из KT
           do f1izd
           if last()#27
              defi wind w3 from 1,15 to 18,78 double shad colo sche 10 &&gr+/w+ &&title zag
              acti wind w3
              sele 2
              set filt to shw=mshw.and.(d_u=2.or.d_u=3).and.mar1#0
              brow fiel pu:H='Приоритет',kornd:H='Кор.№',poznd:H='Обозначение',naimd:H='Наименование'
              set filt to
              rele wind w3
           endif
      case mm0=12                             && Размножение СВИ
              do f1izd   && shw=18
              if last()#27
                 i_shw=mshw
                 i_ribf=mribf
                 *wait '18  i_shw='+str(i_shw,3)+' mribf='+mribf wind
                 do f1izd   && shw=9
                 defi wind w3 from 1,15 to 18,78 double shad colo sche 10 &&gr+/w+ &&title zag
                 acti wind w3
                 sele 2
                 set filt to shw=mshw.and.(d_u=2.or.d_u=3).and.mar1#0
                 on key label Enter do f1mk
                 brow fiel pu:H='Приоритет',shw,poznw:H='Обозначение',naimw:H='Наименование'
                 rele wind w3
                 sele 2
                 *wait 'i_ribf='+i_ribf+'  mpu='+str(mpu,2) wind
                 set filt to poznw=i_ribf.and.pu=mpu
                 go top
                 kz=0
                 do while .not.eof()
                    kz=kz+1
                    skip
                 enddo
                 dime nz[kz]
                 go top
                 ind=1
                 do while .not.eof()
                    nz[ind]=recn()
                    wait 'ind='+str(ind,2)+' nz[ind]='+str(nz[ind],5) wind
                    ind=ind+1
                    skip
                 enddo
                 ind_z=1
                 do while .t.
                    noza=nz[ind_z]
                    wait 'ind_z='+str(ind_z,2)+' nz='+str(nz[ind_z],5) wind
                    go noza
                    scat memv
                    appe blan
                    m.pozn=i_ribf
                    m.shw =i_shw
                    if m.d_u=2
                       m.d_u=3
                    endif
                    *m.koli=
                    gath memv
                    ind_z=ind_z+1
                    if ind_z>kz
                       exit
                    endif
                 enddo
                 wait 'машкомплект изделие сформировано' wind
              endif
   endcase
enddo
deac wind wwod
*est scre from skt
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc Ekr
do Ekr6 with 2
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
****  ПРОСМОТР, КОРРЕКТИРОВКА
* P=2 просмотр
* P=3 корректировка
proc Ekr6
para p
on key
IF P=3
   SET CURS ON
ENDIF
*Wait 'proc Ekr6 p='+str(p,2) wind
zag='Изменение СВИ'
@ 0,1 say 'Дата ввода                          Разработчик            'colo gr+/bg
@ 1,1 say 'Изделие                                                    'colo gr+/bg
@ 2,1 say 'Корот.№ узла                        Шифр издeлия           'colo gr+/bg
@ 3,1 say 'Узeл                                                       'colo gr+/bg
@ 4,1 say 'Корот.№ детали                                             'colo gr+/bg
@ 5,1 say 'Деталь                                                     'colo gr+/bg
@ 6,1 say 'Деталь-узел                         Кол-во с загот.        'colo gr+/bg
@ 7,1 say 'Mатериал                                                   'colo gr+/bg
@ 8,1 say 'Разм.загот.-длина                   Масса заготовки        'colo gr+/bg
@ 9,1 say '(№ сортам.диам.шир.)                                       'colo gr+/bg
@10,1 say 'Tиповый техпроцесс                                         'colo gr+/bg
@11,1 say 'Расх.на ед.(кг,кв.м.)               Масса детали           'colo gr+/bg
@12,1 say 'Технол.маршрут                                             'colo gr+/bg
@13,1 say 'Кол-во в узле                       N док-та               'colo gr+/bg
@14,1 say 'Дата изм.док-та                     Един.измер.            'colo gr+/bg
@15,1 say 'Причина изм.док-та                                         'colo gr+/bg
@16,1 say 'Заменен ли материал??                                      'colo gr+/bg
sele 2
scat memv
@ 0,12 say M.DATV
sele 8
set order to ir
seek M.pozn
if foun()
   npozn=im
else
   npozn=zad
endif
@ 1,9 say M.POZN+' '+npozn
@ 2,15 say M.KORNW
@ 3,7 say M.POZNW+' '+M.NAIMW
@ 4,19 say M.KORND
@ 6,19 say iif(m.d_u=2,'УЗЕЛ','ДЕТАЛЬ') colo w+/bg
@ 5,8 say M.POZND
naimm=space(52)
sele 4
set order to ikodm
seek m.kodm
if foun()
   naimm=naim
else
   sele 29
   set filt to kodm=m.kodm
   go top
   if .not.eof()
      naimm=naim
   endif
endif
@ 7,10 say str(M.KODM,4)+' '+naimm
@ 8,20 say M.ROZMA
@ 9,20 say M.ROZMB
nttp=space(33)
if !empt(m.kttp)
   sele 1
   set order to ivs
   seek str(9,4)+m.kttp
   if foun()
      nttp=im
   else
      nttp=rfix(zad,33)
   endif
   @10,21 say M.KTTP+' '+rfix(NTTP,33)
else
   @10,21 say space(49)
endif
@11,20 SAY M.NRMD pict '9999.99999'
@12,17 say str(M.mar1,4)+'-'
@12,22 say str(M.mar2,4)+'-'
@12,27 say str(M.mar3,4)+'-'
@12,32 say str(M.mar4,4)+'-'
@12,37 say str(M.mar5,4)+'-'
@12,42 say str(M.mar6,4)+'-'
@12,47 say str(M.mar7,4)+'-'
@12,52 say str(M.mar8,4)+'-'
@12,57 say str(M.mar9,4)+'-'
@12,62 say str(M.mar10,4)
@13,21 say M.KOL
@14,17 say M.DATZ
ikpi=space(30)
if m.kpi#0
   set filt to vid=4.and.kod=m.kpi
   go top
   if .not.eof()
      ikpi=im
   else
      ikpi=zad
   endif
endif
@15,12 say str(M.KPi)+' '+ikpi
                         IF M.ZO=0
                            ZO_='ДА    '
                         ENDIF
                         IF M.ZO=1
                            ZO_='НЕТ   '
                         ENDIF
                         IF M.ZO=2
                            ZO_='РЕЗЕРВ'
                         ENDIF
                         @16,25 SAY ZO_ colo w+/bg
@ 0,52 say M.razr
@ 2,52 say M.SHW
@ 5,30 say M.NAIMD
@ 6,52 say M.KOLZ
@ 8,52 say M.MZ  pict '9999.99999'
@11,52 say M.WAG pict '9999.99999'
@13,52 say M.ndok
@14,52 say M.EI
if p=3                                     && КОРРЕКТИРОВКА
   do while .t.
      kudak=28
      kuda=1
      do while.t.
         do case
            case kuda=1                                     && Корот.№ детали
                 on key label uparrow do wwerh
                 @ 3,7 GET M.POZNW
                 read
                 @ 3,7 say M.POZNW colo w+/bg
                 kuda=kuda+1
            case kuda=2                                     && Корот.№ детали
                 on key label uparrow do wwerh
                 @ 4,19 get M.KORND
                 read
                 @ 4,19 say M.KORND colo w+/bg
                 kuda=kuda+1
            case kuda=3               && выдано топл. со склада
                 on key label uparrow do wwerh
                 @5,49 get m.naimd
                 read
                 @5,49 say m.naimd  colo w+/bg
                 kuda=kuda+1
            case kuda=4                                    && Обозн. детали
                 on key label uparrow do wwerh
                 @ 5,8 get M.POZND
                 read
                 @ 5,8 say M.POZND colo w+/bg
                 kuda=kuda+1
            case kuda=5               &&
                 on key label uparrow do wwerh
                 @6,52 get m.kolz
                 read
                 @6,52 say m.kolz  colo w+/bg
                 kuda=kuda+1
            case kuda=6                                   && Материал
                 on key label uparrow do wwerh
                 if m.kodm<1500
                    on key label f1 do f1mat
                    on key label f7 do f7mat
                 else
                    on key label f1 do f1km
                 endif
                 @7,10 get m.kodm pict '9999'
                 read
                 naimm=space(52)
                 if m.kodm#0
                    if M.KOLZ=0
                       WAIT 'KOLZ=0 !!!!' WIND
                    endif
                    if m.kodm<1500
                       sele 4
                       set order to ikodm
                       seek m.kodm
                       if foun()
                          naimm=naim
                          iei  =ei
                          mtm  =tm
                       else
                          naimm=zad
                          iei  =zad
                          mtm  =0
                       endif
                    else
                       sele 29
                       set filt to kodm=m.kodm
                       go top
                       if .not.eof()
                          naimm=naim
                          iei  =ei
                       else
                          naimm=zad
                          iei  =zad
                       endif
                    endif
                 endif
                 @ 7,10 say str(M.KODM,4)+' '+naimm colo w+/bg
                 kuda=kuda+1
            case kuda=7             && длина
                 on key label uparrow do wwerh
                 @8,20 get m.rozma
                 read
                 if m.kolz>1
                    m.rozma=40+(m.rozma+5)*m.kolz
                 endif
                 @8,20 say m.rozma colo w+/bg
                 kuda=kuda+1
            case kuda=8            && ширина
                 on key label uparrow do wwerh
                 @9,20 get m.rozmb
                 read
                 @9,20 sAY m.rozmb colo w+/bg
                 kuda=kuda+1
            case kuda=9                   &&
                 on key label uparrow do wwerh
                 on key label F1 do f1ttp
                 @10,21 get m.kttp
                 read
                 nttp=space(34)
                 if !empt(m.kttp)
                    sele 1
                    set order to ivs
                    seek str(9,4)+m.kttp
                    if foun()
                       nttp=im
                    else
                       nttp=rfix(zad,33)
                    endif
                    @10,21 say m.kttp+' '+rfix(NTTP,34) colo w+/bg
                 endif
                 kuda=kuda+1
            case kuda=10            &&
                 sele 1
                 set order to ivs
                 seek str(9,4)+m.kttp
                 mus=0
                 if foun()
                    mus=us
                 endif
                 sele 4
                 set order to ikodm
                 seek m.kodm
                 if !foun()
                    wait 'НЕТ ТАКОГО МАТЕРИАЛА!!!' wind
                 endif
                 ** для всех us 1 по 8 включительно в фомулах rozma и rozmb менять между собой
                 *и принимать ND ,болшего значения  nd1 и nd2 брать только целые числа
                 *WAIT 'sort='+str(sort,2)+' mus='+str(mus,1);
                 *            +' m.rozma='+str(m.rozma,4);
                 *            +' m.rozmb='+str(m.rozmb,4);
                 *            +' mtm='+str(mtm,4) WIND
                 if sort=1.or.sort=16
                    && 1 ВАРИАНТ
                    nd1=0
                    nd2=0
                    if mUS=1.and.mtm<=5.and.m.ROZMA>=90.and.m.ROZMB>=90
                       ND1=int(DP/ROZMA)
                       ND2=int(SHP/ROZMB)
                    endif
                    if mus=2.and.mtm<=5.m.ROZMA>90.and.m.ROZMB<90
                       ND1=int(DP/ROZMA)
                       ND2=int((SHP-90)/ROZMB)
                       *wait 'nd1='+str(nd1,6)+' nd2='+str(nd2,6) wind
                    endif
                    if mus=3.and.mtm<=5.and.m.ROZMA<89.and.m.ROZMB<89
                       ND1=int((DP-90)/ROZMA)
                       ND2=int((SHP-90)/ROZMB)
                    endif
                    if mus=4.and.mtm=>6.and.mtm<=30.and.m.ROZMA>=130.and.m.ROZMB>=130
                       ND1=int(DP/ROZMA)
                       ND2=int(SHP/ROZMB)
                    endif
                    if mus=5.and.mtm=>6.and.mtm<=30.and.m.ROZMA>=130.and.m.ROZMB<=129
                       ND1=int(DP/ROZMA)
                       ND2=int((SHP-130)/ROZMB)
                    endif
                    if mus=6.and.mtm=>6.and.mtm<=30.and.m.ROZMA<129.and.m.ROZMB<=130
                       ND1=int((DP-130)/ROZMA)
                       ND2=int((SHP-130)/ROZMB)
                    endif
                    if mus=7.and.mtm<=50
                       ND1=int(DP/(ROZMA+10))
                       ND2=int(SHP/(ROZMB+10))
                    endif
                    if mus=8.and.mtm>50
                       nD1=int(DP/(ROZMA+15))
                       nD2=int(SHP/(ROZMB+15))
                    endif
                    ND=ND1*ND2
                       *wait 'nd='+str(nd,6)+'DP='+str(dp,6)+' SHP='+str(shp,6)+' TM='+str(tm,2)+'  UV='+str(uv,6) wind
                    M.NRMD=DP*SHP*TM*UV/1000000/ND
                       *wait 'M.NRMD='+str(M.NRMD,10,5) wind
                       *wait 'M.kolz='+str(m.kolz,5) wind

                    M.MZ=ROZMA*ROZMB*TM*UV/1000000
                    && 2 ВАРИАНТ
                    if mUS=1.and.mtm<=5.and.m.ROZMA>=90.and.m.ROZMB>=90
                       ND1=int(DP/ROZMB)
                       ND2=int(SHP/ROZMA)
                    endif
                    if mus=2.and.mtm<=5.m.ROZMA>90.and.m.ROZMB<90
                       ND1=int(SHP/ROZMA)
                       ND2=int((DP-90)/ROZMB)
                    endif
                    if mus=3.and.mtm<=5.and.m.ROZMA<89.and.m.ROZMB<89
                       ND1=int((DP-90)/ROZMB)
                       ND2=int((SHP-90)/ROZMA)
                    endif
                    if mus=4.and.mtm=>6.and.mtm<=30.and.m.ROZMA>=130.and.m.ROZMB>=130
                       ND1=int(DP/ROZMB)
                       ND2=int(SHP/ROZMA)
                    endif
                    if mus=5.and.mtm=>6.and.mtm<=30.and.m.ROZMA>=130.and.m.ROZMB<=129
                       ND1=int(DP/ROZMB)
                       ND2=int((SHP-130)/ROZMA)
                    endif
                    if mus=6.and.mtm=>6.and.mtm<=30.and.m.ROZMA<129.and.m.ROZMB>=130
                       ND1=int((DP-130)/ROZMB)
                       ND2=int(SHP/ROSMA)
                    endif
                    if mus=7.and.mtm<=50
                       ND1=int(DP/(ROZMB+10))
                       ND2=int(SHP/(ROZMA+10))
                    endif
                    if mus=8.and.mtm>50
                       nD1=int(DP/(ROZMB+15))
                       nD2=int(SHP/(ROZMA+15))
                    endif
                    ND_2=ND1*ND2
                    MNRMD=DP*SHP*TM*UV/1000000/ND_2
                    *MMZ=ROZMA*ROZMB*TM*UV/1000000
                    if nd_2>nd
                       *m.mmz =mmz
                       M.NRMD=MNRMD
                    endif
                 endif
                 **** ДЛЯ ВСЕХ СОРТАМЕНТОВ БОЛЕЕ 2 US=9 НИЖЕПЕРЕЧИСЛЕННОЕ
                 *****ВЗЯТЬ ЗА ОСНОВУ НО БЕЗ  ( 10 И 15 В ФОРМУЛЕ))
                 if mus=9
                    if sort=2.or.sort=13.or.sort=15
                       ** ДЛЯ SORT=2 (КРУГ) US=10 ПОР.ГАЗ ИЛИ ОТР.ПИЛАМИ   записыватьобозначение DM X DP
                       ND=int(DP/(ROZMA+15))
                       M.NRMD=3.14*DM*DM*UV*DP/ND/4000000
                       M.MZ=3.14*DM*DM*UV*ROZMA/4000000
                    endif
                    if sort=4
                       ** ДЛЯ ПОЛОСЫ   SORT=4
                       ND=int(DP/(ROZMA+10))
                       M.NRMD=TM*POL*UV*DP/ND/1000000
                       M.MZ=TM*POL*UV*ROZMA/1000000
                       *** записывать  обозначение полосы tm x pol x dp
                    endif
                    if sort=5
                       ** ДЛЯ SORT=5(КВАДРАТ ) записывать обозначение tm  x dp
                       ND=int(DP/(ROZMA+10))
                       M.NRMD=TM*TM*UV*DP/ND/1000000
                       M.MZ=  TM*TM*UV*ROZMA/1000000
                    endif
                    if (sort=>6.and.sort=<12).or.sort=14.OR.SORT=3
                       ND=int(DP/(ROZMA+15))
                       *** ДЛЯ ВСЕХ SORT>=6,КРОМЕ SORT=1,2,4,5  ЗАПИСЫВАТЬ ОБОЗНАЧЕНИЕ NSORT X DP
                       M.NRMD=DP*PS*UV/ND/1000000
                       M.MZ=ROZMA*PS*UV/1000000
                    endif
                 endif
                 if mus=10
                    if sort=2.or.sort=13.or.sort=15
                       ** ДЛЯ SORT=2 (КРУГ) US=10 НА (болгаркой)ПРЕСНОЖНИЦАХ   записыватьобозначение DM X DP
                       ND=int(DP/(10+ROZMA))
                       M.NRMD=3.14*DM*DM*UV*DP/ND/4000000
                       M.MZ=3.14*DM*DM*UV*ROZMA/4000000
                    endif
                    if sort=4
                       ** ДЛЯ ПОЛОСЫ   SORT=4
                       ND=int(DP/(5+ROZMA))
                       M.NRMD=TM*POL*UV*DP/ND/1000000
                       M.MZ=TM*POL*UV*ROZMA/1000000
                       *** записывать  обозначение полосы tm x pol x dp
                    endif
                    if sort=5
                       ** ДЛЯ SORT=5(КВАДРАТ ) записывать обозначение tm  x dp
                       ND=int(DP/(5+ROZMA))
                       M.NRMD=TM*TM*UV*DP/ND/1000000
                       M.MZ=  TM*TM*UV*ROZMA/1000000
                    endif
                    if (sort=>6.and.sort=<12).or.sort=14
                       ND=int(DP/(5+ROZMA))
                       *** ДЛЯ ВСЕХ SORT>=6,КРОМЕ SORT=1,2,4,5  ЗАПИСЫВАТЬ ОБОЗНАЧЕНИЕ NSORT X DP
                       M.NRMD=DP*PS*UV/ND/1000000
                       M.MZ=ROZMA*PS/1000000
                    endif
                 endif
                 sele 2
                 m.nrmd=iif(m.kolz#0,m.nrmd/m.kolz,0)
                 @11,20 get m.nrmd pict '9999.99999'
                 read
                 @ 8,52 say m.mz pict '9999.99999'   colo w+/bg
                 @11,20 say m.nrmd pict '9999.99999' colo w+/bg
                 kuda=kuda+1
            case kuda=11               &&
                 on key label uparrow do wwerh
                 @11,52 get m.wag pict '9999.99999'
                 read
                 @11,52 say m.wag pict '9999.99999' colo w+/bg
                 kuda=kuda+1
            case kuda=12           &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 1
                 @12,17 get M.mar1 pict '9999'
                 read
                 @12,17 say M.mar1 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=13            &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 2
                 @12,22 get M.mar2 pict '9999'
                 read
                 @12,22 say M.mar2 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=14            &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 3
                 @12,27 get M.mar3 pict '9999'
                 read
                 @12,27 say M.mar3 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=15            &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 4
                 @12,32 get M.mar4 pict '9999'
                 read
                 @12,32 say M.mar4 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=16            &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 5
                 @12,37 get M.mar5 pict '9999'
                 read
                 @12,37 say M.mar5 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=17            &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 6
                 @12,42 get M.mar6 pict '9999'
                 read
                 @12,42 say M.mar6 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=18            &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 7
                 @12,47 get M.mar7 pict '9999'
                 read
                 @12,47 say M.mar7 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=19            &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 8
                 @12,52 get M.mar8 pict '9999'
                 read
                 @12,52 say M.mar8 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=20            &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 9
                 @12,57 get M.mar9 pict '9999'
                 read
                 @12,57 say M.mar9 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=21            &&
                 on key label uparrow do wwerh
                 on key label f1 do f1mar with 10
                 @12,62 get M.mar10 pict '9999'
                 read
                 @12,62 say M.mar10 pict '9999' colo w+/bg
                 kuda=kuda+1
            case kuda=22              &&
                 on key label uparrow do wwerh
                 @13,21 get m.kol
                 read
                 @13,21 say m.kol colo w+/bg
                 kuda=kuda+1
            case kuda=23               &&
                 on key label uparrow do wwerh
                 @14,17 get m.datz
                 read
                 @14,17 say m.datz colo w+/bg
                 kuda=kuda+1
            case kuda=24               &&
                 on key label uparrow do wwerh
                 on key label F1 do f1pi
                 @15,12 get m.kpi
                 read
                 if m.kpi#0
                    sele 1
                    set order to ivk
                    seek str(4,4)+str(m.kpi,4)
                    ikpi=space(30)
                    if foun()
                       ikpi=im
                    else
                       ikpi=zad
                    endif
                 endif
                 @15,12 say str(m.kpi)+' '+ikpi colo w+/bg
                 kuda=kuda+1
            case kuda=25               &&
                 on key label uparrow do wwerh
                 @8,52 get m.mz pict '9999.99999'
                 read
                 @8,52 say m.mz pict '9999.99999' colo w+/bg
                 kuda=kuda+1
            case kuda=26               &&
                 on key label uparrow do wwerh
                 @13,52 get m.ndok
                 read
                 @13,52 say m.ndok  colo w+/bg
                 kuda=kuda+1
            case kuda=27               &&
                 on key label uparrow do wwerh
      defi wind w3 from 15,5 to 18,75 double shad colo gr+/b title zag
      acti wind w3
      @1,2  say '0 - Все нормально'
      @1,24 say '1 - материал заменен'
      rele wind w3
                 @16,25 get m.zo
                 read
                 @16,25 say m.zo  colo w+/bg
                 kuda=kuda+1
         endcase
         if kuda<1.or.kuda>=kudak.OR.lastkey()=27
            on key
            exit
         endif
      enddo
      *WAIT 'defi wind w33' WIND
      defi wind w3 from 15,5 to 18,75 double shad colo gr+/b title zag
      acti wind w3
      @ 0,2  prom 'Ввести в базу       '
      @ 0,24 prom 'Возврат на изменение'
      @ 0,46 prom 'Отмена              '
      menu to m
      rele wind w3
      *WAIT 'rele wind w33' WIND
      sele 2
      do case
         case m=1                              && Ввести в базу
              gather memv
              kuda=1
              exit
         case m=2                             && Возврат на изменение
              kuda=1
              exit
         case m=3                             && Отмена ввода/ корректировки
              exit
      endcase
   enddo
endif
if p#1.and.p#5.and.p#6
*   on key label Del do Del_kart
   on key label Enter do Ekr6 with 3
endif
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*** Передвижение по окну ввода/корректировки
proc wwerh
kuda=kuda-2
keyb '{Enter}'
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc rabota
on key
define window w4 from 2,9 to 22,79 title '' Double close colo sche 10
define window w1 from 1,0 to 20,14 title '' double close colo w+/w
define window w2 from 0,0 to 20,9 in window w1 title'            ' double fill '█' colo sche 10
acti wind w4
SET CURSOR OFF
on key label Enter do Ekr6 with 3
*on key label Del do Del_kart
go top
brow fiel KORND:H='Кoр. N' wind w2 noedit when Ekr()
rele wind w1,w2,w4
on key
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
**** Удаление записи
Proc Del_kart
on key
defi wind del from 13,19 to 16,45 in screen double colo gr+/b
acti wind del
@ 0,1 say 'Запись будет удалена'
@ 1,2 prompt '  Да   '
@ 1,16 prompt' Hет   '
menu to ss
deac wind del
do case
   case ss=2
        delete
        on key label Del do Del_kart
        on key label Enter do Ekr6 with 3
        dl=1
   case ss=1
        on key label Del do Del_kart
        on key label Enter do Ekr6 with 3
endcase
deac wind w3
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc f1iot
on key
mshwot=kod
keyb '{ctrl+w}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc f1mk
on key
mpu   =pu
keyb '{ctrl+w}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc f1km
on key
sele 1
set order to ivi
set filt to vid=26.and.kod#0
go top
defi wind wv from 5,33 to 16,75 title 'ГРУППА МАТЕРИАЛОВ' double shad colo sche 10
acti wind wv
on key label Ins   do ins_grkm
on key label Enter do grkm
brow fiel im:H='Hаименование' in wind wv noed
on key
set filt to vid=21.and.us=mgr
go top
defi wind wv from 5,33 to 16,75 title 'СОРТАМЕНТ' double shad colo sche 10
acti wind wv
on key label Ins   do ins_sortkm
on key label Enter do sortkm
brow fiel im:H='Hаименование' in wind wv noed
on key
set filt to Vid=22 .and.us=mgr
go top
defi wind wv from 5,1 to 14,75 title 'СТАНДАРТ ПОСТАВКИ' double shad colo sche 10
acti wind wv
on key label Ins   do ins_spkm
on key label Enter do spkm
brow fiel im:H='Hаименование',sim:H='Обозначение' in wind wv noed
on key
rele wind wv
sele 29
set filt to gr=mgr.and.sort=msort.and.sp=msp
go top
defi wind wv from 1,14 to 21,75 title 'МАТЕРИАЛ' double shad colo sche 10
acti wind wv
on key label Enter do f1m
on key label Ins do inskm with mgr,ngr,msort,isort,msp,nsp
brow fiel kodm,NAIM:H='НАИМЕНОВАНИЕ' in wind wv noed
ON KEY
rele wind wv
set filt to
*keyb '{Enter}'
retu .f.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc grkm
mgr=kod
ngr=im
keyb '{ctrl+w}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc sortkm
msort=kod
isort=im
keyb '{ctrl+w}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc spkm
msp=kod
nsp=im
keyb '{ctrl+w}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc ins_grkm
on key
sele 1                             && группы
   set order to ivk
   set filt to Vid=26 .and. Kod # 0
   go bott
   scat memv blan
   m.kod=kod+1
   m.vid=26
   defi wind w31 from 16,5 to 21,75 double shad colo gr+/b title 'Ввод новой записи'
   acti wind w31
   set curs on
   @ 0,1 say' Код     Hаименование                     Сокр.наим.       Доп.усл.'
   @ 1,0  get m.kod pict '9999'
   @ 1,5  get m.im
   @ 1,36 get m.sim
   read
   appe blan
   gath memv
   deac wind w31
on key
*keyb '{ctrl+w}'
on key label Enter do GRKM
   set order to ivi
set filt to
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc ins_sortkm
   on key
   sele 1                             && сортамент
   set order to ivk
   set filt to Vid=21 .and. Kod # 0
   go bott
   scat memv blan
   m.kod=kod+1
   m.vid=21
   defi wind w31 from 16,5 to 21,75 double shad colo gr+/b title 'Ввод новой записи'
   acti wind w31
   set curs on
   @ 0,1 say' Код     Hаименование                     Сокр.наим.       Доп.усл.'
   @ 1,0  get m.kod pict '9999'
   @ 1,5  get m.im
   @ 1,36 get m.sim
   read
   appe blan
   gath memv
   deac wind w31
on key
*keyb '{ctrl+w}'
on key label Enter do SORTKM
   set order to ivi
set filt to
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc ins_spkm
on key
sele 1                             && стандарт поставки
   set order to ivk
   set filt to Vid=22 .and. Kod # 0
   go bott
   scat memv blan
   m.kod=kod+1
   m.vid=22
   defi wind w31 from 16,5 to 21,75 double shad colo gr+/b title 'Ввод новой записи'
   acti wind w31
   set curs on
   @ 0,1 say' Код     Hаименование                     Сокр.наим.       Доп.усл.'
   @ 1,0  get m.kod pict '9999'
   @ 1,5  get m.im
   @ 1,36 get m.sim
   read
   appe blan
   gath memv
   deac wind w31
on key
*keyb '{ctrl+w}'
on key label Enter do GRKM
set order to ivi
set filt to
retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc f1pi
sele 1
set filt to vid=4.and.kod#0
go top
defi wind wv from 5,34 to 16,76 title 'ТИПОВЫЙ ТЕХПРОЦЕСС' double shad colo sche 10
acti wind wv
on key label Enter do f1p
brow fiel im:H='Hаименование',sim:H='Обозначение' in wind wv noed
on key
rele wind wv
*keyb '{Enter}'
set filt to
retu .f.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc f1p
m.kpi=kod
keyb '{ctrl+w}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc vgsm
sele 8
set filt to
go top
defi wind wv from 5,33 to 21,76 title '' double shad colo sche 10
acti wind wv
on key label Enter do ttt
brow fiel im:H=' ',ribf:H=' ' in wind wv noed
on key
rele wind wv
@2,14  say ribf+' '+left(im,37)  colo w+/bg
retu .f.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*Буферизация выбранной записи
proc ttt
m.pozn=ribf
m.poznw=ribf
m.poznd=ribf
ribf_=ribf
im_=im
npozn=im
m.shw =kod
keyb '{ctrl+w}'
retu
* * * * * * * * * * * * * * * * * * * * * * * ** *
* При необходимости разделить одно большое изделие на несколько машинокомплектов
* при запуске их в разное время, размещение по кооперации отдельных узлов и.т.д.
* 1.Необходимо задать в экране запроса необходимый узел.
* 2.Данный узел приравнять к pozn  записать в память D_u=3, а в POZNW условно
* отсечь все кроме обозначения этого узла и обрабатывать только эти поля.
* Входящие подузлы   при необходимости  заказывают  отдельно
*  Например : POZN=OO-1
*             poznw=OO-1-1
*                   OO-1-2
*             POSND=00-1-1
*
* Предусмотреть присваивание изделию D_U=3 в автомате когда POZN=POZNW=POZND
*
*
*
***


* Для расчета количества деталей на изделие необходимо учесть следующее:
* узел или деталь в разных количествах могут входить в другие подузлы, само изделие
* Поэтому необходимо взять первую запись узла(d_u=2) в СВИ POZND  (НТВ.56.12 ) и  к-во(KOL=2) зайти в POZNW
* взять там номер по POZNW (HTB.56.026) и по нем вернуться опять в POZND если такой номер есть
* (KOL=6)то умножить первое количество на второе(2 X 6=12) Количество самого изделия равно 1.
* Подузел найденный в POZNW (НТВ.56.12)просмотреть по узлам в POZND (НТВ.56.10)и т.д запомнив
* количество и так до выхода на само изделие(НТВ.56) умножая постепенно к-во .
* Количество узлов в изделии записать в базу СВИ.
* Взять следующий номер запомнить количество каждого из узлов в изделии и проделать тоже
* с деталями умножая их в каждом узле на его количество
**
* 1. Взяв POZND и проверить если их встречается >2 выделив (запомнив отдельно)
* 2.Обрабатывать все D_U=2 доходя до уровня POZND=(то что мы запомнили более 2)
* необходимо записать количество в даном расчете, и считать до тех пор пока данная
* POZND не  выйдет из расчета,но при этом
* 3. Все суммы koli одного  и того poznd при выходе по разным веткам и ссумировать
* 4.Данный ссумированный poznd приравниваем как poznw и идем далее по цепочке до
*   следующего poznd.>2 и так делее на выход .
* 5.Ставим признак закрытия 1.
