*!*	остання версія скорочена з надією на універсальну 
*!*	28 ГРУДНЯ 2017
*!*	КАТАЛОГ D:\SPEKTR\A2018
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

define pad _15f12tg98 of _msysmenu prompt "OПЕРАТИВНАЯ  PАБОТА" color scheme 3 ;
	key alt+O, ""
define pad _15f12tg9a of _msysmenu prompt "BЫХОДНЫЕ  ФОРМЫ" color scheme 3 ;
	key alt+B, "" skip for ut = 8  
define pad _15f12tg9b of _msysmenu prompt "CПРАВОЧНИКИ" color scheme 3 ;
	key alt+C, "" skip for ut = 8  
define pad _service of _msysmenu prompt "CЕРВИС" color scheme 3 ;
	key alt+C, "" skip for ut = 8 or ut = 1 or ut = 9
define pad _15f12tg9d of _msysmenu prompt "BЫХОД" color scheme 3 ;
	key alt+B, "" 
on pad _15f12tg98 	of 	_msysmenu activate popup oперативна
on pad _15f12tg9a 	of 	_msysmenu activate popup bыходныефо
on pad _15f12tg9b 	of 	_msysmenu activate popup cправочник
on pad _service 	of 	_msysmenu activate popup cервис
on selection pad _15f12tg9d of _msysmenu clear events

set path to '.\tech_'

define popup oперативна margin relative shadow color scheme 4
define bar 1 of oперативна prompt "К Т С" skip for ut = 8  
define bar 4 of oперативна prompt "ПРОИЗВОДСТВЕННАЯ БАЗА" skip for ut = 8 or ut = 9 
define bar 7 of oперативна prompt "Наряды" skip for ut = 8 or ut = 9 
define bar 9 of oперативна prompt "Калькуляция" skip for ut = 8 or ut = 9 
define bar 10 of oперативна prompt "Материалы"
define bar 11 of oперативна prompt "Аналитика"
define bar 12 of oперативна prompt "Имитационная база и затраты" skip for ut <> 1 and ut <> 2 
define bar 13 of oперативна prompt "Считывание штрих кодов по МСЛ "
define bar 14 of oперативна prompt "Считывание штрих кодов по маркерам материалов "
define bar 15 of oперативна prompt "Считывание штрих кодов по маркерам деталей и узлов"
define bar 16 of oперативна prompt "Логистика - документы "
define bar 17 of oперативна prompt "Внешяя логистика-штрих коды "
define bar 18 of oперативна prompt "Навигация - отчет "
define bar 19 of oперативна prompt "\-"

on bar		1 of oперативна activate popup ктс 
on bar 		4 of oперативна activate popup popPlanir
on bar 		7 of oперативна activate popup narpop
on bar 		9 of oперативна activate popup sebest
on bar 		10 of oперативна activate popup popmater

on selection bar 11 of oперативна do form kontrol
on selection bar 12 of oперативна do form f_imit
on bar 			 13 of oперативна activate popup shtrihmsl
*!*	on bar 			 15 of oперативна activate popup shtrihlog
on selection bar 16 of oперативна do form f_logist_new
on bar 			 17 of oперативна activate popup wnelog
on selection bar 18 of oперативна do navigator
*********************************************
*!*	define popup shtrihlog margin relative shadow color scheme 4

*!*	define bar 1 of shtrihlog prompt 'Время отправления'
*!*	define bar 2 of shtrihlog prompt 'Время приема'

*********************************************
*********************************************
define popup wnelog margin relative shadow color scheme 4

define bar 	1 of wnelog prompt 'отгрузка на кооперацию и склады'
on bar 		1 of wnelog activate popup otgruzka
define bar 	2 of wnelog prompt 'прием с кооперации и складов'
on bar 		2 of wnelog activate popup priem
*********************************************
define popup otgruzka margin relative shadow color scheme 4

define bar 	1 of otgruzka prompt 'по позициям штрихкода'
*!*	on selection bar 1 of otgruzka do form f_logist_new
*!*	on bar 		1 of otgruzka activate popup otgrw
define bar 	2 of otgruzka prompt 'по исполнителям'
on bar 		2 of otgruzka activate popup priemw
*********************************************
define popup priem  margin relative shadow color scheme 4

define bar 	1 of priem prompt 'по позициям штрихкода'
on bar 		1 of priem activate popup otgrn
define bar 	2 of priem prompt 'по исполнителям'
on bar 		2 of priem activate popup priemn
*********************************************
*********************************************
define popup shtrihmsl margin relative shadow color scheme 4

define bar 1 of shtrihmsl prompt 'Начало работ по операции'
define bar 2 of shtrihmsl prompt 'Конец работ по операции'
define bar 3 of shtrihmsl prompt 'Прием позиции с пердыдущей операции'
define bar 4 of shtrihmsl prompt 'Прием позиции на склад'

*********************************************
define popup popmater margin relative shadow color scheme 4

define bar 3 of popmater prompt 'Остатки'
define bar 7 of popmater prompt 'Эталонная база' skip for ut = 8 or ut = 1 or ut = 9
define bar 8 of popmater prompt 'Печать ЛЗК по эталонной базе' skip for ut = 8  
define bar 13 of popmater prompt 'Остатки промежуточных складов'
define bar 14 of popmater prompt 'Лимитки со штрих_кодами' skip for ut = 8  
on selection bar 3 of popmater do form f_ostatok_oper		&&	f_ostatok_new_sql
on selection bar 7 of popmater do form f_shwzras_sql
on selection bar 8 of popmater do form fr_shwzras_sql
on selection bar 13 of popmater do form f_promost
on selection bar 14 of popmater do form f_limone
aa = sys(5)+SYS(2003)+'\'
*wait window '<'+aa+'>'

define popup popPlanir margin relative shadow color scheme 4

define bar 1 of popPlanir prompt "Производственная база и оперативное планирование" skip for ut <> 5 .and. ut <> 6
define bar 4 of popPlanir prompt "Работа с план-заданиями" skip for ut <> 5 .and. ut <> 6
define bar 5 of popPlanir prompt "Печать план-заданий"
define bar 7 of popPlanir prompt "Заполнение производственной базы (временная схема)" skip for ut <> 5 .and. ut <> 6
define bar 11 of popPlanir prompt "\-"
define bar 12 of popPlanir prompt "Печать ведомости готовности"
define bar 13 of popPlanir prompt "Удаление план-заданий" skip for ut <> 5 .and. ut <> 6
define bar 14 of popPlanir prompt "Печать передаточной накладной"
define bar 15 of popPlanir prompt "Печать вед-ти по незапл. позициям"
define bar 77 of popPlanir prompt "Заполнение производственной базы по технологически подготовленным изделиям" 	skip for ut <> 5 .and. ut <> 6

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
define bar 78 of popPlanir prompt "Создание справочника рабочего времени"
on selection bar 78 of popPlanir do form f_kalend

define popup sebest margin relative shadow color scheme 4
define bar 8 of sebest prompt "Калькуляция. Маржинальный метод"  skip for ut = 8 or ut = 9 
on selection BAR 8 of sebest do   form f_plancalc1 
define bar 9 of sebest prompt "Калькуляция. Прямой метод"
on selection bar 9 of sebest do sebestoim
define bar 10 of sebest prompt "Сводная талица план. и факт. затрат по заказу"
on selection bar 10 of sebest do form STZ

define popup narpop margin relative shadow color scheme 4
 
*!*	define bar		6 of narpop prompt 'Учет сданной продукции ОТК'
define bar		7 of narpop prompt '   Печать рабочих заданий'
define bar		8 of narpop prompt '   Печать невыполенных рабочих заданий'
define bar		9 of narpop prompt '   Печать нарядов'
define bar		10 of narpop prompt 'Работа с нарядами'
 
*!*	on selection bar 6 of narpop do start_f_nar_operplan
on selection bar 7 of narpop do form fr_rabzad
on selection bar 8 of narpop do form fr_rabnzad
on selection bar 9 of narpop do form fr_narad
on selection bar 10 of narpop do form f_nar_sql


define popup ктс margin relative shadow color scheme 4

define bar 1 of ктс prompt "Подетальный ввод" skip for ut <> 2 and ut <> 3 and ut <> 4
define bar 2 of ктс prompt "КТС (корректировка, копирование, удаление)"
define bar 4 of ктс prompt "Расчет количества в изделии" skip for ut <> 2 and ut <> 3 and ut <> 4
define bar 5 of ктс prompt "Модификация изделия" skip for ut <> 2 and ut <> 3 and ut <> 4
define bar 6 of ктс prompt "Проверка ввода" skip for ut <> 2 and ut <> 3 and ut <> 4
define bar 23 of ктс prompt "Копирование узла" skip for ut <> 2 and ut <> 3 and ut <> 4

on bar 			 1 of ктс activate popup подетальны
on selection bar 2 of ктс do form f_kt_vib_sql with "user"
on selection bar 4 of ктс do new_koliz
on selection bar 5 of ктс do form f_modif
on selection bar 23 of ктс do form f_copy_uzel

on selection bar 6 of ктс activate popup _13f14n0c9

define popup подетальны margin relative shadow color scheme 4
define bar		 1 of подетальны prompt "Ввод конструктора"
define bar		 2 of подетальны prompt "Ввод технолога"
on selection bar 1 of подетальны do form f_kt_vvod_sql with "add1","kons"
on selection bar 2 of подетальны do form f_kt_vib_sql with "tech"

*** меню проверки ввода
define popup _13f14n0c9 margin relative shadow color scheme 4

define		 bar 1 of _13f14n0c9 prompt "Правильность ввода"
on selection bar 1 of _13f14n0c9 do form fr_provmat
define		 bar 2 of _13f14n0c9 prompt "Уникальные короткие номера"
on selection bar 2 of _13f14n0c9 do form f_serv17
define		 bar 3 of _13f14n0c9 prompt "Дополнительные проверки"
on selection bar 3 of _13f14n0c9 do form fr_provplus
define		 bar 4 of _13f14n0c9 prompt "Проверка несоответствия количества для покупных"
on selection bar 4 of _13f14n0c9 do form f_kt_test_kol
define		 bar 5 of _13f14n0c9 prompt "Поиск неиспользуемых материалов"
on selection bar 5 of _13f14n0c9 do form f_service_mater_free
define		 bar 15 of _13f14n0c9 prompt "Строки КТС со значениями NULL"
on selection bar 15 of _13f14n0c9 do form fr_error_null


define popup расчетразв margin relative shadow color scheme 4

define bar 1 of расчетразв prompt "Трубы и круги"
define bar 2 of расчетразв prompt "Листы и полосы"
on selection bar 1 of расчетразв do form f_raschet_kt
on selection bar 2 of расчетразв do form f_raschet_lp


define popup bыходныефо margin relative shadow color scheme 4
 
define bar 2 of bыходныефо prompt "Номенклатура изделия по участку(ПО ПРОИЗВОДСТВЕННОЙ БАЗЕ)" skip for ut = 9
define bar 4 of bыходныефо prompt "Детально-специфицированная ведомость материалов и комплектующих"
define bar 6 of bыходныефо prompt "Ведомость норм времени и расценок" skip for ut = 9
define bar 18 of bыходныефо prompt "Сводная ведомость материалов и комплектующих"  
define bar 25 of bыходныефо prompt "Сводная трудоемкость на изделие" skip for ut = 9
define bar 27 of bыходныефо prompt "Печать справочников" skip for ut = 9
define bar 50 of bыходныефо PROMPT "Конструкторско-технологические спецификации(КТС)" skip for ut = 9
define bar 70 of bыходныефо PROMPT "Характеристика номенлатуры изделия" skip for ut = 9
define bar 75 of bыходныефо PROMPT "Ведомость дефицита материалов" skip for ut = 9
define bar 112 of bыходныефо prompt "Маршрутно-сопроводительный лист" skip for ut = 9
define BAR 120 of bыходныефо prompt "Сводная трудоемкость на запуск" skip for ut = 9
define bar 500 of bыходныефо PROMPT "Отчет по состоянию заказа" skip for ut = 9

on selection bar 2   of bыходныефо do form fr_wr_ww_sql
on selection bar 4   of bыходныефо do form f_dsnmat
on selection bar 6   of bыходныефо do WNW_ && report form r_izd preview
on selection bar 18  of bыходныефо do form f_svodmat
on selection bar 25  of bыходныефо do form fr_st
on selection bar 50  of bыходныефо do form fr_rasceh1_sql
on selection bar 70  of bыходныефо do form f_wwmar_sql
on selection bar 75  of bыходныефо do form fr_deficit
on selection bar 112 of bыходныефо do form fr_msl_xml
on selection bar 120 of bыходныефо do form fr_stz
on selection bar 500 of bыходныефо do form fr_sostzak


on bar 27 of bыходныефо activate popup mnSpr

define popup mnSpr margin relative shadow color scheme 4

*!*	define bar 1 of mnSpr prompt "Группы материалов"
*!*	define bar 2 of mnSpr prompt "Сортамент материалов"
*!*	define bar 3 of mnSpr prompt "Стандарты поставки материалов"
*!*	define bar 4 of mnSpr prompt "Стандарты химсостава материалов"
define bar 5 of mnSpr prompt "Профессии"
define bar 6 of mnSpr prompt "Типовые техпроцессы"
define bar 7 of mnSpr prompt "Тарифные сетки"
define bar 8 of mnSpr prompt "Подразделения (участки)"
define bar 9 of mnSpr prompt "Виды оборудования"
define bar 10 of mnSpr prompt "Коды технологических операций"
define bar 11 of mnSpr prompt "Причины изменений"
define bar 16 of mnSpr prompt "Сотрудники"
define bar 18 of mnSpr prompt "Оснастка"
define bar 20 of mnSpr prompt "Оборудование"
define bar 77 of mnSpr prompt "Материалы нерекомендуемые"
 
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

define bar 1 of mn_dsn prompt "Основные"
define bar 2 of mn_dsn prompt "Комплектующие"
on selection bar 1 of mn_dsn 	do form fr_dsn
on selection bar 2 of mn_dsn 	do form f_dsnkm

define popup _13f194dn9 margin relative shadow color scheme 4
define bar 1 of _13f194dn9 prompt "материалы"
define bar 2 of _13f194dn9 prompt "оплата труда"
on bar 1 of _13f194dn9 activate popup _13f19bain

define popup _13f19bain margin relative shadow color scheme 4
define bar 1 of _13f19bain prompt "Детально-специфицированные нормы"
define bar 2 of _13f19bain prompt "Обобщенная ведомость материалов"
on selection bar 2 of _13f19bain do form fr_owm

define popup cправочник margin relative shadow color scheme 4

define bar 		 1 of cправочник prompt "Изделия" skip for ut = 9
on selection bar 1 of cправочник do form f_izd_sql
define bar 		 10 of cправочник prompt "Материалы" skip for ut = 9
on selection bar 10 of cправочник do form f_mater_vib with "vie"
define bar 		 11 of cправочник prompt "Справочники DOSP" skip for ut <> 2
on selection bar 11 of cправочник do form f_dosp_sql
define bar		 12 of cправочник prompt "Справочники прочие" skip for ut <> 2
on selection bar 12 of cправочник do form f_sprav
define bar		 29 of cправочник prompt 'Контрагенты' skip for ut = 9
on selection bar 29 of cправочник do form f_kontrag_sql
define bar		 30 of cправочник prompt 'Договора' skip for ut = 9
on selection bar 30 of cправочник do form f_dogovor
define bar		 31 of cправочник prompt 'Машкомплекты' skip for ut = 9
on selection bar 31 of cправочник do form f_mako
define bar		 32 of cправочник prompt 'Спецматриалы' skip for ut = 9
on selection bar 32 of cправочник do form f_specmat

define popup cервис margin relative shadow color scheme 4

*!*	define bar		 5 of cервис prompt "Экспорт кодов материалов в 1С"
define bar		 34 of cервис prompt 'Журнал'
define bar		 36 of cервис prompt 'Пользователи' skip for !inlist(ut,2)
define bar		 38 of cервис prompt "Сервис замены материалов" skip for ut<>2
define bar 		 115 of cервис prompt 'Архивирование изделий' skip for ut <> 2
define bar		 116 of cервис prompt 'Удаление ЛЗК по маске' skip for ut <> 5 && нач ПДО

define bar 999 of cервис prompt "\-"
define bar 1000 of cервис prompt "Релиз 205.1 beta от 25/09/2012" skip for .t. && version

*!*	on selection BAR 5 of cервис do form f_serv_555
on selection bar 34 of cервис do form f_logview
on selection bar 36 of cервис do run_t1
on selection bar 38 of cервис do form f_mater_zamena
on selection bar 115 of cервис do form f_arc_izd_sql
on selection bar 116 of cервис do form f_clean_shwz

*******
function can()
return !file('debug.inf')
endfunc
