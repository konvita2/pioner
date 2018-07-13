PUBLIC glPar1,glPar2,glPar3,glPar4,glPar5,glPar6,glPar7,glPar8,glPar9
PUBLIC glPar1_1,glPar1_2
PUBLIC glPar2_1
PUBLIC glPar3_1
PUBLIC glPar4_1

PUBLIC ARRAY glAr1[1000]

* переменные для описания пользователя
PUBLIC glUser,glUserType

* переменные для запоминания позиции и размера f_kt_vib
PUBLIC glSavKtVibX, glSavKtVibY, glSavKtVibH, glSavKtVibW
STORE 0 TO glSavKtVibX, glSavKtVibY, glSavKtVibH, glSavKtVibW

CLOSE ALL 

SET DATE BRITISH 
SET CENTURY ON 
SET SYSMENU OFF 
SET EXACT ON	
SET DELETED ON 	
SET EXCLUSIVE Off
SET PROCEDURE TO procs,procsplus
SET OPTIMIZE ON 
SET UNIQUE OFF 

OPEN DATABASE db

_screen.Windowstate = 2 
_screen.Caption = 'АРМ ДП "'+'Автобусний завод "БОГДАН"'
_screen.BackColor = 8421504

* legal
IF DATE() > {^2004-01-31}
	quit
ENDIF 

* legal
SELECT count(*) FROM kt INTO ARRAY a
IF a[1] > 5700
	quit
ENDIF 

* legal
SELECT * FROM dosp WHERE vid=2 AND kod=126 INTO CURSOR ct1000
IF alltrim(ct1000.im) <> 'Дiльниця слюсарних робiт'
	quit
ENDIF 
USE IN ct1000

*DO "main_menu.prg"
*READ EVENTS 

do form f_kt_vib with 'user'

CLOSE DATABASES 
SET SYSMENU TO DEFAULT 
