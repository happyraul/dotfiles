function pytest#runTest() abort
  const l:file = expand('%:p')
  if empty(l:file)
    return
  else
    const l:func = search('^\s*def', 'bcnW')->getline()
          \ ->substitute('^\s*def\s*\(\k*\).*', '\1', '')
    const l:cmd = printf('!pytest %s%s',
          \ l:file,
          \ (empty(l:func) ? '' : '::'.l:func))
    execute l:cmd
  endif
endfunction
