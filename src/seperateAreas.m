function [areas, n] = seperateAreas( pattern )
%SEPERATEAREAS Summary of this function goes here
%   Detailed explanation goes here

    CC = bwconncomp( pattern );
    areas = [];
    n = CC.NumObjects;
    
    for i = 1:n % for every found component in the goal-layer
        layer = pattern*0;
        layer(CC.PixelIdxList{i}) = 1;
        areas(:,:,i) = layer; % add a layer with it to X_goals
        %spy(layer, 'MarkerFaceColor', 'r');
    end

end

