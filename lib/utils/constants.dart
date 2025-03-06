import 'package:date_format/date_format.dart';

const watermarkUpdateMain = 'update_watermark_main'; // 标识修改水印本身
const watermarkUpdateCameraStatus =
    'update_watermark_camera_status'; //标识修改水印的状态（位置，大小等等）
const watermarkUpdateRightBottom = 'update_watermark_right_bottom';

const watermarkLogoLabel = '品牌图片';
const watermarkTimeLabel = '时间：';
const watermarkLocationLabel = '地点：';
const watermarkLatitudeLabel = '经纬度：';
const watermarkWeatherLabel = '天气：';
const watermarkShootPersonLabel = '拍摄人：';
const watermarkRemarkLabel = '备注：';

const double watermarkMinMargin = 6;

const List<String> watermarkTimeFormat = [
  yyyy,
  '-',
  mm,
  '-',
  dd,
  ' ',
  HH,
  ':',
  nn
];

/// 水印类型：时间
const watermarkTimeType = 'RYWatermarkTime';

const watermarkTimeDivisionType = 'RYWatermarkTimeDivision';

/// 水印类型：地址
const watermarkLocationType = 'RYWatermarkLocation';

/// 水印类型：经纬度
const watermarkCoordinateType = 'YWatermarkCoordinate';

/// 水印类型：品牌图
const watermarkBrandLogoType = 'RYWatermarkBrandLogo';

/// 水印类型：天气
const watermarkWeatherType = 'YWatermarkWeather';

/// 水印类型：海拔
const watermarkAltitudeType = 'YWatermarkAltitude';

/// 水印类型：备注
const watermarkNotesType = 'YWatermarkNotes';

/// 水印类型：自定义
const watermarkCustom1Type = 'YWatermarkCustom1';

/// 水印类型： 形状
const watermarkShapeType = 'RYWatermarkShape';

///水印类型：标题
const watermarkTitleType = 'YWatermarkTitleBar';

///一般字体表格
const watermarkTableGeneralType = 'YWatermarTableGeneral';

///自定义添加
const watermarkCustomAddSettingTable1 = "watermarkCustomAddSettingTable1";
const watermarkCustomAddSettingTable2 = "watermarkCustomAddSettingTable2";

const watermarkSignature = "watermarkSignature";

const watermarkLiveShoot = "RYWatermarkLiveShooting";

const surportWatermarkType = [
  watermarkBrandLogoType,
  watermarkTimeDivisionType,
  watermarkTimeType,
  watermarkLocationType,
  watermarkCoordinateType,
  watermarkWeatherType,
  watermarkAltitudeType,
  watermarkNotesType,
  watermarkCustom1Type,
  watermarkTitleType,
  watermarkTableGeneralType,
  watermarkCustomAddSettingTable1,
  watermarkSignature,
  watermarkLiveShoot
];

const List<String> fontNames = [
  "akshar.ttf",
  "Akshar-Medium.ttf",
  "AlimamaShuHeiTi-Bold.ttf",
  "Arial.ttf",
  "AsimovWid.otf",
  "Barlow-SemiBold.ttf",
  "BarlowSemiCondensed-SemiBold.otf",
  "BebasDaka.ttf",
  "Bebas-Regular.ttf ",
  "BW7tiScientificHalf.otf",
  "CKTKingKong.ttf",
  "DIN Alternate-Elvis.ttf",
  "DIN Condensed.ttf",
  "DIN_Alternate_Bold.ttf",
  "DINAlternate-bold.otf",
  "DINAlternate-Bold.ttf",
  "DINCOND-BOLD.OTF",
  "DINCond-BoldAlternate.otf",
  "DINPro-Bold.otf",
  "DINPro-Medium_13936.ttf",
  "DS-DIGI.ttf",
  "FangZhengHeiTi-GBK.ttf",
  "FiraSans-Bold.ttf",
  "FiraSans-Regular.ttf",
  "font134.ttf",
  "FZDH_GBK.ttf",
  "FZFangJHJW_Cu.TTF",
  "FZLTCHK--GBK1-0.ttf",
  "FZMiaoWuJW.TTF",
  "FZRuiZHK_Cu.TTF",
  "FZShuiYJW_Cu.TTF",
  "FZYTJW--GB1-0.ttf",
  "FZZZHONGHJW.TTF",
  "GDhwGoJA-OTF111b.otf",
  "Geomanist-Book.ttf",
  "hagoNumber.ttf",
  "hagoNumber-Regular.ttf",
  "HanBiaoTuBiTi-2.ttf",
  "HarmonyOS_Sans_SC_Black.ttf",
  "HarmonyOS_Sans_SC_Bold.ttf",
  "HarmonyOS_Sans_SC_Light.ttf",
  "HarmonyOS_Sans_SC_Medium.ttf",
  "HarmonyOS_Sans_SC_Regular.ttf",
  "HarmonyOS_Sans_SC_Thin.ttf",
  "HarmonyOS_SC_Bold.ttf",
  "HarmonyOS_SC_Medium.ttf",
  "HarmonyOS_SC_Regular.ttf",
  "HelveticaNeue-CondensedBold.ttf",
  "hyjk_subfont.ttf",
  "HYQiHei-65S.ttf",
  "HYQiHeiX1-75W.otf",
  "HYQiHeiX1-85W.otf",
  "HYQiHeiX2-45w_only_i.ttf",
  "HYQiHeiX2-55W.otf",
  "HYQiHeiX2-65W.otf",
  "HYQiHeiX2-85W.otf",
  "HYQiHeiX2-95W.ttf",
  "HYQiHeiX2-FEW.otf",
  "HYQiHeiX2-HEW.otf",
  "HYZhuZiMuTouRenJ.ttf",
  "HYZhuZiMuTouRenW.ttf",
  "hzgb.ttf",
  "Inter-UI-Medium-3.ttf",
  "LESLIE-Regular.ttf",
  "LiquidCrystal.otf",
  "MakingWorkshop.ttf",
  "MiSans-Medium.ttf",
  "MiSans-Regular.otf",
  "number.ttf",
  "OPPOSans-Regular.ttf",
  "Oswald-SemiBold.ttf",
  "PingFang_SC_Medium.ttf",
  "PingFangSC-Light.otf",
  "PingFangSC-Medium.otf",
  "PingFangSC-Regular.otf",
  "PingFangSC-Semibold.otf",
  "PingFangSC-Thin.otf",
  "PingFangSC-Ultralight.otf",
  "PingFangTCSemibold.otf",
  "PT Mono Bold.ttf",
  "PTMonoBold.ttf",
  "PTMono-Bold.ttf",
  "PTN77F.ttf",
  "PTSans.ttf",
  "PT-Sans-Narrow.ttf",
  "PTSansNarrowBold.ttf",
  "Quartz-Medium.otf",
  "roboto_medium_numbers.ttf",
  "RobotoSlab-Regular.ttf",
  "Sanchez-Regular.ttf",
  "Sarbaz.otf",
  "SF-Pro-Display-Medium.ttf",
  "SourceHanSansCN-VF.otf",
  "SourceHanSerifCN-SemiBold.OTF",
  "STZHONGS.TTF",
  "subset-NotoSansSC-Medium.ttf",
  "UZBUKV.TTF",
  "WangHanZongChaoMingTiFan-1.ttf",
  "water_111_bottom.ttf",
  "water_111_top.ttf",
  "Wechat_regular.otf",
  "WeiLaiYuanscRegular.ttf",
  "YouSheBiaoTiHei.ttf",
  "ZiZhiQuXiMaiTi-2.ttf",
];

const List<String> weatherIcons = [
  "sunny",
  "ella",
  "mist",
  "overcast",
  "snow_icon"
];
const List<String> weatherNames = ["晴", "阴", "雨", "多云", "雪"];

const String defultFontFamily = 'HYQiHeiX2-65W';

class Assets {
  static const String vipBg = "assets/vip/vip.png";
}
