program define xtthreshold, eclass
	syntax anything [if] , 				///
		Threshold(varlist max=1 ts)					///
		[csa(varlist) CSAall]						/// csa options
		/// Threshold options
		[HETEROgenous QUANTILes grid(numlist min = 1 max =3)]	///
		///[Quantiledefine(string) ]					/// use quantiles, default is 0.05 and 0.95 as max values
		///[NOTHRESholdvariables(varlist ts)]		/// constant variables
		///[values VALUESdefine(string)	]			/// use values, maximum and minimum or defined
		[trace]										/// trace
		///[GRIDLength(real 100)]						/// length of grid
		[NOFIXEDeffects NOCONSTant]					/// no FE and/or constant
		[CMDpost(string) MGreg]						/// run MG regression
		[inverter(string)]							///
		[version]									
		*** mark sample
		tempname touse
		marksample touse

		qui{
			cap findfile moremata.hlp
			if _rc != 0 {
				noi disp "Moremata is required. Please install:"
				noi disp in smcl "{stata ssc install moremata}"
				error 198
			}
		}

		if "`version'" != "" {
			local version 0.1
			noi disp "This is version `version' - 24.07.2025"
			ereturn local version "`version'"
			exit	
		}

		if "`cmdpost'" != "" & "`mgreg'" != "" {
			disp as error "Options cmd and mgreg cannot be combined"
			exit
		}

		if "`heterogenous'" != "" & "`quantiles'" != "" {
			disp as text "Heterogenous thresholds imply use of quantiles."
		}

		local cmd "`*'"

		if "`trace'" == "" {
			local trace "qui"
		}
		else {
			local trace noi
		}
			
		`trace' {

			_xt
			local tvar_o `r(tvar)'
			local idvar `r(ivar)'	
			local idvars `idvar'
			local IsPanel = 0

			
			gettoken indedepvars nothresholdvariables: anything , parse("|")

			tsunab indedepvars: `indedepvars'
			gettoken depvar indepvars: indedepvars
			
			if "`nothresholdvariables'" != "" {
				gettoken tmp nothresholdvariables: nothresholdvariables
				tsunab nothresholdvariables: `nothresholdvariables'
			}
			tsunab threshold: `threshold'
			
			if "`csaall'" != "" & "`csa'" == "" local csa `indepvars'

			if "`csa'" != "" {
				tempvar var_csa
				local csa_list
				foreach var in `csa' {
					by `tvar_o', sort: egen `var_csa'_`var' = mean(`var')
					local csa_list `csa_list' `var_csa'_`var'	
				}
				sort `idvar' `tvar_o'
			}
			
			/// Create mata class and run threshold model
			GetClassName

			mata `xtthres_ClassName' = c_xtthres()
			mata `xtthres_ClassName'.init()


			/// Run Program
			mata `xtthres_ClassName'.main_xtthres()

			/// ereturn 
			ereturn clear
			///ereturn post , esample(`touse')
			mata `xtthres_ClassName'.Ereturn()

		}
		/// output
		mata `xtthres_ClassName'.output_main()

		/// ereturn stata
		ereturn local cmd "xtthreshold"
		ereturn local estat_cmd "xtthreshold_estat" 
		ereturn local ClassName "`xtthres_ClassName'"

		if "`cmdpost'" != "" estat cmd `cmdpost'

end


// -------------------------------------------------------------------------------------------------
// GetArrayName
// -------------------------------------------------------------------------------------------------
cap program drop GetClassName
program define GetClassName
syntax [anything]

	if "`anything'" == "" {
		local anything "_xtthreshold"
	}

 	cap mata sizeof(m_xtthres1)(`anything')

	if _rc != 0 {
		c_local xtthres_ClassName `anything'
	}
	else {
		local i = 0
		while _rc == 0 {
			local i = `i' + 1
			cap mata sizeof(m_xtthres1)(`anything'`i')		
		}
		c_local xtthres_ClassName `anything'`i'
	}
end
