.global 	_start
_start: 	la	sp, 	stack
		j 	main
		j	_start
