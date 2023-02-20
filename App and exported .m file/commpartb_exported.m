classdef commpartb_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        GridLayout        matlab.ui.container.GridLayout
        LeftPanel         matlab.ui.container.Panel
        TbmsSpinnerLabel  matlab.ui.control.Label
        TbmsSpinner       matlab.ui.control.Spinner
        StartButton       matlab.ui.control.Button
        AVSpinnerLabel    matlab.ui.control.Label
        AVSpinner         matlab.ui.control.Spinner
        DropDown          matlab.ui.control.DropDown
        RightPanel        matlab.ui.container.Panel
        Label             matlab.ui.control.Label
        UIAxes            matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: AVSpinner
        function AVSpinnerValueChanged(app, event)
            valueA = app.AVSpinner.Value;
            
        end

        % Value changed function: TbmsSpinner
        function TbmsSpinnerValueChanged(app, event)
            valueTb = app.TbmsSpinner.Value;
            
        end

        % Value changed function: DropDown
        function DropDownValueChanged(app, event)
            valueDD = app.DropDown.Value;
            
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            Am= app.AVSpinner.Value;
            Tb= app.TbmsSpinner.Value;
            DD= app.DropDown.Value;
            bits=randi([0 1],1,10);
            NBits=10;
            tvec1=linspace(0,NBits*Tb,NBits*Tb);
            sig=zeros(1,length(tvec1));
            
            if DD=="Unipolar NRZ"
                for i=1:length(bits)
                    if i==1               
                      sig(1:Tb)=bits(i);      
                    else
                      sig((i-1)*Tb+1:(i-1)*Tb+Tb)=bits(i);
                    end
                end
            elseif DD=="Unipolar RZ"
                for i=1:length(bits)
                    if i==1
                            sig(1:floor(Tb/2))=bits(i);
                            sig(1+floor(Tb/2):Tb)=0;     
                    else
                            sig((i-1)*Tb+1:(i-1)*Tb+floor(Tb/2))=bits(i);
                            sig((i-1)*Tb+floor(Tb/2)+1:(i-1)*Tb+Tb)=0; 
                    end
                end
            elseif DD=="Polar NRZ"
                  for i=1:length(bits)
                    if i==1
                       if bits(i)==0
                           sig(1:Tb)=-1;
                       else
                           sig(1:Tb)=bits(i);
                       end
                    else
                        if bits(i)==0
                            sig((i-1)*Tb+1:(i-1)*Tb+Tb)=-1;
                        else
                            sig((i-1)*Tb+1:(i-1)*Tb+Tb)=bits(i);
                        end
                    end
                  end
            elseif DD=="Polar RZ"
                for i=1:length(bits)
                    if i==1
                        if bits(i)==1
                            sig(1:floor(Tb/2))=bits(i);
                            sig(1+floor(Tb/2):Tb)=0;
                        else
                            sig(1:floor(Tb/2))=-1;
                            sig(1+floor(Tb/2):Tb)=0;
                        end
                    else
                        if bits(i)==1
                            sig((i-1)*Tb+1:(i-1)*Tb+floor(Tb/2))=bits(i);
                            sig((i-1)*Tb+floor(Tb/2)+1:(i-1)*Tb+Tb)=0;
                        else
                            sig((i-1)*Tb+1:(i-1)*Tb+floor(Tb/2))=-1;
                            sig((i-1)*Tb+floor(Tb/2)+1:(i-1)*Tb+Tb)=0;
                        end
                    end
                end
            elseif DD== "AMI"
             sign=1;
             for i=1:length(bits)
                 
                 am=bits(i)*sign;
                    if i==1               
                      sig(1:Tb)=am;      
                    else
                      sig((i-1)*Tb+1:(i-1)*Tb+Tb)=am;
                    end
                    sign=sign*(-1);
             end
            elseif DD=="Manchester Code"
                for i=1:length(bits)
                    if i==1
                        if bits(i)==1
                            sig(1:floor(Tb/2))=-1;
                            sig(1+floor(Tb/2):Tb)=1; 
                        else
                            sig(1:floor(Tb/2))=1;
                            sig(1+floor(Tb/2):Tb)=-1; 
                        end
                    else
                        if bits(i)==1
                            sig((i-1)*Tb+1:(i-1)*Tb+floor(Tb/2))=-1;
                            sig((i-1)*Tb+floor(Tb/2)+1:(i-1)*Tb+Tb)=1;
                        else
                            sig((i-1)*Tb+1:(i-1)*Tb+floor(Tb/2))=1;
                            sig((i-1)*Tb+floor(Tb/2)+1:(i-1)*Tb+Tb)=-1;
                        end
                    end
                end
            end
            app.Label.Text="Input bits: "+int2str(bits);
            plot(app.UIAxes,tvec1,Am*sig)
            title(app.UIAxes,DD+" line code");
            xlabel(app.UIAxes,"Time (milliseconds)");
            ylabel(app.UIAxes,"Amplitude (Volts)");
            drawnow
        end

        % Button down function: UIAxes
        function UIAxesButtonDown(app, event)
            
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create TbmsSpinnerLabel
            app.TbmsSpinnerLabel = uilabel(app.LeftPanel);
            app.TbmsSpinnerLabel.HorizontalAlignment = 'right';
            app.TbmsSpinnerLabel.Position = [7 303 43 22];
            app.TbmsSpinnerLabel.Text = 'Tb(ms)';

            % Create TbmsSpinner
            app.TbmsSpinner = uispinner(app.LeftPanel);
            app.TbmsSpinner.ValueChangedFcn = createCallbackFcn(app, @TbmsSpinnerValueChanged, true);
            app.TbmsSpinner.Tag = 'Tb';
            app.TbmsSpinner.Position = [65 303 126 22];

            % Create StartButton
            app.StartButton = uibutton(app.LeftPanel, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Tag = 'Start';
            app.StartButton.Position = [25 187 166 42];
            app.StartButton.Text = 'Start';

            % Create AVSpinnerLabel
            app.AVSpinnerLabel = uilabel(app.LeftPanel);
            app.AVSpinnerLabel.HorizontalAlignment = 'right';
            app.AVSpinnerLabel.Position = [17 338 33 22];
            app.AVSpinnerLabel.Text = 'A(V) ';

            % Create AVSpinner
            app.AVSpinner = uispinner(app.LeftPanel);
            app.AVSpinner.ValueChangedFcn = createCallbackFcn(app, @AVSpinnerValueChanged, true);
            app.AVSpinner.Tag = 'Amp';
            app.AVSpinner.Position = [65 338 127 22];

            % Create DropDown
            app.DropDown = uidropdown(app.LeftPanel);
            app.DropDown.Items = {'Unipolar NRZ', 'Unipolar RZ', 'Polar NRZ', 'Polar RZ', 'AMI', 'Manchester Code'};
            app.DropDown.ValueChangedFcn = createCallbackFcn(app, @DropDownValueChanged, true);
            app.DropDown.Tag = 'LC';
            app.DropDown.Position = [25 249 166 22];
            app.DropDown.Value = 'Unipolar NRZ';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create Label
            app.Label = uilabel(app.RightPanel);
            app.Label.HorizontalAlignment = 'center';
            app.Label.Position = [49 53 321 22];
            app.Label.Text = '';

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.PlotBoxAspectRatio = [1.24846625766871 1 1];
            app.UIAxes.ButtonDownFcn = createCallbackFcn(app, @UIAxesButtonDown, true);
            app.UIAxes.Position = [23 102 374 316];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = commpartb_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end