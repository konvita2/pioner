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

* ���������� ��� �������� ������������
public glUser,glUserType

* ���������� ��� �������� ������� ���������� ��������-�������������
public glMater
m.glMater = 1500

_screen.windowstate = 2
_screen.caption = '������-������������ ('+sys(5)+sys(2003)+')'
_screen.backcolor = 8421504

***	* ��������� ������ ��� ������ ������
glAr_Regim[1] = '������� ����� ������'
glAr_Regim[2] = '������������ ��� ������'
glAr_Regim[3] = '������������ � �������'
glAr_Regim[4] = '������������ ������'
glAr_Regim[5] = '������ ��� ������'
glAr_Regim[6] = '����������'

* ���������� ��� ���������� ������������ ������������
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

* ���������� ��� �������� ����, ���� �� ���������� ������� �� ����
public glShowOst
glShowOst = .f.

* ���������� ��� ����������� ������� � ������� f_kt_vib
public glSavKtVibX, glSavKtVibY, glSavKtVibH, glSavKtVibW
store 0 to glSavKtVibX, glSavKtVibY, glSavKtVibH, glSavKtVibW

* ���������� ��� ��������� ������� ����-�������
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

do setprot with '���� � �������'

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

* ��������� ��������� � �������
public arMat[30000]
store '' to arMat
select cmati
local nnn,nnn1
nnn = -1
scan all
	nnn1 = int(100*recno()/reccount())
	if nnn <> nnn1
		wait window nowait '�������� ���������� '+alltrim(str(100*recno()/reccount()))+'%' 
		nnn = nnn1
	endif	
	if cmati.kodm <> 0
		arMat[cmati.kodm] = cmati.naim
	endif	
endscan 
wait window nowait '��������� ���������!' 

* ��������� ������� � �������
public arPodr[10000]
store '' to arPodr
select * from dosp where kod<>0 and vid=2 into cursor ccdosp
scan all
	wait window nowait '�������� ������������� '+alltrim(str(100*recno()/reccount()))+'%' 
	if ccdosp.kod <> 0
		arPodr[ccdosp.kod] = ccdosp.im
	endif	
endscan 
wait window nowait '������������� ���������!' 
use in ccdosp

* �� ������, ���� �� ������ � �������� ������
glUser = ''
glUserType = 2

if !file('nopsw') 
	local tt
	do form f_start to tt
	if tt=0
		wait window '������������ ������! �� ��������...'
		return
	endif
endif

do setprot with '�����������: '+glUser+' (��������� '+alltrim(str(glUserType))+')'

* �������� ��������
* !!! (���� ��������) do test_obmen

_screen.caption = _screen.caption + ' User:' + alltrim(glUser)

* legal
* wait 'legal' wind
* do legal
* wait 'do form1' wind

if glUserType<>8
	do form f_main
endif

* ��������� ��� �� ������� � ����������� ������� � ������ ������������
if glUserType = 2
	testemptyizd()
endif

* ��������
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

do setprot with '����� �� �������'
