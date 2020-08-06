# LickingTaskBehavior
This is a repository for the Arduino based lateralized licking task. We adapted a headfixed lateralized licking task, inspired from [*Guo, et al (2013)*](https://www.cell.com/neuron/fulltext/S0896-6273(13)00924-0?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS0896627313009240%3Fshowall%3Dtrue). We use auditory tones instead of pole position, and we do not implement a delay period so mice can lick as soon as they hear the tones.
Here is a simple schematic of the task (adapted from *Lee, et al, 2020*):


<img src = "https://github.com/jel0624/LickingTaskBehavior/blob/master/images/TaskStructure.png" width="350" algin="center" />. 

The mouse is trained to withold licking for 2-4 seconds (Inter-trial-interval). Tone comes in (3kHz or 12kHz) indicating which spout is the correct spout. After contact with the spout, solenoid immediately release water rewards on the relevant spout. The task then goes back into the ITI period. ITI length is chosed randomly from 2-4 sec (adjutable) and the clock is reset everytime the mouse licks. If the mouse doesn't lick after a certain time window after the cue (500ms, adjustable), the mouse is punished with a timeout period (6 sec, adjustable). The task also plays the same tone after an incorrect lick to ensure mouse does not lick to just one spout during training (this part can be removed after training).

Adjutable parameters (via Arduino):
- Reward size
- ITI length
- Timeout length
- Reaction window
- Tone Frequency
- Incorrect trial repeat (yes or no)

The code also allows to send digital On/Off signals to trigger Auxilary output (e.g. Laser Stimulation/Camera Trigger)





