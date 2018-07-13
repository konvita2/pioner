Parameters nozap_kt
*!*	WAIT WINDOW 'pt.prg nozap_kt='+STR(nozap_kt)
Create Cursor ptt (;
	id N(10),;
	buk c(1),;
	pozn c(30),;
	poznd c(30),;
	naimd c(70),;
	kttp c(40),;
	kodms c(80),;
	ss c(120),;
	kod N(4),;
	eb c(5),;
	md N(11,5),;
	rash N(11,5),;
	kim N(5,3),;
	kz c(15),;
	pir c(30),;
	kd N(3,1),;
	mz N(11,5),;
	ceh N(4),;
	oper N(4),;
	knop c(35),;
	od c(86),;
	knob c(43),;
	prof N(3),;
	p N(1),;
	ut N(2),;
	kp N(1),;
	koid N(3),;
	tpz N(4,1),;
	tsht N(10,6);
	)
*!*	brow

hh = SQLConnect('sqldb','sa','111')
If hh > 0
	rrsql = SQLExec(hh,'SeleCT * from DOSP Where vid = 44','C_tb')
	If rrsql = -1
		eodbc('PT prg tb dosp44 sele')
	Endif
	SQLDisconnect(hh)
Else
	eodbc('PT prg Obor conn')
Endif
On Key Label f12 Retu
Priv mnaim
Priv detup,detun,m_od
m_od=''
Local dosp_kod,passed_vid
Local hhh,rrsgl
Publ o[100]
Publ m[20]
Public k[15]
Public uslovi[15]
Local mpozn,mshw,iribf,msim
Priv mkttp
mkttp=''

*!*	      wait window 'nozap_kt='+str(nozap_kt)

hh = SQLConnect('sqldb','sa','111')
If hh > 0
	*!*					  select * from kt where kod = nozap_kt into cursor c_kt
	rrsql = SQLExec(hh,'select * from KT where kod = ?nozap_kt','C_KT')
	If rrsql = -1
		eodbc('PT PRG KT Select')
	Endif
	SQLDisconnect(hh)
Else
	eodbc('PT PRG KT conn')
Endif
If Recc() = 0
	Wait 'HET TAKOЙ ПOЗИЦИИ !!!' Wind
	Return - 1
Endif

Select c_kt
m.gpokr = c_kt.gpokr
m.pozn  = c_kt.pozn
m.poznd = c_kt.poznd
m.naimd = c_kt.naimd
m.md 	  = c_kt.wag
m.rash  = c_kt.nrmd
m.kim   = Iif(c_kt.nrmd#0,c_kt.wag/c_kt.nrmd,0)
m.kz = ''
If !Empty(c_kt.kodzag)
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		*!*					  select * from dosp where vid=56 and kod=c_kt.kodzag into cursor c_dosp56
		rrsql = SQLExec(hh,'select * from DOSP where vid=56 and kod=?c_kt.kodzag','C_DOSP56')
		If rrsql = -1
			eodbc('PT PRG DOSP56 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP56 conn')
	Endif
	m.kz    = Alltrim(c_dosp56.im)
	Use In c_dosp56
Endif
m.pir   = Allt(Str(c_kt.rozma,6,1))+'-'+Iif(c_kt.tocha<>0,Allt(Str(c_kt.tocha,4,2)),'')+ ;
	iif(c_kt.rozmb<>0,'x'+Allt(Str(c_kt.rozmb,6,1)),'')+ ;
	iif(c_kt.tochb<>0,'-'+Allt(Str(c_kt.tochb,4,2)),'')
m.kd    = 1
m.mz    = c_kt.mz


hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	*!*					  select gr,sort,kodm,tm,dm,ps,naim,ei from mater where kodm = c_kt.kodm into curs c_mater
	rrsql = SQLExec(hh,'select gr,sort,kodm,tm,dm,ps,naim,ei from MATER where kodm =?c_kt.kodm ','C_mater')
	If rrsql = -1
		eodbc('pr PRG MATER sele')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('pt PRG MATER conn')
Endif
m.kodms = c_mater.naim
m.eb    = c_mater.ei

Insert Into ptt From Memv

hhh = SQLConnect('sqldb','sa','111')
If hhh > 0
	*!*					  select * from te where poznd=c_kt.poznd order by nto,ntp into curs c_tee
	rrsql = SQLExec(hh,'select * from te where rtrim(poznd) = rtrim(?c_kt.poznd) order by nto,ntp','C_tee')
	If rrsql = -1
		eodbc('PT prg  TE ')
	Endif
	SQLDisconnect(hhh)
Else
	eodbc('PT prg TE conn')
Endif
If Reccount()>0 And !Empt(kttp)
	Do ptp
Else
	Use In c_tee
	Wait 'по детали '+c_kt.poznd+' пусто !!! ' Wind
Endif
Use In c_kt
Use In c_mater
*!*	select * from ptt
Do printptt
On Key
Use In c_TB
Retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc ptp
Store 0 To o
ind=1
Select c_tee
Do While .Not.Eof()
	*!*	   wait 'nto='+str(nto,3) wind
	ind=1
	Do While nto#o[ind] Or o[ind]#0
		*!*	      wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind
		If o[ind]=nto
			Exit
		Endif
		If o[ind]=0 &&nto
			o[ind]=c_tee.nto
			Exit
		Endif
		ind=ind+1
		If ind>100
			Wait 'недостаточно памяти, надо расширить' Wind
			Exit
		Endif
	Enddo
	Skip
Enddo
Use In c_tee
ind=1

Do While o[ind]#0
	*!*	   wait 'ind='+str(ind,3)+' o[ind]='+str(o[ind],3) wind

	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*						select * from te where poznd=c_kt.poznd and nto=o[ind] order by ntp into curs c_te
		rrsql = SQLExec(hhh,'Select * From TE Where poznd=?c_kt.poznd and nto=?o[ind] order by ntp ','C_TE')
		If rrsql = -1
			eodbc('PT prg TE NTO Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg te conn')
	Endif

	*!*	        brow
	*!*	   	  WAIT 'sele TE c_te.kttp='+c_te.kttp+mkttp+' c_kt.poznd='+c_kt.poznd+' O='+str(O[IND],3)+str(ind) WIND
	Sum  normw,tpz To itogt,itpz
	If itogt = 0
		Wait 'нет в TE информации по операции '+Str(o[ind],4)+' '+Alltrim(c_kt.poznd) Wind
	Else
		Go Top
		Do While !Eof()
			Scat Memv
			*wait window 'itogt='+str(itogt,6,4)+' m.kto='+str(m.kto)
			If c_te.ntp < 2
				m_od = ''
				If m.kto#0

					hhh = SQLConnect('sqldb','sa','111')
					If hhh > 0
						*!*		     		  select * from dosp where vid = 7 and kod = m.kto into curs c_dosp_7
						rrsql = SQLExec(hh,'Select * from DOSP Where vid = 7 And KOD =?m.kto','C_DOSP_7')
						If rrsql = -1
							eodbc('PT PRG DOSP7 sele')
						Endif
						SQLDisconnect(hhh)
					Else
						eodbc('PT PRG DOSP7 conn')
					Endif
					If Recc()>0
						m.knop= Alltrim(Str(c_dosp_7.kod))+' '+Alltrim(c_dosp_7.im)
						If Inlist(Left(m.kttp,11),'06024.01271','06024.55273','06024.55250','06024.55290')
							*!*		      	   		wait window m.kttp

							hhh = SQLConnect('sqldb','sa','111')
							If hhh > 0
								*!*					  select * from dosp where vid = 9 and sim=c_te.kttp into cursor c9
								rrsql = SQLExec(hh,'SeleCT * from DOSP Where vid = 9 And RTRIM(sim) = RTRIM(?c_te.kttp)','C_9')
								If rrsql = -1
									eodbc('PT PRG DOSP9 sele')
								Endif
								SQLDisconnect(hhh)
							Else
								eodbc('PT PRG DOSP9 conn')
							Endif
							If Reccount()>0
								m_od = m_od + ' '+Alltrim(c_te.kttp)+' '+Alltrim(c_9.im)
							Else
								m_od = m_od + ' '+Alltrim(c_te.kttp)
							Endif
							Use In c_9
						Endif
					Endif
					Use In c_dosp_7
				Endif
				*!*			      wait window '246 m_od='+m_od
				If Inlist(Left(m.kttp,11),'06024.01271','06024.55273','06024.55250','06024.55290')
				Else
					Select * From c_TB Where Val(OBOR) = c_te.mar Into Cursor C_DOSP_44
					If Recc()>0
						m_od = m_od +  Alltrim(C_DOSP_44.sim)
					Endif
					Use In C_DOSP_44
				ENDIF
				If Inlist(c_te.kttp,'06024.55290.00010','06024.55290.00014','06024.55290.00012')
					IF c_te.kodp = 66
						Do stroka_a
					endif
				else
					Do stroka_a
				endif
				m.knob = ''
				If !Empt(m.kodo)

					hh = SQLConnect('sqldb','sa','111')
					If hh > 0
						rrsql = SQLExec(hh,'select marka,naim from OBOR where rtrim(MARKA) = rtrim(?m.kodo)','c_Obor')
						If rrsql = -1
							eodbc('PT prg Obor OBOR sele')
						Endif
						SQLDisconnect(hh)
					Else
						eodbc('PT prg Obor conn')
					Endif
					If Recc() > 0
						m.knob = Alltrim(c_obor.marka)+' '+Allt(c_obor.naim)
					Endif
					Use In c_obor
				ENDIF
				If Inlist(c_te.kttp,'06024.55290.00010','06024.55290.00014','06024.55290.00012')
					IF c_te.kodp = 66
						Do stroka_b
					endif
				else
					Do stroka_b
				endif
			Endif
			*!*				if mkttp='06024.55201.00001'  or mkttp='06024.55201.00013'
			*!*						wait window '!!!!!!!'+m.kttp+'   '+mkttp+'   c_te.mar='+str(c_te.mar)+'  te'+str(c_te.mar)
			*!*				ENDIF
			If Inli(c_te.mar,212,228,341,428,341,1142,433,1024,1045,1046,1109,1428,1528,1617,1628) ;
					or Inli(c_te.mar,4028,4042,4141,4241,6022,8043,9128,9142,9153,9206,9238,9242,9247,9248,9249)
				soder = ''
				If c_te.mar = 212 And c_te.ntp=1
					soder = 'Точить деталь согласно чертежа'
				Endif
				*!*						if c_te.mar = 213 and c_te.ntp=1
				*!*							soder = 'Точить деталь согласно программы'
				*!*						endif
				*!*			      IF (c_te.mar = 215 or c_te.mar = 604)  and C_TE.NTP=1
				*!*			      	soder = 'Обработать поверхности детали согласно прoграммы'
				*!*		   	   ENDIF
				If c_te.mar = 223 And c_te.ntp=1
					soder = 'Накатать резьбу согласно чертежа'
				Endif
				If Inlist(c_te.mar, 228,628,1428,1528,1628,4028,9128) And m.us1=0 And m.us2=0 And m.us3=0 And m.us4=0 And m.us5=0 And m.us6=0 And m.us7=0 And m.us8=0
					*!*		      		wait window 'Изготовить деталь согласно чертежа'
					soder = 'Изготовить деталь согласно чертежа'
				Endif
				If Inlist(c_te.mar, 341, 1142, 4042, 9142, 9242)
					soder = 'Упаковать изделие в соответствии с требованиями чертежа'
				Endif
				If c_te.mar = 428
					soder = 'Снять облой'
				Endif
				If c_te.mar = 433
					soder = 'Прессовать согласно чертежа'
				Endif
				If c_te.mar = 1024
					soder = 'Гравировать согласно чертежа'
				Endif
				If c_te.mar = 1045
					soder = 'Изготовить деталь методом трафаретной печати'
				Endif
				If c_te.mar = 1046
					soder = 'Отрезать заготовку в размер чертежа'
				Endif
				If c_te.mar = 1109
					soder = 'Пескоструить деталь(узел), выполняя требования чертежа'
				Endif
				If Inlist(c_te.mar,  1440, 1540, 1640, 4141, 4240, 4241, 4440, 9140, 9240)
					soder = 'Собрать узел в соответствии с требованиями чертежа'
				Endif
				If c_te.mar = 1617
					soder = 'Промыть деталь'
				Endif
				If c_te.mar = 4340
					soder = 'Поизвести работы по предпродажной подготовке'
				Endif
				If c_te.mar = 6022
					soder = 'Обработать деталь электоэрозионным способом'
				Endif
				If c_te.mar = 8043
					soder = 'Изготовить тару согласно чертежа'
				Endif
				If c_te.mar = 9153 And c_te.us1 = 0
					soder = 'Изготовить деталь согласно чертежа'
				Endif
				If c_te.mar = 9206
					soder = 'Вырезать заготовку на виброножницах согласно чертежа'
				Endif
				If c_te.mar = 9228 And c_te.us1 = 0
					soder = 'Изготовить деталь согласно чертежа'
				Endif
				If c_te.mar = 9238
					soder = 'Ковать заготовку согласно чертежа'
				Endif
				If c_te.mar = 9247
					soder = 'Пошить изделие согласно чертежа'
				Endif
				If c_te.mar = 9248
					soder = 'Изготовить тару согласно чертежа'
				Endif
				If c_te.mar = 9249
					soder = 'Размагнитить изделие в соответствии с типовым техпроцессом'
				Endif
				Do stroka_o
				soder = ''
			Else
				If Left(c_te.kttp,11)='06024.01271'
					Do galwan
				Endif
				If c_te.kttp			= '06024.50141.00001'
					Do f_tok_vint
				Endif
				If c_te.kttp			= '06024.50141.00003'
					Do f_freza
				Endif
				If c_te.kttp			= '06024.50141.00004'
					Do f_k_s
				Endif
				If c_te.kttp			= '06024.50141.00005'
					Do f_p_s
				Endif
				If c_te.kttp 			= '06024.50141.00006'
					Do f_o_s
				Endif
				If c_te.kttp 			= '06024.50141.00007'
					Do f_k_r
				Endif
				If c_te.kttp			= '06024.50141.00008'
					Do f_koord_slif
				Endif
				If c_te.kttp			= '06024.50141.00009'
					Do f_swerl
				Endif
				If c_te.kttp			= '06024.50141.00019'
					Do f_prof_slif
				Endif
				If c_te.kttp			= '06024.50141.00024'
					Do f_w_s
				Endif

				If Inlist(c_te.kttp, '06024.50141.00025', '06024.50141.00026', '06024.50141.00027')
					Do f_z_f
				Endif
				If c_te.kttp 			= '06024.50141.00033'
					Do f_dolb
				Endif

				If Left(c_te.kttp,11)	= '06024.55001'
					Do Trans
				Endif

				If c_te.kttp			= '06024.55201.00001'
					Do slesar
				Endif
				If c_te.kttp			= '06024.55201.00002'
					Do valz
				Endif
				If Inlist(c_te.kttp,'06024.55201.00010','06024.55201.00011','06024.55201.00012', ;
						'06024.55201.00014','06024.55201.00015','06024.55201.00016','06024.55201.00017','06024.55201.00020')
					Do slesar_pr
				ENDIF
				
				If c_te.kttp='06024.55201.00013'
					Do GALTOWKA
				ENDIF
				
				If Left(c_te.kttp,11)='06024.55241'
					Do zagot
				Endif
				If Left(c_te.kttp,11)='06024.55250'
					Do Term
				Endif
				If Left(c_te.kttp,11)='06024.55265'
					Do shtamp
				Endif
				If Left(c_te.kttp,11)='06024.55273'
					Do okraska
				Endif
				If c_te.kttp			= '06024.55290.00011'
					Do swarka_kont
				Endif
				If Inlist(c_te.kttp,'06024.55290.00010','06024.55290.00014','06024.55290.00012')
					Do swarka
				Endif
				If c_te.kttp			= '06024.55278.00001'
					Do kontrol
				Endif
				If c_te.kttp			= '06024.55288.00018'
					Do sborka
				Endif


			Endif
			Sele c_te
			Skip
		Enddo
	Endif
	Use In c_te
	*!*		wait window 'c_kt.poznd='+c_kt.poznd +'  o[ind]='+str(o[ind])+'   ind='+str(ind)
	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*						Select Dist     poznd,nto,osn From te Where poznd=c_kt.poznd  and nto=o[ind] into Curs c_te
		rrsql = SQLExec(hhh,'Select distinct poznd,nto,osn From TE Where rtrim(poznd)=rtrim(?c_kt.poznd) and nto=?o[ind]','C_TE')
		If rrsql = -1
			eodbc('PT prg TE for PRESS Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg TE for PRESS conn')
	Endif
	Scan
		If c_te.osn<>0 And o[ind] <> 15

			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
				rrsql = SQLExec(hhh,'Select kod,im,naim From PRESS Where kod=?c_te.osn','C_KODIO')
				If rrsql = -1
					eodbc('PT prg PRESS Select')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('PT prg PRESS conn')
			Endif
			If Recc()>0
				Scan
					soder_t=Allt(c_kodio.im)+' '+Allt(c_kodio.naim)
					m.buk = 'T'
					m.ss  = soder_t
					Insert Into ptt From Memv
				Endscan
			Endif
			Use In c_kodio
		Endif
	Endscan
	Use In c_te


	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*						Select Dist     poznd,nto,kodi,kttp From te Where  poznd=c_kt.poznd and nto= o[ind] into Curs c_te
		rrsql = SQLExec(hhh,'Select distinct poznd,nto,kodi,kttp From TE Where poznd=?c_kt.poznd and nto=?o[ind]','C_TE')
		If rrsql = -1
			eodbc('PT prg TE stroka T rezi Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg TE stroka T rezi conn')
	Endif
	Scan
		If c_te.kodi<>0
			ikodir=''

			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
				IF INLIST(c_te.kttp,'06024.50141.00001', '06024.50141.00003','06024.50141.00009')
					rrsql = SQLExec(hhh,'Select kodi, im From Izu Where kodi=?c_te.kodi order by im','C_KODI')
				else
					rrsql = SQLExec(hhh,'Select kodi, im From Instr Where kodi=?c_te.kodi order by im','C_KODI')
				endif
				If rrsql = -1
					eodbc('PT prg INSTR stroka T rezi Select')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('PT prg INSTR stroka T rezi conn')
			Endif
			If Recc() > 0
				Scan
					ikodir=im
					soder_t=Allt(ikodir)
					m.buk = 'T'
					m.ss  = soder_t
					Insert Into ptt From Memv
				Endscan
			Endif
			Use In c_kodi
		Endif
	Endscan
	Use In c_te


	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*						Select Dist     poznd,nto,kodim From te Where poznd= c_kt.poznd and nto= o[ind] into Curs c_te
		rrsql = SQLExec(hhh,'Select distinct poznd,nto,kodim From TE Where poznd=?c_kt.poznd and nto=?o[ind]','C_TE')
		If rrsql = -1
			eodbc('PT prg TE stroka T meri Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg TE stroka T merii conn')
	Endif
	Scan
		If c_te.kodim<>0 And o[ind] <> 20
			ikodim=''
			*!*
			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
				rrsql = SQLExec(hhh,'Select kodi,im,pri From INSTR Where kodi=?c_te.kodim and pri=2 order by im','C_IME')
				If rrsql = -1
					eodbc('PT prg INSTR stroka T meri Select')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('PT prg INSTR stroka T meri conn')
			Endif
			If Recc()>0
				Scan
					ikodim=im
					soder_t=Allt(ikodim)
					m.buk = 'T'
					m.ss  = soder_t
					Insert Into ptt From Memv
				Endscan
			Endif
			Use In c_ime
		Endif
	Endscan
	Use In c_te

	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*						Select Dist 	 poznd,nto,kodim1 From te Where poznd= c_kt.poznd and nto= o[ind] into Curs c_te
		rrsql = SQLExec(hhh,'Select distinct poznd,nto,kodim1 From TE Where poznd=?c_kt.poznd and nto=?o[ind]','C_TE')
		If rrsql = -1
			eodbc('PT prg TE stroka T meri1 Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg TE stroka T meri1 conn')
	Endif
	Scan
		If c_te.kodim1<>0 And o[ind] <> 20
			ikodim=''
			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
				rrsql = SQLExec(hhh,'Select kodi,im,pri From INSTR Where kodi=?c_te.kodim1 and pri=2 order by im','C_IME')
				If rrsql = -1
					eodbc('PT prg INSTR stroka T meri1 Select')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('PT prg INSTR stroka T meri1 conn')
			Endif
			If Recc()>0
				Scan
					ikodim=im
					soder_t=Allt(ikodim)
					m.buk = 'T'
					m.ss  = soder_t
					Insert Into ptt From Memv
				Endscan
			Endif
			Use In c_ime
		Endif
	Endscan
	Use In c_te


	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*						Select 	Dist 	 poznd,nto,kodim2 From te Where poznd= c_kt.poznd and nto= o[ind] into Curs c_te
		rrsql = SQLExec(hhh,'Select distinct poznd,nto,kodim2 From TE Where poznd=?c_kt.poznd and nto=?o[ind]','C_TE')
		If rrsql = -1
			eodbc('PT prg TE stroka T meri2 Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg TE stroka T meri2 conn')
	Endif
	Scan
		If c_te.kodim2<>0 And o[ind] <> 20
			ikodim=''
			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
			rrsql = SQLExec(hhh,'Select kodi,im,pri From INSTR Where kodi=?c_te.kodim2 and pri=2 order by im','C_IME')
				If rrsql = -1
					eodbc('PT prg INSTR stroka T meri2 Select')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('PT prg INSTR stroka T meri2 conn')
			Endif
			If Recc()>0
				Scan
					ikodim=im
					soder_t=Allt(ikodim)
					m.buk = 'T'
					m.ss  = soder_t
					Insert Into ptt From Memv
				Endscan
			Endif
			Use In c_ime
		Endif
	Endscan
	Use In c_te

	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*						Select Dist     poznd,nto,kodid From te Where poznd= c_kt.poznd and nto= o[ind] into Curs c_te
		rrsql = SQLExec(hhh,'Select distinct poznd,nto,kodid From TE Where poznd=?c_kt.poznd and nto=?o[ind]','C_TE')
		If rrsql = -1
			eodbc('PT prg TE stroka T dopi Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg TE stroka T dopi conn')
	Endif
	Scan
		If kodid<>0
			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
				rrsql = SQLExec(hhh,'Select kodi,im,pri From INSTR Where kodi=?c_te.kodid and pri=3 order by im','C_KODID')
				If rrsql = -1
					eodbc('PT prg INSTR stroka T dopi Select')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('PT prg INSTR stroka T dopi conn')
			Endif
			If Recc()>0
				Scan
					soder_t=Allt(c_kodid.im)
					m.buk = 'T'
					m.ss  = soder_t
					Insert Into ptt From Memv
				Endscan
			Endif
			Use In c_kodid
		Endif
	Endscan
	Use In c_te

	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*						Select Dist     poznd,nto,kodid1 From te Where poznd= c_kt.poznd and nto= o[ind] into Curs c_te
		rrsql = SQLExec(hhh,'Select distinct poznd,nto,kodid1 From TE Where poznd=?c_kt.poznd and nto=?o[ind]','C_TE')
		If rrsql = -1
			eodbc('PT prg TE stroka T dopi1 Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg TE stroka T dopi1 conn')
	Endif
	Scan
		If c_te.kodid1<>0 And o[ind] <> 20
			ikodim=''
			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
				rrsql = SQLExec(hhh,'Select kodi,im,pri From INSTR Where kodi=?c_te.kodid1 and pri=3 order by im','C_IME')
				If rrsql = -1
					eodbc('PT prg INSTR stroka T dopi1 Select')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('PT prg INSTR stroka T dopi1 conn')
			Endif
			If Recc()>0
				Scan
					ikodim=im
					soder_t=Allt(ikodim)
					m.buk = 'T'
					m.ss  = soder_t
					Insert Into ptt From Memv
				Endscan
			Endif
			Use In c_ime
		Endif
	Endscan
	Use In c_te

	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		*!*						Select Dist     poznd,nto,kodid2 From te Where poznd= c_kt.poznd and nto= o[ind] into Curs c_te
		rrsql = SQLExec(hhh,'Select distinct poznd,nto,kodid2 From TE Where poznd=?c_kt.poznd and nto=?o[ind]','C_TE')
		If rrsql = -1
			eodbc('PT prg TE stroka T dopi2 Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg TE stroka T dopi2 conn')
	Endif
	Scan
		If c_te.kodid2<>0 And o[ind] <> 20
			ikodim=''
			hhh = SQLConnect('sqldb','sa','111')
			If hhh > 0
				rrsql = SQLExec(hhh,'Select kodi,im,pri From INSTR Where kodi=?c_te.kodid2 and pri=3 order by im','C_IME')
				If rrsql = -1
					eodbc('PT prg INSTR stroka T dopi2 Select')
				Endif
				SQLDisconnect(hhh)
			Else
				eodbc('PT prg INSTR stroka T dopi2 conn')
			Endif
			If Recc()>0
				Scan
					ikodim=im
					soder_t=Allt(ikodim)
					m.buk = 'T'
					m.ss  = soder_t
					Insert Into ptt From Memv
				Endscan
			Endif
			Use In c_ime
		Endif
	Endscan
	Use In c_te
	ind=ind+1
Enddo

*!*	SELECT ptt
*!*	brow
Return
***************************************************************************************************
Procedure swarka_kont
Wait Window ' пошла сварка контактная' Nowa
If c_te.kto = 9011
	soder = '1. Установить параметры режима сварки'
	Do stroka_o
	soder = '2. Сварить технологические образцы '
	Do stroka_o
	If !Empty(c_te.osn)
		soder = '3. Установить деталь в приспособление '
		Do stroka_o
	Else
		soder = '3. Выставить детали по разметке '
		Do stroka_o
	Endif
	soder = '4. сварить деталь согласно чертежа выдерживая размеры: '
	kuku = ''

	If !Empty(m.rr1)
		kuku=kuku+'; '
		Do rr1_
		Do toch1_
	Endif
	If !Empty(m.rr2)
		kuku = kuku +'; '
		Do rr2_
		Do toch2_
	Endif
	If !Empty(m.rr3)
		kuku = kuku +'; '
		Do rr3_
		Do toch3_
	Endif

	soder = soder + kuku
	Do stroka_o
	soder = 'Количество точек '+Alltrim(Str(c_te.ip))+', расстояние между точками '+Alltrim(Str(shag,6,2))
	Do stroka_o
	soder = 'Примечание: рабочую поверхность электродов зачищать шлифовальной шкуркой через 100-150 точек '
	Do stroka_o
Endif
*       конец сварки
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
***************************************************************************************************
*********************	П Р О Ф И Л Ь Н А Я   Ш Л И Ф О В К А    ******************************
Procedure f_prof_slif
Wait 'П Р О Ф И Л Ь Н А Я   Ш Л И Ф О В К А ' Window Nowait
If Inlist(70,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	soder =Allt(Str(c_te.ntp))+'. '+' Шлифовать профиль '
	kuku = ''
	If !Empty(m.dbk)
		Do dbk_
		Do tocd1_
	Endif
	If !Empty(m.rr1)
		kuku=kuku+'; '
		Do rr1_
		Do toch1_
	Endif
	If !Empty(m.rr2)
		kuku = kuku +'; '
		Do rr2_
		Do toch2_
	Endif
	If !Empty(m.rr3)
		kuku = kuku +'; '
		Do rr3_
		Do toch3_
	Endif
	kuku = kuku +Iif(c_te.ug#0,'; угол '+Alltrim(Str(c_te.ug,3))+' град','') ;
		+Iif(m.rad#0,'; R='+Alltrim(Str(m.rad,3)),'') ;
		+Iif(c_te.sh<>0,'; Ra='+Allt(Str(c_te.sh,7,3)),'')
	soder = soder + kuku
	Do stroka_o
Endif
Retu
***************************************************************************************************
*********************	К О О Р Д И Н А Т Н А Я   Ш Л И Ф О В К А    ******************************
Procedure f_koord_slif
Wait 'К О О Р Д И Н А Т Н А Я   Ш Л И Ф О В К А' Window Nowait
If Inlist(52,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	soder =Allt(Str(c_te.ntp))+'. '+' Шлифовать сквозные отверствия '
	kuku = ''
	If c_te.dbk#0
		kuku=kuku +'Ф '
		Do dbk_
		Do tocd1_
	Endif
	If !Empty(m.rr1)
		kuku = kuku +'; '
		Do rr1_
		Do toch1_
	Endif
	If !Empty(m.rr2)
		kuku = kuku +'; '
		Do rr2_
		Do toch2_
	Endif
	If !Empty(m.rr3)
		kuku = kuku +'; '
		Do rr3_
		Do toch3_
	Endif
	kuku = kuku +Iif(c_te.ug#0,'; угол '+Alltrim(Str(c_te.ug,3))+' град','') ;
		+Iif(c_te.sh<>0,'; Ra='+Allt(Str(c_te.sh,7,3)),'')
	soder = soder + kuku
	Do stroka_o
Endif
If Inlist(53,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
		or Inlist(54,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
		or Inlist(55,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	soder =Allt(Str(c_te.ntp))+'. '+' Шлифовать сложные поверхности '
	kuku = ''
	If c_te.dbk#0
		Do dbk_
		Do tocd1_
	Endif
	If !Empty(m.rr1)
		kuku = kuku +'; '
		Do rr1_
		Do toch1_
	Endif
	If !Empty(m.rr2)
		kuku = kuku +'; '
		Do rr2_
		Do toch2_
	Endif
	If !Empty(m.rr3)
		kuku = kuku +'; '
		Do rr3_
		Do toch3_
	Endif
	kuku = kuku +Iif(c_te.ug#0,'; угол '+Alltrim(Str(c_te.ug,3))+' град','') ;
		+Iif(m.rad#0,'; R='+Alltrim(Str(m.rad,3)),'') ;
		+Iif(c_te.sh<>0,'; Ra='+Allt(Str(c_te.sh,7,3)),'')

	soder = soder + kuku
	Do stroka_o
Endif
Retu
*********************	К О О Р Д И Н А Т Н О  -  Р А С Т О Ч Н Ы Е  ******************************
Procedure f_k_r
Wait 'К О О Р Д И Н А Т Н О  -  Р А С Т О Ч Н Ы Е' Window Nowait
If Inlist(49,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	soder =Allt(Str(c_te.ntp))+'. '+' Центровать, сверлить, рассверлить, зенкеровать, развернуть отверствия Ф '
	kuku = ''
	If c_te.dbk#0
		Do dbk_
		Do tocd1_
	Endif
	If m.rr1 # 0
		kuku = kuku +'; '
		Do rr1_
		Do toch1_
	Endif
	If m.rr2 # 0
		kuku = kuku +'; '
		Do rr2_
		Do toch2_
	Endif
	If m.rr3#0
		kuku = kuku +'; '
		Do rr3_
		Do toch3_
	Endif
	kuku = kuku +Iif(c_te.ug#0,'; угол '+Alltrim(Str(c_te.ug,3))+' град','') ;
		+Iif(m.rad#0,'; R='+Alltrim(Str(m.rad,3)),'') ;
		+Iif(c_te.sh<>0,'; Ra='+Allt(Str(c_te.sh,7,3)),'')
	soder = soder + kuku
	Do stroka_o
Endif
If Inlist(50,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	soder =Allt(Str(c_te.ntp))+'. '+' Центровать, сверлить, развернуть отверствия D '
	kuku = ''
	If c_te.dbk#0
		Do dbk_
		Do tocd1_
	Endif
	If m.rr1 # 0
		kuku = kuku +'; '
		Do rr1_
		Do toch1_
	Endif
	If m.rr2# 0
		kuku = kuku +'; '
		Do rr2_
		Do toch2_
	Endif
	If m.rr3 # 0
		kuku = kuku +'; '
		Do rr3_
		Do toch3_
	Endif
	kuku = kuku +Iif(c_te.ug#0,'; угол '+Alltrim(Str(c_te.ug,3))+' град','') ;
		+Iif(m.rad#0,'; R='+Alltrim(Str(m.rad,3)),'') ;
		+Iif(c_te.sh<>0,'; Ra='+Allt(Str(c_te.sh,7,3)),'')

	soder = soder + kuku
	Do stroka_o
Endif
If Inlist(51,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	soder =Allt(Str(c_te.ntp))+'. '+' Расточить выточки в отверствиях D '
	kuku = ''
	If c_te.dbk#0
		Do dbk_
		Do tocd1_
	Endif
	If m.rr1 # 0
		kuku = kuku +'; '
		Do rr1_
		Do toch1_
	Endif
	If m.rr2 # 0
		kuku = kuku +'; '
		Do rr2_
		Do toch2_
	Endif
	If m.rr3 # 0
		kuku = kuku +'; '
		Do rr3_
		Do toch3_
	Endif
	kuku = kuku +Iif(c_te.ug#0,'; угол '+Alltrim(Str(c_te.ug,3))+' град','') ;
		+Iif(m.rad#0,'; R='+Alltrim(Str(m.rad,3)),'') ;
		+Iif(c_te.sh<>0,'; Ra='+Allt(Str(c_te.sh,7,3)),'')

	soder = soder + kuku
	Do stroka_o
Endif
If Inlist(11,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	soder =Allt(Str(c_te.ntp))+'. '+' Разметитьпараллельные прямые и окружности '
	kuku = ''
	If c_te.dbk#0
		Do dbk_
		Do tocd1_
	Endif
	If m.rr1 # 0
		kuku = kuku +'; '
		Do rr1_
		Do toch1_
	Endif
	If m.rr2 # 0
		kuku = kuku +'; '
		Do rr2_
		Do toch2_
	Endif
	If m.rr3 # 0
		kuku = kuku +'; '
		Do rr3_
		Do toch3_
		kuku = kuku +Iif(m.rad#0,'; R='+Alltrim(Str(m.rad,3)),'')
	Endif
	soder = soder + kuku
	Do stroka_o
Endif
If Inlist(12,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	soder =Allt(Str(c_te.ntp))+'. '+' Разметить прямые, расположенные под  углом '
	kuku = ''
	If c_te.dbk#0
		Do dbk_
		Do tocd1_
	Endif
	If m.rr1 # 0
		kuku = kuku +'; '
		Do rr1_
		Do toch1_
	Endif
	If m.rr2 # 0
		kuku = kuku +'; '
		Do rr2_
		Do toch2_
	Endif
	If m.rr3 # 0
		kuku = kuku +'; '
		Do rr3_
		Do toch3_
	Endif
	kuku = kuku +Iif(c_te.ug#0,'; угол '+Alltrim(Str(c_te.ug,3))+' град','')

	soder = soder + kuku
	Do stroka_o
Endif
If Inlist(13,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	soder =Allt(Str(c_te.ntp))+'. '+' Разметить криволинейный контур '
	Do stroka_o
Endif
Retu
***************************************************************************************************
***************************************************************************************************
*********************	О П Т И К О - Ш Л И Ф О В А Л Ь Н Ы Е  ************************************
Procedure f_o_s
Wait 'О П Т И К О - Ш Л И Ф О В А Л Ь Н Ы Е' Window Nowait

soder =Allt(Str(c_te.ntp))+'. '+' Шлифовать '+Alltrim(Str(c_te.ip,2))+' поверхности, выдерживая размеры:'
kuku = ''
If c_te.dbk#0
	kuku=kuku+'Ф'
	Do dbk_
	Do tocd1_
Endif
If m.rr1 # 0
	kuku = kuku +'; '
	Do rr1_
	Do toch1_
Endif
If m.rr2 # 0
	kuku = kuku +'; '
	Do rr2_
	Do toch2_
Endif
If m.rr3 # 0
	kuku = kuku +'; '
	Do rr3_
	Do toch3_
Endif
kuku = kuku +Iif(c_te.ug#0,'; угол '+Alltrim(Str(c_te.ug,3))+' град','') ;
	+Iif(m.rad#0,'; R='+Alltrim(Str(m.rad,3)),'') ;
	+Iif(c_te.sh<>0,'; Ra='+Allt(Str(c_te.sh,7,3)),'')

soder = soder + kuku
Do stroka_o
Retu
***************************************************************************************************
*********************	Т Е Р М И Ч К А ***********************************************************
Procedure Term
*!*	wait window 'c_te.kto='+str(c_te.kto)
If Inlist(c_te.kto, 5010, 5050, 5060, 5000, 5043, 5044)

	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		*!*					  Select * From dosp Where vid=7 And kod = c_te.kto Into Cursor c_7
		rrsql = SQLExec(hh,'select * from DOSP where vid=7 and kod =?c_te.kto','C_7')
		If rrsql = -1
			eodbc('PT PRG DOSP7 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP7 conn')
	Endif

	If Reccount() > 0
		soder = Alltrim(c_7.sim)
		soder = soder + ' до твердости HRC='+Alltrim(Str(c_te.tvr,4))
		soder = soder + Iif(c_te.glub>0, ' на глубину '+Alltrim(Str(c_te.glub,5,1)),'')
		Do stroka_o
	Endif
	Use In c_7
	*!*		SELECT kornd,nrmd, poznd,d_u,KODM FROM KT WHERE ;
	*!*					poznd =c_te.poznd ;
	*!*					AND d_u=5 ;
	*!*					ORDER BY kornd ;
	*!*					INTO CURSOR c_kt_kornd
	*!*		soder = ''
	*!*		SCAN
	*!*			SELECT * FROM mater WHERE kodm = c_kt_kornd.kodm INTO CURSOR c_mat
	*!*	*!*			WAIT WINDOW 'MATER'
	*!*	*!*			brow
	*!*			IF RECCOUNT() > 0
	*!*				ma = ALLTRIM(c_mat.naim)
	*!*			ELSE
	*!*				ma = ''
	*!*			ENDIF
	*!*			soder = ma+ ' ' + ;
	*!*					ALLTRIM(c_MAT.ei)+ ' ' + ;
	*!*					ALLTRIM(STR(c_kt_kornd.nrmd,12,5))
	*!*			m.buk = 'К'
	*!*			m.ss  = soder
	*!*			INSERT INTO ptt FROM memv
	*!*			soder = ''
	*!*			USE IN c_mat
	*!*		ENDSCAN
	*!*		USE IN c_kt_kornd
Endif
Return

***************************************************************************************************
***************	К О Н Е Ц   Т Е Р М И Ч К А *****************************************************
***************************************************************************************************
***************	Г А Л Ь В А Н И К А *************************************************************
Procedure galwan
Wait ' Г А Л Ь В А Н И К А  ' Window Nowait
soder = ''
If Inlist(c_te.kto, 7100, 7135, 7141, 7172, 7174)
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		*!*					  Select * From dosp Where vid=7 And kod = c_te.kto Into Cursor c_7
		rrsql = SQLExec(hh,'select * from DOSP where vid=7 and kod =?c_te.kto','C_7')
		If rrsql = -1
			eodbc('PT PRG DOSP7 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP7 conn')
	Endif
	If Reccount() > 0
		soder = Alltrim(c_7.sim)
		soder = soder + ' площадью '+Alltrim(Str(c_te.sp,8,4))+' кв.м'
		soder = soder + ', Покрытие '+Alltrim(m.gpokr)
		soder = soder + Iif(c_te.glub>0, ' толщиной '+Alltrim(Str(c_te.glub)),'')
		Do stroka_o
	Endif
	Use In c_7
Endif
Return
***********************************КОНЕЦ ГАЛЬВАНИКИ************************************************
***************************************************************************************************
*************************************** Ш Т А М П О В К А  ****************************************
Procedure shtamp
Wait Window 'ШТАМПОВКА' Nowait

hh = SQLConnect('sqldb','sa','111')
If hh > 0
	*!*					  Select * From ktu Where ttp=Left(c_te.kttp,11) And kof =1 Order By pri Into Cursor c_ktu
	rrsql = SQLExec(hh,'select * from KTU where left(ttp,11)=Left(?c_te.kttp,11) And kof =1 Order By pri','C_KTU')
	If rrsql = -1
		eodbc('PT PRG KTU Select')
	Endif
	SQLDisconnect(hh)
Else
	eodbc('PT PRG KTU conn')
Endif
If Reccount() > 0
	Scan
		If Inlist(c_ktu.npp,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
			soder = ALLTRIM(c_ktu.dop)
			m.buk = 'О'
			m.ss  = soder
			*!*	Insert Into ptt From Memv
			If c_ktu.pri=7
				soder = soder +' выдерживая размеры: '
				kuku = ''
				If m.rr1 # 0
					kuku = kuku +'; '
					Do rr1_
					Do toch1_
					soder = soder + kuku
				Endif
				If m.rr2 # 0
					kuku = ''
					Do rr2_
					Do toch2_
					soder = soder + kuku
				Endif
				m.buk = 'О'
				m.ss  = soder
				Insert Into ptt From Memv
			Endif
		Endif
	Endscan
Endif
Use In c_ktu

Return
***************************************************************************************************
**************************************** С Л Е С А Р К А  *****************************************
Procedure slesar
Wait 'С Л Е С А Р К А  ' Window Nowait
*!*	Wait Window m.kttp+' us1='+Str(m.us1,3)+' us2='+Str(m.us2,3)+' us3='+Str(m.us3,3)

hh = SQLConnect('sqldb','sa','111')
If hh > 0
	rrsql = SQLExec(hh,'select * from KTU where left(ttp,11)=Left(?c_te.kttp,11) And (kof=11 or kof=12 or kof=13 or kof=14 or kof=21) Order By pri','C_KTU')
	If rrsql = -1
		eodbc('PT PRG KTU Select')
	Endif
	SQLDisconnect(hh)
Else
	eodbc('PT PRG KTU conn')
Endif
If Reccount() > 0
	Scan
		If Inlist(c_ktu.npp,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
			*!*				Brow
			soder = Alltrim(c_ktu.dop)
			If Inli(c_ktu.npp,12,13,14,15,16,17,18,19)
				soder = soder + ' '+Allt(Str(c_te.ip))+'  отв. '+Iif(m.d<>0,' Ф','')
				kuku = ''
				Do d_
				Do tocd1_
				soder = soder + kuku
			Endif
			If Inli(c_ktu.npp,20,21,22,23)
				soder = soder + ' '+Allt(Str(c_te.ip))+' отв. M'
				kuku = ''
				Do d_
				Do tocd1_
				soder = soder + kuku
			Endif
			m.buk = 'О'
			m.ss  = soder
			Insert Into ptt From Memv
			*!*				WAIT WINDOW 'soder='+soder
		Endif
	Endscan
*!*		If Inlist(90,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*			m.buk = 'О'
*!*			m.ss  = 'Зачистить заготовку от шлака'
*!*			Insert Into ptt From Memv
*!*		Endif
*!*		If Inlist(91,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*				or ;
*!*				inlist(92,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*			m.buk = 'О'
*!*			m.ss  = 'Править заготовку вручную по плоскости'
*!*			Insert Into ptt From Memv
*!*		Endif
*!*		If Inlist(93,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*			m.buk = 'О'
*!*			m.ss  = 'Править полосу по плоскости и на ребро вручную'
*!*			Insert Into ptt From Memv
*!*		Endif
*!*		If Inlist(94,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*			m.buk = 'О'
*!*			m.ss  = 'Править фасонный прокат на правильном прессе'
*!*			Insert Into ptt From Memv
*!*		Endif
*!*		If Inlist(95,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*			m.buk = 'О'
*!*			m.ss  = 'Править фасонный прокат вручную'
*!*			Insert Into ptt From Memv
*!*		Endif
*!*		If Inlist(96,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*			m.buk = 'О'
*!*			m.ss  = 'Править листовую заготовку по плоскости на прессе'
*!*			Insert Into ptt From Memv
*!*		Endif
*!*		If Inlist(97,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*			m.buk = 'О'
*!*			m.ss  = 'Зачистить кромки заготовки от грата вручную'
*!*			Insert Into ptt From Memv
*!*		Endif


Endif
Use In c_ktu
Retu
***************************************************************************************************
**************************************** В А Л Ь Ц О В К А*****************************************
Procedure valz
Wait 'В А Л Ь Ц О В К А  ' Window Nowait
hh = SQLConnect('sqldb','sa','111')
If hh > 0
	rrsql = SQLExec(hh,'select * from KTU where left(ttp,11)=Left(?c_te.kttp,11) And kof=2 Order By pri','C_KTU')
	If rrsql = -1
		eodbc('PT PRG KTU Select')
	Endif
	SQLDisconnect(hh)
Else
	eodbc('PT PRG KTU conn')
Endif
If Reccount() > 0
	Scan
		If Inlist(npp,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
			soder = ALLTRIM(c_ktu.dop)
			m.buk = 'О'
			m.ss  = soder
*!*				If !Empty(soder)
*!*					Insert Into ptt From Memv
*!*				Endif
		Endif
	Endscan
Endif
Use In c_ktu
soder = soder+' выдерживая размеры: '
kuku = ''
If m.rr1 # 0
	kuku = kuku +'; '
	Do rr1_
	Do toch1_
	soder = soder + kuku
Endif
Do stroka_o
Return
***************************************************************************************************
**************************************** С Л Е С А Р К А  П Р О Ч А Я *****************************
Procedure slesar_pr
Wait 'С Л Е С А Р К А  П Р О Ч А Я ' Window  Nowait

hh = SQLConnect('sqldb','sa','111')
If hh > 0
	rrsql = SQLExec(hh,'select * from KTU where left(ttp,11)=Left(?c_te.kttp,11) And (kof=11 or kof=12 or kof=13 or kof=14 or kof=19) Order By pri','C_KTU')
	If rrsql = -1
		eodbc('PT PRG KTU Select')
	Endif
	SQLDisconnect(hh)
Else
	eodbc('PT PRG KTU conn')
ENDIF
*!*	brow
soder = Alltrim(c_ktu.dop)
m.buk = 'О'
m.ss  = soder
Insert Into ptt From Memv
*!*	If Reccount() > 0
*!*	*!*		Scan
*!*			brow
*!*			If Inlist(c_ktu.npp,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*				soder = Alltrim(c_ktu.dop)
*!*				If Inli(c_ktu.npp,12,13,14,15,16,17,18,19)
*!*					soder = soder + ' '+Allt(Str(c_te.ip))+'  отв. '+Iif(m.d<>0,' Ф','')
*!*					kuku = ''
*!*					Do d_
*!*					Do tocd1_
*!*					soder = soder + kuku
*!*				Endif
*!*				If Inli(c_ktu.npp,20,21,22,23)
*!*					soder = soder + ' '+Allt(Str(c_te.ip))+' отв. M'
*!*					kuku = ''
*!*					Do d_
*!*					Do tocd1_
*!*					soder = soder + kuku
*!*				Endif
*!*				m.buk = 'О'
*!*				m.ss  = soder
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			If Inlist(90,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*				m.buk = 'О'
*!*				m.ss  = 'Зачистить заготовку от шлака'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			If Inlist(91,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*					or ;
*!*					inlist(92,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*				m.buk = 'О'
*!*				m.ss  = 'Править заготовку вручную по плоскости'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			If Inlist(93,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*				m.buk = 'О'
*!*				m.ss  = 'Править полосу по плоскости и на ребро вручную'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			If Inlist(94,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*				m.buk = 'О'
*!*				m.ss  = 'Править фасонный прокат на правильном прессе'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			If Inlist(95,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*				m.buk = 'О'
*!*				m.ss  = 'Править фасонный прокат вручную'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			If Inlist(96,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*				m.buk = 'О'
*!*				m.ss  = 'Править листовую заготовку по плоскости на прессе'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			If Inlist(97,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*				m.buk = 'О'
*!*				m.ss  = 'Зачистить кромки заготовки от грата вручную'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*	*!*		Endscan

*!*	Endif
Use In c_ktu
*!*	If Inlist(80,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(81,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(82,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Промыть деталь(узел) от загрязнений в ванне'
*!*		Insert Into ptt From Memv
*!*	Endif

*!*	If Inlist(83,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Установить маркировальные бирки пайкой'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(84,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Установить маркировальные бирки без пайки'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(87,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Галтовать детали сухим способом до полного удаления заусенок, ржавчины,наплывов,сколов,грата, брызг шлака'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(90,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Зачистить заготовку от шлака'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(91,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(92,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Править заготовку вручную по плоскости'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(93,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Править полосу по плоскости и на ребро вручную'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(94,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Править фасонный прокат на правильном прессе'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(95,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Править фасонный прокат вручную'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(96,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Править листовую заготовку по плоскости на прессе'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(97,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Зачистить кромки заготовки от грата вручную'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(101,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(106,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(107,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(108,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Раскроить материал, выдерживая размеры '+Alltrim(Str(c_te.rozma,6,1))+'x'+Alltrim(Str(c_te.rozmb,6,1))
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(102,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Править заготовку вручную по плоскости и на ребро'
*!*		Insert Into ptt From Memv
*!*	Endif

*!*	If Inlist(109,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(110,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Крацевать поверхность(и) детали, выдерживая шероховатoсть Ra='+Alltrim(Str(c_te.sh,7,3))
*!*		Insert Into ptt From Memv
*!*	Endif

*!*	If Inlist(111,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(112,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(138,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(139,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Уложить упаковочные докуметнты в пакет(тару)'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(123,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(124,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(125,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Шлифовать поверхность(и) детали, выдерживая шероховатoсть Ra='+Alltrim(Str(c_te.sh,7,3))
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(129,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(130,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(131,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Матировать поверхность(и) детали, выдерживая шероховатoсть Ra='+Alltrim(Str(c_te.sh,7,3))
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(134,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(135,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(136,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(137,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Глянцевать поверхность(и) детали, выдерживая шероховатoсть Ra='+Alltrim(Str(c_te.sh,7,3))
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(141,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Комплектовать детали для упаковки'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(142,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or Inlist(143,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Оббить упаковочные ящики досками'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(144,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Галтовать детали мокрым способом до полного удаления заусенок, ржавчины,наплывов, сколов,грата,брызг шлака'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(145,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(146,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or ;
*!*			inlist(147,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Полировать поверхность(и) детали, выдерживая шероховатoсть Ra='+Alltrim(Str(c_te.sh,7,3))
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(148,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Зачистить фасонную заготовку от шлака'
*!*		Insert Into ptt From Memv
*!*	Endif
*!*	If Inlist(150,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Галтовать детали со стружкой до полного удаления заусенок, ржавчины, сколов, грата'
*!*		Insert Into ptt From Memv
*!*	Endif

*!*	If Inlist(201,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		Or Inlist(202,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or Inlist(203,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or Inlist(204,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or Inlist(205,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or Inlist(206,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or Inlist(207,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or Inlist(208,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8) ;
*!*			or Inlist(209,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
*!*		m.buk = 'О'
*!*		m.ss  = 'Изготовить прокладку согласно чертежа'
*!*		Insert Into ptt From Memv
*!*	Endif
Retu
************************************  КОНЕЦ С Л Е С А Р К А  П Р О Ч А Я **************************
***************************************************************************************************



**************************************** Г А Л Т О В К А *****************************
Procedure GALTOWKA
Wait 'Г А Л Т О В К А ' Window  Nowait

If Inlist(87,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	m.buk = 'О'
	m.ss  = 'Галтовать детали сухим способом до полного удаления заусенок, ржавчины,наплывов,сколов,грата, брызг шлака'
	Insert Into ptt From Memv
Endif
If Inlist(144,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	m.buk = 'О'
	m.ss  = 'Галтовать детали мокрым способом до полного удаления заусенок, ржавчины,наплывов, сколов,грата,брызг шлака'
	Insert Into ptt From Memv
Endif


If Inlist(150,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
	m.buk = 'О'
	m.ss  = 'Галтовать детали со стружкой до полного удаления заусенок, ржавчины, сколов, грата'
	Insert Into ptt From Memv
Endif


Retu
************************************  КОНЕЦ С Л Е С А Р К А  П Р О Ч А Я **************************


**************************************** О К Р А С К А  *******************************************
Procedure okraska
Wait 'О К Р А С К А  ' Window  Nowait
If Inlist(c_te.kto,7311,7328,7360,7361,7362,7363,7378,7386,7410)
	*!*		WAIT WINDOW ALLTRIM(c_te.kttp)

	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		*!*					  Select * From dosp Where vid=9 And sim=c_te.kttp Into Cursor c_9
		rrsql = SQLExec(hh,'select * from DOSP where vid=9 and rtrim(sim) =rtrim(?c_te.kttp)','C_9')
		If rrsql = -1
			eodbc('PT PRG DOSP 9 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP 9 conn')
	Endif
	If Reccount()>0
		im9=Alltrim(im)
	Else
		im9=''
	Endif
	Use In c_9
	soder = 'Oкрасить деталь(узел) краской '+' '+im9+', площадью '+Alltrim(Str(c_te.sp,8,4))+' кв.м'
	m.buk = 'О'
	m.ss  = soder
	Insert Into ptt From Memv
Endif
Retu

*********************************** К О Н Е Ц  О К Р А С К А  *************************************
***************************************************************************************************
********************************** З А Г О Т О В К А **********************************************
Procedure zagot
Wait 'З А Г О Т О В К А  ' Window Nowait
soder = ' '
If c_te.kto =7525
	soder='Вырезать заготовку согласно управляющей программы № '+ Alltrim(Str(c_te.kko))
	Do stroka_o
	soder_t = 'Кран-балка с электротельфером, рукавицы тип А ГОСТ 12.4.010-075'
	m.buk = 'T'
	m.ss  = soder_t
	Insert Into ptt From Memv
Else
	If c_te.nto = 5

		If c_kt.kolz>1
			soder= 'Разметить групповую заготовку на '+Alltrim(Str(c_kt.kolz))+' деталей, выдерживая размеры '+ ;
				alltrim(Str(c_kt.rozma,6,1))+ ;
				iif(c_kt.tocha<>0,'-'+Alltrim(Str(c_kt.tocha,4,2)),'')+ ;
				iif(c_kt.rozmb<>0,'x'+Alltrim(Str(c_kt.rozmb,6,1))+ ;
				iif(c_kt.tochb<>0,'-'+Alltrim(Str(c_kt.tochb,4,2)),''),'')
			Do stroka_o
		Else
			soder= 'Разметить заготовку, выдерживая размеры '+Alltrim(Str(c_kt.rozma,6,1))+ ;
				iif(c_kt.tocha<>0,'-'+Alltrim(Str(c_kt.tocha,4,2)),'')+ ;
				iif(c_kt.rozmb<>0,'x'+Alltrim(Str(c_kt.rozmb,6,1))+ ;
				iif(c_kt.tochb<>0,' - '+Alltrim(Str(c_kt.tochb,4,2)),''),'')
			Do stroka_o
		Endif
		soder_t = 'Кран подвесной КП-16.5,рукавицы тип А ГОСТ 12.4.010-075'
		m.buk = 'T'
		m.ss  = soder_t
		Insert Into ptt From Memv
	Endif

	If c_te.nto = 10
		If	Inlist(30,c_te.us1,c_te.us2,c_te.us3,c_te.us4,c_te.us5,c_te.us6,c_te.us7,c_te.us8)
			soder= 'Отрезать заготовку с вырезкой углов (пазов) согласно чертежа, выдерживая размеры '+ ;
				alltrim(Str(c_kt.rozma,6,1))+ ;
				iif(c_kt.tocha<>0,'-'+Alltrim(Str(c_kt.tocha,4,2)),'')+ ;
				iif(c_kt.rozmb<>0,'x'+Alltrim(Str(c_kt.rozmb,6,1))+ ;
				iif(c_kt.tochb<>0,'-'+Alltrim(Str(c_kt.tochb,4,2)),''),'')
			Do stroka_o
		Else
			If c_kt.kolz>1
				soder= 'Отрезать групповую заготовку на '+Alltrim(Str(c_kt.kolz))+' деталей, выдерживая размеры '+ ;
					alltrim(Str(c_kt.rozma,6,1))+ ;
					iif(c_kt.tocha<>0,'-'+Alltrim(Str(c_kt.tocha,4,2)),'')+ ;
					iif(c_kt.rozmb<>0,'x'+Alltrim(Str(c_kt.rozmb,6,1))+ ;
					iif(c_kt.tochb<>0,'-'+Alltrim(Str(c_kt.tochb,4,2)),''),'')
				Do stroka_o
			Else
				soder= 'Отрезать заготовку, выдерживая размеры '+Alltrim(Str(c_kt.rozma,6,1))+ ;
					iif(c_kt.tocha<>0,'-'+Alltrim(Str(c_kt.tocha,4,2)),'')+ ;
					iif(c_kt.rozmb<>0,'x'+Alltrim(Str(c_kt.rozmb,6,1))+ ;
					iif(c_kt.tochb<>0,'-'+Alltrim(Str(c_kt.tochb,4,2)),''),'')
				Do stroka_o
			Endif
		Endif
		*!*			soder_t = 'Рулетка ГОСТ 7502; штангенциркуль 250 ГОСТ 166'
		*!*			m.buk = 'T'
		*!*			m.ss  = soder_t
		*!*			insert into ptt from memv
		soder_t=''
		If c_te.mar <> 110
			soder_t = 'Кран-подвесной КП-16.5, очки защитные ЗП-80-БСЧ ГОСТ 12.4.13085,рукавицы тип А ГОСТ 12.4.010-075'
		Else
			soder_t = soder_t + ' СОЖ ЭМПО'
		Endif
		m.buk = 'T'
		m.ss = soder_t

		Insert Into ptt From Memv
	Endif
	If c_te.nto = 15
		soder= 'Контролировать сортамент ,размеры заготовки '+ ;
			alltrim(Str(c_kt.rozma,6,1))+ ;
			iif(c_kt.tocha<>0,'-'+Alltrim(Str(c_kt.tocha,4,2)),'')+ ;
			iif(c_kt.rozmb<>0,'x'+Alltrim(Str(c_kt.rozmb,6,1))+ ;
			iif(c_kt.tochb<>0,'-'+Alltrim(Str(c_kt.tochb,4,2)),''),'') + ;
			', контроль 5% от партии'
		Do stroka_o
		*!*			soder_t = 'Рулетка ГОСТ 7502; штангенциркуль 250 ГОСТ 166'
		*!*			m.buk = 'T'
		*!*			m.ss  = soder_t
		*!*			insert into ptt from memv
	Endif
	If c_te.nto = 20
		soder= 'Переместить заготовки по технологическому маршруту '
		Do stroka_o
		soder_t = 'Погрузчик,тара заводская, рукавицы тип А ГОСТ 12.4.010-075'
		m.buk = 'T'
		m.ss  = soder_t
		Insert Into ptt From Memv
	Endif
Endif

Return
*********************************** КОНЕЦ З А Г О Т О В К А *************************************
***************************************************************************************************
********************************** Т О К А Р Н Ы Е ************************************************
Procedure f_tok_vint
Wait ' Т О К А Р Н Ы Е  ' Window  Nowait
*!*	wait window 'kko='+str(m.kko)
soder = ''
If m.ntp=1
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from DOSP where vid=31 and kod=?c_te.kku And us=?c_te.vid','C_dosp31')
		If rrsql = -1
			eodbc('PT PRG DOSP 31 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP 31 conn')
	Endif
	If Recc()>0
		soder=Alltrim(im)+' '+Alltrim(sim)
		Do stroka_o
	Endif
	Use In c_dosp31
Endif


If c_te.mar = 213 And c_te.ntp=1
	soder = 'Точить деталь согласно программы'
	Do stroka_o
Endif
soder = ''
ss=''
If m.kko=0 Or m.kko=12 And m.dbk=0 Or m.kko=6 And m.dbk=0 &&AND EMPTY(m.toch1)
Else
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		*!*					  Select * From pt Where vid=c_te.vid  And kko= m.kko Into Curs c_pt
		rrsql = SQLExec(hh,'select * from PT where vid=?c_te.vid and kko=?m.kko','C_pt')
		If rrsql = -1
			eodbc('PT PRG pt-file Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG pt-file conn')
	Endif
	If Reccount() > 0
		soder = Allt(im)
	Endif
	Use In c_pt
Endif
soder = Allt(Str(M.ntp))+'. '+soder
*!*	If ss = ''
*!*	Else
*!*		
*!*	Endif
If m.kko=77 OR m.kko=78
	Do stroka_o
else
	If m.kko = 1
		*!*		soder = ' Ф '+allt(str(m.d,6,2))+'  до Ф '+allt(str(m.dbk,6,2))+' глубиной '+ALLTRIM(STR(m.ds,6,2))
		*!*		do stroka_o
		soder=soder+' выдерживая размеры: Ф'
		kuku=''
		Do dbk_
		Do tocd1_
		If m.ds# 0
			kuku = kuku + '; l='
			Do ds_
		Endif
		Do sh_
		kuku = kuku +Iif(m.ug>0,'; У='+Alltrim(Str(m.ug))+' град','') ;
			+Iif(m.rad>0,'; r='+Alltrim(Str(m.rad,5,1)),'')
		soder = soder + kuku
		soder=soder+Iif(!Empty(c_te.us),' с учетом припуска '+Alltrim(Str(c_te.us,4,2))+' под последующую обработку','')
		Do stroka_o
	Endif
	If Inlist(m.kko,2,3)
		kuku=''
		soder=soder+' '+Alltrim(Str(m.ds,6,1))
		Do toch1_
		soder=soder+kuku
		Do stroka_o
	Endif

	If m.kko = 4 Or m.kko = 9
		*!*		soder = ' Ф '+allt(str(m.d,6,2))+'  до Ф '+allt(str(m.dbk,6,2))+' на длину '+ALLTRIM(STR(m.ds,6,2))
		*!*		do stroka_o
		soder=soder+' выдерживая размеры: Ф'
		kuku=''
		Do dbk_
		Do tocd1_
		If !Empty(m.ds)
			kuku = kuku + ', l='
			Do ds_
			Do toch1_
		Endif
		Do sh_
		kuku = kuku +Iif(m.ug>0,'; У='+Alltrim(Str(m.ug))+' град','') ;
			+Iif(m.rad>0,'; r='+Alltrim(Str(m.rad,5,1)),'')
		soder = soder + kuku
		soder=soder+Iif(!Empty(c_te.us),' с учетом припуска '+Alltrim(Str(c_te.us,4,2))+' под последующую обработку','')
		Do stroka_o
	Endif
	If m.kko=6
		If m.dbk=0
			If !Empty(m.toch1)
				soder=soder+' выдерживая размеры: Ф'
				kuku=''
				Do dbk_
				Do toch1_
				Do sh_
				soder = soder + kuku
				soder=soder+Iif(!Empty(c_te.us),' с учетом припуска '+Alltrim(Str(c_te.us,4,2))+' под последующую обработку','')
				Do stroka_o
			Else
				soder=soder+'Подрезать торец как чисто'
				soder=soder+Iif(!Empty(c_te.us),' с учетом припуска '+Alltrim(Str(c_te.us,4,2))+' под последующую обработку','')
				Do stroka_o
			Endif
		Endif
	Endif
	If m.kko = 7 Or m.kko = 8
		soder=soder+' выдерживая размеры: Ф '
		kuku = ''
		Do d_
		Do tocd1_

		kuku = kuku +Iif(m.ug>0,'; У='+Alltrim(Str(m.ug))+' град','') ;
			+Iif(m.rad>0,'; r='+Alltrim(Str(m.rad,5,1)),'')
		Do sh_
		soder=soder+kuku
		Do stroka_o
	Endif
	If m.kko = 12
		*!*		soder = ' Ф '+allt(str(m.d,6,2))+'  до Ф '+allt(str(m.dbk,6,2))+' глубиной '+ALLTRIM(STR(m.ds,6,2))
		*!*		do stroka_o
		If dbk#0
			soder=soder+' выдерживая размеры: Ф'
			kuku=''
			Do dbk_
			Do tocd1_
			If m.ds# 0
				kuku = kuku + '; l='
				Do ds_
			Endif
			Do sh_
			kuku = kuku +Iif(m.ug>0,'; У='+Alltrim(Str(m.ug))+' град','') ;
				+Iif(m.rad>0,'; r='+Alltrim(Str(m.rad,5,1)),'')
			soder = soder + kuku
			soder=soder+Iif(!Empty(c_te.us),' с учетом припуска '+Alltrim(Str(c_te.us,4,2))+' под последующую обработку','')
			Do stroka_o
		Else
			If Empty(m.toch1)
				soder=soder+'Подрезать торец как чисто'
				soder=soder+Iif(!Empty(c_te.us),' с учетом припуска '+Alltrim(Str(c_te.us,4,2))+' под последующую обработку','')
				Do stroka_o
			Else
				soder='Tочить торец выдержав размеры '
				kuku=Alltrim(Str(m.toch,5,1))
				Do toch1_
				Do sh_
				soder = soder + kuku
				soder=soder+Iif(!Empty(c_te.us),' с учетом припуска '+Alltrim(Str(c_te.us,4,2))+' под последующую обработку','')
				Do stroka_o
			Endif
		Endif

	Endif

	If m.kko=15
		kuku=''
		soder=soder+' выдерживая размеры: Ф'
		Do d_
		kuku=kuku+' на длину '
		Do ds_
		Do sh_
		soder=soder+kuku
		Do stroka_o
	Endif
	If m.kko=5 Or m.kko > 15 And  m.kko <20
		soder=soder+' выдерживая размеры: Ф'
		kuku=''
		Do d_
		Do tocd1_
		If m.ds # 0
			kuku = kuku + '; l='
			Do ds_
			Do toch1_
		Endif
		Do sh_
		soder=soder+kuku
		Do stroka_o
	Endif

	If m.kko > 19 And m.kko < 24
		soder = soder+Alltrim(Str(m.ip,2))+' паз(ы) выдерживая размеры: Ф'
		kuku = ''
		Do dbk_
		Do tocd1_
		If m.ds # 0
			kuku = kuku +'; в='
			Do ds_
		Endif
		Do sh_
		kuku = kuku +Iif(m.ug>0,'; У='+Alltrim(Str(m.ug))+' град','') ;
			+Iif(m.rad>0,'; r='+Alltrim(Str(m.rad,5,1)),'')
		soder = soder + kuku
		Do stroka_o
	Endif
	If Inlist(m.kko, 24,25)
		kuku=''
		soder = soder+' M '
		Do d_
		kuku=kuku+'x'+Alltrim(Str(m.shag,5,2))+'-'+m.tocd1+' на длине '
		Do ds_
		soder=soder+kuku
		Do stroka_o
	Endif
	If m.kko = 26
		soder=soder+' выдерживая размеры: '
		kuku = ''
		kuku = kuku +Iif(m.ug>0,'; '+Alltrim(Str(m.ds,9,1))+'x'+Alltrim(Str(m.ug))+' град','') ;
			+Iif(m.rad>0,'; r='+Alltrim(Str(m.rad,5,1)),'')
		Do sh_
		soder=soder+kuku
		Do stroka_o
	Endif
	If Inlist(m.kko,28,29,30,31)
		soder = soder+' выдерживая размеры: R'+Alltrim(Str(m.rad,6,2))
		kuku=''
		Do sh_
		soder=soder+kuku
		Do stroka_o
	Endif
	If Inlist(m.kko,33)

	Endif
	If m.kko > 33 And m.kko < 40
		kuku=''
		shag_ = Str(m.shag,4,1)
		soder = soder+' G '+Subs(shag_,1,1)+' '+Subs(shag_,2,1)+'\'+Subs(shag_,4,1)+'"'+'  на длине '
		Do ds_
		soder=soder+kuku
		Do stroka_o
	Endif
	If Inlist(m.kko,40,42)
		soder = soder+' выдерживая размеры: Ф'+Alltrim(Str(m.d,6,2))
		Do stroka_o
	Endif
	If Inlist(m.kko, 41,44)
		kuku=''
		soder = soder+' Ф '
		Do d_
		kuku=kuku+' '+m.tocd1+' глубиной '
		Do ds_
		soder=soder+kuku
		Do stroka_o
	Endif
Endif
Return

*********************************** КОНЕЦ ТОКАРНО-ВИНТОРЕЗНОЙ *************************************
***************************************************************************************************
***************************************************************************************************
********************************** С В Е Р Л О В К А **********************************************
Procedure f_swerl
Wait ' С В Е Р Л О В К А  ' Window Nowait
*!*	WAIT WINDOW 'kko='+STR(m.kko)
soder = ''
If m.ntp=1
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from DOSP where vid=31 and kod=?c_te.kku And us=?c_te.vid','C_dosp31')
		If rrsql = -1
			eodbc('PT PRG DOSP 31 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP 31 conn')
	Endif
	If Recc()>0
		soder=Alltrim(im)+' '+Alltrim(sim)
		Do stroka_o
	Endif
	Use In c_dosp31
Endif

If m.kko#0
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from PT where vid=?c_te.vid and kko=?m.kko','C_pt')
		If rrsql = -1
			eodbc('PT PRG pt-file Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG pt-file conn')
	Endif
	If Reccount() > 0
		soder = Allt(im)
	Endif
	Use In c_pt
Endif
soder =Allt(Str(M.ntp))+'. '+soder
If m.kko=77 or m.kko=78
	Do stroka_o
else
*!*		soder = ''
	If m.kko =1
		kuku = ''
		soder = soder+' '+;
			alltrim(Str(ip))+' отв.' ;
			+ ' выдерживая размеры: Ф'
		Do d_
		Do toch1_
		If m.ds#0
			kuku=kuku+' l='
			Do ds_
		Endif
		Do sh_
		soder = soder + kuku
		Do stroka_o
	Endif
	If m.kko = 2
		kuku = ''
		soder =soder ;
			+' '+Alltrim(Str(ip))+' отв. ' ;
			+ ' выдерживая размеры: Ф'
		Do d_
		Do toch1_
		If m.ds # 0
			kuku = kuku + '; l='
			Do ds_
		Endif
		Do sh_
		soder = soder + kuku
		Do stroka_o
	Endif
	If Inlist(m.kko, 3,4,11,12,13,14)
		kuku = ''
		soder =soder ;
			+' '+Alltrim(Str(ip))+' отв.' ;
			+ ' выдерживая размеры: Ф'
		Do d_
		Do toch1_
		If m.ds # 0
			kuku = kuku + '; l='
			Do ds_
		Endif
		Do sh_
		soder = soder + kuku
		Do stroka_o
	Endif
	If m.kko = 5
		kuku = ''
		soder =soder + ' '+Alltrim(Str(ip))+' отв. согласно разметки'
		Do stroka_o
	Endif
	If Inlist(m.kko, 6,7,8,16,17,18)
		kuku = ''
		soder =soder ;
			+' '+Alltrim(Str(ip))+' отв.' ;
			+ ' выдерживая размеры: Ф'
		Do d_
		Do toch1_
		Do sh_
		soder = soder + kuku
		Do stroka_o
	Endif
	If Inlist(m.kko, 9,10)
		kuku = ''
		soder =soder ;
			+' '+Alltrim(Str(ip))+' отв.' ;
			+' выдерживая размеры: M'
		Do d_
		kuku=kuku+'x'+Alltrim(Str(m.shag,5,2))+'-'+Alltrim(m.toch1)+'; l='
		Do ds_
		Do sh_
		soder = soder + kuku
		Do stroka_o
	Endif
	If Inlist(m.kko, 15,20)
		soder =soder + ' согласно требований чертежа'
		Do stroka_o
	Endif
Endif
Return
*********************************** К О Н Е Ц   С В Е Р Л О В К И   *******************************
***************************************************************************************************
*********************************** Ф Р Е З Е Р Н Ы Е *********************************************
Procedure f_freza
Wait 'Ф Р Е З Е Р Н Ы Е  ' Window Nowait
soder = ''
If m.ntp=1
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from DOSP where vid=31 and kod=?c_te.kku And us=?c_te.vid','C_dosp31')
		If rrsql = -1
			eodbc('PT PRG DOSP 31 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP 31 conn')
	Endif
	If Recc()>0
		soder=Alltrim(im)+' '+Alltrim(sim)
		Do stroka_o
	Endif
	Use In c_dosp31
Endif

If (c_te.mar = 215 Or c_te.mar = 604)  And c_te.ntp=1
	soder = 'Обработать поверхности детали согласно прoграммы'
	Do stroka_o
Endif
soder = ''
*WAIT WINDOW 'kko='+STR(m.kko)
If m.kko#0
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		*!*					  Select * From pt Where vid=c_te.vid  And kko= m.kko Into Curs c_pt
		rrsql = SQLExec(hh,'select * from PT where vid=?c_te.vid and kko=?m.kko','C_pt')
		If rrsql = -1
			eodbc('PT PRG pt-file Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG pt-file conn')
	Endif
	If Reccount() > 0
		soder = Allt(im)
	Endif
	Use In c_pt

	soder =Allt(Str(M.ntp))+'. '+soder
	
	If m.kko=77 or m.kko = 78
		Do stroka_o
	else
*!*			soder=''
		kuku=' выдерживая размеры:'
		If !Empt(m.rr1)
			kuku = kuku +' '
			Do rr1_
			Do tocd1_
		Endif
		If m.rr2#0
			kuku = kuku +' '
			Do rr2_
			Do toch2_
		Endif
		If !Empt(m.toch)
			kuku = kuku +' '+Allt(Str(m.toch,6,1))
			Do toch1_
		Endif

		kuku=kuku+Iif(m.ug#0,'; угол '+Alltrim(Str(m.ug,3))+' град','');
			+Iif(m.rad#0,'; R='+Alltrim(Str(m.rad,3)),'') ;
			+Iif(m.shag#0, '; s='+Alltrim(Str(m.shag,6,2)), '')
		Do sh_
		soder=soder+kuku
		soder=soder+Iif(!Empty(c_te.us),' с учетом припуска '+Alltrim(Str(c_te.us,4,2))+' под последующую обработку','')
		Do stroka_o
	Endif
Endif
Return
************************************КОНЕЦ ФРЕЗЕРНЫХ************************************************

***************************************************************************************************
*********************************** Д О Л Б Е Ж Н Ы Е  *********************************************
Procedure f_dolb
Wait 'Д О Л Б Е Ж Н Ы Е ' Window Nowait
soder = ''

hh = SQLConnect('sqldb','sa','111')
If hh > 0
	*!*					  Select * From dosp Where vid=31 And kod= c_te.kku And us= c_te.vid Into Curs c_dosp31
	rrsql = SQLExec(hh,'select * from DOSP where vid=31 and kod=?c_te.kku And us=?c_te.vid','C_dosp31')
	If rrsql = -1
		eodbc('PT PRG DOSP 31 Select')
	Endif
	SQLDisconnect(hh)
Else
	eodbc('PT PRG DOSP 31 conn')
Endif
If Recc()>0
	soder=Alltrim(im)+' '+Alltrim(sim)
	Do stroka_o
Endif
Use In c_dosp31

soder = ''
*WAIT WINDOW 'kko='+STR(m.kko)
If m.kko#0
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from PT where vid=?c_te.vid and kko=?m.kko','C_pt')
		If rrsql = -1
			eodbc('PT PRG pt-file Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG pt-file conn')
	Endif
	If Reccount() > 0
		soder = Allt(im)
	Endif
	Use In c_pt
Endif
*!*	Do stroka_o
*!*	soder=''
kuku=' выдерживая размеры:'

If m.glub#0
	kuku = kuku +' '+Allt(Str(m.glub,3,1))
	Do toch1_
Endif
If !Empt(m.shag)
	kuku = kuku +' '+Allt(Str(m.shag,3,1))
	Do toch2_
Endif
Do sh_
If !Empt(m.ds)
	kuku = kuku +' на длину '
	Do ds_
Endif
soder=soder+kuku
Do stroka_o
Return
************************************КОНЕЦ Д О Л Б Е Ж Н Ы Е************************************************



***************************************************************************************************
*********************************** Т Р А Н С П О Р Т Н Ы Е ****************************************
Procedure Trans
Wait 'Т Р А Н С П О Р Т Н Ы Е ' Window Nowait
soder='Переместить деталь(узел) по технологическому маршруту '
Do stroka_o
Return
************************************КОНЕЦ ТРАНСПОРТНОЙ*********************************


***************************************************************************************************
*********************************** К Р У Г ЛО - Ш Л И Ф О В А Л Ь Н Ы Е **************************
Procedure  f_k_s
Wait Window ' К Р У Г Л О - Ш Л И Ф О В А Л Ь Н Ы Е' Nowait
soder = ''
If m.ntp=1
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from DOSP where vid=31 and kod=?c_te.kku And us=?c_te.vid','C_dosp31')
		If rrsql = -1
			eodbc('PT PRG DOSP 31 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP 31 conn')
	Endif
	If Recc()>0
		soder=Alltrim(im)+' '+Alltrim(sim)
		Do stroka_o
	Endif
	Use In c_dosp31
Endif
soder = ''
*!*	WAIT WINDOW 'vid='+STR(c_te.vid)+' kko='+STR(m.kko)
If m.kko#0
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from PT where vid=?c_te.vid and kko=?m.kko','C_pt')
		If rrsql = -1
			eodbc('PT PRG pt-file Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG pt-file conn')
	Endif
	If Reccount() > 0
		soder = Allt(im)
	Endif
	Use In c_pt
Endif
soder =Allt(Str(M.ntp))+'. '+soder

If m.kko=77 Or m.kko=78
	Do stroka_o
Else
	*!*	soder=''
	*!*	if m.dbk#0
	*!*	   soder=soder+' поверхность '
	*!*	endif

	soder=soder+' выдерживая размеры Ф'
	kuku=''
	If m.dbk#0
		Do dbk_
		Do tocd1_
	Else
		Do d_
		Do tocd1_
	Endif
	*!*	wait window '1 soder='+soder+' kuku='+kuku
	If m.ds # 0
		kuku=kuku + '; '
		Do ds_
		Do toch3_
	Endif
	*!*	wait window 'pered sh soder='+soder+' kuku='+kuku
	Do sh_
	soder=soder+kuku
	*!*	wait window 'pered stroka_o soder='+soder+' kuku='+kuku
	Do stroka_o
Endif
Return
***************************************************************************************************
*********************************** КОНЕЦ К Р У Г Л О - Ш Л И Ф О В А Л Ь Н Ы Е *******************
***************************************************************************************************
*********************************** П Л О С К О - Ш Л И Ф О В А Л Ь Н Ы Е *************************
***************************************************************************************************
Procedure f_p_s
Wait Window ' П Л О С К О - Ш Л И Ф О В А Л Ь Н Ы Е ' Nowait
soder = ''
If m.ntp=1

	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from DOSP where vid=31 and kod=?c_te.kku And us=?c_te.vid','C_dosp31')
		If rrsql = -1
			eodbc('PT PRG DOSP 31 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP 31 conn')
	Endif
	If Recc()>0
		soder=Alltrim(im)+' '+Alltrim(sim)
		Do stroka_o
	Endif
	Use In c_dosp31
Endif

soder = ''
*WAIT WINDOW 'vid='+STR(c_te.vid)+' kko='+STR(m.kko)
If m.kko#0
	*!*		Sele * From pt Where vid=c_te.vid And kko=m.kko Into Curs c_pt
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from PT where vid=?c_te.vid and kko=?m.kko','C_pt')
		If rrsql = -1
			eodbc('PT PRG pt-file Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG pt-file conn')
	Endif
	If Reccount() > 0
		soder = Allt(im)
	Endif
	Use In c_pt
Endif
soder =Allt(Str(M.ntp))+'. '+soder
If m.kko=77 Or m.kko=78
	Do stroka_o
Else
	If m.kob>1
		soder=soder +' '+Alltrim(Str(m.kob))+' деталей(и) '+Iif(m.ip>1,' '+Alltrim(Str(m.ip))+'-x сторон','')
	Else
		soder=soder + ' деталь '+Iif(m.ip>1,' '+Alltrim(Str(m.ip))+'-x сторон','')
	Endif
*!*		Do stroka_o
	soder=soder + ' выдерживая размеры: '+Alltrim(Str(d,6,2))
	kuku=''
	Do tocd1_
	If m.toch # 0
		kuku=kuku +'; '+Alltrim(Str(m.toch,6,2))
		Do toch1_
	Endif
	soder = soder + kuku
	Do stroka_o
Endif
Return
***************************************************************************************************
*********************************** КОНЕЦ П Л О С К О - Ш Л И Ф О В А Л Ь Н Ы Е *******************
***************************************************************************************************
*********************************** В Н У Т Р И - Ш Л И Ф О В А Л Ь Н Ы Е *************************
***************************************************************************************************
Procedure f_w_s
Wait Window 'В Н У Т Р И - Ш Л И Ф О В А Л Ь Н Ы Е  ' Nowait
soder = ''
If m.ntp=1
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from DOSP where vid=31 and kod=?c_te.kku And us=?c_te.vid','C_dosp31')
		If rrsql = -1
			eodbc('PT PRG DOSP 31 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP 31 conn')
	Endif
	If Recc()>0
		soder=Alltrim(im)+' '+Alltrim(sim)
		Do stroka_o
	Endif
	Use In c_dosp31
Endif

soder = ''

If m.kko#0
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from PT where vid=?c_te.vid and kko=?m.kko','C_pt')
		If rrsql = -1
			eodbc('PT PRG pt-file Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG pt-file conn')
	Endif
	If Reccount() > 0
		soder = Allt(im)
	Endif
	Use In c_pt
Endif
soder =Allt(Str(M.ntp))+'. '+soder
If m.kko<>77 And m.kko<>78
	kuku = ''
	soder=soder+', выдерживая Ф'
	Do dbk_
	*!*	DO d_
	Do tocd1_
	kuku=kuku +Iif(m.sh#0,', шероховатостью Ra='+Alltrim(Str(m.sh,7,3)),'')
	If m.ds#0
		kuku=kuku+'; l='
		Do ds_
	Endif
	Do toch1_
	soder=soder+kuku
	Do stroka_o
Else
	Do stroka_o
Endif
Return
***************************************************************************************************
*********************************** КОНЕЦ В Н У Т Р И - Ш Л И Ф О В А Л Ь Н Ы Е *******************

***************************************************************************************************
*********************************** З У Б О О Б Р А Б О Т К А *************************************
***************************************************************************************************
Procedure f_z_f
Wait Window 'З У Б О О Б Р А Б О Т К А' Nowait
soder = ''
*!*	If m.ntp=1
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from DOSP where vid=31 and kod=?c_te.kku And us=?c_te.vid','C_dosp31')
		If rrsql = -1
			eodbc('PT PRG DOSP 31 Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG DOSP 31 conn')
	Endif
	If Recc()>0
		soder=Alltrim(im)+' '+Alltrim(sim)
		Do stroka_o
	Endif
	Use In c_dosp31
*!*	Endif
soder = ''
If m.kko#0
	*	WAIT WINDOW 'З У Б О О Б Р А Б О Т К А  vid='+STR(c_te.vid)+' kko='+STR(m.kko)
	*!*		Sele * From pt Where vid=c_te.vid And kko=m.kko Into Curs c_pt
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		rrsql = SQLExec(hh,'select * from PT where vid=?c_te.vid and kko=?m.kko','C_pt')
		If rrsql = -1
			eodbc('PT PRG pt-file Select')
		Endif
		SQLDisconnect(hh)
	Else
		eodbc('PT PRG pt-file conn')
	Endif
	If Reccount() > 0
		soder = Allt(im)
	Endif
	Use In c_pt
Endif
*!*	soder =Allt(Str(M.ntp))+'. '+soder

If m.kko#0
	*!*			      WAIT WINDOW ' PT BROW m.kko='+STR(m.kko,4)+' mvid='+STR(mvid,4)+' m.ka='+STR(m.ka)
	If m.ka#0
		kuku=''
		soder=soder+' '+Alltrim(Str(M.ke,3))+' зубъев(а); модуль '+Allt(Str(m.ka,2))
		Do sh_
		soder=soder+'; остальные размеры согласно чертежа'
	Endif
Endif
Do stroka_o
Return
***************************************************************************************************
*********************************** КОНЕЦ ЗУБООБРАБОТКИ *******************************************

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * *  О Б Ы К Н О В Е Н Н А Я    С В А Р К А   * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure swarka
Wait Window ' пошла сварка'  Nowa
*!*		wait window 'kto'+str(m.kto,4)+'  nto='+str(m.nto,4)+' ntp='+str(m.ntp,2)
If c_te.kto = 101
	soder = 'Разметить свариваемые поверхности деталей согласно чертежа комплектом разметочного инструмента'
	Do stroka_o
Endif
If c_te.kto = 418
	hh = SQLConnect('sqldb','sa','111')
	If hh > 0
		*!*						Select kornd,naimd,nrmd,kol From kt Where poznd=c_te.poznd               And d_u=1 Or       poznw =       c_te.poznd  And d_u=2 Order By kornd	into Cursor c_kt_kornd
		rrsql = SQLExec(hh,'select kornd,naimd,nrmd,kol from KT where rtrim(poznd) = rtrim(?m.poznd) And d_u=1 Or rtrim(poznw)=rtrim(?c_te.poznd) And d_u=2 Order By kornd','C_KT_KORND')
		If rrsql = -1
			eodbc('PT prg swarka KT Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg swarka KT conn')
	Endif
	soder = 'Cкомплектовать детали(подузлы) под сварку  и транспортировать на рабочнн место сварщика '
	Do stroka_o
	soder_t='Tележка ручная'
	m.buk = 'T'
	m.ss  = soder_t
	Insert Into ptt From Memv
	soder_t='Погрузчик'
	m.buk = 'T'
	m.ss  = soder_t
	Insert Into ptt From Memv
	soder_t='Кран-балка'
	m.buk = 'T'
	m.ss  = soder_t
	Insert Into ptt From Memv
	Use In c_kt_kornd
Endif
If c_te.kto = 109
	soder = 'Очистить свариваемые кромки и прилегающие к ним поверхности деталей от жировых загрязнений, окисных пленок, грязи и краски на ширину не менее 30 мм.'
	Do stroka_o
	If Inlist(1,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0

			rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=476','C_KODI')
			If rrsql = -1
				eodbc('PT prg INSTR 476 Select')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('PT prg INSTR 476 conn')
		Endif
		If Reccount() > 0
			m.ss  = Alltrim(c_kodi.im)
			m.buk = 'T'
			Insert Into ptt From Memv
		Endif
		Use In c_kodi
	Endif
	If Inlist(2,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0

			rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=462','C_KODI')
			If rrsql = -1
				eodbc('PT prg INSTR 462 Select')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('PT prg INSTR 462 conn')
		Endif
		If Reccount() > 0
			m.ss  =Alltrim(c_kodi.im)
			m.buk = 'T'
			Insert Into ptt From Memv
		Endif
		Use In c_kodi
	Endif
	If Inlist(3,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			*!*
			rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=322','C_KODI')
			If rrsql = -1
				eodbc('PT prg INSTR 322 Select')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('PT prg INSTR 322 conn')
		Endif
		If Reccount() > 0
			m.ss  = Alltrim(c_kodi.im)
			m.buk = 'T'
			Insert Into ptt From Memv
		Endif
		Use In c_kodi
	Endif
	If Inlist(5,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			*!*
			rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=329','C_KODI')
			If rrsql = -1
				eodbc('PT prg INSTR 329 Select')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('PT prg INSTR 329 conn')
		Endif
		If Reccount() > 0
			m.ss  = Alltrim(c_kodi.im)
			m.buk = 'T'
			Insert Into ptt From Memv
		Endif
		Use In c_kodi

		hhh = SQLConnect('sqldb','sa','111')
		If hhh > 0
			rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=477','C_KODI')
			If rrsql = -1
				eodbc('PT prg INSTR 477 Select')
			Endif
			SQLDisconnect(hhh)
		Else
			eodbc('PT prg INSTR 477 conn')
		Endif
		If Reccount() > 0
			m.ss  = Alltrim(c_kodi.im)
			m.buk = 'T'
			Insert Into ptt From Memv
		Endif
		Use In c_kodi
	Endif

	hhh = SQLConnect('sqldb','sa','111')
	If hhh > 0
		rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=469','C_KODI')
		If rrsql = -1
			eodbc('PT prg INSTR 469 Select')
		Endif
		SQLDisconnect(hhh)
	Else
		eodbc('PT prg INSTR 469 conn')
	Endif
	If Reccount() > 0
		m.ss  = Alltrim(c_kodi.im)
		m.buk = 'T'
		Insert Into ptt From Memv
	Endif
	Use In c_kodi
Endif
*!*	If Inlist(c_te.kto, 9031,9041,9043) And m.ntp=1
*!*		soder='Прихватить детали в узле с необходимыми переустановками и подгонкой свариваемых кромок'
*!*		Do stroka_o
*!*		soder='Сварить узел с необходимыми переустановками , выдерживая требования чертежа'
*!*		Do stroka_o
If Inlist(c_te.kto, 9031,9041,9043) And m.kodp=66
	soder='Комплектовать детали к узлу, подготовить сварочные кромки к сварке, разметить, собрать и прихватить, '
	Do stroka_o
	soder=' сварить с необходимыми переустановками и подгонкой ,зачистить свариваемые швы согласно требований чертежа,'
	Do stroka_o
	soder=' проверить швы, сдать роботу ОТК'
	Do stroka_o

*!*	If c_te.kto = 130
*!*		If m.ntp=1 And Inlist(1,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15) ;
*!*				or Inlist(2,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15) ;
*!*				or Inlist(4,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			soder = 'Зачистить с необходимыми переустановками сварные швы и прилегающие к ним поверхности от брызг расплавленного металла'
*!*			Do stroka_o
*!*		Endif
*!*		If m.ntp=1 And Inlist(1,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=476','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 476 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 476 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(2,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				*!*
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi = 319','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 319 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 319 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(4,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=486 Or kodi=513','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 486 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 486 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(33,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15) ;
*!*				or Inlist(34,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			soder = 'Зачистить сварные швы и прилегающие к ним поверхности от брызг расплавленного металла'
*!*			Do stroka_o
*!*		Endif
*!*		If m.ntp=1 And Inlist(34,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=462','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 462 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 462 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(33,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=457','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 457 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 457 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif

*!*		If m.ntp=1
*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=469','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 469 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 469 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(28,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			soder = 'Наплывы и неровности сварных швов обработать с плавным переходом к основному металлу'
*!*			Do stroka_o

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=457','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 457 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 457 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=469','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 469 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 469 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(29,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			soder = 'Усиление шва снять'
*!*			Do stroka_o

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=457','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 457 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 457 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=469','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 469 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 469 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*	Endif
*!*	If c_te.kto = 4237
*!*		If m.ntp=1 And Inlist(28,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			soder = 'Наплывы и неровности сварных швов обработать с плавным переходом к основному металлу'
*!*			Do stroka_o
*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=469','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 469 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 469 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(29,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			soder = 'Усиление шва снять'
*!*			Do stroka_o
*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=469','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 469 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 469 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*	Endif
*!*	If c_te.kto = 200
*!*		soder = '1. Проверить качество свариваемых швов визуально, наплывы, подрезы, трещины, непровары и прожеги не допускаются'
*!*		Do stroka_o
*!*		soder = '2. Проверить соответствие свариваемого узла чертежу, контролировать размеры:'
*!*		kuku='; '
*!*		Do rr1_
*!*		Do toch1_

*!*		kuku = kuku +'; '
*!*		Do rr2_
*!*		Do toch2_

*!*		kuku = kuku +'; '
*!*		Do rr3_
*!*		Do toch3_
*!*		soder=soder+kuku
*!*		Do stroka_o
*!*		hhh = SQLConnect('sqldb','sa','111')
*!*		If hhh > 0
*!*			rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=110','C_KODI')
*!*			If rrsql = -1
*!*				eodbc('PT prg INSTR 110 Select')
*!*			Endif
*!*			SQLDisconnect(hhh)
*!*		Else
*!*			eodbc('PT prg INSTR 110 conn')
*!*		Endif
*!*		If Reccount() > 0
*!*			m.ss  = Alltrim(c_kodi.im)
*!*			m.buk = 'T'
*!*			Insert Into ptt From Memv
*!*		Endif
*!*		Use In c_kodi
*!*		If Inlist(6,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=469','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 469 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 469 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(8,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=514','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 514 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 514 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(9,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=386','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 386 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 386 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(9,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=33','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 33 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 33 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif
*!*		If m.ntp=1 And Inlist(7,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)

*!*			hhh = SQLConnect('sqldb','sa','111')
*!*			If hhh > 0
*!*				rrsql = SQLExec(hhh,'Select im From INSTR Where kodi=37','C_KODI')
*!*				If rrsql = -1
*!*					eodbc('PT prg INSTR 37 Select')
*!*				Endif
*!*				SQLDisconnect(hhh)
*!*			Else
*!*				eodbc('PT prg INSTR 37 conn')
*!*			Endif
*!*			If Reccount() > 0
*!*				m.ss  = Alltrim(c_kodi.im)
*!*				m.buk = 'T'
*!*				Insert Into ptt From Memv
*!*			Endif
*!*			Use In c_kodi
*!*		Endif

*!*		If m.ntp=1 And Inlist(27,m.us1,m.us2,m.us3,m.us4,m.us5,m.us6,m.us7,m.us8,m.us9,m.us10,m.us11,m.us12,m.us13,m.us14,m.us15)
*!*			soder = '1. Установить свариваемую емкость на горизонтальную поверхность, выставить по уровню.'
*!*			Do stroka_o
*!*			soder = '2. Наполнить емкость водой '
*!*			Do stroka_o
*!*			soder = '3. Выдержать емкость с водой в течении 1 часа.'
*!*			Do stroka_o
*!*			soder = '4. Проверить отсутствие течи воды вдоль сварных швов визуально'
*!*			Do stroka_o
*!*			soder = '5. Слить воду из проверяемой емкости'
*!*			Do stroka_o
*!*			soder = '6. Высушить емкость от остатков влаги на поверхности изделия естественной сушкой'
*!*			Do stroka_o
*!*		Endif
*!*endif
endif
*       конец сварки
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
***************************************************************************************************
*********************	К О Н Т Р О Л Ь   ******************************
Procedure kontrol
Wait 'К О Н Т Р О Л Ь ' Window Nowait
soder ='Контролировать '+Allt(Str(c_te.kob))+' % деталей. Количество замеров '+Alltrim(Str(c_te.ip))
Do stroka_o
soder='Проверить размеры:'
kuku = ''
If !Empty(m.rr1)
	kuku=kuku+'; '
	Do rr1_
	Do toch1_
Endif
If !Empty(m.rr2)
	kuku = kuku +'; '
	Do rr2_
	Do toch2_
Endif
If !Empty(m.toch)
	Do toch_
	Do tocd1_
Endif
If !Empty(m.rr3)
	kuku = kuku +'; '
	Do rr3_
	Do toch3_
Endif
kuku = kuku +Iif(c_te.ug#0,'; угол '+Alltrim(Str(c_te.ug,3))+' град','') ;
	+Iif(m.rad#0,'; R='+Alltrim(Str(m.rad,3)),'') ;
	+Iif(m.shag#0,'; шаг='+Alltrim(Str(m.shag,5,2)),'') ;
	+Iif(c_te.sh<>0,'; Ra='+Allt(Str(c_te.sh,7,3)),'')

soder = soder + kuku
Do stroka_o

Return
* * * * * * * * * * * * * * * * * * К О Н Е Ц  К О Н Т Р О Л Ь* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
***************************************************************************************************
********************* С Б О Р К А	   ******************************
Procedure sborka
Wait 'С Б О Р К А ' Window Nowait
soder ='Собрать узел в соответствии с требованиями чертежа выдерживая размеры:'
kuku = ''
If !Empty(m.rr1)
	kuku=kuku+'; '
	Do rr1_
	Do toch1_
Endif
If !Empty(m.rr2)
	kuku = kuku +'; '
	Do rr2_
	Do toch2_
Endif
If !Empty(m.rr3)
	kuku = kuku +'; '
	Do rr3_
	Do toch3_
Endif
soder = soder + kuku
Do stroka_o
Return
* * * * * * * * * * * * * * * * * * К О Н Е Ц  С Б О Р К А * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Procedure toch1_
If !Empt(m.toch1)
	If Asc(Left(m.toch1,1))>64 And Asc(Left(m.toch1,1))<91 Or Asc(Left(m.toch1,1))>96 And Asc(Left(m.toch1,1))<123 ;
			or Asc(Left(m.toch1,1))>191 And Asc(Left(m.toch1,1))<256
		kuku = kuku +' '+Allt(m.toch1)+';'
	Else
		kuku = kuku +' '+Allt(m.toch1)+Iif(Empty(m.toch11),'', ' '+Alltrim(m.toch11))+';'
	Endif
Endif
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure toch2_
If !Empty(m.toch2)
	If Asc(Left(m.toch2,1))>64 And Asc(Left(m.toch2,1))<91 Or Asc(Left(m.toch2,1))>96 And Asc(Left(m.toch2,1))<123 ;
			or Asc(Left(m.toch2,1))>191 And Asc(Left(m.toch2,1))<256
		kuku = kuku +' '+Allt(m.toch2)+';'
	Else
		kuku = kuku +' '+Allt(m.toch2)+Iif(Empty(m.toch21),+'', ' '+Alltrim(m.toch21))+';'
	Endif
Endif
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure toch3_
If !Empty(m.toch3)
	If Asc(Left(m.toch3,1))>64 And Asc(Left(m.toch3,1))<91 Or Asc(Left(m.toch3,1))>96 And Asc(Left(m.toch3,1))<123 ;
			or Asc(Left(m.toch3,1))>191 And Asc(Left(m.toch3,1))<256
		kuku = kuku +' '+Allt(m.toch3)+';'
	Else
		kuku = kuku +' '+Allt(m.toch3)+Iif(Empty(m.toch31),+'', ' '+Alltrim(m.toch31))+';'
	Endif
Endif
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure tocd1_
If !Empty(m.tocd1)
	If Asc(Left(m.tocd1,1))>64 And Asc(Left(m.tocd1,1))<91 Or Asc(Left(m.tocd1,1))>96 And Asc(Left(m.tocd1,1))<123 ;
			or Asc(Left(m.tocd1,1))>191 And Asc(Left(m.tocd1,1))<256
		kuku = kuku +' '+Allt(m.tocd1)+';'
	Else
		kuku = kuku +' '+Allt(m.tocd1)+Iif(Empty(m.tocd11),+'', ' '+Alltrim(m.tocd11))+';'
	Endif
Endif
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure sh_
If m.sh#0
	*!*		kuku=''
	m_sh=Str(m.sh,7,3)
	If Right(m_sh,1)='0'
		msh=Str(m.sh,6,2)
		If Right(msh,1)='0'
			msh_=Str(m.sh,5,1)
			If Right(msh_,1)='0'
				opa=Alltrim(Str(M.sh))
			Else
				opa=Alltrim(Str(m.sh,5,1))
			Endif
		Else
			opa=Allt(Str(m.sh,6,2))
		Endif
	Else
		opa=Alltrim(Str(m.sh,7,3))
	Endif
	If m.sh=>10
		kuku=kuku+'; Rz='+opa
	Else
		kuku=kuku+'; Ra='+opa
	Endif
Endif
Return
***************************************************************************************************
Proc stroka_a
m.buk 	= 'А'
m.ceh 	= c_te.mar
m.oper   = c_te.nto
m.od		= Iif(!Empty(m_od),m_od,'')
Insert Into ptt From Memv
Retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc stroka_b
Select c_te
m.buk 	= 'Б'
m.prof 	= c_te.kodp
m.p    	= c_te.rr
m.ut   	= c_te.setka
m.kp  	= c_te.krno
m.koid	= c_te.kob
m.tpz		= itpz
*m.tsht	= c_te.normw
*IF INLIST(LEFT(c_te.kttp,11),'06024.55273')
m.tsht	= itogt
*endif
Insert Into ptt From Memv
Retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Proc stroka_o
*!*	WAIT WINDOW 'stroka'+soder
If Len(soder)>120
	stroka_1=Substr(soder,1,119)
	m.buk = 'О'
	m.ss  = stroka_1
	*!*		wait window 'stroka_1='+stroka_1
	Insert Into ptt From Memv

	stroka_2=Substr(soder,120)
	*!*	   wait window 'stroka_2='+stroka_2
	m.buk = 'О'
	m.ss  = stroka_2
	Insert Into ptt From Memv
Else
	m.buk = 'О'
	m.ss  = soder
	Insert Into ptt From Memv
Endif
Retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure dbk_
If m.dbk#0
	mdbk=Str(m.dbk,6,2)
	If Right(mdbk,1)='0'
		mdbk_=Str(m.dbk,5,1)
		If Right(mdbk_,1)='0'
			opa=Alltrim(Str(M.dbk))
		Else
			opa=Alltrim(Str(m.dbk,5,1))
		Endif
	Else
		opa=Allt(Str(m.dbk,6,2))
	Endif
	kuku=kuku+opa
Endif
Return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure d_
If m.d#0
	md_=Str(m.d,6,2)
	If Right(md_,1)='0'
		mdb_=Str(m.d,5,1)
		If Right(mdb_,1)='0'
			opa=Alltrim(Str(M.d))
		Else
			opa=Alltrim(Str(m.d,5,1))
		Endif
	Else
		opa=Allt(Str(m.d,6,2))
	Endif
	kuku=kuku+opa
Endif
Return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure ds_
If m.ds#0
	mds=Str(m.ds,6,1)
	If Right(mds,1)='0'
		*!*			mds_=Str(m.ds)
		*!*			If Right(mds_,1)='0'
		opa=Alltrim(Str(M.ds))
		*!*			Else
		*!*				opa=Alltrim(Str(m.ds,5,1))
		*!*			Endif
	Else
		opa=Allt(Str(m.ds,6,1))
	Endif
	kuku=kuku+opa
Endif
Return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure rr1_
If m.rr1#0
	mrr1=Str(m.rr1,6,2)
	If Right(mrr1,1)='0'
		mrr1_=Str(m.rr1,5,1)
		If Right(mrr1_,1)='0'
			opa=Alltrim(Str(M.rr1))
		Else
			opa=Alltrim(Str(m.rr1,5,1))
		Endif
	Else
		opa=Allt(Str(m.rr1,6,2))
	Endif
	kuku=kuku+opa
Endif
Return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure rr2_
If m.rr2#0
	mrr2=Str(m.rr2,6,2)
	If Right(mrr2,1)='0'
		mrr2_=Str(m.rr2,5,1)
		If Right(mrr2_,1)='0'
			opa=Alltrim(Str(M.rr2))
		Else
			opa=Alltrim(Str(m.rr2,5,1))
		Endif
	Else
		opa=Allt(Str(m.rr2,6,2))
	Endif
	kuku=kuku+opa
Endif
Return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure rr3_
If m.rr3#0
	mrr3=Str(m.rr3,6,2)
	If Right(mrr3,1)='0'
		mrr3_=Str(m.rr3,5,1)
		If Right(mrr3_,1)='0'
			opa=Alltrim(Str(M.rr3))
		Else
			opa=Alltrim(Str(m.rr3,5,1))
		Endif
	Else
		opa=Allt(Str(m.rr3,6,2))
	Endif
	kuku=kuku+opa
Endif
Return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Procedure toch_
If m.toch#0
	mtoch=Str(m.toch,6,2)
	If Right(mtoch,1)='0'
		mtoch_=Str(m.toch,5,1)
		If Right(mtoch_,1)='0'
			opa=Alltrim(Str(M.toch))
		Else
			opa=Alltrim(Str(m.toch,5,1))
		Endif
	Else
		opa=Allt(Str(m.toch,6,2))
	Endif
	kuku=kuku+opa
Endif
Return
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
