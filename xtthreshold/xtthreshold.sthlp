{smcl}
{hline}
{hi:help xtthreshold}{right: xtthreshold v. 0.1 - 24.07.2025}
{hline}
{title:Title}

{p 4 4}{cmd:xtthreshold} - threshold estimation for interactive fixed effects models.{p_end}

{title:Syntax}

{p 4 13}{cmd:xtthreshold} {depvar} {indepvars}1 | [{indepvars}2]  {ifin} {cmd:,} {cmdab:t:hreshold(thresvar)} [{cmd: csa({varlist}1) grid(integer)}]

{p 4 4}Data has to be {help tsset} or {help xtset} before using {cmd:xtthreshold}. 
{depvars}, {indepvars}1, {indepvars}2, {it:varname} and {it:varlist},  may contain time-series operators, see {help tsvarlist}.{break}
{cmd:xtthreshold} requires the {help moremata} package.{p_end}

{p 4 4}{it:thresvar} is the thresholding variable.
{indepvars}1 defines variables which are affected by the threshold.
{indepvars}2 contains variables which are {ul:not} affected by the threshold.
{varlist}1 are variables added as cross-section averages.{p_end}


{title:Contents}

{p 4}{help xtthreshold##description:Description}{p_end}
{p 4}{help xtthreshold##options:Options}{p_end}
{p 4}{help xtthreshold##postest:Postestimation}{p_end}
{p 4}{help xtthreshold##examples:Examples}{p_end}
{p 4}{help xtthreshold##references:References}{p_end}
{p 4}{help xtthreshold##about:About, Authors and Version History}{p_end}

{marker description}{title:Description}

{p 4 4}Assume three sets of independent expanatory variables in a panel data set over cross-sectional units {it:i} and time periods {it:t}:
{it:x(i,t)} which is not influenced by a threshold,
{it:w(i,t)} which has different effects on {it:y(i,t)}, depending if 
the thresholding variable {it:z(i,t)} is above or below a threshold {it:v}.
The model can be then written as:
{p_end}

{p 8 8}y(i,t) = b1 x(i,t) + g1 I(z(i,t) < v) w(i,t) + g2 I(z(i,t) > v) w_it + u(i,t){p_end} 

{p 4 4}We further assume that {it:x(i,t)}, {it:w(i,t)} and {it:v(i,t)} have a interactive fixed effects factor structure with the same unobserved common factors.
For example for the unobserved error component {it:u(it)} and one common factor:{p_end}

{p 8 8}u(i,t) = g(i) f(f) + eps(it){p_end} 

{p 4 4}where {it:g(i)} is the factor loading, {it:f(t)} the common factor and {it:eps(it)} iid noise.
Ignoring the factor structure would lead to bias estimation results and it is common to span 
the space of the factors using cross-section averages, see for example {help DK2025:Ditzen & Karavias (2025)} and {help xtdcce2}.{p_end}

{p 4 4}{cmd:xtthreshold} implements the threshold estimator in {help DKW2025:Ditzen et al. (2025)} to estimate {it:v}. 
The estimator creates a grid based on variable {it:z(i,t)} and splits {it:w(i,t)} accordingly and estimates b1, g1 and g2.
It then caclualtes the SSR for each grid segement and selects the threshold {it:v} based on the minumum of the SSRs.{p_end}

{p 4 4}{cmd:estat graph lr} draws a map of a Likelihood Ratio test if a given threshold is different from the optimal threshold. 
The test statistic is:{p_end}

{p 8 8}LR(v0) = NT (SSR(v0)-SSR(v))/SSR(v){p_end}

{marker options}{title:Options}

{p 4 8 12}{cmdab:t:hreshold(thresvar)} defines the thresholding variable, {it:Z}.{p_end}

{p 4 8 12}{cmd:csa(varlist1)} defines variables added as cross-section averages, {it:W}.{p_end}

{p 4 8 12}{cmd:grid(integer)} specifies the length of the grid. Default is 100.{p_end}

{marker postest}{title:Postestimation}

{p 4 4}{cmd:estat} can be used to create variables {cmd:I(z(i,t) < v) w(i,t)} and {cmd:I(z(i,t) > v) w_it}
and draw graphs with the test for a threshold for different values of the thresholding variables.{p_end}

{p 4 13}{cmd:estat split} split variables in {indepvars}1 into new ones variables following the estimated threshold.{p_end}

{p 4 13}{cmd:estat graph lr} draws graph of the LR test for different thresholds.{p_end}

{marker examples}{title:Examples}

{p 4 4}To replicate the results from help DKW2025:Ditzen et al. (2025)}, downloaded the data from
{browse "https://github.com/JanDitzen/xtthreshold/tree/main/data":GitHub}.
Then estimate the threshold as:{p_end}

{col 8}{stata xtthreshold gdppcgr govspend khanvar | open popgr grosscap  , threshold(khanvar) grid(400) csa(govspend khanvar open popgr grosscap)}

{p 4 4}Split the variables affected by the threshold:{p_end}

{col 8}{stata estat split}

{p 4 4}and estimate the model using the CCEP estimator and {help xtdcce2}:{p_end}

{col 8}{stata xtdcce2 gdppcgr govspend_0 khanvar_0 govspend_1 khanvar_1 open popgr grosscap, cr(govspend khanvar open popgr grosscap)}

{p 4 4}For an overview we can draw a graph with combinations of the LR test for different thresholds:{p_end}

{col 8}{stata estat graph lr}

{marker references}{title:References}

{marker DK2025}{p 4 8}Ditzen, J. & Karavias, Y. (2025) 
Interactive, Grouped and Non-separable Fixed Effects: A Practitioner's Guide to the New Panel Data Econometrics
{browse "abc":Link}.{p_end}


{marker DKW2025}{p 4 8}Ditzen, J., Karavias, Y. & Westerlund, J. (2025) 
Threshold Regression in Interactive Fixed Effects Panel Data and the Impact of Inflation on Economic Growth
{browse "abc":Link}.{p_end}

{marker about}{title:Authors}

{p 4}Jan Ditzen (Free University of Bozen-Bolzano){p_end}
{p 4}Email: {browse "mailto:jan.ditzen@unibz.it":jan.ditzen@unibz.it}{p_end}
{p 4}Web: {browse "www.jan.ditzen.net":www.jan.ditzen.net}{p_end}

{p 4}Yiannis Karavias (Brunel University){p_end}
{p 4}Email: {browse "mailto:yiannis.karavias@brunel.ac.uk":yiannis.karavias@brunel.ac.uk}{p_end}
{p 4}Web: {browse "https://sites.google.com/site/yianniskaravias/":https://sites.google.com/site/yianniskaravias/}{p_end}

{p 4}Joakim Westerlund (Lund University){p_end}
{p 4}Email: {browse "mailto:joakim.westerlund@nek.lu.se":joakim.westerlund@nek.lu.se}{p_end}
{p 4}Web: {browse "https://sites.google.com/site/perjoakimwesterlund/":https://sites.google.com/site/perjoakimwesterlund/}{p_end}

{title:How to install}

{p 4 8}The latest versions can be obtained via {stata "net from https://github.com/JanDitzen/xtthreshold"}.{p_end}

{title:Notes}

{p 4 8}{cmd:xtthreshold} requires Stata version 15 or higher.{p_end}

{title:Changelog}
{p 4 4}This version 0.1 - 24.07.2025{p_end}