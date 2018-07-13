lparameters pnom,pnom1

* ===========================================
* ������ ������� ����������
local mnom,mnom1

mnom = pnom
mnom1 = pnom1

*** �������� ����
local hh,rr
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	rr = sqlexec(hh,'select * from ras where nom=?mnom and nom1=?mnom1','ccra')
	if rr < 0
		eodbc('print lzktreb sele')
		return
	endif
	sqldisconnect(hh)
else
	eodbc('print lzktreb conn')
endif

*** ����� ������� � EXCEL 
wait window nowait '������ Excel' 
local loExcel
loExcel = createobject('Excel.Application')
loExcel.Workbooks.Add()
loExcel.Workbooks.Open(sys(5)+sys(2003)+'\limtreb.xls')
loExcel.DisplayAlerts = .f.

local noms
noms = 11

* ��������� ���������
loExcel.cells(3,3).value = '��� (����������) �' + alltrim(str(mnom)) + '.' + ;
	alltrim(str(mnom1)) + ' �� ' + alltrim(dtoc(ccra.dat))
loExcel.Cells(7,3).value = str(ccra.sklad1) + ' ' + get_dosp2(ccra.sklad1)
loExcel.Cells(8,3).value = str(ccra.sklad2) + ' ' + get_dosp2(ccra.sklad2)
loExcel.Cells(5,3).value = '���� '+dtoc(ccra.dat)+' '+alltrim(ccra.shwz)+' ���-�� � ����� '+;
	str(get_izd_partz2_by_shwz(ccra.shwz)-get_izd_partz1_by_shwz(ccra.shwz)+1)+' ��.'
loExcel.Cells(6,3).value = '��������� '+get_izd_ribf_by_shwz(ccra.shwz)+' '+get_izd_im_by_shwz(ccra.shwz)	
loExcel.Cells(8,7).value = '�����: '+alltrim(ccra.cherez)

* ������� ������ ����� odbc
local hh
hh = sqlconnect('sqldb','sa','111')
if hh > 0
	local rr
	rr = sqlexec(hh,'select rast.*,mater.naim as maternaim from rast,mater '+;
					'where mater.kodm = rast.kodm and nom = ?mnom and '+;
					'nom1 = ?mnom1 order by maternaim')
	if rr = -1
		eodbc()
	endif	
else
	eodbc()
	return
endif


* ������� ������
select * from sqlresult into cursor crast
scan all

	* �������
	loExcel.Range(loExcel.Cells(noms,1),loExcel.Cells(noms,7)).Select
	loExcel.Selection.VerticalAlignment = -4160
	
	loExcel.Selection.Borders(9).LineStyle = 1 
	loExcel.Selection.Borders(7).LineStyle = 1 
	loExcel.Selection.Borders(10).LineStyle = 1 
	loExcel.Selection.Borders(8).LineStyle = 1 
	loExcel.Selection.Borders(11).LineStyle = 1 
	
	loExcel.Range(loExcel.Cells(noms,2),loExcel.Cells(noms,2)).Select
	loExcel.Selection.WrapText = .t.
	
	loExcel.Range(loExcel.Cells(noms,4),loExcel.Cells(noms,5)).Select
	loExcel.Selection.NumberFormat = '0.000000'
	
	loExcel.Range(loExcel.Cells(noms,6),loExcel.Cells(noms,6)).Select
	loExcel.Selection.NumberFormat = '@'
	loExcel.Selection.HorizontalAlignment = -4152
	
	loExcel.Range(loExcel.Cells(noms,7),loExcel.Cells(noms,7)).Select
	loExcel.Selection.NumberFormat = '@'
	loExcel.Selection.HorizontalAlignment = -4152
	loExcel.Selection.Font.Name = "CCode39"
	loExcel.Selection.Font.Size = 10
	
	loExcel.Range(loExcel.Cells(noms,3),loExcel.Cells(noms,3)).Select
	loExcel.Selection.HorizontalAlignment = -4108
	
	* ������
	loExcel.Cells(noms,1).value = crast.nsk
	loExcel.Cells(noms,2).value = alltrim(get_mater(crast.kodm))
	loExcel.Cells(noms,3).value = alltrim(get_mater_ei1(crast.kodm))
	loExcel.Cells(noms,4).value = crast.kolzap
	loExcel.Cells(noms,5).value = crast.kolzat
	*loExcel.Cells(noms,6).value = str(crast.kol,12,6) + chr(10) + get_mater_shtuk(crast.kodm,crast.kol)
	
	scancode = gen_scancode(mnom,mnom1,crast.kodm,crast.nsk)
	loExcel.Cells(noms,6).value = scancode
	loExcel.Cells(noms,7).value = scancode
	
	noms = noms+1
endscan 
use in crast

*** ������� �����
loExcel.Cells(noms+1,2).value = '���. ���� _________________________'
loExcel.Cells(noms+3,2).value = '���. ������� ___________________'

*** show Excel
loExcel.ActiveWindow.DisplayGridlines = .f.
loExcel.Visible = .t.

sqldisconnect(hh)

