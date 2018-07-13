* добавить указанное кол-во месяцев к дате
lparameters parDat,parShiftMon
local res,svDat,svCurDat,d1,d2,d3

svDat=parDat
d1=day(parDat) 
d2=month(parDat)
d3=0

do while .t.
	*
	if month(svDat)<>d2
		d3=d3+1
		d2=month(svDat)
	endif
	if d1=day(svDat) and d3=abs(parShiftMon)
		exit
	endif
	*
	if parShiftMon >= 0 
		svDat=svDat+1
	else
		svDat=svDat-1
	endif	
enddo

res = svDat
return res
