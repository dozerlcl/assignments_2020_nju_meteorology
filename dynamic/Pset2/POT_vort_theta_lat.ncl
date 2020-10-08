;       10.08   interpolate to isent level
;               绘制等 theta 面的位势涡度，将之前计算的位势涡度进行插值得到

;;;>>>>> data reader
    month_select = "07"
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_"+month_select+"/"
    path_in_filenames = "fnlvars_vort.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    ; printVarSummary(f)
    ; (/"UGRD_P0_L100_GLL0","VGRD_P0_L100_GLL0","TMP_P0_L100_GLL0"/)
    temper  = f->$"TMP_P0_L100_GLL0"$    ;  [time | 124] x [lv_ISBL0 | 31] x [lat_0 | 181] x [lon_0 | 360]
    ; u_comp  = f->$"UGRD_P0_L100_GLL0"$
    ; v_comp  = f->$"VGRD_P0_L100_GLL0"$
    temper = temper(:,:,::-1,:)
    ; u_comp = u_comp(:,:,::-1,:)
    ; v_comp = v_comp(:,:,::-1,:)
    ;;; 读取前一步计算出的涡度
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_"+month_select+"/"
    path_in_filenames = "POT_vort_lat_time.nc"
    f_vort = addfile(path_in+path_in_filenames,"r")
    pot_vort=f_vort->$"POT_vort"$
;;;>>>>> count theta level
    temper_ave = dim_avg_n_Wrap(temper(time|:, lon_0|:, lv_ISBL0|:, lat_0|:), (/0,1/))
    ph     = conform(temper_ave, temper_ave&lv_ISBL0, (/0/))
    ph@units  = "Pa"
    theta  = temper_ave                                  ; create/transfer meta data
    theta  = temper_ave*(100000/ph)^0.286                ; calculate potential temperature 
    lv_theta           = ispan(600,240,10)*1.                     ; specify desired isentropic levels

;;;>>>>> interpolate to theta level
    ; temper_lv_theta = int2p_n_Wrap (theta, temper_ave, lv_theta, 0, 0)
    pot_vort_lv_theta = int2p_n_Wrap (theta, pot_vort, lv_theta, 0, 0)  
    ; printVarSummary(temper_lv_theta)
    ; ;;;>>>进行作图 ： 时间剖面图(未做调整，检查用)
    wks   = gsn_open_wks ("png", "./output_pic/"+month_select+"/POT_vort_theta_lat" )          ; send graphics to PNG file
    pot_vort_lv_theta = pot_vort_lv_theta * 1e+6
    pot_vort_lv_theta@units = pot_vort_lv_theta@units + " *1e-6"
    ; plot = new(3, graphic)
    res                      = True                 ; plot mods desired
    res@gsnCenterString      = "Jul"
    ; res@gsnDraw = False
    ; res@gsnFrame = False
    res@cnInfoLabelOn = False
      res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
    ;   res@cnLevelSpacingF      = 10.0                  ; contour spacing
    ;   res@cnMinLevelValF       = -50.                 ; min level
    ;   res@cnMaxLevelValF       =  50.                 ; max level
    res@lbLabelBarOn        = True             ; turn on  individual cb's
    ; res@lbLabelBarOn        = False            ; turn off individual cb's
    res@cnLineLabelsOn       = True                 ; turn on line labels
    res@cnFillOn             = True                 ; turn on color fill
    res@cnFillPalette        = "BlWhRe"             ; choose colormap

    plot  = gsn_csm_contour(wks, pot_vort_lv_theta(:,:), res )   ; place holder
