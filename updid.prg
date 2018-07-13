PROCEDURE updi
LOCAL cRibf, ikoli,m.kodm
DO FORM f_izd_vib TO cRibf
*WAIT WINDOW cRibf
if empty(cRibf)
	return
endif

*******excel**************
SELECT pozn,poznd,naimd,kodm1,kodm,poznw,kol,koli from kt ;
		 WHERE pozn = cRibf AND kol > 0 ;
         order BY poznd ;
         INTO CURSOR c_output
GO TOP
m.naim = pozn
m.ribf = cRibf
   
********** ОБЬЕКТ EXCEL *************
LOCAL  loExcel, lcOldError,lcRange, lnCounterS, lnCounterB, ;
	  lnBook,lnROwShapka
	  
WAIT WINDOW NOWAIT 'Excel открывается...'

loExcel = CREATEOBJECT("Excel.Application")

********** свойства заполняемых ячеек ******************
LOCAL lnWorkbooks,lnCounterWB, lnRow ,lnRow12,npp 
WITH loExcel
	.Workbooks.Add()
	.Workbooks.Open(sys(5)+sys(2003)+'\UPDI.XLS')
	.DisplayAlerts = .F.
		WITH .Range("A2:F2")
		     .Value = allt(m.naim)+' '+m.ribf
		     .Merge
		ENDWITH  		
	lnRow = 6
    npp=0
    ikoli=0
    SELECT c_output
    GO top
    SCATTER MEMVAR 
	DO WHILE !EOF()  
	    WAIT WINDOW NOWAIT "Вносятся данные: запись " +;
		ALLTRIM(STR(RECNO())) + " из " + ALLTRIM(str(recc())) 
		npp = npp+1
		WITH .Cells(lnRow, 1)
			.Value =  ALLTRIM(STR(npp))
			.ColumnWidth = 5
		ENDWITH 
		*IF ALLTRIM(m.poznd)=ALLTRIM(c_output.poznd)
	    *	.Cells(lnRow, 2).Value =  ' '
		*ELSE
			
		*endif
		if empty(m.poznd)
			.Cells(lnRow,2).Value = get_mater(m.kodm)		
		else
			.Cells(lnRow, 2).Value =  allt(m.poznd) +' '+allt(m.naimd) 
		endif
		
	    .Cells(lnRow, 3).Value =  allt(m.poznw)
		.Cells(lnRow, 4).Value =  allt(STR(m.kol))
		.Cells(lnRow, 5).Value =  allt(str(m.koli))
 		lnRow= lnRow+1
 		
 		SELECT c_output
 		skip
 		
 		*WAIT 'm.poznd='+m.poznd+'  c_output.poznd='+c_output.poznd wind
 		IF ALLTRIM(m.poznd)#ALLTRIM(c_output.poznd) .and. !empty(m.poznd)
 			*WAIT '### m.poznd='+m.poznd+'  c_output.poznd='+c_output.poznd wind
 			SELECT pozn,poznd,koli FROM kt ;
			 WHERE pozn = cRibf AND poznd=m.poznd AND kol>0 ;
			into CURSOR c_itog
 			IF RECCOUNT()>1 
	 			*BROWSE
	 			*IF LASTKEY()=27
	 			*   CANCEL 
	 			*ENDIF
	 			SUM koli TO ikoli
	 			*lnRow= lnRow+1
	 			.Cells(lnRow, 5).Value = 'ИТОГО: '+str(ikoli,8)	 			
	 			lnRow= lnRow+1
 			ENDIF
 			USE IN c_itog
 		ENDIF 
 		* выводим строчку-разделитель
 		.Cells(lnRow,1).Value = ''
 		lnRow = lnRow+1
 		*lnRow= lnRow+1
 		select c_output
 		scatter memvar 
  ENDDO  
        npp = npp+1
		WITH .Cells(lnRow, 1)
			.Value =  ALLTRIM(STR(npp))
			.ColumnWidth = 5
		ENDWITH 
		 
		.Cells(lnRow, 2).Value =  allt(m.poznd) +' '+allt(m.naimd)
	    .Cells(lnRow, 3).Value =  allt(m.poznw)
		.Cells(lnRow, 4).Value =  allt(STR(m.kol))
		.Cells(lnRow, 5).Value =  allt(str(m.koli)) 		
 		
 		IF ALLTRIM(m.poznd)#ALLTRIM(c_output.poznd)
 			SELECT pozn,poznd,koli FROM kt ;
			 WHERE pozn = cRibf AND poznd=m.poznd AND kol > 0 ;
			into CURSOR c_itog
 			IF RECCOUNT()>1 
	 			SUM koli TO ikoli
	 			*lnRow= lnRow+1
	 			.Cells(lnRow, 5).Value = 'Всьго: '+str(ikoli,8)
			ENDIF
 			USE IN c_itog
 		ENDIF 
		.Columns("A:F").EntireColumn.AutoFit
	ENDWITH 
loExcel.Visible = .t.
WAIT WINDOW TIMEOUT 0.5 "Отчет готов."
loExcel.Visible = .t.
loExcel.activeWindow.SelectedSheets.PrintPreview
RELEASE loExcel
*CLEAR MEMORY
RETURN 
*end excel report


 