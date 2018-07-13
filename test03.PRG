local oexcel as "excel.application"
oexcel.Cells(1,1).Value = 'sd'
a = oexcel.Range(oexcel.Cells(1,1),oexcel.Cells(1,1)).Select 
a 