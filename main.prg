do form spl

declare integer Beep in win32api integer,integer

public glPar1,glPar2,glPar3,glPar4,glPar5,glPar6,glPar7,glPar8,glPar9
public glPar10,glPar11,glPar12,glPar13,glPar14,glPar15
public glPar1_1,glPar1_2
public glPar2_1
public glPar3_1
public glPar4_1
public glSvDogId,glSvDogIzdId

public glNom

store -1 to glSvDogId,glSvDogIzdId

public glSort &&& use for mater-sort

public glMar3
glMar3 = -1

public gldat11
gldat11 = date()

store 0 to glPar1,glPar2,glPar3,glPar4,glPar5,glPar6,glPar7,glPar8,glPar9

public aa

public glErrors

public glLastProc, glLastTime
glLastProc = -1
glLastTime = 0

public pnmarsh
m.pnmarsh = 0

public array glAr1[1000], glAr_Regim[6], glAr2[1000]

store 0 to glAr2

* переменные для описания пользователя
public glUser,glUserType

* переменная для описания границы материалов основные-комплектующие
public glMater
m.glMater = 1500

_screen.windowstate = 2
_screen.caption = 'СПЕКТР-ПРОИЗВОДСТВО ('+sys(5)+sys(2003)+')'
_screen.backcolor = 8421504

***	* заполняем массив для режима работы
glAr_Regim[1] = 'Обычный режим работы'
glAr_Regim[2] = 'Сверхурочные без оплаты'
glAr_Regim[3] = 'Сверхурочные с оплатой'
glAr_Regim[4] = 'Оплачиваемый отпуск'
glAr_Regim[5] = 'Отпуск без оплаты'
glAr_Regim[6] = 'Больничные'

* переменные для бригадного оперативного планирования
public glBrigState
glBrigState = 1
public glBrigTn0,glBrigTn1,glBrigTn2,glBrigTn3
glBrigTn0 = 0
glBrigTn1 = 0
glBrigTn2 = 0
glBrigTn3 = 0
glBrigUch0 = 25
glBrigUch1 = 25
glBrigUch2 = 25
glBrigUch3 = 25

* переменная для указания того, надо ли показывать расходы за день
public glShowOst
glShowOst = .f.

* переменные для запоминания позиции и размера f_kt_vib
public glSavKtVibX, glSavKtVibY, glSavKtVibH, glSavKtVibW
store 0 to glSavKtVibX, glSavKtVibY, glSavKtVibH, glSavKtVibW

* переменная для генерации номеров план-заданий
public glNzad
glNzad = 0

*
* wait 'aaa='+sys(2019) window

close all

set date BRITISH
set century on
set sysmenu off
set exact on
set deleted on
set exclusive off
set procedure to procs,procsplus,procs1,rezprocs
set optimize on
set unique off
set confirm off
set safety off
set talk off
set near off 
*set collate to "RUSSIAN"

do setprot with 'Вход в систему'

* delete old report files
do delete_xml_report

open database db

*!*	*!*	*!*	select 0
*!*	*!*	*!*	use kt shared again alias ckti
*!*	*!*	*!*	set order to tag i_d

*****
*!*	select 0
*!*	use ww shared again alias cwwi
*!*	set order to tag ipoznd

*****
*!*	select 0
*!*	use ww shared again alias cwwii
*!*	set order to tag ispec

*****
*!*	select 0
*!*	use mater shared again alias cmati
*!*	set order to tag aaa

select * from mater into cursor cmati

* загрузить материалы в таблицу
public arMat[30000]
store '' to arMat
select cmati
local nnn,nnn1
nnn = -1
scan all
	nnn1 = int(100*recno()/reccount())
	if nnn <> nnn1
		wait window nowait 'Загрузка материалов '+alltrim(str(100*recno()/reccount()))+'%' 
		nnn = nnn1
	endif	
	if cmati.kodm <> 0
		arMat[cmati.kodm] = cmati.naim
	endif	
endscan 
wait window nowait 'Материалы загружены!' 

* загрузить участки в таблицу
public arPodr[10000]
store '' to arPodr
select * from dosp where kod<>0 and vid=2 into cursor ccdosp
scan all
	wait window nowait 'Загрузка подразделений '+alltrim(str(100*recno()/reccount()))+'%' 
	if ccdosp.kod <> 0
		arPodr[ccdosp.kod] = ccdosp.im
	endif	
endscan 
wait window nowait 'Подразделения загружены!' 
use in ccdosp

* на случай, если не войдем в проверку пароля
glUser = ''
glUserType = 2

if !file('nopsw') 
	local tt
	do form f_start to tt
	if tt=0
		wait window 'НЕПРАВИЛЬНЫЙ ПАРОЛЬ! До свидания...'
		return
	endif
endif

do setprot with 'АВТОРИЗАЦИЯ: '+glUser+' (категория '+alltrim(str(glUserType))+')'

* загрузка остатков
* !!! (пока отключим) do test_obmen

_screen.caption = _screen.caption + ' User:' + alltrim(glUser)

* legal
* wait 'legal' wind
* do legal
* wait 'do form1' wind

if glUserType<>8
	do form f_main
endif

* проверить нет ли записей в справочнике изделий с пустым обозначением
if glUserType = 2
	testemptyizd()
endif

* ПРОВЕРКА
*on key label ESCAPE return
*do test
*on key

* do main_toolbar

*wait 'do' window
do main_menu.prg
*wait 'read events' window
read events

*wait '_screen.forms(1).release' window
if glUserType<>8
	_screen.forms(1).release
endif


close databases
set sysmenu to default

do setprot with 'Выход из системы'
