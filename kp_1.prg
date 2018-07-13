npp=1
Wait Window Nowait '«‡ÔÛÒÍ‡ÂÏ Excel'
loexcel = Createobject('Excel.Application')
loexcel.workbooks.Open(Sys(5)+Sys(2003)+'\grrem.xls')
loexcel.displayalerts = .F.
nnom=7
*
hhh = SQLConnect('sqldb','sa','111')

If hhh > 0
	rrr = SQLExec(hhh,"Select invn,naim,marka,wr,sm From OBOR WHERE INVN<>'' Order By naim",'c_obor')
	If rrr = -1
		eodbc('f_wkp ff p_c OBOR')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('f_wkp ff p_c obor conn')
Endif
Select c_obor

Scan
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rr = SQLExec(hh,"Select * From kp Where invn=?c_obor.invn order by invn,chas",'c_kp')
		If rr = -1
			eodbc('kp_1 sele kp')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('kp_1  kp conn')
	Endif
	Select c_kp
	If Reccount() > 0
		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrr = SQLExec(hhh,"Select * From kp_1 Where invn=?c_obor.invn order by invn,chas",'c_kp_1')
			If rrr = -1
				eodbc('f_wkp ff p_c kp')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('f_wkp ff p_c kp conn')
		Endif

		Select c_kp
		Go Top
		CHAS_OLD	= c_kp.CHAS
		CHAS_MIN 	= c_kp.CHAS
		CHAS_MAX 	= c_kp.CHAS
		*!*				wait window 'MIN=OLD='+str(CHAS_MIN)
		Go Bott
		CHAS_MAX_EOF= c_kp.CHAS
		*!*
		*!*				wait window 'MAX='+str(CHAS_MAX)

		loexcel.cells(nnom,1).Value = npp
		loexcel.cells(nnom,3).Value = Alltrim(c_obor.marka)+' '+Alltrim(c_obor.NAIM)
		loexcel.cells(nnom,2).Value = c_obor.invn
		loexcel.cells(nnom,4).Value = c_obor.sm

		Scan
			If c_kp.CHAS - CHAS_OLD > 1
				npp=npp+1
				CHAS_MAX 	= CHAS_OLD
*!*					Wait Window 'CHAS_OLD='+Str(CHAS_OLD,3)+' CHAS='+Str(CHAS,3)+' CHAS_MIN='+Str(CHAS_MIN,3)+'   CHAS_MAX='+Str(CHAS_MAX,3)
				loexcel.cells(nnom,5).Value = 'œÀ¿Õ'
				DEN = Int(CHAS_MIN / 80)
				loexcel.cells(nnom,7).Value = DEN
				chasiki = (CHAS_MIN - (DEN-1)*80) / 10 + 8
				chasiki_celoe = Int(chasiki)
				MINUTI = (chasiki - chasiki_celoe)*60
				If MINUTI=0
					loexcel.cells(nnom,8).Value = Str(chasiki_celoe,2)+'.00'
				Else
					loexcel.cells(nnom,8).Value = Str(chasiki_celoe,2)+'.'+Str(MINUTI,2)
				Endif
				*!*						loexcel.cells(nnom,8).value = str(chasiki_celoe,2)+'.'+STR((chasiki - chasiki_celoe)*60,2)
				DEN = Int(CHAS_MAX/80)
				loexcel.cells(nnom,9).Value = DEN
				chasiki = (CHAS_MAX - (DEN-1)*80) / 10 + 8
				chasiki_celoe = Int(chasiki)
				MINUTI = (chasiki - chasiki_celoe)*60
				If MINUTI=0
					loexcel.cells(nnom,10).Value = Str(chasiki_celoe,2)+'.00'
				Else
					loexcel.cells(nnom,10).Value = Str(chasiki_celoe,2)+'.'+Str(MINUTI,2)
				Endif
				*!*						loexcel.cells(nnom,10).value = str(chasiki_celoe,2)+'.'+STR((chasiki - chasiki_celoe)*60,2)
				*!*						loexcel.cells(nnom,10).value = alltrim(str((CHAS_MAX - (DEN-1)*80) / 10+ 8,5,2))

				chasiki = (CHAS_MAX - CHAS_MIN ) / 10
				chasiki_celoe = Int(chasiki)
				MINUTI = (chasiki - chasiki_celoe)*60
				If MINUTI=0
					loexcel.cells(nnom,11).Value = Str(chasiki_celoe,2)+'.00'
				Else
					loexcel.cells(nnom,11).Value = Str(chasiki_celoe,2)+'.'+Str(MINUTI,2)
				Endif


				nnom = nnom + 1
				CHAS_MIN = c_kp.CHAS
				CHAS_MAX = c_kp.CHAS
			Endif
			CHAS_OLD = c_kp.CHAS

		Endscan

		CHAS_MAX = CHAS_MAX_EOF
*!*			Wait Window ' EOF CHAS_OLD='+Str(CHAS_OLD,3)+' CHAS='+Str(CHAS,3)+' CHAS_MIN='+Str(CHAS_MIN,3)+'   CHAS_MAX='+Str(CHAS_MAX,3)
		loexcel.cells(nnom,5).Value = 'œÀ¿Õ'
		DEN = Int(CHAS_MIN / 80)
		loexcel.cells(nnom,7).Value = DEN
		chasiki = (CHAS_MIN - (DEN-1)*80) / 10 + 8
		chasiki_celoe = Int(chasiki)
		MINUTI = (chasiki - chasiki_celoe)*60
		If MINUTI=0
			loexcel.cells(nnom,8).Value = Str(chasiki_celoe,2)+'.00'
		Else
			loexcel.cells(nnom,8).Value = Str(chasiki_celoe,2)+'.'+Str(MINUTI,2)
		Endif
		*!*						loexcel.cells(nnom,8).value = str(chasiki_celoe,2)+'.'+STR((chasiki - chasiki_celoe)*60,2)
		DEN = Int(CHAS_MAX/80)
		loexcel.cells(nnom,9).Value = DEN
		chasiki = (CHAS_MAX - (DEN-1)*80) / 10 + 8
		chasiki_celoe = Int(chasiki)
		MINUTI = (chasiki - chasiki_celoe)*60
		If MINUTI=0
			loexcel.cells(nnom,10).Value = Str(chasiki_celoe,2)+'.00'
		Else
			loexcel.cells(nnom,10).Value = Str(chasiki_celoe,2)+'.'+Str(MINUTI,2)
		Endif
		*!*						loexcel.cells(nnom,10).value = str(chasiki_celoe,2)+'.'+STR((chasiki - chasiki_celoe)*60,2)
		*!*						loexcel.cells(nnom,10).value = alltrim(str((CHAS_MAX - (DEN-1)*80) / 10+ 8,5,2))


		chasiki = (CHAS_MAX - CHAS_MIN ) / 10
		chasiki_celoe = Int(chasiki)
		MINUTI = (chasiki - chasiki_celoe)*60
		If MINUTI=0
			loexcel.cells(nnom,11).Value = Str(chasiki_celoe,2)+'.00'
		Else
			loexcel.cells(nnom,11).Value = Str(chasiki_celoe,2)+'.'+Str(MINUTI,2)
		Endif

		nnom = nnom + 1
		Select c_kp_1
		Go Top
		datan = c_kp_1.CHAS
		*!*				wait window c_kp_1.INVN +' MIN ='+STR(c_kp_1.CHAS)
		loexcel.cells(nnom,5).Value = '√–¿‘.–≈Ã.'
		loexcel.cells(nnom,6).Value = c_kp_1.vr
		DEN = Int(c_kp_1.CHAS/80) + 1
		loexcel.cells(nnom,7).Value = DEN
		chasiki = (c_kp_1.CHAS - (DEN-1)*80) / 10 + 8
		chasiki_celoe = Int(chasiki)
		MINUTI = (chasiki - chasiki_celoe)*60
		If MINUTI=0
			loexcel.cells(nnom,8).Value = Str(chasiki_celoe,2)+'.00'
		Else
			loexcel.cells(nnom,8).Value = Str(chasiki_celoe,2)+'.'+Str(MINUTI,2)
		Endif
		*!*				loexcel.cells(nnom,8).value = str(chasiki_celoe,2)+'.'+STR((chasiki - chasiki_celoe)*60,2)
		*!*				loexcel.cells(nnom,8).value = alltrim(str((c_kp_1.CHAS - (DEN-1)*80) / 10 + 8,5,2))
		Go Bott
		*!*				wait window c_kp_1.INVN +' MAX ='+STR(c_kp_1.CHAS)

		datak = c_kp_1.CHAS
		DEN = Int(c_kp_1.CHAS/80) + 1
		loexcel.cells(nnom,9).Value = DEN
		*!*				if c_kp_1.invn='229'
		*!*				wait wind 'c_kp_1.CHAS - (DEN-1)*80)='+str(c_kp_1.CHAS)+'   '+str((DEN-1)*80)
		*!*				wait wind 'str((c_kp_1.CHAS - (DEN-1)*80) / 10 + 8='+str((c_kp_1.CHAS - (DEN-1)*80) / 10 + 8,7,3)
		*!*				endif
		*!*				loexcel.cells(nnom,10).value = alltrim(str((c_kp_1.CHAS - (DEN-1)*80) / 10 + 8,5,2))
		chasiki = (c_kp_1.CHAS - (DEN-1)*80) / 10 + 8
		chasiki_celoe = Int(chasiki)
		MINUTI = (chasiki - chasiki_celoe)*60
		If MINUTI=0
			loexcel.cells(nnom,10).Value = Str(chasiki_celoe,2)+'.00'
		Else
			loexcel.cells(nnom,10).Value = Str(chasiki_celoe,2)+'.'+Str(MINUTI,2)
		Endif
		*!*				loexcel.cells(nnom,10).value = str(chasiki_celoe,2)+'.'+STR((chasiki - chasiki_celoe)*60,2)


		chasiki = (datak - datan) / 10
		chasiki_celoe = Int(chasiki)
		MINUTI = (chasiki - chasiki_celoe)*60
		If MINUTI=0
			loexcel.cells(nnom,11).Value = Str(chasiki_celoe,2)+'.00'
		Else
			loexcel.cells(nnom,11).Value = Str(chasiki_celoe,2)+'.'+Str(MINUTI,2)
		Endif


		nnom = nnom + 1
		Use In c_kp_1
	Endif
	Use In c_kp
Endscan
Use In c_obor
Wait Window Nowait 'Œ“◊≈“ √Œ“Œ¬ !'
loexcel.Visible = .T.
