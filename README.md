# ghcjs-stack
align ghcjs with stack (lts6 branch)

#depricated in favour of https://github.com/tolysz/prepare-ghcjs


Allow to create ghcjs installation archive which has the same versions as the `stack --resolver`

exceptions:
`integer-gmp` - this needs some love to makie it 
`cabal`  
`ghc-prim`

downside is we need to maintain patches for all versions we have...

Ocasionally I run the script myself and upload results to:

http://tolysz.org/ghcjs

But this is a proof of concept; and we need to find a way to make it more streamline.

Or even easier:
https://github.com/tolysz/reflex-todomvc @ stack-experimental branch
