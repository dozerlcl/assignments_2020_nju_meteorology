大气动力学 作业2 NCL绘图脚本，处理FNL数据<br>
按照下面的顺序进行运行：<br>
fnl_grib2.ncl 提取需要的fnl文件变量，并进行整合（时间上进行了合并）<br>
*h_lat.ncl 是高度 纬度（进行纬向平均之后的剖面图）<br>
isent_1.ncl 是来自ncl官方示例的插值到等位温面的示例脚本<br>
    参考的脚本位置：https://www.ncl.ucar.edu/Applications/isent.shtml<br>
    http://www.ncl.ucar.edu/Applications/iso.shtml<br>
<br>
## REMARK:
fnl数据的一月和七月的uv的高度场不太一致，这里进行了插值处理
## OUTLINE:<br>
vorticity_hgt_lat.ncl                   绘制 hgt x lat 的绝对涡度，相对涡度剖面图<br>
POT_hgt_lat.ncl                         绘制 hgt x lat 的位温 剖面图<br>
POT_vort_hgt_lat.ncl                    绘制位势涡度 等压面上<br>
    remark：一月和七月的风速的等压面不一样 一月31个七月34个 <br>
    坐标名分别是 lv_ISBL0 和 lv_ISBL5   注意区别（脚本里会有进行插值处理的部分）<br>
POT_vort_theta_lat.ncl                  绘制等位温面上的位势涡度<br>
POT_vort_theta_330K_precount.ncl        计算330K的位势涡度，给下一步画图做准备<br>
POT_vort_theta_330K.ncl                 绘制330L的位势涡度<br>
HGT_500hPa.ncl                          绘制500hPa位势高度<br>
    

