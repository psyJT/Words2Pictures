function [] = Words2PicturesS(~)

% --- Usage ---
%  Generate Picture(s) with Word(s)
%
% --- Authors ---
%  Ting Jiang, Hengyang Zhang, Tianwei Gong, Si Cheng, and Weiping Chen
%
%  Ting Jiang, 2017.3.27, in School of Psychology, Beijing Normal University
%  E-Mail: psytingjiang@gmail.com or WeChat: 10045198
%
%  Hengyang Zhang, 2017.4.12, in School of Psychology, Beijing Normal University
%  E-Mail: xfyhzhy13582@foxmail.com
%
%  Tianwei Gong, developed an important Matlab version of Words2Pictures previously,
%  which provide substantial inspiration and significant contribution for this version
%  E-Mail: gongtiw@gmail.com
%
%  this version was updated by Ting Jiang, Si Cheng, and Weiping Chen, 2018.1.12 - 2018.2.26, including the points mentioned below:
%  (1) The getframe method has its limit(white edge), we fix this bug
%  (2) Debug the flash problem when initializing the figure
%  (3) Use 2 or more than 2 figures, showing the main figure and hide these affiliated figures
%  (4) The buttondown initiated "Compass", which can provide immediate mental rotation "R" feedback, is the most crucial update for this version
%  (5) We generate the icon in png file format by using Matlab codes, used on the title bar, system taskbar and desktop icon
%  (6) We generate the buttons(off, on, and press) in png file formats by using Matlab codes, in order to support the point (7)
%  (7) The default button-callback binding mechanism has been replaced by the new figure mechanism(windowbuttonmotionfcn + windowbuttondownfcn + windowbuttonupfcn), to improve the user experience

%  this new version can be used under both PCWin and MacOS systems, updated on 2020.12.23 by psyjt

% --- Outline ---
% 1. General setting ............................................. Line 111
% 1.1 warning off
% 1.2 prepare zone
% 1.3 prepare three folders
% 1.3.1 Folder (1): Resource Folder
% 1.3.2 Folder (2): Text Folder
% 1.3.3 Folder (3): Picture Folder
% 1.4 figure/window information
% 2. Create a figure ............................................. Line 211
% 2.1 Change the window's icon on the title bar
% 2.2 Add the background picture
% 3 Create 3 panels .............................................. Line 231
% 3.1 prepare
% 3.2 three panels
% 4. Panel 1 ..................................................... Line 271
% 4.1 Prepare
% 4.2 Create uicontrols in the Panel 1 ........................... Line 281
% 4.2.1 Create a Editbox
% 4.2.2 Create a PushButton
% 4.2.3 Create a Editbox
% 4.2.4 Create a PushButton
% 4.3 Binding mechanism in the Panel 1 ........................... Line 316
% 4.3.1 function Btn_LoadWordsFcn 
% 4.3.2 function Btn_WriteWordsFcn
% 4.3.3 Initialize the Edit_WordsList
% 5. Panel 2 ..................................................... Line 361
% 5.1 Mode(1): create uicontrolls for the "Font select" 
% 5.1.1 Add a Text
% 5.1.2 Create a Editbox
% 5.1.3 Create a PushButton
% 5.1.4 Binding mechanism in the Panel 2: Mode(1)
% 5.1.5 functions
% 5.2 Mode(2): create uicontrolls for the "Font color select" .... Line 441
% 5.2.1 Create a Text
% 5.2.2 Create a Editbox
% 5.2.3 Create a PushButton
% 5.2.4 imshow FontColor
% 5.2.5 function
% 5.3 Mode(3): create uicontrols for the "BKGround color select" . Line 485
% 5.3.1 Create a Text
% 5.3.2 Create a Editbox
% 5.3.3 Create a PushButton
% 5.3.4 imshow BKGround Color
% 5.3.5 function
% 5.4 Mode(4): create uicontrols for the "Width and Height" ...... Line 543
% 5.4.1 Create Texts for Width and Height
% 5.4.2 Create Editboxes for Width and Height
% 5.5 Mode(5): create uicontrols for the 'Radiobuttons( L/M/R )' . Line 626
% 5.5.1 Create Radios for Radiobuttons( L/M/R )
% 5.5.2 Create Editboxs for Radiobuttons( L/M/R )
% 5.5.3 function
% 5.6 mode(6): create compass for panel 2 --- new! & important! .. Line 681
% 5.6.1 prepare & draw the compass
% 5.6.2 Create a Editbox
% 5.6.3 CounterClockwise vs. ClockWise Buttons ................... Line 811
% 5.6.4 function
% 5.7 mentalR
% 6. Panel 3 .................................................... Line 1280
% 6.1 prepare
% 6.2 create uicontrols for panel 3
% 6.2.1 Create pushbuttons for leftBtn, rightBtn, and previewBtn
% 6.2.2 prepare for preview
% 6.3 functions
% 7. Copyright .................................................. Line 1534
% 8. Pause and show the figure .................................. Line 1543
% 9. Generate the icon/logo ..................................... Line 1550
% 10. Generate two Arrow Buttons in png format .................. Line 1608












% -------------------------------------------------------------------------
% 1. General setting
% 1.1 warning off
% warning off;  %
warning('off', 'all');

% 1.2 prepare zone
% prepare the current working path
CurrentWorkingPath = fileparts(mfilename('fullpath'));

% prepare 3 folder names
ResourceFolderName = 'ResourceFolder';
TextFolderName = 'TextFolder';
PicturesFolderName = 'PictureFolder';

% 1.3.1 Folder (1): Resource Folder
% prepare the resource folder path
ResourcePath = sprintf('%s/%s', CurrentWorkingPath, ResourceFolderName);

% judge whether the resource folder exist, if not, mkdir
% create the logo png file via function
% create clockwise and counterclockwise png images for arrow buttons via function
if ~exist(ResourcePath,'dir')
    mkdir(ResourcePath); % make directory
    
    pngFontName = 'Times New Roman';  % prepare the fontname for 'R'
    pngFileName = 'mentalR_icon.png'; % prepare the filename
    pngPathName = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, pngFileName); % prepare the pathname
    
    generatePNGpicture_mentalR(pngFontName, pngPathName);  % generate the mental 'R' png picture by function generatePNGpicture on Line 1682
    
    % gateway to the function that create the clockwise and counterclockwise png images for arrow buttons
    generatePNGpictures_2ArrowButtons();
    
end

% 1.3.2 Folder (2): Text Folder
% prepare the Chinese Animal words cells and the Arabic digits cells for creating 2 text files in the Text Folder
WordsList_Cells = {'Rat'; 'Ox'; 'Tiger'; 'Rabbit'; 'Dragon'; 'Snake'; 'Horse'; 'Goat'; 'Monkey'; 'Rooster'; 'Dog'; 'Pig'};
ArabicDigitsList_Cells = {'0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'};

% prepare the text folder path
TextPath = sprintf('%s/%s', CurrentWorkingPath, TextFolderName);

% two text FileNames for Chinese Animals and Arabic Digits
Twelve_Chinese_Zodiac_textFileName = 'Twelve_Chinese_Zodiac_List.txt';
ArabicDigits_0_9_textFileName = 'ArabicDigits_0_9_List.txt';

% two text PathNames for Chinese Animals and Arabic Digits
Chinese_Zodiac_textPathName = sprintf('%s/%s', TextPath, Twelve_Chinese_Zodiac_textFileName);
Arabic_Digits_textPathName = sprintf('%s/%s', TextPath, ArabicDigits_0_9_textFileName);

% judge whether the text folder exist, if not, mkdir and create 2 text files
if ~exist(TextFolderName,'dir')
    mkdir(TextPath);
    
    % create a text file with Arabic digits
    fid_Digits = fopen(Arabic_Digits_textPathName, 'w+');
    for iNumWord = 1:length(ArabicDigitsList_Cells)
        tmpWord = ArabicDigitsList_Cells{iNumWord};
        fprintf(fid_Digits, '%s\r\n', tmpWord);
    end
    fclose(fid_Digits);
    
    % create a text file with Chinese Animal words
    fid_Chinese_Zodiac = fopen(Chinese_Zodiac_textPathName, 'w+');
    for iNumWord = 1:length(WordsList_Cells)
        tmpWord = WordsList_Cells{iNumWord};
        fprintf(fid_Chinese_Zodiac, '%s\r\n', tmpWord);
    end
    fclose(fid_Chinese_Zodiac);
end

% 1.3.3 Folder (3): Picture Folder
% prepare picture folder path, for saving Pictures
PicturePath = sprintf('%s/%s', CurrentWorkingPath, PicturesFolderName);

% judge whether the Picture Folder exist, if not, mkdir
if ~exist(PicturePath,'dir')
    mkdir(PicturePath);
end



% 1.4 Window/Figure information
% get the boot/screen position information
Screen_PositionInfo = get(0,'screensize');   % get the screen size info. array that has 4 paramenter, including x y width and height
Screen_Width = Screen_PositionInfo(3);       % get the width from the screen size info. array
Screen_Height = Screen_PositionInfo(4);      % get the height from the screen size info. array

% set the window position information
WinWidth = 1024;    % set the window width
WinHeight = 650;    % set the window height

% calculate the Window X and Y & prepare a Window Hide X
WinX = (Screen_Width - WinWidth)/2;     % prepare the initial x value for the window
WinY = (Screen_Height - WinHeight)/2;   % prepare the initial y value for the window
WinX_Hide = -1600;                      % to hide the window, -1600 is a good x parameter


% -------------------------------------------------------------------------
% 2. Create a figure
hFigure1 = figure(1);
set(hFigure1, 'position',[WinX WinY WinWidth WinHeight], 'toolbar','none', 'NumberTitle','off', 'Name',' Words 2 Pictures', 'resize','off', 'menubar','none', 'color','w');
set(hFigure1, 'visible','off');

% 2.1 Change the window's icon on the title bar
newIcon_FileName = 'mentalR_icon.png';
newIcon_PathName = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, newIcon_FileName);   % prepare the icon's full pathname
newIcon = javax.swing.ImageIcon(newIcon_PathName);   % delete the background of the icon
figFrame = get(hFigure1,'JavaFrame');       % get the Figure's JavaFrame。
figFrame.setFigureIcon(newIcon);    % then change the icon

% 2.2 Add the white background picture
hAxes_BackGround = axes('parent',hFigure1);
set(hAxes_BackGround, 'units','pixels', 'position',[0 0 WinWidth WinHeight], 'color','w', 'Xtick',[], 'Ytick',[]);     % 'color','w' == 'color',[1 1 1]
%  set(gca,’xtick’,[]) == hide the calibration of X-axis
axis([0 WinWidth 0 WinHeight]);    % set the X-axis [0 WinWidth] and set the Y-axis [0 WinHeight]
axis off;                          % hide the axis


% -------------------------------------------------------------------------
% 3 Create 3 panels: Load Words, Set Parameters, and Generate Pictures
% 3.1 prepare zone
% prepare Panel_Panel_Interval
Panel_Panel_Interval = 40;

% prepare PanelWidth
PanelWidth = 280;
PanelHeight = 545;
PanelX_LoadWords = (WinWidth - PanelWidth)/2;
PanelY_LoadWords = 75;  %150

% 3.2 prepare parameters of the text uicontrols for 3 panels
% panel has its own text, but it will flash when loading; to fix such bug, we use panel + text uicontrol, instead of panel
hPanel_textWidth = 160;
hPanel_textHeight = 20;
hPanel3_textWidth = 180;
hPanel1_textX = PanelX_LoadWords+12;
hPanel1_textY = PanelY_LoadWords+PanelHeight-hPanel_textHeight/2-2;
hPanel2_textX = PanelX_LoadWords+Panel_Panel_Interval+PanelWidth+12;
hPanel2_textY = PanelY_LoadWords+PanelHeight-hPanel_textHeight/2-2;
hPanel3_textX = PanelX_LoadWords-Panel_Panel_Interval-PanelWidth+12;
hPanel3_textY = PanelY_LoadWords+PanelHeight-hPanel_textHeight/2-2;

% Panel 1: Loading the words list
hPanel1_LoadWords = uipanel('Parent', hFigure1,'FontSize',10,'units','pixels','BackgroundColor','white','Position',[PanelX_LoadWords PanelY_LoadWords PanelWidth PanelHeight]);
hPanel1_text = uicontrol('parent',hFigure1,'style','text','string','Load Words from a .txt File.','position',[hPanel1_textX hPanel1_textY hPanel_textWidth hPanel_textHeight],'HorizontalAlignment','center', 'fontsize',9, 'BackgroundColor','White','Visible','on');

% Panel 2: Setting the parameters for words
hPanel2_SetParameters = uipanel('Parent', hFigure1,'FontSize',10,'units','pixels','BackgroundColor','white','Position',[PanelX_LoadWords+Panel_Panel_Interval+PanelWidth PanelY_LoadWords PanelWidth PanelHeight]);
hPanel2_text = uicontrol('parent',hFigure1,'style','text','string','  Set Parameter for Words.  ','position',[hPanel2_textX hPanel2_textY hPanel_textWidth hPanel_textHeight],'HorizontalAlignment','center', 'fontsize',9, 'BackgroundColor','White','Visible','on');

% Panel 3: Previewing and generating the pictures
hPanel3_PreviewGeneratePictures = uipanel('Parent', hFigure1,'FontSize',10,'units','pixels','BackgroundColor','white','Position',[PanelX_LoadWords-Panel_Panel_Interval-PanelWidth PanelY_LoadWords PanelWidth PanelHeight]);
hPanel3_text = uicontrol('parent',hFigure1, 'style','text', 'string',' Preview and Generate Pictures.', 'position',[hPanel3_textX hPanel3_textY hPanel3_textWidth hPanel_textHeight],'HorizontalAlignment','center', 'fontsize',9, 'BackgroundColor','White','Visible','on');





% -------------------------------------------------------------------------
% 4. Panel 1
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
Edit_WordsList = uicontrol('Parent',hPanel1_LoadWords, 'Style','edit', 'Position',[Edit_WordsList_relativeX Edit_WordsList_relativeY Edit_WordsList_Width Edit_WordsList_Height], 'Max' , 2 , 'Visible','on');

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
Btn_WriteWordsList = uicontrol('Parent',hPanel1_LoadWords,'Style', 'pushbutton','Position', [Pushbutton_WriteWordsList_relativeX Pushbutton_WriteWordsList_relativeY Pushbutton_WriteWordsList_Width Pushbutton_WriteWordsList_Height], 'String', 'Write the Words into a .txt File', 'Visible','oN');



% 4.3 === Binding mechanism in the Panel 1
set(Btn_LoadWordsList, 'Callback', @Btn_LoadWordsFcn);
set(Btn_WriteWordsList, 'Callback', @Btn_WriteWordsFcn);


% ==> 4.3.1 function Btn_LoadWordsFcn
    function Btn_LoadWordsFcn(~, ~, ~)
        textPathNames_forGetFile = sprintf('%s/%s/*.txt', CurrentWorkingPath, TextFolderName);
        [txtFileName, txtPath] = uigetfile(textPathNames_forGetFile, 'Pick a .txt File to load the words list!');
        txtPathName = sprintf('%s%s', txtPath, txtFileName);
        set(Edit_PathName_txtFile, 'String', txtPathName);
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
        textPathNames_forPutFile = sprintf('%s/%s/*.txt', CurrentWorkingPath, TextFolderName);
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

% 4.3.3 Initialize the Edit_WordsList
set(Edit_WordsList, 'String',WordsArray);   % WordsArray --- Line 273


% -------------------------------------------------------------------------
% 5. Panel 2
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
        %         tamFont = get(Edit_FontSet,'String');
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



%--------------------------------------------------------------------------
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

%-->Background Color Function
    function Btn_BKGColorFcn(~, ~, ~)
        bkgColor = uisetcolor(bkgColor);
        tmpColorStringBKG = sprintf('R:%d; G:%d; B:%d', bkgColor(1) * 255, bkgColor(2) * 255, bkgColor(3) * 255);
        set(Edit_FontBKGroundColorSet, 'String', tmpColorStringBKG);
        set(Axes_BKGColor,'Color',bkgColor);
    end

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
Radiobutton_Left_relativeX = 30;
Radiobutton_Left_relativeY = 200;
Radiobutton_Left_Width = 58;
Radiobutton_Left_Height = 23;
RadiobuttonLeft = uicontrol('Parent',hPanel2_SetParameters, 'Style','radio', 'Position',[Radiobutton_Left_relativeX  Radiobutton_Left_relativeY Radiobutton_Left_Width Radiobutton_Left_Height], 'String','Left', 'BackgroundColor','White', 'Visible','on');

Radiobutton_Middle_relativeX = 100;
Radiobutton_Middle_relativeY = 200;
Radiobutton_Middle_Width = 58;
Radiobutton_Middle_Height = 23;
RadiobuttonMiddle = uicontrol('Parent',hPanel2_SetParameters,  'Style','radio','Position',[Radiobutton_Middle_relativeX Radiobutton_Middle_relativeY Radiobutton_Middle_Width Radiobutton_Middle_Height], 'String','Middle', 'BackgroundColor', 'White', 'Visible','on');

Radiobutton_Right_relativeX = 170;
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

% Initialize the L/M/R radiobuttons and the edit, both M
set(RadiobuttonLeft, 'Value',0);
set(RadiobuttonMiddle, 'Value',1);
set(RadiobuttonRight, 'Value',0);
set(Edit_Aligh, 'String','M');

% 5.5.3 function
% combining mechanism in the Panel 2: mode(4)
set(RadiobuttonLeft, 'Callback', @RadiobuttonLeft_CallbackFcn);
set(RadiobuttonMiddle, 'Callback', @RadiobuttonMiddle_CallbackFcn);
set(RadiobuttonRight, 'Callback', @RadiobuttonRight_CallbackFcn);

% ==> function RadiobuttonLeft_CallbackFcn
    function RadiobuttonLeft_CallbackFcn(~, ~, ~)
        set(RadiobuttonLeft, 'Value',1);
        set(RadiobuttonMiddle, 'Value',0);
        set(RadiobuttonRight, 'Value',0);
        set(Edit_Aligh, 'String','L');
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
    end











% 5.6 Mode(6): create compass for panel 2 --- new! & important!
% 5.6.1 prepare---draw the compass
relativeDistanceX_hAxes_ball_Panel = 140;
relativeDistanceY_hAxes_ball_Panel = 125;

% prepare the mouse motion field===>hAxes_BigRound
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

CompassFileName = 'Compass.png';
Compass_PathName = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, CompassFileName);
hImage_Compass = imread(Compass_PathName);
imshow(hImage_Compass,'parent',hAxes_Compass,'Xdata',[-60 60],'Ydata',[-60 60]);

% draw the ball in red
hAxes_ball = axes('parent',hPanel2_SetParameters);
ball_initialX = 135;
ball_initialY = 175;
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
% mediaR = (50 + 60)/2;
mediaR = (250+300)/2*120/610;

% 5.6.2 Editbox
% Create a Editbox for Font Color Set
finalAngle = 0;
strAngle = sprintf('%d',finalAngle);
Edit_Angle_X = 115;
Edit_Angle_Y = 30;
Edit_Angle_Width = 50;
Edit_Angle_Height = 20;
Edit_AngleSet = uicontrol('Parent',hPanel2_SetParameters, 'Style','edit', 'Position',[Edit_Angle_X Edit_Angle_Y Edit_Angle_Width Edit_Angle_Height],'Visible','on');
set(Edit_AngleSet, 'String',strAngle);

% binding mechanism for Edit_AngleSet
set(Edit_AngleSet, 'Callback', @Angle_Set_EditFcn);

% ==> function Angle_Set_EditFcn
    function Angle_Set_EditFcn(~, ~, ~)
        % get the tmpAngleString first
        tmpAngleString = get(Edit_AngleSet, 'String');
        len_AngleString = length(tmpAngleString);
        % len == 0
        if len_AngleString == 0
            tmpAngleString = '0';
            AngleValue = str2num(tmpAngleString);
        end
        % len == 1
        if len_AngleString == 1 && str2num(tmpAngleString) == 0
            tmpAngleString = '0';
            AngleValue = str2num(tmpAngleString);
        end
        % len > = 2
        if len_AngleString >=2
            runningWhile = 1;
            while runningWhile
                the1stChar = tmpAngleString(1);
                if len_AngleString >= 2 && str2num(the1stChar) == 0
                    tmpAngleString = tmpAngleString(2:end);
                else
                    if len_AngleString == 1 && str2num(the1stChar)==0
                        tmpAngleString = '0';
                        AngleValue = str2num(tmpAngleString);
                        runningWhile = 0;
                    else
                        AngleValue = str2num(tmpAngleString);
                        runningWhile = 0;
                    end
                end
            end % for while loop
        end
        
        AngleValue = str2num(tmpAngleString);
        if AngleValue>360||AngleValue<0
            warndlg('The range must be 0~360', 'Warn');
            tmpAngleString = '0';
            AngleValue = str2num(tmpAngleString);
        end
        set(Edit_AngleSet, 'String',tmpAngleString);
        temcircle_x = mediaR * cos(pi/2 - pi*AngleValue/180);
        temcircle_y = mediaR * sin(pi/2 - pi*AngleValue/180);
        temballx_toPanel = temcircle_x - 5 + relativeDistanceX_hAxes_ball_Panel;
        tembally_toPanel = temcircle_y - 5 + relativeDistanceY_hAxes_ball_Panel;
        temballposInfo = [temballx_toPanel tembally_toPanel ball_Width ball_Height];
        set(hAxes_ball, 'position',temballposInfo);
        
        finalAngle = AngleValue;
        mentalR_RotationFcn;
        
        if AngleValue ~= 0
            RadiobuttonMiddle_CallbackFcn;
        end
    end  % end of function Angle_Set_EditFcn





% 5.6.3 CounterClockWise vs. ClockWise Buttons   !!!important
% % CCW-CounterClockWise buttons
CCWpngFileName_Off = 'off_CCW.png';
CCWpngPathName_Off = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, CCWpngFileName_Off);

CCWpngFileName_On = 'on_CCW.png';
CCWpngPathName_On = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, CCWpngFileName_On);

CCWpngFileName_Press = 'press_CCW.png';
CCWpngPathName_Press = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, CCWpngFileName_Press);

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
CWpngPathName_Off = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, CWpngFileName_Off);

CWpngFileName_On = 'on_CW.png';
CWpngPathName_On = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, CWpngFileName_On);

CWpngFileName_Press = 'press_CW.png';
CWpngPathName_Press = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, CWpngFileName_Press);

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


CWimgMatrix_Off = imread(CWpngPathName_Off);
CWimgMatrix_On = imread(CWpngPathName_On);
CWimgMatrix_Press = imread(CWpngPathName_Press);

CWresize_imgMatrix_Off = imresize(CWimgMatrix_Off,[Button_addition_Width Button_addition_Height]);
CWresize_imgMatrix_On = imresize(CWimgMatrix_On,[Button_addition_Width Button_addition_Height]);
CWresize_imgMatrix_Press = imresize(CWimgMatrix_Press,[Button_addition_Width Button_addition_Height]);
% CWresize_imgMatrix_Press = imresize(CWimgMatrix_Press,[25 25]);

h_CWBtnImage_Off = imshow(CWresize_imgMatrix_Off, 'parent',hAxes_CWBKGround_Arrow_off);
h_CWBtnImage_On = imshow(CWresize_imgMatrix_On, 'parent',hAxes_CWBKGround_Arrow_on);
h_CWBtnImage_Press = imshow(CWresize_imgMatrix_Press, 'parent',hAxes_CWBKGround_Arrow_press);

set(hAxes_CCWBKGround_Arrow_on,'visible','off');
set(h_CCWBtnImage_On,'visible','off');
set(hAxes_CCWBKGround_Arrow_press,'visible','off');
set(h_CCWBtnImage_Press,'visible','off');

set(hAxes_CWBKGround_Arrow_on,'visible','off');
set(h_CWBtnImage_On,'visible','off');
set(hAxes_CWBKGround_Arrow_press,'visible','off');
set(h_CWBtnImage_Press,'visible','off');

% set the state_Mouse_In_Btn_Left
state_Mouse_In_Btn_Left = 0;
mouseDown_State = 0;
mouseDown_State = 0;

% show the figure1
set(hFigure1, 'visible','on');

% combining mechanism
set(hFigure1, 'WindowButtonMotionFcn', @hFigure1_WindowButtonMotionFcn);
set(hFigure1, 'WindowButtonDownFcn', @hFigure1_WindowButtonDownFcn);
set(hFigure1, 'WindowButtonUpFcn', @hFigure1_WindowButtonUpFcn);

    function hFigure1_WindowButtonDownFcn(~, ~, ~)
        mouseDown_State = 1;
        % get mouse point x y
        BKGround_pt = get(hAxes_BackGround, 'CurrentPoint');
        BKGround_pt_x = BKGround_pt(1);
        BKGround_pt_y = BKGround_pt(3);
        
        CCWbtn_Field = BKGround_pt_x <= 765 & BKGround_pt_x > 735 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        CWbtn_Field = BKGround_pt_x <= 930 & BKGround_pt_x > 905 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        
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
    end

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
    end


    function hFigure1_WindowButtonMotionFcn(~, ~, ~)
        BKGround_pt = get(hAxes_BackGround, 'CurrentPoint');
        BKGround_pt_x = BKGround_pt(1);
        BKGround_pt_y = BKGround_pt(3);
        CCWbtn_Field = BKGround_pt_x <= 770 & BKGround_pt_x > 740 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        CWbtn_Field = BKGround_pt_x <= 930 & BKGround_pt_x > 905 & BKGround_pt_y <= 215 & BKGround_pt_y >185;
        %         fprintf('%f %f \n',BKGround_pt_x,BKGround_pt_y);  请不要删掉这行代码。
        
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
        end % mouseDown_State == 1
    end  % for hFigure_WindowButtonMotionFcn

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
    end

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
    end

% 5.7 mentalR
% create a axes for R
% prepare the posInfo for hAxes_mentalR
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
R_FontColor = [0.8 0.8 0.8];
% R_BKGroundColor = [1 1 1];

R_textX = R_Width/2;
imgMatrix_A_Rotation = text(R_textX, R_Height/2, mentalR_Char, 'parent',hAxes_mentalR,'fontname','Helvetica', 'HorizontalAlignment','center' ,'fontsize',40, 'fontweight','normal', 'fontangle', 'normal', 'color',R_FontColor, 'visible','on', 'units','pixels');
mentalR_RotationFcn;

% function for mentalR rotation
    function mentalR_RotationFcn(~, ~, ~)
        cRotation_AngleValue = finalAngle;
        cRotation_AngleValue = 360 - cRotation_AngleValue;
        set(imgMatrix_A_Rotation, 'rotation',cRotation_AngleValue);
    end % for preview function







% 6. Panel 3
% 6.1 prepare
hAxes_PreviewBoard_BKGround = axes('parent',hPanel3_PreviewGeneratePictures);
set(hAxes_PreviewBoard_BKGround, 'units','pixels', 'position',[39 299 202 202], 'color','k', 'Xtick',[], 'Ytick',[]);
imgMatrix_PreviewBoard_BKGround = zeros(202,202,3) + 0.8;
imshow(imgMatrix_PreviewBoard_BKGround, 'parent',hAxes_PreviewBoard_BKGround);
axis off;

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
% Saving Directory
% Text_Saving_Directory = uicontrol('Parent',hPanel_PreviewGeneratePictures,'Style','text', 'Position',[40 215 90 20], 'String','Save Directory','BackgroundColor', 'White','FontSize',10, 'Visible','on');
uicontrol('Parent',hPanel3_PreviewGeneratePictures,'Style','text', 'Position',[40 215 90 20], 'String','Save Directory','BackgroundColor', 'White','FontSize',10, 'Visible','on');

% Text_StorageFormat = uicontrol('Parent',hPanel_PreviewGeneratePictures, 'Style','text', 'Position',[142 215 50 20],'BackgroundColor', 'White', 'String','Format','FontSize',10, 'Visible','on');
uicontrol('Parent',hPanel3_PreviewGeneratePictures, 'Style','text', 'Position',[142 215 50 20],'BackgroundColor', 'White', 'String','Format','FontSize',10, 'Visible','on');


Popup_StorageFormat = uicontrol('Parent',hPanel3_PreviewGeneratePictures,  'Style', 'popup', 'Position', [190 235 50 4],'String',{'.bmp', '.jpg', '.png', '.tiff','.gif'}, 'FontSize',8, 'Visible','on');
% edit for saving directory
SavingPath = sprintf('%s/%s', CurrentWorkingPath, PicturesFolderName);
Edit_SavingDirectory =  uicontrol('Parent',hPanel3_PreviewGeneratePictures,'Style','edit', 'Position',[40 190 200 20], 'Enable','off', 'Visible','on');%'Enable','off',
set(Edit_SavingDirectory, 'String',SavingPath);
SaveDirect_EditString_extent = get(Edit_SavingDirectory,'extent');
SaveDirect_EditString_extent_Width = SaveDirect_EditString_extent(3);

Btn_Directory_Select = uicontrol('Parent',hPanel3_PreviewGeneratePictures,  'Style', 'pushbutton', 'Position', [140 165 100 20],'String', 'Directory Select','FontSize',10, 'Visible','on');
SaveDirect_EditString = get(Edit_SavingDirectory, 'String');
flashCard_panel =  uipanel('Parent', hFigure1,'FontSize',8,'units','pixels','BackgroundColor','white','TitlePosition','lefttop','title',SaveDirect_EditString, 'Position',[0 0 1 1],'bordertype','none','Visible','off');
generate_flashCard_panel;
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
Pushbutton_OpenDir = uicontrol('Parent',hPanel3_PreviewGeneratePictures, 'Style','pushbutton', 'String','Open Directory', 'position',[40 35 200 25]);

% === combining mechanism
set(previewBtn, 'Callback',@previewBtnFcn);
set(leftBtn, 'Callback',@leftBtnFcn);
set(rightBtn, 'Callback',@rightBtnFcn);
set(Btn_Directory_Select,'Callback',@Directory_SelectFcn);
set(generate_OnePictureBtn,'Callback',@generate_OnePictureBtnFcn);
set(generate_AllPicturesBtn,'Callback',@generate_AllPictureBtnFcn);
set(Pushbutton_OpenDir,'Callback',@OpenDirectoryFcn);

% 6.2.2 prepare for preview
% ====>function   select_directory
    function Directory_SelectFcn(~, ~, ~)
        Directory_Select_PathNames = sprintf('%s/%s/*.txt', CurrentWorkingPath, PicturesFolderName);
        oldDirectory_Selectdir = set(Edit_SavingDirectory, 'String');
        
        Directory_Selectdir = uigetdir(Directory_Select_PathNames);
        if Directory_Selectdir
            
            set(Edit_SavingDirectory, 'String', Directory_Selectdir);

            SavingPath = Directory_Selectdir;
            SaveDirect_EditString_extent = get(Edit_SavingDirectory,'extent');
            SaveDirect_EditString_extent_Width = SaveDirect_EditString_extent(3);
            generate_flashCard_panel;
        else
            set(Edit_SavingDirectory, 'String', oldDirectory_Selectdir);
            SavingPath = oldDirectory_Selectdir;
            SaveDirect_EditString_extent = get(Edit_SavingDirectory,'extent');
            SaveDirect_EditString_extent_Width = SaveDirect_EditString_extent(3);
            generate_flashCard_panel;
        end
    end

% ====>function  generate_OnePicture
    function generate_OnePictureBtnFcn(~, ~, ~)
        WordsListCells = get(Edit_WordsList, 'String');
        WordsSum = length(WordsListCells);
        if length(WordsListCells) == 1
            cWord = WordsListCells(WordIndex);
        else
            cWord = WordsListCells{WordIndex};
        end
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
        
        if get(RadiobuttonLeft,'Value')
            cAlign = 'left';
            textX = 0;
        elseif get(RadiobuttonMiddle,'Value')
            cAlign = 'center';
            textX = cWidth/2;
        elseif get(RadiobuttonRight,'Value')
            cAlign = 'right';
            textX = cWidth;
        end
        
        cBKGCanvas = zeros(cHeight, cWidth, 3);
        cBKGCanvas(:,:,1) = cBKGroundColor(1);
        cBKGCanvas(:,:,2) = cBKGroundColor(2);
        cBKGCanvas(:,:,3) = cBKGroundColor(3);
        str_RotationAngle = get(Edit_AngleSet,'string');
        cRotation_AngleValue = str2num(str_RotationAngle);
        hFigure2 = figure(2);
        set(hFigure2, 'position',[-cWidth-100 0 cWidth cHeight]);
        hAxes_Original = axes('parent',hFigure2);
        set(hAxes_Original,'units','pixels', 'position',[1 1 cWidth cHeight],'visible','off'  , 'ytick',[], 'xtick',[]);
        axis([-cWidth/2 cWidth/2 -cHeight/2 cHeight/2]);
        imshow(cBKGCanvas, 'Parent', hAxes_Original);
        set(hFigure2, 'visible','off');
        cRotation_AngleValue = 360 - cRotation_AngleValue;
        printWord = text(textX, cHeight/2, cWord, 'parent',hAxes_Original,'fontname',cFontName, 'HorizontalAlignment',cAlign ,'fontsize',cFontSize, 'fontweight',cFontWeight, 'fontangle',cFontAngle, 'color',cFontColor, 'visible','on', 'units','pixels'); %,
        set(printWord, 'rotation',cRotation_AngleValue);
        hFrame_hAxes_Original = getframe(hAxes_Original);
        imgMatrix_Text = hFrame_hAxes_Original.cdata;
        
        %         sizeText = size(imgMatrix_Text);
        imshow(imgMatrix_Text, 'parent',hAxes_PreviewBoard);
        close(hFigure2);
        
        switch cFileExtention
            case '.bmp'
                imwrite(imgMatrix_Text, picturePathName, 'BMP');
            case '.jpg'
                imwrite(imgMatrix_Text, picturePathName, 'JPEG');
            case '.png'
                imwrite(imgMatrix_Text, picturePathName, 'PNG');
            case '.tiff'
                imwrite(imgMatrix_Text, picturePathName, 'TIFF');
            case '.gif'
                imwrite(imgMatrix_Text, picturePathName, 'GIF');
        end
    end

% 6.3 function
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
        elseif get(RadiobuttonMiddle,'Value')
            cAlign = 'center';
            textX = cWidth/2;
        elseif get(RadiobuttonRight,'Value')
            cAlign = 'right';
            textX = cWidth;
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
        hFigure2 = figure(2);
        set(hFigure2, 'position',[-cWidth-100 0 cWidth cHeight]);
        
        % create axes original
        hAxes_Original = axes('parent',hFigure2);
        set(hAxes_Original,'units','pixels', 'position',[1 1 cWidth cHeight],'visible','off'  , 'ytick',[], 'xtick',[]); %
        axis([-cWidth/2 cWidth/2 -cHeight/2 cHeight/2]);
        h_previewBKG = imshow(cBKGCanvas, 'Parent', hAxes_Original);
        set(hFigure2, 'visible','off');
        
        cRotation_AngleValue = 360 - cRotation_AngleValue;
        printWord = text(textX, cHeight/2, cWord, 'parent',hAxes_Original,'fontname',cFontName, 'HorizontalAlignment',cAlign ,'fontsize',cFontSize, 'fontweight',cFontWeight, 'fontangle',cFontAngle, 'color',fColor, 'visible','on', 'units','pixels'); %,
        set(printWord, 'rotation',cRotation_AngleValue);
        hFrame_hAxes_Original = getframe(hAxes_Original);
        imgMatrix_Text = hFrame_hAxes_Original.cdata;
        h_previewimg = imshow(imgMatrix_Text, 'parent',hAxes_PreviewBoard);
        close(hFigure2);
    end % for preview function

%-->Btn_Previous Function
    function leftBtnFcn(~, ~, ~)
        if WordIndex > 1
            WordIndex = WordIndex - 1;
        end
        previewBtnFcn();
    end

%-->Btn_Posterior Function
    function rightBtnFcn(~, ~, ~)
        if WordIndex < WordsSum
            WordIndex = WordIndex + 1;
        end
        previewBtnFcn();
    end

% ====>function  generate_AllPictures

    function generate_AllPictureBtnFcn(~, ~, ~)
        for i = 1:WordsSum
            WordIndex = i;
            previewBtnFcn;
            generate_OnePictureBtnFcn;
        end
    end

    function OpenDirectoryFcn(~, ~, ~)
        strComputer = computer;
        charC = strComputer(1:3);
        if strcmp(charC,'PCW') == 1
            winopen(Edit_SavingDirectory.String);
        else
            tmpDirectory = Edit_SavingDirectory.String;
            tmpStr = sprintf('open %s', tmpDirectory);
            unix(tmpStr);
        end
    end



% 7. Copyright (c) School of Psychology, Beijing Normal University
Copyright_Color = [0.6 0.6 0.6];  % gray color
copyright_text_name = 'Copyright (c) 2017-2020 Cognition & Learning Lab, Faculty of Psychology, Beijing Normal University all rights reserved.';
% copyright_text_C = text(WinWidth/2 , 40 ,copyright_text_name , 'parent',hAxes_BackGround, 'units','pixels', 'fontname','arial', 'HorizontalAlignment','center' ,'fontsize',9,  'fontangle','normal', 'color',Copyright_Color, 'visible','on');
text(WinWidth/2 , 40 ,copyright_text_name , 'parent',hAxes_BackGround, 'units','pixels', 'fontname','arial', 'HorizontalAlignment','center' ,'fontsize',9,  'fontangle','normal', 'color',Copyright_Color, 'visible','on');

copyright_text_Email = 'Anything about the suggestions or questions, please feel free to contact us : psytingjiang@gmail.com';
% copyright_text_E = text( WinWidth/2  , 20 ,copyright_text_Email , 'parent',hAxes_BackGround, 'units','pixels','fontname','arial', 'HorizontalAlignment','center' ,'fontsize',8,  'fontangle','normal', 'color',Copyright_Color, 'visible','on');
text( WinWidth/2  , 20 ,copyright_text_Email , 'parent',hAxes_BackGround, 'units','pixels','fontname','arial', 'HorizontalAlignment','center' ,'fontsize',8,  'fontangle','normal', 'color',Copyright_Color, 'visible','on');



% 8. Pause and show the figure(1)
pause(0.2);
set(hFigure1,'position',[WinX WinY WinWidth WinHeight]);
previewBtnFcn;



% 9. Generate the icon/logo mental rotation 'R' in png format on the title bar
    function [] = generatePNGpicture_mentalR(x_Fontname, picPathName)
        % prepare
        roundColor = [0.85 0 0];
        tmpWidth = 128;
        tmpHeight = 128;
        
        % figure
        hFigure6 = figure(6);
        set(hFigure6, 'position',[-1600 200 tmpWidth tmpHeight] );
        
        % background axes
        hAxes_BKGround = axes('parent',hFigure6);
        set(hAxes_BKGround,'units','pixels', 'position',[0 0 tmpWidth tmpHeight]);
        imgMatrix_BKGround = ones(tmpWidth, tmpHeight, 3);
        
        % show the white background image
        imshow(imgMatrix_BKGround, 'parent',hAxes_BKGround);
        
        % round + text axes
        textR = 'R';
        tmpfont = x_Fontname;
        pngPathName = picPathName;
        hAxes = axes('parent',hFigure6);
        set(hAxes,'units','pixels', 'position',[0 0 tmpWidth tmpHeight]);
        
        mRadius =tmpWidth/2-1;
        mAlpha = 0:2*pi/360:2*pi;
        x = mRadius*cos(mAlpha);
        y = mRadius*sin(mAlpha);
        fill(x, y,roundColor,'edgealpha',0);
        axis([-tmpWidth/2 tmpWidth/2 -tmpHeight/2 tmpHeight/2]);
        text(4, 6, textR, 'fontname',tmpfont, 'fontsize',95, 'HorizontalAlign','Center', 'color',[0.98 0.98 0.98], 'FontWeight','Bold');
        axis off;
        
        % getframe
        hFrame = getframe(gcf); % get the whole window's figure
        imgText = hFrame.cdata;
        
        % adjust
        bw = im2bw(imgText);
        
        % prepare mAlpha
        siz = size(bw);
        mAlpha = ones(siz(1),siz(2));
        rMat = imgText(:,:,1);
        gMat = imgText(:,:,2);
        bMat = imgText(:,:,3);
        logic_rgbMatrix = (rMat == 255 & gMat == 255 & bMat == 255);
        mAlpha(logic_rgbMatrix) = 0;
        mAlpha(~logic_rgbMatrix) = 1;
        
        % imwrite
        imwrite(imgText, pngPathName, 'Alpha',mAlpha);
        close(hFigure6);
    end % for this function



% 10. Generate two Arrow Buttons in png format
    function [] = generatePNGpictures_2ArrowButtons()    % generateArrowPNG
        % prepare pngFileNames
        initialCWcircle_ArrowImg = 'off_CW.png';
        initialCCWcircle_ArrowImg = 'off_CCW.png';
        littleCWcircle_ArrowImg = 'press_CW.png';
        littleCCWcircle_ArrowImg = 'press_CCW.png';
        mouseCWcircle_ArrowImg = 'on_CW.png';
        mouseCCWcircle_ArrowImg = 'on_CCW.png';
        
        Circle_ArrowColor_initial = [0.5 0.5 0.5];
        Circle_ArrowColor_mouse = [0.65 0.65 0.65];
        
        %figure
        hFigureInitial = figure(2);
        set(hFigureInitial,'position',[-1600 200 200 200],'color','w');
        %axes
        hAxes = axes('parent',hFigureInitial);
        set(hAxes,'units','pixels','position',[1 1 200 200]);
        % round rectangle
        rectangle('position',[0,0,200,200], 'curvature',0.6, 'edgecolor',Circle_ArrowColor_mouse, 'facecolor','w', 'linewidth',3);
        axis off;
        
        yAxes = axes('parent',hFigureInitial);           % children axes must parent to figures but not to other axes
        set(yAxes,'units','pixels','position',[40 40 120 120],'visible','off');
        axis([-60 60 -60 60]) ;
        hold on;
        R=60;
        theta=2.5;
        theta2=linspace(0,theta*2,300);
        Arc_x=R*cos(theta2);
        Arc_y=R*sin(theta2);
        plot(Arc_x,Arc_y,'color',Circle_ArrowColor_initial,'LineWidth',10);
        
        % Draw Arrow
        Text_Arrow = annotation('textarrow',[.795,.795],[.6,.4],'Linestyle','none','HeadWidth',30,'Headlength',25,'HeadStyle','cback2','units','pixels','color',Circle_ArrowColor_initial,'HorizontalAlignment','center','textrotation',0);
        axis off;
        % getframe
        hFrame = getframe(gcf); %  get the whole window's figure
        Img_Initial = hFrame.cdata;
        % initial
        initialCWimgText = imresize(Img_Initial,[100 100]);
        initialCCWimgText = fliplr(initialCWimgText);
        
        %imwrite
        initialCWcircle_Arrow_Path = sprintf('%s/%s/%s',CurrentWorkingPath, ResourceFolderName, initialCWcircle_ArrowImg);
        imwrite(initialCWimgText, initialCWcircle_Arrow_Path, 'png');
        initialCCWcircle_Arrow_Path = sprintf('%s/%s/%s',CurrentWorkingPath,ResourceFolderName, initialCCWcircle_ArrowImg);
        imwrite(initialCCWimgText, initialCCWcircle_Arrow_Path, 'png');
        close(hFigureInitial);
        
        %figure
        hFigure_mouse = figure(3);
        set(hFigure_mouse,'position',[-1000 200 200 200],'color','w');
        %axes
        hAxes_mouse = axes('parent',hFigure_mouse);
        set(hAxes_mouse,'units','pixels','position',[1 1 200 200]);
        
        % round rectangle
        rectangle('position',[0,0,200,200], 'curvature',0.6, 'edgecolor',Circle_ArrowColor_mouse, 'facecolor','w', 'linewidth',3);
        axis off;
        
        Axes_mouse = axes('parent',hFigure_mouse);           % children axes must parent to figures but not to other axes
        set(Axes_mouse,'units','pixels','position',[40 40 120 120],'color','w');
        axis([-60 60 -60 60]) ;
        hold on;
        R_mouse=60;
        theta_mouse=2.5;
        theta_mouse2=linspace(0,theta_mouse*2,300);
        Arc_x_mouse=R_mouse*cos(theta_mouse2);
        Arc_y_mouse=R_mouse*sin(theta_mouse2);
        plot(Arc_x_mouse,Arc_y_mouse,'color',Circle_ArrowColor_mouse,'LineWidth',10);
        % Draw Arrow
        Text_Arrow_mouse = annotation('textarrow',[.795,.795],[.6,.4],'Linestyle','none','HeadWidth',30,'Headlength',25,'HeadStyle','cback2','units','pixels','color',Circle_ArrowColor_mouse,'HorizontalAlignment','center','textrotation',0);
        axis off;
        % getframe
        hFrame_mouse = getframe(hFigure_mouse); %  get the whole window's figure
        Img_mouse = hFrame_mouse.cdata;
        mouseCWimgText = imresize(Img_mouse,[100 100]);
        mouseCCWimgText = fliplr(mouseCWimgText);
        %imwrite
        mouseCWcircle_Arrow_Path = sprintf('%s/%s/%s',CurrentWorkingPath,ResourceFolderName, mouseCWcircle_ArrowImg);
        imwrite(mouseCWimgText, mouseCWcircle_Arrow_Path, 'png');
        mouseCCWcircle_Arrow_Path = sprintf('%s/%s/%s',CurrentWorkingPath,ResourceFolderName, mouseCCWcircle_ArrowImg);
        imwrite(mouseCCWimgText, mouseCCWcircle_Arrow_Path, 'png');
        close(hFigure_mouse);
        
        %figure
        hFigure_press = figure(4);
        set(hFigure_press,'position',[-1600 200 200 200],'color','w');
        %axes
        hAxes_press = axes('parent',hFigure_press);
        set(hAxes_press,'units','pixels','position',[1 1 200 200]);
        % round rectangle
        rectangle('position',[0,0,200,200], 'curvature',0.6, 'edgecolor',Circle_ArrowColor_mouse, 'facecolor','w', 'linewidth',3);
        axis off;
        
        Axes_press = axes('parent',hFigure_press);           % children axes must parent to figures but not to other axes
        set(Axes_press,'units','pixels','position',[50 50 100 100],'color','w');
        axis([-50 50 -50 50]) ;
        hold on;
        R_press=50;
        theta_press=2.5;
        theta_press2=linspace(0,theta_press*2,300);
        Arc_x_press=R_press*cos(theta_press2);
        Arc_y_press=R_press*sin(theta_press2);
        plot(Arc_x_press,Arc_y_press,'color',Circle_ArrowColor_mouse,'LineWidth',10);
        % Draw Arrow
        Text_Arrow_press = annotation('textarrow',[.749,.749],[.58,.38],'Linestyle','none','HeadWidth',30,'Headlength',25,'HeadStyle','cback2','units','pixels','color',Circle_ArrowColor_mouse,'HorizontalAlignment','center','textrotation',0);
        axis off;
        % getframe
        hFrame_press = getframe(hAxes_press); % get the whole window's figure
        Img_press = hFrame_press.cdata;
        pressCWimgText = imresize(Img_press,[100 100]);
        pressCCWimgText = fliplr(pressCWimgText);
        %imwrite
        pressCWcircle_Arrow_Path = sprintf('%s/%s/%s',CurrentWorkingPath, ResourceFolderName, littleCWcircle_ArrowImg);
        imwrite(pressCWimgText, pressCWcircle_Arrow_Path, 'png');
        pressCCWcircle_Arrow_Path = sprintf('%s/%s/%s',CurrentWorkingPath, ResourceFolderName, littleCCWcircle_ArrowImg);
        imwrite(pressCCWimgText, pressCCWcircle_Arrow_Path, 'png');
        close(hFigure_press);
        %     end
        % draw the round compass
        %     function[] = draw_round_compass()
        hCompassFigure = figure(11);
        set(hCompassFigure,'position',[-1600 -100 610 610],'color','w')
        % draw the bigRound
        hAxes_Round = axes('parent',hCompassFigure);
        set(hAxes_Round, 'units','pixels', 'position',[5 5 600 600], 'color', 'w');
        axis(hAxes_Round,[-300 300 -300 300]);
        hold on;
        mAlpha = 0:pi/360:2*pi;
        bigR = 300;
        bigR_x = bigR*cos(mAlpha);
        bigR_y = bigR*sin(mAlpha);
        plot(bigR_x,bigR_y,'k','LineWidth',3);
        axis off;
        % draw the radiation
        superR = 300;
        for LineID = 1:12
            tmpBeta = (2 * pi / 12) * LineID;
            oriPoint = [0 superR*cos(tmpBeta)];
            desPoint = [0 superR*sin(tmpBeta)];
            line_color = [105/255 105/255 105/255];
            line(oriPoint,desPoint, 'color',line_color,'LineWidth',4);
        end
        % draw the smallRound
        hAxes_Round = axes('parent',hCompassFigure);
        set(hAxes_Round, 'units','pixels', 'position',[55 55 500 500]);
        axis([-250 250 -250 250]);
        hold on;
        mAlpha = 0:pi/360:2*pi;
        smallR = 250;    % radiation
        smallR_x = smallR*cos(mAlpha);
        smallR_y = smallR*sin(mAlpha);
        plot(smallR_x,smallR_y,'k','LineWidth',4);
        fill(smallR_x,smallR_y,'w','edgealpha',1);
        axis off;
        
        hCompass = getframe(hCompassFigure);
        imgCompass = hCompass.cdata;
        final_compass = imresize(imgCompass,[120 120]);
        CompassFileName = 'Compass.png';
        Compass_PathName = sprintf('%s/%s/%s', CurrentWorkingPath, ResourceFolderName, CompassFileName);
        imwrite(final_compass,Compass_PathName,'png');
        close(hCompassFigure);
        
    end


end   % the end of the main function
