** ���������� �������� �� �������� kt � mater (����)
#define FILER 'test.log'

m.glErrors = 0

**** ���������� ����� ���������
do warn_open with FILER
do warn with '�������� ������'

**** ������������ KT
	wait '������������ �.�.�.' window nowait 
	do warn with '****************************************'
	do warn with '������������ �.�.�.'
	
	*************************************************
	*************************************************
	sele kod,ribf,im from izd into curs c_izd
	sele c_izd
	go top
	do while .not.eof()
	   m.shw=c_izd.kod
	   
	   wait '������������ �.�.�. ������� = '+c_izd.RIBF window nowait 
	   
	   do warn with '������� '+STR(c_izd.KOD,2)+' '+c_izd.RIBF+' '+c_izd.IM

	   sele shw,poznw,poznd,kornd,kodm,kol,d_u from kt ;
	        where  shw=m.shw.and.d_u=1.and.kol=0 into curs c_kt
	   if recc()>0
	   	  m.glErrors = m.glErrors+1	
	      do warn with '! ������� �� ���� ���� ������� '
	      scan
	         do warn with '�����-� - '+str(c_kt.kodm,4);
	                                                      +' '+c_kt.kornd;
	                                                      +' '+c_kt.poznd;
	                                                      +' '+c_kt.poznw
	      endscan
	   endif
	   use in c_kt
	   
	   *
	   *WAIT 'm.shw='+STR(m.shw,6) window nowa 
	   
	   sele kornd,poznd,naimd,mar1,mar2,shw,d_u,kodm from kt;
	        where shw=m.shw.and.d_u=1.and.kodm=0 into curs c_kt
	   if recc()>0
	   	  m.glErrors = m.glErrors+1	 	
	      do warn with '�I�����I��� �����I��I�'
	      scan
	         do warn with c_kt.kornd+' '+c_kt.poznd+' '+c_kt.naimd+str(c_kt.mar1,5)+str(c_kt.mar2,5)
	      endscan
	   endif	   
	   use in c_kt
	   
	   *debug
	   *wait window nowait '�I�����I��� �����I��I� end'
	   
	   sele shw,kodm,kornd,poznd,naimd  from kt where shw=m.shw.and.kodm#0;
	        into curs c_kt
	   sele c_kt
	   if recc()>0
	      sele kodm from mater where kodm=c_kt.kodm into curs c_mat
	      if recc()>0
	         sele c_kt
	         scan
	         	m.glErrors = m.glErrors+1	
	            do warn with '��� � MATER ���� '+str(c_kt.kodm,5)+' '+c_kt.kornd+' '+c_kt.poznd+' '+c_kt.naimd
	         endscan
	      endif
	      use in c_mat
	   endif
	   use in c_kt
	   
	   *wait window nowait '��� � ����� ����'

	   sele shw,d_u,rozma,rozmb,naimd,poznd,kornd,kodm,mar1,mar2,mar3,mar4,mar5,mar6,mar7,mar8,mar9,mar10 from kt where ;
	        shw=m.shw.and.d_u=1;
	        .and.rozma=0;
	        .and.!empt(poznd);
	        .and.kodm > 0;
	        .and.kodm < m.glMater;
	        into curs c_kt
	   sele c_kt
	  
	   if reccount()>0
	   		do warn with '�I�����I��� ����I�I�'
	   	  
	   	scan all
         
         m.glErrors = m.glErrors+1	
         do warn with c_kt.kornd+' '+c_kt.poznd+' '+c_kt.naimd
       	  
	   	endscan
	   endif
	   use in c_kt
	   *wait window nowait '���� ����'
	   
*		   bil=0
*		   select distinct poznd from kt where shw=m.shw and d_u=2 into curs p_2
*		   sele p_2
*		   go top
*		   do while .not.eof()
*		      poznd_=poznd
*		      select kornd, poznd, naimd from kt where shw=M.shw and poznd=poznd_ and d_u=2;
*		        into curs c_3
*		      if recc()<2
*		         bil=bil+1
*		         if bil=1
*		         	m.glErrors = m.glErrors+1	
*		            do warn with '                      ����������� �����'
*		         endif
*		         m.glErrors = m.glErrors+1	
*		         do warn with kornd+' '+poznd+' '+naimd
*		      endif
*		      sele p_2
*		      skip
*		   enddo
	   
	   *wait window nowait '����� ����������� �����'
	   
	   sele c_izd
	   skip
	enddo
	
*		sele dist poznd from kt where !empt(poznd) into curs cdet
*		go top
*		do while .not.eof()
*		   poznd_=poznd
*		   sele poznd, naimd, poznw, naimw, pozn ';
*		   		from kt where poznd=poznd_ and poznd#poznw  into curs c_
*		   go top
*		   if recc()> 1
*		      naimd_=naimd
*		      pipi=0
*		      *@ prow()+1,0 say poznd+' '+naimd+' '+str(recc(),3)
*		      do while .not.eof()
*		         if naimd#naimd_
*		            *wait 'buf '+naimd_+'-'+naimd wind
*		            if last()=27
*		               retu
*		            endif
*		            pipi=pipi+1
*		         endif
*		         skip
*		      enddo
*		      if pipi>1
*		         go top
*		         do warn with ' '
*		         do while .not.eof()
*		         	m.glErrors = m.glErrors+1	
*		            do warn with left(poznd,16)+' '+naimd+' '+left(poznw,16)+' '+naimw+' '+left(pozn,16)
*		            skip
*		         enddo
*		      endif
*		   endif
*		   sele cdet
*		   skip
*		enddo
*		use in cdet
*		use in c_

*		wait window nowait '***'	

*		sele dist poznd from kt where !empt(poznd) into curs cdet
*		scan all
*		   poznd_=poznd
*		   sele poznd, naimd, kodm, rozma, rozmb, kolz from kt ;
*		   		where poznd=poznd_ and poznd#poznw  into curs c_
*		   go top
*		   if recc()> 1
*		      do warn with ' '
*		      scan all
*		         m.glErrors = m.glErrors+1	
*		         do warn with poznd+' '+naimd;
*		                               +' '+str(kodm,4);
*		                               +' '+str(rozma,6,1);
*		                               +' '+str(rozmb,6,1);
*		                               +' '+str(kolz,3)
*		         skip
*		      endscan
*		   endif	
*		   use in c_ 
*		endscan
*		use in cdet
	
	*************************************************
	*************************************************
	
**** �������� ������������ ������������ ������ 	
	wait window nowait '��������: ������ ������������ ��� ���������� ������������'
	do warn with '������ ������������ ��� ���������� ������������'
	select dist poznd from kt ;
		where !empty(poznd) into cursor c_dist
	scan all	
		wait window nowait '��������: ������ ������������ ��� ���������� ������������ '+allt(c_dist.poznd)
		select dist naimd from kt where poznd = c_dist.poznd into cursor c_naimd
		if reccount()>1
			do warn with '������ ������������ �� POZND='+c_dist.poznd
			scan all
				do warn with '  '+c_naimd.naimd			
			endscan
		endif
		use in c_naimd	
	endscan
	use in c_dist
	
**** ������������ TE
	local lbErr
	do warn with '********************************************'
	do warn with '������������ ��������������� ����'	
	
	m.lbErr = .f.
	
	select * from obor order by marka into cursor c_obor
	scan all
		wait window nowait '������������ ��������������� ����: ������������ '+c_obor.marka
		select * from te where kodo == c_obor.marka ;
			order by mar into cursor c_te
		scan all
			if c_obor.podr <> c_te.mar
				do warn with '   ������. �� �����-� ������� (���� ��) '+c_te.poznd+' ��.'+str(c_te.mar,4)+' ����.'+c_obor.marka
				m.lbErr = .t.
			endif
		endscan	
		use in c_te	
	endscan
	use in c_obor
	
	if !m.lbErr
		do warn with ' �� (������ ���)!'		
	endif

**** ������������ MATER
	*************************************************
	*************************************************
	do warn with ''
	do warn with '********************************************'
	do warn with '������������ ����������� ����������'
	
	wait '������������ ����������� ����������' window nowait 
	
	local npp
	m.npp = 0
	select gr,sort,sp,kodm,kod,naim from MATER where gr=0.or.sort=0;
	                                 .or.sp=0;
	                                 .or.kod='000000000000';
	                                 .or.at(' ',kod)>0 ;
	                                  order by kodm into curs k2
	wait '���������: ���� ���� ������, ���������� � ��������� ��������' window nowait 	                                  
	IF RECCOUNT()>0
	   m.glErrors = m.glErrors+1		
	   do warn with '���� � ���� ������ ��� ����-�� ��� ��������� �������� ��� 12-���� !!! ' 
	   scan
	      m.glErrors = m.glErrors+1	
	      do warn with str(k2.kodm,4)+' '+k2.kod+' '+k2.naim
	   ENDSCAN
	ENDIF 
	USE IN K2

	select dist kodm from mater order by kodm into curs CURSMAT
	sele CURSMAT
	wait '���������: ���� �� ������������ �����' window nowait 	                                  
	go top
	do while .not.eof()
	   kodm_=kodm
	   select kodm,naim from MATER where kodm=kodm_ order by kodm into curs k2
	   if recc()>1
	   	  m.glErrors = m.glErrors+1	
	      do warn with '!!!  ����������� ��� '+str(kodm_,4)
	      scan
	      	 m.glErrors = m.glErrors+1	
	         do warn with k2.naim
	      ENDSCAN 
	   ENDIF
	   USE IN K2
	   sele CURSMAT
	   skip
	enddo
	USE IN CURSMAT

	select dist kod from MATER order by kod into curs CURSMAT
	sele CURSMAT
	wait '���������: ���� 12-�� ������� �����' window nowait 	                                  
	go top
	do while .not.eof()
	   kod_=kod
	   select kod,kodm,naim from MATER where kod=kod_ order by kod into curs k2
	   if recc()>1
	      m.glErrors = m.glErrors+1	
	      do warn with '!!!  ����������� 12-� ��� '+kod_
	      scan
	         m.glErrors = m.glErrors+1	
	         do warn with str(k2.kodm,4)+' '+k2.naim
	      ENDSCAN 
	   ENDIF
	   USE IN K2
	   sele CURSMAT
	   skip
	enddo
	USE IN CURSMAT


	select dist naim from MATER order by naim into curs CURSMAT
	sele CURSMAT
	go top
	wait '���������: ���� ������ ������������' window nowait 	                                  
	do while .not.eof()
	   naim_=naim
	   select naim,kodm from MATER where naim=naim_ order by naim into curs k2
	   if recc()>1
	      m.glErrors = m.glErrors+1	
	      do warn with '!!!  ����������� ������������ '+naim_
	      do while .not.eof()
	         m.glErrors = m.glErrors+1	
	         do warn with '    ��� !!! '+str(kodm,4)
	         skip
	      ENDDO
	   ENDIF
	   USE IN K2
	   sele CURSMAT
	   skip
	enddo
	USE IN CURSMAT

	sele * from mater order by kod into curs c_mat
	wait '���������: ���� ������' window nowait 	                                  
	scan
	   scat memv
	   sele * from dosp where vid=21.and.kod=c_mat.sort.and.us=c_mat.gr ;
	        into curs c_dosp
	   SELECT c_dosp
	   IF RECCOUNT()=0
	      npp=npp+1
	      m.glErrors = m.glErrors+1	
	      do warn with str(npp,4);
	                     +' ��� ������ ����-�� '+str(c_mat.sort,3);
	                     +' �� ������ '+str(c_mat.gr,2);
	                     +' '+c_mat.kod;
	                     +' '+c_mat.naim
	   ENDIF
	   USE IN c_dosp
	   sele * from dosp where vid=22.and.kod=c_mat.sp.and.us=c_mat.sort into curs c_dosp
	   if recc()=0
	      *brow
	      npp=npp+1
	      do warn with str(npp,4);
	                     +' ��� ������ �����.����-�� '+str(c_mat.sp,4);
	                     +' �� ����-� '+str(c_mat.sort,3);
	                     +' '+c_mat.kod;
	                     +' '+c_mat.naim
	   ENDIF
	   USE IN c_dosp
	   IF c_mat.sh#0
	      SELECT * from dosp WHERE vid=23.and.kod=c_mat.sh.and.us=c_mat.gr INTO CURSOR c_dosp
	      if recc()=0
	         npp=npp+1
	         m.glErrors = m.glErrors+1	
	         do warn with str(npp,4);
	                     +' ��� ������ �����.�\C������ '+str(c_mat.sh,4);
	                     +' �� ������ '+str(c_mat.gr,3);
	                     +' '+c_mat.kod;
	                     +' '+c_mat.naim
	      ENDIF
	      USE IN c_dosp
	   ENDIF
	endscan
	*************************************************
	*************************************************


**** �������� ���������
do warn_close

**** ����� ��������� ���� ���� ������
if m.glErrors > 0
	messagebox('����� ���������� '+str(m.glErrors)+' ������. �� �������� �� �� �� ������ ������� ���������� ������ ���������!!! ����� 1 �������� 2004 �. ��������� � �������� �������� �� �����.')
	do form f_viewlog with 'test.log'
endif