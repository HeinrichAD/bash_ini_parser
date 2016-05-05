
# Test 03
#
# Multiline string test

. ../../bash_ini_parser.sh
if ! parse_ini test-03.ini ;then exit 1; fi

echo "multiline1: '$INI__multiline1'"
echo "multiline2: '$INI__multiline2'"
echo "multiline3: '$INI__multiline3'"
echo "multiline4: '$INI__multiline4'"
echo
echo "multiline10: '$INI__multiline10'"
echo "multiline11: '$INI__multiline11'"
echo "multiline12: '$INI__multiline12'"
echo "multiline13: '$INI__multiline13'"
echo "multiline14: '$INI__multiline14'"
echo
echo "multiline20: '$INI__multiline20'"
echo "multiline21: '$INI__multiline21'"
echo "multiline22: '$INI__multiline22'"
echo "multiline23: '$INI__multiline23'"
echo "multiline24: '$INI__multiline24'"
echo
echo "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
echo "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
echo "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
echo "INI____ALL_VARS:${INI____ALL_VARS[@]}"
