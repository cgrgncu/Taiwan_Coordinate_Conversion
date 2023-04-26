%**************************************************************************
%   Name: Snyder_Formula_WGS84toTWD97_121.m v20210421a
%   Copyright:  
%   Author: HsiupoYeh 
%   Version: v20210421a
%   Description: �NWGS84�g�n���ഫ���O�W���q��TWD97���G�פ��a�C�A�νd��g��120��122�סC
%   �ѦҤ��m: Snyder, J. P. (1987). Map projections--A working manual (Vol. 1395).
%       US Government Printing Office.(https://pubs.usgs.gov/pp/1395/report.pdf)
%   �I�s�覡:
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(120,22)
%       ���G: TWD97_E_in_meters = 146744.3798, TWD97_N_in_meters = 2433894.6701
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(120.3,22.3)
%       ���G: TWD97_E_in_meters = 177875.4425, TWD97_N_in_meters = 2466940.6551
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(120.8,22.8)
%       ���G: TWD97_E_in_meters = 229467.4326, TWD97_N_in_meters = 2522150.7039
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(121.2,23.2)
%       ���G: TWD97_E_in_meters = 270472.1551, TWD97_N_in_meters = 2566444.0678
%       [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(121.7,23.7)
%       ���G: TWD97_E_in_meters = 321384.4538, TWD97_N_in_meters = 2621974.9102
%**************************************************************************
function [TWD97_E_in_meters,TWD97_N_in_meters]=Snyder_Formula_WGS84toTWD97_121(WGS84_Longitude_in_degrees,WGS84_Latitude_in_degrees)
    %----------------------------------------------------------------------
    % �y���ഫ����¦����:
    % 3D�a�y�W���g�n�׮y�а򥻤W�N�O�@�ӥ��骺���y��W���N��m���y�Ъ��ܪk�C
    % �@�Ӯy�Х]�t�y�������_���g�סB�n�סB���סC
    %
    % �a�y���O���������ΡA���P�~�N�Τ��P����a�y�W�w�����P�����y��C
    % �o�˪��W�w�Q�٬��a�y�ѦҾ�y(Earth reference ellipsoid)�A�]�t�F�o�Ӿ�y�����b�u�b���򥻸�T�C
    % �`�Ϊ��X�Ӧa�y�ѦҾ�y�p�U:
    % Geodetic Reference System 1967 (GRS67)
    % Geodetic Reference System 1980 (GRS80)
    % World Geodetic System 1984 (WGS84)
    % ��h�a�y�ѦҾ�y�i�d��:https://en.wikipedia.org/wiki/Earth_ellipsoid
    % 
    % 2D�a�ϤW���q�`�ϥΧ�v�k�N������g�ܥ����W�C
    % �ثe�D�y�ϥά�����d����v�k(Transverse Mercator projection)�C
    % �q�`���m�|�N�g�n���ഫ�ܧ�v�������p��٧@Forword�A��v������^�g�n�ת��p��٧@Inverse�C    
    % ����:https://en.wikipedia.org/wiki/Transverse_Mercator_projection
    % �t�~���h�ӾǪ̴��X��v�k���ഫ����:
    % https://en.wikipedia.org/wiki/Transverse_Mercator:_Redfearn_series
    % https://en.wikipedia.org/wiki/Transverse_Mercator:_Bowring_series
    % ���O�H�W���ഫ������N�����I�ҽk�A���ϥΡC
    % ���g��ܪ��ഫ�����ѷӮ��y:https://pubs.usgs.gov/pp/1395/report.pdf
    % �ѦW:Snyder, J. P. (1987). Map projections--A working manual (Vol. 1395).
    % US Government Printing Office.
    %
    % ����d����v�k�q�`���X�ӳW��: �G�פ��a(TM2)�B�T�פ��a(TM3)�B���פ��a(TM6)�A�åi�H���w���a�������g�סC
    % �Ҧp�x�W�|���G�פ��a�����g��121 -> TM2/121
    % �䤤���Q�W�w�@�ӳq�γW��:UTM�A�ϥΤ��פ��a�A��a�y����60�ϡA�����g�׳��Q�W�w�n�C
    % �Ҧp�ϰ�1�O�g��180��~174�סA�����g��177�סC
    %
    % �󧹾㪺�Q�תŶ��������@�I�b��y�W����m�A�i�H�Τ��P���y�Шt�Ӵy�z:
    % 1.�j�a�y�Шt -> �g�סB�n�סB����
    % 2.�a�ߪ������Шt -> X,Y,Z (�G�N�Τj�g���ܡA�o�O�T���Ŷ��������y�Ц�m)
    % 3.��v�y�Шt -> E,N(x,y) (�G�N�Τp�g���ܡA�q�`�O���F��x�򩹥_��y)
    %
    % �z�Q�W�A���N��m�b�P�@�ؾ�y�i�H���N�ഫ�ܤ��P�y�Шt�Ӫ��ܡC
    % ��ڤW�ഫ�D�����A�B�ڭ̦����쪺�d��򥻤W�����n�_���C
    %
    % �n���y�P�a�y�s���_�ӡA�ݭn��ܤ@�ӰѦ��I�@����ǡA�i�@�B�b�Ѧ��I�H�~��
    % ��m�i��j�a���q�A���P�~�N�B���P����ܤF��y���~�A�٭q�w�F�U�۪��j�a��
    % �ǰѦ�(Geodetic datum�A��²��datum)�C
    % �Ҧp:
    % �x�W�ϥΪ��j�a���:
    % Hu-Tzu-Shan datum -> �y��=International(1924), ��ǭ��I=�n��H����l�s�@���T���I
    % TWD67 datum -> �y��=GRS67,��ǭ��I=�n��H����l�s�@���T���I
    % TWD97 datum -> �y��=GRS80,���=GPS�ìP�w��޳N(ITRF94@1997.0�ѦҮج[�FBIH 1984.0�ѦҤ��)
    % WGS84 datum -> �y��=WGS84,���=�s�a�y�ҫ�(��q���߬������I�A�[�W�F�����b���@�ɦU�a��1500�Ӧa�z�y�аѦ��I)
    % 
    % ²�檺���A���Q�٬�datum�ɡA�N�|�]�t��y�ΰ�ǡC
    % �q�`�A�ϰ쫬��datum�A�Ϊ��y�нd������p�A���]�����b��v�ɳy�����ᦱ�v�T
    % ���֡A�]���\�h��즳�U�ؤ��P���j�a��ǡC
    % ���F��K�ϥΡA�ثe�D�y�O�ĥ�WGS84 datum ���g�n�ק@���D�n�洫��ơC
    %
    % �P�@�ؾ�y�B�ϥΦP�˪���ǡA�i�H�N�y�Х��N�ഫ�A�]�t:�g�n�סB�y�߬����I��
    % �T��XYZ��ơB��v���G��EN��ơC
    % �u�n��Ǥ��P�A�b�y���ഫ���e�N�n���i�����ഫ�C����ഫ���p�ⳣ�O�b�y��
    % �����I���T��XYZ��Ƥ��B�z�C�Ҧp�`�����ഫ�y�{�O:
    % ��:
    % WGS84 datum(�y��=WGS84) ���g�n�׸�� -> WGS84 datum(�y��=WGS84) ��XYZ��� 
    % -> TWD97 datum(�y��=GRS80) ��XYZ��� 
    % �A:
    % (1) TWD97 datum(�y��=GRS80) ��XYZ��� -> TWD97 datum(�y��=GRS80) ���g�n�׸�� -> TWD97 datum(�y��=GRS80) ��EN��� 
    % (2) TWD97 datum(�y��=GRS80) ��XYZ��� -> TWD97 datum(�y��=GRS80) ��EN��� 
    %
    % �b�x�W�a�ϡATWD97 datum �P WGS84 datum ���g�n�׸�Ʈt���ܤp�A�b�h�����Τ�
    % �Q�����i�������t���A�]���ഫ�覡�N�ܱo�D�`²��:
    % WGS84 datum(�y��=WGS84) ���g�n�׸�� = TWD97 datum(�y��=GRS80) ���g�n�׸�� -> TWD97 datum(�y��=GRS80) ��EN���
    % 
    % �]���AWGS84 datum�g�n�� �� TWD97 datum TM2��ƪ��p���k�i²�Ƭ�:
    % TWD97 datum���g�n�׼ƭȪ����ϥ�WGS84 datum�g�n�סA�y��ѼƱĥ�GRS80�A�ӭp���v��EN���
    % 
    % �P�z�A�]�i�H���:
    % WGS84 datum�g�n�סA�y��ѼƱĥ�WGS84�A�ӭp���v��EN��ơA�N�|���ǷL���t���C
    %----------------------------------------------------------------------
    % �y�аѦҨt��(Coordinate Reference Systems,CRS)
    % �ڬw�۪o�լd��´(European Petroleum Survey Group,EPSG)�ҫإߡA�ثe�Q�~��ϥ�
    % ��EPSG�j�a�ѼƸ�Ʈw�A��EPSG�[�W�Ʀr��z�F�U�a�ӵ��U���j�a�ѼơC
    % �]�N�O�@��EPSG�����@��CRS
    %--
    % �D�n�n���ߪ��O��x�W������:
    % EPSG:4326 -> WGS84
    % EPSG:3825 -> TWD97 TM2 zone 119(�G�פ��a���q���119�g��)
    % EPSG:3826 -> TWD97 TM2 zone 121(�G�פ��a�O�W���q121�g��)
    %----------------------------------------------------------------------
    % �n���ഫ���e�������M���q�Ϊ��w�q�A�G�פ��a�b�������Шt��X���V�¥k�AY���V�¤W�A
    % �g�n�״N�O�g�צbX��V�A�n�צbY��V�C���n�Q�צa�y¶�@��g�n�׶W�L���׵����D�A²
    % ��QX���V�O�¦V�F��AY���V�O�¦V�_��C
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % �H�U���ഫ�����N�O��JWGS84���g�n��(���:[��])�A�A��XTWD97�x�W���q���G�פ��a�y��(���:[m])
    % (1)���]TWD97���g�n�׻PWGS84���g�n�׬ۦP
    % (2)��TWD97���g�n�׮M��Snyder(1987)�������A�������Ψ쪺��y�ѼƳ��Ӧ�TWD97�ѦҪ�GRS80�C
    % (3)�����D�X�Ӫ��O�S���g�LFalse Easting�BFalse northing�ץ����A�]���̫�n�ץ��C
    %--------------------------------------------------------------------------
    % TWD97�G�פ��a�A�H�O�W���q121�g�ק@�������g�u���Ѽ�
    % �p��Ϊ��u����I�w��:
    %   �n�׭��I(Latitude origin)=0��(���D)
    %   �����g��(Central meridian)=121��(�O�W���q�A�F��)
    % �����g�u��v�ثפ�:
    %   �ث��Y��]�l(Scale factor)=0.9999
    % ����ø�ϥΪ�������I�ץ�:
    %   False Easting=250000���� (�o�^��ܮe���O���A�̷Ө�N�q�Q½Ķ���y�Ц貾�q)
    %   False northing=0���� (�o�^��ܮe���O���A�̷Ө�N�q�Q½Ķ���y�Ыn���q)
    % ���I����ץ��O�ΦbUTM���קK�ഫ�X�Ӫ��ƭȦ��t�Ȧs�b�ӳ]�p���A�i�Q���u����I121
    % �״N�O�������250000���ءA�A�νd�򤺪��g��120.5�ר����٬O���Ȧ��p��250000���ءC
    %--
    % �����g�u�ন����
    TWD97_Lambda0 = 121./180.*pi;
    % �����g�u��v�ثפ�
    TWD97_k0=0.9999;
    % ������I�ץ��A���[m]�C
    TWD97_E0=250000;%False_Easting_in_meter_E0=250000;
    TWD97_N0=0;%False_northing_in_meter_N0=0;
    %--
    % TWD97���ѦҾ�y��Ѽ�(�y��=GRS80)
    % �b���ba�A�����a�y�����D�b�|(Equatorial Radius)�A���[m]�C
    TWD97_a=6378137;
    % �b�u�bb�A�����a�y�����b�|(Polar Radius)�A���[m]�C
    TWD97_b = 6356752.314245;
    %----------------------------------------------------------------------
    % �ഫ�����Ӧ�Snyder(1987)��Section8����FORMULAS FOR THE ELLIPSOID
    % �H�U�����������ܼƳ���Snyder�}�Y�A��K��ӡC
    % ��X����:
    % Snyder_x -> ��v�y�Шt�W��E�A���[m]�CSnyder(1987)���ѥ��}�Y��SYMBOLS���`SYMBOLS�C
    % Snyder_y -> ��v�y�Шt�W��N�A���[m]�CSnyder(1987)���ѥ��}�Y��SYMBOLS���`SYMBOLS�C
    % ��J����:
    % Snyder_Phi -> �n�סA���[rad]�CSnyder(1987)���ѥ��}�Y��SYMBOLS���`SYMBOLS�C    
    Snyder_Phi=WGS84_Latitude_in_degrees./180.*pi;%TWD97���n��=WGS84���n�סA���[rad]
    % Snyder_Lambda -> �g�סA���[rad]�CSnyder(1987)���ѥ��}�Y��SYMBOLS���`SYMBOLS�C
    Snyder_Lambda=WGS84_Longitude_in_degrees./180.*pi;%TWD97���g��=WGS84���g�סA���[rad]
    %--
    % Snyder_Lambda0 -> �����g�סA���[rad]�CSnyder(1987)���ѥ��}�Y��SYMBOLS���`SYMBOLS�C
    Snyder_Lambda0=TWD97_Lambda0;%TWD97���q�������g��121�סC
    % Snyder_Phi0 -> �����n�סA���[rad]�CSnyder(1987)���ѥ��}�Y��SYMBOLS���`SYMBOLS�C
    % Snyder_Phi0=0;%TWD97���q�A�o���ثe�Τ���ҥH���ѱ��C
    % Snyder_a -> ���b���ba�A�����a�y�����D�b�|(Equatorial Radius)�A���[m]�CSnyder(1987)���ѥ��}�Y��SYMBOLS���`SYMBOLS�C
    Snyder_a=TWD97_a;%TWD97���C
    % Snyder_b -> �b���ba�A�����a�y�����D�b�|(Equatorial Radius)�A���[m]�CSnyder(1987)���ѥ��}�Y��SYMBOLS���`SYMBOLS�C
    Snyder_b=TWD97_b;%TWD97���C    
    % Snyder_k0 -> �����g�u��v�ثפ�C
    Snyder_k0=TWD97_k0;%TWD97���C     
    %--
    % Snyder_e_square -> Snyder(1987)���ѥ��}�Y��SYMBOLS���`SYMBOLS�C
    Snyder_e_square=1-Snyder_b^2/Snyder_a^2;
    % Snyder_e_prime_square -> Snyder(1987)������(8-12)
    Snyder_e_prime_square=Snyder_e_square/(1-Snyder_e_square);
    % Snyder_N -> Snyder(1987)������(4-20)
    Snyder_N=Snyder_a/sqrt(1-Snyder_e_square*sin(Snyder_Phi)^2);
    % Snyder_T -> Snyder(1987)������(8-13)
    Snyder_T=tan(Snyder_Phi)^2;
    % Snyder_C -> Snyder(1987)������(8-14)
    Snyder_C=Snyder_e_prime_square*cos(Snyder_Phi)^2;
    % Snyder_A -> Snyder(1987)������(8-15)
    Snyder_A=(Snyder_Lambda-Snyder_Lambda0)*cos(Snyder_Phi);    
    % Snyder_M -> Snyder(1987)������(3-21)
    Snyder_M=Snyder_a*(...
            (1-Snyder_e_square/4-3*Snyder_e_square^2/64-5*Snyder_e_square^3/256)*Snyder_Phi- ...
            (3*Snyder_e_square/8+3*Snyder_e_square^2/32+45*Snyder_e_square^3/1024)*sin(2*Snyder_Phi)+ ...
            (15*Snyder_e_square^2/256+45*Snyder_e_square^3/1024)*sin(4*Snyder_Phi)- ...
            (35*Snyder_e_square^3/3072)*sin(6*Snyder_Phi) ...
        );
    % Snyder_M0 -> Snyder(1987)������(3-21)
    % Snyder_M0=Snyder_a*(...
    %        (1-Snyder_e_square/4-3*Snyder_e_square^2/64-5*Snyder_e_square^3/256)*Snyder_Phi0- ...
    %        (3*Snyder_e_square/8+3*Snyder_e_square^2/32+45*Snyder_e_square^3/1024)*sin(2*Snyder_Phi0)+ ...
    %        (15*Snyder_e_square^2/256+45*Snyder_e_square^3/1024)*sin(4*Snyder_Phi0)- ...
    %        (35*Snyder_e_square^3/3072)*sin(6*Snyder_Phi0) ...
    %    );
    % ��Snyder_Phi0=0���ɭԡASnyder_M0=0�C�٥hM0���p�⪽�����ȡC
    Snyder_M0=0;
    %
    %--
    % Snyder(1987)������(8-9)
    Snyder_x=Snyder_k0*Snyder_N*( ...
            Snyder_A+ ...
            (1-Snyder_T+Snyder_C)*Snyder_A^3/6+ ...
            (5-18*Snyder_T+Snyder_T^2+72*Snyder_C-58*Snyder_e_prime_square)*Snyder_A^5/120 ...
        );
    % Snyder(1987)������(8-10)
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
    % �g�n�ק�v��O�W���q��TWD97���G�פ��a��EN�y��
    TWD97_E_in_meters=TWD97_E0+Snyder_x;
    TWD97_N_in_meters=TWD97_N0+Snyder_y;
    %disp([num2str(TWD97_E_in_meters),',',num2str(TWD97_N_in_meters)])
    %----------------------------------------------------------------------
end