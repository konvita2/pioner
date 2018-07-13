*!*	* очистить временные файлы перед запуском
*!*	set safety off
*!*	susp
*!*	wait 'Очистка временных файлов' nowait wind

*!*	on error do ErrHandler
*!*	use vrem7 exclu
*!*	zap
*!*	use 

*!*	return

*!*	procedure ErrHandler
*!*		wait 'Error happened' wind nowait
*!*		return
*!*	endproc


*!*	if .not. used('vrem1')
*!*		use vrem1 exclu
*!*		zap
*!*	endif

*!*	if .not. used('vrem2')
*!*		use vrem2 exclu
*!*		zap
*!*	endif

*!*	if .not. used('vrem3')
*!*		use vrem3 exclu
*!*		zap
*!*	endif

*!*	if .not. used('vrem4')
*!*		use vrem4 exclu
*!*		zap
*!*	endif

*!*	if .not. used('vrem5')
*!*		use vrem5 exclu
*!*		zap
*!*	endif

*!*	if .not. used('vrem6')
*!*		use vrem6 exclu
*!*		zap
*!*	endif

*!*	if flock('vrem7')
*!*		use vrem7 exclu
*!*		zap
*!*		use
*!*	endif

*!*	if .not. used('vrem8')
*!*		use vrem8 exclu
*!*		zap
*!*	endif

*!*	if .not. used('vrem9')
*!*		use vrem9 exclu
*!*		zap
*!*	endif

*!*	if .not. used('vrem10')
*!*		use vrem10 exclu
*!*		zap
*!*	endif


*!*	wait '' nowait wind

