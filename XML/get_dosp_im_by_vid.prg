lparameters parvid
local mres,rr,hh

mres = ''

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from dosp where kod=0 and vid=?parvid','cvid')
	if rr = -1
		eodbc('get_dosp_im_by_vid sele')
	endif

	select cvid
	if reccount()>0
		mres = alltrim(cvid.im)
	endif
	
	use in cvid
	sqldisconnect(hh)
else
	eodbc('get_dosp_im_by_vid conn')
endif

return mres
