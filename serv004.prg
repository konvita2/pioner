lparam parInvn, parChas

local svWA, lnFree

m.lnFree = 0

m.svWA = select()

select kp_assist1
seek m.parInvn+str(m.parChas,4)
do while !eof()	
	if !empty(kp_assist1.shwz)
		exit
	endif
	if kp_assist1.invn # m.parInvn
		exit	
	endif	
	m.lnFree = m.lnFree+1
	skip
enddo

*!*		select * from kp ;
*!*			where invn = m.parInvn and chas >= m.parChas ;
*!*			order by chas ;
*!*			into cursor c800
*!*		scan all
*!*			if !empty(c800.shwz)
*!*				exit
*!*			endif
*!*			m.lnFree = m.lnFree+1
*!*		endscan
*!*		use in c800	

select (m.svWA)

return m.lnFree

