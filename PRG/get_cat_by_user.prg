  * получить категорию по имени пользователя
 lparameters parNam
 local mres
 mres = 0
 
 select * from t1 where alltrim(nam) == alltrim(parNam) into cursor cc33
 if reccount()>0
 	mres = cc33.cat
 endif
 use in cc33
 
 return mres