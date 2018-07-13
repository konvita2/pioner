PARAMETERS prm
LOCAL rn_sp 
STORE 0 TO rn_sp
SELECT sprav
SELECT nozap,key,parent,text FROM sprav;
WHERE ALLTRIM(text)==PROMPT() INTO CURSOR vsprav 
IF  ALLTRIM(vsprav.text) = prm
	rn_sp=vsprav.nozap
	DO form fsprav WITH rn_sp
ENDIF 
