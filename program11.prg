		insert into kt ;
			(dat_v,d_u,kornw,;
			pozn,poznw,poznd,;
			kornd,gr,sort,;
			kodm,ei,kol,ei1,kol1,;
			koli,shw,naimd,;
			naimw,zo,kodm1,;
			kttp,nrmd,mar1,;
			);
			values;
			(date(),5,get_kornw_by_shw_kornd(thisform.p_svshw,thisform.p_svkornd),;
			get_izd_ribf_by_kod(thisform.p_svshw),get_poznw_by_shw_kornd(thisform.p_svshw,thisform.p_svkornd),get_poznd_by_shw_kornd(thisform.p_svshw,thisform.p_svkornd),;
			thisform.p_svkornd,get_mater_gr(c500.kodm),get_mater_sort(c500.kodm),;
			c500.kodm,get_mater_ei(c500.kodm),1,get_mater_ei1(c500.kodm),1,;
			1,thisform.p_svshw,get_naimd_by_shw_kornd(thisform.p_svshw,thisform.p_svkornd),;
			get_naimw_by_shw_kornd(thisform.p_svshw,thisform.p_svkornd),1,c500.kodm,;
			c500.kttp,c500.sumnrmd,20)