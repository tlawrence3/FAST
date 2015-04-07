#!/bin/sh

perl -i.orig -pe 's/English/english/;s/\{eng?\}/{english}/;' Lawrence_etal_FAST_rev.*
rm -f *.orig
