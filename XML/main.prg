Do Form spl

Declare Integer Beep In win32api Integer,Integer

Public glPar1,glPar2,glPar3,glPar4,glPar5,glPar6,glPar7,glPar8,glPar9
Public glPar10,glPar11,glPar12,glPar13,glPar14,glPar15
Public glPar1_1,glPar1_2
Public glPar2_1
Public glPar3_1
Public glPar4_1
Public glSvDogId,glSvDogIzdId

Public glNom

Store -1 To glSvDogId,glSvDogIzdId

Public glSort &&& use for mater-sort

Public glMar3
glMar3 = -1

Public gldat11
gldat11 = Date()

Store 0 To glPar1,glPar2,glPar3,glPar4,glPar5,glPar6,glPar7,glPar8,glPar9

Public aa

Public glErrors

Public glLastProc, glLastTime
glLastProc = -1
glLastTime = 0

Public pnmarsh
m.pnmarsh = 0

Public Array glAr1[1000], glAr_Regim[6], glAr2[1000]

Store 0 To glAr2

* ���������� ��� �������� ������������
Public glUser,glUserType

* ���������� ��� �������� ������� ���������� ��������-�������������
Public glMater
m.glMater = 1500

_Screen.WindowState = 2
_Screen.Caption = '������-������������ ('+Sys(5)+Sys(2003)+')'
_Screen.BackColor = 8421504

***	* ��������� ������ ��� ������ ������
glAr_Regim[1] = '������� ����� ������'
glAr_Regim[2] = '������������ ��� ������'
glAr_Regim[3] = '������������ � �������'
glAr_Regim[4] = '������������ ������'
glAr_Regim[5] = '������ ��� ������'
glAr_Regim[6] = '����������'

* ���������� ��� ���������� ������������ ������������
Public glBrigState
glBrigState = 1
Public glBrigTn0,glBrigTn1,glBrigTn2,glBrigTn3
glBrigTn0 = 0
glBrigTn1 = 0
glBrigTn2 = 0
glBrigTn3 = 0
glBrigUch0 = 25
glBrigUch1 = 25
glBrigUch2 = 25
glBrigUch3 = 25

* ���������� ��� �������� ����, ���� �� ���������� ������� �� ����
Public glShowOst
glShowOst = .F.

* ���������� ��� ����������� ������� � ������� f_kt_vib
Public glSavKtVibX, glSavKtVibY, glSavKtVibH, glSavKtVibW
Store 0 To glSavKtVibX, glSavKtVibY, glSavKtVibH, glSavKtVibW

* ���������� ��� ��������� ������� ����-�������
Public glNzad
glNzad = 0

*
* wait 'aaa='+sys(2019) window

Close All

Set Date BRITISH
Set Century On
Set Sysmenu Off
Set Exact On
Set Deleted On
Set Exclusive Off
Set Procedure To procs,procsplus,procs1,rezprocs
Set Optimize On
Set Unique Off
Set Confirm Off
Set Safety Off
Set Talk Off
Set Near Off
*set collate to "RUSSIAN"

Do setprot With '���� � �������'

* delete old report files
Do delete_xml_report

Open Database db

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
Local hh
hh = SQLConnect('sqldb','sa','111')
If hh > 0
	Local res
	res = SQLExec(hh,'Select * from MATER ','cmati')
	If res > 0
		*!*				res1 = pkodm
		*!*				WAIT WINDOW pkodm nowa
	Else
		eodbc()
	Endif

	SQLDisconnect(hh)
Else
	eodbc()
Endif

*!*	select * from mater into cursor cmati

* ��������� ��������� � �������
Public arMat[30000]
Store '' To arMat
Select cmati
Local nnn,nnn1
nnn = -1
Scan All
	nnn1 = Int(100*Recno()/Reccount())
	If nnn <> nnn1
		Wait Window Nowait '�������� ���������� '+Alltrim(Str(100*Recno()/Reccount()))+'%'
		nnn = nnn1
	Endif
	If cmati.kodm <> 0
		arMat[cmati.kodm] = cmati.naim
	Endif
Endscan
Wait Window Nowait '��������� ���������!'

* ��������� ������� � �������
Public arPodr[10000]
Store '' To arPodr
Select * From dosp Where kod<>0 And vid=2 Into Cursor ccdosp
Scan All
	Wait Window Nowait '�������� ������������� '+Alltrim(Str(100*Recno()/Reccount()))+'%'
	If ccdosp.kod <> 0
		arPodr[ccdosp.kod] = ccdosp.im
	Endif
Endscan
Wait Window Nowait '������������� ���������!'
Use In ccdosp

* �� ������, ���� �� ������ � �������� ������
glUser = ''
glUserType = 2

If !File('nopsw')
	Local tt
	Do Form f_start To tt
	If tt=0
		Wait Window '������������ ������! �� ��������...'
		Return
	Endif
Endif

Do setprot With '�����������: '+glUser+' (��������� '+Alltrim(Str(glUserType))+')'

* �������� ��������
* !!! (���� ��������) do test_obmen

_Screen.Caption = _Screen.Caption + ' User:' + Alltrim(glUser)

* legal
* wait 'legal' wind
* do legal
* wait 'do form1' wind

If glUserType<>8
	Do Form f_main
Endif

* ��������� ��� �� ������� � ����������� ������� � ������ ������������
If glUserType = 2
	testemptyizd()
Endif

* ��������
*on key label ESCAPE return
*do test
*on key

* do main_toolbar

*wait 'do' window
Do main_menu.prg
*wait 'read events' window
Read Events

*wait '_screen.forms(1).release' window
If glUserType<>8
	_Screen.Forms(1).Release
Endif


Close Databases
Set Sysmenu To Default

Do setprot With '����� �� �������'
