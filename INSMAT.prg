proc insmat
para mgr,ngr,msort,isort,msp,nsp,msh,nsh
*wait 'insmat  mgr,msort,msp,msh='+str(mgr,4)+str(msort,4)+str(msp,4)+str(msh,4) wind
save scre to inma
on key
define window w44 from 2,15 to 22,79 title 'rtrim(imv)' double close colo sche 10
acti wind w44
sele 4
set order to ikodm
set key to
set filt to
go bott
kodmax=kodm
scat memv blan
m.GR  =mGR
m.SORT=mSORT
m.SP  =mSP
m.SH  =mSH
m.kodm =kodmax+1
@ 0,1 say 'Группа материалов                             'colo gr+/bg
@ 1,1 say 'Сортамент                                     'colo gr+/bg
@ 2,1 say 'Стандарт поставки                             'colo gr+/bg
@ 3,1 say 'Стандарт химсостава                           'colo gr+/bg
@ 4,1 say 'Порядк.номер(№ склад. карт.)                  'colo gr+/bg
@ 5,1 say 'Наименование                                  'colo gr+/bg
@ 6,1 say 'Обозначение по наклад.                        'colo gr+/bg
@ 7,1 say 'Толщина (мм)                  Диаметр(мм)     'colo gr+/bg
@ 8,1 say 'Номер сортамента                              'colo gr+/bg
@ 9,1 say 'Длина в поставке(мм)                          'colo gr+/bg
@10,1 say 'Ширина в поставке(мм)                         'colo gr+/bg
@11,1 say 'Площадь сечения(кв.мм)                        'colo gr+/bg
@12,1 say 'Единица измерения                             'colo gr+/bg
@13,1 say 'Цена за единицу грн.коп.                      'colo gr+/bg
@14,1 say 'Количество                                    'colo gr+/bg
@15,1 say 'Количество остатка                            'colo gr+/bg
@16,1 say 'Сальдо остатка                                'colo gr+/bg
@17,1 say 'Дата поступления                              'colo gr+/bg
@18,1 say 'Удельный вес(грамм/см.куб)                    'colo gr+/bg
@ 0,17 say STR(M.GR,4)+' '+ngr    colo w+/bg
@ 1,17 say STR(M.sort,4)+' '+ISORT colo w+/bg
@ 2,17 say STR(M.sp,4)+' '+NSP   colo w+/bg
@ 3,17 say STR(M.sh,4)+' '+NSH   colo w+/bg
@ 4,26 say M.kodm  colo w+/bg
@ 5,10 say m.naim
@ 6,10 say m.OBOZ
@ 7,15 say M.tm
@ 7,46 say M.dm
@ 8,26 say M.nsort colo w+/bg
@ 9,26 say M.dp   colo w+/bg
@10,26 say M.shp  colo w+/bg
@11,26 say M.ps   colo w+/bg
@12,26 say M.ei   colo w+/bg
@13,26 say M.cena colo w+/bg
@14,26 say M.kol  colo w+/bg
@15,26 say M.OSTATOK   colo w+/bg
@16,26 say M.SALDO_O   colo w+/bg
@17,26 say M.DATA_O    colo w+/bg
@18,26 say M.uv        colo w+/bg
set curs on
   @ 5,10 GET m.naim
   @ 6,10 GET m.OBOZ
   @ 6,25 get M.tm
   @ 7,26 get M.dm
@ 8,26 get M.nsort
@ 9,26 get M.dp
@10,26 get M.shp
@11,26 get M.ps
@12,26 get M.ei
@13,26 get M.cena
@14,26 get M.kol
@15,26 get M.OSTATOK
@16,26 get M.SALDO_O
@17,26 get M.DATA_O
@18,26 get M.uv
read
kuku=''
if msort=1.or.msort=4.or.msort=16
   kuku=allt(str(m.tm,6,2))+'x'+allt(str(m.shp,6))+'x'+allt(str(m.dp,5))
endif
if msort=5
   kuku=allt(str(m.tm,6,2))+'x'+allt(str(m.dp,5))
endif
if msort=2.or.msort=13.or.msort=15
   kuku=allt(str(m.dm,5,1))+'x'+allt(str(m.dp,5))
endif
if (msort=>6.and.msort=<12).or.msort=14
   kuku=allt(str(m.nsort,5,1))+'x'+allt(str(m.dp,5))
endif
m.naim=allt(isort)+' '+kuku+' '+allt(nsp)+' '+allt(nsh)
@ 5,15 say M.naim
*m.naim=rfix(m.naim,52)
@ 5,15 get M.naim
read
@ 5,15 say M.naim colo w+/bg
appe blan
gath memv
keyb '{ctrl+w}'
keyb '{Enter}'
*rele wind w1,w2,w4
rele wind w44
on key label Enter do f1m
*on key
rest scre from inma
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc esp
on key
msp=kod
nsp=im
keyb '{ctrl+w}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
proc ehs
on key
msh=kod
nsh=im
keyb '{ctrl+w}'
return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

