proc wio

fl='w.txt'


WAIT WINDOW "�������� �����������..." NOWAIT 

set  print to &fl
set  device to print
   
SELECT * from instr where !empt(datap) AND pri=1 order by im ;
      INTO CURSOR cinstr
go top
if .not.eof()
   @prow()+1,0 say '                   ���������'
   @prow()+1,0 say '              ������������(��������) �������� �����������' 
   @prow()+1,0 say '              �� ��������� �� '+dtoc(date())+' �.'
   @prow()+1,0 say '--------------------------------------------------------------------------------'
   @prow()+1,0 say ' � : �����.: ����������                            : �������� :������. :��������'
   @prow()+1,0 say '�/�:   �   :                                       :   ����   : ����   :�������.'
   @prow()+1,0 say '   :       :                                       : �������� :��������:        '
   @prow()+1,0 say '--------------------------------------------------------------------------------'

   npp=0
   do while .not.eof()
         npp=npp+1
         @prow()+1,0 say str(npp,3)+' '+str(kodi,3)+' ';
                        +im+' '+dtoc(datap)+' '+dtoc(datab)+' '+ti
      sele cinstr
      skip
   enddo
ENDIF
USE IN cinstr
SELECT * from instr where !empt(datap) AND pri=2 order by im ;
      INTO CURSOR cinstr
go top
if .not.eof()
   @prow()+1,0 say '                   ���������'
   @prow()+1,0 say '              ������������(��������) ������������ �����������' 
   @prow()+1,0 say '              �� ��������� �� '+dtoc(date())+' �.'
   @prow()+1,0 say '--------------------------------------------------------------------------------'
   @prow()+1,0 say ' � : �����.: ����������                            : �������� :������. :��������'
   @prow()+1,0 say '�/�:   �   :                                       :   ����   :  ����  :�������.'
   @prow()+1,0 say '   :       :                                       : �������� :��������:        '
   @prow()+1,0 say '--------------------------------------------------------------------------------'

   npp=0
   do while .not.eof()
      npp=npp+1
      @prow()+1,0 say str(npp,3)+' '+str(kodi,3)+' ';
                     +im+' '+dtoc(datap)+' '+dtoc(datab)+SPACE(6)+ti
      sele cinstr
      skip
   enddo
ENDIF
USE IN cinstr
SELECT * from instr where !empt(datap) AND pri=3 order by im ;
      INTO CURSOR cinstr

go top
if .not.eof()
      @prow()+1,0 say '                   ���������'
   @prow()+1,0 say '              ������������(��������) ���������������� �����������' 
   @prow()+1,0 say '              �� ��������� �� '+dtoc(date())+' �.'
 
   @prow()+1,0 say '--------------------------------------------------------------------------------'
   @prow()+1,0 say ' � : �����.: ����������                            : �������� :������. :��������'
   @prow()+1,0 say '�/�:   �   :                                       :   ����   : ����   :�������.'
   @prow()+1,0 say '   :       :                                       : �������� :��������:        '
   @prow()+1,0 say '--------------------------------------------------------------------------------'

 
   npp=0
   do while .not.eof()
      npp=npp+1
      @prow()+1,0 say str(npp,3)+' '+str(kodi,3)+' ';
                     +im+' '+dtoc(datap)+' '+dtoc(datab)+' '+ti
      
      sele cinstr
      skip
   enddo
endif
USE IN cinstr

SET PRINTER to
set device to screen
 WAIT WINDOW "������������ ��������� ��������." NOWAIT  
		     loWord=CreateObject("Word.Application")       
            loWord.Application.visible=.T.
            WITH  loWord
            	.Documents.open(sys(5)+sys(2003)+"\w.txt",.f.,.t.,.f.,'','',.t.,'','',4,1251)
            	.DisplayAlerts=.F.
            ENDWITH 
            RELEASE loWord  


retu
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


