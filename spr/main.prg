*CLOSE all
CLOSE DATABASES
OPEN DATABASE data2
*use sprav 	 
SET CLASSLIB TO "D:\A1\mylib"
DO menu1.mpr
DO FORM spl
*DO tlbr
READ EVENTS 


CLOSE DATABASES 