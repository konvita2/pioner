*** �������� �������� ���������� ��������� �� ����
lparameters parKod
local mres
mres = ''

local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select * from dosp where kod = ?parkod and vid=23')
	if rr > 0
		mres = alltrim(sqlresult.im)
	else
		mres = ''
	endif

	sqldisconnect(hh)
else
	eodbc()
endif

return mres