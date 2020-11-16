; 10.28 GC homework 1
; /HGST_SATA_8T_3/yycheng/playground/test_src/general_c/Pset1/dataset
begin
;;;>>>>> data reader
    file_path_in = "/HGST_SATA_8T_3/yycheng/playground/test_src/general_c/Pset1/dataset"
    f_in         = addfile(file_path_in+"/uwnd.mon.mean.nc", "r")
    ;;; NCL has this builtin. Use the function short2flt to read the netCDF fileswhere the data is packed.
    ;;; 解决资料设置 offset 的办法：https://psl.noaa.gov/data/gridded/faq.html#3
    ;;; 偷懒，不修改变量名字了
    temp_air     = short2flt(f_in->$"uwnd"$) ; time x level x lat x lon
    ; print(temp_air)
;;;>>>>> get DJF & JJA
    time_bc = cd_calendar(temp_air&time, 0) 
    ind_DJF = ind(time_bc(:,1).eq.1.or.time_bc(:,1).eq.2.or.time_bc(:,1).eq.12)
    temp_DJF  = temp_air(ind_DJF,:,:,:)

    ind_JJA = ind(time_bc(:,1).eq.6.or.time_bc(:,1).eq.7.or.time_bc(:,1).eq.8)
    temp_JJA  = temp_air(ind_JJA,:,:,:)

    ave_temp_DJF = dim_avg_n_Wrap(temp_DJF(time|:,lon|:,level|:,lat|:), (/0,1/))
    ave_temp_JJA = dim_avg_n_Wrap(temp_JJA(time|:,lon|:,level|:,lat|:), (/0,1/))
    ; printVarSummary(ave_temp_DJF)
    ; printMinMax(ave_temp_DJF, 1)
    ;;;>>>进行作图 ： 时间剖面图(未做调整，检查用)
    wks   = gsn_open_wks ("png", "./output_pic"+"/UWIND_h_lat")          ; send graphics to PNG file
    ; plot = new(3, graphic)
    res                      = True                 ; plot mods desired
    res@gsnDraw = False
    res@gsnFrame = False
    res@cnInfoLabelOn = False
      res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
      res@cnLevelSpacingF      = 4.0                  ; contour spacing
      res@cnMinLevelValF       = -40.                 ; min level
      res@cnMaxLevelValF       = 40.                 ; max level
    res@lbLabelBarOn        = False             ; turn on  individual cb's
    ; res@lbLabelBarOn        = False            ; turn off individual cb's
    res@cnLineLabelsOn       = True                 ; turn on line labels
    res@cnFillOn             = True                 ; turn on color fill
    res@cnFillPalette        = "BlWhRe"             ; choose colormap


    res@lbBoxEndCapStyle     = "TriangleBothEnds"
    ; res@lbTitleString      = "unit: K"
    res@lbTitleFontHeightF = 0.0125
    ; res@gsnPanelMainString   = "Jul"
    res@gsnLeftString        = " "
    ; print(pot_temper&lev)
    ; upper boundary is 100hpa
    ; record number 13 for jul and 10 for jan
    plot = new(2, graphic)
    res@gsnCenterString      = "DJF"
    plot(0)  = gsn_csm_pres_hgt(wks, ave_temp_DJF(0:11,:), res )   ; place holder
    res@gsnCenterString      = "JJA"
    plot(1)  = gsn_csm_pres_hgt(wks, ave_temp_JJA(0:11,:), res )   ; place holder
    ; plot(1)  = gsn_csm_pres_hgt(wks, earth_vort, res )   ; place holder
    ; plot(2)  = gsn_csm_pres_hgt(wks, compare_vort, res )   ; place holder

    pres = True
    pres@txString              = "UWIND"
    pres@gsnPanelLabelBar      = True ; 公用一个色标
    pres@gsnPanelFigureStrings = (/"(a)","(b)"/)
    ; pres@lbOrientation         = "vertical"
    ; pres@lbTitleString      = "unit: m/s"
    ; pres@lbTitleFontHeightF = 0.0125
    pres@lbTitleJust        = "topLeft"
    
    ; pres@amJust                = "TopLeft" ;调整标签顺序

    gsn_panel(wks,plot,(/1,2/),pres)

end