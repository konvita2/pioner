* ������ ��������� ��������� ��� �������

local kodmold

* ����������� ������
select * from raschet ;
	order by kod, shw, shwz, kornd ;
	into cursor cp
if reccount()>0
	* ����������� excel-��������
		wait window nowait '���������� excel-���������' 
		local loExcel
		loExcel = createobject('Excel.Application')
		loExcel.Workbooks.Add()
		loExcel.Workbooks.Open(sys(5)+sys(2003)+'\rez1.xls')
		loExcel.DisplayAlerts = .f.

	* ����������� �����
		* ������� ���� � ���������
		loExcel.Cells(1,7).Value = '������������ '+ttoc(datetime())
		loExcel.Cells(3,2).Value = '���� ������� '+dtoc(cp.datr)
		* ����. ���������� ��� ������
		local npp,ns
		npp = 1
		ns = 7
		* ���������� ������
		kodmold = -1
		shwold = -1
		shwzold = ''
		sss = ''
		first = .t.
		scan all
			* message
			wait window nowait '������� '+alltrim(str(100*recno('cp')/reccount('cp')))+'%' 
			* ��������
			if kodmold <> cp.kod
				* ������� ����� �� ��������� (���� ��� �� ������ ������)
				* ����� ����� ����� ������� � ��� ������ �� �����
				if !first
					wait window nowait '����� �� ��������� '+alltrim(str(kodmold)) 
					local it_naimmat,it_maskd,it_maszag,it_masnto,it_masisp
					local it_kisp,it_kkd,it_rent
					store 0 to it_naimmat,it_maskd,it_maszag,it_masnto,it_masisp
					store 0 to it_kisp,it_kkd,it_rent
					* ���������� �������� ��� ����������
						* it_naimmat
						it_naimmat = get_mater(kodmold)	
						* it_maskd
						local l1
						it_maskd = 0
						select * from cp ;
							where ;
								kod = kodmold ;
							into cursor cpp
						scan all
							l1 = get_wag_by_kornd_and_shwz(cpp.kornd,cpp.shwz)
							it_maskd = it_maskd + l1 * cpp.koli						
						endscan	
						use in cpp		
						release l1						
						* it_maszag
						local aa
						it_maszag = 0
						select * from cp ;
							where ;
								kod = kodmold ;
							into cursor cpp
						scan all
							aa = get_mz_div_kolz_by_k_and_s(cpp.kornd,cpp.shwz)
							it_maszag = it_maszag + cpp.koli * aa
						endscan 	
						use in cpp		
						release aa
						* it_masnto
						local aa
						it_masnto = 0
						select * from ostatki ;
							where kod = kodmold and pri=2;
							into cursor cpp
						scan all
							select * from mater ;
								where kodm = kodmold ;
								into cursor cmat
							if reccount()>0	
								aa = cpp.ra*cpp.rb*cmat.tm*cmat.uv/1000000
								it_masnto = it_masnto + aa
							endif	
							use in cmat
						endscan 				
						use in cpp	
						release aa
						* it_masisp
						local aa
						it_masisp = 0
						select * from cp ;
							where kod = kodmold ;
							into cursor cpp
						scan all
							select * from mater ;
								where kodm = kodmold ;
								into cursor cmat	
							if reccount()>0
								aa = cpp.koli * cpp.rozma * cpp.rozmb * cmat.tm * cmat.uv / 1000000
								it_masisp = it_masisp + aa								
							endif
							use in cmat
						endscan	
						use in cpp						
						release aa
						it_masisp = it_masisp + it_masnto
						* it_kisp
						it_kisp = it_maskd / it_masisp						
						* it_kkd
						it_kkd = it_maszag / it_masisp
						* it_rent
						it_rent = 0
						select * from cp ;
							where kod = kodmold ;
							into cursor cpp
						scan all
							it_rent = it_rent + get_nrmd_by_kornd_and_shwz(cpp.kornd,cpp.shwz)*cpp.koli
						endscan	
						use in cpp	
						it_rent = it_rent - it_masisp
						* ===
					* ������� � excel-��������
					loExcel.Cells(ns,2).Value = '����� �� ���������'
					loExcel.Cells(ns+1,2).Value = it_naimmat
					loExcel.Cells(ns+2,2).Value = '����� ��������� �� ��:'
					loExcel.Cells(ns+2,3).Value = alltrim(str(it_maskd,9,3))
					loExcel.Cells(ns+3,2).Value = '����� ���������:'
					loExcel.Cells(ns+3,3).Value = alltrim(str(it_maszag,9,3))
					loExcel.Cells(ns+4,2).Value = '����� ����������������� �������:'
					loExcel.Cells(ns+4,3).Value = alltrim(str(it_masnto,9,3))
					loExcel.Cells(ns+5,2).Value = '����� ��������������� ���������:'
					loExcel.Cells(ns+5,3).Value = alltrim(str(it_masisp,9,3))
					loExcel.Cells(ns+6,2).Value = '����������� ������������� ����� �� ����������:'
					loExcel.Cells(ns+6,3).Value = alltrim(str(it_kisp,9,3))
					loExcel.Cells(ns+7,2).Value = '����������� ������������� ����� �� ��:'
					loExcel.Cells(ns+7,3).Value = alltrim(str(it_kkd,9,3))
					loExcel.Cells(ns+8,2).Value = '��������������:'
					loExcel.Cells(ns+8,3).Value = alltrim(str(it_rent,9,3))					
					
					* ����������� ns
					ns = ns+10
				* ///	
				endif
				loExcel.Cells(ns,2).Value = get_mater(cp.kod)
				loExcel.Cells(ns,2).Select
				loExcel.Selection.Font.Bold = .t.
				loExcel.Selection.Font.Underline = .t.				 
				kodmold = cp.kod
				shwold = -1
			endif				
			* npp
			loExcel.Cells(ns,1).Value = npp
			* �������-��
			if cp.shw <> shwold or alltrim(cp.shwz) <> alltrim(shwzold)
				sss = get_izd_ribf_by_kod(cp.shw)+' '+;
					get_izd_im_by_kod(cp.shw)+' / '+chr(10)+;
					alltrim(cp.shwz)
				loExcel.Cells(ns+1,2).Value = sss
				shwold = cp.shw
				shwzold = cp.shwz			
			endif
			* �� � ��
			loExcel.Cells(ns,3).Value = cp.nlista
			loExcel.Cells(ns+1,3).Value = cp.nost
			* ��� �
			loExcel.Cells(ns,4).Select
			loExcel.Selection.NumberFormat = '@'
			loExcel.Selection.HorizontalAlignment = -4108
			loExcel.Cells(ns,4).Value = cp.kornd
			* �����. ���.
			loExcel.Cells(ns,5).Value = ;
				get_poznd_by_kornd_and_shwz(cp.kornd,cp.shwz)
			* ����. ���. 
			loExcel.Cells(ns+1,5).Value = ;
				get_naimd_by_kornd_and_shwz(cp.kornd,cp.shwz)
			* ����� � ������
			loExcel.Cells(ns,6).Value = str(cp.rozma,6)
			loExcel.Cells(ns+1,6).Value = str(cp.rozmb,6)
			* ������ 
			loExcel.Cells(ns,7).Value = str(cp.progr,4)						
			* ���
			loExcel.Cells(ns,8).Value = str(cp.koli,4)
			* ������
			*loExcel.Cells(ns,8).Value = str(cp.kolz,5)
			* ������� ���������� �����������
			
			* ��������� npp
			npp = npp+1
			* ��������� ns
			ns = ns+2
			* ���� ���� ������, �� ����������
			first = .f.
		endscan
		* �������� �����
			wait window nowait '����� �� ��������� '+alltrim(str(kodmold)) 
					local it_naimmat,it_maskd,it_maszag,it_masnto,it_masisp
					local it_kisp,it_kkd,it_rent
					store 0 to it_naimmat,it_maskd,it_maszag,it_masnto,it_masisp
					store 0 to it_kisp,it_kkd,it_rent
					* ���������� �������� ��� ����������
						* it_naimmat
						it_naimmat = get_mater(kodmold)	
						* it_maskd
						local l1
						it_maskd = 0
						select * from cp ;
							where ;
								kod = kodmold ;
							into cursor cpp
						scan all
							l1 = get_wag_by_kornd_and_shwz(cpp.kornd,cpp.shwz)
							it_maskd = it_maskd + l1 * cpp.koli						
						endscan	
						use in cpp		
						release l1						
						* it_maszag
						local aa
						it_maszag = 0
						select * from cp ;
							where ;
								kod = kodmold ;
							into cursor cpp
						scan all
							aa = get_mz_div_kolz_by_k_and_s(cpp.kornd,cpp.shwz)
							it_maszag = it_maszag + cpp.koli * aa
						endscan 	
						use in cpp		
						release aa
						* it_masnto
						local aa
						it_masnto = 0
						select * from ostatki ;
							where kod = kodmold and pri=2;
							into cursor cpp
						scan all
							select * from mater ;
								where kodm = kodmold ;
								into cursor cmat
							if reccount()>0	
								aa = cpp.ra*cpp.rb*cmat.tm*cmat.uv/1000000
								it_masnto = it_masnto + aa
							endif	
							use in cmat
						endscan 				
						use in cpp	
						release aa
						* it_masisp
						local aa
						it_masisp = 0
						select * from cp ;
							where kod = kodmold ;
							into cursor cpp
						scan all
							select * from mater ;
								where kodm = kodmold ;
								into cursor cmat	
							if reccount()>0
								aa = cpp.koli * cpp.rozma * cpp.rozmb * cmat.tm * cmat.uv / 1000000
								it_masisp = it_masisp + aa								
							endif
							use in cmat
						endscan	
						use in cpp						
						release aa
						it_masisp = it_masisp + it_masnto
						* it_kisp
						it_kisp = it_maskd / it_masisp						
						* it_kkd
						it_kkd = it_maszag / it_masisp
						* it_rent
						it_rent = 0
						select * from cp ;
							where kod = kodmold ;
							into cursor cpp
						scan all
							it_rent = it_rent + get_nrmd_by_kornd_and_shwz(cpp.kornd,cpp.shwz)*cpp.koli
						endscan	
						use in cpp	
						it_rent = it_rent - it_masisp
						* ===
					* ������� � excel-��������
					loExcel.Cells(ns,2).Value = '����� �� ���������'
					loExcel.Cells(ns+1,2).Value = it_naimmat
					loExcel.Cells(ns+2,2).Value = '����� ��������� �� ��:'
					loExcel.Cells(ns+2,3).Value = alltrim(str(it_maskd,9,3))
					loExcel.Cells(ns+3,2).Value = '����� ���������:'
					loExcel.Cells(ns+3,3).Value = alltrim(str(it_maszag,9,3))
					loExcel.Cells(ns+4,2).Value = '����� ����������������� �������:'
					loExcel.Cells(ns+4,3).Value = alltrim(str(it_masnto,9,3))
					loExcel.Cells(ns+5,2).Value = '����� ��������������� ���������:'
					loExcel.Cells(ns+5,3).Value = alltrim(str(it_masisp,9,3))
					loExcel.Cells(ns+6,2).Value = '����������� ������������� ����� �� ����������:'
					loExcel.Cells(ns+6,3).Value = alltrim(str(it_kisp,9,3))
					loExcel.Cells(ns+7,2).Value = '����������� ������������� ����� �� ��:'
					loExcel.Cells(ns+7,3).Value = alltrim(str(it_kkd,9,3))
					loExcel.Cells(ns+8,2).Value = '��������������:'
					loExcel.Cells(ns+8,3).Value = alltrim(str(it_rent,9,3))					
				
	* �����	
		wait window nowait '������ ������' 

	* ������� excel-��������
		wait wind nowait '�������� excel-���������'
		loExcel.Visible = .t.
		wait window nowait '����� �����'
else
	wait window '��� ������ �� ����������!'
endif	
use in cp	
