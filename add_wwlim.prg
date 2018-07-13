* добавить необходимое количество материалов при планировании
* работает с таблицей wwlim
* nozap	идентификатор записи в ww
* kzp	запланированное количество 
lparameters parNozap,parKzp

local mmshwz,mmkornd,mmvidrab,mmkodm,mmdu
local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select * from ww where nozap = ?parnozap')
	if rr = -1
		eodbc('add_wwlim connection pass 1')
		return
	endif	
	mmshwz = sqlresult.shwz
	mmkornd = sqlresult.kornd
	mmvidrab = sqlresult.vidrab
	mmkodm   = sqlresult.kodm
	mmdu = sqlresult.d_u
	sqldisconnect(hh)
else
	eodbc()
	return
endif

*!*	* проверить нет ли уже детали с таким кор№ и шифром запуска в wwlim
*!*	if mmdu = 1
*!*		local hh1,rr1
*!*		hh1 = sqlconnect('sqldb','sa','111')
*!*		if hh1 > 0
*!*			rr1 = sqlexec(hh1,'select * from wwlim where rtrim(shwz) = rtrim(?m.mmshwz) '+;
*!*				'and rtrim(kornd) = rtrim(?m.mmkornd) and '+;
*!*				'kodm = ?m.mmkodm')
*!*			if rr1 = -1
*!*				eodbc('add_wwlim duplicate testing')
*!*				return
*!*			else
*!*				select sqlresult
*!*				if reccount()>0				&& такая запись уже введена ранее ничего не пишем
*!*					sqldisconnect(hh1)
*!*					return
*!*				endif
*!*			endif

*!*			sqldisconnect(hh1)
*!*		else
*!*			eodbc('add_wwlim connection')
*!*			return
*!*		endif
*!*	endif

* select from ww
local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select * from ww where nozap = ?parnozap')
	if rr = -1
		eodbc('add_wwlim connection pass 2')
		return
	endif	
else
	eodbc()
	return
endif

* формирование лимиток на выдачу материала
select * from sqlresult into cursor c100
if reccount()>0
	do 	case
		case 	c100.vidrab = 1 or (inlist(c100.vidrab,5,2,6,7,8) and c100.d_u = 1)
			
			local newid
			newid = 0

			if c100.vidrab = 1 or (inlist(c100.vidrab,5,2,6,7,8) and c100.d_u = 1)
				local hhh
				hhh = sqlconnect('sqldb','sa','111')
				if hhh > 0
					local rrr
					local mdat,mshwz,mpoznd,mkornd,mnaimd,mkodm,mkol,msklad,mvidrab,mnom,mstroka,mkzp
					local mres
					
					m.mdat		= date()
					m.mshwz		= c100.shwz
					m.mpoznd	= c100.poznd
					m.mkornd	= c100.kornd
					m.mnaimd	= get_naimd_by_kornd_and_shwz(c100.kornd,c100.shwz)
					m.mkodm		= c100.kodm
					m.mkol		= c100.nrmd * parkzp
					m.msklad	= 0
					m.mvidrab	= c100.vidrab
					m.mnom		= 0
					m.mstroka	= 0
					m.mkzp		= parkzp
					if !isdub(mshwz,mkornd,mkodm)

						mres = 0
						rrr = sqlexec(hhh,'exec my_add_wwlim ?m.mdat,?m.mshwz,?m.mpoznd,?m.mkornd,?m.mnaimd,?m.mkodm,?m.mkol,?m.msklad,?m.mvidrab,?m.mnom,?m.mstroka,?m.mkzp,?@mres')
						if rrr = -1
							eodbc('add_wwlim vidrab1')
						else
							newid = m.mres
							insert_into_wwpz(newid,-1)
						endif
					endif
					
					sqldisconnect(hhh)
				else
					eodbc('wwlim')
				endif			
			endif
			
		case c100.vidrab = 5 and (c100.d_u = 2 or c100.d_u = 3)

		
			local mshw,mkornd1,mkornd2,mlen,mkttp,mlen1,mlen2
			local id,dat,shwz,poznd,kornd,naimd,kodm,kol,sklad,vidrab,nom,stroka,kzp
			
			mshw = c100.shw
			
			mkornd = alltrim(c100.kornd)
			
			mlen1 = at('.',mkornd)
			mkornd1 = substr(mkornd,1,mlen1)
			
			mlen2 = len(alltrim(mkornd))
			mkornd2 = alltrim(mkornd)
		
			* обработать d_u = 1
			if glmar3 <> -1
				local hh_,rr_
				hh_ = sqlconnect('sqldb','sa','111')
				if hh_ > 0
					rr_ = sqlexec(hh_,'select * from ktshwz '+;
						'where rtrim(shwz) = rtrim(?mmshwz) and '+;
						'd_u = 1 and mar3 = ?m.glMar3','cdktshwz')
					if rr_ = -1
						eodbc('add_wwlim sele 1')
					endif						
					sqldisconnect(hh_)
				else
					eodbc('add_wwlim conn 1')
				endif				
			
				select * from cdktshwz ;
					where;
					substr(kornd,1,mlen1) = mkornd1 ;
					into cursor c120
				scan all
					m.dat = date()
					m.shwz = c100.shwz
					m.poznd = c120.poznd
					m.kornd = c120.kornd
					m.naimd = c120.naimd
					m.kodm = c120.kodm
					m.kol = c100.nrmd * parkzp
					m.sklad = 0
					m.vidrab = c100.vidrab
					m.nom = 0
					m.stroka = 0
					m.kzp = 0
					
					local mres
					mres = 0
					
					local hhh					
					hhh = sqlconnect('sqldb','sa','111')
					if hhh > 0
						if !isdub(m.shwz,m.kornd,m.kodm)

							local rrr
							local mres
							rrr = sqlexec(hhh,'exec my_add_wwlim ?m.dat,?m.shwz,?m.poznd,?m.kornd,?m.naimd,?m.kodm,?m.kol,'+;
								'?m.sklad,?m.vidrab,?m.nom,?m.stroka,?m.kzp,?@mres')
							if rrr = -1
								eodbc('add_wwlim vidrab 5 adding')
							else
								insert_into_wwpz(m.mres,-1)
							endif

						endif
																
						sqldisconnect(hhh)
					else
						eodbc('add_wwlim vidrab 5 connection')
					endif
					 
				endscan 	
				use in c120	
			endif
			
			* обработать d_u = 4
			local hh_,rr_
			hh_ = sqlconnect('sqldb','sa','111')
			if hh_ > 0
				rr_ = sqlexec(hh_,'select * from ktshwz '+;
					'where rtrim(shwz) = rtrim(?m.mmshwz) and '+;
					'd_u = 4','cdktshwz')
				if rr_ = -1
					eodbc('add_wwlim sele 2')
				endif				
				sqldisconnect(hh_)
			else
				eodbc('add_wwlim conn 2')
			endif
			
			select * from cdktshwz ;
				where;
				substr(kornd,1,mlen1) == mkornd1 ;
				into cursor c120
			scan all
				m.dat = date()
				m.shwz = c100.shwz
				m.poznd = c120.poznd
				m.kornd = c120.kornd
				m.naimd = c120.naimd
				m.kodm = c120.kodm
				m.sklad = 0
				m.vidrab = c100.vidrab
				m.nom = 0
				m.stroka = 0
				m.kzp = 0
				
				if c120.ei = c120.ei1 .or. empty(c120.ei1)
					m.kol = c120.kol * parKzp 	
				else
					m.kol = c120.kol1 * parKzp 	
				endif
				
				local mres
				mres = 0
				
				local hhh
				hhh = sqlconnect('sqldb','sa','111')
				if hhh > 0
					if !isdub(m.shwz,m.kornd,m.kodm)
						local rrr
						rrr = sqlexec(hhh,'exec my_add_wwlim ?m.dat,?m.shwz,?m.poznd,?m.kornd,'+;
							'?m.naimd,?m.kodm,?m.kol,'+;
							'?m.sklad,?m.vidrab,?m.nom,?m.stroka,?m.kzp,?@mres')
						if rrr = -1
							eodbc('add_wwlim d_u=4 vidrab=5 adding')
						else
							insert_into_wwpz(m.mres,-1)
						endif
					endif
														
					sqldisconnect(hhh)					
				else
					eodbc('add_wwlim d_u=4 vidrab=5 connection')
				endif

			endscan
			use in c120
			
			* обработать d_u = 5
			local hh_,rr_
			hh_ = sqlconnect('sqldb','sa','111')
			if hh_ > 0
				rr_ = sqlexec(hh_,'select * from ktshwz '+;
					'where rtrim(shwz) = rtrim(?m.mmshwz) and '+;
					'd_u = 5','cdktshwz')
				if rr_ = -1
					eodbc('add_wwlim sele 3')
				endif			
				sqldisconnect(hh_)
			else
				eodbc('add_wwlim conn 3')
			endif			
			 
			select * from cdktshwz ;
				where;
				(substr(kornd,1,mlen2) == mkornd2 and ;
				(substr(kttp,1,11) == '06024.55288' or substr(kttp,1,11) == '06024.55285' or ;
				substr(kttp,1,11) == '06024.55220' or substr(kttp,1,11) == '06024.55206') and ;
				left(kornd,3) <> '1.0');
				or (left(kornd,3) == '1.0' and empty(kttp));
				into cursor c120
			scan all
				m.dat = date()
				m.shwz = c100.shwz
				m.poznd = c120.poznd
				m.kornd = c120.kornd
				m.naimd = c120.naimd
				m.kodm = c120.kodm
				m.sklad = 0
				m.vidrab = c100.vidrab
				m.nom = 0
				m.stroka = 0
				m.kzp = 0
				
				m.kol = c120.nrmd * parKzp 	

				local mres
				mres = 0
				
				local hhh
				hhh = sqlconnect('sqldb','sa','111')
				if hhh > 0
				
					if !isdub(m.shwz,m.kornd,m.kodm)

						local rrr
						rrr = sqlexec(hhh,'exec my_add_wwlim ?m.dat,?m.shwz,?m.poznd,?m.kornd,?m.naimd,'+;
							'?m.kodm,?m.kol,'+;
							'?m.sklad,?m.vidrab,?m.nom,?m.stroka,?m.kzp,?@mres')
						if rrr = -1
							eodbc('add_wwlim d_u=5 vidrab=5 adding')
						else
							insert_into_wwpz(m.mres,-1)
						endif

					endif
														
					sqldisconnect(hhh)
				else
					eodbc('add_wwlim d_u=5 vidrab=5 connection')
				endif
			endscan
			use in c120

		case inlist(c100.vidrab,6,7,8)
		
			local mshw,mkornd1,mkornd2,mlen,mkttp,mlen1,mlen2
			local id,dat,shwz,poznd,kornd,naimd,kodm,kol,sklad,vidrab,nom,stroka,kzp
			
			mshw = c100.shw
			
			mkornd = alltrim(c100.kornd)
			
			mlen1 = at('.',mkornd)
			mkornd1 = substr(mkornd,1,mlen1)
			
			mlen2 = len(alltrim(mkornd))
			mkornd2 = alltrim(mkornd)
		
			* обработать d_u = 1
			if glmar3 <> -1
				local hh_,rr_
				hh_ = sqlconnect('sqldb','sa','111')
				if hh_ > 0
					rr_ = sqlexec(hh_,'select * from ktshwz '+;
						'where rtrim(shwz) = rtrim(?m.mmshwz) and d_u = 1 and '+;
						'mar3 = ?m.glMar3','cdktshwz')
					if rr_ = -1
						eodbc('add_wwlim sele 4')
					endif					
					sqldisconnect(hh_)
				else
					eodbc('add_wwlim conn 4')
				endif			
			
				select * from cdktshwz ;
					where;
					substr(kornd,1,mlen1) = mkornd1;
					into cursor c120
				scan all
					*m.id = get_newkod('wwlim')
					m.dat = date()
					m.shwz = c100.shwz
					m.poznd = c120.poznd
					m.kornd = c120.kornd
					m.naimd = c120.naimd
					m.kodm = c120.kodm
					m.kol = c100.nrmd * parkzp
					m.sklad = 0
					m.vidrab = c100.vidrab
					m.nom = 0
					m.stroka = 0
					m.kzp = 0
					
					*** <<< insert into wwlim from memvar >>>
					
					local mres 
					mres = 0
					
					local hhh
					hhh = sqlconnect('sqldb','sa','111')
					if hhh > 0
						if !isdub(m.shwz,m.kornd,m.kodm)

							local rrr
							rrr = sqlexec(hhh,'exec my_add_wwlim ?m.dat,?m.shwz,?m.poznd,?m.kornd,?m.naimd,?m.kodm,?m.kol,'+;
								'?m.sklad,?m.vidrab,?m.nom,?m.stroka,?m.kzp,?@mres')
							if rrr = -1
								eodbc('add_wwlim vidrab 6 7 8   du=1 exec')
							else
								insert_into_wwpz(m.mres,-1)
							endif

						endif
						
						sqldisconnect(hhh)					
					else
						eodbc('add_wwlim vidrab 6 7 8   du=1 connection')
					endif
				endscan 	
				use in c120	
			endif
			
			* обработать d_u = 4
			local hh_,rr_
			hh_ = sqlconnect('sqldb','sa','111')
			if hh_ > 0
				rr_ = sqlexec(hh_,'select * from ktshwz '+;
					'where rtrim(shwz) = rtrim(?m.mmshwz) and d_u = 4 '+;
					'','cdktshwz')
				if rr_ = -1
					eodbc('add_wwlim sele 5')
				endif			
				sqldisconnect(hh_)
			else
				eodbc('add_wwlim conn 5')
			endif
			
			select * from cdktshwz ;
				where;
				substr(kornd,1,mlen1) == mkornd1 ;
				into cursor c120
			scan all
				*m.id = get_newkod('wwlim')
				m.dat = date()
				m.shwz = c100.shwz
				m.poznd = c120.poznd
				m.kornd = c120.kornd
				m.naimd = c120.naimd
				m.kodm = c120.kodm
				m.sklad = 0
				m.vidrab = c100.vidrab
				m.nom = 0
				m.stroka = 0
				m.kzp = 0
				
				if c120.ei = c120.ei1 .or. empty(c120.ei1)
					m.kol = c120.kol * parKzp 	
				else
					m.kol = c120.kol1 * parKzp 	
				endif

				*** <<<insert into wwlim from memvar>>>
				
				local mres
				mres = 0
				
				local hhh
				hhh = sqlconnect('sqldb','sa','111')
				if hhh > 0
					if !isdub(m.shwz,m.kornd,m.kodm)

						local rrr
						rrr = sqlexec(hhh,'exec my_add_wwlim ?m.dat,?m.shwz,?m.poznd,?m.kornd,?m.naimd,?m.kodm,?m.kol,'+;
							'?m.sklad,?m.vidrab,?m.nom,?m.stroka,?m.kzp,?@mres')
						if rrr = -1
							eodbc('add_wwlim vidrab 6 7 8   du=4 adding')
						else
							insert_into_wwpz(mres,-1)
						endif

					endif
								
					sqldisconnect(hhh)		
				else
					eodbc('add_wwlim vidrab 6 7 8   du=4 connection')
				endif
								
				*** <<<insert into wwpz (nomlim, nompz) values (m.id, -1)	>>>
				*** <<<insert_into_wwpz(m.id,-1)>>>
				
			endscan
			use in c120
			
			* обработать d_u = 5 
			local hh_,rr_
			hh_ = sqlconnect('sqldb','sa','111')
			if hh_ > 0
				rr_ = sqlexec(hh_,'select * from ktshwz '+;
					'where rtrim(shwz) = rtrim(?m.mmshwz) and d_u = 5','cdktshwz')
				if rr = -1
					eodbc('add_wwlim sele 6')
				endif
				sqldisconnect(hh_)
			else
				eodbc('add_wwlim conn 6')
			endif
			
			select * from cdktshwz ;
				where;
				substr(kornd,1,mlen2) == mkornd2;
				into cursor c120
			scan all
				*m.id = get_newkod('wwlim')
				m.dat = date()
				m.shwz = c100.shwz
				m.poznd = c120.poznd
				m.kornd = c120.kornd
				m.naimd = c120.naimd
				m.kodm = c120.kodm
				m.sklad = 0
				m.vidrab = c100.vidrab
				m.nom = 0
				m.stroka = 0
				m.kzp = 0
				
				m.kol = c120.nrmd * parKzp 	
				
				*** <<<insert into wwlim from memvar >>>
				
				local mres
				mres = 0
				
				local hhh
				hhh = sqlconnect('sqldb','sa','111')
				if hhh > 0
				
				
					if !isdub(m.shwz,m.kornd,m.kodm)
						local rrr
						rrr = sqlexec(hhh,'exec my_add_wwlim ?m.dat,?m.shwz,?m.poznd,?m.kornd,?m.naimd,?m.kodm,?m.kol,'+;
							'?m.sklad,?m.vidrab,?m.nom,?m.stroka,?m.kzp,?@mres')
						if rrr = -1
							eodbc('add_wwlim vidrab 6 7 8   du=5 adding')
						else
							insert_into_wwpz(mres,-1)
						endif
					endif
				
				
					sqldisconnect(hhh)		
				else
					eodbc('add_wwlim vidrab 6 7 8   du=5 connection')
				endif
			endscan
			use in c120
					
		case	c100.vidrab >= 2 .and. c100.vidrab <= 4		
		
			local mshw,mkornd,mlen,mkttp
			
			mshw = c100.shw
			
			* найти точку в коротком номере и др.
			mkornd = alltrim(c100.kornd)
			
			&& mkttp = c100.kttp
			mkttp = get_kttp_by_vidrab(c100.vidrab)
			
			local hh_,rr_
			hh_ = sqlconnect('sqldb','sa','111')
			if hh_ > 0
				rr_ = sqlexec(hh_,'select * from ktshwz '+;
					'where rtrim(shwz) = rtrim(?m.mmshwz) and d_u = 5','cdktshwz')
				if rr = -1
					eodbc('add_wwlim sele 7')
				endif	
				sqldisconnect(hh_)
			else
				eodbc('add_wwlim conn 7')
			endif
			
			select * from cdktshwz ;
				where ;
					substr(kornd,1,len(mkornd)) == mkornd and;
					!empty(kttp) and ;
					left(kttp,11) == mkttp;
				into cursor c115
			scan all
				
				local newid
			 	*newid = get_newkod('wwlim')
				
			  	local mkol
				do	case
					case	c115.d_u = 4
					 	if (c115.ei = c115.ei1) or (empty(c115.ei1))
							mkol = c115.kol*parKzp 
						else
							mkol = c115.kol1*parKzp
						endif
					case	c115.d_u = 5
						mkol = c115.nrmd*parKzp
				endcase
				
				local hhh
				hhh = sqlconnect('sqldb','sa','111')
				if hhh > 0
					local rrr
					local mres
					local mdat,mshwz,mpoznd,mkornd,mnaimd,mkodm,mkol,msklad,mvidrab,mnom,mstroka,mkzp
					
					mres = 0
					
					m.mdat		= date()
					m.mshwz		= c100.shwz
					m.mpoznd	= c115.poznd
					m.mkornd		= c115.kornd
					m.mnaimd		= get_naimd_by_kornd_and_shwz(c115.kornd,c100.shwz)
					m.mkodm		= c115.kodm
					m.mkol		= m.mkol
					m.msklad	= 0
					m.mvidrab	= c100.vidrab
					m.mnom		= 0
					m.mstroka	= 0
					m.mkzp		= parkzp
					
					
					
					if !isdub(m.mshwz,m.mkornd,m.mkodm)
						rrr = sqlexec(hhh,'exec my_add_wwlim ?m.mdat,?m.mshwz,?m.mpoznd,'+;
							'?m.mkornd,?m.mnaimd,?m.mkodm,?m.mkol,?m.msklad,?m.mvidrab,'+;
							'?m.mnom,?m.mstroka,?m.mkzp,?@mres')
						if rrr = -1
							eodbc('add_wwlim vidrab 2 3 4 adding')
						else
							insert_into_wwpz(m.mres,-1)
						endif
					endif
										
					sqldisconnect(hhh)
				else
					eodbc('add_wwlim vidrab 2 3 4 connection')
				endif
				
			endscan 	
			use in c115		

	endcase
else
	wait window nowait 'Не найдена запись!' 
endif
use in c100

sqldisconnect(hh)

**********************************************
* проверяем есть ли дублирующаяся запись в wwlim
* для такого же kornd shwz kodm
function isdub(parshwz,parkornd,parkodm)
	local hh,rr
	local res
	res = .f.
	hh = sqlconnect('sqldb','sa','111')
	if hh > 0
		rr = sqlexec(hh,'select top 1 * from wwlim where '+;
			'rtrim(shwz) = rtrim(?parshwz) and rtrim(kornd) = rtrim(?parkornd) and '+;
			'kodm = ?parkodm','cdd1')
		if rr = -1
			eodbc('add_wwlim isdub sele')
		endif	
		if reccount()>0
			res = .t.
		endif		
		use in cdd1
		sqldisconnect(hh)
	else
		eodbc('add_wwlim isdub conn')
	endif	
	return res
endfunc 