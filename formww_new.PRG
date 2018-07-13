* заполнить ww по  
 
 
 
 *	CLOSE DATABASES
*	OPEN DATABASE db

if file('debug.inf')
	*susp
endif

local cShwz, kol_kt, rozma_kt, rid,rozma_kt,ind,mkol,inormw,itpz,cRibf
store '' to cShwz,rid,cRibf
store 0 to kol_kt, rozma_kt, rozma_kt,ind,mkol,inormw,itpz

do form f_izd_vib_shwz to m.cShwz

if !empty(m.cShwz)
	select shwz from ww where shwz = cShwz into cursor cww
	*WAIT WINDOW "RECCOUNT="+STR(RECCOUNT(),5)
	if reccount() > 0
		if  messagebox("Такое изделие уже сформировано. Сначала удалите его из производственной базы. Удалить?",4)= 6
			delete from ww where shwz=cShwz
		endif
		*RETURN -1
	endif
	use in cww

	select * from izd where shwz = cShwz into cursor c_izd
	go top
	scatter memvar
	*	brow

	*делаем выбор из кт

	local array m[20]
	store 0 to m
	select * from kt where shw = c_izd.Kod order by kornw, kornd ;
		into cursor c_kt

	*debug
	* BROWSE FIELDS poznd

	if reccount()=0
		use in c_kt
		use in c_izd
		wait window "В КТС такое изделие отсутствует!" nowait
		return -1
	endif
	*DO FORM Wait
	wait 'Начинается процесс формирования изделия...'+' '+ alltrim(m.cShwz) +' '+ alltrim(c_izd.Im) nowait wind
	*WAIT WINDOW 'начало'

*!*		select count(*) from ww into array aww
*!*		if aww[1] > 0
*!*			select max(nozap)from ww into array aww
*!*		endif

	select c_kt
	go top
	rn=0
	*BROWSE
	do while .not.eof()
		scatter memvar
		
		kol_kt  =koli
		kolz_kt =kolz
		rozma_kt=rozma
		m[1]=mar1
		m[2]=mar2
		m[3]=mar3
		m[4]=mar4
		m[5]=mar5
		m[6]=mar6
		m[7]=mar7
		m[8]=mar8
		m[9]=mar9
		m[10]=mar10
		m[11]=mar11
		m[12]=mar12
		m[13]=mar13
		m[14]=mar14
		m[15]=mar15
		m[16]=mar16
		m[17]=mar17
		m[18]=mar18
		m[19]=mar19
		m[20]=mar20
		rid=poznd
		ind=1
		do while  ind<21and m[ind]<>0 && o[ind]#0
			select * from te where poznd = rid and mar = m[ind] ;
				order by poznd, nto into cursor c_te
			select c_te
			*brow
			go top
			if reccount() > 0
				*WAIT WINDOW STR(RECCOUNT())+' '+ALLTRIM(poznd)
				store 0 to inormw,itpz
				scat memv
				skip
				do while .not.eof()
					inormw=inormw+m.normw
					itpz  =iif(m.tpz#0,m.tpz,itpz)
					if nto#m.nto
						m.shwz=cShwz
						mkol    = (c_izd.partz2-c_izd.partz1+1)*kol_kt
						m.kol   = kol_kt
						*                        m.data_z=DATE()
						m.kolz  = mkol
						m.normw = inormw
						m.tpz   = itpz
						if kolz_kt>1
							m.rozma=((rozma_kt-40)/kolz_kt)*mkol+40
						endif
						if m.kolz>0
							select obor from dosp where vid = 52 and us = m.kolz ;
								into curs c_dosp52
							if reccount()>0
								m.proc=val(obor)
							else
								m.proc=5
							endif
							use in c_dosp52
							select obor from dosp where vid = 2 and Kod = m.mar ;
								into curs c_dosp2
							*BROWSE
							if reccount()>0
								koef=val(obor)
							else
								koef=1
							endif
							use in c_dosp2
							m.proc=roun(m.proc*koef,0)
							m.proc=iif(m.proc>100,100,m.proc)
						endif
						*aww[1]=aww[1]+1
						m.nozap=get_newkod('ww')
						m.normw = m.inormw+m.itpz/mkol
						insert into ww from memvar

						store 0 to inormw,itpz
					endif
					select c_te
					scatter memvar
					skip
					*WAIT ' sele c_te skip' wind

				enddo
				inormw	 = inormw+m.normw
				itpz  	 = iif(m.tpz#0,m.tpz,itpz)
				m.shwz 	 = cShwz
				mkol    =(c_izd.partz2-c_izd.partz1+1)*kol_kt
				m.kol   =kol_kt
				m.kolz  =mkol
				m.data_z=date()
				m.normw=inormw
				m.tpz  =itpz
				****
				if kolz_kt>1
					m.rozma=((rozma_kt-40)/kolz_kt)*mkol+40
				endif
				use in c_te
				if m.kolz>1
					select * from dosp where vid = 52 and us = m.kolz into cursor c_dosp52
					if reccount()>0
						m.proc=val(obor)
					else
						m.proc=5
					endif
					use in c_dosp52
					select * from dosp where vid = 2 and Kod = m.mar into curs c_dosp2
					if reccount()>0
						koef=val(obor)
					else
						koef=1
					endif
					use in c_dosp2
					m.proc=roun(m.proc*koef,0)
					m.proc=iif(m.proc>100,100,m.proc)
				endif
				wait window allt(m.poznd)+' '+alltrim(m.naimd) nowait
				*					IF LASTKEY()=27
				*					   retu-1
				*					endif
				*aww[1]=aww[1]+1
				m.nozap = get_newkod('ww')
				m.normw = m.inormw+m.itpz/mkol
				* сформировать вид работ
				m.vidrab = 9
				do	case
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55241.' .and. inlist(m.d_u,1,2,3) 
						m.vidrab = 1
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55290.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 2 
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55273.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 3
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55271.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 4
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55288.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 5
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55220.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 6		
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55285.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 7
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55206.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 8		
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55201.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 10		
					case	!empty(m.kttp) .and. (substr(m.kttp,1,12) == '06024.55281.' .or. substr(m.kttp,1,12) == '06024.55280.') .and. inlist(m.d_u,1,2,3)
						m.vidrab = 11		
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55204.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 12
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55360.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 13
					case	!empty(m.kttp) .and. substr(m.kttp,1,12) == '06024.55250.' .and. inlist(m.d_u,1,2,3)
						m.vidrab = 14						
				endcase				
				* записать новую строку в ww
				insert into ww from memvar
				* zapisat WW
				store 0 to inormw,itpz
			endif
			ind=ind+1
			*WAIT 'ind='+STR(ind,3)+' m[ind]='+STR(m[ind],3) wind
			*	 			IF LASTKEY()=27
			*					   retu-1
			*					endif
			if ind>10.or.m[ind]=0
				exit
			endif
		enddo
		select c_kt
		skip
	enddo
	wait 'Процесс формирования окончен' nowait wind
else
	wait "Заполните ШИФР партии запуска!" nowai wind
	return -1
endif

thisform.grdWw.refresh



