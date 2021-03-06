* =======================================
* ��������� � ������� ��� ������ �������
* =======================================

* =======================================
* �������� nzak �� id ������ � porezzak
function get_nzak_by_id(parId)
	local mres
	select nzak from porezzak ;
		where;
			id = parId;
		into cursor cres	
	if reccount()>0
		mres = cres.nzak
	else
		mrez = ''
	endif	
	use in cres	
	return mres
endfunc  


* ========================================
* �������� ������ id �� nzak ������� ��������� 
* �� ������� porezzak
function get_id_by_nzak(parNzak)
	local mres
	select id from porezzak;
		where;
			!empty(nzak) ;
			and;
			alltrim(nzak) == alltrim(parNzak);
		into cursor cres
	if reccount()>0
		mres = cres.id
	else
		mres = -1
	endif	
	use in cres
	return mres		
endfunc 


* =========================================
* �������� ���� ������ dzak �� nzak
function get_dzak_by_nzak(parNzak)
	local mres
	select dzak from porezzak;
		where;
			!empty(nzak);
			and;
			alltrim(nzak) == alltrim(parNzak);
		into cursor cres
	if reccount()>0
		mres = cres.dzak
	else
		mres = date()
	endif	
	use in cres		
	return mres	
endfunc 


* =========================================
* �������� ���������� ������ prim �� nzak
function get_prim_by_nzak(parNzak)
	local mres
	select prim from porezzak;
		where;
			!empty(nzak);
			and;
			alltrim(nzak) == alltrim(parNzak);
		into cursor cres
	if reccount()>0
		mres = cres.prim
	else
		mres = ''
	endif	
	use in cres		
	return mres	
endfunc 


