###############################################################################
# Bash INI parser
# Parse a simple ini file to an array.
#
###############################################################################
# Autors
# Florian Heinrich
#
###############################################################################
# License
# BSD-3-Clause, see LICENSE file.
#
###############################################################################
# Intension and inspiration
# I found the bash_ini_parser from rudimeier
# [https://github.com/rudimeier/bash_ini_parser],
# the pull request from jcass77 [https://github.com/jcass77]
# to support multiline values and wanted to add the support
# of arrays like in php.
# There was one big problem. Bash does not support array nesting.
# Due to this and some other things I decided to create my own bash INI parser.
# Note: Some of the first function tests are still original work
#       of rudimeier and/ or jcass77
#
###############################################################################
# Source code
# https://github.com/HeinrichAD/bash_ini_parser
#
###############################################################################
# Available options/ Usage
# See README or function parse_ini__display_help below.
#
###############################################################################


function parse_ini()
{
	function parse_ini__display_help()
	{
		#parse_ini__log [INFO] "display_help()"

		echo "Bash INI parser
Parse a simple ini file or string.

Parse INI file or string:
${FUNC_NAME} [-b|--boolean]
          [(-s|--splitter) INI_VAR_SPLITTER]
          [(-p|--prefix) INI_VAR_PREFIX] (FILE|INI_STRING_VAR)
          [(-d|--dots|--dots_replacement) DOTS_REPLACEMENT]
          [SECTION [SECTION_2 [...]]]

Cleanup INI variable:
${FUNC_NAME} (-c|--clean) [(-p|--prefix) INI_VAR_PREFIX]
          [(-s|--splitter) INI_VAR_SPLITTER]
          [SECTION [SECTION_2 [...]]]
"
	}


	function parse_ini__parse_arguments()
	{
		#parse_ini__log [INFO] "parse_arguments()"
		#parse_ini__log [INFO] "args='$@'"

		while [ $# -gt 0 ]
		do
			case $1 in
				--clean | -c )
					CLEAN_ENV=1
				;;

				--booleans | -b )
					BOOLEANS=1
				;;

				--prefix | -p )
					shift
					INI_PREFIX="$1"
				;;

				--splitter | -s )
					shift
					INI_SPLITTER="$1"
				;;

				--dots_replacement | --dots | -d )
					shift
					DOTS_REPLACEMENT="$1"
				;;

				--no_color | -nc )
					NO_COLOR=1
				;;

				--help | -h )
					parse_ini__display_help
				;;

				* )
					if [ -z "${INI_FILE}" ]
					then
						INI_FILE="$1"
					else
						INI_SECTION[${#INI_SECTION[@]}]="$1"
					fi
				;;
			esac
			shift
		done
	}


	function parse_ini__log()
	{
		#parse_ini__log [INFO] "log()"

		echo -n "${FUNC_NAME} "

		local level="$1"
		level=${level^^}
		shift
		case "${level}" in
			"[ERROR]" | "ERROR" )
				if ((${NO_COLOR}))
				then
					echo -n "[ERROR]"
				else
					echo -en "\e[91m[ERROR]"
				fi
			;;
			"[INFO]" | "INFO" )
				if ((${NO_COLOR}))
				then
					echo -n "[INFO] "
				else
					echo -en "\e[32m[INFO] "
				fi
			;;
			"[OK]" | "OK" )
				if ((${NO_COLOR}))
				then
					echo -n "[OK]   "
				else
					echo -en "\e[92m[OK]   "
				fi
			;;
					
			"[WARNING]" | "WARNING" | "[WARN]" | "WARN" )
				if ((${NO_COLOR}))
				then
					echo -n "[WARN] "
				else
					echo -en "\e[93m[WARN] "
				fi
			;;
		esac
		parse_ini__return_to_color_default

		local main_message="$1"
		shift

		echo " ${main_message}"

		if [[ $# > 0 ]]
		then
			if ((${NO_COLOR}))
			then
				echo "$@"
			else
				echo -en "\e[38;5;241m$@"
				parse_ini__return_to_color_default
				echo
			fi
		fi
	}


	function parse_ini__return_to_color_default()
	{
		#parse_ini__log [INFO] "return_to_color_default()"

		if ((!${NO_COLOR}))
		then
			echo -en "\e[39m\e[49m"
		fi
	}


	function parse_ini__init()
	{
		#parse_ini__log [INFO] "init()"

		if ! shopt -q extglob
		then
			SWITCH_SHOPT="${SWITCH_SHOPT} extglob"
		fi
		shopt -q -s ${SWITCH_SHOPT}
	}


	function parse_ini__dispose()
	{
		#parse_ini__log [INFO] "dispose()"

		unset -f parse_ini__display_help
		unset -f parse_ini__parse_arguments
		unset -f parse_ini__log
		unset -f parse_ini__return_to_color_default
		unset -f parse_ini__clean_environment
		unset -f parse_ini__array_contains_section_var
		unset -f parse_ini__is_section
		unset -f parse_ini__is_ignore_line
		unset -f parse_ini__get_line_value
		unset -f parse_ini__is_key_value_pair
		unset -f parse_ini__remove_first_quotation_char
		unset -f parse_ini__remove_last_quotation_char
		unset -f parse_ini__get_ini_content
		unset -f parse_ini__is_quotation_start
		unset -f parse_ini__is_quotation_end
		unset -f parse_ini__save_key_value_pair
		unset -f parse_ini__init
		unset -f parse_ini__array_check

		unset -f parse_ini__dispose

		shopt -q -u ${SWITCH_SHOPT}
	}


	function parse_ini__clean_environment()
	{
		#parse_ini__log [INFO] "clean_environment()"
		#parse_ini__log [INFO] "#INI____ALL_SECTIONS:${#INI____ALL_SECTIONS[@]}"
		#parse_ini__log [INFO] "INI____ALL_SECTIONS:${INI____ALL_SECTIONS[@]}"
		#parse_ini__log [INFO] "#INI____ALL_VARS:${#INI____ALL_VARS[@]}"
		#parse_ini__log [INFO] "INI____ALL_VARS:${INI____ALL_VARS[@]}"

		if [ ! -e ${INI_FILE} ] || [ -z ${INI_FILE} ]
		then
			local SECTION_NAME=""
			if [ -z ${INI_FILE} ]
			then
				# Remove all.
				#INI_SECTION[${#INI_SECTION[@]}]=""
				INI_FILE=""

			elif [ "${INI_FILE}" == "${SECTIONLESS_CONST}" ]
			then
				INI_SECTION[${#INI_SECTION[@]}]="${SECTIONLESS_CONST}"
				INI_FILE=""

			else
				parse_ini__is_section "[${INI_FILE}]" SECTION_NAME
				if ((!$?))
				then
					INI_SECTION[${#INI_SECTION[@]}]="${SECTION_NAME}"
					INI_FILE=""
				fi
			fi
		fi
		
		declare -a CLEAN_SECTIONS
		if ((${#INI_SECTION[@]}))
		then
			CLEAN_SECTIONS=( ${INI_SECTION[@]} )
		else
			# Remove all.
			CLEAN_SECTIONS=( "" )
		fi

		declare -a ALL_VARS
		eval "ALL_VARS=( \${${INI_PREFIX}${INI_SPLITTER}__ALL_VARS[@]} )"
		for var in "${ALL_VARS[@]}"
		do
			if ((${#CLEAN_SECTIONS[@]}))
			then
				#parse_ini__log [INFO] "Check if var: '${var}' should be unset."
				parse_ini__array_contains_section_var "${var}" "${CLEAN_SECTIONS[@]}"
				((!$?)) && {
					#parse_ini__log [INFO] "unset var: '${var}'"
					# Unset variable and remove it from var array.
					eval "unset ${var}"
					eval "${INI_PREFIX}${INI_SPLITTER}__ALL_VARS=( \${${INI_PREFIX}${INI_SPLITTER}__ALL_VARS[@]/\$var} )"
				}

			else
				#parse_ini__log [INFO] "unset var: '${var}'"
				# Unset variable and remove it from var array.
				eval "unset ${var}"
				eval "${INI_PREFIX}${INI_SPLITTER}__ALL_VARS=( \${${INI_PREFIX}${INI_SPLITTER}__ALL_VARS[@]/\$var} )"
			fi
		done
		
		eval "local CLEAN_ALL=\${#${INI_PREFIX}${INI_SPLITTER}__ALL_VARS[@]}"
		if ((CLEAN_ALL))
		then
			# Cleanup section array
			for section in "${CLEAN_SECTIONS[@]}"
			do
				eval "${INI_PREFIX}${INI_SPLITTER}__ALL_SECTIONS=( \${${INI_PREFIX}${INI_SPLITTER}__ALL_SECTIONS[@]/\$section} )"
			done
		else
			# Clean all
			eval "unset ${INI_PREFIX}${INI_SPLITTER}__ALL_VARS"
			eval "unset ${INI_PREFIX}${INI_SPLITTER}__ALL_SECTIONS"
		fi
	}


	# parse_ini__array_contains "element" "${array[@]}"
	function parse_ini__array_contains_section_var()
	{
		#parse_ini__log [INFO] "array_contains_start_with()"

		for section in "${@:2}"
		do
			if [ "${section}" == "${SECTIONLESS_CONST}" ]
			then
				# Sectionless special
				if [[ $(grep -o '__' <<<"$1" | grep -c .) == 1 ]]
				then
					return 0
				fi
			else
				eval "[[ \"$1\" == ${INI_PREFIX}${INI_SPLITTER}${section}* ]] && return 0"
			fi
		done
		return 1
	}


	function parse_ini__is_section()
	{
		#parse_ini__log [INFO] "is_section()"

		local line="$1"
		local __SECTION_NAME=""
		if [ $# -gt 1 ]
		then
			__SECTION_NAME="$2"
		fi

		#parse_ini__log [INFO] "line: '${line}'"
		#parse_ini__log [INFO] "SECTION_VAR_NAME: '${__SECTION_NAME}'"

		local REG_SECTION='^\s*\[(.*?)\]\s*([#|;].*)?$'
		if [[ "${line}" =~ $REG_SECTION ]]
		then
			local REG_VALID_SECTION='^\s*\[([a-zA-Z_0-9\.]+)\]\s*([#|;].*)?$'
			if [[ "${line}" =~ $REG_VALID_SECTION ]]
			then
				#parse_ini__log [INFO] "Found section: '${BASH_REMATCH[1]}'"
				if [ ! -z "${__SECTION_NAME}" ]
				then
					local __section_val="${BASH_REMATCH[1]}"
					if [ ! -z "${DOTS_REPLACEMENT}" ]
					then
						eval "__section_val=\"\${__section_val//./${DOTS_REPLACEMENT}}\""
					fi

					eval "${__SECTION_NAME}=\"${__section_val}\""
				fi
				return 0

			else
				# Invalid section
				return 2
			fi

		else
			return 1
		fi
	}


	function parse_ini__is_ignore_line()
	{
		#parse_ini__log [INFO] "is_ignore_line()"

		local line="$1"

		#parse_ini__log [INFO] "line: '${line}'"

		local REG_IGNORE='^\s*([#|;].*)?$'
		if [[ "${line}" =~ $REG_IGNORE ]]
		then
			#parse_ini__log [INFO] "Line to ignore found: ${line}'"
			return 0
		else
			return 1
		fi
	}


	function parse_ini__get_line_value() # Multiline
	{
		#parse_ini__log [INFO] "get_line_value()"

		local __line="$1"
		local __value="$2"
		local __continue="$3"

		#__line="$(echo -e "${__line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		__line="${__line%%+([[:space:]])}"
		__line="${__line##+([[:space:]])}"
		
		local REG_VALUE='^((['"'"'"]?)(.*?)(\2))\s*([\\]?)\s*([#|;].*)?$'
		if [[ "${__line}" =~ $REG_VALUE ]]
		then
			#echo "${BASH_REMATCH[3]}-${BASH_REMATCH[5]}"
			if [[ ( ! -z "${BASH_REMATCH[2]}") && ( ! -z "${BASH_REMATCH[4]}") ]]
			then
				# String in quotation
				if [ -z "${BASH_REMATCH[5]}" ]
				then 
					eval "${__continue}=0"
				else
					eval "${__continue}=1"
				fi

				eval "${__value}=\"\${BASH_REMATCH[3]}\""

			else
				# String without quotation
				# Bash bug ${BASH_REMATCH[5]} will return ever null
				local __val="${BASH_REMATCH[3]}"
				if [ "${__val:(-1)}" == "\\" ]
				then
					eval "${__continue}=1"

					__val="${__val%\\}"
					#__val="$(echo -e "${__val}" | sed -e 's/[[:space:]]*$//')"
					__line="${__line%%+([[:space:]])}"

				else
					eval "${__continue}=0"
					__val="${BASH_REMATCH[3]}"
				fi

				eval "${__value}=\"\${__val}\""
			fi

			return 0

		else
			return 1
		fi
	}


	function parse_ini__is_key_value_pair()
	{
		#parse_ini__log [INFO] "is_key_value_pair()"
		
		local __line="$1"
		local __key="$2"
		local __key_val
		local __val="$3"
		local __val_val
		local __had_quotation="$4"

		#parse_ini__log [INFO] "line: '${__line}'"

		#^\s*(([a-zA-Z_0-9]([a-zA-Z_0-9\[?\.](\])?)*))\s*(=|:)\s*((['"]?)(.*)(\7))(\s*)([#|;].*)?$
		#^\s*(([a-zA-Z_0-9\[?\.](\])?)+)\s*(=|:)\s*((['"]?)(.*)(\6))(\s*)([#|;].*)?$
		#^\s*([a-zA-Z_0-9\[\]\.]+)\s*(=|:)\s*((['"]?)(.*)(\4))(\s*)([#|;].*)?$
		local REG_SECTION='^\s*(([a-zA-Z_0-9]([a-zA-Z_0-9\[?\.](\])?)*))\s*(=|:)\s*((['"'"'"]?)(.*)(\7))(\s*)([#|;].*)?$'
		#local REG_SECTION="^\\s*([a-zA-Z_0-9\\.]+)\\s*(=|:)\\s*((['\"]?)(.*)(\\4))(\\s*)([#|;].*)?$"
		if [[ "${__line}" =~ $REG_SECTION ]]
		then
			if [ -z "${BASH_REMATCH[7]}" ]
			then
				eval "${__had_quotation}=0"

				__key_val="${BASH_REMATCH[1]}"
				__val_val="${BASH_REMATCH[8]}"

				# Remove tailing spaces. [Maybe bash bug that there are spaces.]
				#__val_val="$(echo -e "${__val_val}" | sed -e 's/[[:space:]]*$//')"
				__val_val="${__val_val%%+([[:space:]])}"

			else
				eval "${__had_quotation}=1"

				__key_val="${BASH_REMATCH[1]}"
				__val_val="${BASH_REMATCH[6]}"

				# Remove tailing spaces. [Maybe bash bug that there are spaces.]
				#__val_val="$(echo -e "${__val_val}" | sed -e 's/[[:space:]]*$//')"
				__val_val="${__val_val%%+([[:space:]])}"
				
				# Remove qoutations
				#echo "Before: '${__val_val}'"
				#parse_ini__remove_first_quotation_char "${__val_val}" __val_val
				#parse_ini__remove_last_quotation_char "${__val_val}" __val_val
				if [ "${__val_val::1}" == "\"" ]
				then
					__val_val="${__val_val#\"}"
					__val_val="${__val_val%\"}"
				else
					__val_val="${__val_val#\'}"
					__val_val="${__val_val%\'}"
				fi
				#echo "After: '${__val_val}'"
			fi
			eval "${__key}=\"\${__key_val}\""
			eval "${__val}=\"\${__val_val}\""

			return 0
		else
			return 1
		fi
	}


	function parse_ini__remove_first_quotation_char()
	{
		#parse_ini__log [INFO] "remove_first_quotation_char()"

		local __val="$1"
		local __val_result="$2"

		if [ "${__val::1}" == "\"" ]
		then
			__val="${__val#\"}"
		else
			__val="${__val#\'}"
		fi

		eval "${__val_result}=\"\${__val}\""
		return 0
	}


	function parse_ini__remove_last_quotation_char()
	{
		#parse_ini__log [INFO] "remove_last_quotation_char()"

		local __val="$1"
		local __val_result="$2"

		if [ "${__val:(-1)}" == '"' ]
		then
			__val="${__val%\"}"
		else
			__val="${__val%\'}"
		fi

		eval "${__val_result}=\"\${__val}\""

		return 0
	}


	function parse_ini__get_ini_content()
	{
		#parse_ini__log [INFO] "get_ini_content()"
		
		local __CONTENT_VAR="$1"

		#parse_ini__log [INFO] "$(ls -lah)"

		if [ -e ${INI_FILE} ]
		then
			if [ ! -r ${INI_FILE} ]
			then
				echo "Unable to read INI file '${INI_FILE}'."
				return 1
			fi

			#parse_ini__log [INFO] "INI content from file."
			eval "${__CONTENT_VAR}=\"\$(cat '${INI_FILE}')\""

		else
			#parse_ini__log [INFO] "INI content from string."
			eval "${__CONTENT_VAR}=\"\${INI_FILE}\""
		fi
		
		return 0
	}


	function parse_ini__is_quotation_start()
	{
		#parse_ini__log [INFO] "is_quotation_start()"

		local __val="$1"
		local __val_org="$1"
		local __val_result="$2"
		local __qoutation="$3"
		
		if [ "${#__val}" -lt "2" ]
		then
			# Line like the following should valide too:
			# var1="
			return 1
		fi

		__val="${__val::1}"
		if [[ ("${__val}" == '"') || ("${__val}" == "'") ]]
		then
			parse_ini__remove_first_quotation_char "${__val_org}" "${__val_result}"
			eval "${__qoutation}=\"\${__val}\""
			return 0

		else
			return 2
		fi
	}

	function parse_ini__is_quotation_end()
	{
		#parse_ini__log [INFO] "is_quotation_end()"

		local __val="$1"
		local __char="$2"
		local __val_reuslt="$3"

		if [[ "${__val:(-1)}" == "${__char}" ]]
		then
			if [[ "${__val:(-2)}" != "\\${__char}" ]]
			then
				#parse_ini__log [INFO] "Quotation End"
				parse_ini__remove_last_quotation_char "${__val}" "${__val_reuslt}"
				return 0
			fi
		fi
		eval "${__val_reuslt}=\"\${__val}\""
		return 1
	}


	function parse_ini__array_check()
	{
		local __key_val="$1"
		local __key_="$2"

		#local REG_ARRAY='^([a-zA-Z_0-9\.]+?)\[(((['"'"'"])(.*?)(\4))|[A-Za-z_0-9\.]*?)\]$'
		local REG_ARRAY='^(.*?)\[(.*?)\]$'
    	if [[ "${__key_val}" =~ $REG_ARRAY ]]
    	then
    		local ARRAY_BASE_NAME="${BASH_REMATCH[1]}"
    		local ARRAY_VALUE_KEY="${BASH_REMATCH[2]}"

    		eval "declare -g -A ${ARRAY_BASE_NAME}"

			if [ -z "${ARRAY_VALUE_KEY}" ]
			then
				## Normal Array - No Dictionary (Key Value Array)
    			eval "${__key_}=${ARRAY_BASE_NAME}[\${#${ARRAY_BASE_NAME}[@]}]"
			fi
    	fi
	}


	function parse_ini__save_key_value_pair()
	{
		#parse_ini__log [INFO] "save_key_value_pair()"
		
		local __section="$1"
		local __key="$2"
		local __val="$3"

		if [ ! -z "${DOTS_REPLACEMENT}" ]
		then
			eval "__key=\"\${__key//./${DOTS_REPLACEMENT}}\""
		fi

		local __section_marker=""
		if [ ! -z "${__section}" ]
		then
			__section_marker="${__section}${INI_SPLITTER}"
		fi

		__key="${INI_PREFIX}${INI_SPLITTER}${__section_marker}${__key}"
		parse_ini__array_check "${__key}" __key
		
		#parse_ini__log [INFO] "${INI_PREFIX}${INI_SPLITTER}${__section_marker}${__key}=\"\${__val}\""
		eval "${__key}=\"\${__val}\""
		eval "${INI_PREFIX}${INI_SPLITTER}__ALL_VARS=( \${${INI_PREFIX}${INI_SPLITTER}__ALL_VARS[@]} ${__key} )"
	}



	local FUNC_NAME="parse_ini"
	declare -a INI_SECTION
	local CLEAN_ENV=0
	local BOOLEANS=0
	local NO_COLOR=0
	local INI_FILE
	local INI_PREFIX_DEFAULT="INI"
	local INI_PREFIX="${INI_PREFIX_DEFAULT}"
	local INI_SPLITTER_DEFAULT="__"
	local INI_SPLITTER="${INI_SPLITTER_DEFAULT}"
	local DOTS_REPLACEMENT=""
	local SECTIONLESS_CONST="[]"
	local SWITCH_SHOPT=""


	#parse_ini__log [INFO] "Start ${FUNC_NAME}"


	parse_ini__init
	parse_ini__parse_arguments $@

	#parse_ini__log [INFO] "FUNC_NAME=${FUNC_NAME}"
	#parse_ini__log [INFO] "INI_SECTION='${INI_SECTION[@]}'"
	#parse_ini__log [INFO] "CLEAN_ENV=${CLEAN_ENV}"
	#parse_ini__log [INFO] "BOOLEANS=${BOOLEANS}"
	#parse_ini__log [INFO] "INI_FILE=${INI_FILE}"
	#parse_ini__log [INFO] "INI_PREFIX=${INI_PREFIX}"
	#parse_ini__log [INFO] "INI_SPLITTER=${INI_SPLITTER}"


	if [[ "${INI_PREFIX}" != "${INI_PREFIX_DEFAULT}" ]]
	then
		# Check prefix
		local REG_PREFIX='^[a-zA-Z_]+[a-zA-Z_0-9]*$'
		if ! [[ "${INI_PREFIX}" =~ $REG_PREFIX ]]
		then
			parse_ini__log [ERROR] "INI prefix is not valid." "Prefix: '${INI_PREFIX}'"
			parse_ini__dispose
			return 1
		fi
	fi

	if [[ "${INI_SPLITTER}" != "${INI_SPLITTER_DEFAULT}" ]]
	then
		# Check prefix
		local REG_SPLITTER='^[a-zA-Z_0-9\.]+$'
		if ! [[ "${INI_SPLITTER}" =~ $REG_SPLITTER ]]
		then
			parse_ini__log [ERROR] "INI variable splitter is not valid." "Splitter: '${INI_SPLITTER}'"
			parse_ini__dispose
			return 1
		fi
	fi


	((${CLEAN_ENV})) && parse_ini__clean_environment
	if [ -z "${INI_FILE}" ]
	then
		# Only cleanup or help display.
		parse_ini__dispose
		return 0
	fi


	local INI_FILE_CONTENT
	parse_ini__get_ini_content INI_FILE_CONTENT
	(($?)) && {
		echo "INI content exception. See error message above."
		parse_ini__dispose
		return 1
	}
	#parse_ini__log [INFO] "INI file content: '${INI_FILE_CONTENT}'"


	# Declare global array for all sections and all vars.
	eval "declare -g -a ${INI_PREFIX}${INI_SPLITTER}__ALL_SECTIONS"
	eval "declare -g -a ${INI_PREFIX}${INI_SPLITTER}__ALL_VARS"


	local CURRENT_SECTION=""
	local KEY
	local VALUE
	local MULTILINE=0
	local QOUTATIONS_OPEN=0
	# Analyze INI file/ string
	while IFS= read -r line
	do
		#parse_ini__log [INFO] "INI content line: '${line}'"

		if [ "${QOUTATIONS_OPEN}" != "0" ]
		then
			# Check of end quotation.
			local ADDITIONAL_VALUE=""
			parse_ini__is_quotation_end "${line}" "${QOUTATIONS_OPEN}" ADDITIONAL_VALUE
			if (($?))
			then
				VALUE="${VALUE}
${line}"

			else
				QOUTATIONS_OPEN=0
				VALUE="${VALUE}
${ADDITIONAL_VALUE}"
				parse_ini__save_key_value_pair "${CURRENT_SECTION}" "${KEY}" "${VALUE}"
			fi

			continue
		fi

		if ((${MULTILINE}))
		then
			local ADDITIONAL_VALUE=""
			parse_ini__get_line_value "${line}" ADDITIONAL_VALUE MULTILINE
			if (($?))
			then
				# Error handling.
				parse_ini__log [ERROR] "Multiline parse error" "Current KEY: '${KEY}'" "Current VALUE: '${VALUE}'" "Current line: '${line}'"
				parse_ini__dispose
				return 1
			fi

			VALUE="${VALUE}
${ADDITIONAL_VALUE}"

			if ((!${MULTILINE}))
			then
				parse_ini__save_key_value_pair "${CURRENT_SECTION}" "${KEY}" "${VALUE}"
			fi

			continue
		fi

		parse_ini__is_ignore_line "${line}"
		((!$?)) && {
			continue
		}
		
		parse_ini__is_section "${line}" CURRENT_SECTION
		if ((!$?))
		then
			eval "${INI_PREFIX}${INI_SPLITTER}__ALL_SECTIONS=( \${${INI_PREFIX}${INI_SPLITTER}__ALL_SECTIONS[@]} \${CURRENT_SECTION} )"
			continue

		elif [[ "$?" == "2" ]]
		then
			# Error handling.
			parse_ini__log [ERROR] "Invalid section name." "Line: '${line}'"
		fi

		local value_had_quotation=0
		parse_ini__is_key_value_pair "${line}" KEY VALUE value_had_quotation
		if ((!$?))
		then
			if ((!${value_had_quotation}))
			then
				parse_ini__is_quotation_start "${VALUE}" VALUE QOUTATIONS_OPEN
				if ((!$?))
				then
					continue
				fi
			fi
			
			local VALUE_TEMP=""
			parse_ini__get_line_value "${VALUE}" VALUE_TEMP MULTILINE
			if ((${MULTILINE}))
			then
				#parse_ini__log [INFO] "Set multiline true"
				VALUE="${VALUE_TEMP}"
				continue
			fi
			
			if ((BOOLEANS)) && ((!${value_had_quotation}))
			then
				case "${VALUE^^}" in
					YES | TRUE | ON )
						VALUE=1
					;;
					NO | FALSE | OFF )
						VALUE=0
					;;
				esac
			fi
			
			parse_ini__save_key_value_pair "${CURRENT_SECTION}" "${KEY}" "${VALUE}"

			continue
		fi


		# Error handling.
		parse_ini__log [ERROR] "Line parse error." "Current KEY: '${KEY}'" "Current VALUE: '${VALUE}'" "Current line: '${line}'"
		parse_ini__dispose
		return 1

	done <<< "${INI_FILE_CONTENT}"

	# INI parse end.
	# Result: OK
	#parse_ini__log [OK] "INI parse end."
	parse_ini__dispose
	return 0
}
