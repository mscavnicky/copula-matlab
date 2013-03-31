function th=rotateticklabel(h, rot)
%ROTATETICKLABEL rotates tick labels
%   TH=ROTATETICKLABEL(H,ROT) is the calling form where H is a handle to
%   the axis that contains the XTickLabels that are to be rotated. ROT is
%   an optional parameter that specifies the angle of rotation. The default
%   angle is 90. TH is a handle to the text objects created. For long
%   strings such as those produced by datetick, you may have to adjust the
%   position of the axes so the labels don't get cut off.
%
%   Of course, GCA can be substituted for H if desired.
%
%   TH=ROTATETICKLABEL([],[],'demo') shows a demo figure.
%
%   Known deficiencies: if tick labels are raised to a power, the power
%   will be lost after rotation.
%
%   See also datetick.

%   Written Oct 14, 2005 by Andy Bliss
%   Copyright 2005 by Andy Bliss

%set the default rotation if user doesn't specify
if nargin==1
    rot=90;
end
%make sure the rotation is in the range 0:360 (brute force method)
assert(rot >= 0 & rot <= 360, 'Rotation not in range');

%get current tick labels
labels=get(h,'XTickLabel');
%erase current tick labels from figure
set(h,'XTickLabel',[]);
%get tick label positions
xt=get(h,'XTick');
yt=get(h,'YTick');
%make new tick labels
alignment = 'right';
if rot > 180
    alignment = 'left';
end

newx = xt;
newy = repmat(yt(end)+0.75*(yt(2)-yt(1)), length(xt), 1);
th=text(newx, newy, labels, 'HorizontalAlignment', alignment, 'rotation', rot, 'FontName', 'NewCenturySchlbk');