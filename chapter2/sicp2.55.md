By quoting a quote, we are quoting a two element list:
```
''x = '(quote x)
```
Because of the outer quote (`'`), both quote and x are interpreted as ordinary symbols and do not carry special meanings.

Thus, `car` on this list returns its first element, i.e. the symbol _quote_.

Mystery solved.