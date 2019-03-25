cocurrent 'jpacman'
coinsert 'j'

BASELIB=: 'base library'
DATAMASK=: 0
HWNDP=: ''
ISGUI=: 0
INITDONE=: 0
HASFILEACCESS=: 0
HASADDONSDIR=: 0
ONLINE=: 0
PKGDATA=: 0 7$a:
SECTION=: ,<'All'
SYSNAME=: 'Package Manager'
TIMEOUT=: 60
WWWREV=: REV=: _1

IgnoreIOS=: 0 : 0
api/jni
data/dbman
data/ddmysql
data/odbc
demos/isigraph
demos/wd
demos/wdplot
games/minesweeper
games/nurikabe
games/pousse
games/solitaire
general/pcall
general/sfl
graphics/d3
graphics/fvj3
graphics/fvj4
graphics/gnuplot
graphics/graph
graphics/graphviz
graphics/grid
graphics/jturtle
graphics/print
graphics/tgsj
graphics/treemap
gui/monthview
gui/util
ide/qt
ide/ja
ide/jnet
math/tabula
media/animate
media/gdiplus
media/image3
media/imagekit
media/ming
media/paint
media/wav
)

Ignore=: 3 : 0''
if. IFIOS do.
  <;._2 IgnoreIOS
else.
  <'ide/ios'
end.
)
3 : 0''
HTTPCMD=: ''
nc=. '--no-cache'
if. IFUNIX do.
  IFWGET=. IFCURL=. 0
  if. -. IFIOS +. UNAME-:'Android' do.
    try.
      2!:0'which wget 2>/dev/null'
      IFWGET=. 1 catch. end.
    try.
      2!:0'which curl 2>/dev/null'
      IFCURL=. 1 catch. end.
  end.
  if. IFCURL>IFWGET do.
    HTTPCMD=: 'curl -L -o %O --stderr %L -f -s -S %U'
  elseif. IFWGET do.
    if. 'Android'-:UNAME do. nc=. ''
    else. try. nc=. nc #~ 1 e. nc E. shell 'wget --help' catch. nc=. '' end. end.
    HTTPCMD=: 'wget ',nc,' -O %O -o %L -t %t %U'
  end.
else.
  busybox=. 0
  if. fexist exe=. jpath '~tools/ftp/wget.exe' do. exe=. '"',exe,'"'
  elseif. fexist exe=. jpath '~tools/ftp/busybox.exe' do. exe=. '"',exe,'" wget' [ busybox=. 1
  elseif. do. exe=. '' end.
  if. #exe do.
    try. nc=. nc #~ 1 e. nc E. shell exe,' --help' catch. nc=. '' end.
    HTTPCMD=: exe,' ',nc,busybox{::' -O %O -o %L -t %t -T %T %U';' -q -O %O %U'
  end.
  if. fexist UNZIP=: jpath '~tools/zip/unzip.exe' do. UNZIP=: '"',UNZIP,'" -o -C '
  elseif. fexist UNZIP=: jpath '~tools/ftp/busybox.exe' do. UNZIP=: '"',UNZIP,'" unzip -q -o '
  elseif. do. UNZIP=: 'unzip.exe -o -C ' end.
end.
)
setfiles=: 3 : 0
ADDCFG=: jpath '~addons/config/'
makedir ADDCFG
ADDCFGIJS=: ADDCFG,'config.ijs'
JRELEASE=: 'j','.'-.~({.~i:&'.') JLIB
LIBTREE=: readtree''
if. IFIOS do.
  WWW=: '/jal/',JRELEASE,'/'
else.
  WWW=: 'http://www.jsoftware.com/jal/',JRELEASE,'/'
end.
)
destroy=: codestroy
CFGFILES=: <;._2 (0 : 0)
addons.txt
library.txt
release.txt
revision.txt
zips.txt
)
LIBDESC=: 0 : 0
This is the base library of scripts and labs included in the J system.

Reinstalling or upgrading this library will overwrite files in the system subdirectory. Restart J afterwards.

Files outside the system subdirectory, such as profile.ijs, are not changed.
)
addsep=: , '/' -. {:
remsep=: }.~ [: - '/' = {:
cutjal=: ([: (* 4 > +/\) ' ' = ]) <;._1 ]
cutjsp=: ([: (* 5 > +/\) ' ' = ]) <;._1 ]
fname=: #~ ([: *./\. ~:&'/')
hostcmd=: [: 2!:0 '(' , ] , ' || true)'"_
intersect=: e. # [
ischar=: 2 = 3!:0
noundef=: (1 e. (,each '0:0')&E.) &>
rnd=: [ * [: <. 0.5 + %~
sep2under=: '/' & (I.@('_' = ])})
termLF=: , (0 < #) # LF -. {:
isjpkgout=: ((4 = {:) *. 2 = #)@$ *. 1 = L.
getintro=: ('...' ,~ -&3@[ {. ])^:(<#)
info=: smoutput
dircopy=: 3 : 0
'fm to'=. y
p=. (#fm) }. each dirpath fm
mkdir_j_ each to&, each p
f=. dtree fm
t=. to&, each (#fm) }. each f
t fcopynew &> f
)
getnames=: 3 : 0
select. L.y
case. 0 do.
  if. +/ BASELIB E. y do.
    y=. (<BASELIB), cutnames y rplc BASELIB;''
  else.
    y=. cutnames y
  end.
case. 1 do.
  if. 2 = #$y do.
    y=. {."1 y
  else.
    y=. ,y
  end.
case. do.
  '' return.
end.
y
)
curtailcaption=: 3 : 0
idx=. <_1;~I. 45<#&>{:"1 y
y=. (45&getintro &.> idx{y) idx}y
)
deltree=: 3 : 0
try.
  res=. 0< ferase {."1 dirtree y
  *./ res,0<ferase |.dirpath y
catch. 0 end.
)
dtree=: 3 : 0
p=. y #~ (+./\ *. +./\.) y~:' '
p=. jpath p,'/' -. {:p
d=. 1!:0 p,'*'
if. 0 = #d do. '' return. end.
d=. d #~ 'h' ~: 1 {"1 > 4 {"1 d
if. 0 = #d do. '' return. end.
m=. 'd' = 4 {"1 > 4 {"1 d
d=. (<p) ,each {."1 d
((-.m) # d), ;dtree each m # d
)
fixjal=: 3 : 0
if. 2 > #y do. i.0 5 return. end.
m=. _2 |. (LF,')',LF) E. y
r=. _2 }. each m <;._2 y
x=. r i.&> LF
d=. (x+1) }.each r
r=. x {.each r
r=. 3 {."1 cutjal &> ' ' ,each r
x=. d i.&> LF
c=. x {.each d
d=. (x+1) }.each d
r,.c,.d
)
fixjal2=: 3 : 0
if. 2 > #y do. i.0 2 return. end.
cutjal &> ' ' ,each <;._2 y
)
fixjsp=: 3 : 0
if. 2 > #y do. i.0 5 return. end.
m=. _2 |. (LF,')',LF) E. y
r=. _2 }. each m <;._2 y
x=. r i.&> LF
d=. (x+1) }.each r
r=. x {.each r
r=. ' ' ,each r
(cutjsp &> r),.d
)
fixlib=: 3 : 0
msk=. (<LIBTREE) = 1 {"1 y
if. -. 1 e. msk do. ($0);'';0 return. end.
'ver fln siz'=. 2 4 5 { (msk i.1) { y
ver=. fixver ver
ver;fln;siz
)
fixlibs=: 3 : 0
if. 2 > #y do.
  i.0 6 return.
end.
fls=. <;._2 y
ndx=. fls i.&> ' '
siz=. <&> 0 ". (ndx+1) }.&> fls
fls=. ndx {.each fls
zps=. <;._2 &> fls ,each '_'
pfm=. 3 {"1 zps
uname=. tolower UNAME
msk=. (uname -: ({.~ i.&'.')) &> pfm
if. 1 ~: +/msk do. msk=. 1,~ }:0*.msk end.
msk # zps,.fls,.siz
)
fixrev=: 3 : 0
{. _1 ". :: _1: y -. CRLF
)
fixupd=: 3 : 0
_1 ". :: _1: y -. CRLF
)
fixver=: 3 : 0
if. ischar y do.
  y=. y -. CRLF
  y=. 0 ". ' ' (I. y='.') } y
end.
3 {. y
)
fixvers=: 3 : 0
s=. $y
y=. ,y
3 {."1 [ 0 ". s $ ' ' (I. y e. './') } y
)
fmtjal=: 3 : 0
if. 0 = #y do. '' return. end.
r=. (4 {."1 y) ,each "1 '  ',LF2
r=. <@; "1 r
; r ,each ({:"1 y) ,each <')',LF
)
fmtjal2=: 3 : 0
if. 0 = #y do. '' return. end.
; (2 {."1 y) ,each "1 ' ',LF
)
fmtdep=: 3 : 0
}. ; ',' ,each a: -.~ <;._2 y
)
fmtjsp=: 3 : 0
if. 0 = #y do. '' return. end.
r=. (4 {."1 y) ,each "1 '   ',LF
r=. <@; "1 r
; r ,each ({:"1 y) ,each <')',LF
)
fmtlib=: 3 : 0
, 'q<.>,q<.>r<0>3.0,r<0>3.0' 8!:2 y
)
fmtver=: 3 : 0
if. 0=#y do. '' return. end.
if. ischar y do. y return. end.
}. ; '.' ,each ": each y
)
fmtverlib=: 3 : 0
fmtver y
)
fixzips=: 3 : 0
if. 2 > #y do. i.0 5 return. end.
fls=. <;._2 y
ndx=. fls i.&> ' '
siz=. 0 ". (ndx+1) }.&> fls
fls=. ndx {.each fls
zps=. <;._2 &> fls ,each '_'
zps=. zps,.fls,.<&>siz
pfm=. 3 {"1 zps
and=. (1 e. 'android'&E.) &> pfm
lnx=. (1 e. 'linux'&E.) &> pfm
mac=. (1 e. 'darwin'&E.) &> pfm
win=. mac < (1 e. 'win'&E.) &> pfm

select. UNAME
case. 'Win' do.
  zps=. win # zps
case. 'Linux' do.
  zps=. lnx # zps
case. 'Android' do.
  zps=. and # zps
case. 'Darwin' do.
  zps=. mac # zps
  zps=. zps /: 3 {"1 zps
  zps=. (~: 3 {."1 zps) # zps
end.

bit=. IF64 pick '64';'32'
pfm=. 3 {"1 zps
exc=. (1 e. bit&E.) &> pfm
zps=. zps \: exc
zps=. (~: 3 {."1 zps) # zps
fnm=. 0 {"1 zps
lnm=. 1 {"1 zps
ver=. 2 {"1 zps
pfm=. 3 {"1 zps
fls=. 4 {"1 zps
siz=. 5 {"1 zps
nms=. fnm ,each '/' ,each lnm
pfm=. (pfm i.&> '.') {.each pfm
ndx=. \: # &> pfm
sort ndx { nms,.pfm,.ver,.fls,.siz
)
fwritenew=: 4 : 0
if. x -: fread y do.
  0
else.
  x fwrite y
end.
)
getjqtversion=: 3 : 0
suffix=. (IFUNIX>'/'e.LIBFILE)#'-9.01'
dat=. fread '~bin/jqt',suffix,IFWIN#'.exe'
if. dat-:_1 do. '' return. end.
ndx=. I. 'jqtversion:' E. dat
if. 0=#ndx do. '' return. end.
dat=. 50 {. (11+{.ndx) }. dat
<;._1 '/',(dat i. ':') {. dat
)
platformparent=: 3 : 0
((< _2 {. y) e. '32';'64') # _2 }. y
)
makedir=: 1!:5 :: 0: @ <
plural=: 4 : 0
y,(1=x)#'s'
)
sizefmt=: 3 : 0
select. +/ y >: 1e3 1e4 1e6 1e7 1e9
case. 0 do.
  (": y), ' byte',(y~:1)#'s'
case. 1 do.
  (": 0.1 rnd y%1e3),' KB'
case. 2 do.
  (": 1 rnd y%1e3),' KB'
case. 3 do.
  (": 0.1 rnd y%1e6),' MB'
case. 4 do.
  (": 1 rnd y%1e6),' MB'
case. do.
  (": 0.1 rnd y%1e9),' GB'
end.
)
shellcmd=: 3 : 0
if. IFUNIX do.
  hostcmd_j_ y
else.
  spawn_jtask_ y
end.
)
splitrep=: 3 : 0
rep=. <;.1 '/',y
(}. ; 2 {. rep);;2 }. rep
)
subdir=: 3 : 0
if. 0=#y do. '' return. end.
a=. 1!:0 y,'*'
if. 0=#a do. '' return. end.
a=. a #~ '-d' -:"1 [ 1 4 {"1 > 4 {"1 a
(<y) ,each ({."1 a) ,each '/'
)
testaccess=: 3 : 0
f=. <jpath'~install/testaccess.txt'
try.
  '' 1!:2 f
  1!:55 f
  1
catch.
  0
end.
)
toupper1=: 3 : 0
if. 0=#y do. '' return. end.
(toupper {. y),tolower }. y
)
unzip=: 3 : 0
'file dir'=. dquote each y
e=. 'Unexpected unzip error'
if. IFUNIX do.
  notarcmd=. IFIOS
  if. UNAME-:'Android' do.
    notarcmd=. _1-: 2!:0 ::_1: 'which tar 2>/dev/null'
    if. (UNAME-:'Android') > '/mnt/sdcard'-:2!:5'EXTERNAL_STORAGE' do. notarcmd=. 1 end.
  end.
  if. notarcmd do.
    require 'tar'
    'file dir'=. y
    if. (i.0 0) -: tar 'x';file;dir do. e=. '' end.
  else.
    e=. shellcmd 'tar ',((IFIOS+:UNAME-:'Android')#(('Darwin'-:UNAME){::'--no-same-owner --no-same-permissions';'-o -p')),' -xzf ',file,' -C ',dir
  end.
  if. ('/usr/'-:5{.dir-.'"') *. ('root'-:2!:5'USER') +. (<2!:5'HOME') e. 0;'/var/root';'/root';'';,'/' do.
    shellcmd ::0: 'find ',dir,' -type d -exec chmod a+rx {} \+'
    shellcmd ::0: 'find ',dir,' -type f -exec chmod a+r {} \+'
  end.
else.
  dir=. (_2&}. , '/' -.~ _2&{.) dir
  e=. shellcmd UNZIP,' ',file,' -d ',dir
end.
e
)
zipext=: 3 : 0
y, IFUNIX pick '.zip';'.tar.gz'
)
busyboxget=: 3 : 0
'f p'=. 2 {. (boxxopen y),a:
if. 0=#p do.
  p=. jpath '~temp/',f #~ -. +./\. f = '/'
end.
ferase p
cmd=. '"','"',~jpath '~tools/ftp/busybox.exe'
cmd=. cmd,' wget -O ',p,' ',f
fail=. 0
try.
  fail=. _1-: e=. shellcmd cmd
catch. fail=. 1 end.
if. fail +. 0 >: fsize p do.
  msg=. 'Connection failed'
  log msg
  r=. 1;msg
  ferase p
else.
  r=. 0;p
end.
r
)
CHECKADDONSDIR=: 0 : 0
The addons directory does not exist and cannot be created.

It is set to: XX.

You can either create the directory manually, or set a new addons directory in your profile script.
)
CHECKASK=: 0 : 0
Read catalog from the server using Internet connection now?

Otherwise the local catalog is used offline.
)
CHECKONLINE=: 0 : 0
An active Internet connection is needed to install packages.

Continue only if you have an active Internet connection.

OK to continue?
)
CHECKREADSVR=: 0 : 0
An active Internet connection is needed to read the server repository catalog.

Continue only if you have an active Internet connection.

OK to continue?
)
CHECKSTARTUP=: 0 : 0
Setup repository using Internet connection now?

Select No if not connected, to complete setup later. After Setup is done, repository can be used offline with more options in Tools menu and Preferences dialog.
)
checkaccess=: 3 : 0
if. testaccess'' do. 1 [ HASFILEACCESS_jpacman_=: 1 return. end.
msg=. 'Package Manager will run in read-only mode, as you do not have access to the installation folder.'
if. IFWIN do.
  msg=. msg,LF2,'To run as Administrator, right-click the J icon, select Run as... and '
  msg=. msg,'then select Adminstrator.'
else.
  msg=. msg,LF2,'To run as root, open a terminal and use sudo to run J.'
end.
info msg
0
)
checkaddonsdir=: 3 : 0
d=. jpath '~addons'
if. # 1!:0 d do. 1 [ HASADDONSDIR_jpacman_=: 1 return. end.
if. 1!:5 :: 0: <d do.
  log 'Created addons directory: ',d
  1 [ HASADDONSDIR=: 1 return.
end.
info CHECKADDONSDIR rplc 'XX';d
0
)
getonline=: 3 : 0
ONLINE=: 2=3 2 wdquery y
)
getserver=: 3 : 0
'rc p'=. httpgetr (WWW,'revision.txt');2
if. rc do. 0 return. end.
write_lastupdate''
WWWREV=: fixrev p
if. WWWREV = REV do. 1 return. end.
refreshweb''
)
checkonline=: 3 : 0
select. ReadCatalog_j_
case. 0 do.
  if. REV >: 0 do.
    ONLINE=: 0
    log 'Using local copy of catalog. See Preferences to change the setting.'
    1 return.
  end.
  if. 0 = getonline 'Read Catalog from Server';CHECKREADSVR do. 0 return. end.
case. 1 do.
  ONLINE=: 1
case. 2 do.
  if. REV >: 0 do.
    if. 0 = getonline 'Read Catalog from Server';CHECKASK do.
      log 'Using local copy of catalog. See Preferences to change the setting.'
      1 return.
    end.
  else.
    if. 0 = getonline 'Setup Repository';CHECKSTARTUP do. 0 return. end.
  end.
end.
log 'Updating server catalog...'
if. 0 = getserver'' do.
  ONLINE=: 0
  log 'Working offline using local copy of catalog.'
else.
  log 'Done.'
end.
1
)
checkstatus=: 3 : 0
if. 0 e. #LIBS do. '' return. end.
msk=. masklib PKGDATA
ups=. pkgups''
libupm=. 1 e. msk *. ups
msk=. -. msk
addnim=. +/msk *. pkgnew''
addupm=. +/msk *. pkgups''
tot=. +/addnim,addupm,libupm
if. 0 = tot do.
  'All available packages are installed and up to date.' return.
end.
select. 0 < addnim,addupm
case. 0 0 do.
  msg=. 'Addons are up to date.'
case. 0 1 do.
  msg=. 'All addons are installed, ',(":addupm), ' can be upgraded.'
case. 1 0 do.
  if. addnim = <:#PKGDATA do.
    msg=. 'No addons are installed.'
  else.
    j=. ' addon',('s'#~1<addnim),' are not yet installed.'
    msg=. 'Installed addons are up to date, ',(":addnim),j
  end.
case. 1 1 do.
  j=. (":addupm),' addon',('s'#~1<addupm),' can be upgraded, '
  msg=. j,(":addnim), ' addon',('s'#~1<addnim),' are not yet installed.'
end.
if. 0 = libupm do.
  msg,LF,'The base library is up to date.'
else.
  msg,LF,'There is a newer version of the base library.'
end.
)
write_lastupdate=: 3 : 0
txt=. ": 6!:0 ''
txt fwrites ADDCFG,'lastupdate.txt'
)
checklastupdate=: 3 : 0
if. _1 -: LASTUPD do.
  res=. 'has never been updated.'
else.
  res=. 'was last updated: ',timestamp LASTUPD
end.
'Local JAL information ',res
)
getdepend=: 3 : 0
if. 0 = #y do. y return. end.
dep=. getdepend_console 1{"1 y
PKGDATA #~ (1{"1 PKGDATA) e. dep
)
getdepend_console=: 0&$: : (4 : 0)
if. 0 = #y do. y return. end.
old=. ''
if. 0=#PKGDATA do. init_console'' end.
ids=. 1{"1 PKGDATA
dep=. 6{"1 PKGDATA
res=. ~. <;._1 ; ',' ,each (ids e. y) # dep
whilst. -. res-:old do.
  old=. res
  res=. ~. res, <;._1 ; ',' ,each (ids e. res) # dep
end.
/:~ ~. y, res -. a:, (0=x)# {."1 ADDINS
)
REPOS=: ;:'github'
cutrepo=: 3 : 0
t=. remsep jpathsep deb y
ndx=. t i. ':'
tag=. ndx {. t
t=. (ndx+1) }. t
ndx=. t i. '@'
rep=. ndx {. t
cmt=. (ndx+1) }. t
cmt=. cmt,(0=#cmt)#'master'
tag;rep;cmt
)
getpackageurl=: 3 : 0
'tag rep cmt'=. y
select. tag
case. 'github' do.
  ball=. IFUNIX pick 'zipball';'tarball'
  p=. <;.2 rep,'/'
  rpo=. ;2 {. p
  'https://github.com/',rpo,ball,'/',cmt
case. do.
  ''
end.
)
getpacsub=: 3 : 0
t=. 1!:0 y,'/*'
d=. , t #~ 'd'= 4 {"1 > 4 {"1 t
if. 0=#d do. 0 return. end.
y,'/',0 pick d
)
gettempdir=: 3 : 0
tmp=. jpath '~temp/pacmandownload'
rmdir_j_ tmp
mkdir_j_ tmp
tmp
)
gitrepoget=: 3 : 0
'f p'=. 2 {. (boxxopen y),a:
if. IFWIN do.
  busyboxget f;p
else.
  httpget f;3;p
end.
)
install_gitrepo=: 3 : 0
'tag rep cmt'=. cutrepo y
if. -. (<tag) e. REPOS do.
  echo 'Unsupported repo host: ',tag return.
end.
if. 0 -: readmanifest tag;rep;cmt do. 0 return. end.
if. 0 -: readpackage tag;rep;cmt do. 0 return. end.
frm=. 0 pick splitrep rep
msg=. 'installed: ',frm,' ',cmt
if. -. frm -: FOLDER do.
  msg, ' into folder: ',FOLDER
end.
)
readpackage=: 3 : 0
url=. getpackageurl y
if. 0=#url do. 0 return. end.
tmp=. gettempdir''
p=. tmp,'/t1.',IFUNIX pick 'zip';'tar.gz'
'rc msg'=. gitrepoget url;p
if. rc do.
  0[echo 'Could not download addon: ',msg return.
end.
if. 0 >: fsize p do.
  0[echo 'Could not download addon' return.
end.
unzip p;tmp
sub=. getpacsub tmp
if. 0-:sub do. return. end.
removeextras sub
replacepackage sub;FOLDER
rmdir_j_ tmp
1
)
removeextras=: 3 : 0
p=. addsep y
ferase p&, each FILES -.~ (#p) }. each dtree p
)
replacepackage=: 3 : 0
'tmp rep'=. y
'add sub'=. splitrep rep
fm=. tmp,sub
to=. jpath '~addons/',add
dircopy fm;to
1
)
httpget=: 3 : 0
'f t p'=. 3 {. (boxxopen y),a:
n=. f #~ -. +./\. f e. '=/'
if. 0=#p do. p=. jpath '~temp/',n end.
q=. jpath '~temp/httpget.log'
t=. ":{.t,3
ferase p;q
fail=. 0
cmd=. HTTPCMD rplc '%O';(dquote p);'%L';(dquote q);'%t';t;'%T';(":TIMEOUT);'%U';f
if. ''-:HTTPCMD do.
  require 'socket'
  1!:55 ::0: <p
  rc=. 0 [ e=. pp=. ''
  whilst. 0 do.
    'rc sk'=. sdsocket_jsocket_''
    if. 0~:rc do. break. end.
    ip=. >2{sdgethostbyname_jsocket_ 'www.jsoftware.com'
    rc=. sdconnect_jsocket_ sk;PF_INET_jsocket_;ip;80
    if. 0~:rc do. break. end.
    'rc sent'=. ('GET ',f,' HTTP/1.0',CRLF,CRLF) sdsend_jsocket_ sk;0
    if. 0~:rc do. break. end.
    while. ((0=rc)*.(*#m)) [[ 'rc m'=. sdrecv_jsocket_ sk,4096 do.
      pp=. pp,m
    end.
  end.
  sdclose_jsocket_ sk
  if. 0~:rc do. fail=. 1
  elseif. 1 -.@e. '200 OK' E. (20{.pp) do. fail=. 1 [ e=. ({.~ i.&LF) pp
  elseif. #p1=. I. (CRLF,CRLF) E. 500{.pp do. p2=. 4
  elseif. #p1=. I. LF2 E. 500{.pp do. p2=. 2
  elseif. do. fail=. 1
  end.
  if. 0=fail do.
    ((p2+{.p1)}.pp) 1!:2 <p
  else.
    if. 0~:rc do. e=. sderror_jsocket_ rc end.
  end.
elseif. do.
  try.
    fail=. _1-: e=. shellcmd cmd
  catch. fail=. 1 end.
end.
if. fail +. 0 >: fsize p do.
  if. _1-:msg=. freads q do.
    if. (_1-:msg) +. 0=#msg=. e do. msg=. 'Unexpected error' end. end.
  log 'Connection failed: ',msg
  info 'Connection failed:',LF2,msg
  r=. 1;msg
  ferase p;q
else.
  r=. 0;p
  ferase q
end.
r
)
httpgetr=: 3 : 0
res=. httpget y
if. 0 = 0 pick res do.
  f=. 1 pick res
  txt=. freads f
  ferase f
  0;txt
end.
)
install=: 3 : 0
dat=. getdepend y
'num siz'=. pmview_applycounts dat
many=. 1 < num
msg=. 'Installing ',(":num),' package',many#'s'
msg=. msg,' of ',(many#'total '),'size ',sizefmt siz
log msg
installdo 1 {"1 dat
log 'Done.'
readlocal''
pacman_init 0
)
install_console=: 3 : 0
if. -. init_console 'server' do. '' return. end.
pkgs=. getnames y
if. pkgs -: ,<'all' do. pkgs=. 1 {"1 PKGDATA end.
pkgs=. pkgs (e. # [) ~. (<'base library'), ((pkgnew +. pkgups) # 1&{"1@]) PKGDATA
pkgs=. pkgs -. Ignore
pkgs=. getdepend_console pkgs
if. 0 = num=. #pkgs do. '' return. end.
many=. 1 < num
msg=. 'Installing ',(":num),' package',many#'s'
log msg
installdo pkgs
log 'Done.'
readlocal''
pacman_init ''
checkstatus''
)
upgrade_console=: 3 : 0
if. -. init_console 'read' do. '' return. end.
pkgs=. getnames y
if. (0=#pkgs) +. pkgs -: ,<'all' do. pkgs=. 1{"1 PKGDATA end.
pkgs=. pkgs (e. # [) (pkgups # 1&{"1@])PKGDATA
install_console pkgs
)
installdo=: 3 : 0
msk=. -. y e. <BASELIB
if. 0 e. msk do.
  install_library''
end.
install_addon each msk # y
)
install_addon=: 3 : 0
ndx=. ({."1 ZIPS) i. <y
if. ndx = #ZIPS do. EMPTY return. end.
log 'Downloading ',y,'...'
f=. 3 pick ndx { ZIPS
'rc p'=. httpget WWW,'addons/',f
if. rc do. return. end.
log 'Installing ',y,'...'
msg=. unzip p;jpath'~addons'
ferase p
if. 0>:fsize jpath'~addons/',y,'/manifest.ijs' do.
  log 'Extraction failed: ',msg
  info 'Extraction failed:',LF2,msg
  return.
end.
install_addins y
install_config y
)
install_addins=: 3 :0
fl=. ADDCFG,'addins.txt'
ins=. fixjal2 freads fl
ins=. ins #~ (<y) ~: {."1 ins
ndx=. ({."1 ADDONS) i. <y
ins=. sort ins, 2 {. ndx { ADDONS
(fmtjal2 ins) fwrites fl
)
install_config=: 3 : 0
ADDLABS=: ''
0!:0 :: ] < ADDCFGIJS
install_labs y
write_config''
)
install_labs=: 3 : 0
labs=. dirtree jpath '~addons/',y,'/*.ijt'
if. 0=#labs do. return. end.
pfx=. jpath '~addons/'
labs=. (#pfx) }.each {."1 labs
LABCATEGORY=: ''
0!:0 ::] <jpath '~addons/',y,'/manifest.ijs'
cat=. LABCATEGORY
if. 0 = #cat do.
  cat=. toupper1 (y i. '/') {. y
end.
new=. labs ,each <' ',cat
txt=. sort ~. new,<;._2 ADDLABS
ndx=. 4 + (1 i.~ '.ijt'&E.) &> txt
msk=. fexist &> (<pfx) ,each ndx {.each txt
txt=. msk # txt
ADDLABS=: ; txt ,each LF
)
install_library=: 3 : 0
log 'Downloading base library...'
f=. 1 pick LIB
'rc p'=. httpget WWW,'library/',f
if. rc do. return. end.
log 'Installing base library...'
unzip p;jpath'~system'
ferase p
readlin''
)
write_config=: 3 : 0
txt=. 'NB. Addon configuration',LF2
txt=. txt,'ADDLABS=: 0 : 0',LF,ADDLABS,')',LF
txt fwrites ADDCFGIJS
)
getmanifesturl=: 3 : 0
'tag rep cmt'=. y
select. tag
case. 'github' do.
  p=. <;.2 rep,'/'
  rpo=. ;2 {. p
  sub=. ;2 }. p
  'https://raw.githubusercontent.com/',rpo,cmt,'/',sub,'manifest.ijs'
case. do.
  ''
end.
)
readmanifest=: 3 : 0
url=. getmanifesturl y
if. 0=#url do. 0 return. end.
'rc man'=. gitrepoget url
if. rc do. 0 return. end.
dat=. freads man
if. dat -: _1 do.
  0[log 'could not read manifest for ',y return.
end.
ferase man
if. 0=valmanifest dat do. 0 return. end.
defmanifest dat
)
defmanifest=: 3 : 0
defmanifest1 y
pfm=. (tolower UNAME)&, each '';IF64{'32';'64'
files=. 'FILES'&, each '';toupper each pfm
other=. ;: 'DEPENDS FOLDER PLATFORMS RELEASE VERSION'
all=. files,other
(all)=: <''
n=. all intersect nl_jpacmandef_ 0
(n)=: ". each n ,each <'_jpacmandef_'
coerase <'jpacmandef'

FILES=: ~. cutLF ;LF ,each ". each files
if. 0=#FILES do. 0[echo 'Files not given' return. end.
FILES=: ~. FILES, <'manifest.ijs'

if. 0=#FOLDER do. 0[echo 'Folder not given' return. end.
if. #PLATFORMS do.
  if. 0=#pfm intersect ;: PLATFORMS do.
    0[echo 'Platform not supported for this addon' return.
  end.
end.
if. #RELEASE do.
  rel=. <./0 ". 'j' -.~ RELEASE
  ver=. 0 ". 'j' -.~ ({.~i.&'/')9!:14''
  if. rel > ver do.
    0[echo 'Release not supported for this addon: ',9!:14'' return.
  end.
end.
if. #DEPENDS do.
  dependcheck a: -.~ deb each <;._2 termLF DEPENDS
end.

1
)
defmanifest1=: 3 : 0
coerase <'jpacmandef'
cocurrent 'jpacmandef'
0!:100 y
)
dependcheck=: 3 : 0
m=. (0 = #@(1!:0)) &> (<jpath '~addons/') ,each y , each <'/*'
if. 1 e. m do.
  echo 'This addon requires addons to be installed:',;' ',each m#y
end.
)
valmanifest=: 3 : 0
b=. <;._2 y
b=. dlb each b
b=. b -. a:
b=. b #~ (<'NB.') ~: 3 {.each b
c=. ;: :: 0: each b
msk=. c ~: <0
c=. msk # c
bgn=. noundef c
ndx=. bgn i. 1
hdr=. ndx {. c
c=. bgn <;.1 c
len=. # &> c
ndx=. c i. &> <<,<,')'
if. 1 e. ndx = len do.
  txt=. towords 0 pick ((ndx=len) i. 1) pick c
  log 'invalid manifest for ',x,' at definition: ',txt
  0 return.
end.
c=. hdr, ; (ndx+1) }.each c
c
msk=. (<'NB.') = (3: {. >@{:) each c
c=. (-msk) }.each c
msk=. 3 ~: # &> c
if. 1 e. msk do.
  txt=. towords (msk i. 1) pick c
  log 'invalid manifest for ',x,' at line: ',txt
  0 return.
end.
c3=. > c
ass=. (<'=:') = 1 {"1 c3
chr=. '''' = {. &> 2 {"1 c3
if. 0 e. ass *. chr do.
  txt=. towords ((0 = ass *.chr) i. 1) pick c
  echo 'invalid manifest for ',x,' at line: ',txt
  0 return.
end.
1
)
show_console=: 4 : 0
if. -. init_console 'read' do. '' return. end.
select. x
case. 'search' do.
  pkgs=. getnames y
  res=. (pkgsearch pkgs) # 1 2 3 4 {"1 PKGDATA
  res=. curtailcaption res
case. 'show' do.
  pkgs=. getnames y
  if. pkgs -: ,<'all' do. pkgs=. 1 {"1 PKGDATA end.
  res=. (msk=. pkgshow pkgs) # 5 {"1 PKGDATA
  if. #res do.
    res=. ,((<'== '), &.> msk # 1 {"1 PKGDATA) ,. res
    res=. (2#LF) joinstring (70&foldtext)&.> res
  end.
case. 'showinstalled' do.
  dat=. (isjpkgout y) {:: (1 2 3 4 {"1 PKGDATA);<y
  res=. (-.@pkgnew # ])dat
  res=. curtailcaption res
case. 'shownotinstalled' do.
  dat=. (isjpkgout y) {:: (1 2 3 4 {"1 PKGDATA);<y
  res=. (pkgnew # 0 2 3&{"1@])dat
  res=. curtailcaption res
case. 'showupgrade' do.
  dat=. (isjpkgout y) {:: (1 2 3 4 {"1 PKGDATA);<y
  res=. (pkgups # ])dat
  res=. curtailcaption res
case. 'status' do.
  res=. checklastupdate''
  res=. res,LF,checkstatus''
end.
res
)
showfiles_console=: 4 : 0
if. -. init_console 'read' do. '' return. end.
pkgs=. getnames y
pkgs=. pkgs (e. # [) (-.@pkgnew # 1&{"1@]) PKGDATA
pkgs=. pkgs -. <BASELIB
if. 0=#pkgs do. '' return. end.
fn=. (<'~addons/') ,&.> (pkgs) ,&.> <'/',x,(x-:'history'){::'.ijs';'.txt'
res=. res #~ msk=. (<_1) ~: res=. fread@jpath &.> fn
if. #res do.
  res=. ,((<'== '), &.> msk#pkgs) ,. res
  res=. (2#LF) joinstring res
end.
)
remove_console=: 3 : 0
if. -. init_console 'edit' do. '' return. end.
pkgs=. getnames y
if. pkgs -: ,<'all' do. pkgs=. 1 {"1 PKGDATA end.
pkgs=. pkgs (e. # [) (-.@pkgnew # 1&{"1@]) PKGDATA
pkgs=. pkgs -. <BASELIB
if. 0 = num=. #pkgs do. '' return. end.
many=. 1 < num
msg=. 'Removing ',(":num),' package',many#'s'
log msg
remove_addon each pkgs
log 'Done.'
readlocal''
pacman_init ''
checkstatus''
)

remove_addon=: 3 : 0
log 'Removing ',y,'...'
treepath=. jpath '~addons/',y
if. ((0 < #@dirtree) *. -.@deltree) treepath do.
  nf=. #dirtree treepath
  nd=. <: # dirpath treepath
  nd=. nd + (tolower treepath) e. dirpath jpath '~addons/', '/' taketo y
  msg=. (":nd),' directories and ',(":nf),' files not removed.'
  log 'Remove failed: ',msg
  info 'Remove failed:',LF2,msg
  return.
end.
remove_addins y
remove_config y
)
remove_addins=: 3 :0
fl=. ADDCFG,'addins.txt'
ins=. fixjal2 freads fl
ins=. ins #~ (<y) ~: {."1 ins
(fmtjal2 ins) fwrites fl
)
remove_config=: 3 : 0
ADDLABS=: ''
0!:0 :: ] < ADDCFGIJS
remove_labs y
write_config''
)
remove_labs=: 3 : 0
txt=. <;._2 ADDLABS
txt=. txt #~ (<jpathsep y) ~: (#y)&{. each txt
ADDLABS=: ; txt ,each LF
)
LOG=: 1
log=: 3 : 0
if. LOG do. smoutput y end.
)
logstatus=: 3 : 0
if. ONLINE do.
  log checkstatus''
end.
)
readlin=: 3 : 0
LIN=: 6 1 1 >. fixver JLIB
)
readlocal=: 3 : 0
readlin''
ADDONS=: fixjal freads ADDCFG,'addons.txt'
ADDINS=: fixjal2 freads ADDCFG,'addins.txt'
REV=: fixrev freads ADDCFG,'revision.txt'
LASTUPD=: fixupd freads ADDCFG,'lastupdate.txt'
LIBS=: fixlibs freads ADDCFG,'library.txt'
LIB=: fixlib LIBS
ZIPS=: fixzips freads ADDCFG,'zips.txt'
EMPTY
)
readtree=: 3 : 0
f=. ADDCFG,'tree.txt'
tree=. LF -.~ freads f
if. -. (<tree) e. 'current';'stable' do.
  tree=. 'current'
  writetree tree
end.
tree
)
writetree=: 3 : 0
y fwritenew ADDCFG,'tree.txt'
)
refreshweb=: 3 : 0
if. 0 = refreshjal'' do. 0 return. end.
readlocal''
1
)
refreshaddins=: 3 : 0
setfiles''
ADDLABS=: ''
f=. ADDCFG,'addins.txt'
p=. jpath '~addons/'
sd=. ;subdir each subdir p
if. 0=#sd do.
  '' fwrite f
  write_config'' return.
end.
r=. s=. ''
for_d. sd do.
  mft=. freads (>d),'manifest.ijs'
  if. mft -: _1 do. continue. end.
  VERSION=: ''
  0!:100 mft
  ver=. fmtver fixver VERSION
  n=. }: (#p) }. >d
  n=. '/' (I.n='\') } n
  r=. r,n,' ',ver,LF
  s=. s,d
end.
r fwritenew f
s=. (#p) }.each }: each s
install_labs each s
write_config''
)
refreshjal=: 3 : 0
'rc p'=. httpget WWW,zipext 'jal'
if. rc do. 0 return. end.
unzip p;ADDCFG
ferase p
if. *./ CFGFILES e. {."1 [ 1!:0 ADDCFG,'*' do. 1 return. end.
msg=. 'Could not install the local repository catalog.'
log msg
info msg
0
)
updatejal=: 3 : 0
log 'Updating server catalog...'
if. -. init_console 'server' do. '' return. end.
refreshaddins''
readlocal''
pacman_init''
res=. checklastupdate''
res,LF,checkstatus''
)
masklib=: 3 : 0
(1 {"1 y) = <BASELIB
)
pkglater=: 3 : 0
dat=. (s=. isjpkgout y){:: PKGDATA;<y
if. 0=#dat do. $0 return. end.
loc=. fixvers > (2-s) {"1 dat
srv=. fixvers > (3-s) {"1 dat
{."1 /:"2 srv ,:"1 loc
)
pkgnew=: 3 : 0
dat=. (s=. isjpkgout y){:: PKGDATA;<y
if. 0=#dat do. $0 return. end.
0 = # &> (2-s) {"1 dat
)
pkgups=: pkgnew < pkglater
pkgsearch=: 3 : 0
+./"1 +./ y E."1&>"(0 _) 1{"1 PKGDATA
)
pkgshow=: 3 : 0
y e.~ 1{"1 PKGDATA
)
setshowall=: 3 : 0
PKGDATA=: (<y) (<(I.DATAMASK);0) } PKGDATA
)
setshownew=: 3 : 0
ndx=. I. DATAMASK *. pkgnew''
PKGDATA=: (<y) (<ndx;0) } PKGDATA
)
setshowups=: 3 : 0
ndx=. I. DATAMASK *. pkgups''
PKGDATA=: (<y) (<ndx;0) } PKGDATA
)
splitlib=: 3 : 0
if. 0=#y do.
  2 $ <y return.
end.
msk=. masklib y
(msk#y) ; <(-.msk)#y
)
pacman_init=: 3 : 0
dat=. ADDONS #~ ({."1 ADDONS) e. {."1 ZIPS
if. 0=#dat do.
  dat=. i.0 6
else.
  ndx=. ({."1 ADDINS) i. {."1 dat
  ins=. ndx { (1 {"1 ADDINS),<''
  dat=. dat,.<''
  dat=. 0 5 1 3 4 2 {"1 dat
  dat=. ins 1 }"0 1 dat
end.
lib=. 'base library';(fmtver LIN);(fmtver 0 pick LIB);'base library scripts';LIBDESC;''
dat=. dat,lib
dat=. (<0),.dat
PKGDATA=: sort dat
nms=. 1 {"1 PKGDATA
nms=. ~. (nms i.&> '/') {.each nms
SECTION=: 'All';nms
DATAMASK=: (#PKGDATA) $ 1
EMPTY
)
init_console=: 3 : 0
if. 0=#y do. y=. 'read' end.
select. y
fcase. 'edit';'server' do.
  if. -. HASFILEACCESS do. 0 return. end.
case. 'read' do.
  if. -. HASADDONSDIR do. 0 return. end.
  setfiles''
  readlocal''
  pacman_init ''
  res=. 1
case. do. res=. 0
end.
if. y -: 'server' do. res=. getserver'' end.
res
)
jpkg=: 4 : 0
if. -.INITDONE_jpacman_ do.
  checkaccess''
  checkaddonsdir''
  INITDONE_jpacman_=: 1
end.
select. x
case. 'history';'manifest' do.
  x showfiles_console y
case. 'install' do.
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  install_console y
case. 'reinstall' do.
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  remove_console y
  install_console y
case. 'remove' do.
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  remove_console y
case. ;:'show search showinstalled shownotinstalled showupgrade status' do.
  x show_console y
case. 'update' do.
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  updatejal ''
case. 'upgrade' do.
  if. -. HASFILEACCESS*.HASADDONSDIR do. 'file permission error' return. end.
  upgrade_console y
case. do.
  msg=. 'Valid options are:',LF
  msg=. msg,'  history, install, manifest, remove, reinstall, show, search,',LF
  msg=. msg,'  showinstalled, shownotinstalled, showupgrade, status,',LF
  msg,'  update, upgrade'
end.
)
jef=: '~temp/je_update/'

je_update=: 3 : 0
if. IFIOS+.UNAME-:'Android' do. 'update not supported for this platform' return. end.
mkdir_j_ jef
sh=. 'update.',;(UNAME-:'Win'){'sh';'bat'
ferase jef,sh
'plat name bname'=. je_sub''
old=. fread bname
old fwrite jef,name,'.old'
if. #msg=. je_get'' do. echo msg return. end.
if. (-.'force'-:y) *. old-:fread jef,name,'.new' do.
  echo 'the current JE is already up to date' return.
end.
OLD=. hostpathsep jpath bname
NEW=. hostpathsep jpath jef,name,'.new'
if. UNAME-:'Win' do.
  (win_update rplc 'OLD';OLD;'NEW';NEW) fwrite jef,sh
else.
  if. FHS*.UNAME-:'Linux' do.
    d=. deb_update
  else.
    d=. unix_update
  end.
  (d rplc 'OLD';OLD;'NEW';NEW) fwrite jef,sh
  2!:0 'chmod +x ',jpath jef,sh
end.
echo shutdown rplc 'CMD';hostpathsep jpath jef,sh
)
je_get=: 3 : 0
mkdir_j_ jef
'plat name bname'=. je_sub''
t=. <;._1 '/',9!:14''
version=. ;{.t
br=. ;3{t
i=. ('beta';'rele')i. <4{.br
if. i=2 do. 'current JE is not beta or release' return. end.
type=. ;i{'beta';'release'
if. 1~:ftype bname do. 'update not supported for this type of install' return. end.
erase'JENEW'
jeold=. fread bname
path=. 'http://www.jsoftware.com/download/jengine/',version,'-',type,'/'
avxname=. name
avx=. 'nonavx'-:_6{.;1{t
if. avx do.
  avxname=. avxname rplc '.';'-nonavx.'
end.
tname=. '~temp/',avxname
ferase tname
arg=. path,'P/jX/N' rplc 'P';plat;'N';avxname;'X';;IF64{'32';'64'
echo arg
httpget_jpacman_ arg
(fread tname)fwrite jef,name,'.new'
echo 'saved as:    ',jef,name,'.new'
echo 'new version: ',jengine_version tname
''
)

je_sub=: 3 : 0
i=. ('Win';'Darwin')i.<UNAME
plat=. ;i{'windows';'darwin';IFRASPI{::'linux';'raspberry'
name=. ;i{'j.dll';'libj.dylib';'libj.so'
bname=. '~bin/',name
if. FHS*.UNAME-:'Linux' do.
  v=. ({.~i.&'/')}.9!:14''
  sub=. '.',({.v),'.',}.v
  if. fexist '/etc/redhat-release' do.
    d1=. IF64{::'/usr/lib/';'/usr/lib64/'
  else.
    if. IFRASPI do.
      d1=. IF64{::'/usr/lib/arm-linux-gnueabihf/';'/usr/lib/aarch64-linux-gnu/'
    elseif. do.
      d1=. IF64{::'/usr/lib/i386-linux-gnu/';'/usr/lib/x86_64-linux-gnu/'
    end.
  end.
  bname=. d1,name,sub
end.
plat;name;bname
)
jengine_version=: 3 : 0
d=. fread y
'not a file'assert _1~:d
'not a JE' assert (1 i.~'non-unique sparse elements' E. d)<#d
i=. 1 i.~'je9!:14' E. d
if. i=#d do. 'unknown' return. end.
d=. d}.~8+i
s=. d{.~d i. {.a.
s=. s-.LF,12{a.
dt=. _20{.s
date=. 11{.dt
m=. 2":>:(;:'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec')i.<3{.date
date=. ((_4{.date),'-',m,'-',4 5{date)rplc' ';'0'
(_20}.s),date,11}.dt
)

unix_update=: 0 : 0
#!/bin/sh
cp "NEW" "OLD"
echo restart J and check JVERSION
)

deb_update=: 0 : 0
#!/bin/sh
sudo cp "NEW" "OLD"
sudo chmod 644 "OLD"
sudo chown root:root "OLD"
sudo ldconfig
)

win_update=: 0 : 0
@ECHO OFF
copy "NEW" "OLD"
echo restart J and check JVERSION
)

shutdown=: 0 : 0

hint: copy command so you can paste it in terminal/command window

!!! shutdown J (all copies running this version) !!!

in a terminal/command window run the following:

"CMD"

note: command may require admin/sudo priviliege

)
do_install=: 3 : 0
if. -. checkaccess_jpacman_ '' do. return. end.
if. ':' e. y do. install_gitrepo y return. end.
'update' jpkg ''
if. y -: 'addons' do. y=. 'all' end.
if. -. (<y) e. 'full';'qtide';'slim' do.
  'install' jpkg y return.
end.
if. IFQT do.
  smoutput 'Must run from jconsole' return.
end.
if. y-:'qtide' do.
  s=. 'slim'-: 4 {. ;getjqtversion_jpacman_''
  y=. s pick 'full';'slim'
end.
'install' jpkg 'base library ide/qt'
getqtbin y
msg=. (+/ 2 1 * IFWIN,'Darwin'-:UNAME) pick 'jqt.sh';'the jqt icon';'jqt.cmd'
if. '/usr/share/j/' -: 13{. jpath'~install' do. msg=. 'jqt' end.
smoutput 'Exit and restart J using ',msg
)
do_getqtbin=: 3 : 0

bin=. 'JQt ',(((y-:'slim')#'slim ')),'binaries.'
smoutput 'Installing ',bin,'..'
if. 'Linux'-:UNAME do.
  if. IFRASPI do.
    z=. 'jqt-',((y-:'slim') pick 'raspi';'raspislim'),'-',(IF64 pick '32';'64'),'.tar.gz'
  else.
    z=. 'jqt-',((y-:'slim') pick 'linux';'slim'),'-',(IF64 pick 'x86';'x64'),'.tar.gz'
  end.
  z1=. 'libjqt.so'
elseif. IFWIN do.
  z=. 'jqt-win',((y-:'slim')#'slim'),'-',(IF64 pick 'x86';'x64'),'.zip'
  z1=. 'jqt.dll'
elseif. do.
  z=. 'jqt-mac',((y-:'slim')#'slim'),'-',(IF64 pick 'x86';'x64'),'.zip'
  z1=. 'libjqt.dylib'
end.
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/j901/qtide/',z
if. rc do.
  smoutput 'unable to download: ',z return.
end.
d=. jpath '~bin'
fhs=. '/usr/share/j/' -: 13{. jpath'~install'
if. IFWIN do.
  unzip_jpacman_ p;d
else.
  if. 'Linux'-:UNAME do.
    if. fhs do.
      if. fexist '/etc/redhat-release' do.
        d1=. IF64{::'/usr/lib/.';'/usr/lib64/.'
      else.
        if. IFRASPI do.
          d1=. IF64{::'/usr/lib/arm-linux-gnueabihf/.';'/usr/lib/aarch64-linux-gnu/.'
        elseif. do.
          d1=. IF64{::'/usr/lib/i386-linux-gnu/.';'/usr/lib/x86_64-linux-gnu/.'
        end.
      end.
      echo 'install libjqt.so to ',d1
      hostcmd_jpacman_ 'rm -f /usr/bin/jqt'
      hostcmd_jpacman_ 'cd ',(dquote jpath '~temp'),' && tar --no-same-owner --no-same-permissions -xzf ',(dquote p), ' && chmod 755 jqt && mv jqt /usr/bin/jqt-9.01 && chmod 644 libjqt.so && mv libjqt.so ',d1,'/libjqt.so.9.01 && ldconfig'
      hostcmd_jpacman_ 'update-alternatives --install /usr/bin/jqt jqt /usr/bin/jqt-9.01 901'
    else.
      hostcmd_jpacman_ 'cd ',(dquote d),' && tar xzf ',(dquote p)
    end.
  else.
    hostcmd_jpacman_ 'unzip -o ',(dquote p),' -d ',dquote d
  end.
end.
ferase p
if. #1!:0 fhs{::(jpath '~bin/',z1);'/usr/bin/jqt' do.
  m=. 'Finished install of ',bin
else.
  m=. 'Unable to install ',bin,LF
  m=. m,'check that you have write permission for: ',LF,fhs{::(jpath '~bin');'/usr/bin'
end.
smoutput m
if. 'Linux'-:UNAME do. return. end.

tgt=. jpath IFWIN{::'~install/Qt';'~bin/Qt5Core.dll'
y=. (*#y){::0;y

smoutput 'Installing Qt library...'
if. IFWIN do.
  z=. 'qt59-win-',((y-:'slim')#'slim-'),(IF64 pick 'x86';'x64'),'.zip'
else.
  z=. 'qt59-mac-',((y-:'slim')#'slim-'),(IF64 pick 'x86';'x64'),'.zip'
end.
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/j901/qtlib/',z
if. rc do.
  smoutput 'unable to download: ',z return.
end.
d=. jpath IFWIN{::'~install';'~bin'
if. IFWIN do.
  unzip_jpacman_ p;d
else.
  hostcmd_jpacman_ 'unzip -o ',(dquote p),' -d ',dquote d
end.
ferase p
if. #1!:0 tgt do.
  m=. 'Finished install of Qt library.'
else.
  m=. 'Unable to install Qt library.',LF
  m=. m,'check that you have write permission for: ',LF,IFWIN{::tgt;jpath'~bin'
end.
smoutput m

)
jpkg_z_=: 3 : 0
'help' jpkg y
:
a=. conew 'jpacman'
res=. x jpkg__a y
destroy__a''
res
)
jpkgv_z_=: (<@:>"1@|:^:(0 ~: #))@jpkg
je_update_z_=: je_update_jpacman_
