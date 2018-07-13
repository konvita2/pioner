IF csprav.FILEdbf='DOSP'
	SELECT dosp
	SCATTER MEMVAR blan
	SELECT MAX(nozap)from dosp INTO ARRAY a  
	m.nozap = a[1] + 1 
	m.vid = dosp.vid
	*WAIT WINDOW 'Command5 click m.nozap='+STR(m.nozap,6)+'  m.vid='+STR(m.vid,4)+'  m.kod='+STR(m.kod,4)
	DO CASE 
		CASE m.vid=4 OR m.vid=10 or m.vid=11 or m.vid=12 or m.vid=26 or m.vid=40 or m.vid=51 or m.vid=53 
			m.im = ALLTRIM(dosp.im)
			DO FORM f_dosp_im_add 
		
		CASE m.vid=44
		     m.im  = ALLTRIM(dosp.im)
		     m.sim = ALLTRIM(dosp.sim)
		     m.kod = dosp.kod
		     m.vid= dosp.vid
		     DO form f_dosp_im_sim_add
	     
	     CASE m.vid=2 OR m.vid=5 or m.vid=21 or m.vid=22 or m.vid=23 or m.vid=33
			 m.im = ALLTRIM(dosp.im)
	         m.us = dosp.us
	    *     WAIT WINDOW 'Command5 click IM_US m.nozap='+STR(m.nozap,6) ;
     	 *        +'  m.vid='+STR(m.vid,4)+'  m.kod='+STR(m.kod,4)
			 DO FORM f_dosp_im_us_add 
		 
	    
	    CASE m.vid=9 OR m.vid=30 or m.vid=31 or m.vid=32 or m.vid=34 or m.vid=41 
			 m.im = ALLTRIM(dosp.im)
	         m.us = dosp.us
	         m.vid=dosp.vid
	         m.kod=dosp.kod
	         m.nozap=dosp.nozap
			 DO FORM f_dosp_im_sim_us_add 
		 
		CASE m.vid=7
			*WAIT WINDOW "vid="+' '+ STR(m.kod)
			m.im   = ALLTRIM(dosp.im)
			m.sim  = ALLTRIM(dosp.sim)
			m.obor = ALLTRIM(dosp.obor)
			m.vid  = dosp.vid
			m.kod  = dosp.kod
			m.nozap=dosp.nozap
			DO FORM f_dosp_im_sim_obor_add 
		     
		CASE m.vid=52
		*	WAIT WINDOW "kod="+' '+ STR(m.kod)
			m.im = ALLTRIM(dosp.im)
			m.us = dosp.us
			m.obor = ALLTRIM(dosp.obor)
			DO FORM f_dosp_im_us_obor_add
	ENDCASE 
ENDIF
IF csprav.FILEdbf='KADRY'
	SELECT KADRY
	SCATTER MEMVAR blan
	M.TN  = KADRY.TN
    m.FIO = ALLTRIM(KADRY.FIO)
	M.PODR= KADRY.PODR
	DO FORM f_KADRY_add 
ENDIF
IF csprav.FILEdbf='OBOR'
	SELECT OBOR
	SCATTER MEMVAR blan
	DO FORM f_obor_add 
ENDIF
IF csprav.FILEdbf='BRUT'
	=MESSAGEBOX('÷€ ≥нформац≥€ не п≥дл€гаЇ додаванню!',0,'”¬ј√ј!')
	*SELECT BRUT
	*SCATTER MEMVAR blan
	*DO FORM f_brut_add 
ENDIF
IF csprav.FILEdbf='TARIF'
	SELECT TARIF
	SCATTER MEMVAR blan
	DO FORM f_tarif_add 
ENDIF
IF csprav.FILEdbf='POST'
	SELE POST
	SCATTER MEMVAR blan
	DO FORM f_post_add 
ENDIF
IF csprav.FILEdbf='INSTR' && AND CSPRAV.KOD=1
	SELECT INSTR
	SCATTER MEMVAR blan
	DO FORM f_instr_add 
ENDIF
IF csprav.FILEdbf='INSTR' AND CSPRAV.KOD=2
	SELECT INSTR
	SCATTER MEMVAR blan
	DO FORM f_instr_add 
ENDIF
IF csprav.FILEdbf='INSTR' AND CSPRAV.KOD=3
	SELECT INSTR
	SCATTER MEMVAR blan
	DO FORM f_instr_add 
ENDIF
IF csprav.FILEdbf='PRESS'
	SELECT PRESS
	SCATTER MEMVAR blan
	DO FORM f_press_add 
ENDIF
IF csprav.FILEdbf='TTO'
	SELECT TTO
	SCATTER MEMVAR blan
	DO FORM f_tto_add 
ENDIF
IF csprav.FILEdbf='KTU'
	SELECT KTU
	SCATTER MEMVAR blan
	DO FORM f_ktu_add 
ENDIF
IF csprav.FILEdbf='KTO'
	SELECT KTO
	SCATTER MEMVAR blan
	DO FORM f_kto_add 
ENDIF
IF csprav.FILEdbf='RD'
	SELECT RD
	SCATTER MEMVAR blan
	DO FORM f_rd_add 
ENDIF
IF csprav.filedbf="IZD"
	SELECT izd
	SCATTER MEMVAR BLANK 
	DO FORM f_izd_add
ENDIF 