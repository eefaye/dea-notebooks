#/bin/bash


for ncfile in /g/data/u46/users/ext547/ewater/input_data/Temperature/World/*.nc; do
    echo -n .
    ncks -d lon,101.3,108.7 -d lat,8.9,15.7 $ncfile clipped_`basename $ncfile`
    ncrename -a Tair@Fill_value,_FillValue clipped_`basename $ncfile`
    ncap2 -s Tair=Tair-273.15 -s 'Tair@actual_max=Tair.max()' \
        -s 'Tair@actual_min=Tair.min()' -s Tair@units=\"C\" \
        -s 'lat@actual_min=lat.min()' -s 'lat@actual_max=lat.max()' \
        -s 'lon@actual_min=lon.min()' -s 'lon@actual_max=lon.max()' \
        clipped_`basename $ncfile` celsius_`basename $ncfile`
done
