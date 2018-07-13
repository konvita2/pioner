local aa 
aa = createobject('cls_dosp2')

aa.FindByKod(20)

? aa.Im

aa.New()
aa.Kod = 1000
aa.Im = 'Test appartment'
? aa.Save()





define class cls_dosp2 as Custom 

	* props
	Kod 	= 0
	Im 		= ''
	Us		= 0.0
	Obor	= ''
	
	* Object state
	* can be
	* 0 - usual state
	* 1 - adding state
	mStat	= 0
	
	* Result 
	* can be
	* 0 - is OK
	* 1 - error (depends on Method)
	mRes	= 0
	
	* methods
	
	* FindByKod
	procedure FindByKod(parkod as Integer)
		local hh,rr
		hh = sqlconnect('sqldb','sa','111')
		if hh > 0
			rr = sqlexec(hh,'select * from dosp where vid=2 and kod=?parkod')
			if rr = -1
				eodbc()
			else
				select sqlresult
				if reccount()>0
					this.Kod 	= sqlresult.kod
					this.Im		= sqlresult.im
					this.Us		= sqlresult.us
					this.Obor	= sqlresult.obor
				endif
			endif
			
			sqldisconnect(hh)
		else
			eodbc()
		endif		
	endproc 
	
	* New
	procedure New()
		this.Kod	= 0
		this.Im		= ''
		this.Us		= 0
		this.Obor	= ''
	endproc 
	
	* Save
	* states
	function Save()
		local res
		local hh,rr
		res = -1
		hh = sqlconnect('sqldb','sa','111')
		if hh > 0
			rr = sqlexec(hh,'insert into dosp (kod,vid,im,us,obor) values (?this.kod,2,?this.im,?this.us,?this.obor)')
			if rr = -1
				eodbc()
			else
				res = this.kod	
			endif		
		else
			eodbc()
		endif
		return res
	endfunc
	
	* Delete
	procedure Del()
		
		
	endproc 

enddefine



