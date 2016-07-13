" MRU

" run :MRU when vim is opened without any file
function! NoFile()
    if @% == ""
        :MRU
    endif
endfunction
autocmd VimEnter * call NoFile()


" vim-surround

function! LookLeft(char)
    let column = 2
    while col('.')-column >= 0
        let char = getline('.')[col('.')-column]
        if char == a:char
            return 1
        endif
        let column += 1
    endwhile
    return 0
endfunc

function! LookRight(char)
    let column = 0
    while col('.')+column <= col('$')
        let char = getline('.')[col('.')+column]
        if char == a:char
            return 1
        endif
        let column += 1
    endwhile
    return 0
endfunc

function! ChangeDetectedSurrounding()
    let pairs = {'(': ')', '[': ']', '{': '}', '<': '>',
               \ '`': '`', '"': '"', "'": "'"}
    let chars = ['.', ',', ';', ':', '~', '-', '=',
               \ '!', '?', '/', '\', '|']
    let surroundings = copy(chars)
    for pair in items(pairs)
        call extend(surroundings, pair)
    endfor
    let char = getline('.')[col('.')-1]
    if index(surroundings, char) >= 0
        echo "cs" . char
        return "cs" . char
    endif
    for pair in items(pairs)
        if LookLeft(pair[0]) && LookRight(pair[1])
            echo "cs" . pair[0]
            return "cs" . pair[0]
        endif
    endfor
    for char in chars
        if LookLeft(char) && LookRight(char)
            echo "cs" . char
            return "cs" . char
        endif
    endfor
endfunction

nmap <expr> cd ChangeDetectedSurrounding()


" NERD Commenter

let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

" lightline.vim

set noshowmode

augroup LightLineColorscheme
    autocmd!
    autocmd ColorScheme * call s:lightline_update()
augroup END

function! s:lightline_update()
    if !exists('g:loaded_lightline')
        return
    endif
    try
        if g:colors_name =~# 'wombat\|solarized\|landscape\
                            \ |jellybeans\|seoul256\|Tomorrow'
            let g:lightline.colorscheme =
                \ substitute(substitute(g:colors_name, '-', '_', 'g'),
                           \ '256.*', '', '') .
                \ (g:colors_name ==# 'solarized' ? '_' . &background : '')
            call lightline#init()
            call lightline#colorscheme()
            call lightline#update()
        endif
    catch
    endtry
endfunction


" UltiSnips

" Use <CR> to accept snippets
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:ulti_expand_res = 0
function! SnippetOrCR()
    let snippet = UltiSnips#ExpandSnippet()
    if g:ulti_expand_res > 0
        return snippet
    else
        return CROrUncomment()
    endif
endfunction
inoremap <silent><expr> <CR> "<C-R>=SnippetOrCR()<CR>"


" Reedes

augroup reedes
  autocmd!
  autocmd FileType markdown,mkd,text,tex call pencil#init()
                                     \ | call textobj#sentence#init()
augroup END

let g:pencil#conceallevel = 0
let g:pencil#textwidth = &textwidth


" incsearch.vim

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

let g:indexed_search_mappings = 0
augroup incsearch-indexed
    autocmd!
    autocmd User IncSearchLeave ShowSearchIndex
augroup END

nnoremap <silent>n nzv:ShowSearchIndex<CR>
nnoremap <silent>N Nzv:ShowSearchIndex<CR>


" vim-pandoc

let g:pandoc#after#modules#enabled = ["ultisnips"]
let g:pandoc#syntax#conceal#use = 0


" vim-sneak

let g:sneak#use_ic_scs = 1
hi clear SneakPluginTarget
hi link SneakPluginTarget Search

"replace 'f' with 1-char Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
"replace 't' with 1-char Sneak
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T


" vim-expand-region

call expand_region#custom_text_objects({
    \ 'i(': 1, 'i)': 1, 'ib': 1, 'i{': 1, 'i}': 1, 'iB': 1,
             \ 'i[': 1, 'i]': 1, 'i<': 1, 'i>': 1, 'it': 1,
    \ 'A(': 1, 'A)': 1, 'Ab': 1, 'A{': 1, 'A}': 1, 'AB': 1,
             \ 'A[': 1, 'A]': 1, 'A<': 1, 'A>': 1, 'At': 1,
    \ "i'": 1, 'i"': 1, 'i`': 1, "A'": 1, 'A"': 1, 'A`': 1,
    \ 'i,': 1, 'i;': 1, 'A,': 1, 'A;': 1, 'as': 1, 'is': 1,
    \ 'ii': 1, 'ai': 1,
    \ })


" incsearch.vim

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


" yankstack

let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y']
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste


" Vimtex

let g:vimtex_indent_bib_enabled = 0
let g:vimtex_fold_enabled = 1
let g:latex_fold_preamble = 1
let g:vimtex_fold_envs = 0
let g:vimtex_fold_sections = []


" NeoComplete

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags


" neocomplete/Vimtex compatibility

if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.tex =
        \ '\v\\%('
        \ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
        \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
        \ . '|hyperref\s*\[[^]]*'
        \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
        \ . '|%(include%(only)?|input)\s*\{[^}]*'
        \ . '|\a*(gls|Gls|GLS)(pl)?\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
        \ . '|includepdf%(\s*\[[^]]*\])?\s*\{[^}]*'
        \ . '|includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*'
        \ . ')'

let last_spell_changedtick = -1
let last_spell_count = 1

