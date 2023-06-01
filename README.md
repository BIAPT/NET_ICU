# NET_ICU Pipeline
**Python below**

This repository is for the EEG-based graph theory analysis of the NET_ICU study. The code found here is a work-in progress and not a final implementation.

Requirement to use the pipeline:

- MATLAB version: R2020a or more recent version
- Neuroalgo MATLAB functions
- Signal Processing Toolbox
- Symbolic Math Toolbox
- Statistics and Machine Learning Toolbox

Current features are already available

- **Functional connectivity (wPLI) ** : Time-averaged functional connectivity for the different experimental phases
- **Functional connectivity (dPLI) ** : Time-averaged functional connectivity for the different experimental phases
- **Hub ** : Time-averaged functional connectivity for the different experimental phases


- ** Spectrogram : Average frequency of all electrodes
- ** Topographic map : Topographic map of frequency power from 4 to 13 Hz


# SETUP for Python version

1) clone this Repo
 `git clonse https://github.com/BIAPT/TACS_Baseline_Analysis.git`

2) clone other required repos in utils folder
  `git clone https://github.com/BIAPT/Python_Connectivity.git utils/Python_Connectivity`

3) install requirements.txt `pip install -r requirements.txt`
    **This step is extremely important, as this code only works fine with MNE=1.1.1**

4) Analysis runs independently with the `NET_ICU_Python_Notebook.npy`

- Saves results and figures automatically

....
