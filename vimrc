" basic settings {{{
set encoding=utf-8 " 设置字符编码
set autoread " 自动载入外部修改
set hidden " 允许被修改的 buffer 放到后台
set number " relativenumber
set cursorline " 高亮当前行
" 设置分割方向
set splitright
set splitbelow
" 设置tab相关的
set tabstop=4 " tab size
set shiftwidth=0 " size of < and >, 0 use tabstop
set expandtab " expand tab to space
set laststatus=2 " 始终显示状态栏
set noshowmode " 有了 lightline 不再需要显示 mode
" 关闭交换文件
set noswapfile
" 默认 backspace 无法删除旧内容，用 2 或 indent,eol,start
set backspace=2
" 开启搜索高亮
set hlsearch

augroup filetype_vim " vimrc 内按 marker 折叠
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}


" key mappings {{{
" open and source vimrc file
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" 打开 terminal use c-\c-n to return to normal mode
nnoremap <silent> <leader>tl :vert term<cr>
nnoremap <silent> <leader>tj :term<cr>
" 关闭搜索高亮，下次搜索还会高亮
nnoremap <silent> <esc> :nohlsearch<cr> 
" 快速滚动
nnoremap <c-e> 3<c-e>
nnoremap <c-y> 3<c-y>
" 鼠标滚动
set mouse=a
map <scrollwheelup> <c-y>
map <scrollwheeldown> <c-e>
" 默认不折行，但可切换
set nowrap
nnoremap <silent> <leader>wr :set wrap!<cr>
" 以下 mode 下用 emacs 的 keybinding
" insert mode
inoremap <c-p> <up>
inoremap <c-n> <down>
inoremap <c-b> <left>
inoremap <c-f> <right>
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-d> <del>
" cmd line mode
cnoremap <c-p> <up>
cnoremap <c-n> <down>
cnoremap <c-b> <left>
cnoremap <c-f> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-d> <del>
" terminal mode
tnoremap <c-p> <up>
tnoremap <c-n> <down>
tnoremap <c-b> <left>
tnoremap <c-f> <right>
tnoremap <c-a> <home>
tnoremap <c-e> <end>
tnoremap <c-d> <del>
" }}}


" plugins {{{
call plug#begin('~/fsz.plug')

" theme buffer tab {{{
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
Plug 'lifepillar/vim-solarized8'
let g:lightline = {'colorscheme': 'solarized'}
nnoremap [b :bp<cr>
nnoremap ]b :bn<cr>
" }}}

" vim-floaterm 浮动终端 {{{
Plug 'voldikss/vim-floaterm'
nnoremap <silent> <m-x> :FloatermToggle<cr>
tnoremap <silent> <m-x> <c-\><c-n>:FloatermToggle<cr>
nnoremap <silent> <m-c> :FloatermNew<cr>
tnoremap <silent> <m-c> <c-\><c-n>:FloatermNew<cr>
nnoremap <silent> <m-v> :FloatermNext<cr>
tnoremap <silent> <m-v> <c-\><c-n>:FloatermNext<cr>
" }}}

" nerdtree {{{
Plug 'scrooloose/nerdtree'
let NERDTreeShowHidden=1
nnoremap <silent> <leader>tr :NERDTreeToggle<cr>
nnoremap <silent> <leader>tf :NERDTreeFind<cr>
" }}}

" nerdcommenter {{{
Plug 'preservim/nerdcommenter'
nmap <m-;> <Plug>NERDCommenterToggle
vmap <m-;> <Plug>NERDCommenterToggle<cr>gv
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
" vim 8 / neovim HEAD runtime: when ft==python, cms:=#\ %s
"   -- when g:NERDSpaceDelims==1, then NERDComment results in double space
let g:NERDCustomDelimiters = {
            \ 'python': { 'left': '#', 'right': '' }
            \ }
" }}}

" 自动判断 tabstop {{{
Plug 'tpope/vim-sleuth'
" }}}

" fzf {{{
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
nnoremap <leader>ff :Files<cr>
nnoremap <leader>bb :Buffers<cr>
nnoremap <leader>bl :BLines<cr>
nnoremap <leader>ag :Ag<cr>
nnoremap <leader>rg :Rg<cr>
" }}}

" colorscheme-preview {{{
Plug 'mnishz/colorscheme-preview.vim'
" }}}

" vimspector {{{
if has('unix')
    Plug 'puremourning/vimspector'
    let g:vimspector_enable_mappings = 'HUMAN'
endif
" }}}

" lsp {{{
Plug 'neoclide/coc.nvim', {'branch': 'release'}

set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>fm  <Plug>(coc-format-selected)
nmap <leader>fm  <Plug>(coc-format-selected)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}

" vim-bookmarks {{{
Plug 'MattesGroeger/vim-bookmarks'
let g:bookmark_no_default_key_mappings = 1 " 禁用默认 mapping，避免和 vim 内置 mark 冲突
let g:bookmark_save_per_working_dir = 1 " 会在每个目录下单独生成 vim-bookmarks
let g:bookmark_auto_save = 0 " 自动保存有 bug，暂时不用
let g:bookmark_show_warning = 1 " 清空时提醒
let g:bookmark_show_toggle_warning = 1 " 删除时提醒
let g:bookmark_display_annotation = 1 " 在状态栏显示标注信息
nnoremap <leader>mm <Plug>BookmarkToggle
nnoremap <leader>mi <Plug>BookmarkAnnotate <Plug>BookmarkShowAll
nnoremap <leader>ma <Plug>BookmarkShowAll
nnoremap <leader>mj <Plug>BookmarkNext
nnoremap <leader>mk <Plug>BookmarkPrev
nnoremap <leader>mc <Plug>BookmarkClear
nnoremap <leader>mx <Plug>BookmarkClearAll
nnoremap <leader>mK <Plug>BookmarkMoveUp
nnoremap <leader>mJ <Plug>BookmarkMoveDown
nnoremap <leader>mg <Plug>BookmarkMoveToLine
" }}}

" vim-yggdrasil 一个基础组件，构建 tree view ，以后用 {{{
Plug 'm-pilia/vim-yggdrasil'
" }}}

" google/vim-maktaba 那一堆 {{{
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
augroup autoformat_settings
    autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
    autocmd FileType go AutoFormatBuffer gofmt
    autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer prettier
    autocmd FileType python AutoFormatBuffer black
augroup END
" }}}

" vim-startuptime 启动时间 benchmark {{{
Plug 'dstein64/vim-startuptime'
" }}}

call plug#end()
" }}}


" my functions {{{

" function! ToggleDarkLight {{{
let s:fsz_dark_light = 0
function! ToggleDarkLight()
    if s:fsz_dark_light == 1
        let s:fsz_dark_light = 0
        set background=dark
    else
        let s:fsz_dark_light = 1
        set background=light
    endif
endfunction
nnoremap <silent><leader>th :call ToggleDarkLight()<cr>
" }}}

" function! AutoDarkLight {{{
function! AutoDarkLight()
    " 按时间设置默认暗色或亮色
    let hour = strftime("%H")
    if 6 <= hour && hour < 18
        let s:fsz_dark_light = 1
        set background=light
    else
        let s:fsz_dark_light = 0
        set background=dark
    endif
endfunction
" }}}

" function! SetWindowAndFontSize {{{
let s:fsz_font_index = 1
function! SetWindowAndFontSize()
    let size_list = [9, 11, 12, 14, 18]
    let s:fsz_font_index  = min([max([s:fsz_font_index, 0]), len(size_list) - 1])
    let font_size = size_list[s:fsz_font_index]
    if font_size == 9
        set guifont=Sarasa\ Term\ Slab\ SC:h9
        winpos 500 250
        winsize 170 35
    elseif font_size == 11
        set guifont=Sarasa\ Term\ Slab\ SC:h11
        winpos 450 250
        winsize 170 35
    elseif font_size == 12
        set guifont=Sarasa\ Term\ Slab\ SC:h12
        winpos 400 200
        winsize 170 35
    elseif font_size == 14
        set guifont=Sarasa\ Term\ Slab\ SC:h14
        winpos 250 150
        winsize 170 35
    elseif font_size == 18
        set guifont=Sarasa\ Term\ Slab\ SC:h18
        winpos 9999 9999
        winsize 9999 9999
    else
        echo "wrong font size"
    endif
endfunction
function! IncreaseFontSize()
    let s:fsz_font_index = s:fsz_font_index + 1
    call SetWindowAndFontSize()
endfunction
function! DecreaseFontSize()
    let s:fsz_font_index = s:fsz_font_index - 1
    call SetWindowAndFontSize()
endfunction
nnoremap <silent><m-g>+ :call IncreaseFontSize()<cr>
nnoremap <silent><m-g>- :call DecreaseFontSize()<cr>
" }}}

" }}}


" last settings {{{

colorscheme solarized8
syntax enable
call ToggleDarkLight()

if has('gui_running')
    set guioptions-=m  "menu bar
    set guioptions-=T  "toolbar
    set guioptions-=r  "right scrollbar
    set guioptions-=L  "left scrollbar
    let s:fsz_font_index = 1
    call SetWindowAndFontSize()
else
    set t_Co=256
endif

" }}}
