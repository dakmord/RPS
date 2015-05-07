function integerScalarCallback( hObj, hDlg, fieldName, ~ )

tagprefix= 'Tag_ConfigSet_RTT_Settings_';
tag= [ tagprefix, fieldName] ;
newVal= hDlg. getWidgetValue( tag) ;

if ~ i_isEntryValid( newVal)
    oldVal= hObj. TargetExtensionData. ( fieldName) ;
    hDlg. setWidgetValue( tag, oldVal) ;
    msg= 'Invalid entry. Enter the number as a positive scalar integer number.';
    realtime. errorDlg( 'realtime:setup:Error', msg) ;
else
    hObj. TargetExtensionData. ( fieldName) = newVal;
end

end


function ret= i_isEntryValid( newVal)
ret= false;
valStr= str2num( newVal) ; %#ok<ST2NM>
valNum= int32( valStr) ;
if ~ isempty( valStr) && isscalar( valNum) && isreal( valNum) &&  ...
        ( valStr> 0) && isempty( strfind( newVal, '.') )
    ret= true;
end
end


