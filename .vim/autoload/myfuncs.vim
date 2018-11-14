function! s:PasteEscaped()
  echo "\\".getcmdline()."\""
  let char = getchar()
  if char == "\<esc>"
    return ''
  else
    let register_content = getreg(nr2char(char))
    let escaped_register = escape(register_content, '\'.getcmdtype())
    let escaped_register2 = substitute(escaped_register,'[','\\[','g')
    let escaped_register3 = substitute(escaped_register2,']','\\]','g')
    return substitute(escaped_register3, '\n', '\\n', 'g')
  endif
endfunction

