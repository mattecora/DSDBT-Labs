@echo off

D:\Utilities\graphviz\bin\dot.exe -Gdpi=300 -Nfontname="Cambria Math" -Gfontname="Cambria Math" ex_tree_orig.gv -Tpng -o ex_tree_orig.png

D:\Utilities\graphviz\bin\dot.exe -Gdpi=300 -Nfontname="Cambria Math" -Gfontname="Cambria Math" ex_tree_opt.gv -Tpng -o ex_tree_opt.png