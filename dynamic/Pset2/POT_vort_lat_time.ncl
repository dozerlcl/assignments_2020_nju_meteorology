;       10.07   动力课作业2 P2
;               计算，等压面上的位势涡度
;               使用ncl函数 https://www.ncl.ucar.edu/Document/Functions/Contributed/pot_vort_isobaric.shtml
;               计算量较大,进行三个变量的平均加上为 位势涡函数的使用 pot_vort 大约20s  准备一个缓存数据
begin
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/"
    path_in_filenames = "vars_p2.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    ; printVarSummary(f)
    ; (/"UGRD_P0_L100_GLL0","VGRD_P0_L100_GLL0","TMP_P0_L100_GLL0"/)
    temper  = f->$"TMP_P0_L100_GLL0"$    ;  [time | 124] x [lv_ISBL0 | 31] x [lat_0 | 181] x [lon_0 | 360]
    u_comp  = f->$"UGRD_P0_L100_GLL0"$
    v_comp  = f->$"VGRD_P0_L100_GLL0"$
    temper = temper(:,:,::-1,:)
    u_comp = u_comp(:,:,::-1,:)
    v_comp = v_comp(:,:,::-1,:)
    ; printVarSummary(temper)
    ; print(u_comp&lat_0)
    ;   must be S-N order
    temper_ave = dim_avg_n_Wrap(temper(time|:, lv_ISBL0|:, lat_0|:, lon_0|:), (/0/))
    u_ave      = dim_avg_n_Wrap(u_comp(time|:, lv_ISBL0|:, lat_0|:, lon_0|:), (/0/))
    v_ave      = dim_avg_n_Wrap(v_comp(time|:, lv_ISBL0|:, lat_0|:, lon_0|:), (/0/))
    print("-----------start count potiential vort----------------")
    pot_vort  = pot_vort_isobaric(temper_ave&lv_ISBL0, u_ave, v_ave, temper_ave, temper_ave&lat_0, 1, 0)
    
    ; printVarSummary(pot_vort)
    ; pot_vort [lv_ISBL0 | 31] x [lat_0 | 181] x [lon_0 | 360]
    pot_vort_lat = dim_avg_n_Wrap(pot_vort(lon_0|:,lv_ISBL0|:,lat_0|:), 0)
    pot_vort_lat!0   = "lev"
    pot_vort_lat&lev@units = "Pa"
    pot_vort_lat = pot_vort_lat*1e+6 ; unit 1e-6
    ;;;>>>进行作图 ： 时间剖面图(未做调整，检查用)
    wks   = gsn_open_wks ("png", "./output_pic/POT_vort_h_lat_check" )          ; send graphics to PNG file
    ; plot = new(3, graphic)
    res                      = True                 ; plot mods desired
    ; res@gsnDraw = False
    ; res@gsnFrame = False
    res@cnInfoLabelOn = False
    res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
      res@cnLevelSpacingF      = 0.5                 ; contour spacing
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

    plot  = gsn_csm_pres_hgt(wks, pot_vort_lat(10:,:), res)   ; place holder

end