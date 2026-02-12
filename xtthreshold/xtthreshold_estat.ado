program define xtthreshold_estat, rclass
	syntax anything ,[*]

	
	gettoken cmd content: anything


	local xtthres_ClassName `e(ClassName)'

	tempvar smpl
	gen `smpl' = e(sample)
	return clear

	
	

	if "`cmd'" == "split" {
		mata `xtthres_ClassName'.estatSplit()
		return local varlist `varlist'

	}
	else if "`cmd'" == "graph" {
		if strlower("`content'") == " lr" {
			preserve 
				tempname m1 m2
				mata st_local("obs",strofreal(`xtthres_ClassName'.GridLength))
				clear
				set obs `obs'
				mata `m1' = _xtthreshold.GridZ
				mata `m2' = _xtthreshold.Est_LR
				getmata Gamma = `m1'
				getmata LR = `m2'
				gen double cval = -2*log(1-sqrt(`c(level)'/100))
				local cval cval[1]
				twoway (line  LR Gamma) (line cval Gamma , lp(dash) lc(red)) , legend( order(2) label(1 "LR") label(2 "`c(level)'% Critical Value (`=strofreal(`cval',"%-4.2f")')") holes(1) pos(6) rows(1)) ytitle("LR")
			restore
		}

			
	}
	else if "`cmd'" == "cmd" {
		mata st_local("depvar",`xtthres_ClassName'.DepName)
		mata st_local("IndepNo",`xtthres_ClassName'.IndepNoThresName)
		qui estat split
		local ThresdVars `r(varlist)'
		tempname StoredResults
		qui est sto `StoredResults'
		`content' `depvar' `IndepNo' `ThresdVars', `options'
		qui est sto `content'
		qui est restore `StoredResults'
		qui est drop `StoredResults'
		qui drop `ThresdVars'
		disp as text in smcl "Results from`content' saved as{it:`content'} ({stata est restore `content':click to restore})." 
	}

end
