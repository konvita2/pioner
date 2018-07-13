 lparameters parTabn

local svRes
local svWA

m.svWA = select(0)

	select * from kadry ;
		where tn = m.parTabn ;
		into cursor cc_kadry
	if reccount()>0
		m.svRes = cc_kadry.vr
	else
		m.svRes = 0
	endif	
	use in cc_kadry	

select (svWA)

return m.svRes