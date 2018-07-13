* проставить поле kod в kt
* запускается только один раз 

LOCAL par

USE kt
par = 1
SCAN ALL 
	replace kod WITH par
	par = par+1
ENDSCAN

USE IN kt
