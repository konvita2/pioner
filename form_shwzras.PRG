lparameters parShwz

local ans,newid

* ��������� ���� �� ��� ���� �������
select * from shwzras where alltrim(shwz) == alltrim(parShwz) ;
    and !empty(shwz) ;
    into cursor cc10
if reccount()>0
    ans = messagebox('� ���� ������������ ���������� ����� ��� ��� ����! �������� ���?',4+32)
    if ans <> 6
        wait window nowait '���� ����������� � ���������� �� ���� ������������!'
        return
    else
        wait window nowait '��������� ������������ ������'
        delete from shwzras where alltrim(shwz)	== alltrim(parShwz)
    endif
endif
use in cc10

* ���������
local lcShw

lcShw = get_izd_kod_by_shwz(parShwz)



* �� �������� ����������
select dist Mater.kodm, Mater.naim, Mater.pol,;
    Mater.gr, Mater.sort,Mater.kod,Mater.ei ;
    from  db!Mater ;
    INNER join db!kt ;
    on  Mater.kodm = kt.kodm ;
    where kt.shw = m.lcShw ;
    and kt.kodm = Mater.kodm and kt.kodm <> 0 ;
    and Mater.kodm < m.glMater ;
    order by Mater.sort, Mater.pol, Mater.naim ;
    into curs cc20
scan all
    select ;
        round(sum(wag*koli),3) as s1, ;
        round(sum(mz*koli),3) as s2, ;
        round(sum(nrmd*koli),3) as s3, ;
        round(sum(normwr*koli),3) as s4, ;
        round(sum(normwr0*koli),3) as s5 ;
        from kt ;
        where kt.shw=m.lcShw and cc20.kodm # 0 ;
        and cc20.kodm = kt.kodm and kt.d_u=1 and !empty(kt.poznd) ;
        into cursor cc30
    * ����� � �������
    *  newid
    select * from shwzras order by id into cursor cc40
    if reccount()>0
        go bottom
        newid = cc40.id+1
    else
        newid = 1
    endif
    use in cc40
    *
    insert into shwzras ;
        (id,kodm,kolizd,kol1,shwz) ;
        values ;
        (newid,cc20.kodm,lnKol1,cc30.s3,parShwz)
    use in cc30
endscan
use in cc20

* �� ������������� ����������
select dist Mater.kodm, Mater.naim, Mater.pol,;
    Mater.gr, Mater.sort,Mater.kod,Mater.ei ;
    from  db!Mater ;
    INNER join db!kt ;
    on  Mater.kodm = kt.kodm ;
    where kt.shw = m.lcShw ;
    and kt.kodm = Mater.kodm and kt.kodm <> 0 ;
    and Mater.kodm >= m.glMater ;
    order by Mater.sort, Mater.pol, Mater.naim ;
    into curs cc20
scan all
    select sum(koli) as s1 ;
        from kt ;
        where kt.shw=m.lcShw and cc20.kodm # 0 ;
        and cc20.kodm=kt.kodm and kt.d_u=1 and empty(kt.poznd) ;
        into cursor cc30
    *  newid
    select * from shwzras order by id into cursor cc40
    if reccount()>0
        go bottom
        newid = cc40.id+1
    else
        newid = 1
    endif
    use in cc40
    *
    insert into shwzras ;
        (id,kodm,kolizd,kol1,shwz) ;
        values ;
        (newid,cc20.kodm,lnKol1,cc30.s1,parShwz)
    use in cc30    
endscan
use in cc20








