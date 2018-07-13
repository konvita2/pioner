 LPARAMETERS parKey
 local res,svwa
 
 m.res = ''
 m.svwa = select()
 
 	select * from nastr where alltrim(m.parKey) == alltrim(nastr.key) ;
 		into cursor c_nastr
 		
 	if reccount() > 0
 		m.res = c_nastr.valu
 	endif	
 
 	use in c_nastr
 	
 select (svwa)
 
 RETURN m.res 