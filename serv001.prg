****************************************
* it uses for v_matras 
* get post_naim
	lparam parVid,parKod
	local svWA,cRes
	m.svWA = select()
	if m.parVid = 0
		select * from db!v_dosp2 where kod = m.parKod into cursor c_serv001
		if recc() > 0
			m.cRes = c_serv001.im
		else
			m.cRes = "(не выбран)"
		endif 
		use in c_serv001
	else
		select * from db!v_post where id = m.parKod into cursor c_serv001
		if recc() > 0
			m.cRes = c_serv001.im
		else
			m.cRes = "(не выбран)"
		endif 
		use in c_serv001
	endif	
	select (m.svWA)
	return m.cRes



