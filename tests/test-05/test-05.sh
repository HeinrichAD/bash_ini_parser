

# Test 05
#
# Prevention of in-value code execution via backticks or $() notation.
# This must be done because the value is run through an eval statement.

. ../../bash_ini_parser.sh
if ! parse_ini test-05.ini ;then exit 1; fi

echo "var1:$INI__var1"
echo "var2:$INI__var2"
echo "var3:$INI__var3"
echo "var4:$INI__var4"
echo "var5:$INI__var5"
echo "var6:$INI__var6"
