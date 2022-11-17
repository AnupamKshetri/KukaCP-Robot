% Robotic-Lab RWU Prof. Dr.-Ing. K. Wöllhaf
% ballSort2.m Version 12.05.2020
% Example script to simulate the ball sorting
%% List of predefined positions
kukaHome=deg2rad([0;-90;90;0;0;0]); % sets the home position
oFP=[992.26176 1018.5852 225.71452 -2.3431045 -0.01134464 3.1415927];
uFP=[1014.6146 1005.7988 60.639322 -2.3605578 -0.01134464 3.1415927];
uW1P=[1191.6107 624.58005 169.59211 -2.6476645 -0.01134464 3.1415927];
oW1P=[1192.3698 624.98879 245.58722 -2.6476645 -0.01134464 3.1415927];
oW2P=[1225.7918 714.86067 267.76213 -2.6136306 -0.01134464 3.1415927];
uW2P=[1232.3783 701.33735 168.76851 -2.6136306 -0.01134464 3.1415927];
pos1=[1100 100 100 -0.1 pi 0]; % Position of palett 1
pos2=[1100 -400 100 -0.2 pi 0];% Position of palett 2
pos3=[800 -900 100 -0.3 pi 0]; % Position of palett 3
setPaths();
kuka=kukaCP;
kuka.showFrameVrml('oF',Kuka2T(oFP)); % Feeder up
kuka.showFrameVrml('uF',Kuka2T(uFP)); % Feeder down
kuka.showFrameVrml('uW1',Kuka2T(uW1P));% Scale 1 down
kuka.showFrameVrml('oW1',Kuka2T(oW1P));% % Scale 2 up
kuka.showFrameVrml('uW2',Kuka2T(uW2P));% Scale 2 down
kuka.showFrameVrml('oW2',Kuka2T(oW2P));% Scale 2 up
kuka.showFrameVrml('pal1',Kuka2T(pos1)); % Palette 1
kuka.showFrameVrml('pal2',Kuka2T(pos2)); % Palette 2
kuka.showFrameVrml('pal3',Kuka2T(pos3)); % Palette 3
% Transform to the Kuka-like structures 
oF=toKuka(oFP);
uF=toKuka(uFP); 
uW1=toKuka(uW1P); 
oW1=toKuka(oW1P); 
oW2=toKuka(oW2P); 
uW2=toKuka(uW2P); 
countPal1=1; % counter needed for the palett function 
countPal2=1; 
countPal3=1;
pause(1);
%% start of the program
kuka.setToolData(6,'gripper',0,0,50,deg2rad(0),deg2rad(0),deg2rad(0)); % set tool data 1
kuka.showToolObject(1); % show the gripper 
kuka.setActTool(6); % set actual tool
kuka.setActBase(0); % set base (here NULLFRAME world is used)
%%start of the Main loop 
while countPal3<=12 && countPal2 <=12 && countPal1 <= 12
kuka.simulateNewBall(2); % creates new ball 1. 1,2,3 are possible values 
kuka.simulateNewBall(randi([1 3])); % create balls using random-numbers
 % Start the movements 
kuka.ptpAx(kukaHome); % move to home 
kuka.openGripper(); % opens the gripper 
kuka.ptp(oF); % move ptp to uper feeder position1 
kuka.lin(uF); % move down 
kuka.closeGripper(); % close the gripper
pause(1); % stop simulation for 1 seconds 
kuka.lin(oF); % move up 
kuka.lin(oW1); % move scale 1upper position 
kuka.lin(uW1);
kuka.openGripper(); % opens the gripper 
value1 = kuka.signalScale1();%reading the scale 
kuka.closeGripper(); % close the gripper 
kuka.lin(oW1); 
if value1 == false 
countPal1=palette(pos1,1,countPal1);  
else
kuka.lin(oW2); 
kuka.lin(uW2);
kuka.openGripper(); % opens the gripper 
value2 = kuka.signalScale2();%reading the scale 
kuka.closeGripper(); % close the gripper 
kuka.lin(oW2); % move scale 2 upper position 

if value2 == false 
countPal2 = palette(pos2,2,countPal2); % palettize function, 
else
 countPal3 = palette(pos3,3,countPal3); 
end
end
 
 % palettize function, 
 % pos1 the positon, 1 means which palette, counter is needed to compute the position 
 % and check if the palette is full!
 % move to home
 
 % Some commands you may need
 
 %%end of the main loop 
 % closes the kuka App
 for i=1:5 % for-loop
 % 
 fprintf('array[%d]=%g\n',i,pi*i); % C-like fprintf-function 
 end
end
kuka.ptpAx(kukaHome); 
pause(1);
