USE vrem7
DO while .not. EOF()
	WAIT 'press' WINDOW 
	SCAN NEXT 10
		? SUBSTR(vrem7.st,1,80)
	ENDSCAN 
ENDDO 	