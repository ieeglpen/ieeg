function GenerateSound(freq)
% This program plays a sinusoid on the computer's audio system.
% The frequency of the sinusoid is specified by the user.

%freq=input('Specify Frequency in Hertz: '); %Obtain desired frequency in Hertz from the keyboard
rfreq=2*pi*freq;                            %Convert to radian frequency

Ts=[linspace(0,4,8192*4)];                  %Specify sample times over 4 seconds
                                            %Since the default sample rate is 8192 Hz
                                            %the four seconds (0 - 4) needs to be 
                                            %divided into 4*8192 pieces
signal=cos(rfreq*Ts);                       %Calculate the cosine at all sample times
soundsc(signal);                            %Play the sound