lparameters pars

if parameters()=0
	wait window 'Ошибка доступа через ODBC!'
else
	wait window pars + ': Ошибка доступа через ODBC!'
endif	