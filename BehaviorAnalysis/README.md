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
**SingleSessionStats_1** is a custom written script to analyze the effect of stimulation. It can be used to analyze both stimulation during Tone and stimulation during ITI. Before you run the code, you have to change the parameter **LaserTimeRelativeToneOnset** according to the stimulation protocol you have used. This is the time of the laser relative to Tone onset, and will be 25ms for Tone stimulation trials, and -500 for ITI stimulation.  

Running the script will give out a prompt asking for the   
**>> Session File Name to be analyzed**   
along with all the filenames in the current directory displayed. You need to type in the exact name of the txt file to be analyzed.
Running the script will generate 8 figures.

### Tone stimulation (LaserTimeRelativeToneOnset>0)
The relevant figures to look at are Fig. 1, 2, 4 and 6.  
**Fig1:** Control first/subsequent lick latency (Histogram). Also displayed is the incorrect & miss percentage.  
**Fig2:** Stim first/sunsequent lick latency (Histogram). Also displayed is the incorrect & miss percentage. Analysis is repeated for each depth (rows).       
**Fig4:** Same plot as Fig. 2 but in lick raster rather than histogram.  
**Fig6:** Each dot represent a lick, and all trial type are sorted into Left vs Right, and by outcome, indicated by the color of the right most column.

### ITI stimulation (LaserTimeRelativeToneOnset<0)
The relevant figures to look at are Fig. 1, 2, 4 and 6.  
**Fig3:** Control first/subsequent lick latency (Histogram). Also displayed is the incorrect & miss percentage.  
**Fig5:** Stim first/sunsequent lick latency (Histogram). Also displayed is the incorrect & miss percentage. Analysis is repeated for each depth (rows).       
**Fig7:** Same plot as Fig. 2 but in lick raster rather than histogram.  
**Fig8:** Each dot represent a lick, and all trial type are sorted into Left vs Right, and by outcome, indicated by the color of the right most column.





