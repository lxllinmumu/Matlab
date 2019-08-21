function varargout = serial_communication01(varargin)
% SERIAL_COMMUNICATION01 MATLAB code for serial_communication01.fig
%      SERIAL_COMMUNICATION01, by itself, creates a new SERIAL_COMMUNICATION01 or raises the existing
%      singleton*.
%
%      H = SERIAL_COMMUNICATION01 returns the handle to a new SERIAL_COMMUNICATION01 or the handle to
%      the existing singleton*.
%
%      SERIAL_COMMUNICATION01('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SERIAL_COMMUNICATION01.M with the given input arguments.
%
%      SERIAL_COMMUNICATION01('Property','Value',...) creates a new SERIAL_COMMUNICATION01 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before serial_communication01_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to serial_communication01_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help serial_communication01

% Last Modified by GUIDE v2.5 27-Jul-2019 16:05:59

% Begin initialization code - DO NOT EDIT
varargin{1}
varargin{2}
varargin{3}
varargin{4}
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @serial_communication01_OpeningFcn, ...
                   'gui_OutputFcn',  @serial_communication01_OutputFcn, ...
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
%*************************进度残留**************************
%只进行到十六进制显示，数据保存和曲线保存未完成以及数据发送部分
%数据显示edit编辑框如何保持在最底端
%**********************************************************
% --- Executes just before serial_communication01 is made visible.
function serial_communication01_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to serial_communication01 (see VARARGIN)

% Choose default command line output for serial_communication01
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes serial_communication01 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

warning off all;
%% 初始化参数
hasData = false;
isShow = false;
isStopDisp = false;
isHexDisp = false;
isHexSend = false;
numRec = 0;
numSend = 0;
strRec = '';
% douRec = [];
txtfilename = 'serial_data.txt';
%% 将上述参数作为应用数据，存入窗口对象
setappdata(hObject,'hasData',hasData);
setappdata(hObject,'isShow',isShow);
setappdata(hObject,'isStopDisp',isStopDisp);
setappdata(hObject,'isHexDisp',isHexDisp);
setappdata(hObject,'isHexSend',isHexSend);
setappdata(hObject,'numRec',numRec);
setappdata(hObject,'numSend',numSend);
setappdata(hObject,'strRec',strRec);
% setappdata(hObject,'douRec',douRec);
setappdata(hObject,'txtfilename',txtfilename);

set(handles.lamb,'backgroundcolor','red');
set(handles.disp,'Enable','inactive');
grid(handles.data_axes,'on');
grid(handles.data_axes,'minor');
% --- Outputs from this function are returned to the command line.
function varargout = serial_communication01_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function disp_Callback(hObject, eventdata, handles)
% hObject    handle to disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of disp as text
%        str2double(get(hObject,'String')) returns contents of disp as a double


% --- Executes during object creation, after setting all properties.
function disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function send_Callback(hObject, eventdata, handles)
% hObject    handle to trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trans as text
%        str2double(get(hObject,'String')) returns contents of trans as a double

% % 获取周期编辑区的字符串
str = get(handles.send,'String');
% % 获取isHexSend参数
isHexSend = getappdata(handles.figure1,'isHexSend');

if ~isHexSend                   %若为ASCII形式发送，直接将字符串转为相应的数值
    val = double(str);          %注意与str2double的区别
else                            %若为十六进制形式发送，获取要发送的数据
    n = find(str == ' ');       %查找空格
    n = [0 n length(str)+1];    %空格索引
    % % 每两个空格之间的字符串为数值的十六进制形式，将其转换为数值
    length_b = length(n)-1;
    b = cell(1,length_b);
    for i = 1:length_b
       temp = str(n(i)+1:n(i+1)-1);     %获取每段数据的长度
       if ~rem(length(temp),2)
           b{i} = reshape(temp,2,[])';  %将每段十六进制转换为单位数组
       else
           break;
       end
    end
    val = hex2dec(b)';                  %将十六进制转换为十进制，等待写入串口
end
% % 更新发送数据
set(hObject,'UserData',val);
    

% --- Executes during object creation, after setting all properties.
function trans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in com.
function com_Callback(hObject, eventdata, handles)
% hObject    handle to com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns com contents as cell array
%        contents{get(hObject,'Value')} returns selected item from com


% --- Executes during object creation, after setting all properties.
function com_CreateFcn(hObject, eventdata, handles)
% hObject    handle to com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rate.
function rate_Callback(hObject, eventdata, handles)
% hObject    handle to rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns rate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rate


% --- Executes during object creation, after setting all properties.
function rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in check_bits.
function check_bits_Callback(hObject, eventdata, handles)
% hObject    handle to check_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns check_bits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from check_bits


% --- Executes during object creation, after setting all properties.
function check_bits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to check_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in data_bits.
function data_bits_Callback(hObject, eventdata, handles)
% hObject    handle to data_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns data_bits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from data_bits


% --- Executes during object creation, after setting all properties.
function data_bits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in stop_bits.
function stop_bits_Callback(hObject, eventdata, handles)
% hObject    handle to stop_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns stop_bits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stop_bits


% --- Executes during object creation, after setting all properties.
function stop_bits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in start_serial.
function start_serial_Callback(hObject, eventdata, handles)
% hObject    handle to start_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 
if get(hObject,'value')
    % % 获取串口名
    com_n = sprintf('COM%d',get(handles.com,'value'));
    % % 获取波特率
    rates = get(handles.rate,'string');
    baud_rate = str2num(rates{get(handles.rate,'value')});
    %% 获取校验位
    switch get(handles.check_bits,'value')
        case 1 
            check = 'none';
        case 2
            check = 'odd';
        case 3
            check = 'even';
    end
    %% 获取数据位
    data_bits = 5 + get(handles.data_bits,'value');
    % % 获取停止位
    stop_bits = get(handles.stop_bits,'value');
    % % 创建串口对象
    scom = serial(com_n);
    % % 配置串口属性
    set(scom,'BaudRate',baud_rate,'parity',check,'DataBits',data_bits,...
        'StopBits',stop_bits,'BytesAvailableFcnCount',10,...
        'BytesAvailableFcnMode','byte','BytesAvailableFcn',{@bytes,handles},...
        'TimerPeriod',0.01,'timerFcn',{@dataDisp,handles});
    % % 将串口对象的句柄作为用户数据，存入窗口对象
    set(handles.figure1,'UserData',scom);
    %% 尝试打开串口
    try
        fopen(scom);
    catch
        msgbox('error:无法获取串口!');
        set(hObject,'value',0);
        return;
    end
    %% 打开串口后允许串口发送数据，清空接收显示区，点亮串口状态指示灯
    % 并更改按钮文本为“关闭串口”
    set(handles.period_send,'Enable','on');
    set(handles.manual_send,'Enable','on');
    set(handles.disp,'string','');
    set(handles.lamb,'backgroundcolor','green');
    set(hObject,'string','关闭串口');
   % off-对象处于灰色不可选中状态，inactive-不可选中，但对象不为灰色
    set(handles.com,'Enable','off');
    set(handles.rate,'Enable','off');
    set(handles.check_bits,'Enable','off');
    set(handles.data_bits,'Enable','off');
    set(handles.stop_bits,'Enable','off');
else%关闭串口
    % % 停止并删除定时器
    t = timerfind;
    if ~isempty(t)
        stop(t);
        delete(t);
    end
    % % 停止并删除串口对象
    scoms= instrfind;
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
    % % 禁用【自动发送】和【手动发送】
    set(handles.period_send,'Enable','off','value',0);
    set(handles.manual_send,'Enable','off');
	set(handles.lamb,'backgroundcolor','red');
	set(hObject,'string','打开串口');
    
  	set(handles.com,'Enable','on');
    set(handles.rate,'Enable','on');
    set(handles.check_bits,'Enable','on');
    set(handles.data_bits,'Enable','on');
    set(handles.stop_bits,'Enable','on');
end
% --- Executes on button press in lamb.
function lamb_Callback(hObject, eventdata, handles)
% hObject    handle to lamb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clear_count.
function clear_count_Callback(hObject, eventdata, handles)
% hObject    handle to clear_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set([handles.rec,handles.trans],'string','')
set(handles.rec,'string',0);
set(handles.trans,'string',0);
setappdata(handles.figure1,'numRec',0);
setappdata(handles.figure1,'numSend',0);
% --- Executes on button press in period_send.
function period_send_Callback(hObject, eventdata, handles)
% hObject    handle to period_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of period_send
%% 【自动发送】
if get(hObject,'Value')
   % % 获取定时器周期
   t1 = 0.001*str2double(get(handles.period,'string'));
   t = timer('ExecutionMode','fixedrate','Period',t1,'TimerFcn',...
       {@manual_send_Callback,handles});%创建定时器
   set(handles.period,'Enable','off');
   set(handles.manual_send,'Enable','off');
   set(handles.send,'Enable','inactive');
   start(t);
else
   set(handles.period,'Enable','on');
   set(handles.manual_send,'Enable','on');
   set(handles.send,'Enable','on');
   t = timerfind;
   stop(t);
   delete(t);
end

% --- Executes on button press in hex_send.
function hex_send_Callback(hObject, eventdata, handles)
% hObject    handle to hex_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hex_send
if get(hObject,'Value') 
    isHexSend = true;
else
    isHexSend = false;
end
setappdata(handles.figure1,'isHexSend',isHexSend);
% % 更新发送数据
send_Callback(handles.trans,eventdata,handles);
% --- Executes on button press in clear_send.
function clear_send_Callback(hObject, eventdata, handles)
% hObject    handle to clear_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.trans,'string','');
set(handles.trans,'UserData',[])


function period_Callback(hObject, eventdata, handles)
% hObject    handle to period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of period as text
%        str2double(get(hObject,'String')) returns contents of period as a double

% --- Executes during object creation, after setting all properties.
function period_CreateFcn(hObject, ~, handles)
% hObject    handle to period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manual_send.
function manual_send_Callback(hObject, eventdata, handles)
% hObject    handle to manual_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 【手动发送】按钮状态
% % 获取参数
scom = get(handles.figure1,'UserData');
numSend = getappdata(handles.figure1,'numSend');
val = get(handles.send,'UserData');
% % 更新发送的数据个数
numSend = numSend + length(val);
set(handles.trans,'string',num2str(numSend));
setappdata(handles.figure1,'numSend',numSend);
% % 若发送数据不为空则发送数据
if ~isempty(val)
	n = 1000;
    while n
        % % 获取串口的传输状态，若没有正在写入数据则写入数据
        str = get(scom,'TransferStatus');
        if ~(strcmp(str,'write')||strcmp(str,'read&write'))
           fwrite(scom,val,'uint8','async');%数据写入串口 异步模式
           break;
        end
        n = n - 1;
    end
end
% --- Executes on button press in stop_disp.
function stop_disp_Callback(hObject, eventdata, handles)
% hObject    handle to stop_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 根据【停止显示】按钮状态更新isStopDisp参数
if get(hObject,'value')
    isStopDisp = true;
else
    isStopDisp = false;
end
setappdata(handles.figure1,'isStopDisp',isStopDisp);
% --- Executes on button press in clear_disp.
function clear_disp_Callback(hObject, eventdata, handles)
% hObject    handle to clear_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 【清空接收区】
txtfilename = getappdata(handles.figure1,'txtfilename');
% % 清空要显示的字符串
setappdata(handles.figure1,'strRec','');
% % 清空已显示的字符串
set(handles.disp,'string','');
% % 清空文件内容
fid = fopen(txtfilename,'w');
fwrite(fid,'');
fclose(fid);
% --- Executes on button press in hex_disp.
function hex_disp_Callback(hObject, eventdata, handles)
% hObject    handle to hex_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 
% Hint: get(hObject,'Value') returns toggle state of hex_disp
% % 根据【十六进制显示】复选框状态更新isHexDisp参数
if get(hObject,'value')
    isHexDisp = true;
else
    isHexDisp = false;
end
setappdata(handles.figure1,'isHexDisp',isHexDisp);
% --- Executes on button press in data_save.
function data_save_Callback(hObject, eventdata, handles)
% hObject    handle to data_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
douRec = getappdata(handles.figure1,'douRec');
%% 根据【保存数据】复选框更新复制状态
if get(hObject,'value')
    set(handles.disp,'enable','on');
else
    set(handles.disp,'enable','off');
end
% t = timerfind
% if ~isempty(t)
%     stop(t);
    [filename,pathname]=uiputfile({'data_save.txt';'*.txt'},'保存数据为'); 
    if filename
        file=strcat(pathname,filename);
        fid = fopen(file,'w+');%'w+':刷新重写数据，若无文件则创建
        fwrite(fid,douRec);
        fclose(fid);
    end
% Hint: get(hObject,'Value') returns toggle state of data_save
function dataDisp(hObject,eventdata,handles)
%% 【数据显示】
% % 获取参数
hasData = getappdata(handles.figure1,'hasData');
strRec = getappdata(handles.figure1,'strRec');
% douRec = getappdata(handles.figure1,'douRec');
numRec = getappdata(handles.figure1,'numRec');
txtfilename = getappdata(handles.figure1,'txtfilename');
% % 检测串口是否获取到数据，没有则尝试接收数据
if hasData
    bytes(hObject,eventdata,handles);
end
% a1 = hasData;                       % ****调试用****
%% 若串口有数据，则显示数据
if hasData
   % % 给数据显示加互斥锁
   % % 在执行显示数据模块时，不接受串口数据
   setappdata(handles.figure1,'isShow',true);
   % % 显示的字符串长度超过10000，清空显示区
   if length(strRec) > 10000
       strRec = ' ';
       setappdata(handles.figure1,'string',strRec);
   end
%    a2 = strRec;                                      % ****调试用****
   % % 显示数据
   set(handles.disp,'string',strRec);
   % % 更新接受计数
   set(handles.rec,'string',numRec);
   %% 将数据以【曲线】的形式表示
   A = load(txtfilename);
   if ~isempty(A)
        douRec = A(:,1);
   else
       douRec = 0;
   end
   plot(handles.data_axes,douRec,'-r');
   grid(handles.data_axes,'on');
   grid(handles.data_axes,'minor');
   % % 更新hasData标志，表明串口数据已经显示
   setappdata(handles.figure1,'hasData',false);
   % % 给数据显示模块解锁
   setappdata(handles.figure1,'isShow',false);
   % % 将采集数据存入窗口对象内
   setappdata(handles.figure1,'douRec',douRec);
end
function bytes(Object,~,handles)
%% 【数据接收】
% % 获取参数
strRec = getappdata(handles.figure1,'strRec');
numRec = getappdata(handles.figure1,'numRec');
isStopDisp = getappdata(handles.figure1,'isStopDisp');
isHexDisp = getappdata(handles.figure1,'isHexDisp');
isShow = getappdata(handles.figure1,'isShow');   
txtfilename = getappdata(handles.figure1,'txtfilename');
% % 显示数据时不接收新数据
if isShow
    return;
end
% % 获取串口可获取的数据个数
n = get(Object,'BytesAvailable');
%% 若串口有数据，则接收所有数据
if n
    % % 更新hasData参数
    setappdata(handles.figure1,'hasData',true);
%     hasData = getappdata(handles.figure1,'hasData');% ****调试用****
    % % 读取串口数据
    a = fread(Object,n,'uchar');%ASCII值
%% ************************调试用***************************
%      class(a)                      %****调试用****
%     str_c = char(a')                     % ****调试用****
%  class(str_c)
 %******************************************************************
    %% 若没有停止显示，则将数据解算出来，准备显示
    if ~isStopDisp
        % % 根据需求将数据转换为相应的进制模式
        if ~isHexDisp
            c = char(a');
        else
            strHex = dec2hex(a')';
            strHex2 = [strHex;blanks(size(a,1))];
            c = strHex2(:)';
        end
        % % 更新已接收的数据个数
        numRec = numRec + size(a,1);
        % % 存储数据.txt
        fid = fopen(txtfilename,'a');%'a':后续写入，若无文件则创建
        fwrite(fid,a);
        % % 更新显示的字符串
        strRec = [strRec c];
        fclose(fid);
    end
    % % 更新参数
    setappdata(handles.figure1,'numRec',numRec);
    setappdata(handles.figure1,'strRec',strRec);
end
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 【界面关闭】
% % 查找定时器
t = timerfind;
% % 若存在定时器对象，则停止并关闭
if ~isempty(t)
    stop(t);
    delete(t);
end
% % 查找串口对象
scoms = instrfind;
% % 若存在定时器对象，则停止并关闭
try
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
% catch
%     sprintf('无法关闭窗口！')
%     return;
end
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in curv_save.
function curv_save_Callback(hObject, eventdata, handles)
% hObject    handle to curv_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_f_handle=figure('visible','off');
new_axes=copyobj(handles.data_axes,new_f_handle); %picture是GUI界面绘图的坐标系句柄
set(new_axes,'units','default','position','default');
[filename,pathname,fileindex]=uiputfile({'curv_save.jpg';'*.bmp'},'保存曲线为');
if ~filename
     return
else
      file=strcat(pathname,filename);
      switch fileindex %根据不同的选择保存为不同的类型
      case 1
                  print(new_f_handle,'-djpeg',file);
      case 2
                  print(new_f_handle,'-dbmp',file);
      end
end
delete(new_f_handle);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over data_save.
function data_save_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to data_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over curv_save.
function curv_save_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to curv_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over clear_count.
function clear_count_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to clear_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function send_CreateFcn(hObject, eventdata, handles)
% hObject    handle to send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
