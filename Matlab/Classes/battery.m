classdef battery < dynamicprops
    %BATTERY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        usable_energy = 0; %max storable energy in kwh
        round_trip_efficiency = 0;
        power = 0; %charging/discharging power in kw
        lifetime= 0;
        price = 0;
        extra %extra information
        DC_voltage
    end
    
    methods
        function obj = battery(name,usable_energy,round_trip_efficiency,power,lifetime,price)
            obj.name =name;
            obj.usable_energy = usable_energy; %max storable energy
            obj.round_trip_efficiency = round_trip_efficiency;
            obj.power = power; %charging/discharging power
            obj.lifetime= lifetime;
            obj.price = price;
        end

       
    end
end

