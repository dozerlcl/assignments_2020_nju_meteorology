;       10.08   interpolate to isent level
;               绘制330K的位势涡度，将之前计算的位势涡度进行插值得到

;;;>>>>> data reader
    select_month = "07"
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_" +select_month+ "/"
    path_in_filenames = "fnlvars_vort.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    temper  = f->$"TMP_P0_L100_GLL0"$    ;  [time | 124] x [lv_ISBL0 | 31] x [lat_0 | 181] x [lon_0 | 360]
    temper = temper(:,:,::-1,:)

    ;;; 读取前一步计算出的涡度
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_" +select_month+ "/"
    path_in_filenames = "POT_vort_lon_lat_lev.nc"
    f_vort = addfile(path_in+path_in_filenames,"r")
    pot_vort=f_vort->$"POT_vort"$
;;;>>>>> count theta level
    temper_ave = dim_avg_n_Wrap(temper(time|:, lv_ISBL0|:, lat_0|:, lon_0|:), (/0/))
    ph     = conform(temper_ave, temper_ave&lv_ISBL0, (/0/))
    ph@units  = "Pa"
    theta  = temper_ave                                  ; create/transfer meta data
    theta  = temper_ave*(100000/ph)^0.286                ; calculate potential temperature 
    lv_theta           = 330.                            ; specify desired isentropic levels
    ; printVarSummary(theta)
    ; printVarSummary(pot_vort)
;;;>>>>> interpolate to theta level
    ; temper_lv_theta = int2p_n_Wrap (theta, temper_ave, lv_theta, 0, 0)
    pot_vort_lv_theta = int2p_n_Wrap (theta, pot_vort, lv_theta, 0, 0)  
    ; printVarSummary(pot_vort_lv_theta)
    ; print(pot_vort_lv_theta)
    ind_lat = ind(pot_vort_lv_theta&lat_0.ge.20)
    plot_pot_vort = pot_vort_lv_theta(0, ind_lat, :)
    ;;;>>>进行作图 ： 时间剖面图(未做调整，检查用)
    wks   = gsn_open_wks ("png", "./output_pic/"+select_month+"/POT_vort_theta_330K" )          ; send graphics to PNG file
    plot_pot_vort = plot_pot_vort * 1e+6
    plot_pot_vort@units = plot_pot_vort@units + " *1e-6"
    ; plot = new(3, graphic)
    res                      = True                 ; plot mods desired
    res@gsnCenterString      = "Jul"
    ; res@gsnDraw = False
    ; res@gsnFrame = False
    ; res@cnInfoLabelOn = False
    res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
    res@gsnPolar             = "NH"                   ; specify the hemisphere
    res@cnLinesOn            = False
    res@mpFillOn                   = True               ; turn off gray map
    res@mpOutlineDrawOrder         = "PostDraw"           ; draw outline first
    ; res@cnLineLabelsOn      = T
    ;   res@cnLevelSpacingF      = 10.0                  ; contour spacing
    ;   res@cnMinLevelValF       = -50.                 ; min level
    ;   res@cnMaxLevelValF       =  50.                 ; max level
    res@gsnAddCyclic        = True
    res@mpLimitMode       = "LatLon"
    res@mpMinLatF         = 20         
    res@mpMaxLatF         = 90
    ;   res@mpMinLonF         = -180
    ; res@mpMaxLonF         = 180
    res@lbLabelBarOn        = True             ; turn on  individual cb's
    ; res@lbLabelBarOn        = False            ; turn off individual cb's
    ; res@cnLineLabelsOn       = True                 ; turn on line labels
    res@cnFillOn             = True                 ; turn on color fill
    res@cnFillPalette        = "BlWhRe"             ; choose colormap

    plot  = gsn_csm_contour_map(wks, plot_pot_vort, res )   ; place holder
