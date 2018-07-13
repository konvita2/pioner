lparameters parPoznw
local mres 

mres = ''

select naimw from kt where !empty(naimw) and !empty(poznw) and alltrim(poznw) == alltrim(parPoznw) into cursor c700
if reccount()>0
	mres = c700.naimw
endif
use in c700

return mres