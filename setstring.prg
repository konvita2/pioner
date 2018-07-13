* using in f_imit_sql
* =R63C[-2]+R59C[-2])
lparameters ar[1000]
private s

s = "=(R"
for each a in ar
	if type('a') <> 'L'

		s = s + alltrim(str(a)) + "C+R"

	endif
endfor

if(len(s) > 5)
	s = left(s,len(s)-2)  && delete last +R
	s = s + ")"
else
	s = ""
endif

return s