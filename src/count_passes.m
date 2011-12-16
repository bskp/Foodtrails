% Find Agents on counter areas

for agentID = 1:size(A,2)
   X = round(A(2, agentID)); Y= round(A(1,agentID));
   
   a_counter = X_counter(X, Y);
   
   if (  a_counter ~= A(7, agentID) ... % agent was not on the area yet
       & a_counter ~= 0 )               % agent is indeed on an area
   
       passes( a_counter ) = passes ( a_counter ) + 1; % boah, matlab!!!
       A(7, agentID) = a_counter;
   end
       
end

% das geht auch anders:

% a_pos = round(A(1,:)) + size(A,2) * round(A(2,:)); % liste der pixel der a.
% 
% a_counter = X_counter( a_pos ); % greife auf elemente zu
% 
% a_counter( a_counter == A(7,:) ) = 0; % wirf besuchte weg
% 
% for c = 1:n_counters % auszählen: über counter it.
%     passes(c) = passes(c) + sum( a_counter == c );
% end
% 
% % overwrite last area-value where a new counter was detectet
% A(7, a_counter ~= 0) = a_counter( a_counter ~= 0);
