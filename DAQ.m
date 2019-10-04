function varargout = DAQ(varargin)
% DAQ MATLAB code for DAQ.fig
%      DAQ, by itself, creates a new DAQ or raises the existing
%      singleton*.
%
%      H = DAQ returns the handle to a new DAQ or the handle to
%      the existing singleton*.
%
%      DAQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAQ.M with the given input arguments.
%
%      DAQ('Property','Value',...) creates a new DAQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DAQ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DAQ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DAQ

% Last Modified by GUIDE v2.5 28-Sep-2019 21:33:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DAQ_OpeningFcn, ...
                   'gui_OutputFcn',  @DAQ_OutputFcn, ...
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


% --- Executes just before DAQ is made visible.
function DAQ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DAQ (see VARARGIN)

% Choose default command line output for DAQ
handles.output = hObject;

% initilize port, baudrate, and the number of hand mocap
handles.port = 'COM1';
handles.baudRate = '115200';
handles.num_handMocap = 'L1';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DAQ wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DAQ_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnConnect.
function btnConnect_Callback(hObject, eventdata, handles)
% hObject    handle to btnConnect (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
    %disp(strcat(handles.port, ', ', handles.baudRate, ', ', handles.num_handMocap))
    test(handles)

function test(handles)

    %close existing memory of port object
    if ~isempty(instrfind)
         fclose(instrfind);
          delete(instrfind);
    end
    
    %data length, prefix, postfix
    length_protocol = 46;
    hex_prefix = 64;
    hex_postfix = 255;
    
    
    disp(strcat(handles.port, ', ', handles.baudRate, ', ', handles.num_handMocap))
    
    %open serial port
    ser = serial(handles.port);
    ser.Baudrate = str2num(handles.baudRate);
    fopen(ser);
    
    %assign the size of data
    data = zeros(length_protocol, 1);
   
    
    while(true)
    %read first byte and check whether it is same with the prefix byte
    first_byte = fread(ser, 1);    
    
    %check first byte
    if first_byte == hex_prefix
        remain_byte = fread(ser, length_protocol - 1);
                
        %check last byte
        if remain_byte(end) == hex_postfix
            data = [first_byte;remain_byte];
            
            %parsing sensor data (6sensors, 7bytes for each sensor)
            % 왼손
            % sensor 1: 중지 말단
            % sensor 2: 중지 손등
            % sensor 3: 검지 손등
            % sensor 4: 검지 말단
            % sensor 5: 엄지 손등
            % sensor 6: 엄지 말단 
            
            sensor1 = data(4:10);
            sensor2 = data(11:17);
            sensor3 = data(18:24);
            sensor4 = data(25:31);
            sensor5 = data(32:38);
            sensor6 = data(39:45);
            sensor_data = {sensor1, sensor2, sensor3, sensor4, sensor5, sensor6};
            
            bx = cell(1, 6);
            by = cell(1, 6);
            bz = cell(1, 6);
            
            [bx{1}, by{1}, bz{1}] = getMagneticValue(sensor1);
            [bx{2}, by{2}, bz{2}] = getMagneticValue(sensor2);
            [bx{3}, by{3}, bz{3}] = getMagneticValue(sensor3);
            [bx{4}, by{4}, bz{4}] = getMagneticValue(sensor4);
            [bx{5}, by{5}, bz{5}] = getMagneticValue(sensor5);
            [bx{6}, by{6}, bz{6}] = getMagneticValue(sensor6);
                       
            
            %%
            
            data_table = get(handles.table_data, 'data');
            data_table{1} = bx{1};
            data_table{2} = bx{2};
            data_table{3} = bx{3};
            data_table{4} = bx{4};
            data_table{5} = bx{5};
            data_table{6} = bx{6};
            
            data_table{7} = by{1};
            data_table{8} = by{2};
            data_table{9} = by{3};
            data_table{10} = by{4};
            data_table{11} = by{5};
            data_table{12} = by{6};
            set(handles.table_data, 'data', data_table);
             fprintf('sensor 1: %04.3f, %04.3f, %04.3f, sensor2 : %04.3f, %04.3f, %04.3f\n', bx{1}, by{1}, bz{1}, bx{2}, by{2}, bz{2})
             fprintf('sensor 3: %04.3f, %04.3f, %04.3f, sensor4 : %04.3f, %04.3f, %04.3f', bx{3}, by{3}, bz{3}, bx{4}, by{4}, bz{4})
             fprintf('sensor 5: %04.3f, %04.3f, %04.3f, sensor6 : %04.3f, %04.3f, %04.3f\n', bx{5}, by{5}, bz{5}, bx{6}, by{6}, bz{6})
           %drawnow;
                                 
        end
    end
end
    
    
    
    
    
    
    


% --- Executes on selection change in menu_comport.
function menu_comport_Callback(hObject, eventdata, handles)
% hObject    handle to menu_comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
port = contents{get(hObject,'Value')};
disp(port)
handles.port = port;
guidata(hObject, handles);


function menu_comport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function menu_baudRate_Callback(hObject, eventdata, handles)
% hObject    handle to menu_baudRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    contents = cellstr(get(hObject,'String'));
    baudRate = contents{get(hObject,'Value')};
    disp(baudRate)
    handles.baudRate = baudRate;
    %update variables
    guidata(hObject, handles);

function menu_baudRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_baudRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function menu_handmocap_Callback(hObject, eventdata, handles)
% hObject    handle to menu_handmocap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    contents = cellstr(get(hObject,'String'));
    num_handMocap = contents{get(hObject,'Value')};
    disp(num_handMocap)
    handles.num_handMocap = num_handMocap;
    guidata(hObject, handles);


function menu_handmocap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_handmocap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
        
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function table_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to table_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.uitable = hObject;
 guidata(hObject, handles);
