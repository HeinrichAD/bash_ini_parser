
# Test 02
#
# Basic variable values; leading/trailing whitespace; comments

. ../../bash_ini_parser.sh
if ! parse_ini test-02.ini ;then exit 1; fi

#echo "a:LOCALVAR=$LOCALVAR"
echo "var1:$INI__var1"
echo "var2:$INI__var2"
echo "var3:$INI__var3"
echo "var4:$INI__var4"
echo "var5:$INI__var5"
echo "var6:$INI__var6"
echo "var7:$INI__var7"
echo "var8:$INI__var8"
echo "var9:$INI__var9"
echo "var10:$INI__var10"
echo "var11:$INI__var11"
