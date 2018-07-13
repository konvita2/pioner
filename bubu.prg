local loExc

loExc = createobject('Excel.application')

*loExc.Workbooks.Add('')
loExc.Caption = "Hello"
loExc.Workbooks.Open('c:\dsn.xls')
loExc.Visible = .t.