import sys
keyword_dir=sys.argv[1]
f=open('tmp/new_ctm').read().splitlines()
v=open('%s/rttm'%keyword_dir,'w')	
for i in f:
    v.write("LEXEME ")
    v.write(i)
    v.write(" <NA> <NA> <NA>")
    v.write("\n")
v.close()

