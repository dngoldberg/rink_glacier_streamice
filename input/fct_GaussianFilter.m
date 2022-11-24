function gaussFilter = fct_GaussianFilter(vec_var, norm, theta)
% fct_GaussianFilter(vec_var, norm, theta)
%
% Create a gaussian filter kernel
%
% Input
%   vec_var = [2*varRow, 2*varColumn]: The size of the wanted filter (the double of the
%   wanted variance)
%   norm: 1 for a normalized filter, 0 for the original values.
%   theta: the orientation of the filter in radian. 
%       theta = 0: varRow apply on the rows
%       theta = pi/2: varRow apply on the columns
%
% Output
%   gaussFilter: gaussian kernel (square) that can be used to build a convolutional
%   gaussian filter.
%
% F Weissgerber - 2017-10-27



varX = floor(vec_var(2)/2);
varY = floor(vec_var(1)/2);

valMax = max(varX,varY);

vecX = -valMax:valMax;
vecY = -valMax:valMax;

[X,Y] = meshgrid(vecX,vecY);
complex = X+1i*Y;
complex = complex*exp(1i*theta);
Xn = real(complex);
Yn = imag(complex);
gaussFilter = exp(-(Xn.^2/(varX)+Yn.^2/varY));

if norm == 1
    gaussFilter = gaussFilter/sum(gaussFilter(:));
end



end