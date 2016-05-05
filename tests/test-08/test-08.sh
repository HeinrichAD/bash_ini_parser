
# Test 08
#
# Option: [--prefix | -p] PREFIX

# First: valid value for prefix
echo "# 1"
. ../../bash_ini_parser.sh
parse_ini --prefix PREFIX1 test-08.ini

echo "var1:$PREFIX1__var1"
echo "section1 var1:$PREFIX1__section1__var1"
echo


# Second: invalid value for prefix (contains illegal chars)
echo "# 2"
. ../../bash_ini_parser.sh
parse_ini -p PR:EFIX --no_color test-08.ini && {
	echo "var1:$PREFIX1__var1"
	echo "section1 var1:$PREFIX1__section1__var1"
}
echo


# Third: invalid value for prefix (begins with a number)
echo "# 3"
. ../../bash_ini_parser.sh
parse_ini --prefix 1PREFIX -nc test-08.ini &&
{
	echo "var1:$PREFIX1__var1"
	echo "section1 var1:$PREFIX1__section1__var1"
}
