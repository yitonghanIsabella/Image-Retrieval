function varargout = MainT(varargin)
% MAINT MATLAB code for MainT.fig
%      MAINT, by itself, creates a new MAINT or raises the existing
%      singleton*.
%
%      H = MAINT returns the handle to a new MAINT or the handle to
%      the existing singleton*.
%
%      MAINT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINT.M with the given input arguments.
%
%      MAINT('Property','Value',...) creates a new MAINT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainT

% Last Modified by GUIDE v2.5 24-Jun-2021 10:06:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainT_OpeningFcn, ...
    'gui_OutputFcn',  @MainT_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MainT is made visible.
function MainT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainT (see VARARGIN)

% Choose default command line output for MainT
handles.output = hObject;
InitAxes(handles);
handles.filePath = 0;
handles.Hu_vec = 0;
handles.Color_vec = 0;
handles.Img = 0;
handles.indexsort = 0;
handles.H = 0;
% Update handles structure
guidata(hObject, handles);
% javaFrame = get(hObject, 'JavaFrame');
% javaFrame.setFigureIcon(javax.swing.ImageIcon('MainT.jpg'));
% UIWAIT makes MainT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filePath = OpenImageFile();
if isequal(filePath, 0)
    return;
end
[~ , name , ext ] = fileparts(filePath);
selected_pic = sprintf('%s%s', name, ext);
%set(handles.edit5,'String',selected_pic);
if ~isequal(handles.filePath, 0)
    InitAxes(handles);
    set(handles.edit1,'String','Picture Name');
    set(handles.edit2,'String','Picture Name');
    set(handles.edit3,'String','Picture Name');
    set(handles.edit4,'String','Picture Name');
    set(handles.edit5,'String','Picture Name');
end
handles.filePath = 0;
handles.vi = 0;
handles.Img = 0;
handles.indexsort = 0;

[Img, map] = imread(filePath);
if ~isempty(map)
    Img = ind2rgb(Img, map);
end
imshow(Img, [], 'parent', handles.axes1);
handles.filePath = filePath;
handles.Img = Img;
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start_path = fullfile(pwd);
dialog_title = 'select a database-file';
folder_name = uigetdir(start_path,dialog_title);
if isequal(folder_name, 0)
    return;
end
db_file = fullfile(folder_name, 'H.mat');
if exist(db_file, 'file')
    load(db_file);
    handles.folder_name = folder_name;
    handles.H = H;
    guidata(hObject, handles);
    msgbox('Database select successfully！', 'Tips');
else
    msgbox('Database first importing, please wait', 'Tips');
    db_file = GetDatabaseVec(folder_name);
    if ~exist(db_file, 'file')
        msgbox('Database importing error, please RETRY！', 'Tips','error');
        return;
    end
    load(db_file);
    handles.folder_name = folder_name;
    handles.H = H;
    guidata(hObject, handles);
    msgbox('Database select successfully！', 'Tips');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.Img, 0)
    return;
end
Hu_vec = Get_Hu_vec(handles.Img);
handles.Hu_vec = Hu_vec;
guidata(hObject, handles);
msgbox('Hu gotten！', 'Tips');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.Img, 0)
    return;
end
Color_vec = Get_Color_vec(handles.Img);
handles.Color_vec = Color_vec;
guidata(hObject, handles);
msgbox('Color features gotten！', 'Tips');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.Hu_vec, 0) || isequal(handles.Color_vec, 0)
    return;
end
former = Return_former (handles.Hu_vec, handles.Color_vec, handles.H);
[~, indexsort] = sort(former);
H = handles.H;
n=0;
for i = 1 : 20
    file = fullfile(sprintf('%s', H(indexsort(i+1)).filename));
    Img = imread(file);
    if i<6
        imshow(Img, [], 'parent', eval(sprintf('handles.axes%d', (i+1))));
        axes(eval(sprintf('handles.axes%d', (i+1))));
        title(sprintf('%d', i));
    end
    [~ , name , ext ] = fileparts(file);
    str_ = sprintf('%s%s', name, ext);
    if(startsWith(str_,"image")==0)
        n=n+1;
        %disp(str_)
    end
    if i == 1
        set(handles.edit1,'String',str_);
    end
    if i == 2
        set(handles.edit2,'String',str_);
    end
    if i == 3
        set(handles.edit3,'String',str_);
    end
    if i == 4
        set(handles.edit4,'String',str_);
    end
    if i == 5
        set(handles.edit5,'String',str_);
    end
end
disp("precision:")
disp(n/20)
disp("recall:")
disp(n/50)
handles.indexsort = indexsort;
guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Exit sure?', ...
    'Exit', ...
    'Exit','Cancel','Cancel');
switch choice
    case 'Exit'
        close;
    case 'Cancel'
        return;
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
