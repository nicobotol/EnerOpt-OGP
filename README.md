# EnerOpt-OGP
Energy System Optimizer for Oil and Gas Platforms

<p align="center">
  <img src="manual/figure/graphical_abstract_simplified.png" alt="Figure description" width="600"/>
</p>

## Functionality description
The repository contains the Matlab code for cost-optimal sizing an isolated power system, with particular focus on a Oil and Gas application. \
The required inputs are: 
- Historical time series of renewables in the deployment location
- Historical time series of load of an akin installation
- Technical parameters of the renewable/non renewable generators and energy storages systems
- Economical costs of installing and operating the desired assets

The generated outputs are the size of the assets minimizing the installation and operation costs during plant's operative life

## Code usage
The main file of the project is `main_decarbonization.m` \
A early-stage user's manual is available in `manual\manual.pdf`

## Contact information
Please report any bug or suggestions to: niccolo.andreetta@ntnu.no

## Citations
Cite this work as:\
[![DOI](https://zenodo.org/badge/1036283281.svg)](https://doi.org/10.5281/zenodo.17081291)

## Credits
`DataX.m` was originally developed by [spixap/BESS-SIZING](https://github.com/spixap/BESS-SIZING) - [MIT](https://github.com/spixap/BESS-SIZING/blob/main/LICENSE)
