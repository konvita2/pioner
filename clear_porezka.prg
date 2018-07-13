local msg

msg = 'Вы действительно хотите полностью очистить информацию по порезке?'

if messagebox(msg,4+32)=6
	delete from ostatki
	delete from raschet
	wait window 'Таблицы порезки вычищены' 
endif