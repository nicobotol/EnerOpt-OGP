# # wave FROM ERA5
# import netCDF4 as nc
# import pandas as pd
# import matplotlib.pyplot as plt

# # Define the path to your .nc file and the output CSV file

# nc_file = 'src/meteo_data_import/dulang/fda1136c105a9e3958fc020d09d12fdf.nc' # mean wave period (mwp) dulang
# # nc_file = 'src/meteo_data_import/dulang/swh_dulang_2022_2023.nc' # wave heigh (mwp) dulang

# var_name = 'mwh' # name of the series that has to be extracted
# output_file = 'src/meteo_data_import/dulang/' + 'dulang_2022_2023_' +  var_name + '.txt'

# # Open the NetCDF file
# with nc.Dataset(nc_file, 'r') as ds:
#     # Select the  variable and retrieve its data
#     var = ds.variables[var_name]

#     # Extract data for coordinates 5.5N 104.5E (stored in the second row and column)
#     data = var[:,1,1]  

#     # Flatten the data into a single column
#     flattened_data = data.flatten()

#     # Create a DataFrame with a single column
#     df = pd.DataFrame(flattened_data, columns=[var_name])

# # Save the DataFrame to a CSV file
# df.to_csv(output_file, index=False)
# print(f"Data has been successfully saved to {output_file}")

# plt.plot(flattened)
# plt.axhline(y=4, color='r', linestyle='--')
# for x in range(1, 730*24 + 1, 24):
#     plt.axvline(x=x, color='gray', linestyle='--', linewidth=0.5)
# plt.show()

# # wave FROM ERA5
# import netCDF4 as nc
# import pandas as pd
# import matplotlib.pyplot as plt

# # Define the path to your .nc file and the output CSV file

# nc_file = 'src/meteo_data_import/dulang/peak_wave_period.nc' # mean wave period (mwp) dulang
# # nc_file = 'src/meteo_data_import/dulang/swh_dulang_2022_2023.nc' # wave heigh (mwp) dulang

# var_name = 'pp1d' # name of the series that has to be extracted
# output_file = 'src/meteo_data_import/dulang/' + 'dulang_2022_2023_' +  var_name + '.txt'

# # Open the NetCDF file
# with nc.Dataset(nc_file, 'r') as ds:
#     # Select the  variable and retrieve its data
#     var = ds.variables[var_name]

#     # Extract data for coordinates 5.5N 104.5E (stored in the second row and column)
#     data = var[:,1,1]  

#     # Flatten the data into a single column
#     flattened_data_pp1d = data.flatten()

#     # Create a DataFrame with a single column
#     df = pd.DataFrame(flattened_data_pp1d, columns=[var_name])

# # Open the NetCDF file
# with nc.Dataset(nc_file, 'r') as ds:
#     # Select the  variable and retrieve its data
#     var = ds.variables['mwp']

#     # Extract data for coordinates 5.5N 104.5E (stored in the second row and column)
#     data = var[:,1,1]  

#     # Flatten the data into a single column
#     flattened_data_mwp = data.flatten()

# # Save the DataFrame to a CSV file
# df.to_csv(output_file, index=False)
# print(f"Data has been successfully saved to {output_file}")

# plt.plot(flattened_data_pp1d)
# plt.plot(flattened_data_mwp)
# plt.axhline(y=4, color='r', linestyle='--')
# for x in range(1, 730*24 + 1, 24):
#     plt.axvline(x=x, color='gray', linestyle='--', linewidth=0.5)
# plt.show()

## WIND 
import netCDF4 as nc
import pandas as pd
import matplotlib.pyplot as plt

# Define the path to your .nc file and the output CSV file

nc_file = 'src/meteo_data_import/dulang/u10_v10_swh_pp1d_file1.nc' # data related to wind
nc_file_w = 'src/meteo_data_import/dulang/u10_v10_swh_pp1d_file2.nc' # data related to wave

var_name_wind = 'wind_112m' # name of the series that has to be extracted
output_file_wind = 'src/meteo_data_import/dulang/' + 'dulang_2022_2023_' +  var_name_wind + '.txt'
var_name_swh = 'swh' # name of the series that has to be extracted
output_file_swh = 'src/meteo_data_import/dulang/' + 'dulang_2022_2023_' +  var_name_swh + '.txt'
var_name_pp1d = 'pp1d' # name of the series that has to be extracted
output_file_pp1d = 'src/meteo_data_import/dulang/' + 'dulang_2022_2023_' +  var_name_pp1d + '.txt'

#  __        ___           _ 
#  \ \      / (_)_ __   __| |
#   \ \ /\ / /| | '_ \ / _` |
#    \ V  V / | | | | | (_| |
#     \_/\_/  |_|_| |_|\__,_|
# Open the NetCDF file
with nc.Dataset(nc_file, 'r') as ds:
                               
  # Select the  variable and retrieve its data
  var_u10 = ds.variables['u10']
  var_v10 = ds.variables['v10']

  # Extract data for coordinates 5.5N 104.5E (stored in the second row and column)
  data_u10 = var_u10[:,1,1]  
  data_v10 = var_v10[:,1,1]

  data_10 = (data_u10**2 + data_v10**2)**0.5 # wind speed

  # Flatten the data into a single column
  flattened_data = data_10.flatten()

  data_h100 = data_10*(100/10)**0.11 # wind speed at 100m
  flattened_data_h100 = data_h100.flatten()

  data_h112 = data_10*(112/10)**0.11 # wind speed at 100m
  flattened_data_h112 = data_h112.flatten()

  # Create a DataFrame with a single column
  df = pd.DataFrame(flattened_data, columns=[var_name_wind])
  df_h100 = pd.DataFrame(flattened_data_h100, columns=[var_name_wind])
  df_h112 = pd.DataFrame(flattened_data_h112, columns=[var_name_wind])


df_h112.to_csv(output_file_wind, index=False)
print(f"Data has been successfully saved to {output_file_wind}")

with nc.Dataset(nc_file_w, 'r') as ds:
  var_swh = ds.variables['swh']
  var_pp1d = ds.variables['pp1d']
  data_swh = var_swh[:,1,1]
  data_pp1d = var_pp1d[:,1,1]
  flattened_data_swh = data_swh.flatten()
  flattened_data_pp1d = data_pp1d.flatten()
  df_swh = pd.DataFrame(flattened_data_swh, columns=[var_name_swh])
  df_pp1d = pd.DataFrame(flattened_data_pp1d, columns=[var_name_pp1d])
  df_swh.to_csv(output_file_swh, index=False)
  df_pp1d.to_csv(output_file_pp1d, index=False)

# plt.plot(flattened_data)
# plt.plot(data_h100)
# plt.plot(data_h112)
# plt.axhline(y=4, color='r', linestyle='--')
# for x in range(1, 730*24 + 1, 24):
#     plt.axvline(x=x, color='gray', linestyle='--', linewidth=0.5)
# plt.show()