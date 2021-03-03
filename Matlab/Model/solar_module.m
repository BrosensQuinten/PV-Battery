classdef solar_module
    %this class is to store the data of the relevant solar panels.
    %   Detailed explanation goes here
    
    properties
        module_name
        module_type
        efficiency 
        max_power
        area
        power_gradient
        
    end
    
    methods
        function obj = solar_module(module_name,module_type, efficiency, max_power, area, power_gradient)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.module_name = module_name;
            obj.module_type = module_type;
            obj.efficiency = efficiency;
            obj.max_power = max_power;
            obj.area = area;
            obj.power_gradient = power_gradient;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

