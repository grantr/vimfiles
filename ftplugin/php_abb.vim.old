" vim:fdm=marker:
"
" $Id: php_abb.vim,v 1.3 2003/05/26 16:21:50 culley Exp culley $
"
" see the help file for documentation
"
" {{{ changelog
" ======================================================================
" Version: 1.1
" New Functions: is_null, is_numeric, empty
" New Settings: g:phpNewlineBeforeBrace, g:phpFoldMarkerFunctions,
"               g:phpRequireIncludeParens
" ======================================================================
" }}}
" {{{ default settings
if !exists("g:phpLeader")
    let g:phpLeader = "php"
endif

if !exists("g:phpUseFunctionNames")
    let g:phpUseFunctionNames = 1
endif

if !exists("g:phpFoldMarkerFunctions")
    let g:phpFoldMarkerFunctions = 0
endif

if !exists("g:phpRequireIncludeParens")
    let g:phpRequireIncludeParens = 1
endif

if exists("g:phpNewlineBeforeBrace") && g:phpNewlineBeforeBrace == 1
    let s:separator = "<cr>"
else
    let s:separator = " "
endif

" }}}
" {{{ functions 
" {{{ CreateAbbreviations
function! CreateAbbreviations(phpFunction, aliases, expandTo)

    "if a:phpFunction contains a value, and g:usePhpFunctionNames is properly
    "setcreate an abbreviation without prefixing g:phpLeader
    if strlen(a:phpFunction) > 0 && g:phpUseFunctionNames == 1
        exec "iab <buffer> " . a:phpFunction . " " . a:expandTo
        exec "iab <buffer> " . g:phpLeader . a:phpFunction . " " . a:expandTo
    elseif strlen(a:phpFunction) > 0 
        exec "iab <buffer> " . g:phpLeader . a:phpFunction . " " . a:expandTo
    endif

    "set up aliases
    let l:pattern = "^[^ ]*[ ]"
    let l:aliases = a:aliases . " "
    let l:value = matchstr(l:aliases, l:pattern)
    let l:position = 0
    
    while strlen(l:value) > 0 
        exec "iab <buffer> " . g:phpLeader . l:value . " " . a:expandTo
        let l:position = matchend(l:aliases, l:pattern, l:position)
        let l:value = matchstr(l:aliases, l:pattern, l:position)
    endwhile
    
endfunction 
" }}}
" {{{ ReplacePlaceHolder
function! ReplacePlaceHolder()

    let flags = "W"
    if search("<", flags)
        exec "normal vf>s"
    endif

endfunction 
" }}}
" {{{ PhpActOnVariable
function! PhpActOnVariable()
    let l:php_function = input("Function (? for list): ")

    "escape s:separator if necessary
    if s:separator == "<cr>"
        let l:separator = "\<cr>"
    else
        let l:separator = " "
    endif

    if l:php_function =~ '^array_push$\|^ap$'
        exec "normal yiwoa\<esc>array_push($\<esc>pa, X);\<esc>FXs"
    elseif l:php_function =~ '^array_map$\|^am$' 
        exec "normal yiwo$\<esc>pa = a\<esc>array_map('X', $\<esc>pa);\<esc>FXs"
    elseif l:php_function =~ '^count$\|^cnt$' 
        exec "normal yiwo$X = c\<esc>aount($\<esc>pa);\<esc>FXs"
    elseif l:php_function =~ '^echo$\|^e$\|^print$\|^p$' 
        exec "normal yiwoe\<esc>acho $\<esc>pa;\<esc>"
    elseif l:php_function =~ '^echoexit\|ee$' 
        exec "normal yiwoe\<esc>acho $\<esc>pa;\<cr>exit;\<esc>"
    elseif l:php_function =~ '^echobr$\|^ebr$\|^printbr$\|^pbr$' 
        exec "normal yiwoe\<esc>acho \"$\<esc>pa<br />\";\<esc>"
    elseif l:php_function =~ '^empty$\|^em$' 
        exec "normal yiwoif (e\<esc>ampty($\<esc>pa))" . l:separator . "{X\<cr>}\<esc>?X\<cr>s"
    elseif l:php_function =~ '^explode$\|^exp$\|^split$\|^spl$' 
        exec "normal yiwo$X = e\<esc>axplode(\"<separator>\", $\<esc>pa);\<esc>FXs"
    elseif l:php_function =~ '^extract$\|^ext$' 
call CreateAbbreviations("", "em empty", "empty($X)<esc>FXs<c-o>:call getchar()<cr>")
        exec "normal yiwoe\<esc>axtract($\<esc>pa, EXTR_OVERWRITE);\<esc>"
    elseif l:php_function =~ '^foreach$\|^fore$' 
        exec "normal yiwof\<esc>aoreach ($\<esc>pa as $k => $v)" . l:separator . "{X\<cr>}\<esc>?X\<cr>s"
    elseif l:php_function =~ '^htmlspecialchars$\|^hsc$' 
        exec "normal yiwo$\<esc>pa = h\<esc>atmlspecialchars($\<esc>pa);\<esc>"
    elseif l:php_function =~ '^implode$\|^imp$\|^join$\|^j$' 
        exec "normal yiwo$X = i\<esc>amplode(\"<separator>\", $\<esc>pa);\<esc>FXs"
    elseif l:php_function =~ '^is_null$\|^isn$' 
        exec "normal yiwoif (i\<esc>as_null($\<esc>pa))" . l:separator . "{X\<cr>}\<esc>?X\<cr>s"
    elseif l:php_function =~ '^is_numeric$\|^isnum$' 
        exec "normal yiwoif (i\<esc>as_numeric($\<esc>pa))" . l:separator . "{X\<cr>}\<esc>?X\<cr>s"
    elseif l:php_function =~ '^isset$\|^iss$' 
        exec "normal yiwoif (i\<esc>asset($\<esc>pa))" . l:separator . "{X\<cr>}\<esc>?X\<cr>s"
    elseif l:php_function =~ '^preg_match$\|^prm$' 
        exec "normal yiwoif (p\<esc>areg_match('/X/', $\<esc>pa, $matches))" . l:separator . "{\<cr>}\<esc>?X\<cr>s"
    elseif l:php_function =~ '^print_r$\|^pr$' 
        exec "normal yiwoecho \"<pre>\";\<cr>p\<esc>arint_r($\<esc>pa);\<cr>echo \"</pre>\";\<esc>"
    elseif l:php_function =~ '^print_rc$\|^prc$' 
        exec "normal yiwop\<esc>arint_r($\<esc>pa);\<esc>"
    elseif l:php_function =~ '^strlen$\|^strl$' 
        exec "normal yiwo$X = s\<esc>atrlen($\<esc>pa);\<esc>FXs"
    elseif l:php_function =~ '^strcasecmp$\|^strcc$' 
        exec "normal yiwoif (!s\<esc>atrcasecmp($\<esc>pa, 'X'))" . l:separator . "{\<cr>}\<esc>?X\<cr>s"
    elseif l:php_function =~ '^strcmp$\|^strc$' 
        exec "normal yiwoif (!s\<esc>atrcmp($\<esc>pa, 'X'))" . l:separator . "{\<cr>}\<esc>?X\<cr>s"
    elseif l:php_function =~ '^strstr$\|^strs$' 
        exec "normal yiwo$\<esc>pa = s\<esc>atrstr($\<esc>pa, 'X');\<esc>FXs"
    elseif l:php_function =~ '^str_replace$\|^strr$' 
        exec "normal yiwo$\<esc>pa = s\<esc>atr_replace(X, <replace>, $\<esc>pa);\<esc>FXs"
    elseif l:php_function =~ '^strtolower$\|^strtl$' 
        exec "normal yiwo$\<esc>pa = s\<esc>atrtolower($\<esc>pa);\<esc>"
    elseif l:php_function =~ '^strtoupper$\|^strtu$' 
        exec "normal yiwo$\<esc>pa = s\<esc>atrtoupper($\<esc>pa);\<esc>"
    elseif l:php_function =~ '^substr$\|^ss$' 
        exec "normal yiwo$\<esc>pa = s\<esc>aubstr($\<esc>pa, X);\<esc>FXs"
    elseif l:php_function =~ '^switch$\|^sw$' 
        exec "normal yiwoswitch ($\<esc>pa)" . l:separator . "{\<cr>Case X:\<cr>break;\<cr>}\<up>\<left>\<tab>\<up>\<esc>^i\<tab>\<esc>?X\<cr>s"
    elseif l:php_function =~ '^unset$\|^u$' 
        exec "normal yiwou\<esc>anset($\<esc>pa);\<esc>"
    elseif l:php_function =~ '^while$\|^wh$' 
        exec "normal yiwowhile ($\<esc>pa X)" . l:separator . "{\<cr>}\<esc>?X\<cr>s"
    elseif l:php_function =~ '^wordwrap$\|^ww$' 
        exec "normal yiwo$\<esc>pa = w\<esc>aordwrap($\<esc>pa, X);\<esc>FXs"
    elseif l:php_function == "?"
        echo "array_push       (ap)    -- push value onto the array variable under the cursor"
        echo "array_map        (am)    -- set the array variable under the cursor equal to an array_map of itself"
        echo "count            (cnt)   -- set a new variable equal to count() of the array variable under the cursor"
        echo "echo             (e)     -- echo the variable under the cursor"
        echo "echobr           (ebr)   -- echo the variable under the cursor including <br />"
        echo "echoexit         (ee)    -- echo the variable under the cursor and exit the script"
        echo "empty            (em)    -- create an empty if block for the variable under the cursor"
        echo "explode          (exp)   -- set a new variable equal to exploding the array variable under the cursor"
        echo "split            (spl)   -- synonym for explode"
        echo "extract          (ext)   -- extract the array variable under the cursor-- defaults to EXTR_OVERWRITE"
        echo "foreach          (fore)  -- creates a foreach block on the (array) variable under the cursor"
        echo "htmlspecialchars (hsc)   -- set a variable equal to itself filtered through htmlspecialchars"
        echo "implode          (imp)   -- set a new variable equal to imploding the array variable under the cursor"
        echo "isset            (iss)   -- create an isset if block for the variable under the cursor"
        echo "is_null          (isn)   -- create an is_null if block for the variable under the cursor"
        echo "is_numeric       (isnum) -- create an is_numeric if block for the variable under the cursor"
        echo "join             (j)     -- synonym for implode"
        echo "preg_match       (prm)   -- create an if block for a preg_match on the variable under the cursor"
        echo "print            (p)     -- alias for echo"
        echo "printbr          (pbr)   -- alias for echobr"
        echo "print_r          (pr)    -- print_r for the variable under the cursor-- wrapped in <pre> tags"
        echo "print_rc         (prc)   -- print_r for the variable under the cursor-- not wrapped in <pre> tags"
        echo "strcasecmp       (strcc) -- create an if block for a strcasecmp on the variable under the cursor"
        echo "strcmp           (strc)  -- create an if block for a strcmp on the variable under the cursor"
        echo "strlen           (strl)  -- set a new variable equal to the length of the variable under the cursor"
        echo "strstr           (strs)  -- set a variable equal to itself passed through strstr"
        echo "str_replace      (strr)  -- set a variable equal to itself passed through str_replace"
        echo "strtolower       (strtl) -- set a variable equal to itself lowercase"
        echo "strtoupper       (strtu) -- set a variable equal to itself uppercase"
        echo "substr           (ss)    -- set a variable equal to a substring of itself"
        echo "switch           (sw)    -- create a switch block on the variable under the cursor"
        echo "unset            (u)     -- unset the variable under the cursor"
        echo "while            (wh)    -- create a while block on the variable under the cursor"
        echo "wordwrap         (ww)    -- wordwrap the variable under cursor.  expects <width>"
    else
        echo "Unknown or Unsupported Function"
    endif
    
endfunction 
" }}}
" {{{ phpFunction
function! PhpFunction()

    let l:funk = input("Function name? ")
    if g:phpFoldMarkerFunctions == 1
        exec "normal O\/\/ {{{ function" . l:funk . "\nfunction" . l:funk . "(X)\n{\n\n}\n\/\/ }}}\n\e5k$hs" 
    else
        exec "normal Ofunction" . l:funk . "(X)\n{\n\n}\e3k$hs" 
    endif

endfunction 
" }}}
" }}}
" {{{ abbreviations
 
" array key exists and variants
call CreateAbbreviations("array_key_exists", "ake", "array_key_exists('X', $<array>)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "cke", "array_key_exists('X', $_COOKIE)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "gke", "array_key_exists('X', $_GET)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "pke", "array_key_exists('X', $_POST)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "ske", "array_key_exists('X', $_SESSION)<esc>FXs<c-o>:call getchar()<cr>")

call CreateAbbreviations("array_map", "am", "array_map(\"X\", $<aray>);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("array_push", "ap", "array_push($X, <mixed>);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("htmlspecialchars", "hsc", "htmlspecialchars($X);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "coookie ck", "$_COOKIE['X']<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "c cnt count", "count($X);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "class", "class X" . s:separator . "{<cr>}<esc>?X<cr>s<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "e echo", "echo 'X';<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "em empty", "empty($X)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "env", "$_ENV['X']<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "exp explode spl split", "explode('X', $<string>);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "ext extract", "extract($x, EXTR_OVERWRITE);<esc>Fxs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "for", "for ($i = 0; $iX; $i++)" . s:separator . "{<cr>}<esc>?X<cr>s<c-o>:call getchar()<cr>")
call CreateAbbreviations("foreach", "fore", "foreach ($X as $k => $v)" . s:separator . "{<cr>}<esc>?X<cr>s<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "func", "<ESC>:call PhpFunction()<cr>")
call CreateAbbreviations("", "get", "$_GET['X']<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "h", "<?php<cr>X<cr>?><esc>?X<cr>s<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "if", "if ($X)" . s:separator . "{<cr>}<esc>?X<cr>s<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "ife", "if ($X)" . s:separator . "{<cr>}" . s:separator . "else" . s:separator . "{<cr>}<esc>?X<cr>s<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "ifeif", "if ($X)" . s:separator . "{<cr>}" . s:separator . "elseif (<expression>)" . s:separator . "{<cr>}" . s:separator . "else" . s:separator . "{<cr>}<esc>?X<cr>s<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "ifl ift", "$X = (<expression>) ? <true> : <false>;<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("implode", "imp join j", "implode('X', $<array>);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("isset", "iss", "isset($X)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("is_null", "isn isnull", "is_null($X)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("is_numeric", "isnum isnuumeric", "is_numeric($X)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "o", "<?= $X ?><esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "p print", "print(\"X\");<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("preg_match", "prm", "preg_match('/X/', $<string>, $matches)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "post", "$_POST['X']<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("print_r", "pr", "print_r($X)<esc>FXs<c-o>:call getchar()<cr>")

if g:phpRequireIncludeParens == 1
    call CreateAbbreviations("require_once", "req", "require_once('X');<esc>FXs<c-o>:call getchar()<cr>")
    call CreateAbbreviations("", "require", "require('X');<esc>FXs<c-o>:call getchar()<cr>")
    call CreateAbbreviations("include_once", "inc", "include_once('X');<esc>FXs<c-o>:call getchar()<cr>")
    call CreateAbbreviations("", "include", "include('X');<esc>FXs<c-o>:call getchar()<cr>")
else
    call CreateAbbreviations("require_once", "req", "require_once 'X';<esc>FXs<c-o>:call getchar()<cr>")
    call CreateAbbreviations("", "require", "require 'X';<esc>FXs<c-o>:call getchar()<cr>")
    call CreateAbbreviations("include_once", "inc", "include_once 'X';<esc>FXs<c-o>:call getchar()<cr>")
    call CreateAbbreviations("", "include", "include 'X';<esc>FXs<c-o>:call getchar()<cr>")
endif

call CreateAbbreviations("strcasecmp", "strcc scc", "strcasecmp($X, <string>)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("strcmp", "strc sc", "strcmp($X, <string>)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "self", "$_SERVER['PHP_SELF']<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "server", "$_SERVER['X']<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "sess session", "$_SESSION['X']<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "sn servername", "$_SERVER['SERVER_NAME']<c-o>:call getchar()<cr>")
call CreateAbbreviations("strpos", "sp spos", "strpos($X,'<string>');<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("strstr", "strs", "strstr($X, '<string>')<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("substr", "subs substring", "substr($X, <start>);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("strlen", "strl strlength", "strlen($X)<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("str_replace", "strr", "str_replace(X, <replace>, $<subject>);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("strtolower", "strtl lower", "strtolower($X);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("strtoupper", "strtu upper", "strtoupper($X);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "sw switch", "switch ($X)" . s:separator . "{<cr>case <case>:<cr>break;<cr>}<esc>?X<cr>s<c-o>:call getchar()<cr>")
call CreateAbbreviations("trigger_error", "te", "trigger_error(\"X\", E_USER_ERROR);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("unset", "us", "unset($X);<esc>FXs<c-o>:call getchar()<cr>")
call CreateAbbreviations("", "while", "while (X)" . s:separator . "{<cr>}<esc>?X<cr>s<c-o>:call getchar()<cr>")
call CreateAbbreviations("wordwrap", "ww", "wordwrap($X, <width>);<esc>FXs<c-o>:call getchar()<cr>")
" }}}
