 * ������� �� ��� ����� � ostatki � raschet ��� ���������� ������
 * ������� ����������� ������� - ������ ostatki1 � raschet1
 
 * ��������� �� ������ �� �������� �����
 local kol1,kol2
 local a[1]
 select count(*) from ostatki1 into array a
 kol1 = a[1]
 select count(*) from raschet1 into array a
 kol2 = a[1]
 *
 if kol1 = 0 .and. kol2 = 0
 	wait window '*** ��������, �������� ��������� ��� ��������� ***' 
 	return  
 endif
 
 local ask
 ask = '�� �������, ��� ������ ������� ����� ����������� ������� ��� ����������?'
 if messagebox(ask,4+32)=6
 	* ������� ������
 	delete from ostatki1
 	delete from raschet1
 	* ��������� ����������������� ������� � ��������� 3 � ����� ���
 	select sum(get_ves_by_kodm_ra_rb(kod,ra,rb)) as ssum, kod from ostatki ; 
 		where pri=2 ;
 		order by kod ; 
 		group by kod ;
 		into cursor cc_100 
 	scan all
 		* ������������ ����� nozap
 		local pnozap
 		select * from ostatki order by nozap into cursor cc_101
 		if reccount()>0
 			go bottom 
 			pnozap = cc_101.nozap + 1
 		else
 			pnozap = 1
 		endif
 		use in cc_101 		
 		* �������� ����� ������������ � ��������� 3 		
 		insert into ostatki ;
 			(nozap,dat_o,kod,nlista,nost,pri,inlista,inost,ves);
 			values;
 			(m.pnozap,date(),cc_100.kod,-10,-10,3,-10,-10,cc_100.ssum) 			
 	endscan	
 	use in cc_100	
 	* ���� �� �������� ������������ � ���������� �������
 	
 	
 	* ������� ������������ � ��������� 2
 	wait window nowait '������� ����������������� �������...' 
 	delete from ostatki where pri=2
 	* ��������� ��� �� ���� ���������� � ��������
 	wait window nowait '������������� ��� � ��������...' 
 	select * from ostatki ;
 		where pri=0 or pri=1 ;
 		into cursor c_ost
 	scan all
 		select c_ost
 		scatter memvar 
 		m.ves = get_ves_by_kodm_ra_rb(m.kod,m.ra,m.rb)
 		update ostatki set ;
 			dat_o 	= m.dat_o,;
 			kod		= m.kod,;
 			ra		= m.ra,;
 			rb		= m.rb,;
 			nlista	= m.nlista,;
 			nost	= m.nost,;
 			pri		= m.pri,;
 			rx		= m.rx,;
 			ry		= m.ry,;
 			inlista	= m.inlista,;
 			inost	= m.inost,;
 			kromka	= m.kromka,;
 			ves		= m.ves ;
 		where;
 			nozap 	= m.nozap
 	endscan	
 	use in c_ost	 	
 	wait window '*** ��������� �������� ��������� ***' 
 else	
	wait window '*** �������� ��������� �� ��������� ***'  	 	
 endif
 