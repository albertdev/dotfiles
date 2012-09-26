" Vim syntax file
" Language:	log4j log file
" Maintainer:	jacobsb
" Last Change:	Fr, 24 Feb 2010
" Filenames:	

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

"syn case ignore

" strings
"syn region  catalogString start=+"+ skip=+\\\\\|\\"+ end=+"+ keepend
"syn region  catalogString start=+'+ skip=+\\\\\|\\'+ end=+'+ keepend

"syn region  catalogComment      start=+--+   end=+--+ contains=catalogTodo
"syn keyword catalogTodo		TODO FIXME XXX NOTE contained
"syn keyword catalogKeyword	DOCTYPE OVERRIDE PUBLIC DTDDECL ENTITY CATALOG
syn keyword ErrorLvl		ERROR FATAL
syn keyword WarningLvl		WARN
syn keyword InfoLvl		INFO
syn keyword DebugLvl		TRACE DEBUG

" The default highlighting.
"hi def link catalogString		     String
"hi def link catalogComment		     Comment
"hi def link catalogTodo			     Todo
"hi def link catalogKeyword		     Statement
hi def link ErrorLvl		ErrorMsg
hi def link WarningLvl		Todo
hi def link InfoLvl		Normal
hi def link DebugLvl		logFaint
hi def logFaint ctermfg=LightGray guiFg=LightGray

let b:current_syntax = "log4j"
