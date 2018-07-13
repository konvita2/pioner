lparameters parSim
local hh,rr,res

res = 0

hh = sqlconnect('sqldb', 'sa', '111')
if hh > 0
	local rr
	rr = sqlexec(hh, 'SELECT * FROM vdosp9 WHERE sim = ?parSim', 'cdosp91')
	if rr > 0
		select cdosp91
		res = cdosp91.us
	endif
	use in cdosp91
else
	eodbc('get_mus_9')
endif

return res
