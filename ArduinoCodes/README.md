# Arduino Files

This folder contains 4 Arduino ino files.
**Task_for_Training** is the main code that is to be used for regular training.  
Other files are variant of **Task_for_Training** but with stimulation code added at the end.  
  
**Task_with_Tone_Stim**   
applies the stimulation after tone onset. Timing can be adjusted by changing the parameter *ISILaser*.

**Task_with_ITI_Stim**   
applies the stimulation during the ITI period. Timing can be adjusted by changing the parameter *ITIstimTime*.

**Task_with_ToneITI_Stim**   
applies the stimulation both during Tone and ITI. Frequency is adjusted so that stimulation is applied during tone/left trials 33% of the time, tone/right trials 33% of the time, and during ITI 33% of the time.  *ISILaser* and *ITIstimTime* can be adjusted to change timing.

**Task_for_Training** implements a IncorrectTrialRepeat procedure. Thus, if the mouse makes an incorrect lick, the same tone is played in the next trial. This is to ensure that the mouse learns to lick both side, and does not resort to a strategy of licking just a single spout and get 50% of all rewards.
However, other task DO NOT implement the IncorrectTrialRepeat procedure.
