classdef invertor < dynamicprops
    
    properties
        invertor_name
        efficiency = 0;
        input_DC_voltage = 0;
        output_AC_voltage = 0;
        rated_power = 0;
        lifetime = 0;
        price = 0;
    end
    
    methods
        function obj = invertor(invertor_name, efficiency, input_DC_voltage, output_AC_voltage, rated_power, lifetime, price)
            obj.invertor_name = invertor_name;
            obj.efficiency = efficiency;
            obj.input_DC_voltage = input_DC_voltage;
            obj.output_AC_voltage = output_AC_voltage;
            obj.rated_power = rated_power;
            obj.lifetime = lifetime;
            obj.price = price;
        end
        
    end
end

