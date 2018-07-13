* установить статус в записях limone
* которые соотвествуют записям в climonep
* (должен быть сформирован перед)
lparameters pStat 
local hh,rr,sq
local mshwz,mkodm

sq = 'update limone set status=?pStat where rtrim(shwz)=?mshwz and kodm=?mkodm'

hh = sqlcn()
if hh>0
	select climonep
	scan all	
		mshwz = alltrim(climonep.shwz)
		mkodm = climonep.kodm
	
		rr = sqlexec(hh,sq)
		if rr = -1
			eodbc('limone_status upd')
			return
		endif
	endscan
else
	eodbc('limone_status conn')
endif