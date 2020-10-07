;       10.07 dynamic p1   
;           plot vorticity lat ave 
;>>> data reader
begin
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/"
    path_in_filenames = "vars_p1.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    ; printVarSummary(f)
    vorticity  = f->$"ABSV_P0_L100_GLL0"$    ;   [time | 124] x [lv_ISBL8 | 26] x [lat_0 | 181] x [lon_0 | 360]
    vort_ave = dim_avg_n_Wrap(vorticity(time|:, lon_0|:, lv_ISBL8|:, lat_0|:), (/0,1/))
    ; printVarSummary(vort_ave)
    vort_ave!0 = "lev"
    vort_ave&lev@units = "Pa"
;;;>>>count
    rate_rota = 7.27 * 1e-5
    earth_vort_lat = 2*sin(vort_ave&lat_0)*rate_rota
    ; printVarSummary(vort_ave)
    earth_vort     = conform_dims(dimsizes(vort_ave), earth_vort_lat, 1)
    copy_VarCoords(vort_ave, earth_vort)
    earth_vort&lev@units = "Pa"
    ; printVarSummary(earth_vort)
    ; printVarSummary(vort_ave)
    real_vort = vort_ave
    real_vort = real_vort - earth_vort
    printVarSummary(real_vort)
;;;>>>进行作图 ： 时间剖面图(未做调整，检查用)
  wks   = gsn_open_wks ("png", "./vort_h_lat_check" )          ; send graphics to PNG file

  res                      = True                 ; plot mods desired

;   res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
;   res@cnLevelSpacingF      = 5.0                  ; contour spacing
;   res@cnMinLevelValF       = -50.                 ; min level
;   res@cnMaxLevelValF       =  50.                 ; max level
  res@cnLineLabelsOn       = True                 ; turn on line labels
  res@cnFillOn             = True                 ; turn on color fill
  res@cnFillPalette        = "BlWhRe"             ; choose colormap
;   res@tiYAxisString        = u&lev@long_name + " (" + u&lev@units + ")"   

; Note: u is already on pressure levels. If this were model data, it
; would be necessary to interpolate from the hybrid coordinates to 
; pressure levels.
  
  plot  = gsn_csm_pres_hgt(wks, real_vort, res )   ; place holder


end