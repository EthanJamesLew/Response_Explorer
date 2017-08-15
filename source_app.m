function varargout = source_app(varargin)
% SOURCE_APP MATLAB code for source_app.fig
%      SOURCE_APP, by itself, creates a new SOURCE_APP or raises the existing
%      singleton*.
%
%      H = SOURCE_APP returns the handle to a new SOURCE_APP or the handle to
%      the existing singleton*.
%
%      SOURCE_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOURCE_APP.M with the given input arguments.
%
%      SOURCE_APP('Property','Value',...) creates a new SOURCE_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before source_app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to source_app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help source_app

% Last Modified by GUIDE v2.5 10-Aug-2017 19:32:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @source_app_OpeningFcn, ...
                   'gui_OutputFcn',  @source_app_OutputFcn, ...
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


% --- Executes just before source_app is made visible.
function source_app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to source_app (see VARARGIN)

% Choose default command line output for source_app
clc;

handles.output = hObject;

handles.H_old = 0;

set(handles.status_static_text, 'String', 'Loading Old H data...');
load(strcat(pwd, '\OLD\MATS\H_old.mat'));
handles.H_old = H_all;
set(handles.status_static_text, 'String','Idle');

set(handles.status_static_text, 'String', 'Loading Old GV data...');
load(strcat(pwd, '\OLD\MATS\globalview_old.mat'));
handles.locs_old = locs;
handles.levs_old = levs;
handles.lons_old = lons;
handles.lats_old = lats;
set(handles.status_static_text, 'String','Idle');

handles.tau = 1;

handles.year = uicontrol('Parent',handles.slider_panel,'Style','slider','Position',[0,0,500,25],...
              'value',handles.tau, 'min',1, 'max',400);
          
handles.year.Callback = @(es, ex)update_plot(hObject, eventdata, handles, varargin); 
          
guidata(hObject, handles);
update_location_menu(hObject, eventdata, handles, varargin);



update_plot(hObject, eventdata, handles, varargin);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes source_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function update_plot(hObject, eventdata, handles, varargin)

    
    handles = guidata(hObject);
    cats = {'Gas+Oil', 'Coal', 'Livestock', 'Waste', 'BB C3', 'Rice', 'WL(30-0N)', 'BB C4', 'WL(90-30N)', 'WL(0-90S)'};
    
    
    delete(get(handles.uibuttongroup1,'Children'));
    is3d = get(handles.enable_3d, 'Value');
    

    site_idx = get(handles.location_menu,'Value');
    if isempty(site_idx)
        site_idx = 1;
    end

    ax = axes('Parent',handles.uibuttongroup1);
    tau = floor(get(handles.year,'Value'));
    month = mod(tau, 12);
    year = floor(tau/12) + 1979;
    s = strcat(num2str(month), '/');
    s = strcat(s,  num2str(year));
    s = strcat(s, ' tau:');
    set(handles.tau_edit_text, 'String', strcat(s, num2str(tau)));
    
    name = handles.locs_old(site_idx);
    name = strcat(name, ' [ ');
    name = strcat(name, num2str(handles.lons_old(site_idx)));
    name = strcat(name, ', ');
    name = strcat(name, num2str(handles.lats_old(site_idx)));
    name = strcat(name, ', ');
    name = strcat(name, num2str(handles.levs_old(site_idx)));
    name = strcat(name, ']');
    name = strcat(name, ' --- ');
    name = strcat(name, s(1:numel(s)-4));
        
    if is3d
        if tau ~= 1
            cat_idx = get(handles.cat_pop,'Value');
            [Y, X] = meshgrid(1:1:12, 1:tau);
            size([Y, X]);
            Zs = transpose(squeeze(handles.H_old(:, cat_idx, site_idx, 1:tau)));
            size(Zs);

            %[X,Y] = meshgrid(1:0.5:10,1:20);
            %Zs = sin(X) + cos(Y);
            %size(Zs)
            %size([X, Y])
            surf(X,Y,Zs);
            set(gca,'Ydir','reverse')

            title(name, 'Interpreter', 'latex')
            xlabel('Time (months since 1/1979)', 'Interpreter', 'latex')
            ylabel('Response Time (months)', 'Interpreter', 'latex')
            zlabel('CH$_4$Concentration (ppb)', 'Interpreter', 'latex')
            
            xlim([1, tau])
            ylim([1, 12])

            rotate3d();
        end
    else
        
        

        %hold on
        months = (1:1:12);
        ma = 0;

        for i=1: 10
            ys =  handles.H_old(:, i, site_idx, tau);
                temp = max(ys);
                if temp > ma
                       ma = temp;
                end
        end


        for i=1: 10
                %subplot(5, 2,i);
                ys =  handles.H_old(:, i, site_idx, tau);
                
                subaxis(5, 2, i, 'sh', 0.00, 'sv', 0.00, 'padding', 0, 'margin', 0.07);
                axis off

                plot( transpose(months), ys) ;

                if i == 1
                    
                    title(name, 'Interpreter', 'latex');
                end

                xlim([1, 12])
                text(6, ma*.8,cats(i), 'center', 'interpreter', 'latex');
                gcas(i) = gca;
                
                if mod(i, 2) == 0
                    set(gca, 'YaxisLocation', 'right');
                end
                
                if i > 8
                    xlabel('Time Response (months)', 'interpreter', 'latex');
                end
                
                if or(i == 5, i == 6)
                    ylabel('CH$_4$ Concentration (ppb)', 'interpreter', 'latex');
                end
        end
        set(gcas, 'Ylim', [0, ma]);
        
    end
   
    %hold off
    guidata(hObject, handles);


function update_location_menu(hObject, eventdata, handles, varargin)
handles = guidata(hObject);
cats = {'Gas+Oil', 'Coal', 'Livestock', 'Waste', 'BB C3', 'Rice', 'WL(30-0N)', 'BB C4', 'WL(90-30N)', 'WL(0-90S)'};
set(handles.location_menu,'String', transpose(handles.locs_old));
set(handles.cat_pop,'String', transpose(cats));
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = source_app_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in location_menu.
function location_menu_Callback(hObject, eventdata, handles)
% hObject    handle to location_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns location_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from location_menu
update_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function location_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to location_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in enable_3d.
function enable_3d_Callback(hObject, eventdata, handles)
% hObject    handle to enable_3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable_3d
update_plot(hObject, eventdata, handles);
is3d = get(handles.enable_3d, 'Value')
if is3d
    set(handles.cat_pop, 'Visible', 'on')
else
    set(handles.cat_pop, 'Visible', 'off')
end


% --- Executes on selection change in cat_pop.
function cat_pop_Callback(hObject, eventdata, handles)
% hObject    handle to cat_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cat_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cat_pop
update_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function cat_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cat_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Print_Callback(hObject, eventdata, handles)
% hObject    handle to Print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
print_dialogue(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_dialogue(hObject, eventdata, handles)


% --------------------------------------------------------------------
function print_menu_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to print_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
print_dialogue(hObject, eventdata, handles)

% --------------------------------------------------------------------
function save_menu_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_dialogue(hObject, eventdata, handles)

function save_dialogue(hObject, eventdata, handles)
filename = uiputfile('*.fig','Save Figure');
if filename ~= 0
    uicontrols = findall(handles.uibuttongroup1,'Parent',handles.uibuttongroup1); 
    fh = figure(); %new figure
    copyobj(uicontrols, fh); %show selected axes in new figure
    saveas(gcf,filename);
    close(gcf);
end

function print_dialogue(hObject, eventdata, handles)
    uicontrols = findall(handles.uibuttongroup1,'Parent',handles.uibuttongroup1); 
    fh = figure(); %new figure
    copyobj(uicontrols, fh); %show selected axes in new figure
    printpreview(fh);
    close(gcf);
