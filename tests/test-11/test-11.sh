
# Test 11
#
# Option: [--splitter | -s] INI_VAR_SPLITTER

# First: valid value for splitter
echo "# 1"
. ../../bash_ini_parser.sh
parse_ini --splitter _x_ test-11.ini

echo "var1:$INI_x_var1"
echo "section1 var1:$INI_x_section1_x_var1"
echo


# Second: invalid value for splitter (contains illegal chars)
echo "# 2"
. ../../bash_ini_parser.sh
parse_ini -nc --splitter ":" test-11.ini && {
	echo "var1:$INI:var1"
	echo "section1 var1:$INI:section1:var1"
}
echo
