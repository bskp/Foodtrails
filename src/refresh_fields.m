% Fast marching algorithm

f = v0_mean / tau_alpha; % see formula (2) in paper

for i = 1
    X_fm(:,:,i) = 0.00001 + X_walls(:,:,i)*0.9;

    X_people = 0*X_walls(:,:,i);
    a_pos = round(A(2,:)) + (map_x) * round(A(1,:)-1); % liste der pixel der a.
    X_people( a_pos ) = 1;

    R_p = 5 * R;

    g_people = exp( -sqrt( (k-k_0).^2+(l-l_0).^2 )/R_p );

    X_people_conv = conv2(X_people, g_people, 'same');

    X_fm(:,:,i) = 2*X_fm(:,:,i) - X_people_conv;


    addpath fm/;
    [t_x, t_y] = find(X_goals(:,:,i) == 1); % Create list of target-pxs

    [T(:,:,i), Y] = msfm(X_fm(:,:,i), [t_x t_y]'); % Do the fast marching thing

    [e_alpha_x(:,:,i), e_alpha_y(:,:,i)] = gradient(-T(:,:,i));
    r = sqrt( e_alpha_x(:,:,i).^2 + e_alpha_y(:,:,i).^2 );
    
    r( r==0 ) = inf;
    
    e_alpha_x(:,:,i) = e_alpha_x(:,:,i)./r;
    e_alpha_y(:,:,i) = e_alpha_y(:,:,i)./r;
    % Now we've got the fields for the desired direction, e_alpha.
%     
%     %fields_x(:,:,i) =  field_walls_x(:,:,i);% + f*e_alpha_x(:,:,i);
%     %fields_y(:,:,i) =  field_walls_y(:,:,i);% + f*e_alpha_y(:,:,i); % Scale & sum fields
end
