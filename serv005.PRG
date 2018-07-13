lparam parInvn, parChas
local llRes,svWA,svEmp

m.svWA = select()

m.llRes = .f.

* должен быть открыт kp с индексом iii в алиасе kp_assist
select kp_assist
seek parInvn + str(parChas,4)

do case
	case !empt(kp_assist.shwz)
		m.llRes = .f.
	case kp_assist.chas = 1 and empt(kp_assist.shwz)
		m.llRes = .t.
	case kp_assist.chas <> 1
		m.svEmp = kp_assist.shwz
		skip -1
		if empty(m.svEmp) <> empty(kp_assist.shwz)			
			m.llRes = .t.
		else
			m.llRes = .f.
		endif
endcase

select (svWA)

return m.llRes