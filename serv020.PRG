* ��������� ���������� wwlim ����������� ������ 061
create cursor cc45 (shwz c(20))

wait window nowait '������� WW' 
local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from ww','cww')
	if rr = -1
		eodbc('sele')
	endif

	sqldisconnect(hh)
else
	eodbc('conn')
endif

wait window nowait '������� 061 ������' 
select distinct shwz from cww into cursor cc46
scan all
	if isdogovor('061',cc46.shwz)
		insert into cc45 (shwz) values (cc46.shwz)
	endif	
endscan 
use in cc46

wait window nowait '�������� ��������������� �����'
delete from cc45 where alltrim(shwz) = '980.790.399.061.08'

select cc45
scan all
	
	waitproc(recno(),reccount(),'���������� wwlim')
	
	select * from cww where alltrim(shwz) = alltrim(cc45.shwz) into cursor cc
	scan all
		add_wwlim(cc.nozap,cc.kzp)
	endscan 
	use in cc
	
endscan 
 
 
select cc45
scan all

endscan

use in cc45