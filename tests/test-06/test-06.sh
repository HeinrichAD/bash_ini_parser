
# Test 06
#
# Dots in variable names (converted to underscores in output var names)

. ../../bash_ini_parser.sh
if ! parse_ini test-06.ini --dots "_" ;then exit 1; fi

echo "var_1:$INI__var_1"
echo "var_two:$INI__var_two"
echo "var_3_two_dots:$INI__var_3_two_dots"

echo "section 1 var_1:$INI__section1__var_1"
echo "section 1 var_two:$INI__section1__var_two"

echo "section 2 var_1:$INI__section_2__var_1"
echo "section 2 var_two:$INI__section_2__var_two"
