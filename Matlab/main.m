%% Adds the missing rows in the irradiance data file
path = [pwd , '\Data\Irradiance_data.mat'];
irradiance_data = load(path);
irradiance_data = irradiance_data.Irradiancedata;
irradiance_data_filled = irradiance_fill(irradiance_data);


%%
