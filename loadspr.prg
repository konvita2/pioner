local lcFile,lcFound

* �������� ��� ����� ��� ������
m.lcFile = getnastr('ostatpath')

if empty(m.lcFile)
	wait '�� ������� ����� ��� ����� � ����� nastr! ������� �� ����� ���� ���������.' window nowait	
	return
endif

* ������� ������ �������/������������� �� 444
*	select distinct kodskl, namskl from (lcFile) into cursor c400

*	if reccount() > 0

*		wait '������� ����������� ������ �������������' wind nowait
*		delete from dosp where vid = 2 and kod <> 0
*		wait '����������� ���������� ������ �������������...' wind nowait	
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
*			(2, 9999, '(�� ������)')
*		
*	else
*		wait '���������� ����������� ������������� �� ���� ��������� �.�. ������ ����' nowait wind 
*	endif

*	use in c400

* ============== ����� �������
select kodskl,kodtmz,kodspektr,kodeizm,kol,sum ;
	from (lcfile) ;
	where kol <> 0 and kodspektr <> 0 into cursor c400
if reccount()>0
	*** ������� �������
	wait '�������� ���������� ��������' nowait wind
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

		* ������������� ��������� ���� (� � � � � � �   � � � � � � �)
		* update mater set cena = c400.sum/c400.kol where kodm = c400.kodspektr

	endscan
else
	wait '���������� ����������� �������� �� ���������. �������� ��� ?' nowait wind
endif
use in c400

return

* //////////////////////////////////////////////
* ���� ������� �� 31/10/2006
* ������� �������� �� 444
select kodskl,kodtmz,kodspektr,kodeizm,kol,sum ;
	from (lcFile) ;
	where kol <> 0 into cursor c400

if recc() > 0
    *** ������� �������
	wait '�������� ���������� ��������' nowait wind
	delete from ostatok
	*** ������� ����� ��������
	wait '������� ����� ��������' nowait wind
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
	wait '���������� ���������' wind nowait
else
	wait '���������� ����������� �������� �� ���������. �������� ��� ?' nowait wind	

endif

use in c400