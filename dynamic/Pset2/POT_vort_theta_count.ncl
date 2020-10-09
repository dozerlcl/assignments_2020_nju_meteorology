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
    ph         = conform(temper_ave, temper_ave&lv_ISBL0, (/0/))
    
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