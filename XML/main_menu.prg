*!*	������� ����� ��������� � ��䳺� �� ����������� 
*!*	28 ������ 2017
*!*	������� D:\SPEKTR\A2018
*       *********************************************************
*       *
*       * 23/01/2004           MAIN_MENU.MPR            18:06:39
*       *
*       *********************************************************

public ut

ut = glUserType

aa = sys(5)+SYS(2003)+'\'

set sysmenu to
set sysmenu automatic

define pad _15f12tg98 of _msysmenu prompt "O����������  P�����" color scheme 3 ;
	key alt+O, ""
define pad _15f12tg9a of _msysmenu prompt "B�������  �����" color scheme 3 ;
	key alt+B, "" skip for ut = 8  
define pad _15f12tg9b of _msysmenu prompt "C����������" color scheme 3 ;
	key alt+C, "" skip for ut = 8  
define pad _service of _msysmenu prompt "C�����" color scheme 3 ;
	key alt+C, "" skip for ut = 8 or ut = 1 or ut = 9
define pad _15f12tg9d of _msysmenu prompt "B����" color scheme 3 ;
	key alt+B, "" 
on pad _15f12tg98 	of 	_msysmenu activate popup o���������
on pad _15f12tg9a 	of 	_msysmenu activate popup b���������
on pad _15f12tg9b 	of 	_msysmenu activate popup c���������
on pad _service 	of 	_msysmenu activate popup c�����
on selection pad _15f12tg9d of _msysmenu clear events

set path to '.\tech_'

define popup o��������� margin relative shadow color scheme 4
define bar 1 of o��������� prompt "� � �" skip for ut = 8  
define bar 4 of o��������� prompt "���������������� ����" skip for ut = 8 or ut = 9 
define bar 7 of o��������� prompt "������" skip for ut = 8 or ut = 9 
define bar 9 of o��������� prompt "�����������" skip for ut = 8 or ut = 9 
define bar 10 of o��������� prompt "���������"
define bar 11 of o��������� prompt "���������"
define bar 12 of o��������� prompt "������������ ���� � �������" skip for ut <> 1 and ut <> 2 
define bar 13 of o��������� prompt "���������� ����� ����� �� ��� "
define bar 14 of o��������� prompt "���������� ����� ����� �� �������� ���������� "
define bar 15 of o��������� prompt "���������� ����� ����� �� �������� ������� � �����"
define bar 16 of o��������� prompt "��������� - ��������� "
define bar 17 of o��������� prompt "������ ���������-����� ���� "
define bar 18 of o��������� prompt "��������� - ����� "
define bar 19 of o��������� prompt "\-"

on bar		1 of o��������� activate popup ��� 
on bar 		4 of o��������� activate popup popPlanir
on bar 		7 of o��������� activate popup narpop
on bar 		9 of o��������� activate popup sebest
on bar 		10 of o��������� activate popup popmater

on selection bar 11 of o��������� do form kontrol
on selection bar 12 of o��������� do form f_imit
on bar 			 13 of o��������� activate popup shtrihmsl
*!*	on bar 			 15 of o��������� activate popup shtrihlog
on selection bar 16 of o��������� do form f_logist_new
on bar 			 17 of o��������� activate popup wnelog
on selection bar 18 of o��������� do navigator
*********************************************
*!*	define popup shtrihlog margin relative shadow color scheme 4

*!*	define bar 1 of shtrihlog prompt '����� �����������'
*!*	define bar 2 of shtrihlog prompt '����� ������'

*********************************************
*********************************************
define popup wnelog margin relative shadow color scheme 4

define bar 	1 of wnelog prompt '�������� �� ���������� � ������'
on bar 		1 of wnelog activate popup otgruzka
define bar 	2 of wnelog prompt '����� � ���������� � �������'
on bar 		2 of wnelog activate popup priem
*********************************************
define popup otgruzka margin relative shadow color scheme 4

define bar 	1 of otgruzka prompt '�� �������� ���������'
*!*	on selection bar 1 of otgruzka do form f_logist_new
*!*	on bar 		1 of otgruzka activate popup otgrw
define bar 	2 of otgruzka prompt '�� ������������'
on bar 		2 of otgruzka activate popup priemw
*********************************************
define popup priem  margin relative shadow color scheme 4

define bar 	1 of priem prompt '�� �������� ���������'
on bar 		1 of priem activate popup otgrn
define bar 	2 of priem prompt '�� ������������'
on bar 		2 of priem activate popup priemn
*********************************************
*********************************************
define popup shtrihmsl margin relative shadow color scheme 4

define bar 1 of shtrihmsl prompt '������ ����� �� ��������'
define bar 2 of shtrihmsl prompt '����� ����� �� ��������'
define bar 3 of shtrihmsl prompt '����� ������� � ���������� ��������'
define bar 4 of shtrihmsl prompt '����� ������� �� �����'

*********************************************
define popup popmater margin relative shadow color scheme 4

define bar 3 of popmater prompt '�������'
define bar 7 of popmater prompt '��������� ����' skip for ut = 8 or ut = 1 or ut = 9
define bar 8 of popmater prompt '������ ��� �� ��������� ����' skip for ut = 8  
define bar 13 of popmater prompt '������� ������������� �������'
define bar 14 of popmater prompt '������� �� �����_������' skip for ut = 8  
on selection bar 3 of popmater do form f_ostatok_oper		&&	f_ostatok_new_sql
on selection bar 7 of popmater do form f_shwzras_sql
on selection bar 8 of popmater do form fr_shwzras_sql
on selection bar 13 of popmater do form f_promost
on selection bar 14 of popmater do form f_limone
aa = sys(5)+SYS(2003)+'\'
*wait window '<'+aa+'>'

define popup popPlanir margin relative shadow color scheme 4

define bar 1 of popPlanir prompt "���������������� ���� � ����������� ������������" skip for ut <> 5 .and. ut <> 6
define bar 4 of popPlanir prompt "������ � ����-���������" skip for ut <> 5 .and. ut <> 6
define bar 5 of popPlanir prompt "������ ����-�������"
define bar 7 of popPlanir prompt "���������� ���������������� ���� (��������� �����)" skip for ut <> 5 .and. ut <> 6
define bar 11 of popPlanir prompt "\-"
define bar 12 of popPlanir prompt "������ ��������� ����������"
define bar 13 of popPlanir prompt "�������� ����-�������" skip for ut <> 5 .and. ut <> 6
define bar 14 of popPlanir prompt "������ ������������ ���������"
define bar 15 of popPlanir prompt "������ ���-�� �� ������. ��������"
define bar 77 of popPlanir prompt "���������� ���������������� ���� �� �������������� �������������� ��������" 	skip for ut <> 5 .and. ut <> 6

on selection bar 1 of popPlanir do form f_ww_prosm_new 
on selection bar 4 of popPlanir do form f_pz
on selection bar 5 of popPlanir do form fr_pz
on selection bar 7 of popPlanir do form f_ww_fill_by_kt
on selection bar 12 of popPlanir do form fr_gotizd
on selection bar 13 of popPlanir do form f_delpz
on selection bar 14 of popPlanir do form fr_nakl_per
*!*	on selection bar 14 of popPlanir do form fr_nakl
on selection bar 15 of popPlanir do form fr_nevid
on selection bar 77 of popPlanir do form f_ww_fill_by_kt_pi
define bar 78 of popPlanir prompt "�������� ����������� �������� �������"
on selection bar 78 of popPlanir do form f_kalend

define popup sebest margin relative shadow color scheme 4
define bar 8 of sebest prompt "�����������. ������������ �����"  skip for ut = 8 or ut = 9 
on selection BAR 8 of sebest do   form f_plancalc1 
define bar 9 of sebest prompt "�����������. ������ �����"
on selection bar 9 of sebest do sebestoim
define bar 10 of sebest prompt "������� ������ ����. � ����. ������ �� ������"
on selection bar 10 of sebest do form STZ

define popup narpop margin relative shadow color scheme 4
 
*!*	define bar		6 of narpop prompt '���� ������� ��������� ���'
define bar		7 of narpop prompt '   ������ ������� �������'
define bar		8 of narpop prompt '   ������ ������������ ������� �������'
define bar		9 of narpop prompt '   ������ �������'
define bar		10 of narpop prompt '������ � ��������'
 
*!*	on selection bar 6 of narpop do start_f_nar_operplan
on selection bar 7 of narpop do form fr_rabzad
on selection bar 8 of narpop do form fr_rabnzad
on selection bar 9 of narpop do form fr_narad
on selection bar 10 of narpop do form f_nar_sql


define popup ��� margin relative shadow color scheme 4

define bar 1 of ��� prompt "����������� ����" skip for ut <> 2 and ut <> 3 and ut <> 4
define bar 2 of ��� prompt "��� (�������������, �����������, ��������)"
define bar 4 of ��� prompt "������ ���������� � �������" skip for ut <> 2 and ut <> 3 and ut <> 4
define bar 5 of ��� prompt "����������� �������" skip for ut <> 2 and ut <> 3 and ut <> 4
define bar 6 of ��� prompt "�������� �����" skip for ut <> 2 and ut <> 3 and ut <> 4
define bar 23 of ��� prompt "����������� ����" skip for ut <> 2 and ut <> 3 and ut <> 4

on bar 			 1 of ��� activate popup ����������
on selection bar 2 of ��� do form f_kt_vib_sql with "user"
on selection bar 4 of ��� do new_koliz
on selection bar 5 of ��� do form f_modif
on selection bar 23 of ��� do form f_copy_uzel

on selection bar 6 of ��� activate popup _13f14n0c9

define popup ���������� margin relative shadow color scheme 4
define bar		 1 of ���������� prompt "���� ������������"
define bar		 2 of ���������� prompt "���� ���������"
on selection bar 1 of ���������� do form f_kt_vvod_sql with "add1","kons"
on selection bar 2 of ���������� do form f_kt_vib_sql with "tech"

*** ���� �������� �����
define popup _13f14n0c9 margin relative shadow color scheme 4

define		 bar 1 of _13f14n0c9 prompt "������������ �����"
on selection bar 1 of _13f14n0c9 do form fr_provmat
define		 bar 2 of _13f14n0c9 prompt "���������� �������� ������"
on selection bar 2 of _13f14n0c9 do form f_serv17
define		 bar 3 of _13f14n0c9 prompt "�������������� ��������"
on selection bar 3 of _13f14n0c9 do form fr_provplus
define		 bar 4 of _13f14n0c9 prompt "�������� �������������� ���������� ��� ��������"
on selection bar 4 of _13f14n0c9 do form f_kt_test_kol
define		 bar 5 of _13f14n0c9 prompt "����� �������������� ����������"
on selection bar 5 of _13f14n0c9 do form f_service_mater_free
define		 bar 15 of _13f14n0c9 prompt "������ ��� �� ���������� NULL"
on selection bar 15 of _13f14n0c9 do form fr_error_null


define popup ���������� margin relative shadow color scheme 4

define bar 1 of ���������� prompt "����� � �����"
define bar 2 of ���������� prompt "����� � ������"
on selection bar 1 of ���������� do form f_raschet_kt
on selection bar 2 of ���������� do form f_raschet_lp


define popup b��������� margin relative shadow color scheme 4
 
define bar 2 of b��������� prompt "������������ ������� �� �������(�� ���������������� ����)" skip for ut = 9
define bar 4 of b��������� prompt "��������-����������������� ��������� ���������� � �������������"
define bar 6 of b��������� prompt "��������� ���� ������� � ��������" skip for ut = 9
define bar 18 of b��������� prompt "������� ��������� ���������� � �������������"  
define bar 25 of b��������� prompt "������� ������������ �� �������" skip for ut = 9
define bar 27 of b��������� prompt "������ ������������" skip for ut = 9
define bar 50 of b��������� PROMPT "��������������-��������������� ������������(���)" skip for ut = 9
define bar 70 of b��������� PROMPT "�������������� ����������� �������" skip for ut = 9
define bar 75 of b��������� PROMPT "��������� �������� ����������" skip for ut = 9
define bar 112 of b��������� prompt "���������-���������������� ����" skip for ut = 9
define BAR 120 of b��������� prompt "������� ������������ �� ������" skip for ut = 9
define bar 500 of b��������� PROMPT "����� �� ��������� ������" skip for ut = 9

on selection bar 2   of b��������� do form fr_wr_ww_sql
on selection bar 4   of b��������� do form f_dsnmat
on selection bar 6   of b��������� do WNW_ && report form r_izd preview
on selection bar 18  of b��������� do form f_svodmat
on selection bar 25  of b��������� do form fr_st
on selection bar 50  of b��������� do form fr_rasceh1_sql
on selection bar 70  of b��������� do form f_wwmar_sql
on selection bar 75  of b��������� do form fr_deficit
on selection bar 112 of b��������� do form fr_msl_xml
on selection bar 120 of b��������� do form fr_stz
on selection bar 500 of b��������� do form fr_sostzak


on bar 27 of b��������� activate popup mnSpr

define popup mnSpr margin relative shadow color scheme 4

*!*	define bar 1 of mnSpr prompt "������ ����������"
*!*	define bar 2 of mnSpr prompt "��������� ����������"
*!*	define bar 3 of mnSpr prompt "��������� �������� ����������"
*!*	define bar 4 of mnSpr prompt "��������� ���������� ����������"
define bar 5 of mnSpr prompt "���������"
define bar 6 of mnSpr prompt "������� �����������"
define bar 7 of mnSpr prompt "�������� �����"
define bar 8 of mnSpr prompt "������������� (�������)"
define bar 9 of mnSpr prompt "���� ������������"
define bar 10 of mnSpr prompt "���� ��������������� ��������"
define bar 11 of mnSpr prompt "������� ���������"
define bar 16 of mnSpr prompt "����������"
define bar 18 of mnSpr prompt "��������"
define bar 20 of mnSpr prompt "������������"
define bar 77 of mnSpr prompt "��������� ���������������"
 
*!*	on selection bar 1 of mnSpr	do pech_spr with 'grupmat'
*!*	on selection bar 2 of mnSpr	do pech_spr with 'sortmat'
*!*	on selection bar 3 of mnSpr	do pech_spr with 'stmat'
*!*	on selection bar 4 of mnSpr	do pech_spr with 'shmat'
on selection bar 5 of mnSpr	do pech_spr with 'prof'
on selection bar 6 of mnSpr	do pech_spr with 'ttp'
on selection bar 7 of mnSpr	do pech_spr with 'tarsetka'
on selection bar 8 of mnSpr	do pech_spr with 'podr'
on selection bar 9 of mnSpr	do pech_spr with 'vidobor'
on selection bar 10 of mnSpr do pech_spr with 'techoper'
on selection bar 11 of mnSpr do pech_spr with 'prichizm'
on selection bar 16 of mnSpr report form r_spr_kadry preview
on selection bar 18 of mnSpr do form fr_press 
on selection bar 20 of mnSpr do form f_print_obor 
on selection bar 77 of mnSpr do form fr_mater_nm


define popup mn_dsn margin relative shadow color scheme 4

define bar 1 of mn_dsn prompt "��������"
define bar 2 of mn_dsn prompt "�������������"
on selection bar 1 of mn_dsn 	do form fr_dsn
on selection bar 2 of mn_dsn 	do form f_dsnkm

define popup _13f194dn9 margin relative shadow color scheme 4
define bar 1 of _13f194dn9 prompt "���������"
define bar 2 of _13f194dn9 prompt "������ �����"
on bar 1 of _13f194dn9 activate popup _13f19bain

define popup _13f19bain margin relative shadow color scheme 4
define bar 1 of _13f19bain prompt "��������-����������������� �����"
define bar 2 of _13f19bain prompt "���������� ��������� ����������"
on selection bar 2 of _13f19bain do form fr_owm

define popup c��������� margin relative shadow color scheme 4

define bar 		 1 of c��������� prompt "�������" skip for ut = 9
on selection bar 1 of c��������� do form f_izd_sql
define bar 		 10 of c��������� prompt "���������" skip for ut = 9
on selection bar 10 of c��������� do form f_mater_vib with "vie"
define bar 		 11 of c��������� prompt "����������� DOSP" skip for ut <> 2
on selection bar 11 of c��������� do form f_dosp_sql
define bar		 12 of c��������� prompt "����������� ������" skip for ut <> 2
on selection bar 12 of c��������� do form f_sprav
define bar		 29 of c��������� prompt '�����������' skip for ut = 9
on selection bar 29 of c��������� do form f_kontrag_sql
define bar		 30 of c��������� prompt '��������' skip for ut = 9
on selection bar 30 of c��������� do form f_dogovor
define bar		 31 of c��������� prompt '������������' skip for ut = 9
on selection bar 31 of c��������� do form f_mako
define bar		 32 of c��������� prompt '������������' skip for ut = 9
on selection bar 32 of c��������� do form f_specmat

define popup c����� margin relative shadow color scheme 4

*!*	define bar		 5 of c����� prompt "������� ����� ���������� � 1�"
define bar		 34 of c����� prompt '������'
define bar		 36 of c����� prompt '������������' skip for !inlist(ut,2)
define bar		 38 of c����� prompt "������ ������ ����������" skip for ut<>2
define bar 		 115 of c����� prompt '������������� �������' skip for ut <> 2
define bar		 116 of c����� prompt '�������� ��� �� �����' skip for ut <> 5 && ��� ���

define bar 999 of c����� prompt "\-"
define bar 1000 of c����� prompt "����� 205.1 beta �� 25/09/2012" skip for .t. && version

*!*	on selection BAR 5 of c����� do form f_serv_555
on selection bar 34 of c����� do form f_logview
on selection bar 36 of c����� do run_t1
on selection bar 38 of c����� do form f_mater_zamena
on selection bar 115 of c����� do form f_arc_izd_sql
on selection bar 116 of c����� do form f_clean_shwz

*******
function can()
return !file('debug.inf')
endfunc
