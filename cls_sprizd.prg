#include 'foxpro.h'
clear

local d as Boolean 
aa = createobject("SprIzd")

if aa.IsEmpty() 
	wait window 'Empty sprizd' 
endif

aa.NewEmpty
aa.kod = 1000
aa.naim = 'test izdelie'
aa.Write

release aa


***
define class SprIzd as custom
	id = 0
	kod = 0
	naim = ''
	oboz = ''
	shwz = ''
	***
	* 0 - no records
	* 1 - browse
	* 2 - new
	* 3 - edit
	state = 0
	
	*** 
	function IsEmpty() as Boolean 
		if this.id = 0
			return .t.
		else
			return .f.
		endif
	endfunc 
	
	*** delete record
	procedure Delete(parId)
		local svId
		svId = -1
		*** test if the passed id is exists
		*** checking (need to look all places where izd is used)
		*** delete if it possible
		delete from parId where id = parId
		
		this.LoadRecord(svId)
		*** find prev or next element
	endproc 
	
	*** edit record
	procedure Edit
		if this.id <> 0
			this.state = 3
		else
			this.state = 0
			wait window 'Изделия: нет записи для редактирования'
		endif	
	endproc 
	
	*** add empty record
	procedure NewEmpty
		this.kod = 0
		this.naim = ''
		this.oboz = ''
		this.shwz = ''
		*** 
		this.state = 2
	endproc 
	
	*** add partially filled record
	procedure NewPartial
		lparameters parKod,parNaim,parOboz,parShwz 
		this.kod = parKod
		this.naim = parNaim
		this.oboz = parOboz
		this.shwz = parShwz
		***
		this.state = 2
	endproc 
	
	*** write
	procedure Write
		local newid	
		do 	case
			case this.state = 2			&& new record
				*** get newid
				select * from izd order by id into cursor clc20
				if reccount()>0
					go bottom 
					newid = clc20.id + 1
				else
					newid = 1
				endif
				use in clc20
				*** save 
				insert into izd ;
					(id,kod,im,ribf,shwz);
					values;
					(newid,this.kod,this.naim,this.oboz,this.shwz)
				*** get last record
				this.LoadRecord(newid)
			case this.state = 3
				*** save
				update izd ;
					set;
						kod		= this.kod,;
						im		= this.naim,;
						ribf	= this.oboz,;
						shwz	= this.shwz;
					where id = this.id					
				*** get last record
				this.LoadRecord(this.id)
		endcase
	endproc
	
	*** load record
	procedure LoadRecord(parId)
		select * from izd where id = parId into cursor clc10
		if reccount()>0
			this.id = clc10.id
			this.kod = clc10.kod
			this.naim = alltrim(clc10.im)
			this.oboz = alltrim(clc10.ribf)
			this.shwz = alltrim(clc10.shwz)
			***
			this.state = 1
		else
			this.id = 0
			this.kod = 0
			this.naim = ''
			this.oboz = ''
			this.shwz = ''
			***
			this.state = 0
		endif
		use in clc10	
	endproc 
	 
	*** f i n d   i z d
	
	*** FindByKod
	procedure FindByKod(parKod)
		select * from izd;
			where kod = parKod;
			into cursor clc1
		if reccount()>0
			this.LoadRecord(clc1.id)
		else
			this.LoadRecord(-1)
		endif	
		use in clc1		
	endproc 
	
	*** FindByShwz
	procedure FindByShwz(parShwz)
		if !empty(parShwz)
			select * from izd;
				where alltrim(shwz) == alltrim(parShwz);
				into cursor clc10
			if reccount()>0
				this.LoadRecord(clc10.id)	
			else
				this.LoadRecord(-1)
			endif	
			use in clc10		
		else
			this.LoadRecord(-1)		
		endif
	endproc 	 
enddefine   
 

