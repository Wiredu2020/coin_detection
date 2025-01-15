% Now let's classify the coins
%the function inputs should be the features of the coins
%features are diameters, hue, saturation
function Class_label = classifier(features)

%Diameteres
% 2 eur Diameter (mm): 25.75
% 1 eur 23.25
% 50 cents 24.25
% 20 cents 22.25
% 10 cents 19.75
% 5 cents  21.25

 
    % We have taken three features
    %Diameter
    diameter = features(1); 

    %hue
    hue = features(2); 

    %saturation difference between features sat_dif
    sat_dif = features(3);

    %calculate average hue
    hue_avg = features(4); 
    avg_sat = features(5);

    %if average saturation and average saturation is less than or equal to
    %value given
    if avg_sat <= 0.00409
        if sat_dif <= -0.125
            Class_label = 5;
        else 
            Class_label = 0;
        end
    else 
        if hue <= 0.0996791
            if hue_avg <= 0.0012046
                Class_label = 1;
            else 
                if diameter <= 25.5000496
                    Class_label = 5;
                    %Diameter is lesser
                else 
                    Class_label = 6;
                end
            end
        else % if hue > 0.0996791
            if diameter <= 24.0393009
                if diameter <= 21.2246885
                    Class_label = 2;
                else % if diameter > 21.2246885
                    Class_label = 3;
                end
            else % if diameter > 24.0393009
                if hue <= 0.1166754
                    Class_label = 4;
                else % if hue > 0.1166754
                    Class_label = 0;
                end
            end
        end
    end
end



