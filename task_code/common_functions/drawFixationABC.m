function [display] = drawFixationABC(display, color)

width = 52; %39;  % horizontal dimension of display (cm)
dist = 90; %60;% viewing distance (cm)

colorOval = [255 255 255];% color of the two circles [R G B] [0, 0, 0]
colorCross = [118 118 118];% color of the Cross [R G B] [255, 255, 255]


d1 = 0.6;% diameter of outer circle (degrees) %0.6???
d2 = 0.2;% diameter of inner circle (degrees)

% screen = 0;
[cx, cy] = RectCenter(display.rect);
ppd = pi*(display.rect(3)-display.rect(1)) / atan(width/ dist/2) /360; % pixel per degree
% HideCursor;

% WaitSecs(2);
Screen('FillOval', display.h, colorOval, [cx-d1/2*ppd, cy-d1/2*ppd, cx+d1/2*ppd, cy+d1/2*ppd], d1*ppd);
Screen('DrawLine', display.h, colorCross, cx-d1/2*ppd, cy,cx+d1/2*ppd, cy, d2*ppd);
Screen('DrawLine', display.h, colorCross, cx, cy-d1/2*ppd,cx, cy+d1/2*ppd, d2*ppd);
Screen('FillOval', display.h, color, [cx-d2/2*ppd, cy-d2/2*ppd, cx+d2/2*ppd, cy+d2/2*ppd], d2*ppd);
% Screen(w, 'Flip');


end 


