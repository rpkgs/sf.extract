# cdo -z zip_1 yearsum GRACE_REC_v03_GSFC_ERA5_monthly_ensemble_mean.nc GRACE_REC_v03_GSFC_ERA5_monthly_ensemble_mean-1979_201907.nc

cdo -seldate,1979-01-01,2018-12-31 -selname,rec_ensemble_mean -yearsum GRACE_REC_v03_GSFC_ERA5_monthly_ensemble_mean.nc GRACE_REC_v03_GSFC_ERA5_yearly_1979-2018.nc

cdo -seldate,1979-01-01,2018-12-31 -selname,rec_ensemble_mean -yearsum GRACE_REC_v03_JPL_ERA5_monthly_ensemble_mean.nc GRACE_REC_v03_JPL_ERA5_yearly_1979-2018.nc

# GSWP3
cdo -P 8 -z zip_1 -selname,rec_ensemble_mean -yearsum GRACE_REC_v03_GSFC_GSWP3_monthly_ensemble_mean.nc ../GRACE_REC_v03_GSFC_GSWP3_yearly_1901-2014.nc
cdo -P 8 -z zip_1 -selname,rec_ensemble_mean -yearsum GRACE_REC_v03_JPL_GSWP3_monthly_ensemble_mean.nc ../GRACE_REC_v03_GSFC_JPL_yearly_1901-2014.nc

# MSWEP
cdo -P 8 -z zip_1 -selname,rec_ensemble_mean -yearsum GRACE_REC_v03_GSFC_MSWEP_monthly_ensemble_mean.nc ../GRACE_REC_v03_GSFC_MSWEP_yearly_1979-2016.nc
cdo -P 8 -z zip_1 -selname,rec_ensemble_mean -yearsum GRACE_REC_v03_JPL_MSWEP_monthly_ensemble_mean.nc ../GRACE_REC_v03_JPL_MSWEP_yearly_1979-2016.nc

# cdo -z zip_1 yearsum GRACE_REC_v03_GSFC_GSWP3_monthly_ensemble_mean.nc GRACE_REC_v03_GSFC_GSWP3_monthly_ensemble_mean.nc
# cdo -z zip_1 yearsum GRACE_REC_v03_GSFC_MSWEP_monthly_ensemble_mean.nc GRACE_REC_v03_GSFC_MSWEP_monthly_ensemble_mean.nc
# cdo -z zip_1 yearsum GRACE_REC_v03_JPL_ERA5_monthly_ensemble_mean.nc GRACE_REC_v03_JPL_ERA5_monthly_ensemble_mean.nc
# cdo -z zip_1 yearsum GRACE_REC_v03_JPL_GSWP3_monthly_ensemble_mean.nc GRACE_REC_v03_JPL_GSWP3_monthly_ensemble_mean.nc
# cdo -z zip_1 yearsum GRACE_REC_v03_JPL_MSWEP_monthly_ensemble_mean.nc GRACE_REC_v03_JPL_MSWEP_monthly_ensemble_mean.nc
