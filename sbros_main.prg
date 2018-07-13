 open database db
 
 select kod,im,ribf,shwz from izd into cursor c_izd
 
 scan all
 	insert into 555 ;
 		(kodm, naim, ei,oboz,shwz) ;
 		values ;
 		(c_izd.kod,c_izd.im, 'izdel', c_izd.ribf, c_izd.shwz)
 endscan
 
 use in c_izd
 
 close databases 