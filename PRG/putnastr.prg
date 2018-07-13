* записать строку в таблицу nastr
parameters parKey,parValu,parDesc
dimension a[1]

select count(*) from nastr where !empty(key) and alltrim(key) == alltrim(m.parKey) into array a
if a[1]>0
	update nastr set nastr.valu = m.parValu ;			
		where ;
			alltrim(key) == alltrim(m.parKey)
else
	insert into nastr ;
		(key,valu,desc) ;
		values ;
		(m.parKey,m.parValu,m.parDesc)
endif

return