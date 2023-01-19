clear,clc

%This section lays out the varibles that should be changed
Apogee = 4500; %ft
MainEjectHeight = 550; %ft
AirDensity = 0.00233546; %slug/ft^3 at 600 ft altitude


%This section is for rocket parameters
g = 32.2; %ft/s^2
NoseCone = 2.39/g; %slugs
PayloadTube = 3.37/g; %slugs
ForwardSwitchBand = 1.91/g; %slugs
DrogueTube = 1.44/g; %slugs
AvionicsBay = 4.42/g; %slugs
MainTube = 1.96/g; %slugs
AftSwitchBand = 1.71/g;
ForwardMotorTube = 1.46/g; %slugs
AftMotorTube = 3.14/g; %slugs
MotorWeightNoProp = (5.77 - 2.8)/g; %slugs

Section1 = NoseCone + PayloadTube + ForwardSwitchBand; %slugs
Section2 = DrogueTube + AvionicsBay + MainTube; %slugs
Section3 = ForwardMotorTube + AftMotorTube + AftSwitchBand + MotorWeightNoProp; %slugs

RocketWeightNoM = (Section1 + Section2 + Section3); %slugs

%This section creates matrices with drogue and main 
%parachute options
%Parachute data taken from fruitychutes
%Main parachutes = Iris Ultra Standard Parachutes
%DrogueParachute = Elliptical/Compact Elliptical Parachutes
Drogue = [12, 15, 18, 24]; %inches
DrogueCd = [1.6, 1.6, 1.6, 1.6];
Main = [36, 48, 60, 72, 84, 96, 120]; %inches
MainCd = [2.2, 2.2, 2.2, 2.2, 2.2, 2.2, 2.2];

%Making the matrices to keep track of the data
Parachutes = zeros(length(Main),length(Drogue)); 
VDrogue = zeros(length(Main),length(Drogue));
VMain = zeros(length(Main),length(Drogue));
KE1 = zeros(length(Main),length(Drogue));
KE2 = zeros(length(Main),length(Drogue));
KE3 = zeros(length(Main),length(Drogue));
KE1V = zeros(length(Main),length(Drogue));
KE2V = zeros(length(Main),length(Drogue));
KE3V = zeros(length(Main),length(Drogue));
DecentTime = zeros(length(Main),length(Drogue));
Drift0 = zeros(length(Main),length(Drogue));
Drift5 = zeros(length(Main),length(Drogue));
Drift10 = zeros(length(Main),length(Drogue));
Drift15 = zeros(length(Main),length(Drogue));
Drift20 = zeros(length(Main),length(Drogue));

%For loop to get data for all drogue and main configurations
for i = 1:length(Main)
    for j = 1:length(Drogue)
        Parachutes(i,j) = Drogue(j) + " " + Main(i);
        %Decent Velocities: Drogue & Main
        VDrogue(i,j) = sqrt((8* RocketWeightNoM * g)/(pi * AirDensity * DrogueCd(j) * (Drogue(j)/12) ^ 2));
        VMain(i,j) = sqrt((8* RocketWeightNoM * g)/(pi * AirDensity * MainCd(i) * (Main(i)/12) ^ 2));
        
        %Kinetic Energy Calculations
        KE1(i,j) = (.5) * (Section1) * (VMain(i,j) ^ 2); %lbf
        KE2(i,j) = (.5) * (Section2) * (VMain(i,j) ^ 2); %lbf %This is the important one
        KE3(i,j) = (.5) * (Section3) * (VMain(i,j) ^ 2); %lbf
        
        %Kinetic energy calculations for the drogue
        KE1V(i,j) = (.5) * (Section1) * (VDrogue(i,j) ^ 2); %lbf
        KE2V(i,j) = (.5) * (Section2) * (VDrogue(i,j) ^ 2); %lbf %This is the important one
        KE3V(i,j) = (.5) * (Section3) * (VDrogue(i,j) ^ 2); %lbf
        
        %Decent Time Calculations
        DecentTime(i,j) = ((Apogee - MainEjectHeight)/VDrogue(i,j)) + (MainEjectHeight/VMain(i,j)); %s
        
        %Drift Calculations
        Drift0(i,j) = (0) * (DecentTime(i,j)); %ft
        Drift5(i,j) = (7 + 1/3) * (DecentTime(i,j)); %ft
        Drift10(i,j) = (14 + 2/3) * (DecentTime(i,j)); %ft
        Drift15(i,j) = (22) * (DecentTime(i,j)); %ft
        Drift20(i,j) = (29 + 1/3) * (DecentTime(i,j)); %ft %This is the important one
    end
end

%Figure to show the drogue decent velocities
figure(1)
X1 = Drogue;
bar(X1, VDrogue(1,:));
title('Drogue Parachute Decent Velocities');
xlabel('Drogue Diameter (in)');
ylabel('Velocity (ft/s)');


%Figure to show the main decent velocities
figure(2)
X2 = Main;
bar(X2, VMain(:,1));
title('Main Parachute Decent Velocities');
xlabel('Main Diameter (in)');
ylabel('Velocity (ft/s)');

%Figure to show the ground hit kinetic energy for each main parachute
%Section 2
figure(3)
X3 = Main;
bar(X3, KE2(:,1));
title('Ground Hit Kinetic Energy of Section 2');
xlabel('Main Diameter (in)');
ylabel('Kinetic Energy (lbf)');

%Figure to show the ground hit kinetic energy for each main parachute
%Section 1
figure(9)
X3 = Main;
bar(X3, KE1(:,1));
title('Ground Hit Kinetic Energy of Section 1');
xlabel('Main Diameter (in)');
ylabel('Kinetic Energy (lbf)');

%Figure to show the ground hit kinetic energy for each main parachute
%Section 3
figure(10)
X3 = Main;
bar(X3, KE3(:,1));
title('Ground Hit Kinetic Energy of Section 3');
xlabel('Main Diameter (in)');
ylabel('Kinetic Energy (lbf)');

%Figure to show the ground hit kinetic energy for each drogue parachute for
%section 1
figure(6)
X3 = Drogue;
bar(X3, KE1V(1, :));
title('Ground Hit Kinetic Energy of Section 1 for Drogue');
xlabel('Drogue Diameter (in)');
ylabel('Kinetic Energy (lbf)');

%Figure to show the ground hit kinetic energy for each drogue parachute for
%section 2
figure(7)
X3 = Drogue;
bar(X3, KE2V(1, :));
title('Ground Hit Kinetic Energy of Section 2 for Drogue');
xlabel('Drogue Diameter (in)');
ylabel('Kinetic Energy (lbf)');

%Figure to show the ground hit kinetic energy for each drogue parachute for
%section 3
figure(8)
X3 = Drogue;
bar(X3, KE3V(1, :));
title('Ground Hit Kinetic Energy of Section 3 for Drogue');
xlabel('Drogue Diameter (in)');
ylabel('Kinetic Energy (lbf)');

%Figure to show the decent time for each drogue-main configuration
figure(4)
X4 = Main;
bar(X4, DecentTime);
legend('12','15','18','24');
title('Decent Time for Different Configurations');
xlabel('Parachute Configuration');
ylabel('Time (s)');

%Figure to show the drift for each drogue-main configuration
figure(5)
X5 = Main;
bar(X5, Drift20);
legend('12','15','18','24');
title('20 mi/hr Drift for Different Configurations');
xlabel('Parachute Configuration');
ylabel('Drift (ft)');

%Prints out all of the drogue-main configurations that meet the NASA
%handbook requirements
disp('NASA Handbook Successful Parachute Configurations');
for i = 1:length(Main)
    for j = 1:length(Drogue)
        if(KE2(i,j) < 75 && DecentTime(i,j) < 90 && Drift20(i,j) < 2500)
            fprintf('Drogue Parachute %d in and Main Parachute %d in\n', Drogue(j), Main(i));
        end
    end
end

%Prints out all of the drogue-main parachute configurations that meet both
%the NASA handbook requirements and CyLaunch's requirements 
%These are the configurations that should be used
fprintf('\n');
disp('CyLaunch Successful Parachute Configurations');
for i = 1:length(Main)
    for j = 1:length(Drogue)
        if(KE2(i,j) < 75 && DecentTime(i,j) < 90 && Drift20(i,j) < 2500 && VDrogue(i,j) < 100 && VMain(i,j) < 15)
            fprintf('Drogue Parachute %d in and Main Parachute %d in\n', Drogue(j), Main(i));
        end
    end
end



%Drift0(5,3)
%Drift5(5,3)
%Drift10(5,3)
%Drift15(5,3)
%Drift20(5,3)














