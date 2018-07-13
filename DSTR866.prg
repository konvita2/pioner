&&****************************************
FUNCTION str866(nfil)
n_f=FOPEN(nfil,2)
FSEEK(n_f,29)
iosb=FWRITE(n_f,"e")
FCLOSE(n_f)
RETURN iosb
