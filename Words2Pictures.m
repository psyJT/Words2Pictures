function y = Words2Pictures(x)


% --- Usage ---
%  Generate Picture(s) with Word(s)
%  程序功能：将文字转换成图片
%
% --- Authors ---
%  [1] Ting Jiang, [2] Hengyang Zhang, [3] Tianwei Gong, [4] Si Cheng, [5] Weiping Chen, and [6] Jinjin Guo.
%
%  [1] Ting Jiang, 2017.3.27, School of Psychology, Beijing Normal University
%  E-Mail: psytingjiang@gmail.com
%
%  [2] Hengyang Zhang, 2017.4.12, in School of Psychology, Beijing Normal University
%  E-Mail: xfyhzhy13582@foxmail.com
%
%  [3] Tianwei Gong, developed an important Matlab version of Words2Pictures previously,
%  which provide substantial inspiration and significant contribution for this version
%  E-Mail: gongtiw@gmail.com
%
%  [4] Si Cheng, wrote more than 50% codes in this version. She realize
%  the transparent icon, Compass, and generating pngButtons ideas.
%  E-Mail: chengsi123456@gmail.com
%
%  [5] Weiping Chen, wrote the document.
%  E-Mail: chenweiping@xhd.cn
%
%  [6] Jinjin Guo, packing installation
%  E-Mail: m18811419688@163.com
%
%  this version "Words2Pictures" was updated by Ting Jiang, Si Cheng, Weiping Chen, and Jinjin Guo 2018.1.12 - 2018.12.12, including the points mentioned below:
%  (1) The getframe method has its limit(white edge), we fix this bug
%  (2) Debug the flash problem when initializing the figure
%  (3) Use 2 or more than 2 figures, showing the main figure and hide these affiliated figures
%  (4) The buttondown initiated "Compass", which can provide immediate mental rotation "R" feedback, is the most crucial update for this version
%  (5) We generate the icons in png file format by using the Matlab functions (the icons on the title bar, on system taskbar and on the desktop)
%  (6) We generate the buttons(off, on, and press) in png file formats by using Matlab codes, in order to support the point (7)
%  (7) The default button-callback binding mechanism has been replaced by the new figure mechanism(windowbuttonmotionfcn + windowbuttondownfcn + windowbuttonupfcn), to improve the user experience
%  (8) We notice that the codes "CWPath = fileparts(mfilename('fullpath'))" is problematic when we use its .exe version. We use relative path directly.
%  (9) Icon is transparent in the version Matlab2014a. ..
%  (10) Getframe + text(...rotation) mechanism will be replaced by insertText + imrotate mechanism. ..
%  (11) Rotated text 'R' would be replaced by the IMROTATE mechanism. ..

% 这个应用采用的是目录+模块化的思想，把所有的内容都统一呈现在当前的.m文件中





% -------------------------------------------------------------------------
% --- Outline --- 目录 ---
% 整个目录主要分为三个部分（界面上可以看到的三个部分）：文本载入 + 参数设置 + 图片预览和生成
% 在这三个部分之前，是一般性的设置，包括：文件夹 + 窗口大小 + 透明图标 + 创建面板等
% 在这三个部分之后，是捆绑机制
%
% 1. General setting ............................................. Line 131
% 1.1 warning off
% 1.2 prepare zone
% 1.3 prepare three folders ...................................... Line 148
% 1.3.1 Folder (1): Resource Folder
% 1.3.2 Folder (2): Text Folder
% 1.3.3 Folder (3): Picture Folder
% 1.4 figure/window information
%
% 2. Create a figure ............................................. Line 221
% 2.1 Change the window's icon on the title bar
% 2.2 Add the background picture
% 3 Create 3 panels .............................................. Line 241
% 3.1 prepare
% 3.2 three panels
%
% 4. Panel 1 ..................................................... Line 281
% 4.1 Prepare
% 4.2 Create uicontrols in the Panel 1 ........................... Line 293
% 4.2.1 Create a Editbox
% 4.2.2 Create a PushButton
% 4.2.3 Create a Editbox
% 4.2.4 Create a PushButton
% 4.3 Binding mechanism in the Panel 1 ........................... Line 328
% 4.3.1 function Btn_LoadWordsFcn
% 4.3.2 function Btn_WriteWordsFcn
% 4.3.3 Initialize the Edit_WordsList
%
% 5. Panel 2 ..................................................... Line 401
% 5.1 Mode(1): create uicontrolls for the "Font select"
% 5.1.1 Add a Text
% 5.1.2 Create a Editbox
% 5.1.3 Create a PushButton
% 5.1.5 functions
% 5.2 Mode(2): create uicontrolls for the "Font color select" .... Line 511
% 5.2.1 Create a Text
% 5.2.2 Create a Editbox
% 5.2.3 Create a PushButton
% 5.2.4 imshow FontColor
% 5.2.5 function
% 5.3 Mode(3): create uicontrols for the "BKGround color select" . Line 571
% 5.3.1 Create a Text
% 5.3.2 Create a Editbox
% 5.3.3 Create a PushButton
% 5.3.4 imshow BKGround Color
% 5.3.5 functions
% 5.4 Mode(4): create uicontrols for the "Width and Height" ...... Line 631
% 5.4.1 Create Texts for Width and Height
% 5.4.2 Create Editboxes for Width and Height
% 5.5 Mode(5): create uicontrols for the 'Radiobuttons( L/M/R )' . Line 671
% 5.5.1 Create Radios for Radiobuttons( L/M/R )
% 5.5.2 Create Editboxs for Radiobuttons( L/M/R )
% 5.5.3 functions
% 5.6 Mode(6): create compass for panel 2 --- new! & important! .. Line 741
% 5.6.1 prepare & draw the compass
% 5.6.2 Create a Editbox
% 5.6.3 CounterClockwise vs. ClockWise Buttons ................... Line 871
% 5.6.4 function
% 5.7 mentalR ................................................... Line 1155
%
% 6. Panel 3 .................................................... Line 1191
% 6.1 prepare
% 6.2 create uicontrols for panel 3
% 6.2.1 Create pushbuttons for leftBtn, rightBtn, and previewBtn
% 6.2.2 Directory_SelectFcn + generate_OnePictureBtnFcn ......... Line 1271
% 6.3 functions
%  Binding mechanism............................................. Line 1500
%
% 7. Copyright .................................................. Line 1831
%
% 8. Pause and show the figure .................................. Line 1851



% -------------------------------------------------------------------------
% 1. General setting
% -------------------------------------------------------------------------
% 1.1 warning off
% warning off;  %
warning('off', 'all');  % Matlab会有警告信息，一般会把这部分信息给禁掉


%
% 1.2 prepare zone
% prepare 3 folder names
% 我们会准备好三个文件夹的名字，分别是：资源 + 文本 + 图片
ResourceFolderName = 'ResourceFolder'; % 资源文件夹名
TextFolderName = 'TextFolder'; % 文本文件夹名
PicturesFolderName = 'PictureFolder'; % 图片文件夹名

%
% 1.3.1 Folder (1): Resource Folder --- 资源 resouce
if ~exist(ResourceFolderName,'dir') % 如果资源文件夹不存在，那么创建一个新的
    mkdir(ResourceFolderName);
end

%
% 1.3.2 Folder (2): Text Folder --- 文本 text
% prepare 12 ShengXiao words list 准备十二生肖的元胞数组，里边放置12个生肖的英文单词
WordsList_Cells = {'Rat'; 'Ox'; 'Tiger'; 'Rabbit'; 'Dragon'; 'Snake'; 'Horse'; 'Goat'; 'Monkey'; 'Rooster'; 'Dog'; 'Pig'};

% prepare Arabic digits 准备0-9的阿拉伯数字
ArabicDigitsList_Cells = {'0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'};

% two text FileNames for Chinese Animals and Arabic Digits 
Twelve_Chinese_Zodiac_textFileName = 'Twelve_Chinese_Zodiac_List.txt';  % 放置国十二生肖英语单词列表的.txt文件的文件名 
ArabicDigits_0_9_textFileName = 'ArabicDigits_0_9_List.txt';  % 放置阿拉伯数字 0-9的.txt文件的文件名

% two text PathNames for Chinese Animals and Arabic Digits | 准备十二生肖的文件名 + 阿拉伯数字的文件的全路径
Chinese_Zodiac_textPathName = sprintf('%s/%s', TextFolderName, Twelve_Chinese_Zodiac_textFileName);
Arabic_Digits_textPathName = sprintf('%s/%s', TextFolderName, ArabicDigits_0_9_textFileName);

% 如果文本文件夹不存在的话，创建它，并且要生成两个默认的.txt文件：十二生肖 + 阿拉伯数字
if ~exist(TextFolderName,'dir')
    mkdir(TextFolderName);
    
    % create a text file with Chinese Animal words | 创建一个.txt文件，写入十二生肖的英文单词
    fid_Chinese_Zodiac = fopen(Chinese_Zodiac_textPathName, 'w+');
    for iNumWord = 1:length(WordsList_Cells)
        tmpWord = WordsList_Cells{iNumWord};
        fprintf(fid_Chinese_Zodiac, '%s\r\n', tmpWord);
    end
    fclose(fid_Chinese_Zodiac);
    
    % create a text file with Arabic digits | 创建一个.txt文件，写入0-9阿拉伯数字
    fid_Digits = fopen(Arabic_Digits_textPathName, 'w+');
    for iNumWord = 1:length(ArabicDigitsList_Cells)
        tmpWord = ArabicDigitsList_Cells{iNumWord};
        fprintf(fid_Digits, '%s\r\n', tmpWord);
    end
    fclose(fid_Digits);
end

% 1.3.3 Folder (3): Picture Folder --- 图片 picture
if ~exist(PicturesFolderName,'dir') % 如果图片文件夹不存在，那么创建这个文件夹
    mkdir(PicturesFolderName);
end

%
% 1.4 Window/Figure information | 窗口信息
% get the boot/screen position information
Screen_PositionInfo = get(0,'screensize');   % get the screen size info. array that has 4 paramenter, including x y width and height | 获取屏幕的位置大小信息
Screen_Width = Screen_PositionInfo(3);       % get the width from the screen size info. array| 获取屏幕的宽度信息
Screen_Height = Screen_PositionInfo(4);      % get the height from the screen size info. array| 获取屏幕的高度信息

% set the window position information
WinWidth = 1024;    % set the window width|设置窗口的宽度
WinHeight = 650;    % set the window height|设置窗口的高度

% calculate the Window X and Y & prepare a Window Hide X
WinX = (Screen_Width - WinWidth)/2;     % prepare the initial x value for the window|准备好窗口的位置X信息
WinY = (Screen_Height - WinHeight)/2;   % prepare the initial y value for the window|准备好窗口的位置Y信息












% -------------------------------------------------------------------------
% 2. Create a figure 创建一个窗口 hFigure1
% -------------------------------------------------------------------------
hFigure1 = figure(1);
set(hFigure1, 'position',[WinX WinY WinWidth WinHeight], 'toolbar','none', 'NumberTitle','off', 'Name',' Words To Pictures', 'resize','off', 'menubar','none', 'color','w'); % 设置好窗口的一系列参数（比如，没有菜单栏）

% 2.1 Change the window's icon on the title bar | 把窗口标题栏左边的图标改成我们想要的透明的png图片[自绘]
newIcon_FileName = 'mentalR_icon.png';
newIcon_PathName = sprintf('%s/%s', ResourceFolderName, newIcon_FileName);   % prepare the icon's full pathname
newIcon = javax.swing.ImageIcon(newIcon_PathName);   % delete the background of the icon
figFrame = get(hFigure1,'JavaFrame');       % get the Figure's JavaFrame。
figFrame.setFigureIcon(newIcon);    % then change the icon

% 2.2 Add the white background | 增加白色背景
hAxes_BackGround = axes('parent',hFigure1);
set(hAxes_BackGround, 'units','pixels', 'position',[0 0 WinWidth WinHeight], 'color','w', 'Xtick',[], 'Ytick',[]);     % 'color','w' == 'color',[1 1 1]
%  set(gca,’xtick’,[]) == hide the calibration of X-axis
axis([0 WinWidth 0 WinHeight]);    % set the X-axis [0 WinWidth] and set the Y-axis [0 WinHeight]
axis off;

% -------------------------------------------------------------------------
% 3 Create 3 panels 创建3个面板: Load Words, Set Parameters, and Generate Pictures  文本载入 + 参数设置 + 图片预览和生成
% -------------------------------------------------------------------------
% 3.1 prepare zone
% prepare Panel_Panel_Interval
Panel_Panel_Interval = 40;  % Panel之间的间隔

% prepare PanelWidth
PanelWidth = 280;  % Panel宽
PanelHeight = 545;  % Panel高
PanelX_LoadWords = (WinWidth - PanelWidth)/2;   % 获取Load Words Panel的位置
PanelY_LoadWords = 75;  % 150 

% 3.2 prepare parameters of the text uicontrols for 3 panels
% panel has its own text, but it will flash when loading; to fix such bug, we use panel + text uicontrol, instead of panel
hPanel_textWidth = 160;  % text控件的宽度
hPanel_textHeight = 20;  % text控件的高度
hPanel3_textWidth = 180;  % Panel3 text控件的宽度（高度与普通的Panel的文本控件是一样的）

% 各个Panel控件中text文本控件的位置信息
hPanel1_textX = PanelX_LoadWords + 12;  % 相对于Panel1的X位置向右移动12个像素，就是Panel1的文本控件的位置
hPanel1_textY = PanelY_LoadWords + PanelHeight - hPanel_textHeight/2 - 2;   %　相对于Panel1的Y位置向上增加Panel的高度，再减去整个text控件的高度，最后微调2个像素
hPanel2_textX = PanelX_LoadWords + Panel_Panel_Interval + PanelWidth + 12;  % Panel2的X位置
hPanel2_textY = PanelY_LoadWords + PanelHeight - hPanel_textHeight/2 - 2;   % Panel2的Y的位置
hPanel3_textX = PanelX_LoadWords - Panel_Panel_Interval - PanelWidth + 12; % Panel3 的X位置
hPanel3_textY = PanelY_LoadWords + PanelHeight - hPanel_textHeight/2 - 2;  % Panel3 的Y位置

% Panel 1: Loading the words list
hPanel1_LoadWords = uipanel('Parent', hFigure1,'FontSize',10,'units','pixels','BackgroundColor','white','Position',[PanelX_LoadWords PanelY_LoadWords PanelWidth PanelHeight]);
hPanel1_text = uicontrol('parent',hFigure1,'style','text','string','Load Words from a .txt File.','position',[hPanel1_textX hPanel1_textY hPanel_textWidth hPanel_textHeight],'HorizontalAlignment','center', 'fontsize',9, 'BackgroundColor','White','Visible','on');

% Panel 2: Setting the parameters for words
hPanel2_SetParameters = uipanel('Parent', hFigure1,'FontSize',10,'units','pixels','BackgroundColor','white','Position',[PanelX_LoadWords+Panel_Panel_Interval+PanelWidth PanelY_LoadWords PanelWidth PanelHeight]);
hPanel2_text = uicontrol('parent',hFigure1,'style','text','string','  Set Parameter for Pictures.  ','position',[hPanel2_textX hPanel2_textY hPanel_textWidth hPanel_textHeight],'HorizontalAlignment','center', 'fontsize',9, 'BackgroundColor','White','Visible','on');

% Panel 3: Previewing and generating the pictures
hPanel3_PreviewGeneratePictures = uipanel('Parent', hFigure1,'FontSize',10,'units','pixels','BackgroundColor','white','Position',[PanelX_LoadWords-Panel_Panel_Interval-PanelWidth PanelY_LoadWords PanelWidth PanelHeight]);
hPanel3_text = uicontrol('parent',hFigure1, 'style','text', 'string',' Preview and Generate Pictures.', 'position',[hPanel3_textX hPanel3_textY hPanel3_textWidth hPanel_textHeight],'HorizontalAlignment','center', 'fontsize',9, 'BackgroundColor','White','Visible','on');


% -------------------------------------------------------------------------
% 4. Panel 1: Load Words 载入文本
% -------------------------------------------------------------------------
% 4.1 Prepare the wordslist/wisdom presented in the editbox
WordsArray = {'Dream'; 'is'; 'what'; 'makes'; 'you'; 'happy'; 'even';'when'; 'you'; 'are'; 'just';'trying'};

% prepare the word index, point to the 1st word
WordIndex = 1;

% get the length of the wordlist, which will be refleshed in every preview
WordsSum = length(WordsArray);



% 4.2 Create uicontrols for Panel 1: loading the words list
% 4.2.1 Editbox
% Create a Editbox with MultipleLines, for words list
Edit_WordsList_relativeX = 30;    % 280 = 240 + 20 * 2
Edit_WordsList_relativeY = 160;
Edit_WordsList_Width = 220;
Edit_WordsList_Height = 340;
Edit_WordsList = uicontrol('Parent',hPanel1_LoadWords, 'Style','edit', 'Position',[Edit_WordsList_relativeX Edit_WordsList_relativeY Edit_WordsList_Width Edit_WordsList_Height], 'Max' , 2 ,'HorizontalAlignment','center', 'fontsize',12, 'Visible','on');

% 4.2.2 PushButton
% Create a Load PushButton
Pushbutton_LoadWordsList_relativeX = 30;
Pushbutton_LoadWordsList_relativeY = 115;
Pushbutton_LoadWordsList_Width = 220;
Pushbutton_LoadWordsList_Height = 25;
Btn_LoadWordsList = uicontrol('Parent',hPanel1_LoadWords,'Style', 'pushbutton','Position', [Pushbutton_LoadWordsList_relativeX Pushbutton_LoadWordsList_relativeY Pushbutton_LoadWordsList_Width Pushbutton_LoadWordsList_Height], 'String', 'Load the Words from a .txt File', 'Visible','oN');

% 4.2.3 Editbox
% Create a Editbox for .txt file PathName
Edit_txtPathName_relativeX = 30;    % 280 = 220 + 30 * 2
Edit_txtPathName_relativeY = 77.5;
Edit_txtPathName_Width = 220;
Edit_txtPathName_Height = 20;
Edit_PathName_txtFile = uicontrol('Parent',hPanel1_LoadWords, 'Style','edit', 'Position',[Edit_txtPathName_relativeX Edit_txtPathName_relativeY Edit_txtPathName_Width Edit_txtPathName_Height], 'Visible','on', 'Enable','off');


% 4.2.4 PushButton
% Create a Write PushButton
Pushbutton_WriteWordsList_relativeX = 30;
Pushbutton_WriteWordsList_relativeY = 35;
Pushbutton_WriteWordsList_Width = 220;
Pushbutton_WriteWordsList_Height = 25;
Btn_WriteWordsList = uicontrol('Parent',hPanel1_LoadWords,'Style', 'pushbutton','Position', [Pushbutton_WriteWordsList_relativeX Pushbutton_WriteWordsList_relativeY Pushbutton_WriteWordsList_Width Pushbutton_WriteWordsList_Height], 'String', 'Write the Words into a .txt File', 'Visible','on');



% 4.3 === Binding mechanism in the Panel 1
set(Btn_LoadWordsList, 'Callback', @Btn_LoadWordsFcn);
set(Btn_WriteWordsList, 'Callback', @Btn_WriteWordsFcn);

% ==> 4.3.1 function Btn_LoadWordsFcn
    function Btn_LoadWordsFcn(~, ~,~)
        textPathNames_forGetFile = sprintf('%s/*.txt', TextFolderName);
        [txtFileName, txtPath] = uigetfile(textPathNames_forGetFile, 'Pick a .txt File to load the words list!');
        txtPathName = sprintf('%s%s', txtPath, txtFileName);
        set(Edit_PathName_txtFile, 'String', txtPathName);
        Load_FlashCardString = get(Edit_PathName_txtFile, 'String');
        Initial_LoadPath = Load_FlashCardString;
        Load_FlashCardString_extent = get(Edit_PathName_txtFile,'extent');
        Load_FlashCardString_extent_Width = Load_FlashCardString_extent(3);
        
        try
            [WordsArray] = textread(txtPathName, '%s', 'delimiter', '\n');
            set(Edit_WordsList, 'String',WordsArray);
        catch
            fprintf('File not found!\n');
        end
    end   % end for function Btn_LoadWordsFcn

% ==> 4.3.2 function Btn_WriteWordsFcn
    function Btn_WriteWordsFcn(~, ~, ~)
        WordsArray = get(Edit_WordsList, 'String');
        textPathNames_forPutFile = sprintf('%s/*.txt', TextFolderName);
        [txtFileName_Save, txtPath_Save] = uiputfile(textPathNames_forPutFile, 'Save the Words list as a .txt File!');
        
        if isequal(txtFileName_Save,0) || isequal(txtPath_Save,0)
            
        else
            txtPathName_Save = sprintf('%s%s', txtPath_Save, txtFileName_Save);
            set(Edit_PathName_txtFile, 'String',txtPathName_Save);
            fid = fopen(txtPathName_Save, 'w+');
            for iLine = 1:length(WordsArray)
                tmpStr = WordsArray{iLine};
                tmpLine = sprintf('%s\r\n', tmpStr);
                fprintf(fid, tmpLine);
            end
            fclose(fid);
        end
    end  % end for function Btn_WriteWordsFcn

% get the string of load path
Initial_LoadPath = sprintf('%s','');
set(Edit_PathName_txtFile,'string',Initial_LoadPath);
Load_FlashCardString = get(Edit_PathName_txtFile, 'String');
% Calculate the width of the String in the Saving Directory Editbox
Load_FlashCardString_extent = get(Edit_PathName_txtFile,'extent');
Load_FlashCardString_extent_Width = Load_FlashCardString_extent(3);
% Create the flashcard
LoadPath_flashCard_panel =  uipanel('Parent', hFigure1,'FontSize',8,'units','pixels','BackgroundColor','white','TitlePosition','lefttop','title',Load_FlashCardString, 'Position',[0 0 1 1],'bordertype','none','Visible','off');
generate_LoadPath_flashCard_panel;
% ===> function generate_flashCard_panel
    function generate_LoadPath_flashCard_panel()
        if Load_FlashCardString_extent_Width>201
            set(LoadPath_flashCard_panel, 'title',Load_FlashCardString);
            set(LoadPath_flashCard_panel,'Position',[PanelX_LoadWords+Edit_txtPathName_relativeX PanelY_LoadWords+Edit_txtPathName_relativeY Load_FlashCardString_extent_Width+3 21]);
        else
            set(LoadPath_flashCard_panel, 'title',Load_FlashCardString,'Visible','off');
            set(LoadPath_flashCard_panel,'Visible','off');
        end
    end

% 4.3.3 Initialize the Edit_WordsList
set(Edit_WordsList, 'String',WordsArray);   % see: Words List on Line 283



% -------------------------------------------------------------------------
% 5. Panel 2: Set Parameters 设置参数
% -------------------------------------------------------------------------
% 5.1 Mode(1): create uicontrols for Font Select
% 5.1.1 Add a Text to label Editbox of the Font info. Select
Text_FontSetName_relativeX = 30;   % 280 = 220 + 30 * 2
Text_FontSetName_relativeY = 487;
Text_FontSetName_Width = 220;
Text_FontSetName_Height = 20;
Text_FontSet = uicontrol('Parent',hPanel2_SetParameters, 'Style','text', 'String','Set Font', 'Position',[Text_FontSetName_relativeX Text_FontSetName_relativeY Text_FontSetName_Width Text_FontSetName_Height],'HorizontalAlignment','Left', 'fontsize',10, 'BackgroundColor','White','Visible','on');

% 5.1.2 Create a Editbox for Font info.
Edit_FontSetBox_relativeX = 30;    % 280 = 220 + 30 * 2
Edit_FontSetBox_relativeY = 469;
Edit_FontSetBox_Width = 220;
Edit_FontSetBox_Height = 20;
Edit_FontSet = uicontrol('Parent',hPanel2_SetParameters, 'Style','edit', 'Position',[Edit_FontSetBox_relativeX Edit_FontSetBox_relativeY Edit_FontSetBox_Width Edit_FontSetBox_Height],'Visible','on', 'Enable','off');

% 5.1.3 Create a PushButton for Font info. Select
Pushbutton_FontSetBox_relativeX = 160;
Pushbutton_FontSetBox_relativeY = 442;
Pushbutton_FontSetBox_Width = 90;
Pushbutton_FontSetBox_Height = 20;
Btn_FontSet = uicontrol('Parent',hPanel2_SetParameters,'Style','pushbutton', 'Position',[Pushbutton_FontSetBox_relativeX Pushbutton_FontSetBox_relativeY Pushbutton_FontSetBox_Width Pushbutton_FontSetBox_Height], 'String','Font Select', 'fontsize',10, 'Visible','on');

% --- initialize the default Font parameters, load these default parameters, if press cancel -------
sFont.FontName = 'Microsoft Yahei';
sFont.FontSize = 36;
sFont.FontUnits = 'normalized';
sFont.FontWeight = 'normal';
sFont.FontAngle = 'normal';
sFontx = sFont;
sFontStyle = 'normal';

% 5.1.4 === Binding mechanism in the Panel 2: Mode(1)
set(Btn_FontSet, 'Callback', @Btn_FontSelectFcn);

% 5.1.5 Functions in the Panel 2: Mode(1)
% ==> function Btn_FontSelectFcn
    function Btn_FontSelectFcn(~, ~, ~)
        sFont = uisetfont(sFont);
        % if press cancel, load the default parameter
        if isstruct(sFont) == 0
            sFont = sFontx;
        end
        % setting font parameters
        if strcmp(sFont.FontWeight,'bold') && strcmp(sFont.FontAngle,'italic') == 1
            sFontStyle = 'bold italic';
        elseif strcmp(sFont.FontWeight,'bold') == 1
            sFontStyle = 'bold';
        elseif strcmp(sFont.FontAngle,'italic') == 1
            sFontStyle = 'italic';
        else
            sFontStyle = 'normal';
        end
        tmpFontString = sprintf('Name:%s; Style:%s; Size:%d', sFont.FontName, sFontStyle, sFont.FontSize);
        set(Edit_FontSet, 'String', tmpFontString);
        FontSet_FlashCardString = get(Edit_FontSet, 'String');
        InitialFontString = FontSet_FlashCardString;
        FontSet_FlashCardString_extent = get(Edit_FontSet,'extent');
        FontSet_FlashCardString_extent_Width = FontSet_FlashCardString_extent(3);
        
    end   % end of function Btn_FontSelectFcn

% ==> function Default_Btn_FontSelectFcn
    function Default_Btn_FontSelectFcn(~, ~, ~)
        sFont = sFontx;
        % setting font parameters
        if strcmp(sFont.FontWeight,'bold') && strcmp(sFont.FontAngle,'italic') == 1
            sFontStyle = 'bold italic';
        elseif strcmp(sFont.FontWeight,'bold') == 1
            sFontStyle = 'bold';
        elseif strcmp(sFont.FontAngle,'italic') == 1
            sFontStyle = 'italic';
        else
            sFontStyle = 'normal';
        end
        tmpFontString = sprintf('Name:%s; Style:%s; Size:%d', sFont.FontName, sFontStyle, sFont.FontSize);
        set(Edit_FontSet, 'String', tmpFontString);
    end   % end of function Default_Btn_FontSelectFcn

% get the string of font set

InitialFontString = sprintf('Name:%s; Style:%s; Size:%d', 'Microsoft Yahei', 'normal',36);
set(Edit_FontSet, 'String', InitialFontString);
FontSet_FlashCardString = get(Edit_FontSet, 'String');

% Calculate the width of the String in the Saving Directory Editbox
FontSet_FlashCardString_extent = get(Edit_FontSet,'extent');
FontSet_FlashCardString_extent_Width = FontSet_FlashCardString_extent(3);

%
% Create the flashcard
FontSet_flashCard_panel =  uipanel('Parent', hFigure1,'FontSize',8,'units','pixels','BackgroundColor','white','TitlePosition','lefttop','title',FontSet_FlashCardString, 'Position',[0 0 1 1],'bordertype','none','Visible','off');
generate_FontSet_flashCard_panel;

% ===> function generate_flashCard_panel
    function generate_FontSet_flashCard_panel()
        if FontSet_FlashCardString_extent_Width>218
            set(FontSet_flashCard_panel, 'title',FontSet_FlashCardString);
            set(FontSet_flashCard_panel,'Position',[PanelX_LoadWords+Panel_Panel_Interval+PanelWidth+Edit_FontSetBox_relativeX PanelY_LoadWords+Edit_FontSetBox_relativeY FontSet_FlashCardString_extent_Width+3 21]);
        else
            set(FontSet_flashCard_panel, 'title',FontSet_FlashCardString,'Visible','off');
            set(FontSet_flashCard_panel, 'Visible','off');
        end
    end





%
% 5.2 Mode(2): create uicontrols for the "Font Color Select"
% prepare color for font
fColor = [1 1 1];

% 5.2.1 Add a Text to label Editbox of the Font Color Set
Edit_FontColorSetName_relativeX = 30;
Edit_FontColorSetName_relativeY = 415;
Edit_FontColorSetName_Width = 220;
Edit_FontColorSetName_Height = 20;
Text_FontColorSet = uicontrol('Parent',hPanel2_SetParameters, 'Style','text', 'String','Set Font Color', 'Position',[Edit_FontColorSetName_relativeX Edit_FontColorSetName_relativeY Edit_FontColorSetName_Width Edit_FontColorSetName_Height],'HorizontalAlignment','Left', 'fontsize',10, 'BackgroundColor','White','Visible','on');

% 5.2.2 Editbox
% Create a Editbox for Font Color Set
Edit_FontColorSetBox_relativeX = 30;
Edit_FontColorSetBox_relativeY = 397;
Edit_FontColorSetBox_Width = 220;
Edit_FontColorSetBox_Height = 20;
Edit_FontColorSet = uicontrol('Parent',hPanel2_SetParameters, 'Style','edit', 'Position',[Edit_FontColorSetBox_relativeX Edit_FontColorSetBox_relativeY Edit_FontColorSetBox_Width Edit_FontColorSetBox_Height],'Visible','on', 'Enable','off');

% 5.2.3 PushButton
% Create a PushButton for Font Color Set
Pushbutton_FontColorSetBox_relativeX = 160;
Pushbutton_FontColorSetBox_relativeY = 370;
Pushbutton_FontColorSetBox_Width = 90;
Pushbutton_FontColorSetBox_Height = 20;
Btn_FontColorSet = uicontrol('Parent',hPanel2_SetParameters,'Style','pushbutton', 'Position',[Pushbutton_FontColorSetBox_relativeX Pushbutton_FontColorSetBox_relativeY Pushbutton_FontColorSetBox_Width Pushbutton_FontColorSetBox_Height], 'String','Color Select', 'fontsize',10, 'Visible','on');

% 5.2.4 imshow FontColor
Box_Width = 20;
Box_Height = 20;
Axes_FontColor = axes('Parent',hPanel2_SetParameters);
set(gca, 'box','on', 'xtick',[], 'ytick',[], 'units','pixels','position',[Pushbutton_FontColorSetBox_relativeX-30 Pushbutton_FontColorSetBox_relativeY Box_Width Box_Height], 'Visible','on');
tmpFontString = sprintf('Name:%s; Style:%s; Size:%d', sFont.FontName, sFontStyle, sFont.FontSize);
set(Edit_FontSet, 'String', tmpFontString);
set(Axes_FontColor,'Color',fColor);

% 5.2.5 === Binding mechanism in the Panel 2: Mode(2)
set(Btn_FontColorSet, 'Callback', @Btn_FontColorFcn);

% ==> function Btn_FontColorFcn
    function Btn_FontColorFcn(~, ~, ~)
        fColor = uisetcolor(fColor);
        tmpColorString = sprintf('R:%d; G:%d; B:%d', fColor(1) * 255, fColor(2) * 255, fColor(3) * 255);
        set(Edit_FontColorSet, 'String', tmpColorString);
        set(Axes_FontColor,'Color',fColor);
    end   % end of function Btn_FontColorFcn

% ==> function Default_Btn_FontColorFcn
    function Default_Btn_FontColorFcn(~, ~, ~)
        fColor = [1 1 1];
        tmpColorString = sprintf('R:%d; G:%d; B:%d', fColor(1) * 255, fColor(2) * 255, fColor(3) * 255);
        set(Edit_FontColorSet, 'String', tmpColorString);
    end   % end of function Default_Btn_FontColorFcn





%
% 5.3 Mode(3): create uicontrols for the "BKGround Color Select"
% prepare bkground color
bkgColor = [0 0 0];

% 5.3.1 Add a Text to label Editbox of the BKGround Color Set
Edit_FontBKGroundColorSetName_relativeX = 30;
Edit_FontBKGroundColorSetName_relativeY = 340;
Edit_FontBKGroundColorSetName_Width = 220;
Edit_FontBKGroundColorSetName_Height = 20;
Text_FontBKGroundColorSet = uicontrol('Parent',hPanel2_SetParameters,'Style','text', 'String','Set BKGround Color', 'Position',[Edit_FontBKGroundColorSetName_relativeX Edit_FontBKGroundColorSetName_relativeY Edit_FontBKGroundColorSetName_Width Edit_FontBKGroundColorSetName_Height],'HorizontalAlignment','Left', 'fontsize',10, 'BackgroundColor','White','Visible','on');

% 5.3.2 Create a Editbox for BKGround Color Set.
Edit_FontBKGroundColorSetBox_relativeX = 30;
Edit_FontBKGroundColorSetBox_relativeY = 322;
Edit_FontBKGroundColorSetBox_Width = 220;
Edit_FontBKGroundColorSetBox_Height = 20;
Edit_FontBKGroundColorSet = uicontrol('Parent',hPanel2_SetParameters, 'Style','edit', 'Position',[Edit_FontBKGroundColorSetBox_relativeX Edit_FontBKGroundColorSetBox_relativeY Edit_FontBKGroundColorSetBox_Width Edit_FontBKGroundColorSetBox_Height],'Visible','on', 'Enable','off');

% 5.3.3 Create a PushButton for BKGround Color Set
Pushbutton_FontBKGroundColorSetBox_relativeX = 160;
Pushbutton_FontBKGroundColorSetBox_relativeY = 295;
Pushbutton_FontBKGroundColorSetBox_Width = 90;
Pushbutton_FontBKGroundColorSetBox_Height = 20;
Btn_FontBKGroundColorSet = uicontrol('Parent',hPanel2_SetParameters,'Style','pushbutton', 'Position',[Pushbutton_FontBKGroundColorSetBox_relativeX Pushbutton_FontBKGroundColorSetBox_relativeY Pushbutton_FontBKGroundColorSetBox_Width Pushbutton_FontBKGroundColorSetBox_Height], 'String','Color Select', 'fontsize',10, 'Visible','on');

% 5.3.4 imshow BKGround Color
% Create a axes for color block of Background Color
Box_Width = 20;
Box_Height = 20;
Axes_BKGColor=axes('Parent', hPanel2_SetParameters);
set(gca, 'box','on', 'xtick',[], 'ytick',[], 'units','pixels','position',[Pushbutton_FontBKGroundColorSetBox_relativeX-30 Pushbutton_FontBKGroundColorSetBox_relativeY Box_Width Box_Height], 'Visible','on');
set(Axes_BKGColor,'Color',bkgColor);

% 5.3.5 function
% combining mechanism in the Panel 2: mode(3)
set(Btn_FontBKGroundColorSet, 'Callback', @Btn_BKGColorFcn);

% ===> function Btn_BKGColorFcn
    function Btn_BKGColorFcn(~, ~, ~)
        bkgColor = uisetcolor(bkgColor);
        tmpColorStringBKG = sprintf('R:%d; G:%d; B:%d', bkgColor(1) * 255, bkgColor(2) * 255, bkgColor(3) * 255);
        set(Edit_FontBKGroundColorSet, 'String', tmpColorStringBKG);
        set(Axes_BKGColor,'Color',bkgColor);
    end

% ===> function Default_Btn_BKGColorFcn
    function Default_Btn_BKGColorFcn(~, ~, ~)
        bkgColor = [0 0 0];
        tmpColorStringBKG = sprintf('R:%d; G:%d; B:%d', bkgColor(1) * 255, bkgColor(2) * 255, bkgColor(3) * 255);
        set(Edit_FontBKGroundColorSet, 'String', tmpColorStringBKG);
    end

% Initialize these three color-related parameters
Default_Btn_FontSelectFcn;
Default_Btn_FontColorFcn;
Default_Btn_BKGColorFcn;




% 5.4 Mode(4): create uicontrols for the "Width and Height"
% 5.4.1 Add Texts to label Width and Height
% Width Text/Label
Text_Width_relativeX = 30;
Text_Width_relativeY = 260;
Text_Width_Width = 140;
Text_Width_Height = 20;
Text_Width = uicontrol('Parent',hPanel2_SetParameters, 'Style','text', 'String','Width','Position',[Text_Width_relativeX Text_Width_relativeY Text_Width_Width Text_Width_Height],'HorizontalAlignment','Left',  'Fontsize',10, 'BackgroundColor','White', 'Visible','on');

% Height Text/Label
Text_Height_relativeX = 160;
Text_Height_relativeY = 260;
Text_Height_Width = 120;
Text_Height_Height = 20;
Text_Height = uicontrol('Parent',hPanel2_SetParameters, 'Style','text','String','Height', 'Position',[Text_Height_relativeX Text_Height_relativeY Text_Height_Width Text_Height_Height], 'HorizontalAlignment','Left',  'Fontsize',10, 'BackgroundColor','White', 'Visible','on');

% 5.4.2 Editboxes for setting Width and Height parameters of picture(s)
% Create Editbox for Width
Edit_Width_relativeX = 30;
Edit_Width_relativeY = 238;
Edit_Width_Width = 90;
Edit_Width_Height = 20;
Edit_Width = uicontrol('Parent',hPanel2_SetParameters, 'Style','edit', 'Position',[Edit_Width_relativeX Edit_Width_relativeY Edit_Width_Width Edit_Width_Height], 'Visible','on');

% Create Editbox for Height
Edit_Height_relativeX = 160;
Edit_Height_relativeY = 238;
Edit_Height_Width = 90;
Edit_Height_Height = 20;
Edit_Height = uicontrol('Parent',hPanel2_SetParameters, 'Style','edit', 'Position',[Edit_Height_relativeX Edit_Height_relativeY Edit_Height_Width Edit_Height_Height], 'Visible','on');

% Initialize the values/Strings in the Editboxes for Width and Height
picWidth = 200;
picHeight = 200;
set(Edit_Width, 'String',picWidth);
set(Edit_Height, 'String',picHeight);




% 5.5 Mode(5): create uicontrols for the "Width and Height"
% 5.5.1 Add Radiobuttons for L/M/R, Left/Middle/Right
Radiobutton_Left_relativeX = 50;
Radiobutton_Left_relativeY = 200;
Radiobutton_Left_Width = 58;
Radiobutton_Left_Height = 23;
RadiobuttonLeft = uicontrol('Parent',hPanel2_SetParameters, 'Style','radio', 'Position',[Radiobutton_Left_relativeX  Radiobutton_Left_relativeY Radiobutton_Left_Width Radiobutton_Left_Height], 'String','Left', 'BackgroundColor','White', 'Visible','on');

% Radiobutton_Middle_relativeX = 100;
Radiobutton_Middle_relativeX = 115;
Radiobutton_Middle_relativeY = 200;
Radiobutton_Middle_Width = 58;
Radiobutton_Middle_Height = 23;
RadiobuttonMiddle = uicontrol('Parent',hPanel2_SetParameters,  'Style','radio','Position',[Radiobutton_Middle_relativeX Radiobutton_Middle_relativeY Radiobutton_Middle_Width Radiobutton_Middle_Height], 'String','Middle', 'BackgroundColor', 'White', 'Visible','on');

% Radiobutton_Right_relativeX = 170;
Radiobutton_Right_relativeX = 185;
Radiobutton_Right_relativeY = 200;
Radiobutton_Right_Width = 58;
Radiobutton_Right_Height = 23;
RadiobuttonRight = uicontrol('Parent',hPanel2_SetParameters, 'Style','radio', 'Position',[Radiobutton_Right_relativeX Radiobutton_Right_relativeY Radiobutton_Right_Width Radiobutton_Right_Height], 'String','Right', 'BackgroundColor', 'White', 'Visible','on');

% 5.5.2 edit for Radiobuttons( L/M/R )
% Add Editbox for showing L/M/R
Edit_Aligh_relativeX = 225;
Edit_Aligh_relativeY = 200;
Edit_Aligh_Width = 25;
Edit_Aligh_Height = 20;
Edit_Aligh = uicontrol('Parent',hPanel2_SetParameters,'Style','edit', 'Position',[Edit_Aligh_relativeX  Edit_Aligh_relativeY Edit_Aligh_Width Edit_Aligh_Height], 'Visible','on', 'Enable','off');
set(Edit_Aligh, 'visible', 'off');
% Initialize the L/M/R radiobuttons and the edit, both M
set(RadiobuttonLeft, 'Value',0);
set(RadiobuttonMiddle, 'Value',1);
set(RadiobuttonRight, 'Value',0);
set(Edit_Aligh, 'String','M');

% 5.5.3 functions
% binding mechanism in the Panel 2: mode(4)
set(RadiobuttonLeft, 'Callback', @RadiobuttonLeft_CallbackFcn);
set(RadiobuttonMiddle, 'Callback', @RadiobuttonMiddle_CallbackFcn);
set(RadiobuttonRight, 'Callback', @RadiobuttonRight_CallbackFcn);

% ==> function RadiobuttonLeft_CallbackFcn
    function RadiobuttonLeft_CallbackFcn(~, ~, ~)
        set(RadiobuttonLeft, 'Value',1);
        set(RadiobuttonMiddle, 'Value',0);
        set(RadiobuttonRight, 'Value',0);
        set(Edit_Aligh, 'String','L');
            tmpAngleString = '0';
            set(Edit_AngleSet, 'String',tmpAngleString);
            AngleValue = str2num(tmpAngleString);
            finalAngle = AngleValue;
                    temcircle_x = mediaR * cos(pi/2 - pi*AngleValue/180);
                    temcircle_y = mediaR * sin(pi/2 - pi*AngleValue/180);
                    temballx_toPanel = temcircle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
                    tembally_toPanel = temcircle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
                    temballposInfo = [temballx_toPanel tembally_toPanel ball_Width ball_Height];
                    set(hAxes_ball, 'position',temballposInfo);
                    mentalR_RotationFcn;
    end

% ==> function RadiobuttonMiddle_CallbackFcn
    function RadiobuttonMiddle_CallbackFcn(~, ~, ~)
        set(RadiobuttonLeft, 'Value',0);
        set(RadiobuttonMiddle, 'Value',1);
        set(RadiobuttonRight, 'Value',0);
        set(Edit_Aligh, 'String','M');
    end

%==> function RadiobuttonRight_CallbackFcn
    function RadiobuttonRight_CallbackFcn(~, ~, ~)
        set(RadiobuttonLeft, 'Value',0);
        set(RadiobuttonMiddle, 'Value',0);
        set(RadiobuttonRight, 'Value',1);
        set(Edit_Aligh, 'String','R'); % R is special as it represent the material of the mental rotation experiment
            tmpAngleString = '0';
            set(Edit_AngleSet, 'String',tmpAngleString);
            AngleValue = str2num(tmpAngleString);
            finalAngle = AngleValue;
                    temcircle_x = mediaR * cos(pi/2 - pi*AngleValue/180);
                    temcircle_y = mediaR * sin(pi/2 - pi*AngleValue/180);
                    temballx_toPanel = temcircle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
                    tembally_toPanel = temcircle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
                    temballposInfo = [temballx_toPanel tembally_toPanel ball_Width ball_Height];
                    set(hAxes_ball, 'position',temballposInfo);
                    mentalR_RotationFcn;
    end





% 5.6 Mode(6): create Compass for panel 2 --- new! & important!
% 5.6.1 prepare for drawing the Compass
relativeDistanceX_hAxes_ball_Panel = 140;
relativeDistanceY_hAxes_ball_Panel = 125;

% prepare the mouse "down & motion" field(hAxes_BigRound), in which the ball can be moved
Round_relativeX = 65;
Round_relativeY = 50;
Round_Width = 150;
Round_Height = 150;
hAxes_BigRound = axes('parent',hPanel2_SetParameters);
set(hAxes_BigRound, 'units','pixels', 'position',[Round_relativeX Round_relativeY Round_Width Round_Height], 'color', 'w');
axis(hAxes_BigRound,[-75 75 -75 75]);
axis off;

% imshow the compass image in the "hAxes_Compass" axes
BKGround_relativeX = 80;
BKGround_relativeY = 65;
BKGround_Width = 120;
BKGround_Height = 120;
hAxes_Compass = axes('parent',hPanel2_SetParameters);
set(hAxes_Compass, 'units','pixels', 'position',[BKGround_relativeX BKGround_relativeY BKGround_Width BKGround_Height], 'color','w');
axis(hAxes_Compass,[-60 60 -60 60]);
axis off;

% read the image of the Compass, generated by the ""
CompassFileName = 'Compass.png';
Compass_PathName = sprintf('%s/%s', ResourceFolderName, CompassFileName);
hImage_Compass = imread(Compass_PathName);
imshow(hImage_Compass,'parent',hAxes_Compass,'Xdata',[-60 60],'Ydata',[-60 60]);

% draw the ball in red
hAxes_ball = axes('parent',hPanel2_SetParameters);
ball_initialX = 135;
ball_initialY = 173;
ball_Width = 10;
ball_Height = 10;
set(hAxes_ball, 'units','pixels','position',[ball_initialX ball_initialY ball_Width ball_Height],'visible','on');
axis([-5 5 -5 5]);
hold on;
alpha = 0:pi/360:2*pi;
Rr = 5; % radiation
ballR_x = Rr*cos(alpha);
ballR_y = Rr*sin(alpha);
ballColor = [1 0 0];
plot(ballR_x,ballR_y, 'color', ballColor);
fill(ballR_x,ballR_y, ballColor, 'edgealpha',0);
axis off;
hold off;

% prepare the point of the the ball
mediaR = (240+290)/2*120/600;  % the ratio is 5 == 120:600, and the outside R == 290, the difference is 290 - 240 == 10 * 5, and the track R of the red ball in the big image is (240+290)/2
% So the track R of the red ball in the small image is (240+290)/2*120/600;

% 5.6.2 % Create a Editbox for Font Color Set
finalAngle = 0;        % initialize the variable "finalAngle"
strAngle = sprintf('%d',finalAngle);  % transform the finalAngle into string type
% prepare the position info.
Edit_Angle_X = 115;
Edit_Angle_Y = 30;
Edit_Angle_Width = 50;
Edit_Angle_Height = 20;
% create the editbox uicontrol and initialize the presented string
Edit_AngleSet = uicontrol('Parent',hPanel2_SetParameters, 'Style','edit', 'Position',[Edit_Angle_X Edit_Angle_Y Edit_Angle_Width Edit_Angle_Height],'Visible','on');
set(Edit_AngleSet, 'String',strAngle);

% binding mechanism for Edit_AngleSet
set(Edit_AngleSet, 'Callback', @Angle_Set_EditFcn);

% ==> function Angle_Set_EditFcn
    function Angle_Set_EditFcn(~, ~, ~)
        % get the tmpAngleString first
        tmpAngleString = get(Edit_AngleSet, 'String');
        len_AngleString = length(tmpAngleString);
        trans2num = str2num(tmpAngleString);
        if length(trans2num) == 0
            tmpAngleString = '0';
            set(Edit_AngleSet, 'String',tmpAngleString);
            AngleValue = str2num(tmpAngleString);
            finalAngle = AngleValue;
            temcircle_x = mediaR * cos(pi/2 - pi*AngleValue/180);
            temcircle_y = mediaR * sin(pi/2 - pi*AngleValue/180);
            temballx_toPanel = temcircle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
            tembally_toPanel = temcircle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
            temballposInfo = [temballx_toPanel tembally_toPanel ball_Width ball_Height];
            set(hAxes_ball, 'position',temballposInfo);
            mentalR_RotationFcn;
            warndlg('Please input a number in 0~360', 'Warn');            
        else
            AngleValue = str2num(tmpAngleString);
            if AngleValue>360||AngleValue<0
                tmpAngleString = '0';
                set(Edit_AngleSet, 'String',tmpAngleString);
                AngleValue = str2num(tmpAngleString);
                finalAngle = AngleValue;
                temcircle_x = mediaR * cos(pi/2 - pi*AngleValue/180);
                temcircle_y = mediaR * sin(pi/2 - pi*AngleValue/180);
                temballx_toPanel = temcircle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
                tembally_toPanel = temcircle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
                temballposInfo = [temballx_toPanel tembally_toPanel ball_Width ball_Height];
                set(hAxes_ball, 'position',temballposInfo);
                mentalR_RotationFcn;
                warndlg('Please input a number in 0~360', 'Warn');
            else
                if AngleValue == 0||AngleValue==360
                    
                    tmpAngleString = '0';
                    set(Edit_AngleSet, 'String',tmpAngleString);
                    AngleValue = str2num(tmpAngleString);
                    finalAngle = AngleValue;
                    temcircle_x = mediaR * cos(pi/2 - pi*AngleValue/180);
                    temcircle_y = mediaR * sin(pi/2 - pi*AngleValue/180);
                    temballx_toPanel = temcircle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
                    tembally_toPanel = temcircle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
                    temballposInfo = [temballx_toPanel tembally_toPanel ball_Width ball_Height];
                    set(hAxes_ball, 'position',temballposInfo);
                    mentalR_RotationFcn;
                else
                    RadiobuttonMiddle_CallbackFcn;
                    AngleValue = str2num(tmpAngleString);
                    finalAngle = AngleValue;
                    tmpAngleString = num2str(AngleValue);
                    set(Edit_AngleSet, 'String',tmpAngleString);
                    
                    temcircle_x = mediaR * cos(pi/2 - pi*AngleValue/180);
                    temcircle_y = mediaR * sin(pi/2 - pi*AngleValue/180);
                    temballx_toPanel = temcircle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
                    tembally_toPanel = temcircle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
                    temballposInfo = [temballx_toPanel tembally_toPanel ball_Width ball_Height];
                    set(hAxes_ball, 'position',temballposInfo);
                    mentalR_RotationFcn;
                end

                
            end

        end
        
        
    end  % end of function Angle_Set_EditFcn




%
% 5.6.3 CounterClockWise vs. ClockWise Buttons   !!!important
% % CCW-CounterClockWise buttons
CCWpngFileName_Off = 'off_CCW.png';
CCWpngPathName_Off = sprintf('%s/%s',ResourceFolderName, CCWpngFileName_Off);

CCWpngFileName_On = 'on_CCW.png';
CCWpngPathName_On = sprintf('%s/%s', ResourceFolderName, CCWpngFileName_On);

CCWpngFileName_Press = 'press_CCW.png';
CCWpngPathName_Press = sprintf('%s/%s', ResourceFolderName, CCWpngFileName_Press);

% prepare the position info. for the CCW axes/buttons
Button_subtractX = BKGround_relativeX - 40;
Button_subtractY = BKGround_relativeY + 50;
Button_subtract_Width = 30;
Button_subtract_Height = 30;

% prepare the 3 axes for arrow_off, arrow_on, and arrow press
hAxes_CCWBKGround_Arrow_off = axes('parent',hPanel2_SetParameters);
set(hAxes_CCWBKGround_Arrow_off, 'units','pixels', 'position',[Button_subtractX Button_subtractY-5 Button_subtract_Width Button_subtract_Height],'Xtick',[],'Ytick',[]);
axis off;
hAxes_CCWBKGround_Arrow_on = axes('parent',hPanel2_SetParameters);
set(hAxes_CCWBKGround_Arrow_on, 'units','pixels', 'position',[Button_subtractX Button_subtractY-5 Button_subtract_Width Button_subtract_Height],'Xtick',[],'Ytick',[]);
axis off;
hAxes_CCWBKGround_Arrow_press = axes('parent',hPanel2_SetParameters);
set(hAxes_CCWBKGround_Arrow_press, 'units','pixels', 'position',[Button_subtractX Button_subtractY-5 Button_subtract_Width Button_subtract_Height],'Xtick',[],'Ytick',[]);
axis off;

% read the image matrix of off, on, and press for 3 CounterClockWise arrow buttons
CCWimgMatrix_Off = imread(CCWpngPathName_Off);
CCWimgMatrix_On = imread(CCWpngPathName_On);
CCWimgMatrix_Press = imread(CCWpngPathName_Press);

% get the size info. of image matrixes for 3 arrow buttons
CCWresize_imgMatrix_Off = imresize(CCWimgMatrix_Off,[Button_subtract_Width Button_subtract_Height]);
CCWresize_imgMatrix_On = imresize(CCWimgMatrix_On,[Button_subtract_Width Button_subtract_Height]);
CCWresize_imgMatrix_Press = imresize(CCWimgMatrix_Press,[Button_subtract_Width Button_subtract_Height]);

% image show 3 images on these 3 axes
h_CCWBtnImage_Off = imshow(CCWresize_imgMatrix_Off, 'parent',hAxes_CCWBKGround_Arrow_off);
h_CCWBtnImage_On = imshow(CCWresize_imgMatrix_On, 'parent',hAxes_CCWBKGround_Arrow_on);
h_CCWBtnImage_Press = imshow(CCWresize_imgMatrix_Press, 'parent',hAxes_CCWBKGround_Arrow_press);

% % CW-ClockWise buttons
% prepare the filenames
CWpngFileName_Off = 'off_CW.png';
CWpngPathName_Off = sprintf('%s/%s', ResourceFolderName, CWpngFileName_Off);

CWpngFileName_On = 'on_CW.png';
CWpngPathName_On = sprintf('%s/%s', ResourceFolderName, CWpngFileName_On);

CWpngFileName_Press = 'press_CW.png';
CWpngPathName_Press = sprintf('%s/%s', ResourceFolderName, CWpngFileName_Press);

% prepare the position info. for the CW axes/buttons
Button_additionX = BKGround_relativeX+120+10;
Button_additionY = BKGround_relativeY+50;
Button_addition_Width = 30;
Button_addition_Height = 30;

% prepare the 3 axes for arrow_off, arrow_on, and arrow press
hAxes_CWBKGround_Arrow_off = axes('parent',hPanel2_SetParameters);
set(hAxes_CWBKGround_Arrow_off, 'units','pixels', 'position',[Button_additionX Button_additionY-5 Button_addition_Width Button_addition_Height],'Xtick',[],'Ytick',[]);
axis off;
hAxes_CWBKGround_Arrow_on = axes('parent',hPanel2_SetParameters);
set(hAxes_CWBKGround_Arrow_on, 'units','pixels', 'position',[Button_additionX Button_additionY-5 Button_addition_Width Button_addition_Height],'Xtick',[],'Ytick',[]);
axis off;
hAxes_CWBKGround_Arrow_press = axes('parent',hPanel2_SetParameters);
set(hAxes_CWBKGround_Arrow_press, 'units','pixels', 'position',[Button_additionX Button_additionY-5 Button_addition_Width Button_addition_Height],'Xtick',[],'Ytick',[]);
axis off;

% read the image matrix of off, on, and press for 3 ClockWise arrow buttons
CWimgMatrix_Off = imread(CWpngPathName_Off);
CWimgMatrix_On = imread(CWpngPathName_On);
CWimgMatrix_Press = imread(CWpngPathName_Press);

% get the size info. of image matrixes for 3 arrow buttons
CWresize_imgMatrix_Off = imresize(CWimgMatrix_Off,[Button_addition_Width Button_addition_Height]);
CWresize_imgMatrix_On = imresize(CWimgMatrix_On,[Button_addition_Width Button_addition_Height]);
CWresize_imgMatrix_Press = imresize(CWimgMatrix_Press,[Button_addition_Width Button_addition_Height]);

% image show 3 images on these 3 axes above
h_CWBtnImage_Off = imshow(CWresize_imgMatrix_Off, 'parent',hAxes_CWBKGround_Arrow_off);
h_CWBtnImage_On = imshow(CWresize_imgMatrix_On, 'parent',hAxes_CWBKGround_Arrow_on);
h_CWBtnImage_Press = imshow(CWresize_imgMatrix_Press, 'parent',hAxes_CWBKGround_Arrow_press);

% hide the on and press buttons, but show the off buttons, for both CounterClockWise and ClockWise
% CounterClockWise
set(hAxes_CCWBKGround_Arrow_on,'visible','off');
set(h_CCWBtnImage_On,'visible','off');
set(hAxes_CCWBKGround_Arrow_press,'visible','off');
set(h_CCWBtnImage_Press,'visible','off');
% ClockWise
set(hAxes_CWBKGround_Arrow_on,'visible','off');
set(h_CWBtnImage_On,'visible','off');
set(hAxes_CWBKGround_Arrow_press,'visible','off');
set(h_CWBtnImage_Press,'visible','off');

% set the state_Mouse_In_Btn_Left
state_Mouse_In_Btn_Left = 0;
mouseDown_State = 0;
mouseDown_State = 0;

% ==> function Addition_ButtonDownFcn
    function Addition_ButtonDownFcn(~, ~, ~)
        % when the ball move, set the middle radiobutton true
        RadiobuttonMiddle_CallbackFcn;
        
        hAxes_ball_posInfo = get(hAxes_ball, 'position');
        ballX_hAxes_ball_heart = hAxes_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
        ballY_hAxes_ball_heart = hAxes_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
        
        if  ballX_hAxes_ball_heart >=0 && ballY_hAxes_ball_heart>=0      % First quadrant
            mTheta = atan(abs(ballY_hAxes_ball_heart/ballX_hAxes_ball_heart));
            % calculate mTheta +1°
            mTheta = mTheta - 2*pi/360;
            ballX_hAxes_ball_heart = mediaR * cos(mTheta);
            ballY_hAxes_ball_heart = mediaR * sin(mTheta);
            ballX_Panel = ballX_hAxes_ball_heart - 5 + relativeDistanceX_hAxes_ball_Panel;
            ballY_Panel = ballY_hAxes_ball_heart - 5 + relativeDistanceY_hAxes_ball_Panel;
            hAxes_ball_posInfo = [ballX_Panel ballY_Panel ball_Width ball_Height];
            set(hAxes_ball, 'position', hAxes_ball_posInfo);
            
            % Print degrees into editbox
            hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
            Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
            Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
            edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
            finalAngle = 180*(pi/2 - edit_mTheta)/pi;
            tmpTheta = round(finalAngle);
            set(Edit_AngleSet, 'String', tmpTheta);
        elseif ballX_hAxes_ball_heart > 0 && ballY_hAxes_ball_heart<0      % Second quadrant
            mTheta = atan(abs(ballY_hAxes_ball_heart/ballX_hAxes_ball_heart));
            % calculate mTheta +1°
            mTheta = mTheta + 2*pi/360;
            ballX_hAxes_ball_heart = mediaR * cos(mTheta);
            ballY_hAxes_ball_heart = -mediaR * sin(mTheta);
            ballX_Panel = ballX_hAxes_ball_heart - 5 + relativeDistanceX_hAxes_ball_Panel;
            ballY_Panel = ballY_hAxes_ball_heart - 5 + relativeDistanceY_hAxes_ball_Panel;
            hAxes_ball_posInfo = [ballX_Panel ballY_Panel ball_Width ball_Height];
            set(hAxes_ball, 'position', hAxes_ball_posInfo);
            
            hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
            Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
            Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
            edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
            finalAngle = 180*(pi/2 + edit_mTheta)/pi;
            tmpTheta = round(finalAngle);
            set(Edit_AngleSet, 'String', tmpTheta);
        elseif ballX_hAxes_ball_heart <= 0 && ballY_hAxes_ball_heart<=0      % Third quadrant
            mTheta = atan(abs(ballY_hAxes_ball_heart/ballX_hAxes_ball_heart));
            % calculate mTheta +1°
            mTheta = mTheta - 2*pi/360;
            ballX_hAxes_ball_heart = -mediaR * cos(mTheta);
            ballY_hAxes_ball_heart = -mediaR * sin(mTheta);
            ballX_Panel = ballX_hAxes_ball_heart - 5 + relativeDistanceX_hAxes_ball_Panel;
            ballY_Panel = ballY_hAxes_ball_heart - 5 + relativeDistanceY_hAxes_ball_Panel;
            hAxes_ball_posInfo = [ballX_Panel ballY_Panel ball_Width ball_Height];
            set(hAxes_ball, 'position', hAxes_ball_posInfo);
            
            hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
            Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
            Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
            edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
            finalAngle = 180*(3*pi/2 - edit_mTheta)/pi;
            tmpTheta = round(finalAngle);
            set(Edit_AngleSet, 'String', tmpTheta);
        elseif  ballX_hAxes_ball_heart < 0 && ballY_hAxes_ball_heart>0 % Fourth quadrant
            mTheta = atan(abs(ballY_hAxes_ball_heart/ballX_hAxes_ball_heart));
            % calculate mTheta +1°
            mTheta = mTheta + 2*pi/360;
            ballX_hAxes_ball_heart = -mediaR * cos(mTheta);
            ballY_hAxes_ball_heart = mediaR * sin(mTheta);
            ballX_Panel = ballX_hAxes_ball_heart - 5 + relativeDistanceX_hAxes_ball_Panel;
            ballY_Panel = ballY_hAxes_ball_heart - 5 + relativeDistanceY_hAxes_ball_Panel;
            hAxes_ball_posInfo = [ballX_Panel ballY_Panel ball_Width ball_Height];
            set(hAxes_ball, 'position', hAxes_ball_posInfo);
            
            hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
            Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
            Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
            edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
            finalAngle = 180*(3*pi/2 + edit_mTheta)/pi;
            tmpTheta = round(finalAngle);
            set(Edit_AngleSet, 'String', tmpTheta);
        end
        mentalR_RotationFcn;
    end   % end of function Addition_ButtonDownFcn

% ==> function Subtraction_ButtonDownFcn
    function Subtraction_ButtonDownFcn(~, ~, ~)
        % when the ball move, set the middle radiobutton true
        RadiobuttonMiddle_CallbackFcn;
        hAxes_ball_posInfo = get(hAxes_ball, 'position');
        ballX_hAxes_ball_heart = hAxes_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
        ballY_hAxes_ball_heart = hAxes_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
        
        if  ballX_hAxes_ball_heart > 0 && ballY_hAxes_ball_heart>=0      % First quadrant
            mTheta = atan(abs(ballY_hAxes_ball_heart/ballX_hAxes_ball_heart));
            % calculate mTheta +1°
            mTheta = mTheta + 2*pi/360;
            ballX_hAxes_ball_heart = mediaR * cos(mTheta);
            ballY_hAxes_ball_heart = mediaR * sin(mTheta);
            ballX_Panel = ballX_hAxes_ball_heart - 5 + relativeDistanceX_hAxes_ball_Panel;
            ballY_Panel = ballY_hAxes_ball_heart - 5 + relativeDistanceY_hAxes_ball_Panel;
            hAxes_ball_posInfo = [ballX_Panel ballY_Panel ball_Width ball_Height];
            set(hAxes_ball, 'position', hAxes_ball_posInfo);
            % Print degrees into editbox
            hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
            Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
            Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
            edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
            finalAngle = 180*(pi/2 - edit_mTheta)/pi;
            tmpTheta = round(finalAngle);
            set(Edit_AngleSet, 'String', tmpTheta);
        elseif ballX_hAxes_ball_heart >= 0 && ballY_hAxes_ball_heart<=0      % Second quadrant
            mTheta = atan(abs(ballY_hAxes_ball_heart/ballX_hAxes_ball_heart));
            % calculate mTheta +1°
            mTheta = mTheta - 2*pi/360;
            ballX_hAxes_ball_heart = mediaR * cos(mTheta);
            ballY_hAxes_ball_heart = -mediaR * sin(mTheta);
            ballX_Panel = ballX_hAxes_ball_heart - 5 + relativeDistanceX_hAxes_ball_Panel;
            ballY_Panel = ballY_hAxes_ball_heart - 5 + relativeDistanceY_hAxes_ball_Panel;
            hAxes_ball_posInfo = [ballX_Panel ballY_Panel ball_Width ball_Height];
            set(hAxes_ball, 'position', hAxes_ball_posInfo);
            
            hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
            Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
            Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
            edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
            finalAngle = 180*(pi/2 + edit_mTheta)/pi;
            tmpTheta = round(finalAngle);
            set(Edit_AngleSet, 'String', tmpTheta);
        elseif ballX_hAxes_ball_heart <= 0 && ballY_hAxes_ball_heart<=0      % Third quadrant
            mTheta = atan(abs(ballY_hAxes_ball_heart/ballX_hAxes_ball_heart));
            % calculate mTheta +1°
            mTheta = mTheta + 2*pi/360;
            ballX_hAxes_ball_heart = -mediaR * cos(mTheta);
            ballY_hAxes_ball_heart = -mediaR * sin(mTheta);
            ballX_Panel = ballX_hAxes_ball_heart - 5 + relativeDistanceX_hAxes_ball_Panel;
            ballY_Panel = ballY_hAxes_ball_heart - 5 + relativeDistanceY_hAxes_ball_Panel;
            hAxes_ball_posInfo = [ballX_Panel ballY_Panel ball_Width ball_Height];
            set(hAxes_ball, 'position', hAxes_ball_posInfo);
            
            hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
            Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
            Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
            edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
            finalAngle = 180*(3*pi/2 - edit_mTheta)/pi;
            tmpTheta = round(finalAngle);
            set(Edit_AngleSet, 'String', tmpTheta);
        elseif   ballX_hAxes_ball_heart <= 0 && ballY_hAxes_ball_heart>0 % Fourth quadrant
            mTheta = atan(abs(ballY_hAxes_ball_heart/ballX_hAxes_ball_heart));
            % calculate mTheta +1°
            mTheta = mTheta - 2*pi/360;
            ballX_hAxes_ball_heart = -mediaR * cos(mTheta);
            ballY_hAxes_ball_heart = mediaR * sin(mTheta);
            ballX_Panel = ballX_hAxes_ball_heart - 5 + relativeDistanceX_hAxes_ball_Panel;
            ballY_Panel = ballY_hAxes_ball_heart - 5 + relativeDistanceY_hAxes_ball_Panel;
            hAxes_ball_posInfo = [ballX_Panel ballY_Panel ball_Width ball_Height];
            set(hAxes_ball, 'position', hAxes_ball_posInfo);
            
            hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
            Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
            Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
            edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
            finalAngle = 180*(3*pi/2 + edit_mTheta)/pi;
            tmpTheta = round(finalAngle);
            set(Edit_AngleSet, 'String', tmpTheta);
        end
        mentalR_RotationFcn;
    end   % end of function Subtraction_ButtonDownFcn







% 5.7 mentalR
% 5.7.1 Create a Axes for R
% prepare the posInfo. for hAxes_mentalR
hAxes_mentalR_x = 110;
hAxes_mentalR_y = 95;
hAxes_mentalR_Width = 60;
hAxes_mentalR_Height = 60;
hAxes_mentalR = axes('parent',hPanel2_SetParameters);
set(hAxes_mentalR, 'units','pixels', 'position',[hAxes_mentalR_x hAxes_mentalR_y hAxes_mentalR_Width hAxes_mentalR_Height], 'color','w');
axis off;

% prepare R
mentalR_Char = 'R';
R_Width = 60;
R_Height = 60;

% prepare the font color for the 'R'
R_FontColor = [0.9 0.9 0.9];

imgMatrix_mentalR = ones(R_Height, R_Width, 3) * 255;
imgMatrix_mentalR(:,:,1) = 255;
imgMatrix_mentalR(:,:,2) = 255;
imgMatrix_mentalR(:,:,3) = 255;
imgMatrix_mentalR_Uint8 = uint8(imgMatrix_mentalR);
imgMatrix_mentalR_Uint8_mentalR = insertText(imgMatrix_mentalR_Uint8, [R_Width/2 R_Height/2], 'R', 'Font','Times','AnchorPoint','Center', 'BoxColor',[255 255 255], 'TextColor', R_FontColor, 'FontSize',60, 'TextColor',[160 160 160]);
% insertedpic = insertText(cBKGCanvas, pt_word, cWord, 'AnchorPoint','Center','BoxColor',bkgColor,'FontSize',30, 'TextColor',cFontColor);

% show the image matrix
imshow(imgMatrix_mentalR_Uint8_mentalR,'parent',hAxes_mentalR);

% show the 'R'
% imgMatrix_A_Rotation = text(R_Width/2, R_Height/2, mentalR_Char, 'parent',hAxes_mentalR,'fontname','Helvetica', 'HorizontalAlignment','center' ,'fontsize',40, 'fontweight','normal', 'fontangle', 'normal', 'color',R_FontColor, 'visible','on', 'units','pixels');


% ==> function mentalR_RotationFcn
    function mentalR_RotationFcn(~, ~, ~)
        % get the bkgColor
       
        
        
%         set(hAxes_mentalR, 'units','pixels', 'position',[hAxes_mentalR_x hAxes_mentalR_y hAxes_mentalR_Width hAxes_mentalR_Height], 'color','w');
%         imgMatrix_mentalR = ones(R_Height, R_Width, 3) * 255;
%         imgMatrix_mentalR_Uint8 = uint8(imgMatrix_mentalR);
        
        % get the angle
%         cRotation_AngleValue = finalAngle;
%         cRotation_AngleValue = 360 - cRotation_AngleValue;   % the angle value is clockwise(common sense), but the rotation angle value is counterclockwise
%         imgMatrix_mentalR_Uint8_mentalR = imrotate(imgMatrix_mentalR_Uint8_mentalR, cRotation_AngleValue, 'bicubic','crop');
        
        cRotation_AngleValue = finalAngle;
        cRotation_AngleValue = 360 - cRotation_AngleValue;   % the angle value is clockwise(common sense), but the rotation angle value is counterclockwise
        imgMatrix_mentalR_Uint8_mentalR = imcomplement(imgMatrix_mentalR_Uint8_mentalR);%将原图反色 
        imgMatrix_mentalR_Uint8_mentalR = imrotate(imgMatrix_mentalR_Uint8_mentalR, cRotation_AngleValue, 'bilinear','crop');
        imgMatrix_mentalR_Uint8_mentalR = imcomplement(imgMatrix_mentalR_Uint8_mentalR);%将图像反色回来
        

        
%         imgMatrix_mentalR_Uint8_mentalR_R = imgMatrix_mentalR_Uint8_mentalR(:,:,1);
%         imgMatrix_mentalR_Uint8_mentalR_G = imgMatrix_mentalR_Uint8_mentalR(:,:,2);
%         imgMatrix_mentalR_Uint8_mentalR_B = imgMatrix_mentalR_Uint8_mentalR(:,:,3);
        
%             I=imcomplement(I);%将原图反色 
%             Im=imrotate(I,0.5,'crop');%旋转一定角度
%             Im=imcomplement(Im);%将图像反色回来


%         imgMatrix_mentalR_Uint8_mentalR_R(imgMatrix_mentalR_Uint8_mentalR_R == 0) = 255;
%         imgMatrix_mentalR_Uint8_mentalR_G(imgMatrix_mentalR_Uint8_mentalR_G == 0) = 255;
%         imgMatrix_mentalR_Uint8_mentalR_B(imgMatrix_mentalR_Uint8_mentalR_B == 0) = 255;
%         
%         imgMatrix_mentalR_Uint8_mentalR(:,:,1) = imgMatrix_mentalR_Uint8_mentalR_R;
%         imgMatrix_mentalR_Uint8_mentalR(:,:,2) = imgMatrix_mentalR_Uint8_mentalR_G;
%         imgMatrix_mentalR_Uint8_mentalR(:,:,3) = imgMatrix_mentalR_Uint8_mentalR_B;
               
%         imgMatrix_mentalR_Uint8_mentalR = [imgMatrix_mentalR_Uint8_mentalR_R; imgMatrix_mentalR_Uint8_mentalR_G; imgMatrix_mentalR_Uint8_mentalR_B];
        %         set(imgMatrix_A_Rotation, 'rotation',cRotation_AngleValue);
        imshow(imgMatrix_mentalR_Uint8_mentalR,'parent',hAxes_mentalR);
        
%         imgMatrix_mentalR = ones(R_Height, R_Width, 3);
%         imgMatrix_mentalR_Uint8 = uint8(imgMatrix_mentalR);
        
        imgMatrix_mentalR_Uint8_mentalR = insertText(imgMatrix_mentalR_Uint8, [R_Width/2 R_Height/2], 'R', 'Font','Times','AnchorPoint','Center', 'BoxColor',[255 255 255], 'TextColor', R_FontColor, 'FontSize',60, 'TextColor',[160 160 160]);
    end    % end of function for mentalR rotation






% -------------------------------------------------------------------------
% 6. Panel 3
% -------------------------------------------------------------------------
% 6.1 create hAxes_PreviewBoard_BKGround and hAxes_PreviewBoard
% hAxes_PreviewBoard_BKGround
hAxes_PreviewBoard_BKGround = axes('parent',hPanel3_PreviewGeneratePictures);
set(hAxes_PreviewBoard_BKGround, 'units','pixels', 'position',[39 299 202 202], 'color','k', 'Xtick',[], 'Ytick',[]);
imgMatrix_PreviewBoard_BKGround = zeros(202,202,3) + 0.8;
imshow(imgMatrix_PreviewBoard_BKGround, 'parent',hAxes_PreviewBoard_BKGround);
axis off;

% hAxes_PreviewBoard
hAxes_PreviewBoard = axes('parent', hPanel3_PreviewGeneratePictures);
set(hAxes_PreviewBoard, 'units','pixels', 'position',[40 300 200 200], 'color',[0.95 0.95 0.95], 'Xtick',[], 'Ytick',[]);
imgMatrix_Preivew = ones(200, 200, 3) * 0.95;
imshow(imgMatrix_Preivew, 'parent',hAxes_PreviewBoard);
axis off;



% 6.2 --- create uicontrols for panel 3 ---
% 6.2.1 pushbutton for leftBtn,rightBtn,previewBtn
% leftBtn
leftBtn = uicontrol(hPanel3_PreviewGeneratePictures, 'Style','pushbutton', 'String','<', 'position',[10 380 20 40]);
% rightBtn
rightBtn = uicontrol(hPanel3_PreviewGeneratePictures, 'Style','pushbutton', 'String','>', 'position',[250 380 20 40]);
% previewBtn
previewBtn = uicontrol(hPanel3_PreviewGeneratePictures, 'Style','pushbutton', 'String','Preview', 'position',[40 255 200 25]);

% Create Saving Directory text
Text_Saving_Directory = uicontrol('Parent',hPanel3_PreviewGeneratePictures,'Style','text', 'Position',[40 215 90 20], 'String','Save Directory','BackgroundColor', 'White','FontSize',10, 'Visible','on');

% Create Popup uicontrol
Popup_StorageFormat = uicontrol('Parent',hPanel3_PreviewGeneratePictures,  'Style', 'popup', 'Position', [190 185 50 1],'String',{'.bmp', '.jpg', '.png', '.tiff','.gif'}, 'FontSize',8, 'Visible','on');

% Create the Editbox for saving directory
SavingPath = sprintf('%s', PicturesFolderName);
Edit_SavingDirectory =  uicontrol('Parent',hPanel3_PreviewGeneratePictures,'Style','edit', 'Position',[40 190 200 20], 'Enable','off', 'Visible','on');%'Enable','off',
set(Edit_SavingDirectory, 'String',SavingPath);

% Calculate the width of the String in the Saving Directory Editbox
SaveDirect_EditString_extent = get(Edit_SavingDirectory,'extent');
SaveDirect_EditString_extent_Width = SaveDirect_EditString_extent(3);

% Create the pushbutton "Directory Select"
Btn_Directory_Select = uicontrol('Parent',hPanel3_PreviewGeneratePictures,  'Style', 'pushbutton', 'Position', [40 165 105 20],'String', 'Directory Select','FontSize',10, 'Visible','on');
SaveDirect_EditString = get(Edit_SavingDirectory, 'String');

% Create the flashcard
flashCard_panel =  uipanel('Parent', hFigure1,'FontSize',8,'units','pixels','BackgroundColor','white','TitlePosition','lefttop','title',SaveDirect_EditString, 'Position',[0 0 1 1],'bordertype','none','Visible','off');
generate_flashCard_panel;

% ===> function generate_flashCard_panel
    function generate_flashCard_panel()
        if SaveDirect_EditString_extent_Width>201
            set(flashCard_panel, 'title',SavingPath);
            set(flashCard_panel,'Position',[PanelX_LoadWords-Panel_Panel_Interval-PanelWidth+40 PanelY_LoadWords+190 SaveDirect_EditString_extent_Width+3 21]);
        else
            set(flashCard_panel, 'title',SavingPath,'Visible','off');
            set(flashCard_panel,'Visible','off');
        end
    end

% generate button
generate_OnePictureBtn = uicontrol(hPanel3_PreviewGeneratePictures, 'Style','pushbutton', 'String','Generate ONE Picture', 'position',[40 115 200 25]);
generate_AllPicturesBtn = uicontrol(hPanel3_PreviewGeneratePictures, 'Style','pushbutton', 'String','Generate ALL Pictures', 'position',[40 75 200 25]);

% open directory
Pushbutton_OpenDir = uicontrol('Parent',hPanel3_PreviewGeneratePictures, 'Style','pushbutton', 'String','Open Picture''s files', 'position',[40 35 200 25]);

% === binding mechanism
set(leftBtn, 'Callback',@leftBtnFcn);
set(rightBtn, 'Callback',@rightBtnFcn);
set(previewBtn, 'Callback',@previewBtnFcn);
set(Btn_Directory_Select,'Callback',@Directory_SelectFcn);
set(generate_OnePictureBtn,'Callback',@generate_OnePictureBtnFcn);
set(generate_AllPicturesBtn,'Callback',@generate_AllPictureBtnFcn);
set(Pushbutton_OpenDir,'Callback',@OpenDirectoryFcn);


%
% 6.2.2 Directory_SelectFcn + generate_OnePictureBtnFcn
% ===> function leftBtnFcn
    function leftBtnFcn(~, ~, ~)
        if WordIndex > 1
            WordIndex = WordIndex - 1;
        end
        previewBtnFcn();
    end

% ===> function rightBtnFcn
    function rightBtnFcn(~, ~, ~)
        if WordIndex < WordsSum
            WordIndex = WordIndex + 1;
        end
        previewBtnFcn();
    end

% ==> function previewBtnFcn
    function previewBtnFcn(~, ~, ~)
        WordsListCells = get(Edit_WordsList, 'String');
        WordsSum = length(WordsListCells);
        if length(WordsListCells) == 1
            cWord = WordsListCells(WordIndex);
        else
            cWord = WordsListCells{WordIndex};
        end
        
        % mode1 fontname + fontsize + bold
        cFontName = sFont.FontName;
        cFontSize = sFont.FontSize;
        cFontWeight = sFont.FontWeight;
        cFontAngle = sFont.FontAngle;
        
        % mode2 fontcolor
        cFontColor = fColor;
        
        % mode3 bkground color
        cBKGroundColor = bkgColor;

        % picWidth + picHeight
        str_Width = get(Edit_Width,'string');
        str_Height = get(Edit_Height,'string');
        cWidth = str2num(str_Width);
        cHeight = str2num(str_Height);
        
        % Left or Middle or Right
        if get(RadiobuttonLeft,'Value')
            cAlign = 'left';
            textX = 0;
            pt_word = [0 cHeight/2];
            AnchorPointString = 'LeftCenter';
            
        elseif get(RadiobuttonMiddle,'Value')
            cAlign = 'center';
            textX = cWidth/2;
            pt_word = [cWidth/2 cHeight/2];
            AnchorPointString = 'Center';
            
        elseif get(RadiobuttonRight,'Value')
            cAlign = 'right';
            textX = cWidth;
            pt_word = [cWidth cHeight/2];
            AnchorPointString = 'RightCenter';
        end
        
        % prepare the Background Canvas
        cBKGCanvas = zeros(cHeight, cWidth, 3);
        cBKGCanvas(:,:,1) = bkgColor(1);
        cBKGCanvas(:,:,2) = bkgColor(2);
        cBKGCanvas(:,:,3) = bkgColor(3);
        
        % get the Angle value
        str_RotationAngle = get(Edit_AngleSet,'string');
        cRotation_AngleValue = str2num(str_RotationAngle);
        
        % create figure 2
        %         hFigure2 = figure(2);
        %         set(hFigure2, 'position',[500 300 cWidth cHeight], 'visible','off');  % set(hFigure2, 'position',[-cWidth-100 0 cWidth cHeight]);
        
        % create axes original
        %         hAxes_Original = axes('parent',hFigure1);
        %         set(hAxes_Original,'units','pixels', 'position',[1 1 cWidth cHeight],'visible','off'  , 'ytick',[], 'xtick',[]); %
        %         axis([-cWidth/2 cWidth/2 -cHeight/2 cHeight/2]);
        %         h_previewBKG = imshow(cBKGCanvas, 'Parent', hAxes_Original);
        %         set(hFigure2, 'visible','off');
        
        imgMatrix_insertText = insertText(cBKGCanvas, pt_word, cWord, 'Font',cFontName, 'AnchorPoint',AnchorPointString, 'BoxColor',bkgColor, 'FontSize',cFontSize, 'TextColor',cFontColor);
        
        imgMatrix_insertText = imgMatrix_insertText + 0.001;
        %
        %          insertedpic = AddTextToImage(cBKGCanvas, cWord, pt_word, cFontColor, cFontName, cFontSize);
        
        cRotation_AngleValue = 360 - cRotation_AngleValue;
        
        imgMatrix_insertText_Rot = imrotate(imgMatrix_insertText, cRotation_AngleValue, 'bilinear','crop');
        
        imgR = imgMatrix_insertText_Rot(:,:,1);
        imgG = imgMatrix_insertText_Rot(:,:,2);
        imgB = imgMatrix_insertText_Rot(:,:,3);
        
        imgMatrix_insertText_Rot_Gray = rgb2gray(imgMatrix_insertText_Rot);
        
        % 将 logicalMatrix 膨胀一点点
        logicalMatrix = imgMatrix_insertText_Rot_Gray == 0;
        SE = strel('square',3);
        logicalMatrix_Dil = imdilate(logicalMatrix,SE);
        
        
        imgR(logicalMatrix_Dil) = cBKGroundColor(1);
        imgG(logicalMatrix_Dil) = cBKGroundColor(2);
        imgB(logicalMatrix_Dil) = cBKGroundColor(3);
        
        imgMatrix_insertText_Com = cat(3, imgR, imgG, imgB);
        
%         imgMatrix_mentalR_Uint8_mentalR = imcomplement(imgMatrix_mentalR_Uint8_mentalR);%将原图反色 
%         imgMatrix_mentalR_Uint8_mentalR = imrotate(imgMatrix_mentalR_Uint8_mentalR, cRotation_AngleValue, 'bicubic','crop');
%         imgMatrix_mentalR_Uint8_mentalR = imcomplement(imgMatrix_mentalR_Uint8_mentalR);%将图像反色回来
        
%         I = imcomplement(I);%将原图反色 
%         Im=imrotate(I,0.5,'crop');%旋转一定角度
%             Im=imcomplement(Im);%将图像反色回来   
        
        
        %         printWord = text(textX, cHeight/2, cWord, 'parent',hAxes_Original,'fontname',cFontName, 'HorizontalAlignment',cAlign ,'fontsize',cFontSize, 'fontweight',cFontWeight, 'fontangle',cFontAngle, 'color',fColor, 'visible','on', 'units','pixels'); %,
        
        %         set(printWord, 'rotation',cRotation_AngleValue);
        %         hFrame_hAxes_Original = getframe(hAxes_Original);
        %         imgMatrix_Text = hFrame_hAxes_Original.cdata;
        h_previewimg = imshow(imgMatrix_insertText_Com, 'parent',hAxes_PreviewBoard);
        %         close(hFigure2);
    end % end of preview function

% ===> function Directory_SelectFcn
    function Directory_SelectFcn(~, ~, ~)
        Directory_Select_PathNames = sprintf('%s/*.txt', PicturesFolderName);
        Directory_Selectdir = uigetdir(Directory_Select_PathNames);
        SaveDirect_EditString_Cancle = get(Edit_SavingDirectory, 'String');
        
        if isequal(Directory_Selectdir,0)
            set(Edit_SavingDirectory, 'String',SaveDirect_EditString_Cancle);
        else
            set(Edit_SavingDirectory, 'String', Directory_Selectdir);
            SavingPath = Directory_Selectdir;
            SaveDirect_EditString_extent = get(Edit_SavingDirectory,'extent');
            SaveDirect_EditString_extent_Width = SaveDirect_EditString_extent(3);
        end
        generate_flashCard_panel; % when update the saving direction, re-generate the flashcard of the saving direction
        
    end   % end of function Directory_SelectFcn

% ===> function generate_OnePictureBtnFcn
    function generate_OnePictureBtnFcn(~, ~, ~)
        WordsListCells = get(Edit_WordsList, 'String');
        WordsSum = length(WordsListCells);
        if length(WordsListCells) == 1
            cWord = WordsListCells(WordIndex);
        else
            cWord = WordsListCells{WordIndex};
        end
        Name_cWords =cWord;
        cWord(find(isspace(cWord)))=[];
        PopupStringsList = get(Popup_StorageFormat,'String');
        PopupValue = get(Popup_StorageFormat,'Value');
        cFileExtention = PopupStringsList{PopupValue};
        pictureFileName = sprintf('%s%s', cWord, cFileExtention);
        picturePath = get(Edit_SavingDirectory, 'String');
        picturePathName = sprintf('%s/%s', picturePath, pictureFileName);
        
        cFontName = sFont.FontName;
        cFontSize = sFont.FontSize;
        cFontWeight = sFont.FontWeight;
        cFontAngle = sFont.FontAngle;
        cFontColor = fColor;
        cBKGroundColor = bkgColor;
        
        str_Width = get(Edit_Width,'string');
        str_Height = get(Edit_Height,'string');
        cWidth = str2num(str_Width);
        cHeight = str2num(str_Height);
        
        % Left or Middle or Right
        if get(RadiobuttonLeft,'Value')
            cAlign = 'left';
            textX = 0;
            pt_word = [0 cHeight/2];
            AnchorPointString = 'LeftCenter';
            
        elseif get(RadiobuttonMiddle,'Value')
            cAlign = 'center';
            textX = cWidth/2;
            pt_word = [cWidth/2 cHeight/2];
            AnchorPointString = 'Center';
            
        elseif get(RadiobuttonRight,'Value')
            cAlign = 'right';
            textX = cWidth;
            pt_word = [cWidth cHeight/2];
            AnchorPointString = 'RightCenter';
        end
        
        cBKGCanvas = zeros(cHeight, cWidth, 3);
        cBKGCanvas(:,:,1) = cBKGroundColor(1);
        cBKGCanvas(:,:,2) = cBKGroundColor(2);
        cBKGCanvas(:,:,3) = cBKGroundColor(3);
        
        str_RotationAngle = get(Edit_AngleSet,'string');
        cRotation_AngleValue = str2num(str_RotationAngle);
        cRotation_AngleValue = 360 - cRotation_AngleValue;
        
        % 

        imgMatrix_insertText = insertText(cBKGCanvas, pt_word, cWord, 'Font',cFontName, 'AnchorPoint',AnchorPointString, 'BoxColor',bkgColor, 'FontSize',cFontSize, 'TextColor',cFontColor);
        imgMatrix_insertText = imgMatrix_insertText + 0.001;
        
        imgMatrix_insertText_Rot = imrotate(imgMatrix_insertText, cRotation_AngleValue, 'bilinear','crop');
        
        imgR = imgMatrix_insertText_Rot(:,:,1);
        imgG = imgMatrix_insertText_Rot(:,:,2);
        imgB = imgMatrix_insertText_Rot(:,:,3);
        
        imgMatrix_insertText_Rot_Gray = rgb2gray(imgMatrix_insertText_Rot);
        
        % 将 logicalMatrix 膨胀一点点
        logicalMatrix = imgMatrix_insertText_Rot_Gray == 0;
        SE = strel('square',3);
        logicalMatrix_Dil = imdilate(logicalMatrix,SE);
        
        
        imgR(logicalMatrix_Dil) = cBKGroundColor(1);
        imgG(logicalMatrix_Dil) = cBKGroundColor(2);
        imgB(logicalMatrix_Dil) = cBKGroundColor(3);
        
        imgMatrix_insertText_Com = cat(3, imgR, imgG, imgB);
                
        % sizeText = size(imgMatrix_Text);
        imshow(imgMatrix_insertText_Com, 'parent',hAxes_PreviewBoard);
  
        switch cFileExtention
            case '.bmp'
                imwrite(imgMatrix_insertText_Com, picturePathName, 'BMP');
            case '.jpg'
                imwrite(imgMatrix_insertText_Com, picturePathName, 'JPEG');
            case '.png'
                imwrite(imgMatrix_insertText_Com, picturePathName, 'PNG');
            case '.tiff'
                imwrite(imgMatrix_insertText_Com, picturePathName, 'TIFF');
            case '.gif'
                imwrite(imgMatrix_insertText_Com, picturePathName, 'GIF');
        end
    end   % end of function generate_OnePictureBtnFcn



% 6.3 preview function
% ===> function generate_AllPictureBtnFcn
    function generate_AllPictureBtnFcn(~, ~, ~)
        h_Waitbar = waitbar(0,'please wait...', 'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
        setappdata(h_Waitbar,'canceling',0);
        
        for i = 1:WordsSum
            WordIndex = i;
            if getappdata(h_Waitbar,'canceling')  % getappdata 查询当前的句柄数据，如果按了【取消】键终止程序
                break
            end
            
            if i == WordsSum  %计算步数为1到100，如果是100的话，显示计算完成
                waitbar(i/WordsSum,h_Waitbar,'完成')   %waitbar（进度比例取值0到1，h进度条句柄，string）
                pause(0.05);   %没有实质意义，只是使显示的信息稍微延迟一些时间，以便看清。
            else
                str=['正在生成中',num2str(fix(100*i/WordsSum)),'%...'];
                waitbar(i/WordsSum,h_Waitbar,str);
                pause(0.05);
            end
            
            previewBtnFcn;
            generate_OnePictureBtnFcn;
        end
        delete(h_Waitbar);
    end

% ===> function OpenDirectoryFcn
    function OpenDirectoryFcn(~, ~, ~)
        winopen(Edit_SavingDirectory.String);
    end







% ---------------------------------------------------------------------------
% Binding Mechanism on the main figure
% ---------------------------------------------------------------------------
set(hFigure1, 'WindowButtonMotionFcn', @hFigure1_WindowButtonMotionFcn);
set(hFigure1, 'WindowButtonDownFcn', @hFigure1_WindowButtonDownFcn);
set(hFigure1, 'WindowButtonUpFcn', @hFigure1_WindowButtonUpFcn);

% ==> function hFigure1_WindowButtonMotionFcn
    function hFigure1_WindowButtonMotionFcn(~, ~, ~)
        BKGround_pt = get(hAxes_BackGround, 'CurrentPoint');
        BKGround_pt_x = BKGround_pt(1);
        BKGround_pt_y = BKGround_pt(3);
        CCWbtn_Field = BKGround_pt_x <= 770 & BKGround_pt_x > 740 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        CWbtn_Field = BKGround_pt_x <= 930 & BKGround_pt_x > 905 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        %fprintf('%f %f \n',BKGround_pt_x,BKGround_pt_y);  请不要删掉这行代码。
        
        if CCWbtn_Field
            set(hAxes_CCWBKGround_Arrow_off,'visible','off');
            set(h_CCWBtnImage_Off,'visible','off');
            set(hAxes_CCWBKGround_Arrow_press,'visible','off');
            set(h_CCWBtnImage_Press,'visible','off');
            set(h_CCWBtnImage_On,'visible','on');
            state_Mouse_In_Btn_Left = 1;
        else
            set(hAxes_CCWBKGround_Arrow_press,'visible','off');
            set(h_CCWBtnImage_Press,'visible','off');
            set(hAxes_CCWBKGround_Arrow_on,'visible','off');
            set(h_CCWBtnImage_On,'visible','off');
            set(h_CCWBtnImage_Off,'visible','on');
            state_Mouse_In_Btn_Left = 0;
        end
        
        if CWbtn_Field
            set(hAxes_CWBKGround_Arrow_off,'visible','off');
            set(h_CWBtnImage_Off,'visible','off');
            set(hAxes_CWBKGround_Arrow_press,'visible','off');
            set(h_CWBtnImage_Press,'visible','off');
            set(h_CWBtnImage_On,'visible','on');
            state_Mouse_In_Btn_Left = 1;
        else
            set(hAxes_CWBKGround_Arrow_press,'visible','off');
            set(h_CWBtnImage_Press,'visible','off');
            set(hAxes_CWBKGround_Arrow_on,'visible','off');
            set(h_CWBtnImage_On,'visible','off');
            set(h_CWBtnImage_Off,'visible','on');
            state_Mouse_In_Btn_Left = 1;
        end
        
        if mouseDown_State == 1
            % when the ball move, set the middle radiobutton true
            RadiobuttonMiddle_CallbackFcn;
            pt = get(hAxes_BigRound,'CurrentPoint');
            pt_x = pt(1);
            pt_y = pt(3);
            
            hAxes_BigRound_Field = pt_x > -75 && pt_x <75 && pt_y > -75 && pt_y < 75;
            if hAxes_BigRound_Field
                if pt_x > 0 && pt_y>0             % First quadrant
                    mBeta = atan(pt_y/pt_x);     % Angle
                    circle_x = mediaR * cos(mBeta);
                    circle_y = mediaR * sin(mBeta);
                    ballx_toPanel = circle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
                    bally_toPanel = circle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
                    ballposInfo = [ballx_toPanel bally_toPanel ball_Width ball_Height];
                    set(hAxes_ball, 'position',ballposInfo);
                    
                    % Print degrees into editbox
                    hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
                    Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
                    Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
                    edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
                    finalAngle = 180*(pi/2 - edit_mTheta)/pi;
                    tmpTheta = round(finalAngle);
                    set(Edit_AngleSet, 'String', tmpTheta);
                elseif pt_x > 0 && pt_y<0     % Second quadrant
                    mBeta = atan(pt_y/pt_x);     %Angle
                    circle_x = mediaR * cos(mBeta);
                    circle_y = mediaR * sin(mBeta);
                    ballx_toPanel = circle_x -5+ relativeDistanceX_hAxes_ball_Panel;
                    bally_toPanel = circle_y -5 + relativeDistanceY_hAxes_ball_Panel;
                    ballposInfo = [ballx_toPanel bally_toPanel ball_Width ball_Height];
                    set(hAxes_ball, 'position',ballposInfo);
                    
                    hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
                    Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
                    Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
                    edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
                    finalAngle = 180*(pi/2 + edit_mTheta)/pi;
                    tmpTheta = round(finalAngle);
                    set(Edit_AngleSet, 'String', tmpTheta);
                elseif pt_x < 0 && pt_y<0   % Third quadrant
                    mBeta = atan(abs(pt_y/pt_x));
                    circle_x = -mediaR * cos(mBeta);
                    circle_y = -mediaR * sin(mBeta);
                    ballx_toPanel = circle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
                    bally_toPanel = circle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
                    ballposInfo = [ballx_toPanel bally_toPanel ball_Width ball_Height];
                    set(hAxes_ball, 'position',ballposInfo);
                    
                    hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
                    Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
                    Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
                    edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
                    finalAngle = 180*(3*pi/2 - edit_mTheta)/pi;
                    tmpTheta = round(finalAngle);
                    set(Edit_AngleSet, 'String', tmpTheta);
                else
                    mBeta = atan(abs(pt_y/pt_x));    % Fourth quadrant
                    circle_x = -mediaR * cos(mBeta);
                    circle_y = mediaR * sin(mBeta);
                    ballx_toPanel = circle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
                    bally_toPanel = circle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
                    ballposInfo = [ballx_toPanel bally_toPanel ball_Width ball_Height];
                    set(hAxes_ball, 'position',ballposInfo);
                    
                    hAxes_edit_ball_posInfo = get(hAxes_ball, 'position');
                    Edit_ballX_hAxes_ball_heart = hAxes_edit_ball_posInfo(1) + 5 - relativeDistanceX_hAxes_ball_Panel;
                    Edit_ballY_hAxes_ball_heart = hAxes_edit_ball_posInfo(2) + 5 - relativeDistanceY_hAxes_ball_Panel;
                    edit_mTheta = atan(abs(Edit_ballY_hAxes_ball_heart/Edit_ballX_hAxes_ball_heart));
                    finalAngle = 180*(3*pi/2 + edit_mTheta)/pi;
                    tmpTheta = round(finalAngle);
                    set(Edit_AngleSet, 'String', tmpTheta);
                end  % pt_x > 0 & pt_y>0
            end % if in hAxes_BigRound_Field
            mentalR_RotationFcn;
        else
            % saveDirectory_Edit_Field for flashcard
            saveDirectory_Edit_Field = BKGround_pt_x > PanelX_LoadWords-Panel_Panel_Interval-PanelWidth+40 & BKGround_pt_x <PanelX_LoadWords-Panel_Panel_Interval-PanelWidth+240  & BKGround_pt_y >PanelY_LoadWords+190 & BKGround_pt_y <PanelY_LoadWords+ 210;
            if saveDirectory_Edit_Field
                % flashCard
                set(flashCard_panel,'visible','on');
                if SaveDirect_EditString_extent_Width>201
                    set(flashCard_panel, 'title',SavingPath);
                    set(flashCard_panel,'Position',[PanelX_LoadWords-Panel_Panel_Interval-PanelWidth+40 PanelY_LoadWords+190 SaveDirect_EditString_extent_Width+3 21]);
                else
                    set(flashCard_panel, 'title',SavingPath,'Visible','off');
                    set(flashCard_panel,'Visible','off');
                end
            else
                set(flashCard_panel,'visible','off');
            end
            
            % LoadPath_Edit_Field for flashcard  [Edit_txtPathName_relativeX Edit_txtPathName_relativeY Load_FlashCardString_extent_Width+3 21]
            LoadPath_Edit_Field = BKGround_pt_x > PanelX_LoadWords+Edit_txtPathName_relativeX & BKGround_pt_x <PanelX_LoadWords+Edit_txtPathName_relativeX+Edit_txtPathName_Width  & BKGround_pt_y >PanelY_LoadWords+Edit_txtPathName_relativeY & BKGround_pt_y <PanelY_LoadWords+ Edit_txtPathName_relativeY+30;
            if LoadPath_Edit_Field
                %                 flashCard
                set(LoadPath_flashCard_panel,'visible','on');
                if Load_FlashCardString_extent_Width>201
                    set(LoadPath_flashCard_panel, 'title',Load_FlashCardString);
                    set(LoadPath_flashCard_panel,'Position',[PanelX_LoadWords+Edit_txtPathName_relativeX PanelY_LoadWords+Edit_txtPathName_relativeY Load_FlashCardString_extent_Width+3 21]);
                else
                    set(LoadPath_flashCard_panel, 'title',Load_FlashCardString,'Visible','off');
                    set(LoadPath_flashCard_panel,'Visible','off');
                end
            else
                set(LoadPath_flashCard_panel,'visible','off');
            end
            
            % FontSet_Edit_Field for flashcard  [PanelX_LoadWords++Panel_Panel_Interval+PanelWidth+Edit_FontSetBox_relativeX PanelY_LoadWords+Edit_FontSetBox_relativeY FontSet_FlashCardString_extent_Width+3 21]
            FontSet_Edit_Field = BKGround_pt_x > PanelX_LoadWords+Panel_Panel_Interval+PanelWidth+Edit_FontSetBox_relativeX & BKGround_pt_x <PanelX_LoadWords++Panel_Panel_Interval+PanelWidth+Edit_FontSetBox_relativeX+Edit_FontSetBox_Width  & BKGround_pt_y >PanelY_LoadWords+Edit_FontSetBox_relativeY & BKGround_pt_y <PanelY_LoadWords+Edit_FontSetBox_relativeY+20;
            if FontSet_Edit_Field
                if FontSet_FlashCardString_extent_Width>218
                    %                 generate_FontSet_flashCard_panel;
                    set(FontSet_flashCard_panel,'title',FontSet_FlashCardString);
                    set(FontSet_flashCard_panel,'Position',[PanelX_LoadWords+Panel_Panel_Interval+PanelWidth+Edit_FontSetBox_relativeX PanelY_LoadWords+Edit_FontSetBox_relativeY FontSet_FlashCardString_extent_Width+3 21]);
                    set(FontSet_flashCard_panel,'visible','on');
                    
                else
                    set(FontSet_flashCard_panel, 'title',FontSet_FlashCardString,'Visible','off');
                    set(FontSet_flashCard_panel,'Visible','off');
                end
            else
                set(FontSet_flashCard_panel,'Visible','off');
            end
            
            
        end % mouseDown_State == 1
    end  % for hFigure_WindowButtonMotionFcn

% ==> function hFigure1_WindowButtonDownFcn
    function hFigure1_WindowButtonDownFcn(~, ~, ~)
        mouseDown_State = 1;
        % get mouse point x y
        BKGround_pt = get(hAxes_BackGround, 'CurrentPoint');
        BKGround_pt_x = BKGround_pt(1);
        BKGround_pt_y = BKGround_pt(3);
        
        CCWbtn_Field = BKGround_pt_x <= 765 & BKGround_pt_x > 735 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        CWbtn_Field = BKGround_pt_x <= 930 & BKGround_pt_x > 905 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        
        FontColorSet_Field = BKGround_pt_x<=PanelX_LoadWords+Panel_Panel_Interval+PanelWidth+Pushbutton_FontColorSetBox_relativeX-10 & BKGround_pt_x >=PanelX_LoadWords+Panel_Panel_Interval+PanelWidth+Pushbutton_FontColorSetBox_relativeX-30 & BKGround_pt_y <= PanelY_LoadWords+Pushbutton_FontColorSetBox_relativeY+20 & BKGround_pt_y >=PanelY_LoadWords+Pushbutton_FontColorSetBox_relativeY;
        BKGColorSet_Field = BKGround_pt_x<= PanelX_LoadWords+Panel_Panel_Interval+PanelWidth+Pushbutton_FontBKGroundColorSetBox_relativeX-10 & BKGround_pt_x>= PanelX_LoadWords+Panel_Panel_Interval+PanelWidth+Pushbutton_FontBKGroundColorSetBox_relativeX-30 & BKGround_pt_y <= PanelY_LoadWords+Pushbutton_FontBKGroundColorSetBox_relativeY+20 & BKGround_pt_y >=PanelY_LoadWords+Pushbutton_FontBKGroundColorSetBox_relativeY;
        %fprintf('%f %f \n',BKGround_pt_x,BKGround_pt_y);  请不要删掉这行代码。
        if FontColorSet_Field && mouseDown_State == 1
            Btn_FontColorFcn;
        else
        end
        
        if BKGColorSet_Field && mouseDown_State == 1
            Btn_BKGColorFcn;
        else
        end
        
        
        
        if CCWbtn_Field
            %imshow(resize_imgMatrix_Press, 'parent',hAxes_BKGround_Arrow_off)
            set(hAxes_CCWBKGround_Arrow_off,'visible','off');
            set(h_CCWBtnImage_Off,'visible','off');
            set(hAxes_CCWBKGround_Arrow_on,'visible','off');
            set(h_CCWBtnImage_On,'visible','off');
            set(h_CCWBtnImage_Press,'visible','on');
            Subtraction_ButtonDownFcn;
        elseif CWbtn_Field
            set(hAxes_CWBKGround_Arrow_off,'visible','off');
            set(h_CWBtnImage_Off,'visible','off');
            set(hAxes_CWBKGround_Arrow_on,'visible','off');
            set(h_CWBtnImage_On,'visible','off');
            set(h_CWBtnImage_Press,'visible','on');
            Addition_ButtonDownFcn;
        end
    end   % end of function hFigure1_WindowButtonDownFcn

% ==> function hFigure1_WindowButtonUpFcn
    function hFigure1_WindowButtonUpFcn(~, ~, ~)
        mouseDown_State = 0;
        BKGround_pt = get(hAxes_BackGround, 'CurrentPoint');
        BKGround_pt_x = BKGround_pt(1);
        BKGround_pt_y = BKGround_pt(3);
        % counterclockwise button field
        CCWbtn_Field = BKGround_pt_x <= 770 & BKGround_pt_x > 740 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        % clockwise button field
        CWbtn_Field = BKGround_pt_x <= 930 & BKGround_pt_x > 905 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        if CCWbtn_Field
            set(hAxes_CCWBKGround_Arrow_off,'visible','off');
            set(h_CCWBtnImage_Off,'visible','off');
            set(hAxes_CCWBKGround_Arrow_press,'visible','off');
            set(h_CCWBtnImage_Press,'visible','off');
            set(h_CCWBtnImage_On,'visible','on');
        elseif CWbtn_Field
            set(hAxes_CWBKGround_Arrow_off,'visible','off');
            set(h_CWBtnImage_Off,'visible','off');
            set(hAxes_CWBKGround_Arrow_press,'visible','off');
            set(h_CWBtnImage_Press,'visible','off');
            set(h_CWBtnImage_On,'visible','on');
        end
    end   % end of function hFigure1_WindowButtonUpFcn












% -------------------------------------------------------------------------
% 7. Copyright (c) School of Psychology, Beijing Normal University
% -------------------------------------------------------------------------
Copyright_Color = [0.2 0.2 0.2];  % gray color
copyright_text_name = 'Copyright \copyright 2017-2018 School of Psychology, Beijing Normal University all rights reserved.';
% copyright_text_C = text(WinWidth/2 , 40 ,copyright_text_name , 'parent',hAxes_BackGround, 'units','pixels', 'fontname','arial', 'HorizontalAlignment','center' ,'fontsize',9,  'fontangle','normal', 'color',Copyright_Color, 'visible','on');
text(WinWidth/2 , 40 ,copyright_text_name , 'parent',hAxes_BackGround, 'units','pixels', 'fontname','arial', 'HorizontalAlignment','center' ,'fontsize',9,  'fontangle','normal', 'color',Copyright_Color, 'visible','on');

copyright_text_Email = 'Anything about the suggestions or questions, please feel free to contact us : psytingjiang@gmail.com';
% copyright_text_E = text( WinWidth/2  , 20 ,copyright_text_Email , 'parent',hAxes_BackGround, 'units','pixels','fontname','arial', 'HorizontalAlignment','center' ,'fontsize',8,  'fontangle','normal', 'color',Copyright_Color, 'visible','on');
text( WinWidth/2  , 20 ,copyright_text_Email , 'parent',hAxes_BackGround, 'units','pixels','fontname','arial', 'HorizontalAlignment','center' ,'fontsize',8,  'fontangle','normal', 'color',Copyright_Color, 'visible','on');









% -------------------------------------------------------------------------
% 8. Pause, show the preview picture
% -------------------------------------------------------------------------
% pause(0.2);
% set(hFigure1,'position',[WinX WinY WinWidth WinHeight]);
previewBtnFcn;

% y = 1
y = 1;


end