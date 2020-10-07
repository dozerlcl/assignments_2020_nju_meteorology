;   10.07 处理动气作业需要的fnl资料。原始是grib2
;           works：将 dir 目录下的fnl文件全部读取，再path_out目录下输出
;                   选取select_varnames中的所有变量进行逐一输出，输出文件名是path_out_filenames
;   用于检查文件f_fnl正确性的函数pvs,输出结果放在同目录下的fnl_vars_log 中，展示了fnl数据的变量数量
undef("pvs")
procedure pvs(x)
local i,varnames
begin
    printVarSummary(x)

    if (isfile(x))then
        varnames = getfilevarnames(x)
        if(.not.any(ismissing(varnames))) then
            do i=0,dimsizes(varnames)-1
                printFileVarSummary (x,varnames(i))
            end do
        end if
    end if

end

begin
;;;>>>>> data reader
    ;   input dir & file_names
;;;-------------------------------input files parameters----------------------------
    dir          = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl/"
    file_names   = systemfunc("cd "+dir+"; ls fnl*")
    ;   output path & varnames
    ; select_varnames = (/"MSLET_P0_L101_GLL0","TSOIL_P0_2L106_GLL0"/)
    select_varnames = (/"ABSV_P0_L100_GLL0","TMP_P0_L100_GLL0"/)
    path_out = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/"
    path_out_filenames = "vars_p1.nc"
    netCDF = True ;   switch,是否将CPC资料存放为nc格式数据
;;;----------------------------------------------------------------------------------
    ; printVarSummary(file_names)
    dim_file_names   = dimsizes(file_names)  ;   放置CMORPH文件夹中所有的文件名
    file_names_c     = tochar( file_names )        ;   拆分文件名

    f_fnl = addfiles(dir+file_names,"r")
    ListSetType(f_fnl,"join") ; 打开多个文件并且返回文件句柄（批量读入后实质上是一个list, 这样使得维度不会混乱

;;;>>>>>add time coordinates
    ;   fnl grib2 没找到合适的时间属性，这里自己添加
    ;   char to string
    ;   YYYY 4-7 MM 8-9 DD 10-11 HH 13-14 mn 16-17 ss=0
    yyyy = stringtointeger(chartostring(file_names_c(:,4:7)))
    mm   = stringtointeger(chartostring(file_names_c(:,8:9)))
    dd   = stringtointeger(chartostring(file_names_c(:,10:11)))
    hh   = stringtointeger(chartostring(file_names_c(:,13:14)))
    mn   = stringtointeger(chartostring(file_names_c(:,16:17)))
    ss   = new(dim_file_names, float)
    ss   = 0

    time = cd_inv_calendar(yyyy, mm, dd, hh, mn, ss, "hours since 1900-01-01 00:00:00", 0)

;;;>>>>>select vars and output
if (netCDF) then
    ; select_varnames = (/"MSLET_P0_L101_GLL0","TSOIL_P0_2L106_GLL0"/)
    ; path_out = "/HGST_SATA_8T_3/yycheng/data_stage/course/fnl_2_nc/"
    ; path_out_filenames = "vars_combine.nc"
    system("rm -f "+path_out+path_out_filenames) ;删除目录下的同名文件
    ncdf_step1 = addfile(path_out+path_out_filenames, "c") ; c表示创建netcdf文件
    do i=0,dimsizes(select_varnames)-1,1
        vars       = f_fnl[:]->$select_varnames(i)$
        vars!0     = "time"
        vars&time = time
        ncdf_step1->$select_varnames(i)$=vars ;写入变量数值
        ; printVarSummary(vars)
        delete(vars)
        ; print(i)
    end do
    delete(ncdf_step1)
end if

end