# Bash INI parser
Parse a simple ini file or string.

**Table of Contents**
- [Intension and inspiration](#intension-and-inspiration)
- [Usage](#usage)
- [Options](#options)
- [LICENSE](#license)


## Intension and inspiration
I found the [bash_ini_parser] from [rudimeier], the pull request from [jcass77] to support multiline values and wanted to add the support of arrays like in php.<br />
There was only one big problem. Bash does not support array nesting and the work of [rudimeier] based on arrays.
Due to this and some other things I decided to create my own bash INI parser.

Note: Some of the first function tests are still original work
of [rudimeier] and/ or [jcass77].


## Usage
```bash
#/usr/bash
# Example
. bash_ini_parser.sh
if ! parse_ini INI_FILE.ini ;then exit 1; fi

echo $INI__VAR1
echo $INI__SECTION__VAR1
```
For more example please look into the test files.


## Options
```bash
Bash INI parser
Parse a simple ini file or string.

Parse INI file or string:
parse_ini [-b|--boolean]
          [(-s|--splitter) INI_VAR_SPLITTER]
          [(-p|--prefix) INI_VAR_PREFIX]
          (FILE|INI_STRING_VAR)
          [(-d|--dots|--dots_replacement) DOTS_REPLACEMENT]
          [SECTION [SECTION_2 [...]]]

Cleanup INI variable:
parse_ini (-c|--clean)
          [(-p|--prefix) INI_VAR_PREFIX]
          [(-s|--splitter) INI_VAR_SPLITTER]
          [SECTION [SECTION_2 [...]]]
```
-b|--boolean<br />
Convert yes, true and on to 1 and no, false and off to 0.

(-s|--splitter) INI_VAR_SPLITTER<br />
Variable splitter string. Default: '**__**'.<br />
Exmaple: INI**__**section1**__**var1

(-p|--prefix) INI_VAR_PREFIX<br />
Variable prefix string. Default: '**INI**'.<br />
Exmaple: **INI**__section1__var1

FILE|INI_STRING_VAR<br />
INI file path or INI file content as string.

(-d|--dots|--dots_replacement) DOTS_REPLACEMENT<br />
Replace dots in keys and sections with a string replacemanet.

SECTION [SECTION_2 [...]]<br />
Sections to which should payed attention.

-c|--clean<br />
Clean/ unset variables.


## LICENSE
[BSD-3-Clause]<br />
For more information see LICENSE file.


[bash_ini_parser]: <https://github.com/rudimeier/bash_ini_parser>
[rudimeier]: <https://github.com/rudimeier>
[jcass77]: <https://github.com/jcass77>
[BSD-3-Clause]: <https://opensource.org/licenses/BSD-3-Clause>
