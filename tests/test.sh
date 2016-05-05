#!/bin/bash
###############################################################################
# Bash INI parser tester
# Test ini parser functionality.
#
###############################################################################
# Autors
# Florian Heinrich
#
###############################################################################
# License
# BSD-3-Clause, see LICENSE file
#
###############################################################################
# Source code
# **GIT REPOSITORY URL**
#
###############################################################################
# Available options/ Usage
# ./test.sh
#     Run all tests.
# ./test.sh 1 2 04 7
#     Run test 1, 2, 4 and 7.
# ./test.sh ( -c | --clean | --cleanup )
#     Remove all test-XX.out files.
#
###############################################################################

# Save current directory and move to test directory.
old_dir=$(cd)
cd "$(dirname $0)"
main_test_dir="$(pwd)"


declare -a tests
declare -a test_nums

# Read test arguments.
while [ $# -gt 0 ]
do
	case $1 in
		-c | --clean | --cleanup )
			echo "** Cleanup **"
			echo "Remove all test-XX.out files."
			rm -rf "test-*/test-*.out"
			local rm_code=$?
			cd ${old_dir}  # Move back to old directory.
			if [ rm_code -ne 0 ]
			then
				return -1
			else
				return 0
			fi
		;;

		* )
			test_nums[${#test_nums[@]}]="$1"
		;;
	esac

	shift
done


# Get test names.
if [ ${#test_nums[@]} == 0 ]
then
	tests=( $(ls -d test-*) )

else
	for test_num in ${test_nums[@]}
	do
		eval "tests[${#tests[@]}]=\$(ls -d \"test-$(printf %02d $test_num)\")"
	done
fi


# Run tests.
declare -a test_results
errors=0
time {
	for test in ${tests[@]}
	do
		echo "***********************************"
		echo -n " * Run test '${test}'. *"
		cd "${test}"

		# Run single test.
		time {
			bash "${test}.sh" &> "${test}.out"
		}

		echo " *"
		
		# Check result.
		dif=$(diff ${test}.out ${test}.out.correct 2>&1)
		if [[ -z "${dif}" ]]
		then
			echo "[OK]"
			# Remove test ouput file.
			rm -rf "${test}.out"

		else
			errors=$((errors+1))
			eval "test_results[${errors}]=\"${test}\""
			# Display difference.			
			echo "[ERROR] Test '${test}' failed."
			echo "Full output is in '${test}/${test}.out'."
			echo "${dif}"
		fi
		
		cd "${main_test_dir}"
		echo " * End test '${test}'. *"
		echo "***********************************"
		echo
	done
}


# Announce test result.
echo
if [ ${errors} == 0 ]
then
	echo "[OK] All tests passed."

else
	echo -n "${errors} test"
	if [ ${errors} -gt 1 ]
	then
		echo -n "s"
	fi
	echo " failed:"

	for test in ${test_results[@]}
	do
		echo "[ERROR] ${test}"
	done
fi


# Move back to old directory.
cd ${old_dir}


# Return error count
exit ${errors}
