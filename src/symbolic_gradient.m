%%
syms x y r vbeta ebeta dt b sigma F s r;

b = sqrt((sqrt(x.^2+y.^2)+sqrt((x-s).^2+(y-r).^2)).^2-(s.^2+r.^2));
F = exp(-b/sigma);
r = [x;y];
w = jacobian(F,r)
%%
sigma = 9;
v_b = [1000,1000];
e_b = v_b/norm(v_b,2);
dt=.2;
[X, Y] = meshgrid(-15:1:15, -15:1:15);

b=(1/2)*sqrt(...  
        (...
        sqrt(X.^2+Y.^2)+...
        sqrt((X-v_b(1)*dt).^2+(Y-dt*v_b(2)).^2)...
        ).^2-...
        (sqrt(sum(v_b.^2))*dt).^2);
result = exp(-b/sigma);
clf;
contour(result);
hold on;
[DX,DY] = gradient(result);
DX =2.1*30^2*-DX;
DY = 2.1*30^2*-DY;
XY = sqrt(X.^2+Y.^2);
EX = X./XY; EY = Y./XY;
quiver(DX,DY);
%%
shit = (-1/sigma).*exp(-b/sigma);
%quiver(EX,EY,'y');
%quiver(DX,DY,'b');
quiver(DX,DY,'y');
DX = DX.*EX; DY = DY.*EY;

DX_ = shit*EX; DY_ = shit*EY;
%quiver([1:2:121,1:2:121],[1:2:121,1:2:121],DX(1:2:121,1:2:121),DY(1:2:121,1:2:121))
quiver(EX,EY,'b');
%quiver(DX_,DY_,'r');
quiver(DX,DY,'r');
hold off;
%%
clf;
quiver(DX,DY,'g');
% quiver(X,Y,'b');
DXY = DX.*X+DY*Y;
quiver(DX.*EX,DY*EY);
%quiver(DXY.*EX,DXY*EY,'r');
