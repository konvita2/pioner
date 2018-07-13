local lcFile,lcFound

* получить имя файла для обмена
m.lcFile = getnastr('ostatpath')

if empty(m.lcFile)
	wait 'Не удалось найти имя файла в файле nastr! Закачка не может быть выполнена.' window nowait	
	return
endif

* закачка списка складов/подразделений из 444
*	select distinct kodskl, namskl from (lcFile) into cursor c400

*	if reccount() > 0

*		wait 'Осистка предыдущего списка подразделений' wind nowait
*		delete from dosp where vid = 2 and kod <> 0
*		wait 'Выполняется обновление списка подразделений...' wind nowait	
*		select c400
*		scan all
*			insert into dosp ;
*				(vid,kod,im, ;
*				sim, us, obor) ;
*				values ;	
*				(2, c400.kodskl, c400.namskl, ;
*				'',0,'' )	
*		endscan		
*		
*		insert into dosp ;
*			(vid,kod,im) ;
*			values ;
*			(2, 9999, '(не указан)')
*		
*	else
*		wait 'Обновление справочника подразделений не было выполнено т.к. список пуст' nowait wind 
*	endif

*	use in c400

* ============== новый вариант
select kodskl,kodtmz,kodspektr,kodeizm,kol,sum ;
	from (lcfile) ;
	where kol <> 0 and kodspektr <> 0 into cursor c400
if reccount()>0
	*** очистка таблицы
	wait 'Удаление предыдуших остатков' nowait wind
	delete from ostatok
	***
	select c400
	scan all
		insert into ostatok ;
			(sklad_id, nsk, kodm, ;
			kol, cena, dat) ;
			values ;
			(c400.kodskl, c400.kodtmz, c400.kodspektr, ;
			c400.kol, c400.sum/c400.kol, date())
		*******************************************

		* зафиксировать изменение цены (С Д Е Л А Т Ь   П О П О З Ж Е)
		* update mater set cena = c400.sum/c400.kol where kodm = c400.kodspektr

	endscan
else
	wait 'Обновление справочника остатков не выполнено. Остатков нет ?' nowait wind
endif
use in c400

return

* //////////////////////////////////////////////
* ниже вариант до 31/10/2006
* закачка остатков из 444
select kodskl,kodtmz,kodspektr,kodeizm,kol,sum ;
	from (lcFile) ;
	where kol <> 0 into cursor c400

if recc() > 0
    *** очистка таблицы
	wait 'Удаление предыдуших остатков' nowait wind
	delete from ostatok
	*** закачка новых остатков
	wait 'Закачка новых остатков' nowait wind
	select c400
	scan all
		insert into ostatok ;
			(sklad_id, nsk, kodm, ;
			kol, cena, dat) ;
			values ;
			(c400.kodskl, c400.kodtmz, c400.kodspektr, ;
			c400.kol, c400.sum/c400.kol, date())	
		*******************************************
		UPDATE mater SET cena = c400.sum/c400.kol WHERE kodm = c400.kodspektr 	
	endscan	
	wait 'Обновление завершено' wind nowait
else
	wait 'Обновление справочника остатков не выполнено. Остатков нет ?' nowait wind	

endif

use in c400