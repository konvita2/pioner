local msg

msg = '�� ������������� ������ ��������� �������� ���������� �� �������?'

if messagebox(msg,4+32)=6
	delete from ostatki
	delete from raschet
	wait window '������� ������� ��������' 
endif