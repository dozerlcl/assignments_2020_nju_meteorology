;       10.07   动力课作业2 P2
;               计算位温，在100hPa以下位温变化幅度不大，在100以上开始狂飙，注意调整数据间隔
begin
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/"
    path_in_filenames = "vars_p1.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    ; printVarSummary(f)
    temper  = f->$"TMP_P0_L100_GLL0"$    ;  [time | 124] x [lv_ISBL0 | 31] x [lat_0 | 181] x [lon_0 | 360]
    ; printVarSummary(temper)
    temper_ave = dim_avg_n_Wrap(temper(time|:, lon_0|:, lv_ISBL0|:, lat_0|:), (/0,1/))
    ; printVarSummary(vort_ave)
    temper_ave!0 = "lev"
    temper_ave&lev@units = "Pa"
    pot_temper = pot_temp(temper_ave&lev, temper_ave, 0, False)
    printVarSummary(pot_temper)

;;;>>>进行作图 ： 时间剖面图(未做调整，检查用)
    wks   = gsn_open_wks ("png", "./output_pic/POT_h_lat_check" )          ; send graphics to PNG file
    ; plot = new(3, graphic)
    res                      = True                 ; plot mods desired
    ; res@gsnDraw = False
    ; res@gsnFrame = False
    res@cnInfoLabelOn = False
      res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
      res@cnLevelSpacingF      = 10.0                  ; contour spacing
    ;   res@cnMinLevelValF       = -50.                 ; min level
    ;   res@cnMaxLevelValF       =  50.                 ; max level
    res@lbLabelBarOn        = True             ; turn on  individual cb's
    ; res@lbLabelBarOn        = False            ; turn off individual cb's
    res@cnLineLabelsOn       = True                 ; turn on line labels
    res@cnFillOn             = True                 ; turn on color fill
    res@cnFillPalette        = "BlWhRe"             ; choose colormap
    ;   res@lbOrientation        = ""
    ;   res@tiYAxisString        = u&lev@long_name + " (" + u&lev@units + ")"   
    ; Note: u is already on pressure levels. If this were model data, it
    ; would be necessary to interpolate from the hybrid coordinates to 
    ; pressure levels.

    plot  = gsn_csm_pres_hgt(wks, pot_temper(10:,:), res )   ; place holder
    ; plot(1)  = gsn_csm_pres_hgt(wks, earth_vort, res )   ; place holder
    ; plot(2)  = gsn_csm_pres_hgt(wks, compare_vort, res )   ; place holder

    ; pres = True
    ; pres@txString              = "vorticity in Jan"
    ; pres@gsnPanelLabelBar      = True ; 公用一个色标
    ; pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)"/)
    ; pres@lbOrientation         = "vertical"
    ; pres@lbTitleString      = "unit: s-1 * 1e-5"
    ; pres@lbTitleFontHeightF = 0.0125
    ; pres@lbTitleJust        = "topLeft"
    
    ; pres@amJust                = "TopLeft" ;调整标签顺序

    ; gsn_panel(wks,plot,(/1,3/),pres)
end