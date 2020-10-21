;       10.07   动力课作业2 P2
;               计算，等压面上的位势涡度
;               使用ncl函数 https://www.ncl.ucar.edu/Document/Functions/Contributed/pot_vort_isobaric.shtml
;               计算量较大,进行三个变量的平均加上为 位势涡函数的使用 pot_vort 大约20s  准备一个缓存数据
;       10.08   添加pot_vort 的输出，为进一步绘图做准备
begin
    month_select = "01"
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_" + month_select + "/"
    path_in_filenames = "fnlvars_vort.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    temper  = f->$"TMP_P0_L100_GLL0"$    ;  [time | 124] x [lv_ISBL0 | 31] x [lat_0 | 181] x [lon_0 | 360]
    ; printVarSummary(f)
    ; (/"UGRD_P0_L100_GLL0","VGRD_P0_L100_GLL0","TMP_P0_L100_GLL0"/)
        path_in_filenames = "fnlvars_uv.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    u_comp  = f->$"UGRD_P0_L100_GLL0"$
    v_comp  = f->$"VGRD_P0_L100_GLL0"$
    temper = temper(:,:,::-1,:)
    u_comp = u_comp(:,:,::-1,:)
    v_comp = v_comp(:,:,::-1,:)
    ; print(u_comp&lat_0)
    ; printVarSummary(temper&lv_ISBL0)
    ; printVarSummary(u_comp&lv_ISBL5)
    ; print(temper&lv_ISBL0)
    ; print(u_comp&lv_ISBL5)
    ;   must be S-N order and Jan for lv_ISBL0 Jul for lv_ISBL5
    temper_ave = dim_avg_n_Wrap(temper(time|:, lv_ISBL0|:, lat_0|:, lon_0|:), (/0/))
    u_ave_or   = dim_avg_n_Wrap(u_comp(time|:, lv_ISBL0|:, lat_0|:, lon_0|:), (/0/))
    v_ave_or   = dim_avg_n_Wrap(v_comp(time|:, lv_ISBL0|:, lat_0|:, lon_0|:), (/0/))

    if(month_select.eq."07") then
    ;;; interpolate different isosurface
    u_ave      = int2p_n_Wrap(u_ave_or&lv_ISBL5, u_ave_or, temper_ave&lv_ISBL0, 1,0)
    v_ave      = int2p_n_Wrap(v_ave_or&lv_ISBL5, v_ave_or, temper_ave&lv_ISBL0, 1,0)
    end if
    if(month_select.eq."01") then
    ;;; same levels. do not change
    u_ave      = u_ave_or
    v_ave      = v_ave_or
    end if
    print("-----------start count potiential vort----------------")
    pot_vort  = pot_vort_isobaric(temper_ave&lv_ISBL0, u_ave, v_ave, temper_ave, temper_ave&lat_0, 1, 0)
    
    ; printVarSummary(pot_vort)
    ; pot_vort [lv_ISBL0 | 31] x [lat_0 | 181] x [lon_0 | 360]
    pot_vort_lat = dim_avg_n_Wrap(pot_vort(lon_0|:,lv_ISBL0|:,lat_0|:), 0)

    ;;;>>> output to nc for next plot
    path_out = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_"+month_select+"/"
    path_out_filenames = "POT_vort_lat_time.nc"
    system("rm -f "+path_out+path_out_filenames) ;删除目录下的同名文件
    ncdf_step1 = addfile(path_out+path_out_filenames, "c") ; c表示创建netcdf文件
    ncdf_step1->$"POT_vort"$=pot_vort_lat ;写入变量数值

    ;;;>>>进行作图 ： 时间剖面图(未做调整，检查用)
    wks   = gsn_open_wks ("png", "./output_pic/"+month_select+"/POT_vort_h_lat" )          ; send graphics to PNG file
    pot_vort_lat!0   = "lev"
    pot_vort_lat&lev@units = "Pa"
    pot_vort_lat = pot_vort_lat*1e+6 ; unit 1e-6
    pot_vort_lat@units = pot_vort_lat@units + " *1e-6"
    ; plot = new(3, graphic)
    res                      = True                 ; plot mods desired
    ; res@gsnDraw = False
    ; res@gsnFrame = False
    res@cnInfoLabelOn = False
    res@cnLevelSelectionMode = "ExplicitLevels"       
    ; res@cnLevelSelectionMode = "ManualLevels"       
    res@cnLevels            = (/-16,-14,-12,-10,-8,-6,-4,-2,-1.5,-1,-0.5,0,0.5,1,1.5,2,4,6,8,10,12,14,16/)
      ; res@cnLevelSpacingF      = 5                  ; contour spacing
      ; res@cnMinLevelValF       = -16.                 ; min level
      ; res@cnMaxLevelValF       =  16.                 ; max level

    res@lbLabelBarOn        = True             ; turn on  individual cb's
    ; res@lbLabelBarOn        = False            ; turn off individual cb's
    res@cnLineLabelsOn       = True                 ; turn on line labels
    res@cnFillOn             = True                 ; turn on color fill
    res@cnFillPalette        = "BlWhRe"             ; choose colormap
    res@gsnCenterString      = "Jan"
    ;   res@lbOrientation        = ""
    ;   res@tiYAxisString        = u&lev@long_name + " (" + u&lev@units + ")"   
    ; Note: u is already on pressure levels. If this were model data, it
    ; would be necessary to interpolate from the hybrid coordinates to 
    ; pressure levels.
    ; upper boundary is 100hpa
    ; record number 13 for jul and 10 for jan
    plot  = gsn_csm_pres_hgt(wks, pot_vort_lat(10:,:), res)   ; place holder

end