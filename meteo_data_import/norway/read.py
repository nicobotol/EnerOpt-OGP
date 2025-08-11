# # wave FROM ERA5
# import netCDF4 as nc
# import pandas as pd
# import matplotlib.pyplot as plt

# # Define the path to your .nc file and the output CSV file

# nc_file = 'src/meteo_data_import/norway/fda1136c105a9e3958fc020d09d12fdf.nc' # mean wave period (mwp) dulang
# # nc_file = 'src/meteo_data_import/dulang/swh_dulang_2022_2023.nc' # wave heigh (mwp) dulang

# var_name = 'mwh' # name of the series that has to be extracted
# output_file = 'src/meteo_data_import/norway/' + 'norway_2022_2023_' +  var_name + '.txt'

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

# nc_file = 'src/meteo_data_import/norway/peak_wave_period.nc' # mean wave period (mwp) dulang
# # nc_file = 'src/meteo_data_import/dulang/swh_dulang_2022_2023.nc' # wave heigh (mwp) dulang

# var_name = 'pp1d' # name of the series that has to be extracted
# output_file = 'src/meteo_data_import/norway/' + 'norway_2022_2023_' +  var_name + '.txt'

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

nc_file = 'src/meteo_data_import/norway/u10v10ERA5_2022_2023.nc' # mean wave period (mwp) dulang
# nc_file = 'src/meteo_data_import/dulang/swh_dulang_2022_2023.nc' # wave heigh (mwp) dulang

var_name = 'wind_112m' # name of the series that has to be extracted
output_file = 'src/meteo_data_import/norway/' + 'norway_2022_2023_' +  var_name + '.txt'

# Open the NetCDF file
with nc.Dataset(nc_file, 'r') as ds:
    # Select the  variable and retrieve its data
    var_u10 = ds.variables['u10']
    var_v10 = ds.variables['v10']

    # Extract data for coordinates 5.5N 104.5E (stored in the second row and column)
    data_u10 = var_u10[:,1,1]  
    data_v10 = var_v10[:,1,1]

    data = (data_u10**2 + data_v10**2)**0.5 # wind speed

    # Flatten the data into a single column
    flattened_data = data.flatten()

    data_h100 = data*(100/10)**0.11 # wind speed at 100m
    flattened_data_h100 = data_h100.flatten()

    data_h112 = data*(112/10)**0.11 # wind speed at 100m
    flattened_data_h112 = data_h112.flatten()

    # Create a DataFrame with a single column
    df = pd.DataFrame(flattened_data, columns=[var_name])
    df_h100 = pd.DataFrame(flattened_data_h100, columns=[var_name])
    df_h112 = pd.DataFrame(flattened_data_h112, columns=[var_name])

# # # Save the DataFrame to a CSV file
# # df.to_csv(output_file, index=False)
# # print(f"Data has been successfully saved to {output_file}")
# # Save the DataFrame to a CSV file
# df_h100.to_csv(output_file, index=False)
# print(f"Data has been successfully saved to {output_file}")
# Save the DataFrame to a CSV file
df_h112.to_csv(output_file, index=False)
print(f"Data has been successfully saved to {output_file}")

plt.plot(flattened_data)
plt.plot(data_h100)
plt.plot(data_h112)
plt.axhline(y=4, color='r', linestyle='--')
for x in range(1, 730*24 + 1, 24):
    plt.axvline(x=x, color='gray', linestyle='--', linewidth=0.5)
plt.show()