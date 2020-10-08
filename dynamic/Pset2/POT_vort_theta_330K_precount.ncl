;       10.07   动力课作业2 P2
;               
;       10.08   添加pot_vort 的输出，为进一步绘图做准备
;               绘制lat x lon x 330K 的位势涡度,并保存，准备绘图
;               remark：FNL数据的问题，u,v垂直坐标 一月是lv_isbl0 七月是lv_isbl5
begin
    month_select = "07"
    path_in = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_"+month_select+"/"
    path_in_filenames = "fnlvars_vort.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    ; printVarSummary(f)
    ; (/"UGRD_P0_L100_GLL0","VGRD_P0_L100_GLL0","TMP_P0_L100_GLL0"/)
    temper  = f->$"TMP_P0_L100_GLL0"$    ;  [time | 124] x [lv_ISBL0 | 31] x [lat_0 | 181] x [lon_0 | 360]
    path_in_filenames = "fnlvars_uv.nc"
    f     = addfile(path_in+path_in_filenames,"r")
    u_comp  = f->$"UGRD_P0_L100_GLL0"$
    v_comp  = f->$"VGRD_P0_L100_GLL0"$
    temper = temper(:,:,::-1,:)
    u_comp = u_comp(:,:,::-1,:)
    v_comp = v_comp(:,:,::-1,:)
    ; printVarSummary(temper)
    ; print(u_comp&lat_0)
    ;   must be S-N order
    temper_ave = dim_avg_n_Wrap(temper(time|:, lv_ISBL0|:, lat_0|:, lon_0|:), (/0/))
    u_ave_or   = dim_avg_n_Wrap(u_comp(time|:, lv_ISBL5|:, lat_0|:, lon_0|:), (/0/)) ; change 一月是lv_isbl0 七月是lv_isbl5
    v_ave_or   = dim_avg_n_Wrap(v_comp(time|:, lv_ISBL5|:, lat_0|:, lon_0|:), (/0/)) ; change 

    if(month_select.eq."07") then
    ;;; interpolate different isosurface
    u_ave      = int2p_n_Wrap(u_ave_or&lv_ISBL5, u_ave_or, temper_ave&lv_ISBL0, 1,0) ; change
    v_ave      = int2p_n_Wrap(v_ave_or&lv_ISBL5, v_ave_or, temper_ave&lv_ISBL0, 1,0) ; change 
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
    ; pot_vort_lat = dim_avg_n_Wrap(pot_vort(lon_0|:,lv_ISBL0|:,lat_0|:), 0)

    ;;;>>> output to nc for next plot
    path_out = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/2019_"+month_select+"/"
    path_out_filenames = "POT_vort_lon_lat_lev.nc"
    system("rm -f "+path_out+path_out_filenames) ;删除目录下的同名文件
    ncdf_step1 = addfile(path_out+path_out_filenames, "c") ; c表示创建netcdf文件
    ncdf_step1->$"POT_vort"$=pot_vort ;写入变量数值

end