
# Test 04
#
# Sections

. ../../bash_ini_parser.sh
if ! parse_ini test-04.ini ;then exit 1; fi

echo "var1:$INI__var1"
echo "var2:$INI__var2"

echo "setion1_var1:$INI__section1__var1"
echo "setion1_var2:$INI__section1__var2"
echo "setion1_var3:$INI__section1__var3"

echo "setion2_var1:$INI__section2__var1"
echo "setion2_var2:$INI__section2__var2"
echo "setion2_var3:$INI__section2__var3"
echo "setion2_var4:$INI__section2__var4"
echo "setion2_var5:$INI__section2__var5"

echo "setion3_var1:$INI__section3__var1"
echo "setion3_var2:$INI__section3__var2"

echo "number sections:${#INI____ALL_SECTIONS[@]}"
echo "all sections:${INI____ALL_SECTIONS[@]}"
echo "all variables:${INI____ALL_VARS[@]}"
