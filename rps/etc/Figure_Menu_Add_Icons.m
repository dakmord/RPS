%% #######################     HEADER START    ############################
%*************************************************************************
%
% Filename:				Figure_Menu_Add_Icons.m
%
% Author:				A. Mering
% Created:				22-Nov-2013
%
% Changed on:			XX-XX-XXXX  by USERNAME		SHORT CHANGE DESCRIPTION
%						XX-XX-XXXX  by USERNAME		SHORT CHANGE DESCRIPTION
%
%*************************************************************************
%
% Description:
%		Adapt the figure menu of a GUIDE GUI
% 
%
% Input parameter:
%		- GUI_handle:		Handle to the GUI to be adapted
%
% Output parameter:
%		- none
%
%*************************************************************************
%
% Intrinsic Subfunctions
%		- Loop_SubMenues:	Loop through the submenus and retrieve items
%		- AddIcon:			Add icon to given java element
%
% Intrinsic Callbacks
%		- none
%
% #######################      HEADER END     ############################

%% #######################    FUNCTION START   ############################
function Figure_Menu_Add_Icons(GUI_handle)

%% Input checking
if ~ishandle(GUI_handle) || ~ isequal(get(GUI_handle, 'Type'), 'figure')
	error('Given input is not a valid figure handle')
end

%% Extract menu bar from figure
warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
JFrame = get(GUI_handle, 'JavaFrame');		% get frame = java figure

if verLessThan('matlab', '7.5')	% earlier than R2008a
	
	JWindow = JFrame.fFigureClient.getWindow;	% get the Window
	
else % R2008a and later
	
	JWindow = JFrame.fHG1Client.getWindow;		% get the Window
end

JMenuBar      =  JWindow.getJMenuBar;			% get the menu for the figure

%% Extract menu structure from Matlab
uimenu_handle_list = findobj(GUI_handle, 'Type', 'uimenu');

% get top level menus
top_level_menu_handles = uimenu_handle_list(find(cell2mat(get(uimenu_handle_list, 'Parent')) == GUI_handle));

for num_menu = 1: length(top_level_menu_handles)
	pos_menu_java = get(top_level_menu_handles(num_menu), 'Position') - 1;
	
	JMenu = JMenuBar.getMenu(pos_menu_java);
	
	% open each menu entry to make java instance available
	JMenu.doClick
	pause(0.05);
	JMenu.menuSelectionChanged(false)
	JMenu.getPopupMenu.menuSelectionChanged(false)
	
	% add icon to top level menu
	AddIcon(JMenu, top_level_menu_handles(num_menu))
	
	% loop through the children
	Menu_Children = get(top_level_menu_handles(num_menu), 'Children');
	
 	Loop_SubMenues(JMenu, Menu_Children)		
end

% #######################     FUNCTION END    ############################

%% #######################  SUBFUNCTION START  ############################
function Loop_SubMenues(JMenu, Menu_Children)
% recursively runs through the menu entries and adds the icon, if exists

if isempty(Menu_Children)
	return
end

%% take care of seperators
% these change the positions
separator_state = get(Menu_Children, {'Separator'});
separator_state(strcmp(separator_state, 'off')) = {0};
separator_state(strcmp(separator_state, 'on')) = {1};

% sort position in ascending order
children_info = [Menu_Children, cell2mat([get(Menu_Children, 'Position'), separator_state])];
children_info = sortrows(children_info, 2);

children_info(:,3) = cumsum(children_info(:, 3));

for num_entry = 1 : length(Menu_Children)
	
	pos_entry_java = children_info(num_entry, 2) + children_info(num_entry, 3) - 1;  % java indexing
	
	AddIcon(JMenu.getItem(pos_entry_java), children_info(num_entry, 1))
	
	% Recurse into submenues
	Loop_SubMenues(JMenu.getItem(pos_entry_java), get(children_info(num_entry, 1), 'Children'))
	
end

% --------------
% Attach Icon to menu entry
function AddIcon(Jhandle, Mhandle)

if isempty(Jhandle) || isempty(Mhandle)
	return
end


icon_info = get(Mhandle, 'UserData');

switch class(icon_info)
	
	case 'javax.swing.ImageIcon'	% full qualified java icon
		
		Jhandle.setIcon(icon_info);
		
	case 'char'			% only filename give
		
		icon_info = which(icon_info);
		
		if exist(icon_info, 'file')
			
			Jhandle.setIcon(javax.swing.ImageIcon(icon_info))

		end
		
	case 'double'		% Checkmarked items, do nothing		

end

% #######################   SUBFUNCTION END   ############################

%% #######################    CALLBACK START   ############################


% #######################     CALLBACK END    ############################

