PARAMETERS kodkt,mars
*!*	WAIT WINDOW 'swerl.prg kodkt,mars '
create cursor meh (;
	noza n(10),;
	ntp n(4),;
	kko n(4),;
	kodir n(4),;
	d n(6,2),;
	toch1 c(7),;
	toch11 c(7),;
	ip n(2),;
	ds n(5), ;
	shag n(6,2),;
	glub n(4,1),; 
	sh n(7,3),;
	normw n(12,6);
)
*!*	WAIT WINDOW 'DO FORM c:\spektr\moroz\tech\sverl WITH kodkt,mars '
DO FORM sverl WITH kodkt,mars
use in meh

