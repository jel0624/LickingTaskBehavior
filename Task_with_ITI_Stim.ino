// This is a task adapted from Dan Hochbaum timing task.
// Mice are requred to withold licking for a fixed interval
// First tone arrives that signals the availability of a reward in the future
// Second tone signals that they can lick for reward
// Any licks in between resets the trial and the first tone is given again after a timeout period

#define Idle 0
#define ISI_State 1
#define FirstCueOn 2
#define FirstCueOff 3
#define SecondCueOn 4
#define SolenoidOn 5
#define SolenoidOff 6
#define TurnOffLickStatus 7
#define RestartClock 8
#define TimeOut 9
#define Idle2 10
#include <math.h>


//// Important Parameters for the task that can be changed ////

unsigned long RewardSizeLeft = 25;
unsigned long RewardSizeRight = 0;
unsigned long ITI1 = 2000;
unsigned long ITI2 = 2000;
unsigned long ReactionTime = 500;
int RightProb = -102;
int RightProb2 = -102;

int LaserStimProb =25;
unsigned long ISIlaser = 25;//Time of stim in (ms) before cue
unsigned long TimeOutDuration = 1;
unsigned long ITIstimTime = 500;

// ITI is defined as ITI1+random(ITI2) meaning that ITI1 is the minium duration, and ITI1+ITI2 is the maximum,
// True ITI is taken randomly from a uniform distribution between ITI1 and ITI1+ITI2
unsigned long ISI = 0;

// same applies for
unsigned long waitTime = 1;
unsigned long waitTime1 = 2000;
unsigned long waitTime2 = 1300;

unsigned long FirstToneDuration = 50;
unsigned long SecondToneDuration = 1;

//// ----------- ////
unsigned long RewardSize = 20;
volatile bool ISI_State_tag = 0;
volatile bool RewardState_tag = 0;
volatile bool NorewardState_tag = 0;
static int state = 0 ;
unsigned long LastLick = 0;
const byte Speaker = 47;
const byte LickDetect1 = 19;
const byte LickDetect2 = 18;
const byte WaterSpout = 9;
const byte WaterSpout2 = 8;
const byte Button = 53;
const byte Button2 = 12;
const byte Button1 = 11;
const byte CameraTrigger = 21;
bool ButtonState = 0;
int LaserStim = 0;
int LickStatus = 0;
int LickStatus2 = 0;
int LaserTrial = 0;
int LaserTrialType = 1;
unsigned long LaserTime = 0;
int ButtonStatus1 = 0;
int ButtonStatus2 = 0;
unsigned long DummyButton1 = 0;
unsigned long DummyButton2 = 0;
unsigned long DummyButton3 = 1;
int TrialType = 0; //0=LEFT, 1=RIGHT
int incorrectStatus = 0;
unsigned long Lick_Start = 0;
unsigned long LastTrialEnd = 0;
unsigned long Dummy1 = 0;
unsigned long Dummy2 = 0;
unsigned long Dummy3 = 0;
unsigned long Dummy4 = 0;
unsigned long Dummy5 = 0;
unsigned long Dummy6 = 0;
unsigned long Dummy7 = 0;
unsigned long Dummy9 = 0;
unsigned long Dummy10 = 0;
unsigned long D1 = 0;
unsigned long D2 = 0;
unsigned long D3 = 0;
unsigned long Lick_Duration;
unsigned long On;
unsigned long Start = 0;
unsigned long Now = 0;
unsigned long ISI_start;
int TrialNum = 0;
int RewardNum = 0;

void setup()
{
  Serial.begin(115200);
  pinMode(WaterSpout, OUTPUT);
  pinMode(WaterSpout2, OUTPUT);
  pinMode(LickDetect1, INPUT);
  pinMode(LickDetect2, INPUT);
  pinMode(Button2, INPUT);
  pinMode(Button1, INPUT);
  pinMode(Button, INPUT);
  pinMode(Speaker, OUTPUT);
  digitalWrite(WaterSpout, LOW);
  digitalWrite(WaterSpout2, LOW);
  pinMode(Speaker, OUTPUT);
  //  attachInterrupt(digitalPinToInterrupt(LickDetect2), LICK_OFF, RISING);
  //  attachInterrupt(digitalPinToInterrupt(LickDetect1), LICK_ON, FALLING);
  // attachInterrupt(digitalPinToInterrupt(Button2), DeliverReward, RISING);
  pinMode(51, OUTPUT);
  pinMode(30, OUTPUT);
  pinMode(21, OUTPUT);
  Start = millis();
  state = 0;
  pinMode(4, INPUT);
  randomSeed(analogRead(4));
}

void loop()
{
  switch (state)
  {
    //1////////////////// Determine the intertrial interval
    case ISI_State:
      digitalWrite(WaterSpout, LOW);
      digitalWrite(WaterSpout2, LOW);
      noTone(Speaker);
      Dummy1 = millis();
      state = 2;
      ISI = ITI1 + random(ITI2);
      TrialNum = TrialNum + 1;
      Serial.print(TrialNum);
      Serial.print("\t");
      Serial.print(state);
      Serial.print("\t");
      Serial.print("ITI");
      Serial.print("\t");
      Serial.print(Dummy2);
      Serial.print("\t");
      Serial.println(ISI);
      LaserStim = 0;
      LaserTrialType = random(1,3);
      LaserTrialType = 1;
      break;
    //2//////////////////
    case FirstCueOn:

      Dummy2 = millis();
      {
        if ((Dummy2 - Dummy1) > ISI  )
        {


          if (random(101) > RightProb)
          {
            tone(Speaker, 3000);
            Dummy2 = millis();
            state = 3;
            Serial.print(TrialNum);
            Serial.print("\t");
            Serial.print(state);
            Serial.print("\t");
            Serial.print("LEFTTrial");
            Serial.print("\t");
            Serial.print(Dummy2);
            Serial.print("\t");
            Serial.println(FirstToneDuration);
            TrialType = 0;
          }
          else
          {
            tone(Speaker, 12000);
            Dummy2 = millis();
            state = 3;
            Serial.print(TrialNum);
            Serial.print("\t");
            Serial.print(state);
            Serial.print("\t");
            Serial.print("RIGHTTrial");
            Serial.print("\t");
            Serial.print(Dummy2);
            Serial.print("\t");
            Serial.println(FirstToneDuration);
            TrialType = 1;
          }
        }
        if  ((LickStatus == 1) || (LickStatus2 == 1) )
        {
          Dummy1 = millis();
        }
      }
      break;
    //3//////////////////
    case FirstCueOff:
      Dummy3 = millis();
      if ((Dummy3 - Dummy2) > FirstToneDuration  )
      {
        noTone(Speaker);
        state = 5;
        waitTime = waitTime1 + random(waitTime2);
      }
      if  ((LickStatus == 1) || (LickStatus2 == 1) )
      {
        noTone(Speaker);
        state = 1;
      }
      break;
    //4//////////////////
    //5//////////////////
    case SolenoidOn:
      Dummy6 = millis();
      if  (LickStatus == 1 && TrialType == 0)
      {
        digitalWrite(WaterSpout, HIGH);
        On = millis();
        state = 6;
        RightProb = RightProb2;
      }
      else if (LickStatus2 == 1 && TrialType == 1)
      {
        digitalWrite(WaterSpout2, HIGH);
        On = millis();
        state = 6;
        RightProb = RightProb2;
      }
      else
      {
        if ((Dummy6 - Dummy3) > ReactionTime)
        {
          //Time ouT
          state = 9;
          Serial.print(TrialNum);
          Serial.print("\t");
          Serial.print(state);
          Serial.print("\t");
          Serial.print("MissTrial");
          Serial.print("\t");
          Serial.print(Dummy6);
          Serial.print("\t");
          Serial.println(0);
          //RightProb = TrialType * 101;
        }
      }
      if ( (LickStatus2 == 1 && TrialType == 0) || (LickStatus == 1 && TrialType == 1))
      {
        // Wrong lick direction
        state = 1;
        Serial.print(TrialNum);
        Serial.print("\t");
        Serial.print(state);
        Serial.print("\t");
        Serial.print("IncorretLick");
        Serial.print("\t");
        Serial.print(Dummy6);
        Serial.print("\t");
        Serial.println(0);
        //RightProb = TrialType * 101;
      }
      else
      {
        //RightProb=RightProb2;
      }
      break;
    //6//////////////////
    case SolenoidOff:
      Dummy7 = millis();
      if (TrialType==0)
      {
        RewardSize=RewardSizeLeft;
      }
      else
      {
        RewardSize=RewardSizeRight;
      }
      if ((Dummy7 - Dummy6) > RewardSize)
      {
        RewardNum = RewardNum + 1;
        digitalWrite(WaterSpout, LOW);
        digitalWrite(WaterSpout2, LOW);
        digitalWrite(WaterSpout, LOW);
        digitalWrite(WaterSpout2, LOW);
        state = 1;
        Serial.print(RewardNum);
        Serial.print("\t");
        Serial.print(state);
        Serial.print("\t");
        Serial.print("RewardDelivery");
        Serial.print("\t");
        Serial.print(On);
        Serial.print("\t");
        Serial.println(RewardSize);
      }

      break;
    //0//////////////////
    case Idle:
      if (digitalRead(Button) == 1)
      {
        digitalWrite(CameraTrigger, LOW);
        Start = millis();
        digitalWrite(30, LOW);

        Serial.print("TASK STARTED AT ");
        Serial.print("\t");
        Serial.println(millis());
        digitalWrite(30, HIGH);
        digitalWrite(30, LOW);
        state = 1;
        DummyButton3 = 0;
      }
      break;
    ////////////////////

    // 9 /////////////////////
    case TimeOut:
      Dummy9 = millis();
      {
        if ((Dummy9 - Dummy6) > TimeOutDuration)
        {
          state = 1;
        }

      }
      break;
    // 10 /////////////////
    case Idle2:
      state = 0;
      break;
    default:
      state = 1;
      digitalWrite(CameraTrigger, LOW);
      break;
  }
  // END OF SWITCH STRCUTURE //

  // Lick Detection //
  // LEFT
  if (digitalRead(LickDetect1) == 0)
  {
    if (LickStatus == 0)
    {
      LickStatus = 1;
      Lick_Start = millis();
    }
  }
  if (digitalRead(LickDetect1) == 1)
  {
    if (LickStatus == 1)
    {
      LickStatus = 0;
      Serial.print(TrialNum);
      Serial.print("\t");
      Serial.print(state);
      Serial.print("\t");
      Serial.print("LickLeft");
      Serial.print("\t");
      Serial.print(Lick_Start);
      Serial.print("\t");
      Lick_Duration = millis() - Lick_Start;
      Serial.println(Lick_Duration);
      LastLick = millis();

    }
  }
  // RIGHT
  if (digitalRead(LickDetect2) == 0)
  {
    if (LickStatus2 == 0)
    {
      LickStatus2 = 1;
      Lick_Start = millis();
    }
  }
  if (digitalRead(LickDetect2) == 1)
  {
    if (LickStatus2 == 1)
    {
      LickStatus2 = 0;
      Serial.print(TrialNum);
      Serial.print("\t");
      Serial.print(state);
      Serial.print("\t");
      Serial.print("LickRight");
      Serial.print("\t");
      Serial.print(Lick_Start);
      Serial.print("\t");
      Lick_Duration = millis() - Lick_Start;
      Serial.println(Lick_Duration);
      LastLick = millis();

    }
  }
  // Lick Detection END //

  // Camera External Trigger //
  Now = millis();
  if (state != 0)
  {
    if ( ((Now - Start) % 20) == 0 || ((Now - Start) % 20) == 1 )
    {
      digitalWrite(CameraTrigger, HIGH);
    }
    else
    {
      digitalWrite(CameraTrigger, LOW);
    }
  }
  // Camera External Trigger END //

  if (digitalRead(Button) == 0)
  {
    if (DummyButton3 == 0)
    {
      DummyButton3 = 1;
     
 
      Serial.print("TASK ENDED AT ");
      Serial.print("\t");
      Serial.println(millis());
      digitalWrite(30, HIGH);
      digitalWrite(30, LOW);
      state = 0;
      noTone(Speaker);
    }
  }

  // Left SideButtonsForRewards
  if (digitalRead(Button1) == 1 && ButtonStatus1 == 0)
  {
    ButtonStatus1 = 1;
    digitalWrite(WaterSpout, HIGH);
    DummyButton1 = millis();
  }
  if ((millis() - DummyButton1) > 10 && ButtonStatus1 == 1 )
  {
    digitalWrite(WaterSpout, LOW);
  }
  if ( ButtonStatus1 == 1 && digitalRead(Button1) == 0 )
  {
    ButtonStatus1 = 0;
  }
  // // Left SideButtonsForRewards END
  // RIGHT SideButtonsForRewards
  if (digitalRead(Button2) == 1 && ButtonStatus2 == 0)
  {
    ButtonStatus2 = 1;
    digitalWrite(WaterSpout2, HIGH);
    DummyButton2 = millis();
  }
  if ((millis() - DummyButton2) > 10 && ButtonStatus2 == 1 )
  {
    digitalWrite(WaterSpout2, LOW);
  }
  if ( ButtonStatus2 == 1 && digitalRead(Button2) == 0 )
  {
    ButtonStatus2 = 0;
  }
  // OPTOGENETICS //
  if (LaserTrialType==1)
  {
    D1=(Dummy2 - Dummy1);
    D2=(ISI-ITIstimTime);
    D3=2;
  }
  if (LaserTrialType==2)
  {
    D1=(Dummy2 - Dummy1);
    D2=(ISI-1);
    D3=2;
  }
  if (LaserTrialType==3)
  {
     D1=(Dummy2 - Dummy1);
    D2=(ISI-500);
    D3=2;
  }
  if (LaserTrialType==4)
  {
    D1=(Dummy2 - Dummy1);
    D2=(ISI-500);
    D3=2;
  }
  
  if (   (D1 > D2) && (state == D3) && (LaserStim == 0) && (D1 < 10000) )
  {
    LaserStim = 1;
    if (random(100) < LaserStimProb)
    {
      //Laser Stim
      LaserTrial = LaserTrial + 1;
      LaserTime = millis();
      Serial.print(LaserTrial);
      Serial.print("\t");
      Serial.print(0);
      Serial.print("\t");
      Serial.print("Laser_Stim_");
      Serial.print(LaserTrialType);
      Serial.print("\t");
      Serial.print(LaserTime);
      Serial.print("\t");
      Serial.println(0);
      digitalWrite(51, LOW);
      digitalWrite(51, HIGH);
      digitalWrite(51, LOW);
    }
    else
    {
      LaserTime = millis();
      Serial.print(0);
      Serial.print("\t");
      Serial.print(0);
      Serial.print("\t");
      Serial.print("NoStim");
      Serial.print("\t");
      Serial.print(LaserTime);
      Serial.print("\t");
      Serial.println(0);
    }
  }
  // OPTOGENETICS END //

  //if ( ((Now - Start) % 100) == 0 || ((Now - Start) % 100) == 1 )
  // {Serial.println(state);}
}
