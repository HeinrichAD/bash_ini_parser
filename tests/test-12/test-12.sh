
# Test 12
#
# Array test

. ../../bash_ini_parser.sh
if ! parse_ini test-12.ini ;then exit 1; fi

echo "INI__first_section__one = '${INI__first_section__one}'"
echo "INI__first_section__five = '${INI__first_section__five}'"
echo "INI__first_section__animal = '${INI__first_section__animal}'"
echo
echo "INI__second_section__path = '${INI__second_section__path}'"
echo "INI__second_section__URL = '${INI__second_section__URL}'"
echo
echo "INI__third_section__phpversion[0] = '${INI__third_section__phpversion[0]}'"
echo "INI__third_section__phpversion[1] = '${INI__third_section__phpversion[1]}'"
echo "INI__third_section__phpversion[2] = '${INI__third_section__phpversion[2]}'"
echo "INI__third_section__phpversion[3] = '${INI__third_section__phpversion[3]}'"
echo "#INI__third_section__phpversion[@] = '${#INI__third_section__phpversion[@]}'"
echo "INI__third_section__phpversion[@] = '${INI__third_section__phpversion[@]}'"
echo
echo "INI__third_section__urls[svn] = '${INI__third_section__urls[svn]}'"
echo "INI__third_section__urls[git] = '${INI__third_section__urls[git]}'"
echo "#INI__third_section__urls[@] = '${#INI__third_section__urls[@]}'"
echo "INI__third_section__urls[@] = '${INI__third_section__urls[@]}'"
