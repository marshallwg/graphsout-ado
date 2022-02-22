//Created by mwg on 6/27/2018
//Update 2/22/2022
//version 1.0
capture program drop graphsout
program define graphsout, rclass
	//define syntax
	version 9.2	
	syntax [anything], ///
		[ ///
		TYPE(string) ///
		FONT(string) ///
*		ORIENTation(string) ///
		REPLace ///
		]
	
	*First, detecting OS type
	if c(os)=="Windows" local sys=0
	if c(os)=="MacOSX" local sys=1
	
	*Defaults
	if `"`orientation'"'=="" {
		local orientation="portrait"
	}
	if `"`orientation'"'!="" {
		local orientation=`"`string'"'
	}
	
	if !mi("`font'") {
		local font "font(`font')"
	}
	else {
		local font
	}
	
	*Cleaning up the file name and path
	local filename=subinstr(`"`anything'"', `"""', "", .)
		
	*Now, check to see whether user entered anything in type
	if `"`type'"'=="" {
		di as error "Must provide at least one graph export type"
		exit 110
	}	
	
	*Now, confirming selected graph options match available options
	foreach graphtype in `type' {
		if !regexm("`graphtype'",`"(ps|eps|svg|wmf|emf|pdf|png|tif)"') {
			di as error "Type must be valid graph type"
			exit 110
		}
		if regexm("`graphtype'",`"(ps|eps|svg|wmf|emf|pdf|png|tif)"') {
			graph export "`filename'.`graphtype'", `replace' as(`graphtype') `font'
		}
		local types=`"`types' `graphtype'"'
	}
	return local filetypes="`types'"
end

