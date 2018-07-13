SELECT strizd
e=0
SCAN
	e=e+1 
	REPLACE key WITH ALLTRIM(STR(e)+"_")
endscan  