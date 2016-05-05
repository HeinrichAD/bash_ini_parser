
# Test 10
#
# further stuff which didn't worked in 0.3

. ../../bash_ini_parser.sh
if ! parse_ini test-10.ini ;then exit 1; fi


echo "var1:$INI__var1"
echo "var2:$INI__var2"
echo "var3:$INI__var3"
echo "var4:$INI__var4"
echo "var5:$INI__var5"
echo "var6:$INI__var6"
echo
echo "SECTION1 var1:$INI__SECTION1__var1"
echo "SECTION1 var2:$INI__SECTION1__var2"
echo "SECTION2 var3:$INI__SECTION2__var3"
echo "SECTION2 var4:$INI__SECTION2__var4"
echo "SECTION3 var5:$INI__SECTION3__var5"
echo "SECTION3 var6:$INI__SECTION3__var6"
