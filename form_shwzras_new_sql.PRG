* ����� ������ ������������� ��������� ���� ��
* ����� �������
* ���������� �����
lparameters parshwz
local res
res = 1

local ans

local hh,rr

* ��������� ���� �� ��� ���� �������
*!*	select * from shwzras where alltrim(shwz) == alltrim(parshwz) ;
*!*		and !empty(shwz) ;
*!*		into cursor cc10

hh = sqlconnect('sqldb','sa','111')

* wait window 'hh= '+str(hh) 

if hh > 0
	rr = sqlexec(hh,'select * from shwzras where rtrim(shwz)=rtrim(?parshwz) and '+;
					"rtrim(shwz)<>''",'cc10')
	if rr = -1				
		eodbc('form_shwzras_new_sql sele1')
	endif
	if reccount()>0
		ans = messagebox('� ���� ������������ ���������� ����� ��� ��� ����! �������� ���?',4+32)
		if ans <> 6
			wait window nowait '���� ����������� � ���������� �� ���� ������������!'
			res = 0
			return res
		else
			wait window nowait '��������� ������������ ������'
			*delete from shwzras where alltrim(shwz)	== alltrim(parshwz)
			rr = sqlexec(hh,'delete from shwzras where rtrim(shwz)=rtrim(?parshwz)')
			if rr = -1
				eodbc('form_shwzras_new_sql dele2')
			endif
		endif
	endif
	use in cc10

	* �������� ��� �������
	local lcshw
	lcshw = get_izd_kod_by_shwz(parshwz)

	*  ���������� ������� ������� � �������
	*  kol1
	local lnkol1

	lnkol1 = get_izd_kolzap_by_shwz(parshwz)

	* �������� �� ����������
	rr = sqlexec(hh,'select distinct mater.kodm,mater.naim,mater.kod,mater.ei,kt.mar1,kt.d_u '+;
					'from mater,kt where kt.shw=?lcshw and kt.kodm=mater.kodm and kt.kodm<>0 '+;
					'and (kt.d_u=1 or kt.d_u=4 or kt.d_u=5) order by mater.naim','cc30')
	if rr = -1
		eodbc('form_shwzras_new_sql sele3')
	endif				
	scan all
		*** progress
		*wait window nowait '��������� '+str(100*recno()/reccount(),3)+'%'
		waitproc(recno(),reccount(),'������������ ��������� ���� 1-�� ������')
		*** ������� ����
		do case
			case	cc30.d_u = 1 .or. cc30.d_u = 5

					rr = sqlexec(hh,'select sum(koli*nrmd) as snrmd, sum(koli) as skoli, max(d_u) as d_u '+;
									'from kt where kodm=?cc30.kodm and shw=?lcshw and '+;
									'mar1 = ?cc30.mar1 and d_u=?cc30.d_u','cc40')
					if rr = -1
						eodbc('form_shwzras_new_sql sele5')
					endif				

			case	cc30.d_u = 4

					rr = sqlexec(hh,'select sum(kol1 * koli / kol) as snrmd, sum(koli) as skoli , max(d_u) as d_u '+;
									'from kt where kodm=?cc30.kodm and shw=?lcshw and '+;
									'mar1=?cc30.mar1 and d_u=?cc30.d_u','cc40')
					if rr = -1
						eodbc('form_shwzras_new_sql sele6')
					endif				
		endcase
			
		local aa,dd
		
		* ������������ ������:
		* � ������ ���� ���������� � ������� �������� � ��� ��������, � ��� ����� ��������
		* ��� - �� ���������
		*** aa = get_du_by_shwz_kodm(parshwz,cc30.kodm)			
		
		dd = date()
		rr = sqlexec(hh,'insert into shwzras (kodm,kolizd,kol1,shwz,mar1,du,koli,dat) '+;
						'values '+;
						'(?cc30.kodm,?lnkol1,?cc40.snrmd,?parshwz,?cc30.mar1,'+;
						'?cc40.d_u,?cc40.skoli,?dd)')
		if rr = -1
			eodbc('form_shwzras_new_sql ins10')
		endif					
			
		*** close cc40
*!*			use in cc40
	endscan
	use in cc30

	sqldisconnect(hh)

	*** ������� dattd ��� ������� �������
	***wait window '�� ������ �������� fix_izd_dattd'
	do fix_izd_dattd with parshwz

	wait window nowait '���������� � ��������� ���� ���������'

else
	eodbc('form_shwzras_new_sql conn')
endif

return res