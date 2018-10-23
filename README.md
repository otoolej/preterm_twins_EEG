EEG Concordance in Preterm Twins
================================

Code for manuscript:

`Lloyd RO, O'Toole JM, Livingstone V, Filan PM, Boylan GB, Mathematical analysis of EEG
concordance in perterm twins, 2018, under review`


Please cite the above reference if using this code to generate new results. 


All code developed in _R_ (version 3.4.4, [The R Foundation of Statistical
Computing](http://www.r-project.org)).
EEG features calculated using the NEURAL (version 0.3.3,
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1052811.svg)](https://doi.org/10.5281/zenodo.1052811),
also available [on github](https://github.com/otoolej/qEEG_feature_set)) with burst
detector (version 0.1.2,
[![DOI](https://zenodo.org/badge/42042482.svg)](https://zenodo.org/badge/latestdoi/42042482),
also available [on github](https://github.com/otoolej/burst_detector)). See
[references](#references) [1,2] for more details on these.


__*NB: feature set (as .csv file) will be included after publication.*__


## Required packages
Mixed-effects models use the `lme4` package (v1.1.15); also `plyr` (v1.8.4) is required
somewhere. 

If not installed, then 

``` R
install.packages('lme4')
install.packages('plyr')
```

## Load the functions

``` R
# load the functions:
source('gen_all_ICC.R')
source('gen_all_ICC_thresholds.R')
source('compare_ICCs_with_thresholds.R')
```

## Intra-class Correlations (ICC)

Generate ICCs using linear mixed-effects models for all EEG
features at all time points, including and not including gestational age, and for the 4
data sets (all twins, MCDA twins, DCDA twins, and singletons):
``` R
gen_all_ICC()
```
This write the ICCs to .csv files (see `set_paths.R` for location).

Then generate the lower-limit threshold for the ICCs, again for all features, at all
time-points, including/not-including gestational age, and for the 4 data sets:
``` R
gen_all_ICC_thresholds("twins")
gen_all_ICC_thresholds("mcda")
gen_all_ICC_thresholds("dcda")
gen_all_ICC_thresholds("singletons")
```
WARNING: this can be slow (e.g. a couple of hours or more). Writes the ICC-thresholds to
.csv files (see `set_paths.R` for location).


Next (optional), to test if the ICCs are significant or not, then compare to the generated
threshold. To do so, load the the data from the .csv files and compare (which writes to
another .csv file):
``` R
compare_ICCs_with_thresholds("twins")
compare_ICCs_with_thresholds("mcda")
compare_ICCs_with_thresholds("dcda")
compare_ICCs_with_thresholds("singletons")
```


## Parameters for the NEURAL toolbox
Parameter values of the [NEURAL](https://github.com/otoolej/qEEG_feature_set) toolbox used
to the generate the qEEG features are listed in the file
[neural_parameters_TWINS.m](neural_parameters_TWINS.m).

# Licence

```
Copyright (c) 2018, John M. O' Toole, University College Cork
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

  Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or
  other materials provided with the distribution.

  Neither the name of the University College Cork nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

# References

1. JM O’Toole and GB Boylan (2017). NEURAL: quantitative features for newborn EEG using
   Matlab. ArXiv e-prints, arXiv:[1704.05694](https://arxiv.org/abs/1704.05694).

2. JM O' Toole, GB Boylan, RO Lloyd, RM Goulding, S Vanhatalo, and NJ Stevenson,
   Detecting Bursts in the EEG of Very and Extremely Premature Infants Using a
   Multi-Feature Approach, Medical Engineering & Physics, vol. 45, pp. 42-50, 2017.
   [doi:10.1016/j.medengphy.2017.04.003](https://doi.org/10.1016/j.medengphy.2017.04.003)

# Contact

John M. O' Toole

Neonatal Brain Research Group,  
INFANT: Irish Centre for Fetal and Neonatal Translational Research,  
Department of Paediatrics and Child Health,  
Room 2.19 UCC Paediatric Academic Unit, Cork University Hospital,  
University College Cork,  
Ireland

- email: j.otoole AT ieee.org

