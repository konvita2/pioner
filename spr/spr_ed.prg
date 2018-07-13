*WAIT WINDOW '!!! O='+O+' csprav.FILEdbf='+csprav.FILEdbf+' KOD='+STR(csprav.KOD,2)
IF csprav.FILEdbf='DOSP'
	SELECT dosp
	SCATTER memv
	*WAIT WINDOW 'Command1 click '+STR(m.nozap,6)+'  '+STR(m.vid,4)+'  '+STR(m.kod,4)
	DO CASE 
		CASE m.vid=4 OR m.vid=10 or m.vid=11 or m.vid=12 or m.vid=26 or m.vid=40 or m.vid=51 or m.vid=53 
			m.im = ALLTRIM(dosp.im)
			DO FORM f_dosp_im_edit 
		
		 CASE m.vid=2 OR m.vid=5 or m.vid=21 or m.vid=22 or m.vid=23 or m.vid=33
			 m.im = ALLTRIM(dosp.im)
	         m.us = dosp.us
	         DO FORM f_dosp_im_us_edit 
		CASE m.vid=44
		     m.im = ALLTRIM(dosp.im)
		     m.sim = ALLTRIM(dosp.sim)
		     DO form f_dosp_im_sim_edit
	     
	    CASE m.vid=9 OR m.vid=30 or m.vid=31 or m.vid=32 or m.vid=34 or m.vid=41 
			 m.im = ALLTRIM(dosp.im)
	         m.us = dosp.us
	         m.kod=dosp.kod
	         m.vid=dosp.vid
	         m.nozap=dosp.nozap
			 DO FORM f_dosp_im_sim_us_edit 
		 
		CASE m.vid=7
			m.im = ALLTRIM(dosp.im)
			m.sim = ALLTRIM(dosp.sim)
			m.obor = ALLTRIM(dosp.obor)
			DO FORM f_dosp_im_sim_obor_edit 
		     
		CASE m.vid=52
			m.im = ALLTRIM(dosp.im)
			m.us = dosp.us
			m.obor = ALLTRIM(dosp.obor)
			m.kod = dosp.kod
			m.vid = dosp.vid
			DO FORM f_dosp_im_us_obor_edit 
	ENDCASE 
ENDIF
IF csprav.FILEdbf='KADRY'
   SELECT KADRY
   SCATTER MEMV
   *WAIT WINDOW ' Command1 Click m.tn='+STR(m.tn,5)+' '+ALLTRIM(m.fio )+' '+STR(m.podr,4) 
   DO FORM F_KADRY_EDIT
ENDIF
IF csprav.FILEdbf='POST'
	SELECT post
	SCATTER  MEMVAR 
	DO FORM f_post_edit 
ENDIF
IF csprav.FILEdbf='TARIF'
	SELECT tarif
    SCATTER memv 
	DO FORM f_tarif_edit 
ENDIF
IF csprav.FILEdbf='BRUT'
	SELECT brut
    SCATTER memv 
	DO FORM f_brut_edit 
ENDIF
IF csprav.FILEdbf='RD'
	SELECT rd
    SCATTER memv 
	DO FORM f_rd_edit 
ENDIF
IF csprav.FILEdbf='TTO'
	SELECT tto
	SCATTER MEMVAR
	m.nozap = tto.nozap 
	DO FORM f_tto_edit 
ENDIF
IF csprav.FILEdbf='KTU'
	SELECT ktu
    SCATTER memv 
	DO FORM f_ktu_edit 
ENDIF
IF csprav.FILEdbf='KTO'
	SELECT kto
    SCATTER memv 
	DO FORM f_kto_edit 
ENDIF
	IF csprav.FILEdbf='OBOR'
		SELECT obor
	    SCATTER memv 
		DO FORM f_obor_edit 
	ENDIF
	IF csprav.FILEdbf='PRESS'
		SELECT press
	    SCATTER memv 
		DO FORM f_press_edit
	ENDIF
IF csprav.FILEdbf='INSTR' AND csprav.kod=1
	SELECT instr
    SCATTER memv 
	DO FORM f_instr_edit WITH 1
ENDIF
IF csprav.FILEdbf='INSTR' AND csprav.kod=2
	SELECT instr
    SCATTER memv
	DO FORM f_instr_edit WITH 2
ENDIF
IF csprav.FILEdbf='INSTR' AND csprav.kod=3
	SELECT instr
    SCATTER memv
	DO FORM f_instr_edit WITH 3
ENDIF
IF csprav.filedbf="IZD"
	SELECT izd
	SCATTER MEMVAR 
	DO FORM f_izd_edit
	*WAIT WINDOW STR(m.nozap)
ENDIF 