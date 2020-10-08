;;;>>>>> data reader
    select_month = "07"
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_"+select_month+"/"
    path_in_filenames = "fnlvars_hgt.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    hgt  = f->$"HGT_P0_L100_GLL0"$    ;  [time | 124] x [lv_ISBL0 | 31] x [lat_0 | 181] x [lon_0 | 360]
    hgt = hgt(:,:,::-1,:)
;;;>>>>> count theta level
    hgt_ave = dim_avg_n_Wrap(hgt(time|:, lv_ISBL0|:, lat_0|:, lon_0|:), (/0/))
    ; plot_hgt = 
    ; printVarSummary(plot_hgt)
    ; hgt_ave@units ="m"
    wks   = gsn_open_wks ("png", "./output_pic/"+select_month+"/HGT_500hpa" )          ; send graphics to PNG file
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

    plot  = gsn_csm_contour_map(wks, hgt_ave({50000.},{20:},:), res )   ; place holder
