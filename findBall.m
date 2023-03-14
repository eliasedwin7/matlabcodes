% This function tries to find a red(ish) ball using the hue colour channel
% of an image as well as a list of candidate locations (centre point +
% radius). It returns the centre location and radius of the first circle
% that meets the criteria.
% TODO: This function simply checks the colour (hue) value at the centre
% point, rather than checking all pixels within the circle circumference.
% It would be better to do the latter, create a hue value histogram and
% check that the majority of pixel values are within the allowed hue range.
%
% Author: Roland Goecke
% Date created: 09/03/2021
% Date last changed: 05/03/2023

function [centre, radius] = findBall(hue, centres, radii)
% Get the number of candidate circles to check
numCandidates = length(centres);

% Loop over all candidates, check the hue value - from checking the hue
% values beforehand, we have determined that a hue value < 0.095 is
% consistent with the 'redish' colour of the ball
for iI = 1:numCandidates(1)
    currentHue = hue(uint16(centres(iI,2)), uint16(centres(iI,1)));
    if (currentHue < 0.095)     % Found one!
        centre = uint16(centres(iI, :) + 0.5); % Return as nearest integer
        radius = uint16(radii(iI)); % Return as nearest integer
        return              % This simple code assumes the first one
    end                     % found is correct, so stops the for-loop
end

% If we didn't find one, let's return 0 values
centre = 0;
radius = 0;
