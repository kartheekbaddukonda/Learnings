#!/bin/bash

# sed = Stream Editor
# A stream is a data that travels from:
# : One proces to another through piped
# : One file to another as a redirect
# : Once device to another  
# Standard Input = Standard input stream etc.
# Streams are typically textual transformations on streams
#   : ex :
#   : Substitute some text for other text
#   : Remove lines
#   : Append text after given lines
#   : Insert text before some lines
# sed is used programatically not interactively

# sed 's/string to be replaced/string to replace/' file_source   : here s refers to substitute
# - the above command send the outout to the console but dont change the original file 
# its case sensitive
# falgs are allowed  
# i / I for case ignore case 

        # [vagrant@localhost vagrant]$ echo 'I love My wife' > love.txt
        # [vagrant@localhost vagrant]$ sed 's/My wife/my job/' love.txt 
        # I love my job
        # [vagrant@localhost vagrant]$ cat love.txt 
        # I love My wife
        # [vagrant@localhost vagrant]$ sed 's/MY WIFE/my job/' love.txt
        # I love My wife
        # [vagrant@localhost vagrant]$ sed 's/MY WIFE/my job/i' love.txt
        # I love my job
        # [vagrant@localhost vagrant]$ sed 's/MY WIFE/my job/I' love.txt
        # I love my job
        # [vagrant@localhost vagrant]$ 

# by default sed replaces only the first occurance of a line in every line , if sed need to look for all occurances in a line use:

# g global

        # [vagrant@localhost vagrant]$ sed 's/MY WIFE/sed/gi' love.txt 
        # I love sed
        # This is line 2
        # This is line 3
        # I love sed with all of my heart
        # I love sed and sed love me. Also sed loves the cat.
        # [vagrant@localhost vagrant]$ cat love.txt
        # I love My wife
        # This is line 2
        # This is line 3
        # I love My wife with all of my heart
        # I love My wife and my wife love me. Also my wife loves the cat.
        # [vagrant@localhost vagrant]$

# 1 for first occurance
# 2 for second occurance 

        # [vagrant@localhost vagrant]$ sed 's/MY WIFE/sed/2' love.txt
        # I love My wife
        # This is line 2
        # This is line 3
        # I love My wife with all of my heart
        # I love My wife and sed love me. Also my wife loves the cat.
        # [vagrant@localhost vagrant]$ 

# in case you want the file to be updated u can use the flag

# -i also if you want a backup of old file u can provide a file extention to -i flag as below.
# -i refers to inplace edit
# make sure you dont put a space after i option which throws an error

        # [vagrant@localhost vagrant]$ ls -l lov* 
        # -rwxrwxrwx 1 vagrant vagrant 145 Jun  1 13:20 love.txt

        # [vagrant@localhost vagrant]$ sed -i.bak 's/My wife/sed/2i' love.txt

        # [vagrant@localhost vagrant]$ ls -l lov*
        # -rwxrwxrwx 1 vagrant vagrant 141 Jun  1 13:30 love.txt    
        # -rwxrwxrwx 1 vagrant vagrant 145 Jun  1 13:20 love.txt.bak

        # [vagrant@localhost vagrant]$ cat love.txt
        # I love My wife
        # This is line 2
        # This is line 3
        # I love My wife with all of my heart
        # I love My wife and sed love me. Also my wife loves the cat.

        # [vagrant@localhost vagrant]$ cat love.txt.bak
        # I love My wife
        # This is line 2
        # This is line 3
        # I love My wife with all of my heart
        # I love My wife and my wife love me. Also my wife loves the cat.
        # [vagrant@localhost vagrant]$ 

# any character works as a delimeter 

        # [vagrant@localhost vagrant]$ echo '/home/kb' | sed 's/\/home\/kb/\/export\/users\/kb/'
        # /export/users/kb

        # so to simplyfy we can use: (in this case # as delimeter)

        # [vagrant@localhost vagrant]$ echo '/home/kb' | sed 's#/home/kb#/export/users/kb#'
        # /export/users/kb

# d flag to delete the search pattern (note that we dont need to pass s in sed for deletion)

        # [vagrant@localhost vagrant]$ cat love.txt
        # I love My wife
        # This is line 2
        # This is line 3
        # I love My wife with all of my heart
        # I love My wife and sed love me. Also my wife loves the cat.
        # [vagrant@localhost vagrant]$ sed '/This/d' love.txt
        # I love My wife
        # I love My wife with all of my heart
        # I love My wife and sed love me. Also my wife loves the cat.


quick recap: 

# sed
# s - substitute
# i - case-insensitive
# g - globally  , 1 - first occurance , 2 - second occurance [...] n - nth occurance 
# gw - if you only want to save the lines where matches were made use this flag.
# d - delete (sed '/abc/d' bbc.txt)


#         ex: $ cat love.txt
#                 i love my wife
#                 i love my wife and my wife loves me too, also my wife love cats
#                 this is a new line

#                 $ sed 's/love/like/gw like.txt' love.txt
#                 i like my wife
#                 i like my wife and my wife likes me too, also my wife like cats
#                 this is a new line

#                 $ cat like.txt
#                 i like my wife
#                 i like my wife and my wife likes me too, also my wife like cats
# its not necessary to have / as delimeter any character can be a delimeter 
#                 $ echo '/home/jason' | sed 's#/home/jason#/home/kb/#'
#                  /home/kb/

search patterns  - 
# ^#  begining of the line matches # 
# ^$  begining of the line immediately followed by ending of the line

to combile multiple seds use semicolon - ;  

                # [vagrant@localhost vagrant]$ cat config
                # #User to run service as
                # User apache

                # # Group to run service as
                # group apache
                # [vagrant@localhost vagrant]$ sed '/^#/d ; /^$/d ; s/apache/httpd/' config
                # User httpd
                # group httpd

        # alternate way is to use -e
        sed -e '/^#/d' -e '/^$/d' -e 's/apache/httpd/' config

# u can have all sed commands in a file and execute another sed by passing this file as input

                # [vagrant@localhost vagrant]$ echo '/^#/d' > sed.script
                # [vagrant@localhost vagrant]$ echo '/^$/d' >> sed.script
                # [vagrant@localhost vagrant]$ echo 's/apache/httpd/' >> sed.script
                # [vagrant@localhost vagrant]$ cat sed.script
                # /^#/d
                # /^$/d
                # s/apache/httpd/
                # [vagrant@localhost vagrant]$ sed -f sed.script config
                # User httpd
                # group httpd

# to apply changes on a specific line itself u can pass the line number after sed abd before operation

                # [vagrant@localhost vagrant]$ sed '2 s/apache/httpd/' config   (or  sed '2s/apache/httpd/' config )
                # #User to run service as
                # User httpd

                # # Group to run service as
                # group apache

# we can apply changes if matches a special string with in the content

                # [vagrant@localhost vagrant]$ sed '/group/ s/apache/httpd/' config
                # #User to run service as
                # User apache

                # # Group to run service as
                # group httpd

# we can pass line numnbers or regex as well

                # [vagrant@localhost vagrant]$ sed '1,3 s/run/execute/' config
                # #User to execute service as
                # User apache

                # # Group to run service as
                # group apache







sed -i  : inplace editing ( to save the file)
sed -i.bak : will perform inpace edit and do a copy of the original file with extension .bak (this estension can be anything)

 

