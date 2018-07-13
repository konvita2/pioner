* ãåíåðèðîâàòü ïëàí-çàäàíèå

lparameters parmar,pardat,parnarid
local mnzad

mnzad = glnzad

*!*	 if mnzad = 0	&& èùåì íîâûé íîìåð çàäàíèÿ
*!*	 	select nzad from pz order by nzad into cursor cpz
*!*	 	if reccount()>0
*!*	 		go bottom
*!*	 		mnzad = 1+cpz.nzad
*!*	 	else
*!*	 		mnzad = 1
*!*	 	endif
*!*	 	use in cpz
*!*
*!*	 	glNzad = mnzad
*!*
*!*	 endif

if mnzad = 0
	mnzad = get_newkod('nzad')
	glNzad = mnzad
endif

* ÇÀÏÈÑÜ ÇÀÃÎËÎÂÊÀ
* ïðîâåðèòü åñòü ëè òàêîé çàãîëîâîê
local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0

	local rr1
	rr1 = sqlexec(hh,'select * from pz where nzad = ?mnzad and mar = ?parmar')
	do case
		case	rr1 = -1
			eodbc()
		otherwise
			select sqlresult
			if reccount()=0
				local rr2
				rr2 = sqlexec(hh,'insert into pz (nzad,mar,dat,vid) values (?mnzad,?parmar,?pardat,0)')
				do	case
					case	rr2 = -1
						eodbc()
				endcase
			endif 
	endcase 
	
	local rr2
	rr2 = sqlexec(hh,'update wwpz set nompz = ?mnzad where nompz = -1')
	if rr2 = -1
		eodbc()
	endif	

else
	eodbc()
endif

*** <<<<<<
* ÇÀÏÈÑÜ ÇÀÃÎËÎÂÊÀ
* ïðîâåðèòü åñòü ëè òàêîé çàãîëîâîê
*!*	select * from pz where nzad = mnzad and mar = parmar into cursor cpz
*!*	if reccount()=0	&& åñëè íåò òàêîãî çàãîëîâêà - äîáàâèòü
*!*		local id,mar,nzad,dat,vid

*!*		local newid
*!*		select id from pz order by id into cursor cid
*!*		if reccount()>0
*!*			go bottom
*!*			newid = 1+cid.id
*!*		else
*!*			newid = 1
*!*		endif
*!*		use in cid
*!*		id = newid

*!*		mar = parmar

*!*		dat = pardat

*!*		vid = 0

*!*		nzad = mnzad

*!*		insert into pz from memvar
*!*	endif
*!*	use in cpz

*!*	update wwpz set nompz = mnzad where nompz = -1
*** >>>

* ÇÀÏÈÑÜ ÒÀÁËÈ×ÍÎÉ ×ÀÑÒÈ
local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr4
	rr4 = sqlexec(hh,'insert into pzt (nzad,narid,mar) values (?m.mnzad,?m.parnarid,?m.parmar)')
	if rr4 = -1	
		eodbc()
	endif

	sqldisconnect(hh)
else
	eodbc()
endif

*** <<<
* ÇÀÏÈÑÜ ÒÀÁËÈ×ÍÎÉ ×ÀÑÒÈ
*!*	local id,nzad,narid,mar

*!*	local newid
*!*	select id from pzt order by id into cursor cid
*!*	if reccount()>0
*!*		go bottom
*!*		newid = 1+cid.id
*!*	else
*!*		newid = 1
*!*	endif
*!*	use in cid
*!*	id = newid

*!*	nzad = mnzad

*!*	narid = parnarid

*!*	mar = parmar

*!*	insert into pzt from memvar

*** >>>

return
