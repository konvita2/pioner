 ************************************
 * it used in v_techos
 lparam parKodm
 local cRes,svWA
 m.cRes = '(не найден с справочнике)'
 
 m.svWA = select()
 
 	select * from db!mater where kodm = m.parKodm ;
 		into cursor cc305
 		
 	if recc() > 0
 		m.cRes = cc305.naim 	
 	endif	
 		
 	use in cc305	
 
 select (m.svWA)
 
 return m.cRes