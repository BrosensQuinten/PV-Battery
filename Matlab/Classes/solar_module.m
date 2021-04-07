classdef solar_module < dynamicprops
    %this class is to store the data of the relevant solar panels.
    %   Detailed explanation goes here
    
    properties
        module_name
        module_type = 'na';
        efficiency = 0
        max_power = 0 %
        area = 0 %m2
        power_temperature_coef = 0 % %/degree celsius
        price = 0; %in euros
        lifetime = 0;
        nominal_voltage = 0;
        nominal_current = 0;
    end
    
    methods
        function obj = solar_module(module_name, module_type , efficiency, max_power, area, power_temperature_coef,price, lifetime)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
           if nargin == 1
                module_type = 'na'
                efficiency = 0
                max_power = 0 %
                area = 0 %m2
                power_temperature_coef = 0 % %/degree celsius
                price = 0 %in euros
                lifetime = 0;
                nominal_voltage = 0;
           end
            obj.module_name = module_name;
            obj.module_type = module_type;
            obj.efficiency = efficiency;
            obj.max_power = max_power;
            obj.area = area;
            obj.power_temperature_coef = power_temperature_coef;
            obj.price = price;
            obj.lifetime = lifetime;
        end
        
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

