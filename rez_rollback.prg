* выполняем возврат к предыдущему состоянию, для этого
* очищаем ostatki и raschet
* переносим все из ostatki1 и raschet1
* очищаем ostatki1 и raschet1

* проверяем можно ли выполнить откат
local kol1,kol2,ask,res
local a[1]
 
wait window nowait 'Проверяем возможность возврата...'  
select count(*) from ostatki1 into array a
kol1 = a[1]
 
select count(*) from raschet1 into array a
kol2 = a[1]
 
if kol1 = 0 .and. kol2 = 0
	ask = 'Ваши архивные таблицы - пустые. '+;
			'Более вероятно, что вы уже выполнили фиксацию изменений. '+;
			'Поэтому продолжение отката НЕ РЕКОМЕНДУЕТСЯ. '+;
			'Если Вы попытаетесь выполнить возврат к предыдущему состоянию, '+;
			'Ваши остатки будут обнулены. '+chr(10)+;
			'Если вы хотите полностью удалить остатки и расчет нажмите <Да>.'+chr(10)+;
			'Для отказа от данной операции нажмите <Нет>'
	res = messagebox(ask,48+4)
	if res <> 6
		wait window nowait 'Правильно! Не надо спешить.' 
 		return 
 	endif
 	ask = 'Остатки будут ОБНУЛЕНЫ! Вы уверены в том что делаете?'
 	res = messagebox(ask,48+4)
 	if res <> 6
 		wait window nowait 'Вот и хорошо!' 
 		return
 	endif
endif
 
* очищаем базовые таблицы
wait window nowait 'Очищаем базовые таблицы...' 
delete from ostatki
delete from raschet 
 
* переносим из архивных в базовые
wait window nowait 'Перенос остатков...' 
select * from ostatki1 into cursor c_os
scan all
	scatter memvar 
	insert into ostatki from memvar 
endscan
use in c_os 

wait window nowait 'Перенос расчета...' 
select * from raschet1 into cursor c_ras
scan all
	scatter memvar 
	insert into raschet from memvar
endscan
use in c_ras
 
* очищаем архивные таблицы
wait window nowait 'Удаление архивов...' 
delete from ostatki1
delete from raschet1 

wait window nowait '*** Выполнен возврат к предыдущему состоянию ***' 