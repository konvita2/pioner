* �������� � ���� dattd ������� ���� ��� ������� ����� �������
* ��� sql ������ �������� ����������
lparameters parshwz
local hh,rr

hh = sqlconnect('sqldb','sa','111')
if hh > 0
	* ��������� �� ������ �� ��� ��
	if empty(parshwz)
		return
	endif

	* ��������� ���� �� ����� �� � izd
	*select * from izd where alltrim(shwz) == alltrim(parshwz) into cursor cc77
	rr = sqlexec(hh,'select * from izd where rtrim(shwz)=rtrim(?parshwz)','cc77')
	if rr = -1
		eodbc('fix_izd_dattd sele')
	endif	
	local ddd
	ddd = date()
	if reccount()>0
		if empty(cc77.dat_td) or cc77.dat_td < date(2000,1,1)
			*update izd set dattd = date() where id = cc77.id
			rr = sqlexec(hh,'update izdfull set dat_td=?ddd where id = ?cc77.id')
			if rr = -1
				eodbc('fix_izd_dattd sele1')
			endif
		endif
	endif
	use in cc77
else
	eodbc('fix_izd_dattd conn')
endif
