* ��������� ������� � ����������� ���������, ��� �����
* ������� ostatki � raschet
* ��������� ��� �� ostatki1 � raschet1
* ������� ostatki1 � raschet1

* ��������� ����� �� ��������� �����
local kol1,kol2,ask,res
local a[1]
 
wait window nowait '��������� ����������� ��������...'  
select count(*) from ostatki1 into array a
kol1 = a[1]
 
select count(*) from raschet1 into array a
kol2 = a[1]
 
if kol1 = 0 .and. kol2 = 0
	ask = '���� �������� ������� - ������. '+;
			'����� ��������, ��� �� ��� ��������� �������� ���������. '+;
			'������� ����������� ������ �� �������������. '+;
			'���� �� ����������� ��������� ������� � ����������� ���������, '+;
			'���� ������� ����� ��������. '+chr(10)+;
			'���� �� ������ ��������� ������� ������� � ������ ������� <��>.'+chr(10)+;
			'��� ������ �� ������ �������� ������� <���>'
	res = messagebox(ask,48+4)
	if res <> 6
		wait window nowait '���������! �� ���� �������.' 
 		return 
 	endif
 	ask = '������� ����� ��������! �� ������� � ��� ��� �������?'
 	res = messagebox(ask,48+4)
 	if res <> 6
 		wait window nowait '��� � ������!' 
 		return
 	endif
endif
 
* ������� ������� �������
wait window nowait '������� ������� �������...' 
delete from ostatki
delete from raschet 
 
* ��������� �� �������� � �������
wait window nowait '������� ��������...' 
select * from ostatki1 into cursor c_os
scan all
	scatter memvar 
	insert into ostatki from memvar 
endscan
use in c_os 

wait window nowait '������� �������...' 
select * from raschet1 into cursor c_ras
scan all
	scatter memvar 
	insert into raschet from memvar
endscan
use in c_ras
 
* ������� �������� �������
wait window nowait '�������� �������...' 
delete from ostatki1
delete from raschet1 

wait window nowait '*** �������� ������� � ����������� ��������� ***' 