function f = objFcn(x, R)

% objFcn
%
% Objective function for celltower problem.
% Calculates the area of cell coverage overlap.
%
%   areaOverlap = objFcn(x, R)
%     x : cell tower coordinates

% Copyright 2003-2011 The MathWorks, Inc.

pts = reshape(x,2,length(x)/2);
N = length(R);
f = 0;
% Two circles can intersect in 0,1, 2, or all points.
% If they intersect in 0 points, then no area to add since disjoint.
% If they intersect in 1 point, then either have no common area
%       of intersection (almost disjoint), or one is inside the other and barely touching.
%       In the second case, area of intersection is the smaller circle.
% If they intersect in 2 points, then usual case of overlapping, call
%       circleIntersectArea to compute.
% They can be the same circle and so intersect at all points, they can have
% the same center but different radii (so compute diff), or they can have
% different centers and radii but one is completely inside the other (so
% compute diff).

for i = 1:N-1
  for j = i+1:N

    [p,q,areatotal] = areaIntersect(pts(:,i),R(i),pts(:,j),R(j)); %#ok<ASGLU>
    if isequal(pts(:,i),pts(:,j))
      % Circles have the same center: give a higher penalty
      f = f + areatotal + 1/(1e-8);
    else % different centers
      f = f + areatotal + 1/40 * 1/((norm(pts(:,i)-pts(:,j)))^2);
    end
  end
end


%-------------------------------
function [p,q,areatotal,numberOfPoints] = areaIntersect(C1,r1,C2,r2)
% Circle centers C1 and C2 with radius r1 and r2.

% Compute x and y
% Solve in easy coordinates
a = norm(C1-C2);
% Check for divide by zero
if isequal(a,0)
  % Circles have same center. Return the area of the smaller circle.
  p = [NaN;NaN]; q = [NaN;NaN]; numberOfPoints = Inf;
  areatotal = pi*min(r1,r2)^2;
  return
end
x = 0.5*(a + (r1^2 - r2^2)/a);
if r1^2 < x^2 % Check for sqrt of negative
  p = [NaN;NaN]; q = [NaN;NaN];
  if r1 + r2 < a
    areatotal = 0; numberOfPoints = 0;
  else % One circle is inside the other
    areatotal = pi*min(r1,r2)^2;
    numberOfPoints = Inf;
  end
  return
end
y = sqrt(r1^2 - x^2);

% Original coordinates basis
i = (C2-C1)/norm(C2-C1);
j = null(i');

% Intersection points in original coordinates
p = C1 + i*x + j*y ;
q = C1 + i*x - j*y;

% Compute the angle theta between radius and x-axis
% in the easy coordinates
theta1 =  atan2(y,x);
theta2 =  atan2(y,a-x);

% Obtain A1 with x, y, r1
area1 = theta1*r1^2 - x*y;
% Obtain A2 with a-x, y, r2
area2 = theta2*r2^2 - (a-x)*y;

areatotal = area1 + area2;

if isequal(p,q)
  numberOfPoints = 1;
else
  numberOfPoints = 2;
end
