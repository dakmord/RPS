function d = showLoadingAnimation(windowName, loadingText)
enableDisableFig(gcf,'off');
d = com.mathworks.mlwidgets.dialog.ProgressBarDialog.createProgressBar(windowName, []);
d.setValue(0.25);                        % default = 0
d.setProgressStatusLabel(loadingText);  % default = 'Please Wait'
d.setSpinnerVisible(false);               % default = true
d.setCircularProgressBar(true);         % default = false  (true means an indeterminate (looping) progress bar)
d.setCancelButtonVisible(false);          % default = true
d.setVisible(true);                      % default = false

