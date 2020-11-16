; 10.28 GC homework 1
; /HGST_SATA_8T_3/yycheng/playground/test_src/general_c/Pset1/dataset
begin
;;;>>>>> data reader
    file_path_in = "/HGST_SATA_8T_3/yycheng/playground/test_src/general_c/Pset1/dataset"
    f_in         = addfile(file_path_in+"/air.mon.mean.nc", "r")
    ;;; NCL has this builtin. Use the function short2flt to read the netCDF fileswhere the data is packed.
    ;;; 解决资料设置 offset 的办法：https://psl.noaa.gov/data/gridded/faq.html#3
    ;;; 偷懒，不修改变量名字了
    temp_air     = short2flt(f_in->$"air"$) ; time x level x lat x lon
    ; print(temp_air)
;;;>>>>> get DJF & JJA
    time_bc = cd_calendar(temp_air&time, 0) 
    ind_DJF = ind(time_bc(:,1).eq.1.or.time_bc(:,1).eq.2.or.time_bc(:,1).eq.12)
    temp_DJF  = temp_air(ind_DJF,:,:,:)

    ind_JJA = ind(time_bc(:,1).eq.6.or.time_bc(:,1).eq.7.or.time_bc(:,1).eq.8)
    temp_JJA  = temp_air(ind_JJA,:,:,:)

    ; printVarSummary(temp_air)
    ave_temp_DJF = dim_avg_n_Wrap(temp_DJF(time|:,level|:,lat|:,lon|:), (/0/))
    ave_temp_JJA = dim_avg_n_Wrap(temp_JJA(time|:,level|:,lat|:,lon|:), (/0/))
    ; printVarSummary(ave_temp_DJF)
    ; printMinMax(ave_temp_DJF(0,:,:), 1)
;;;>>>进行作图
    wks = gsn_open_wks("png","./output_pic"+"/TEMP_lon_lat_DJF")                ; send graphics to PNG file
    res = True                                    ; plot mods desired
    res@gsnDraw = False
    res@gsnFrame = False
    res@cnFillOn             = False                 ; turn on color fill
    res@cnFillPalette        = "BlWhRe"             ; choose colormap
    res@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
    ; res@cnMinLevelValF       = 240.               ; set min contour level
    ; res@cnMaxLevelValF       = 320.               ; set max contour level
    res@cnLevelSpacingF      =   5.               ; set contour spacing
    ; res@cnInfoLabelOn        = True
    res@cnLineLabelPlacementMode = "Computed"
    ; res@cnLineLabelPlacementMode = "Randomized"
    ; res@cnLabelScaleValueF   = 2.
    res@cnLineLabelsOn       = True
    ; res@cnLineLabelInterval  = 1.
    ; res@lbBoxEndCapStyle     = "TriangleBothEnds"
    ; res@cnInfoLabelOrthogonalPosF = -0.07         ; move the label inside the plot
    res@gsnLeftString        = " "
    res@tiMainString         = " "    ; plot title
    copy_VarMeta(temp_air(0,:,:,:), ave_temp_DJF)


;;;>>>>> set panels on every levels
    ; print(ave_temp_JJA&level) ; 0 for 1000, 2 for 850, 5 for 500, 11 for 100hPa
    plot = new(4,graphic)
    pres = True
    ;;; 1000hPa
    res@gsnCenterString      = "1000 mb"           ; plot center string
    plot(0) = gsn_csm_contour_map(wks, ave_temp_DJF(0,:,:), res)  ; create plot
    ;;; 850hPa
    res@gsnCenterString      = "850 mb"           ; plot center string
    plot(1) = gsn_csm_contour_map(wks, ave_temp_DJF(2,:,:), res)  ; create plot
    ;;; 500hPa
    res@gsnCenterString      = "500 mb"           ; plot center string
    plot(2) = gsn_csm_contour_map(wks, ave_temp_DJF(5,:,:), res)  ; create plot
    ;;; 100hPa
    res@gsnCenterString      = "100 mb"           ; plot center string
    plot(3) = gsn_csm_contour_map(wks, ave_temp_DJF(11,:,:), res)  ; create plot
    pres@txString              = "DJF temp"
    ; pres@gsnPanelLabelBar      = True ; 公用一个色标
    pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)","(d)"/)
    ; pres@lbOrientation         = "vertical"
    ; pres@lbTitleString      = "unit: m/s"
    ; pres@lbTitleFontHeightF = 0.0125
    ; pres@lbTitleJust        = "topLeft"
    
    ; pres@amJust                = "TopLeft" ;调整标签顺序

    gsn_panel(wks,plot,(/2,2/),pres)
end