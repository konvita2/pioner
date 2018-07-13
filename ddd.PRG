SET DATE BRITISH
ON KEY LABEL F12 RETU
g=2008
m=6
d=3
sd=DATE()
IF YEAR(sd)>=g AND MONTH(sd)>=m AND DAY(sd)>=d
	DO WHILE .t.
		
		IF YEAR(sd)=g AND MONTH(sd)=m AND DAY(sd)=d
			
			WAIT WINDOW 'opa!   '+DTOC(sd)
			EXIT
		ENDIF
		sd=sd-1
		WAIT WINDOW '- 1    '+DTOC(SD)	
	enddo
ELSE
	DO WHILE .t.
		sd=sd+1
		WAIT WINDOW '+ 1    '+ DTOC(SD)
		IF YEAR(sd)=g AND MONTH(sd)=m AND DAY(sd)=d
			WAIT WINDOW 'opa! '+DTOC(sd)
			EXIT
			
		endif	
	enddo
endif