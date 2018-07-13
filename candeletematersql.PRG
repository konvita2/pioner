* test if kodm can be deleted
* return 
*   0 - ok can be delete
*  -1 - ktfull uses kodm
*  -2 - rast uses kodm
*  -3 - ostatok uses kodm
lparameters parkodm

local res
res = 0

local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	* test ktfull
	rr = sqlexec(hh,'select * from ktfull where kodm = ?parkodm','sqlres')
	if rr = -1
		eodbc('candeletematersql sele ktfull')
	else
		select sqlres
		if reccount()>0
			res = -1
		endif	
	endif
	
	* test rast 
	rr = sqlexec(hh,'select * from rast where kodm = ?parkodm','sqlres')
	if rr = -1
		eodbc('candeletematersql sele rast')
	else
		if reccount()>0
			res = -2
		endif	
	endif
	
	* test ostatok 
	rr = sqlexec(hh,'select * from ostatok where kodm = ?parkodm','sqlres')
	if rr = -1
		eodbc('candeletematersql sele ostatok')
	else
		if reccount()>0
			res = -3
		endif	
	endif

	sqldisconnect(hh)
else
	eodbc('candeletematersql conn')
endif

return res