
;MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
; Author  : Mengyuan Mu
; Version : 1.0 (2021-08-04)
; Email   : mu.mengyuan815@gmail.com
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

;*******************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;*******************************************

begin

;______ From Mark Decker's code ______
setvalues NhlGetWorkspaceObjectId()
  "wsMaximumSize" : 5000000000 ;
end setvalues
;_____________________________________

; ================================== Options ===================================
year_s      = 2017
year_e      = 2019
scale       = "SE-AU"

PFT         = new((/241,281/),integer,-9999999)
WTD         = new((/241,281/),float)
PFT         = -9999999
WTD         = 0.

do year  = year_s,year_e
  filename_hw = "/g/data/w35/mm3972/model/cable/runs/AWAP_pumping/CTL-30x3+30yr/outputs-daily/cable_out_"+year+"_SE_Aus.nc"
  f           = addfile (filename_hw,"r")
  WTD         = WTD + dim_avg_n_Wrap(f->WatTable(:,:,:),0)
  ; delete(f)
end do
PFT = f->iveg
PFT = where(PFT .eq. 2, 1, PFT)
PFT = where(PFT .eq. 5, 2, PFT)
PFT = where(PFT .eq. 6, 3, PFT)
PFT = where(PFT .eq. 9, 4, PFT)
PFT = where(PFT .eq. 14,5, PFT)
print(get_unique_values(PFT))

WTD = WTD/3.
WTD@_FillValue = f->WatTable@_FillValue
WTD!0 = "lat"
WTD!1 = "lon"
WTD&lat = f->y ;fspan(-40,-28,241)
WTD&lon = f->x ;fspan(140,154,281)
printVarSummary(WTD)

; ================================= Plotting ===================================
res                    = True
res@gsnDraw            = True  ; Don't draw plots
res@gsnFrame           = True  ; ����ҳ
res@gsnMaximize        = False

res@cnFillOn                = True
res@cnMissingValFillColor   = "gray80"
res@cnFillBackgroundColor   = "gray80"

res@cnFillMode         = "RasterFill"            ; Raster Mode
res@cnFillOn           = True                    ;��ɫ
res@lbLabelBarOn           = True
res@vpHeightF 	           = 0.38               ; change aspect ratio of plot
res@vpWidthF 	             = 0.38
res@txFontHeightF          = 0.015            ; change title font heights
res@tiYAxisFontThicknessF  = 3.
res@tmBorderThicknessF     = 3.
res@tmXBMajorThicknessF    = 3.
res@tmXBMinorThicknessF    = 3.
res@tmYLMajorThicknessF    = 3.
res@tmYLMinorThicknessF    = 3.
res@tmYLLabelFontThicknessF= 3.
res@tmBorderThicknessF     = 3.


;************** ����labelbar ***************
res@lbBoxLinesOn       = True                       ;�ر�lbar box ����
; res@lbTitleFont        = 25
; res@lbLabelFont        = 25
res@lbTitleFontHeightF = 0.015
res@lbLabelFontHeightF = 0.015
res@txString           = ""
; res@tmXBLabelFont      = 25 ;Sets the font index for the bottom X-Axis labels.
; res@tmYLLabelFont      = 25
res@pmLabelBarHeightF       = 0.08
res@pmLabelBarParallelPosF  = 0.5
res@pmLabelBarOrthogonalPosF= 0.09

;*************** ���õ�ֵ�� *****************
res@cnLinesOn          = False                       ; �رյ�ֵ������
res@cnLineColor        = "black"
res@cnLineThicknessF   = 1.5
res@cnLineLabelsOn     = False
res@gsnMaximize        = True
res@cnExplicitLabelBarLabelsOn = True   ;?
res@cnLevelSelectionMode = "ExplicitLevels"

;************ ����������ֵ��Χ **************
res@tmXBLabelFontThicknessF = 0.015
res@tmYLLabelFontThicknessF = 0.015
res@tmXBLabelFontHeightF    = 0.015
res@tmYLLabelFontHeightF    = 0.015
res@tmYLMode                = "Explicit"
res@tmXBMode                = "Explicit"

res@gsnMaximize         = True
res@gsnLeftString       = ""
res@gsnRightString      = ""


res@cnFillMode             = "RasterFill"            ; Raster Mode
res@cnFillOn               = True                            ;��ɫ
res@cnLinesOn              = False
res@cnLineLabelsOn         = False
res@cnExplicitLabelBarLabelsOn = True   ;?
res@cnLevelSelectionMode   = "ExplicitLevels"

res@lbLabelBarOn           = True
res@lbBoxLinesOn           = True                       ;�ر�lbar box ����
res@lbOrientation          = "horizontal";"vertical" ;"horizontal"
; res@lbTitleFont            = 25
; res@lbLabelFont            = 25
res@lbTitleFontHeightF     = 0.013
res@lbLabelFontHeightF     = 0.013

; res@tmXBLabelFont           = 25 ;Sets the font index for the bottom X-Axis labels.
; res@tmYLLabelFont           = 25
res@tmXBLabelFontThicknessF = 0.015
res@tmYLLabelFontThicknessF = 0.015
res@tmXBLabelFontHeightF    = 0.015
res@tmYLLabelFontHeightF    = 0.015
; res@mpDataBaseVersion       = "HighRes"

res@lbLabelBarOn            = True
res@tmYLMode                = "Explicit"
res@tmXBMode                = "Explicit"
res@txString                = ""
res@gsnLeftString           = ""
res@gsnRightString          = ""

if scale .eq. "Global" then
  res@trYMinF         = -60
  res@trYMaxF         = 80
  res@mpMinLatF       = -60
  res@mpMaxLatF       = 80
  res@mpCenterLonF    = 160
  res@tmYLMode        = "Explicit"
  res@tmYLValues      =(/60,30,0,-30,-60/)
  res@tmYLLabels      =(/"60~S~o~N~N","30~S~o~N~N","0~S~o~N~","30~S~o~N~S","60~S~o~N~S"/)
  res@tmXBMode        = "Explicit"
  res@tmXBValues      =(/240,300,0,60,120,180/)
  res@tmXBLabels      =(/"120~S~o~N~W","60~S~o~N~W","0~S~o~N~","60~S~o~N~E","120~S~o~N~E","180~S~o~N~"/)
else if scale .eq. "SE-AU" then
  res@gsnAddCyclic    = False
  res@trYMinF         = -40.
  res@trYMaxF         = -28.
  res@mpMinLatF       = -40.
  res@mpMaxLatF       = -28.
  res@trXMinF         = 140.
  res@trXMaxF         = 154.
  res@mpMinLonF       = 140.
  res@mpMaxLonF       = 154.
  res@tmYLMode        = "Explicit"
  res@tmYLValues      = (/-40,-35,-30,-25/)
  res@tmYLLabels      = (/"40~S~o~N~S","35~S~o~N~S","30~S~o~N~S","25~S~o~N~S"/)
  res@tmXBMode        = "Explicit"
  res@tmXBValues      = (/140,145,150/)
  res@tmXBLabels      = (/"140~S~o~N~E","145~S~o~N~E","150~S~o~N~E"/)
else if scale .eq. "AU" then
  res@gsnAddCyclic    = False
  res@trYMinF         = -44
  res@trYMaxF         = -10
  res@mpMinLatF       = -44
  res@mpMaxLatF       = -10
  res@trXMinF         = 112
  res@trXMaxF         = 154
  res@mpMinLonF       = 112
  res@mpMaxLonF       = 154
  res@tmYLMode        = "Explicit"
  res@tmYLValues      = (/-40,-35,-30,-25,-20,-15,-10/)
  res@tmYLLabels      = (/"40~S~o~N~S","35~S~o~N~S","30~S~o~N~S","25~S~o~N~S","20~S~o~N~S","15~S~o~N~S","10~S~o~N~S"/)
  res@tmXBMode        = "Explicit"
  res@tmXBValues      = (/115,120,125,130,135,140,145,150/)
  res@tmXBLabels      = (/"115~S~o~N~E","120~S~o~N~E","125~S~o~N~E","130~S~o~N~E","135~S~o~N~E","140~S~o~N~E","145~S~o~N~E","150~S~o~N~E"/)
end if
end if
end if

; ================================= Plot WTD ===================================
pic1 = "./plots/FigS5_WTD_2017-2019"
wks1 = gsn_open_wks("pdf",pic1)
gsn_define_colormap(wks1,"GMT_haxby");"WhiteBlueGreenYellowRed") ;"ViBlGrWhYeOrRe") ;"BlueYellowRed")

; _____________ Colorbar ____________
; Blue
cmap  = (/ (/247.,252,240,1/), (/224,243,219,1/), (/204,235,197,1/),                     \
            (/168,221,181,1/), (/123,204,196,1/),  (/78,179,211,1/),  (/43,140,190,1/),  \
            (/8,104,172,1/),    (/  8,64,129,1/),    (/2,56,88,1/),   (/8,29,88,1/)      /)

cmap(:,0:2) = cmap(:,0:2)/255.
; res@lbTitleString   = "WTD (m)"
; res@lbTitlePosition = "Bottom"
levels = fspan(1,11,11)
res@cnLevels = levels
res@cnFillPalette = cmap(::-1,:)
plots = gsn_csm_contour_map(wks1,WTD,res)
delete(levels)
delete(res@cnLevels)
delete(res@cnFillPalette)
; delete(res@lbTitleString)


; ================================= Plot PFT ===================================
pic2 = "./plots/FigS2a_PFT_map"
wks2 = gsn_open_wks("pdf",pic2)
gsn_define_colormap(wks2,"drought_severity");"WhiteBlueGreenYellowRed") ;"ViBlGrWhYeOrRe") ;"BlueYellowRed")
levels = (/1.1,2.1,3.1,4.1/)
res@lbLabelsOn                 = True
res@cnExplicitLabelBarLabelsOn = True
res@lbLabelStrings             = (/"evergreen~C~broadleaf~C~forest",\
                                   "shrub~C~ ~C~ ", "grassland~C~ ~C~ ", "cropland~C~ ~C~ ",\
                                   "barren~C~land~C~ "/)
res@lbTitleFontHeightF         = 0.01
res@lbLabelFontHeightF         = 0.01
res@pmLabelBarParallelPosF     = 0.5
res@pmLabelBarOrthogonalPosF   = 0.13
; res@lbLabelPosition            = "right"
res@lbLabelJust                = "bottomcenter"
res@lbLabelAlignment           = "BoxCenters"
; res@lbLabelOffsetF             = -0.1
res@cnLevels = levels
plots = gsn_csm_contour_map(wks2,PFT,res)

; ________________ add order name ________________
pres                            = True
pres@wkWidth                    = 2500
pres@wkHeight                   = 2500
pres@gsnMaximize                = False
pres@gsnPanelYWhiteSpacePercent = 0.1
pres@gsnPanelXWhiteSpacePercent = 0.1

txres                           = True
txres@txPerimOn                 = False
txres@txFont                    = 25
txres@txFontHeightF             = 0.04
amres                           = True
amres@amParallelPosF            = -0.45    ; This is the right edge of the plot.
amres@amOrthogonalPosF          = -0.45    ; This is the bottom edge of the plot.
amres@amJust                    = "TopLeft"

txid  = gsn_create_text(wks2, "(a)", txres)
annoid = gsn_add_annotation(plots, txid, amres)
gsn_panel(wks2,plots,(/1,1/),pres)
; cmp = read_colormap_file("drought_severity")
; print(cmp)


end
