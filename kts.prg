local lo1

lo1 = createobject("clsDet")

lo1.GoByKod(14828)
wait window lo1.kornd
wait window lo1.izdnaim

return 

* определение классов для отображения дерева

* ////////////////////////////////////////////////////
* clsDet
* класс для отображения детали
define class clsDet as Custom
    * служебные поля
    result  = 0   &&результат выполнения метода    
    * иерархия
    paren   = -1  &&код родителя
    child   = -1  &&код ребенка 
	* поля записи
	kod		= -1
	shw		= -1
	izdnaim = space(40)
	pozn	= space(20)
	d_u		= -1
	kornw	= space(7)
	poznw	= space(22)
	kornd	= space(7)
	poznd	= space(22)
	kodm	= -1
	ei		= space(15)
	rozma	= 0
	rozmb	= 0
	nrmd	= 0
	wag		= 0
	mz		= 0
	kol		= 0
	koli	= 0
	kttp	= space(20)
	datz	= date()
	kpi		= 0
	naimd 	= space(70)
	kolz	= 0
	ndok	= ''
	naimw	= space(70)
	razr	= space(12)
	mar1	= 0
	mar2	= 0
	mar3	= 0
	mar4	= 0
	mar5	= 0
	mar6	= 0
	mar7	= 0
	mar8	= 0
	mar9	= 0
	mar10	= 0
	pu		= 0
	zo		= 0
	eskiz	= 0
	plopok	= space(7)
	pokr	= space(12)
	kodm1	= -1
	mark	= .f.
	porad	= 0
	kodm_n	= space(68)
	kodm1_n	= space(68)
	mar1n 	= ''	&& имена участков
	mar2n 	= ''
	mar3n 	= ''
	mar4n 	= ''
	mar5n 	= ''
	mar6n 	= ''
	mar7n 	= ''
	mar8n 	= ''
	mar9n 	= ''
	mar10n 	= ''
	
	* ==========================================================
	* получить код родителя
	function GetParent()
		return paren
	endfunc
	
	* ==========================================================
	* получить код ребенка
	function GetChild()
		return child
	endfunc
	
	* ==========================================================
	* это деталь
	function IsDetal()
		return this.d_u = 1
	endfunc
	
	* ==========================================================
	* это узел
	function IsUsel()
		return this.d_u = 2
	endfunc
	
	* ==========================================================
	* это изделие
	function IsIzdel()
		return this.d_u = 3
	endfunc
	
	* ==========================================================
	* перейти на запись с указанным кодом и загрузить параметры
	procedure GoByKod(parKod)
		select * from kt where kod = m.parKod into cursor kts100
		if reccount()>0
			this.kod 		= m.parKod
			this.kornd 		= kts100.kornd
			this.shw		= kts100.shw
			this.pozn		= kts100.pozn
			this.d_u		= kts100.d_u
			this.kornw		= kts100.kornw
			this.poznw		= kts100.poznw
			this.poznd		= kts100.poznd
			this.kodm		= kts100.kodm
			this.ei			= kts100.ei
			this.rozma		= kts100.rozma
			this.rozmb		= kts100.rozmb
			this.nrmd		= kts100.nrmd
			this.wag		= kts100.wag
			this.mz			= kts100.mz
			this.kol		= kts100.kol
			this.koli		= kts100.koli
			this.kttp		= kts100.kttp
			this.datz		= kts100.datz
			this.kpi		= kts100.kpi
			this.naimd		= kts100.naimd
			this.kolz		= kts100.kolz
			this.ndok		= kts100.ndok
			this.naimw		= kts100.naimw
			this.razr		= kts100.razr
			this.mar1		= kts100.mar1
			this.mar2		= kts100.mar2
			this.mar3		= kts100.mar3
			this.mar4		= kts100.mar4
			this.mar5		= kts100.mar5
			this.mar6		= kts100.mar6
			this.mar7		= kts100.mar7
			this.mar8		= kts100.mar8
			this.mar9		= kts100.mar9
			this.mar10		= kts100.mar10
			this.pu			= kts100.pu
			this.zo			= kts100.zo
			this.eskiz		= kts100.eskiz
			this.plopok		= kts100.plopok
			this.pokr		= kts100.pokr
			this.kodm1		= kts100.kodm1
			this.mark		= kts100.mark			
			
			* get izdnaim
			select * from izd where kod = kts100.shw into cursor kts101
			if reccount()>0
				this.izdnaim = kts101.im
			else
				this.izdnaim = ''
			endif
			use in kts101			
			* get kodm_n
			select * from mater where kodm = kts100.kodm into cursor kts101
			if reccount()>0
				this.kodm_n = kts101.naim
			else
				this.kodm_n = ''
			endif
			use in kts101 
			* get kodm1_n
			select * from mater where kodm = kts100.kodm1 into cursor kts101
			if reccount()>0
				this.kodm1_n = kts101.naim
			else
				this.kodm1_n = ''
			endif
			use in kts101 			
			* заполнить имена маршрутов	
			this.mar1n	= get_dosp2(this.mar1)
			this.mar2n	= get_dosp2(this.mar2)
			this.mar3n	= get_dosp2(this.mar3)
			this.mar4n	= get_dosp2(this.mar4)
			this.mar5n	= get_dosp2(this.mar5)
			this.mar6n	= get_dosp2(this.mar6)
			this.mar7n	= get_dosp2(this.mar7)
			this.mar8n	= get_dosp2(this.mar8)
			this.mar9n	= get_dosp2(this.mar9)
			this.mar10n	= get_dosp2(this.mar10)

			* результат
			this.result = 1 				
		else
		
			* результат
			this.result = 0
		endif
		use in kts100
	endproc
enddefine

* ////////////////////////////////////////////////////////
* clsKTS 
* класс для работы с набором деталей (коллекция)