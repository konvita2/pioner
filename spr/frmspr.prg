PARAMETERS name_spr, oname,al
PUBLIC to_im
LOCAL rnspr
STORE 0 TO rnspr
IF VARTYPE(oname)="C"
	oname1=oname
ELSE 
	oname1=.F.
ENDIF 
SELECT nozap,filedbf from sprav WHERE ALLTRIM(filedbf)==name_spr INTO CURSOR vspr_form
rnspr = vspr_form.nozap
WAIT WINDOW ALLTRIM(oname)+""+"from frmspr"
DO FORM fsprav WITH rnspr,oname1,al TO to_im