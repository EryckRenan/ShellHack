if not(defined("CALLISTO_INCLUDED"))

; Asar compatible file containing information about callisto, can be imported using incsrc as needed

; Marker define to mark that callisto.asm has been included
!CALLISTO_INCLUDED = 1

; Marker define to determine that callisto is assembling a file
!CALLISTO_ASSEMBLING = 1

; Define containing callisto's version number as a string
!CALLISTO_VERSION = "0.4.1"

; Defines containing callisto's version number as individual numbers
!CALLISTO_VERSION_MAJOR = 0
!CALLISTO_VERSION_MINOR = 4
!CALLISTO_VERSION_PATCH = 1

; Define containing path to user-specified header file
!CALLISTO_HEADER = "C:/Users/Eryck/Desktop/Cracka Shells Baserom v 0.4.0/shared/callisto/header.asm"

incsrc "!CALLISTO_HEADER"

; Define containing path to project root
!CALLISTO_ROOT = "C:/Users/Eryck/Desktop/Cracka Shells Baserom v 0.4.0"

; Define containing path to .callisto folder
!CALLISTO_PATH = "C:/Users/Eryck/Desktop/Cracka Shells Baserom v 0.4.0/.callisto"

; Define containing path to callisto's module imprint folder
!CALLISTO_MODULES = "C:/Users/Eryck/Desktop/Cracka Shells Baserom v 0.4.0/.callisto/modules"

; Macro which includes a specified source code file relative to the project root
macro incsrc_file(file_path)
	incsrc "!CALLISTO_ROOT/<file_path>"
endmacro

; Macro which includes a specified binary file relative to the project root
macro incbin_file(file_path)
	incbin "!CALLISTO_ROOT/<file_path>"
endmacro

; Macro which includes the labels of the given module into the current file
macro include_module(module)
	incsrc "!CALLISTO_MODULES/<module>"
endmacro

; Macro which calls a module label and automatically sets the data bank register
macro call_module(module_label)
	PHB
	PEA.w <module_label>>>8
	PLB
	PLB
	JSL <module_label>
	PLB
endmacro

; Macro which can be used to error out if the version number of the Callisto that's in use is lower than the one passed to the macro
macro require_callisto_version(major, minor, patch)
if !CALLISTO_VERSION_MAJOR > <major>
elseif !CALLISTO_VERSION_MAJOR == <major> && !CALLISTO_VERSION_MINOR > <minor>
elseif !CALLISTO_VERSION_MAJOR == <major> && !CALLISTO_VERSION_MINOR == <minor> && !CALLISTO_VERSION_PATCH >= <patch>
else
	error "Required Callisto version: <major>.<minor>.<patch>, actual Callisto version: !CALLISTO_VERSION"
endif
endmacro

endif
