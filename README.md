# Taiwan_Coordinate_Conversion
+ 台灣地區座標轉換 (使用MATLAB)
+ 作者: HsiupoYeh
+ 最後版本: v20210421a

### Snyder_Formula_TWD97_121toWGS84.m v20210421a
```matlab
%**************************************************************************
%   Name: Snyder_Formula_TWD97_121toWGS84.m v20210421a
%   Copyright:  
%   Author: HsiupoYeh 
%   Version: v20210421a
%   Description: 將臺灣本島的TWD97的二度分帶轉換為WGS84經緯度。
%   參考文獻: Snyder, J. P. (1987). Map projections--A working manual (Vol. 1395).
%       US Government Printing Office.(https://pubs.usgs.gov/pp/1395/report.pdf)
%   呼叫方式:
%       [WGS84_Longitude_in_degrees,WGS84_Latitude_in_degrees]=Snyder_Formula_TWD97_121toWGS84(146744.3798,2433894.6701)
%       結果: WGS84_Longitude_in_degrees = 120.0000, WGS84_Latitude_in_degrees = 22.0000
%       [WGS84_Longitude_in_degrees,WGS84_Latitude_in_degrees]=Snyder_Formula_TWD97_121toWGS84(177875.4425,2466940.6551)
%       結果: WGS84_Longitude_in_degrees = 120.3000, WGS84_Latitude_in_degrees = 22.3000
%       [WGS84_Longitude_in_degrees,WGS84_Latitude_in_degrees]=Snyder_Formula_TWD97_121toWGS84(229467.4326,2522150.7039)
%       結果: WGS84_Longitude_in_degrees = 120.8000, WGS84_Latitude_in_degrees = 22.8000
%       [WGS84_Longitude_in_degrees,WGS84_Latitude_in_degrees]=Snyder_Formula_TWD97_121toWGS84(270472.1551,2566444.0678)
%       結果: WGS84_Longitude_in_degrees = 121.2000, WGS84_Latitude_in_degrees = 23.2000
%       [WGS84_Longitude_in_degrees,WGS84_Latitude_in_degrees]=Snyder_Formula_TWD97_121toWGS84(321384.4538,2621974.9102)
%       結果: WGS84_Longitude_in_degrees = 121.7000, WGS84_Latitude_in_degrees = 23.7000
%**************************************************************************
function [WGS84_Longitude_in_degrees,WGS84_Latitude_in_degrees]=Snyder_Formula_TWD97_121toWGS84(TWD97_E_in_meters,TWD97_N_in_meters)
    %----------------------------------------------------------------------
    % 座標轉換的基礎知識:
    % 3D地球上的經緯度座標基本上就是一個立體的橢圓球體上任意位置的座標表示法。
    % 一個座標包含球體表面算起的經度、緯度、高度。
    %
    % 地球不是完美的橢圓形，不同年代及不同單位把地球規定成不同的橢圓球體。
    % 這樣的規定被稱為地球參考橢球(Earth reference ellipsoid)，包含了這個橢球的長軸短軸等基本資訊。
    % 常用的幾個地球參考橢球如下:
    % Geodetic Reference System 1967 (GRS67)
    % Geodetic Reference System 1980 (GRS80)
    % World Geodetic System 1984 (WGS84)
    % 更多地球參考橢球可查詢:https://en.wikipedia.org/wiki/Earth_ellipsoid
    % 
    % 2D地圖上的通常使用投影法將曲面投射至平面上。
    % 目前主流使用為橫麥卡托投影法(Transverse Mercator projection)。
    % 通常文獻會將經緯度轉換至投影平面的計算稱作Forword，投影平面轉回經緯度的計算稱作Inverse。    
    % 說明:https://en.wikipedia.org/wiki/Transverse_Mercator_projection
    % 另外有多個學者提出投影法的轉換公式:
    % https://en.wikipedia.org/wiki/Transverse_Mercator:_Redfearn_series
    % https://en.wikipedia.org/wiki/Transverse_Mercator:_Bowring_series
    % 但是以上的轉換公式交代的有點模糊，放棄使用。
    % 本篇選擇的轉換公式參照書籍:https://pubs.usgs.gov/pp/1395/report.pdf
    % 書名:Snyder, J. P. (1987). Map projections--A working manual (Vol. 1395).
    % US Government Printing Office.
    %
    % 橫麥卡托投影法通常有幾個規格: 二度分帶(TM2)、三度分帶(TM3)、六度分帶(TM6)，並可以指定分帶的中央經度。
    % 例如台灣會說二度分帶中央經度121 -> TM2/121
    % 其中有被規定一個通用規格:UTM，使用六度分帶，把地球分成60區，中央經度都被規定好。
    % 例如區域1是經度180度~174度，中央經度177度。
    %
    % 更完整的討論空間中的任一點在橢球上的位置，可以用不同的座標系來描述:
    % 1.大地座標系 -> 經度、緯度、高度
    % 2.地心直角坐標系 -> X,Y,Z (故意用大寫表示，這是三維空間的直角座標位置)
    % 3.投影座標系 -> E,N(x,y) (故意用小寫表示，通常是往東的x跟往北的y)
    %
    % 理想上，任意位置在同一種橢球可以任意轉換至不同座標系來表示。
    % 實際上轉換非完美，且我們有興趣的範圍基本上遠離南北極。
    %
    % 要把橢球與地球連結起來，需要選擇一個參考點作為基準，進一步在參考點以外的
    % 位置進行大地測量，不同年代、不同單位選擇了橢球之外，還訂定了各自的大地基
    % 準參考(Geodetic datum，或簡稱datum)。
    % 例如:
    % 台灣使用的大地基準:
    % Hu-Tzu-Shan datum -> 球體=International(1924), 基準原點=南投埔里虎子山一等三角點
    % TWD67 datum -> 球體=GRS67,基準原點=南投埔里虎子山一等三角點
    % TWD97 datum -> 球體=GRS80,基準=GPS衛星定位技術(ITRF94@1997.0參考框架；BIH 1984.0參考方位)
    % WGS84 datum -> 球體=WGS84,基準=新地球模型(質量中心為中心點，加上了分布在全世界各地的1500個地理座標參考點)
    % 
    % 簡單的說，當被稱為datum時，就會包含橢球及基準。
    % 通常，區域型的datum適用的座標範圍較窄小，但也往往在投影時造成的扭曲影響
    % 較少，因此許多單位有各種不同的大地基準。
    % 為了方便使用，目前主流是採用WGS84 datum 的經緯度作為主要交換資料。
    %
    % 同一種橢球且使用同樣的基準，可以將座標任意轉換，包含:經緯度、球心為原點的
    % 三維XYZ資料、投影的二維EN資料。
    % 只要基準不同，在座標轉換之前就要先進行基準轉換。基準轉換的計算都是在球心
    % 為原點的三維XYZ資料中處理。例如常見的轉換流程是:
    % 先:
    % WGS84 datum(球體=WGS84) 的經緯度資料 -> WGS84 datum(球體=WGS84) 的XYZ資料 
    % -> TWD97 datum(球體=GRS80) 的XYZ資料 
    % 再:
    % (1) TWD97 datum(球體=GRS80) 的XYZ資料 -> TWD97 datum(球體=GRS80) 的經緯度資料 -> TWD97 datum(球體=GRS80) 的EN資料 
    % (2) TWD97 datum(球體=GRS80) 的XYZ資料 -> TWD97 datum(球體=GRS80) 的EN資料 
    %
    % 在台灣地區，TWD97 datum 與 WGS84 datum 的經緯度資料差異很小，在多數應用中
    % 被視為可忽略的差異，因此轉換方式就變得非常簡潔:
    % WGS84 datum(球體=WGS84) 的經緯度資料 = TWD97 datum(球體=GRS80) 的經緯度資料 -> TWD97 datum(球體=GRS80) 的EN資料
    % 
    % 因此，WGS84 datum經緯度 轉 TWD97 datum TM2資料的計算方法可簡化為:
    % TWD97 datum的經緯度數值直接使用WGS84 datum經緯度，球體參數採用GRS80，來計算投影的EN資料
    % 
    % 同理，也可以選擇:
    % WGS84 datum經緯度，球體參數採用WGS84，來計算投影的EN資料，將會有些微的差異。
    %----------------------------------------------------------------------
    % 座標參考系統(Coordinate Reference Systems,CRS)
    % 歐洲石油調查組織(European Petroleum Survey Group,EPSG)所建立，目前被繼續使用
    % 的EPSG大地參數資料庫，用EPSG加上數字整理了各地來註冊的大地參數。
    % 也就是一個EPSG對應一個CRS
    %--
    % 主要要關心的是跟台灣有關的:
    % EPSG:4326 -> WGS84
    % EPSG:3825 -> TWD97 TM2 zone 119(二度分帶離島澎湖119經度)
    % EPSG:3826 -> TWD97 TM2 zone 121(二度分帶臺灣本島121經度)
    %----------------------------------------------------------------------
    % 要做轉換之前先說明清楚通用的定義，二度分帶在直角坐標系中X正向朝右，Y正向朝上，
    % 經緯度就是經度在X方向，緯度在Y方向。不要討論地球繞一圈經緯度超過角度等問題，簡
    % 單想X正向是朝向東邊，Y正向是朝向北邊。
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % 以下的轉換公式就是輸入TWD97台灣本島的二度分帶座標(單位:[m])，再輸出WGS84的經緯度(單位:[度])
    % (1)假設TWD97的經緯度與WGS84的經緯度相同
    % (2)用TWD97的經緯度套用Snyder(1987)的公式，公式內用到的橢球參數都來自TWD97參考的GRS80。
    % (3)公式使用的是沒有經過False Easting、False northing修正的，因此要先去掉修正。
    %--------------------------------------------------------------------------
    % TWD97二度分帶，以臺灣本島121經度作為中央經線的參數
    % 計算用的真實原點定為:
    %   緯度原點(Latitude origin)=0度(赤道)
    %   中央經度(Central meridian)=121度(臺灣本島，東引)
    % 中央經線投影尺度比:
    %   尺度縮放因子(Scale factor)=0.9999
    % 網格繪圖用的網格原點修正:
    %   False Easting=250000公尺 (這英文很容易記錯，依照其意義被翻譯為座標西移量)
    %   False northing=0公尺 (這英文很容易記錯，依照其意義被翻譯為座標南移量)
    % 原點網格修正是用在UTM時避免轉換出來的數值有負值存在而設計的，可想像真實原點121
    % 度就是對應到第250000公尺，適用範圍內的經度120.5度依舊還是正值但小於250000公尺。
    %--
    % 中央經線轉成弧度
    TWD97_Lambda0=121./180.*pi;
    % 中央經線投影尺度比
    TWD97_k0=0.9999;
    % 網格原點修正，單位[m]。
    TWD97_E0=250000;%False_Easting_in_meter_E0=250000;
    TWD97_N0=0;%False_northing_in_meter_N0=0;
    %--
    % TWD97的參考橢球體參數(球體=GRS80)
    % 半長軸a，對應地球的赤道半徑(Equatorial Radius)，單位[m]。
    TWD97_a=6378137;
    % 半短軸b，對應地球的極半徑(Polar Radius)，單位[m]。
    TWD97_b=6356752.314245;
    %----------------------------------------------------------------------
    % 轉換公式來自Snyder(1987)的Section8中的FORMULAS FOR THE ELLIPSOID
    % 以下公式相關的變數都用Snyder開頭，方便對照。
    % 輸入項目:
    % Snyder_x -> 投影座標系上的E，單位[m]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_x=TWD97_E_in_meters-TWD97_E0;
    % Snyder_y -> 投影座標系上的N，單位[m]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_y=TWD97_N_in_meters-TWD97_N0;
    % 輸出項目:
    % Snyder_Phi -> 緯度，單位[rad]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    % Snyder_Lambda -> 經度，單位[rad]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    %--
    % Snyder_Lambda0 -> 中央經度，單位[rad]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_Lambda0=TWD97_Lambda0;%TWD97本島的中央經度121度。
    % Snyder_Phi0 -> 中間緯度，單位[rad]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    % Snyder_Phi0=0;%TWD97本島，這項目前用不到所以註解掉。
    % Snyder_a -> 的半長軸a，對應地球的赤道半徑(Equatorial Radius)，單位[m]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_a=TWD97_a;%TWD97的。
    % Snyder_b -> 半長軸a，對應地球的赤道半徑(Equatorial Radius)，單位[m]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_b=TWD97_b;%TWD97的。    
    % Snyder_k0 -> 中央經線投影尺度比。
    Snyder_k0=TWD97_k0;%TWD97的。     
    %--
    % Snyder_e_square -> Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_e_square=1-Snyder_b^2/Snyder_a^2;
    % Snyder_e_prime_square -> Snyder(1987)的公式(8-12)
    Snyder_e_prime_square=Snyder_e_square/(1-Snyder_e_square);
    % Snyder_M0 -> Snyder(1987)的公式(3-21)
    % Snyder_M0=Snyder_a*(...
    %        (1-Snyder_e_square/4-3*Snyder_e_square^2/64-5*Snyder_e_square^3/256)*Snyder_Phi0- ...
    %        (3*Snyder_e_square/8+3*Snyder_e_square^2/32+45*Snyder_e_square^3/1024)*sin(2*Snyder_Phi0)+ ...
    %        (15*Snyder_e_square^2/256+45*Snyder_e_square^3/1024)*sin(4*Snyder_Phi0)- ...
    %        (35*Snyder_e_square^3/3072)*sin(6*Snyder_Phi0) ...
    %    );
    % 當Snyder_Phi0=0的時候，Snyder_M0=0。省去M0的計算直接給值。
    Snyder_M0=0;
    %      
    % Snyder_e1 -> Snyder(1987)的公式(3-24)
    Snyder_e1=(1-sqrt(1-Snyder_e_square))/(1+sqrt(1-Snyder_e_square));
    % Snyder_M -> Snyder(1987)的公式(8-20)
    Snyder_M=Snyder_M0+Snyder_y/Snyder_k0; 
    % Snyder_Mu -> Snyder(1987)的公式(7-19)
    Snyder_Mu=Snyder_M/(...
            Snyder_a*( ...
                1-Snyder_e_square/4-3*Snyder_e_square^2/64-5*Snyder_e_square^3/256 ...
            ) ...
        );       
    % Snyder_Phi1 -> Snyder(1987)的公式(3-26)
    Snyder_Phi1=Snyder_Mu+ ...
        (3*Snyder_e1/2-27*Snyder_e1^3/32)*sin(2*Snyder_Mu)+ ...
        (21*Snyder_e1^2/16-55*Snyder_e1^4/32)*sin(4*Snyder_Mu)+ ...
        (151*Snyder_e1^3/96)*sin(6*Snyder_Mu)+ ...
        (1097*Snyder_e1^4/512)*sin(8*Snyder_Mu);
    % Snyder_C1 -> Snyder(1987)的公式(8-21)
    Snyder_C1=Snyder_e_prime_square*cos(Snyder_Phi1)^2;
    % Snyder_T1 -> Snyder(1987)的公式(8-22)
    Snyder_T1=tan(Snyder_Phi1)^2;
    % Snyder_N1 -> Snyder(1987)的公式(8-23)
    Snyder_N1=Snyder_a/sqrt(1-Snyder_e_square*sin(Snyder_Phi1)^2);
    % Snyder_R1 -> Snyder(1987)的公式(8-24)
    Snyder_R1=Snyder_a*(1-Snyder_e_square)/(1-Snyder_e_square*sin(Snyder_Phi1)^2)^1.5;
    % Snyder_D
    Snyder_D=Snyder_x/(Snyder_N1*Snyder_k0);    
    %--
    % Snyder(1987)的公式(8-17)
    Snyder_Phi=Snyder_Phi1-(Snyder_N1*tan(Snyder_Phi1)/Snyder_R1)*( ...
            Snyder_D^2/2- ...
            (5+3*Snyder_T1+10*Snyder_C1-4*Snyder_C1^2-9*Snyder_e_prime_square)*Snyder_D^4/24+ ...
            (61+90*Snyder_T1+298*Snyder_C1+45*Snyder_T1^2-252*Snyder_e_prime_square-3*Snyder_C1^2)*Snyder_D^6/720 ...
        );
    % Snyder(1987)的公式(8-18)
	Snyder_Lambda=Snyder_Lambda0+( ...
            Snyder_D- ...
            (1+2*Snyder_T1+Snyder_C1)*Snyder_D^3/6+ ...
            (5-2*Snyder_C1+28*Snyder_T1-3*Snyder_C1^2+8*Snyder_e_prime_square+24*Snyder_T1^2)*Snyder_D^5/120 ...
        )/cos(Snyder_Phi1);
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % 臺灣本島的TWD97的二度分帶的EN座標轉回經緯度
    WGS84_Longitude_in_degrees=Snyder_Lambda*180/pi;
    WGS84_Latitude_in_degrees=Snyder_Phi*180/pi;
    %disp([num2str(WGS84_Longitude_in_degrees),',',num2str(WGS84_Latitude_in_degrees)])
    %----------------------------------------------------------------------
end
```

### Snyder_Formula_WGS84toTWD97_121.m v20210421a
```matlab
%**************************************************************************
%   Name: Snyder_Formula_WGS84toTWD97_121.m v20210421a
%   Copyright:  
%   Author: HsiupoYeh 
%   Version: v20210421a
%   Description: 將WGS84經緯度轉換為臺灣本島的TWD97的二度分帶。適用範圍經度120到122度。
%   參考文獻: Snyder, J. P. (1987). Map projections--A working manual (Vol. 1395).
%       US Government Printing Office.(https://pubs.usgs.gov/pp/1395/report.pdf)
%   呼叫方式:
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(120,22)
%       結果: TWD97_E_in_meters = 146744.3798, TWD97_N_in_meters = 2433894.6701
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(120.3,22.3)
%       結果: TWD97_E_in_meters = 177875.4425, TWD97_N_in_meters = 2466940.6551
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(120.8,22.8)
%       結果: TWD97_E_in_meters = 229467.4326, TWD97_N_in_meters = 2522150.7039
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(121.2,23.2)
%       結果: TWD97_E_in_meters = 270472.1551, TWD97_N_in_meters = 2566444.0678
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(121.7,23.7)
%       結果: TWD97_E_in_meters = 321384.4538, TWD97_N_in_meters = 2621974.9102
%**************************************************************************
function [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(WGS84_Longitude_in_degrees,WGS84_Latitude_in_degrees)
    %----------------------------------------------------------------------
    % 座標轉換的基礎知識:
    % 3D地球上的經緯度座標基本上就是一個立體的橢圓球體上任意位置的座標表示法。
    % 一個座標包含球體表面算起的經度、緯度、高度。
    %
    % 地球不是完美的橢圓形，不同年代及不同單位把地球規定成不同的橢圓球體。
    % 這樣的規定被稱為地球參考橢球(Earth reference ellipsoid)，包含了這個橢球的長軸短軸等基本資訊。
    % 常用的幾個地球參考橢球如下:
    % Geodetic Reference System 1967 (GRS67)
    % Geodetic Reference System 1980 (GRS80)
    % World Geodetic System 1984 (WGS84)
    % 更多地球參考橢球可查詢:https://en.wikipedia.org/wiki/Earth_ellipsoid
    % 
    % 2D地圖上的通常使用投影法將曲面投射至平面上。
    % 目前主流使用為橫麥卡托投影法(Transverse Mercator projection)。
    % 通常文獻會將經緯度轉換至投影平面的計算稱作Forword，投影平面轉回經緯度的計算稱作Inverse。    
    % 說明:https://en.wikipedia.org/wiki/Transverse_Mercator_projection
    % 另外有多個學者提出投影法的轉換公式:
    % https://en.wikipedia.org/wiki/Transverse_Mercator:_Redfearn_series
    % https://en.wikipedia.org/wiki/Transverse_Mercator:_Bowring_series
    % 但是以上的轉換公式交代的有點模糊，放棄使用。
    % 本篇選擇的轉換公式參照書籍:https://pubs.usgs.gov/pp/1395/report.pdf
    % 書名:Snyder, J. P. (1987). Map projections--A working manual (Vol. 1395).
    % US Government Printing Office.
    %
    % 橫麥卡托投影法通常有幾個規格: 二度分帶(TM2)、三度分帶(TM3)、六度分帶(TM6)，並可以指定分帶的中央經度。
    % 例如台灣會說二度分帶中央經度121 -> TM2/121
    % 其中有被規定一個通用規格:UTM，使用六度分帶，把地球分成60區，中央經度都被規定好。
    % 例如區域1是經度180度~174度，中央經度177度。
    %
    % 更完整的討論空間中的任一點在橢球上的位置，可以用不同的座標系來描述:
    % 1.大地座標系 -> 經度、緯度、高度
    % 2.地心直角坐標系 -> X,Y,Z (故意用大寫表示，這是三維空間的直角座標位置)
    % 3.投影座標系 -> E,N(x,y) (故意用小寫表示，通常是往東的x跟往北的y)
    %
    % 理想上，任意位置在同一種橢球可以任意轉換至不同座標系來表示。
    % 實際上轉換非完美，且我們有興趣的範圍基本上遠離南北極。
    %
    % 要把橢球與地球連結起來，需要選擇一個參考點作為基準，進一步在參考點以外的
    % 位置進行大地測量，不同年代、不同單位選擇了橢球之外，還訂定了各自的大地基
    % 準參考(Geodetic datum，或簡稱datum)。
    % 例如:
    % 台灣使用的大地基準:
    % Hu-Tzu-Shan datum -> 球體=International(1924), 基準原點=南投埔里虎子山一等三角點
    % TWD67 datum -> 球體=GRS67,基準原點=南投埔里虎子山一等三角點
    % TWD97 datum -> 球體=GRS80,基準=GPS衛星定位技術(ITRF94@1997.0參考框架；BIH 1984.0參考方位)
    % WGS84 datum -> 球體=WGS84,基準=新地球模型(質量中心為中心點，加上了分布在全世界各地的1500個地理座標參考點)
    % 
    % 簡單的說，當被稱為datum時，就會包含橢球及基準。
    % 通常，區域型的datum適用的座標範圍較窄小，但也往往在投影時造成的扭曲影響
    % 較少，因此許多單位有各種不同的大地基準。
    % 為了方便使用，目前主流是採用WGS84 datum 的經緯度作為主要交換資料。
    %
    % 同一種橢球且使用同樣的基準，可以將座標任意轉換，包含:經緯度、球心為原點的
    % 三維XYZ資料、投影的二維EN資料。
    % 只要基準不同，在座標轉換之前就要先進行基準轉換。基準轉換的計算都是在球心
    % 為原點的三維XYZ資料中處理。例如常見的轉換流程是:
    % 先:
    % WGS84 datum(球體=WGS84) 的經緯度資料 -> WGS84 datum(球體=WGS84) 的XYZ資料 
    % -> TWD97 datum(球體=GRS80) 的XYZ資料 
    % 再:
    % (1) TWD97 datum(球體=GRS80) 的XYZ資料 -> TWD97 datum(球體=GRS80) 的經緯度資料 -> TWD97 datum(球體=GRS80) 的EN資料 
    % (2) TWD97 datum(球體=GRS80) 的XYZ資料 -> TWD97 datum(球體=GRS80) 的EN資料 
    %
    % 在台灣地區，TWD97 datum 與 WGS84 datum 的經緯度資料差異很小，在多數應用中
    % 被視為可忽略的差異，因此轉換方式就變得非常簡潔:
    % WGS84 datum(球體=WGS84) 的經緯度資料 = TWD97 datum(球體=GRS80) 的經緯度資料 -> TWD97 datum(球體=GRS80) 的EN資料
    % 
    % 因此，WGS84 datum經緯度 轉 TWD97 datum TM2資料的計算方法可簡化為:
    % TWD97 datum的經緯度數值直接使用WGS84 datum經緯度，球體參數採用GRS80，來計算投影的EN資料
    % 
    % 同理，也可以選擇:
    % WGS84 datum經緯度，球體參數採用WGS84，來計算投影的EN資料，將會有些微的差異。
    %----------------------------------------------------------------------
    % 座標參考系統(Coordinate Reference Systems,CRS)
    % 歐洲石油調查組織(European Petroleum Survey Group,EPSG)所建立，目前被繼續使用
    % 的EPSG大地參數資料庫，用EPSG加上數字整理了各地來註冊的大地參數。
    % 也就是一個EPSG對應一個CRS
    %--
    % 主要要關心的是跟台灣有關的:
    % EPSG:4326 -> WGS84
    % EPSG:3825 -> TWD97 TM2 zone 119(二度分帶離島澎湖119經度)
    % EPSG:3826 -> TWD97 TM2 zone 121(二度分帶臺灣本島121經度)
    %----------------------------------------------------------------------
    % 要做轉換之前先說明清楚通用的定義，二度分帶在直角坐標系中X正向朝右，Y正向朝上，
    % 經緯度就是經度在X方向，緯度在Y方向。不要討論地球繞一圈經緯度超過角度等問題，簡
    % 單想X正向是朝向東邊，Y正向是朝向北邊。
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % 以下的轉換公式就是輸入WGS84的經緯度(單位:[度])，再輸出TWD97台灣本島的二度分帶座標(單位:[m])
    % (1)假設TWD97的經緯度與WGS84的經緯度相同
    % (2)用TWD97的經緯度套用Snyder(1987)的公式，公式內用到的橢球參數都來自TWD97參考的GRS80。
    % (3)公式求出來的是沒有經過False Easting、False northing修正的，因此最後要修正。
    %--------------------------------------------------------------------------
    % TWD97二度分帶，以臺灣本島121經度作為中央經線的參數
    % 計算用的真實原點定為:
    %   緯度原點(Latitude origin)=0度(赤道)
    %   中央經度(Central meridian)=121度(臺灣本島，東引)
    % 中央經線投影尺度比:
    %   尺度縮放因子(Scale factor)=0.9999
    % 網格繪圖用的網格原點修正:
    %   False Easting=250000公尺 (這英文很容易記錯，依照其意義被翻譯為座標西移量)
    %   False northing=0公尺 (這英文很容易記錯，依照其意義被翻譯為座標南移量)
    % 原點網格修正是用在UTM時避免轉換出來的數值有負值存在而設計的，可想像真實原點121
    % 度就是對應到第250000公尺，適用範圍內的經度120.5度依舊還是正值但小於250000公尺。
    %--
    % 中央經線轉成弧度
    TWD97_Lambda0 = 121./180.*pi;
    % 中央經線投影尺度比
    TWD97_k0=0.9999;
    % 網格原點修正，單位[m]。
    TWD97_E0=250000;%False_Easting_in_meter_E0=250000;
    TWD97_N0=0;%False_northing_in_meter_N0=0;
    %--
    % TWD97的參考橢球體參數(球體=GRS80)
    % 半長軸a，對應地球的赤道半徑(Equatorial Radius)，單位[m]。
    TWD97_a=6378137;
    % 半短軸b，對應地球的極半徑(Polar Radius)，單位[m]。
    TWD97_b = 6356752.314245;
    %----------------------------------------------------------------------
    % 轉換公式來自Snyder(1987)的Section8中的FORMULAS FOR THE ELLIPSOID
    % 以下公式相關的變數都用Snyder開頭，方便對照。
    % 輸出項目:
    % Snyder_x -> 投影座標系上的E，單位[m]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    % Snyder_y -> 投影座標系上的N，單位[m]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    % 輸入項目:
    % Snyder_Phi -> 緯度，單位[rad]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。    
    Snyder_Phi=WGS84_Latitude_in_degrees./180.*pi;%TWD97的緯度=WGS84的緯度，單位[rad]
    % Snyder_Lambda -> 經度，單位[rad]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_Lambda=WGS84_Longitude_in_degrees./180.*pi;%TWD97的經度=WGS84的經度，單位[rad]
    %--
    % Snyder_Lambda0 -> 中央經度，單位[rad]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_Lambda0=TWD97_Lambda0;%TWD97本島的中央經度121度。
    % Snyder_Phi0 -> 中間緯度，單位[rad]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    % Snyder_Phi0=0;%TWD97本島，這項目前用不到所以註解掉。
    % Snyder_a -> 的半長軸a，對應地球的赤道半徑(Equatorial Radius)，單位[m]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_a=TWD97_a;%TWD97的。
    % Snyder_b -> 半長軸a，對應地球的赤道半徑(Equatorial Radius)，單位[m]。Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_b=TWD97_b;%TWD97的。    
    % Snyder_k0 -> 中央經線投影尺度比。
    Snyder_k0=TWD97_k0;%TWD97的。     
    %--
    % Snyder_e_square -> Snyder(1987)的書本開頭的SYMBOLS章節SYMBOLS。
    Snyder_e_square=1-Snyder_b^2/Snyder_a^2;
    % Snyder_e_prime_square -> Snyder(1987)的公式(8-12)
    Snyder_e_prime_square=Snyder_e_square/(1-Snyder_e_square);
    % Snyder_N -> Snyder(1987)的公式(4-20)
    Snyder_N=Snyder_a/sqrt(1-Snyder_e_square*sin(Snyder_Phi)^2);
    % Snyder_T -> Snyder(1987)的公式(8-13)
    Snyder_T=tan(Snyder_Phi)^2;
    % Snyder_C -> Snyder(1987)的公式(8-14)
    Snyder_C=Snyder_e_prime_square*cos(Snyder_Phi)^2;
    % Snyder_A -> Snyder(1987)的公式(8-15)
    Snyder_A=(Snyder_Lambda-Snyder_Lambda0)*cos(Snyder_Phi);    
    % Snyder_M -> Snyder(1987)的公式(3-21)
    Snyder_M=Snyder_a*(...
            (1-Snyder_e_square/4-3*Snyder_e_square^2/64-5*Snyder_e_square^3/256)*Snyder_Phi- ...
            (3*Snyder_e_square/8+3*Snyder_e_square^2/32+45*Snyder_e_square^3/1024)*sin(2*Snyder_Phi)+ ...
            (15*Snyder_e_square^2/256+45*Snyder_e_square^3/1024)*sin(4*Snyder_Phi)- ...
            (35*Snyder_e_square^3/3072)*sin(6*Snyder_Phi) ...
        );
    % Snyder_M0 -> Snyder(1987)的公式(3-21)
    % Snyder_M0=Snyder_a*(...
    %        (1-Snyder_e_square/4-3*Snyder_e_square^2/64-5*Snyder_e_square^3/256)*Snyder_Phi0- ...
    %        (3*Snyder_e_square/8+3*Snyder_e_square^2/32+45*Snyder_e_square^3/1024)*sin(2*Snyder_Phi0)+ ...
    %        (15*Snyder_e_square^2/256+45*Snyder_e_square^3/1024)*sin(4*Snyder_Phi0)- ...
    %        (35*Snyder_e_square^3/3072)*sin(6*Snyder_Phi0) ...
    %    );
    % 當Snyder_Phi0=0的時候，Snyder_M0=0。省去M0的計算直接給值。
    Snyder_M0=0;
    %
    %--
    % Snyder(1987)的公式(8-9)
    Snyder_x=Snyder_k0*Snyder_N*( ...
            Snyder_A+ ...
            (1-Snyder_T+Snyder_C)*Snyder_A^3/6+ ...
            (5-18*Snyder_T+Snyder_T^2+72*Snyder_C-58*Snyder_e_prime_square)*Snyder_A^5/120 ...
        );
    % Snyder(1987)的公式(8-10)
    Snyder_y=Snyder_k0*( ...
            Snyder_M-Snyder_M0+ ...
            Snyder_N*tan(Snyder_Phi)*( ...
                Snyder_A^2/2+ ...
                (5-Snyder_T+9*Snyder_C+4*Snyder_C^2)*Snyder_A^4/24+ ...
                (61-58*Snyder_T+Snyder_T^2+600*Snyder_C-300*Snyder_e_prime_square)*Snyder_A^6/720 ...
            ) ...
        );    
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % 經緯度投影到臺灣本島的TWD97的二度分帶的EN座標
    TWD97_E_in_meters=TWD97_E0+Snyder_x;
    TWD97_N_in_meters=TWD97_N0+Snyder_y;
    %disp([num2str(TWD97_E_in_meters),',',num2str(TWD97_N_in_meters)])
    %----------------------------------------------------------------------
end
```
