%%
syms x y r vbeta ebeta dt b sigma F s r;

b = sqrt((sqrt(x.^2+y.^2)+sqrt((x-s).^2+(y-r).^2)).^2-(s.^2+r.^2));
F = exp(-b/sigma);
r = [x;y];
w = jacobian(F,r)
%%
sigma = 9;
v_b = [90,-20];
e_b = v_b/norm(v_b,2);
dt=.2;
[X, Y] = meshgrid(-30:1:30, -30:1:30);

b=(1/2)*sqrt(...  
        (...
        sqrt(X.^2+Y.^2)+...
        sqrt((X-v_b(1)*dt).^2+(X-dt*v_b(2)).^2)...
        ).^2-...
        (sqrt(sum(v_b.^2))*dt).^2);
result = exp(-b/sigma);
clf;
contour(result);
hold on;
[DX,DY] = gradient(result);
shit = (-1/sigma).*exp(-b/sigma);
DX = DX*e_b(1);
DY = DY*e_b(2);

DX_ =shit*e_b(1);
DY_ = shit*e_b(2);
%quiver([1:2:121,1:2:121],[1:2:121,1:2:121],DX(1:2:121,1:2:121),DY(1:2:121,1:2:121))
quiver(DX,DY);
%quiver(DX_,DY_,'r');
hold off;