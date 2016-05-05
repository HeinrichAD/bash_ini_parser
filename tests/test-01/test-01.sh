
# Test 01
#
# Clean test

. ../../bash_ini_parser.sh


echo "***************************"
echo "** Clear section 1 and 3 **"
echo "***************************"

INI__var1="INI__var1"
INI__var2="INI__var2"
INI__var3="INI__var3"
INI__var4="INI__var4"
INI__var5="INI__var5"
INI__var6="INI__var6"

INI__SECTION1__var1="INI__SECTION1__var1"
INI__SECTION1__var2="INI__SECTION1__var2"

INI__SECTION2__var3="INI__SECTION2__var3"
INI__SECTION2__var4="INI__SECTION2__var4"

INI__SECTION3__var5="INI__SECTION3__var5"
INI__SECTION3__var6="INI__SECTION3__var6"

declare -a INI____ALL_SECTIONS
INI____ALL_SECTIONS=( SECTION1 SECTION2 SECTION3 )
declare -a INI____ALL_VARS
INI____ALL_VARS=( INI__var1 INI__var2 INI__var3 INI__var4 INI__var5 INI__var6 INI__SECTION1__var1 INI__SECTION1__var2 INI__SECTION2__var3 INI__SECTION2__var4 INI__SECTION3__var5 INI__SECTION3__var6 )


echo "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
echo "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
echo "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
echo "INI____ALL_VARS:${INI____ALL_VARS[@]}"
echo




# Clean section 1 and 3 test
if ! parse_ini --clean SECTION1 "SECTION3"; then exit 1; fi
echo "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
echo "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
echo "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
echo "INI____ALL_VARS:${INI____ALL_VARS[@]}"
echo
echo



echo "****************************"
echo "** Clear sectionless vars **"
echo "****************************"

INI__var1="INI__var1"
INI__var2="INI__var2"
INI__var3="INI__var3"
INI__var4="INI__var4"
INI__var5="INI__var5"
INI__var6="INI__var6"

INI__SECTION1__var1="INI__SECTION1__var1"
INI__SECTION1__var2="INI__SECTION1__var2"

INI__SECTION2__var3="INI__SECTION2__var3"
INI__SECTION2__var4="INI__SECTION2__var4"

INI__SECTION3__var5="INI__SECTION3__var5"
INI__SECTION3__var6="INI__SECTION3__var6"

declare -a INI____ALL_SECTIONS
INI____ALL_SECTIONS=( SECTION1 SECTION2 SECTION3 )
declare -a INI____ALL_VARS
INI____ALL_VARS=( INI__var1 INI__var2 INI__var3 INI__var4 INI__var5 INI__var6 INI__SECTION1__var1 INI__SECTION1__var2 INI__SECTION2__var3 INI__SECTION2__var4 INI__SECTION3__var5 INI__SECTION3__var6 )


echo "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
echo "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
echo "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
echo "INI____ALL_VARS:${INI____ALL_VARS[@]}"
echo


# Clean sectionless test
if ! parse_ini --clean "[]"; then exit 1; fi
echo "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
echo "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
echo "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
echo "INI____ALL_VARS:${INI____ALL_VARS[@]}"
echo
echo


echo "******************************************"
echo "** Clear section 1 and sectionless vars **"
echo "******************************************"

INI__var1="INI__var1"
INI__var2="INI__var2"
INI__var3="INI__var3"
INI__var4="INI__var4"
INI__var5="INI__var5"
INI__var6="INI__var6"

INI__SECTION1__var1="INI__SECTION1__var1"
INI__SECTION1__var2="INI__SECTION1__var2"

INI__SECTION2__var3="INI__SECTION2__var3"
INI__SECTION2__var4="INI__SECTION2__var4"

INI__SECTION3__var5="INI__SECTION3__var5"
INI__SECTION3__var6="INI__SECTION3__var6"

declare -a INI____ALL_SECTIONS
INI____ALL_SECTIONS=( SECTION1 SECTION2 SECTION3 )
declare -a INI____ALL_VARS
INI____ALL_VARS=( INI__var1 INI__var2 INI__var3 INI__var4 INI__var5 INI__var6 INI__SECTION1__var1 INI__SECTION1__var2 INI__SECTION2__var3 INI__SECTION2__var4 INI__SECTION3__var5 INI__SECTION3__var6 )


echo "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
echo "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
echo "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
echo "INI____ALL_VARS:${INI____ALL_VARS[@]}"
echo


# Clean section 1 and sectionless test
if ! parse_ini --clean SECTION1 "[]"; then exit 1; fi
echo "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
echo "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
echo "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
echo "INI____ALL_VARS:${INI____ALL_VARS[@]}"
echo
echo



echo "***************"
echo "** Clear all **"
echo "***************"

INI__var1="INI__var1"
INI__var2="INI__var2"
INI__var3="INI__var3"
INI__var4="INI__var4"
INI__var5="INI__var5"
INI__var6="INI__var6"

INI__SECTION1__var1="INI__SECTION1__var1"
INI__SECTION1__var2="INI__SECTION1__var2"

INI__SECTION2__var3="INI__SECTION2__var3"
INI__SECTION2__var4="INI__SECTION2__var4"

INI__SECTION3__var5="INI__SECTION3__var5"
INI__SECTION3__var6="INI__SECTION3__var6"

declare -a INI____ALL_SECTIONS
INI____ALL_SECTIONS=( SECTION1 SECTION2 SECTION3 )
declare -a INI____ALL_VARS
INI____ALL_VARS=( INI__var1 INI__var2 INI__var3 INI__var4 INI__var5 INI__var6 INI__SECTION1__var1 INI__SECTION1__var2 INI__SECTION2__var3 INI__SECTION2__var4 INI__SECTION3__var5 INI__SECTION3__var6 )


echo "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
echo "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
echo "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
echo "INI____ALL_VARS:${INI____ALL_VARS[@]}"
echo


# Clean all test
if ! parse_ini --clean; then exit 1; fi
echo "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
echo "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
echo "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
echo "INI____ALL_VARS:${INI____ALL_VARS[@]}"
echo
