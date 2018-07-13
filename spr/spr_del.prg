IF csprav.FILEdbf='DOSP'
	SET DELETED ON
    SELECT dosp
	SCATTER MEMVAR 
	*WAIT WINDOW STR(m.nozap,6)+' '+STR(m.vid,3)+ ' '+STR(m.kod,4)
	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
		DELETE FROM dosp where nozap = m.nozap 
	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF
IF csprav.FILEdbf='KADRY'
	SELECT KADRY
	SCATTER MEMVAR 
	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
		DELETE FROM KADRY where TN=M.TN
	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF
IF csprav.FILEdbf='OBOR'
	SELECT OBOR
	SCATTER MEMVAR 
 	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
 		DELETE FROM OBOR where INVN=M.INVN
	ENDIF 
 	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF
IF csprav.FILEdbf='BRUT'
	=MESSAGEBOX('Ця інформація не підлягає видаленню!',0,'УВАГА!')
 	*SELECT BRUT
	*SCATTER MEMVAR 
*	DELETE FROM BRUT where 
*	thisform.grid.Refresh
ENDIF
IF csprav.FILEdbf='TARIF'
	SELECT TARIF
	SCATTER MEMVAR 
 	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
 		DELETE FROM TARIF WHERE nozap= m.nozap 
 	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF
IF csprav.FILEdbf='POST'
	SELECT POST
	SCATTER MEMVAR 
	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
		DELETE FROM POST where nozap=m.nozap
	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF

IF csprav.FILEdbf='INSTR' 
	SELECT INSTR
	SCATTER MEMVAR 
	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
		DELETE FROM INSTR where NOZAP=M.NOZAP
	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF
IF csprav.FILEdbf='PRESS'
	SELECT PRESS
	SCATTER MEMVAR 
	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
		DELETE FROM PRESS where NOZAP=M.NOZAP 				
	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF
IF csprav.FILEdbf='TTO'
	SELECT TTO
	SCATTER MEMVAR
	m.nozap = tto.nozap 
	 
 	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
 		*WAIT WINDOW STR(m.nozap)
 		DELETE FROM TTO WHERE NOZAP=M.NOZAP
	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh 
ENDIF
IF csprav.FILEdbf='KTU'
	SELECT KTU
	SCATTER MEMVAR 
 	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
 		DELETE FROM KTU WHERE NOZAP= M.NOZAP
    ENDIF 
    _screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF
IF csprav.FILEdbf='KTO'
	SELECT KTO
	SCATTER MEMVAR 
 	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
 		DELETE FROM KTO where NOZAP = M.NOZAP 
	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF
IF csprav.FILEdbf='RD'
	SELECT RD
	SCATTER MEMVAR 
 	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
 		DELETE FROM RD where  NOZAP=M.NOZAP
	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF
IF csprav.FILEdbf='IZD'
	SELECT izd
	SCATTER MEMVAR 
 	IF MESSAGEBOX("Запись будет удалена","Внимание",4)=6
 		DELETE FROM izd where  NOZAP=M.NOZAP
	ENDIF 
	_screen.ActiveForm.Container2.Container1.grid.Refresh
ENDIF