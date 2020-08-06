
function varargout = LambdaB_GUI(varargin)
% LAMBDAB_GUI MATLAB code for LambdaB_GUI.fig
%      LAMBDAB_GUI, by itself, creates a new LAMBDAB_GUI or raises the existing
%      singleton*.
%
%      H = LAMBDAB_GUI returns the handle to a new LAMBDAB_GUI or the handle to
%      the existing singleton*.
%
%      LAMBDAB_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAMBDAB_GUI.M with the given input arguments.
%
%      LAMBDAB_GUI('Property','Value',...) creates a new LAMBDAB_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LambdaB_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LambdaB_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LambdaB_GUI

% Last Modified by GUIDE v2.5 22-Apr-2019 21:28:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @LambdaB_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @LambdaB_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before LambdaB_GUI is made visible.
function LambdaB_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Initialize Save LambdaB parameters
load('C:\Users\Sabatini Lab\Documents\MATLAB\lambdaB_default_PARAMS.mat')
handles.PARAMS.GalvoAngles=PARAMS.GalvoAngles;
handles.PARAMS.MirrorAngles=PARAMS.MirrorAngles;
handles.PARAMS.AOMpower=PARAMS.AOMpower;
handles.PARAMS.PulseDuration=PARAMS.PulseDuration;
handles.PARAMS.RampDownDuration=0;
handles.PARAMS.RampDownDuration=PARAMS.RampDownDuration;

% [FileName,PathName] = uigetfile('*.mat');
% if (FileName)~=0
%     load(FileName);
%     handles.PARAMS=PARAMS;
% end
% Initiate session
handles.flag=0;
handles.Session.s2 = daq.createSession('ni');
handles.Session.s3 = daq.createSession('ni');
s3 = handles.Session.s3;
s3.Rate = 1000;
GalvoCh=addAnalogOutputChannel(handles.Session.s3,'Dev1',0,'Voltage');
ShutterCh=addAnalogOutputChannel(handles.Session.s3,'Dev1',3,'Voltage');
LaserCh=addAnalogOutputChannel(handles.Session.s3,'Dev1',2,'Voltage');

addAnalogInputChannel(s3,'Dev1','ai7','Voltage');
s2 = handles.Session.s2;
handles.Session.s2.Rate = 1000;
MirrorCh=addAnalogOutputChannel(handles.Session.s2,'Dev1',1,'Voltage');
handles.Session.GalvoRange=0:((2.4)/40):2.4;
handles.PARAMS.PowerValues = zeros(8,1);




set(handles.edit1,'string',handles.PARAMS.MirrorAngles(1));
set(handles.edit2,'string',handles.PARAMS.MirrorAngles(2));
set(handles.edit3,'string',handles.PARAMS.MirrorAngles(3));
set(handles.edit4,'string',handles.PARAMS.MirrorAngles(4));
set(handles.edit5,'string',handles.PARAMS.AOMpower(1));
set(handles.edit6,'string',handles.PARAMS.AOMpower(2));
set(handles.edit7,'string',handles.PARAMS.AOMpower(3));
set(handles.edit8,'string',handles.PARAMS.AOMpower(4));
set(handles.slider1,'Value',handles.PARAMS.MirrorAngles(1));
set(handles.slider2,'Value',handles.PARAMS.MirrorAngles(2));
set(handles.slider3,'Value',handles.PARAMS.MirrorAngles(3));
set(handles.slider4,'Value',handles.PARAMS.MirrorAngles(4));
set(handles.slider5,'Value',handles.PARAMS.AOMpower(1));
set(handles.slider6,'Value',handles.PARAMS.AOMpower(2));
set(handles.slider7,'Value',handles.PARAMS.AOMpower(3));
set(handles.slider8,'Value',handles.PARAMS.AOMpower(4));
set(handles.Galvo1,'string',handles.PARAMS.GalvoAngles(1));
set(handles.Galvo2,'string',handles.PARAMS.GalvoAngles(2));
set(handles.Galvo3,'string',handles.PARAMS.GalvoAngles(3));
set(handles.Galvo4,'string',handles.PARAMS.GalvoAngles(4));




% Choose default command line output for LambdaB_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LambdaB_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LambdaB_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in StartTaskButton.
function StartTaskButton_Callback(hObject, eventdata, handles)

handles.Session.s2.Rate = 1000;
handles.Session.s3.Rate = 1000;
addTriggerConnection( handles.Session.s3,'external','Dev1/PFI2','StartTrigger');
outputSingleScan( handles.Session.s3,[-2.4 0 0]);
StimDuration=handles.PARAMS.PulseDuration;
RampDownDuration=handles.PARAMS.RampDownDuration;
outputDataGalvo=[ones(StimDuration+RampDownDuration,1); zeros(1000-StimDuration-RampDownDuration,1)];
outputDataGalvo2=[zeros(StimDuration+RampDownDuration,1); -5+zeros(1000-StimDuration-RampDownDuration,1)];
outputDataShutter=[5*ones(StimDuration,1); 5*ones(RampDownDuration,1);0*ones(1000-StimDuration-RampDownDuration,1)];
outputDataShutter2=[5*ones(StimDuration+2,1); 5*ones(1000-StimDuration-2-1,1); 5];
outputDataShutter_Trains=[repmat([ones(5,1) ;zeros(5,1)],[10 1]);0*ones(1000-StimDuration,1)];


%outputSingleScan(handles.Session.s2,[ 0 0]);
[FileName,PathName] = uiputfile('*.mat');
cd(PathName);
handles.Session.s3.ExternalTriggerTimeout=360000;
log=[];
TS=[];
tic

outputSingleScan(handles.Session.s2,[  8 ]);
outputSingleScan(handles.Session.s3,[  -10 0 0]);
%% RED Laser Version
if (handles.REDLASER.Value==1)
    if (handles.PowerModulation.Value==1 && handles.checkbox1.Value==1)
        % Different Power AOM version for single depth
        for j=1:1000
            % handles.PARAMS.PowerValues
            nn=length(handles.PARAMS.PowerValues(handles.PARAMS.PowerValues~=0));
            %  nn
            for k=randperm(nn)
                i=str2double(handles.edit27.String);
                outputSingleScan(handles.Session.s2,[  handles.PARAMS.MirrorAngles(i)]);
                outputSingleScan(handles.Session.s3,[-10  5 0]);
                outputDataAOM=[handles.PARAMS.PowerValues(k)*ones(StimDuration,1);( handles.PARAMS.PowerValues(k)-handles.PARAMS.PowerValues(k)/RampDownDuration:-handles.PARAMS.PowerValues(k)/RampDownDuration:0)'; zeros(1000-StimDuration-RampDownDuration,1)];
                
                queueOutputData(handles.Session.s3,[handles.PARAMS.GalvoAngles(i)*outputDataGalvo+outputDataGalvo2  outputDataShutter2 outputDataAOM]);
                data=startForeground( handles.Session.s3);
                log=[log k];
                TS=[TS toc];
                disp([num2str(i) 'th Position ' num2str(k) 'th Power ' num2str(j) 'th rounds ' num2str(length(log)) ' nth stim' ]);
                PARAMS=handles.PARAMS;
                save(FileName,'PARAMS','log','TS');
                
                outputSingleScan(handles.Session.s2,[  8]);
                % outputSingleScan(handles.Session.s3,[  -10 0]);
            end
        end
    else
        % Single AOM value normal version
        for j=1:1000
            for i=randperm(4)
                if handles.checkbox1.Value==1
                    i=str2double(handles.edit27.String);
                end
                outputSingleScan(handles.Session.s2,[  handles.PARAMS.MirrorAngles(i) ]);
                outputSingleScan( handles.Session.s3,[-10   5 0]);
                % outputSingleScan( handles.Session.s3,[-5   0]);
                outputDataAOM=[ handles.PARAMS.AOMpower(i)*ones(StimDuration,1); (handles.PARAMS.AOMpower(i)-handles.PARAMS.AOMpower(i)/RampDownDuration:-handles.PARAMS.AOMpower(i)/RampDownDuration:0)'; zeros(1000-StimDuration-RampDownDuration,1)];
                
                pause(0.2);
                
                queueOutputData( handles.Session.s3,[handles.PARAMS.GalvoAngles(i)*outputDataGalvo+outputDataGalvo2  outputDataShutter2 outputDataAOM]);
                data=startForeground( handles.Session.s3);
                log=[log i];
                TS=[TS toc];
                disp([num2str(i) 'th Position ' num2str(j) 'th rounds ' num2str(length(log)) ' nth stim']);
                PARAMS=handles.PARAMS;
                save(FileName,'PARAMS','log','TS');
                % outputSingleScan(handles.Session.s2,[ 0 0])
                outputSingleScan(handles.Session.s2,[  8 ]);
                %   outputSingleScan(handles.Session.s3,[  -10 0]);
            end
        end
    end
    
else
    %% Blue Laser Version
    if (handles.PowerModulation.Value==1 && handles.checkbox1.Value==1)
        % Different Power AOM version for single depth
        for j=1:1000
            % handles.PARAMS.PowerValues
            nn=length(handles.PARAMS.PowerValues(handles.PARAMS.PowerValues~=0));
            %  nn
            for k=randperm(nn)
                i=str2double(handles.edit27.String);
                outputSingleScan(handles.Session.s2,[  handles.PARAMS.MirrorAngles(i)]);
                outputSingleScan(handles.Session.s3,[-10  5 0]);
                outputDataAOM=[outputDataShutter*0+1*handles.PARAMS.PowerValues(k)];
                queueOutputData(handles.Session.s3,[handles.PARAMS.GalvoAngles(i)*outputDataGalvo+outputDataGalvo2  outputDataShutter2 outputDataAOM]);
                data=startForeground( handles.Session.s3);
                log=[log k];
                TS=[TS toc];
                disp([num2str(i) 'th Position ' num2str(k) 'th Power ' num2str(j) 'th rounds ' num2str(length(log)) ' nth stim' ]);
                PARAMS=handles.PARAMS;
                save(FileName,'PARAMS','log','TS');
                
                outputSingleScan(handles.Session.s2,[  8 ]);
                % outputSingleScan(handles.Session.s3,[  -10 0]);
            end
        end
    else
        % Single AOM value normal version
        for j=1:1000
            for i=randperm(4)
                if handles.checkbox1.Value==1
                    i=str2double(handles.edit27.String);
                end
                outputSingleScan(handles.Session.s2,[  handles.PARAMS.MirrorAngles(i) ]);
                outputSingleScan( handles.Session.s3,[-10   5 0]);
                % outputSingleScan( handles.Session.s3,[-5   0]);
                pause(0.2)
                
                outputDataAOM=[outputDataShutter*0+1*handles.PARAMS.AOMpower(i)];
                %%%%% Inserted code
                %outputDataAOM=[outputDataShutter_Trains*handles.PARAMS.AOMpower(i)];
                %%%%%
                
                queueOutputData( handles.Session.s3,[handles.PARAMS.GalvoAngles(i)*outputDataGalvo+outputDataGalvo2  outputDataShutter2 outputDataAOM]);
                data=startForeground( handles.Session.s3);
                log=[log i];
                TS=[TS toc];
                disp([num2str(i) 'th Position ' num2str(j) 'th rounds ' num2str(length(log)) ' nth stim']);
                PARAMS=handles.PARAMS;
                save(FileName,'PARAMS','log','TS');
                % outputSingleScan(handles.Session.s2,[ 0 0])
                outputSingleScan(handles.Session.s2,[  8 ]);
                %   outputSingleScan(handles.Session.s3,[  -10 0]);
            end
        end
    end
end
% --- Executes on button press in EndTaskButton.
function EndTaskButton_Callback(hObject, eventdata, handles)
% hObject    handle to EndTaskButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit1_Callback(hObject, eventdata, handles)
set(handles.slider1,'Value',str2double(get(hObject,'String')));
handles.PARAMS.MirrorAngles(1)=str2double(get(hObject,'String'));
guidata(hObject,handles);
togglebutton1_Callback(handles.togglebutton1, eventdata, handles);

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slider1_Callback(hObject, eventdata, handles)
set(handles.edit1,'string',num2str(get(hObject,'Value')));
handles.PARAMS.MirrorAngles(1)=get(hObject,'Value');
guidata(hObject,handles);
togglebutton1_Callback(handles.togglebutton1, eventdata, handles);

function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit2_Callback(hObject, eventdata, handles)
set(handles.slider2,'Value',str2double(get(hObject,'String')));
handles.PARAMS.MirrorAngles(2)=str2double(get(hObject,'String'));
guidata(hObject,handles);
togglebutton3_Callback(handles.togglebutton3, eventdata, handles);

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
set(handles.slider3,'Value',str2double(get(hObject,'String')));
handles.PARAMS.MirrorAngles(3)=str2double(get(hObject,'String'));
togglebutton4_Callback(handles.togglebutton4, eventdata, handles);

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
set(handles.slider4,'Value',str2double(get(hObject,'String')));
handles.PARAMS.MirrorAngles(4)=str2double(get(hObject,'String'));
guidata(hObject,handles);
togglebutton5_Callback(handles.togglebutton5, eventdata, handles);

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slider2_Callback(hObject, eventdata, handles)
set(handles.edit2,'string',num2str(get(hObject,'Value')));
handles.PARAMS.MirrorAngles(2)=get(hObject,'Value');
guidata(hObject,handles);
togglebutton3_Callback(handles.togglebutton3, eventdata, handles);

function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider3_Callback(hObject, eventdata, handles)
set(handles.edit3,'string',num2str(get(hObject,'Value')));
handles.PARAMS.MirrorAngles(3)=get(hObject,'Value');
guidata(hObject,handles);
togglebutton4_Callback(handles.togglebutton4, eventdata, handles);

function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider4_Callback(hObject, eventdata, handles)
set(handles.edit4,'string',num2str(get(hObject,'Value')));
handles.PARAMS.MirrorAngles(4)=get(hObject,'Value');
guidata(hObject,handles);
togglebutton5_Callback(handles.togglebutton5, eventdata, handles);

function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit5_Callback(hObject, eventdata, handles)
set(handles.slider5,'Value',str2double(get(hObject,'String')));
handles.PARAMS.AOMpower(1)=str2double(get(hObject,'String'));
guidata(hObject,handles);
togglebutton1_Callback(handles.togglebutton1, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slider5_Callback(hObject, eventdata, handles)
set(handles.edit5,'string',num2str(get(hObject,'Value')));
handles.PARAMS.AOMpower(1)=get(hObject,'Value');
guidata(hObject,handles);
togglebutton1_Callback(handles.togglebutton1, eventdata, handles);

function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit6_Callback(hObject, eventdata, handles)
set(handles.slider6,'Value',str2double(get(hObject,'String')));
handles.PARAMS.AOMpower(2)=str2double(get(hObject,'String'));
guidata(hObject,handles);
togglebutton3_Callback(handles.togglebutton3, eventdata, handles);

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)
set(handles.slider7,'Value',str2double(get(hObject,'String')));
handles.PARAMS.AOMpower(3)=str2double(get(hObject,'String'));
guidata(hObject,handles);
togglebutton4_Callback(handles.togglebutton4, eventdata, handles);

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
set(handles.slider8,'Value',str2double(get(hObject,'String')));
handles.PARAMS.AOMpower(4)=str2double(get(hObject,'String'));
guidata(hObject,handles);
togglebutton5_Callback(handles.togglebutton5, eventdata, handles);

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slider6_Callback(hObject, eventdata, handles)

set(handles.edit6,'string',num2str(get(hObject,'Value')));
handles.PARAMS.AOMpower(2)=get(hObject,'Value');
guidata(hObject,handles);
togglebutton3_Callback(handles.togglebutton3, eventdata, handles);

function slider6_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider7_Callback(hObject, eventdata, handles)

set(handles.edit7,'string',num2str(get(hObject,'Value')));
handles.PARAMS.AOMpower(3)=get(hObject,'Value');
guidata(hObject,handles);
togglebutton4_Callback(handles.togglebutton4, eventdata, handles);


function slider7_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider8_Callback(hObject, eventdata, handles)
set(handles.edit8,'string',num2str(get(hObject,'Value')));
handles.PARAMS.AOMpower(4)=get(hObject,'Value');
guidata(hObject,handles);
togglebutton5_Callback(handles.togglebutton5, eventdata, handles);


function slider8_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function SaveParamsButton_Callback(hObject, eventdata, handles)
[FileName,PathName] = uiputfile('*.mat');
PARAMS=handles.PARAMS;
save([PathName '\' FileName],'PARAMS');



function LoadParamsButton_Callback(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
[FileName,PathName] = uigetfile('*.mat');
if (FileName)~=0
    load([PathName '\' FileName]);
    handles.PARAMS=PARAMS;
end
handles.edit1.String=num2str(handles.PARAMS.MirrorAngles(1));
handles.edit2.String=num2str(handles.PARAMS.MirrorAngles(2));
handles.edit3.String=num2str(handles.PARAMS.MirrorAngles(3));
handles.edit4.String=num2str(handles.PARAMS.MirrorAngles(4));
handles.edit5.String=num2str(handles.PARAMS.AOMpower(1));
handles.edit6.String=num2str(handles.PARAMS.AOMpower(2));
handles.edit7.String=num2str(handles.PARAMS.AOMpower(3));
handles.edit8.String=num2str(handles.PARAMS.AOMpower(4));
handles.slider1.Value=handles.PARAMS.MirrorAngles(1);
handles.slider2.Value=handles.PARAMS.MirrorAngles(2);
handles.slider3.Value=handles.PARAMS.MirrorAngles(3);
handles.slider4.Value=handles.PARAMS.MirrorAngles(4);
handles.slider5.Value=handles.PARAMS.AOMpower(1);
handles.slider6.Value=handles.PARAMS.AOMpower(2);
handles.slider7.Value=handles.PARAMS.AOMpower(3);
handles.slider8.Value=handles.PARAMS.AOMpower(4);
handles.PulseDuration.String=handles.PARAMS.PulseDuration;
handles.PowerValue1.String=num2str(handles.PARAMS.PowerValues(1));
handles.PowerValue2.String=num2str(handles.PARAMS.PowerValues(2));
handles.PowerValue3.String=num2str(handles.PARAMS.PowerValues(3));
handles.PowerValue4.String=num2str(handles.PARAMS.PowerValues(4));
handles.PowerValue5.String=num2str(handles.PARAMS.PowerValues(5));
handles.PowerValue6.String=num2str(handles.PARAMS.PowerValues(6));
handles.PowerValue7.String=num2str(handles.PARAMS.PowerValues(7));
handles.PowerValue8.String=num2str(handles.PARAMS.PowerValues(8));
% added code
handles.Galvo1.String=num2str(handles.PARAMS.GalvoAngles(1));
handles.Galvo2.String=num2str(handles.PARAMS.GalvoAngles(2));
handles.Galvo3.String=num2str(handles.PARAMS.GalvoAngles(3));
handles.Galvo4.String=num2str(handles.PARAMS.GalvoAngles(4));


guidata(hObject,handles);

function PulseDuration_Callback(hObject, eventdata, handles)
set(handles.PulseDuration,'string',num2str(get(hObject,'String')));
handles.PARAMS.PulseDuration=str2double(get(hObject,'String'));
guidata(hObject,handles);

function PulseDuration_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function togglebutton1_ButtonDownFcn(hObject, eventdata, handles)

function togglebutton3_ButtonDownFcn(hObject, eventdata, handles)




function Galvo1_Callback(hObject, eventdata, handles)
handles.PARAMS.GalvoAngles(1)=str2double(get(hObject,'String'));

guidata(hObject,handles);

function Galvo1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Galvo2_Callback(hObject, eventdata, handles)
handles.PARAMS.GalvoAngles(2)=str2double(get(hObject,'String'));
guidata(hObject,handles);
function Galvo2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Galvo3_Callback(hObject, eventdata, handles)
handles.PARAMS.GalvoAngles(3)=str2double(get(hObject,'String'));
guidata(hObject,handles);

function Galvo3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Galvo4_Callback(hObject, eventdata, handles)
handles.PARAMS.GalvoAngles(4)=str2double(get(hObject,'String'));
guidata(hObject,handles);

function Galvo4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function OffButton_Callback(hObject, eventdata, handles)
s2=handles.Session.s2;
s3=handles.Session.s3;
outputSingleScan(s2,[0]);
outputSingleScan(s3,[0 0 0]);

function togglebutton1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    s2=handles.Session.s2;
    s3=handles.Session.s3;
    outputSingleScan(s2,[ handles.PARAMS.MirrorAngles(1)  ]);
    outputSingleScan(s3,[handles.PARAMS.GalvoAngles(1) 5 handles.PARAMS.AOMpower(1)]);
end

function togglebutton3_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    s2=handles.Session.s2;
    s3=handles.Session.s3;
    outputSingleScan(s2,[ handles.PARAMS.MirrorAngles(2)  ]);
    outputSingleScan(s3,[handles.PARAMS.GalvoAngles(2) 5  handles.PARAMS.AOMpower(2)]);
end

function togglebutton4_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    s2=handles.Session.s2;
    s3=handles.Session.s3;
    outputSingleScan(s2,[ handles.PARAMS.MirrorAngles(3) ]);
    outputSingleScan(s3,[handles.PARAMS.GalvoAngles(3) 5 handles.PARAMS.AOMpower(3)]);
end

function togglebutton5_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    s2=handles.Session.s2;
    s3=handles.Session.s3;
    outputSingleScan(s2,[ handles.PARAMS.MirrorAngles(4)  ]);
    outputSingleScan(s3,[handles.PARAMS.GalvoAngles(4) 5 handles.PARAMS.AOMpower(4)]);
end


function Release_Callback(hObject, eventdata, handles)
stop(handles.Session.s2);release(handles.Session.s2);
stop(handles.Session.s3);release(handles.Session.s3);
removeConnection(handles.Session.s3,1);
removeConnection(handles.Session.s3,2);
removeConnection(handles.Session.s3,3);
guidata(hObject,handles);



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)



function edit27_Callback(hObject, eventdata, handles)

% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PowerModulation.
function PowerModulation_Callback(hObject, eventdata, handles)
% hObject    handle to PowerModulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PowerModulation

% --- Executes on button press in Power1.
function Power1_Callback(hObject, eventdata, handles)
Buttons_state=[handles.togglebutton1.Value handles.togglebutton3.Value handles.togglebutton4.Value handles.togglebutton5.Value];
AOM_Values=[handles.slider5.Value handles.slider6.Value handles.slider7.Value handles.slider8.Value];
handles.PowerValue1.String=num2str(AOM_Values(find(Buttons_state,1)));
handles.PARAMS.PowerValues(1,1)=AOM_Values(find(Buttons_state,1));
guidata(hObject,handles);

function Power2_Callback(hObject, eventdata, handles)
Buttons_state=[handles.togglebutton1.Value handles.togglebutton3.Value handles.togglebutton4.Value handles.togglebutton5.Value];
AOM_Values=[handles.slider5.Value handles.slider6.Value handles.slider7.Value handles.slider8.Value];
handles.PowerValue2.String=num2str(AOM_Values(find(Buttons_state,1)));
handles.PARAMS.PowerValues(2,1)=AOM_Values(find(Buttons_state,1));
guidata(hObject,handles);

function Power3_Callback(hObject, eventdata, handles)
Buttons_state=[handles.togglebutton1.Value handles.togglebutton3.Value handles.togglebutton4.Value handles.togglebutton5.Value];
AOM_Values=[handles.slider5.Value handles.slider6.Value handles.slider7.Value handles.slider8.Value];
handles.PowerValue3.String=num2str(AOM_Values(find(Buttons_state,1)));
handles.PARAMS.PowerValues(3,1)=AOM_Values(find(Buttons_state,1));
guidata(hObject,handles);


function Power4_Callback(hObject, eventdata, handles)
Buttons_state=[handles.togglebutton1.Value handles.togglebutton3.Value handles.togglebutton4.Value handles.togglebutton5.Value];
AOM_Values=[handles.slider5.Value handles.slider6.Value handles.slider7.Value handles.slider8.Value];
handles.PowerValue4.String=num2str(AOM_Values(find(Buttons_state,1)));
handles.PARAMS.PowerValues(4,1)=AOM_Values(find(Buttons_state,1));
guidata(hObject,handles);


function Power5_Callback(hObject, eventdata, handles)
Buttons_state=[handles.togglebutton1.Value handles.togglebutton3.Value handles.togglebutton4.Value handles.togglebutton5.Value];
AOM_Values=[handles.slider5.Value handles.slider6.Value handles.slider7.Value handles.slider8.Value];
handles.PowerValue5.String=num2str(AOM_Values(find(Buttons_state,1)));
handles.PARAMS.PowerValues(5,1)=AOM_Values(find(Buttons_state,1));
guidata(hObject,handles);


function Power6_Callback(hObject, eventdata, handles)
Buttons_state=[handles.togglebutton1.Value handles.togglebutton3.Value handles.togglebutton4.Value handles.togglebutton5.Value];
AOM_Values=[handles.slider5.Value handles.slider6.Value handles.slider7.Value handles.slider8.Value];
handles.PowerValue6.String=num2str(AOM_Values(find(Buttons_state,1)));
handles.PARAMS.PowerValues(6,1)=AOM_Values(find(Buttons_state,1));
guidata(hObject,handles);


function Power7_Callback(hObject, eventdata, handles)
Buttons_state=[handles.togglebutton1.Value handles.togglebutton3.Value handles.togglebutton4.Value handles.togglebutton5.Value];
AOM_Values=[handles.slider5.Value handles.slider6.Value handles.slider7.Value handles.slider8.Value];
handles.PowerValue7.String=num2str(AOM_Values(find(Buttons_state,1)));
handles.PARAMS.PowerValues(7,1)=AOM_Values(find(Buttons_state,1));
guidata(hObject,handles);


function Power8_Callback(hObject, eventdata, handles)
Buttons_state=[handles.togglebutton1.Value handles.togglebutton3.Value handles.togglebutton4.Value handles.togglebutton5.Value];
AOM_Values=[handles.slider5.Value handles.slider6.Value handles.slider7.Value handles.slider8.Value];
handles.PowerValue8.String=num2str(AOM_Values(find(Buttons_state,1)));
handles.PARAMS.PowerValues(8,1)=AOM_Values(find(Buttons_state,1));
guidata(hObject,handles);



function RampDownDuration_Callback(hObject, eventdata, handles)
% hObject    handle to RampDownDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RampDownDuration as text
%        str2double(get(hObject,'String')) returns contents of RampDownDuration as a double
set(handles.RampDownDuration,'string',num2str(get(hObject,'String')));
handles.PARAMS.RampDownDuration=str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function RampDownDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RampDownDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in REDLASER.
function REDLASER_Callback(hObject, eventdata, handles)
% hObject    handle to REDLASER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of REDLASER
