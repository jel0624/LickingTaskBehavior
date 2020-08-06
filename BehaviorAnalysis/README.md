# Analysis of Behavior
### Structure of txt file from Arduino
Arduino files ouput txt files that can be easily analyzed using various programming softwares.  
The txt file is organized as follows:

| Trial Number  | State        | EventName | EventTimeStamp | EventDuration |
| ------------- | ------------- | -- | -- | -- |
| 1  | 1  | LeftTrial | 1021 |50|
| 1  | 1  | RewardDelivery | 1025 |20|
| 1  | 1  | LickLeft | 1021 |20|
| 1  | 1  | LickLeft | 1181 |21|
| 2  | 1  | LeftTrial | 1221 |50|
| 2  | 1  | Incorrect | 1325 |0|
| 2  | 1  | LickLeft | 1421 |20|
| 2  | 1  | LickLeft | 1581 |21|

**Trial Numer:** This is the number of tones that have been played, thus the nth trial.  
**State:** This is the state in the Arduino code. Can be ignored.  
**Event Name:** This is the event name that is being recorded.  
**Event Time Stamp:** This is the time in ms in the Arduino clock, of when the event happened.  
**Event Duration:** This is the duration of the event. Might be zero if the event has no duration.  
  
Usually, most of the analysis can be performed by just reading **Eventname** and **EventTimeStamp**.

Sometimes, when stimulation was performed during the task, a separate matfile with variable named **'Log'** will be needed to analyze the data using the script provided. **'Log'** file is an array containing information about the depth that was stimulated (tapered fiber stimulation). If only one site was used, then this should be a trivial containing a single number, and length equal to the number of stimulation. A good sanity check that I performed is to compared the size of the **Log** file with the total number of stim trials shown in the Arduino txt files. If those two number disagree, the discrepancy must be resolved before carrying out further analysis. 

### MATLAB script for analysis
**SingleSessionStats_1** is a costum written script to analyze the effect of stimulation.

