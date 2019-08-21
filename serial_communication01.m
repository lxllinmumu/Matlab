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
%*************************���Ȳ���**************************
%ֻ���е�ʮ��������ʾ�����ݱ�������߱���δ����Լ����ݷ��Ͳ���
%������ʾedit�༭����α�������׶�
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
%% ��ʼ������
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
%% ������������ΪӦ�����ݣ����봰�ڶ���
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

% % ��ȡ���ڱ༭�����ַ���
str = get(handles.send,'String');
% % ��ȡisHexSend����
isHexSend = getappdata(handles.figure1,'isHexSend');

if ~isHexSend                   %��ΪASCII��ʽ���ͣ�ֱ�ӽ��ַ���תΪ��Ӧ����ֵ
    val = double(str);          %ע����str2double������
else                            %��Ϊʮ��������ʽ���ͣ���ȡҪ���͵�����
    n = find(str == ' ');       %���ҿո�
    n = [0 n length(str)+1];    %�ո�����
    % % ÿ�����ո�֮����ַ���Ϊ��ֵ��ʮ��������ʽ������ת��Ϊ��ֵ
    length_b = length(n)-1;
    b = cell(1,length_b);
    for i = 1:length_b
       temp = str(n(i)+1:n(i+1)-1);     %��ȡÿ�����ݵĳ���
       if ~rem(length(temp),2)
           b{i} = reshape(temp,2,[])';  %��ÿ��ʮ������ת��Ϊ��λ����
       else
           break;
       end
    end
    val = hex2dec(b)';                  %��ʮ������ת��Ϊʮ���ƣ��ȴ�д�봮��
end
% % ���·�������
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
    % % ��ȡ������
    com_n = sprintf('COM%d',get(handles.com,'value'));
    % % ��ȡ������
    rates = get(handles.rate,'string');
    baud_rate = str2num(rates{get(handles.rate,'value')});
    %% ��ȡУ��λ
    switch get(handles.check_bits,'value')
        case 1 
            check = 'none';
        case 2
            check = 'odd';
        case 3
            check = 'even';
    end
    %% ��ȡ����λ
    data_bits = 5 + get(handles.data_bits,'value');
    % % ��ȡֹͣλ
    stop_bits = get(handles.stop_bits,'value');
    % % �������ڶ���
    scom = serial(com_n);
    % % ���ô�������
    set(scom,'BaudRate',baud_rate,'parity',check,'DataBits',data_bits,...
        'StopBits',stop_bits,'BytesAvailableFcnCount',10,...
        'BytesAvailableFcnMode','byte','BytesAvailableFcn',{@bytes,handles},...
        'TimerPeriod',0.01,'timerFcn',{@dataDisp,handles});
    % % �����ڶ���ľ����Ϊ�û����ݣ����봰�ڶ���
    set(handles.figure1,'UserData',scom);
    %% ���Դ򿪴���
    try
        fopen(scom);
    catch
        msgbox('error:�޷���ȡ����!');
        set(hObject,'value',0);
        return;
    end
    %% �򿪴��ں������ڷ������ݣ���ս�����ʾ������������״ָ̬ʾ��
    % �����İ�ť�ı�Ϊ���رմ��ڡ�
    set(handles.period_send,'Enable','on');
    set(handles.manual_send,'Enable','on');
    set(handles.disp,'string','');
    set(handles.lamb,'backgroundcolor','green');
    set(hObject,'string','�رմ���');
   % off-�����ڻ�ɫ����ѡ��״̬��inactive-����ѡ�У�������Ϊ��ɫ
    set(handles.com,'Enable','off');
    set(handles.rate,'Enable','off');
    set(handles.check_bits,'Enable','off');
    set(handles.data_bits,'Enable','off');
    set(handles.stop_bits,'Enable','off');
else%�رմ���
    % % ֹͣ��ɾ����ʱ��
    t = timerfind;
    if ~isempty(t)
        stop(t);
        delete(t);
    end
    % % ֹͣ��ɾ�����ڶ���
    scoms= instrfind;
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
    % % ���á��Զ����͡��͡��ֶ����͡�
    set(handles.period_send,'Enable','off','value',0);
    set(handles.manual_send,'Enable','off');
	set(handles.lamb,'backgroundcolor','red');
	set(hObject,'string','�򿪴���');
    
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
%% ���Զ����͡�
if get(hObject,'Value')
   % % ��ȡ��ʱ������
   t1 = 0.001*str2double(get(handles.period,'string'));
   t = timer('ExecutionMode','fixedrate','Period',t1,'TimerFcn',...
       {@manual_send_Callback,handles});%������ʱ��
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
% % ���·�������
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
%% ���ֶ����͡���ť״̬
% % ��ȡ����
scom = get(handles.figure1,'UserData');
numSend = getappdata(handles.figure1,'numSend');
val = get(handles.send,'UserData');
% % ���·��͵����ݸ���
numSend = numSend + length(val);
set(handles.trans,'string',num2str(numSend));
setappdata(handles.figure1,'numSend',numSend);
% % ���������ݲ�Ϊ����������
if ~isempty(val)
	n = 1000;
    while n
        % % ��ȡ���ڵĴ���״̬����û������д��������д������
        str = get(scom,'TransferStatus');
        if ~(strcmp(str,'write')||strcmp(str,'read&write'))
           fwrite(scom,val,'uint8','async');%����д�봮�� �첽ģʽ
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
%% ���ݡ�ֹͣ��ʾ����ť״̬����isStopDisp����
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
%% ����ս�������
txtfilename = getappdata(handles.figure1,'txtfilename');
% % ���Ҫ��ʾ���ַ���
setappdata(handles.figure1,'strRec','');
% % �������ʾ���ַ���
set(handles.disp,'string','');
% % ����ļ�����
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
% % ���ݡ�ʮ��������ʾ����ѡ��״̬����isHexDisp����
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
%% ���ݡ��������ݡ���ѡ����¸���״̬
if get(hObject,'value')
    set(handles.disp,'enable','on');
else
    set(handles.disp,'enable','off');
end
% t = timerfind
% if ~isempty(t)
%     stop(t);
    [filename,pathname]=uiputfile({'data_save.txt';'*.txt'},'��������Ϊ'); 
    if filename
        file=strcat(pathname,filename);
        fid = fopen(file,'w+');%'w+':ˢ����д���ݣ������ļ��򴴽�
        fwrite(fid,douRec);
        fclose(fid);
    end
% Hint: get(hObject,'Value') returns toggle state of data_save
function dataDisp(hObject,eventdata,handles)
%% ��������ʾ��
% % ��ȡ����
hasData = getappdata(handles.figure1,'hasData');
strRec = getappdata(handles.figure1,'strRec');
% douRec = getappdata(handles.figure1,'douRec');
numRec = getappdata(handles.figure1,'numRec');
txtfilename = getappdata(handles.figure1,'txtfilename');
% % ��⴮���Ƿ��ȡ�����ݣ�û�����Խ�������
if hasData
    bytes(hObject,eventdata,handles);
end
% a1 = hasData;                       % ****������****
%% �����������ݣ�����ʾ����
if hasData
   % % ��������ʾ�ӻ�����
   % % ��ִ����ʾ����ģ��ʱ�������ܴ�������
   setappdata(handles.figure1,'isShow',true);
   % % ��ʾ���ַ������ȳ���10000�������ʾ��
   if length(strRec) > 10000
       strRec = ' ';
       setappdata(handles.figure1,'string',strRec);
   end
%    a2 = strRec;                                      % ****������****
   % % ��ʾ����
   set(handles.disp,'string',strRec);
   % % ���½��ܼ���
   set(handles.rec,'string',numRec);
   %% �������ԡ����ߡ�����ʽ��ʾ
   A = load(txtfilename);
   if ~isempty(A)
        douRec = A(:,1);
   else
       douRec = 0;
   end
   plot(handles.data_axes,douRec,'-r');
   grid(handles.data_axes,'on');
   grid(handles.data_axes,'minor');
   % % ����hasData��־���������������Ѿ���ʾ
   setappdata(handles.figure1,'hasData',false);
   % % ��������ʾģ�����
   setappdata(handles.figure1,'isShow',false);
   % % ���ɼ����ݴ��봰�ڶ�����
   setappdata(handles.figure1,'douRec',douRec);
end
function bytes(Object,~,handles)
%% �����ݽ��ա�
% % ��ȡ����
strRec = getappdata(handles.figure1,'strRec');
numRec = getappdata(handles.figure1,'numRec');
isStopDisp = getappdata(handles.figure1,'isStopDisp');
isHexDisp = getappdata(handles.figure1,'isHexDisp');
isShow = getappdata(handles.figure1,'isShow');   
txtfilename = getappdata(handles.figure1,'txtfilename');
% % ��ʾ����ʱ������������
if isShow
    return;
end
% % ��ȡ���ڿɻ�ȡ�����ݸ���
n = get(Object,'BytesAvailable');
%% �����������ݣ��������������
if n
    % % ����hasData����
    setappdata(handles.figure1,'hasData',true);
%     hasData = getappdata(handles.figure1,'hasData');% ****������****
    % % ��ȡ��������
    a = fread(Object,n,'uchar');%ASCIIֵ
%% ************************������***************************
%      class(a)                      %****������****
%     str_c = char(a')                     % ****������****
%  class(str_c)
 %******************************************************************
    %% ��û��ֹͣ��ʾ�������ݽ��������׼����ʾ
    if ~isStopDisp
        % % ������������ת��Ϊ��Ӧ�Ľ���ģʽ
        if ~isHexDisp
            c = char(a');
        else
            strHex = dec2hex(a')';
            strHex2 = [strHex;blanks(size(a,1))];
            c = strHex2(:)';
        end
        % % �����ѽ��յ����ݸ���
        numRec = numRec + size(a,1);
        % % �洢����.txt
        fid = fopen(txtfilename,'a');%'a':����д�룬�����ļ��򴴽�
        fwrite(fid,a);
        % % ������ʾ���ַ���
        strRec = [strRec c];
        fclose(fid);
    end
    % % ���²���
    setappdata(handles.figure1,'numRec',numRec);
    setappdata(handles.figure1,'strRec',strRec);
end
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ������رա�
% % ���Ҷ�ʱ��
t = timerfind;
% % �����ڶ�ʱ��������ֹͣ���ر�
if ~isempty(t)
    stop(t);
    delete(t);
end
% % ���Ҵ��ڶ���
scoms = instrfind;
% % �����ڶ�ʱ��������ֹͣ���ر�
try
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
% catch
%     sprintf('�޷��رմ��ڣ�')
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
new_axes=copyobj(handles.data_axes,new_f_handle); %picture��GUI�����ͼ������ϵ���
set(new_axes,'units','default','position','default');
[filename,pathname,fileindex]=uiputfile({'curv_save.jpg';'*.bmp'},'��������Ϊ');
if ~filename
     return
else
      file=strcat(pathname,filename);
      switch fileindex %���ݲ�ͬ��ѡ�񱣴�Ϊ��ͬ������
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
