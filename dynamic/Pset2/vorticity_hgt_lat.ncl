;       10.07 dynamic p1   
;           plot vorticity lat ave
;           小图三张分别为 纬向平均的 相对涡度 牵连涡度 差值（牵连减相对） 
;           目前只绘制了1月平均的图
;>>> data reader
begin
    month_select = "07"
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_"+month_select+"/"
    path_in_filenames = "fnlvars_vort.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    ; printVarSummary(f)
    vorticity  = f->$"ABSV_P0_L100_GLL0"$    ;   [time | 124] x [lv_ISBL8 | 26] x [lat_0 | 181] x [lon_0 | 360]
    ; printVarSummary(vorticity)
    vort_ave = dim_avg_n_Wrap(vorticity(time|:, lon_0|:, lv_ISBL10|:, lat_0|:), (/0,1/))
    vort_ave!0 = "lev"
    vort_ave&lev@units = "Pa"
;;;>>>count
    pi = get_pi("float")
    rate_rota = 7.27 * 1e-5
    earth_vort_lat = 2*sin(vort_ave&lat_0/180*pi)*rate_rota
    ; print(earth_vort_lat)
    ; printVarSummary(vort_ave)
    earth_vort     = conform_dims(dimsizes(vort_ave), earth_vort_lat, 1)
    copy_VarCoords(vort_ave, earth_vort)
    earth_vort&lev@units = "Pa"
    ; printVarSummary(earth_vort)
    ; printVarSummary(vort_ave)
    real_vort = vort_ave
    real_vort = real_vort - earth_vort
    earth_vort  = earth_vort* 1e+5
    real_vort   = real_vort* 1e+5 ; 绘图 x 1e+5 记得标注单位
    ; printVarSummary(real_vort)
    compare_vort = real_vort - earth_vort
    ; printVarSummary(compare_vort)
    copy_VarCoords(vort_ave, compare_vort)
    compare_vort&lev@units = "Pa"
;;;>>>进行作图 ： 时间剖面图(未做调整，检查用)
    wks   = gsn_open_wks ("png", "./output_pic/"+month_select+"/vort_h_lat" )          ; send graphics to PNG file
    plot = new(3, graphic)
    res                      = True                 ; plot mods desired
    res@gsnDraw = False
    res@gsnFrame = False
    res@cnInfoLabelOn = False
    ;   res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
    ;   res@cnLevelSpacingF      = 5.0                  ; contour spacing
    ;   res@cnMinLevelValF       = -50.                 ; min level
    ;   res@cnMaxLevelValF       =  50.                 ; max level
    res@lbLabelBarOn        = False            ; turn off individual cb's
    res@cnLineLabelsOn       = True                 ; turn on line labels
    res@cnFillOn             = True                 ; turn on color fill
    res@cnFillPalette        = "BlWhRe"             ; choose colormap
    ;   res@lbOrientation        = ""
    ;   res@tiYAxisString        = u&lev@long_name + " (" + u&lev@units + ")"   
    ; Note: u is already on pressure levels. If this were model data, it
    ; would be necessary to interpolate from the hybrid coordinates to 
    ; pressure levels.

    plot(0)  = gsn_csm_pres_hgt(wks, real_vort, res )   ; place holder
    plot(1)  = gsn_csm_pres_hgt(wks, earth_vort, res )   ; place holder
    plot(2)  = gsn_csm_pres_hgt(wks, compare_vort, res )   ; place holder

    pres = True
    pres@txString              = "vorticity in Jul"
    pres@gsnPanelLabelBar      = True ; 公用一个色标
    pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)"/)
    ; pres@lbOrientation         = "vertical"
    pres@lbTitleString      = "unit: s-1 * 1e-5"
    pres@lbTitleFontHeightF = 0.0125
    pres@lbTitleJust        = "topLeft"
    
    ; pres@amJust                = "TopLeft" ;调整标签顺序

    gsn_panel(wks,plot,(/1,3/),pres)
end