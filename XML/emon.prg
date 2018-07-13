* получить дату конца мес€ца
lparameters parDat
local svMon,svDat,svCurDat

svMon=month(parDat) 
svDat=parDat
svCurDat=parDat

do while month(svCurDat)=svMon
	svDat=svCurDat
	svCurDat=svCurDat+1	
enddo

return svDat