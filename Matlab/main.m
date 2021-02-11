api = 'https://suncalc.org/#/48.85826,2.29451,17/2015.05.11/13:15/324.0/2';
url = [api];
  
options = weboptions()
spots = webread(url);
whos('spots')

%%
WordString = 'Azimuth';
B=strfind(spots, WordString);
result = spots(B:end);

