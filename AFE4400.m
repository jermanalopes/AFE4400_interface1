classdef AFE4400 < handle
    
    properties 
        serialPort;
        registers;
        nSamples;
        led1;
        led2;
        aled1;
        aled2;
        led1_aled1;
        led2_aled2;
    end
    
    methods
        function obj = AFE4400(comPort)
            obj.serialPort = serial(comPort);
            obj.serialPort.BaudRate = 230400;
            %obj.serialPort.TimeOut = 1000;
            obj.serialPort.InputBufferSize = 512;
            
            obj.registers = RegistersAFE4400();
        end
        
        function init(obj)
            fopen(obj.serialPort);
            
            % get device information
            fwrite(obj.serialPort, hex2dec({'04', '0D'}));
            device = fread(obj.serialPort);
            disp( sprintf('Device Information: AFE%s\n', device(3:6, 1)') );
            
            % get firmware information
            fwrite(obj.serialPort, hex2dec({'07','0D'}));
            firmwareVersion = fread(obj.serialPort);
            disp( sprintf('Firmware Version: %d.%d\n', firmwareVersion(3, 1), firmwareVersion(4, 1)) );
            
            %SET EVM DEFAULT
            fwrite(obj.serialPort, hex2dec({'02','30','30','30','30','30','30','30','38','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','30','30','30','30','30','30','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','30','30','30','30','30','30','38','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','30','30','30','30','30','30','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','31','30','30','31','37','43','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','32','30','30','31','46','33','45','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','33','30','30','31','37','37','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','34','30','30','31','46','33','46','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','35','30','30','30','30','35','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','36','30','30','30','37','43','45','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','37','30','30','30','38','32','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','38','30','30','30','46','39','45','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','39','30','30','30','37','44','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','41','30','30','30','46','39','46','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','42','30','30','30','46','46','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','43','30','30','31','37','36','45','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','44','30','30','30','30','30','36','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','45','30','30','30','37','43','46','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','30','46','30','30','30','37','44','36','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','30','30','30','30','46','39','46','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','31','30','30','30','46','41','36','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','32','30','30','31','37','36','46','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','33','30','30','31','37','37','36','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','34','30','30','31','46','33','46','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','36','30','30','30','30','30','35','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','37','30','30','30','37','44','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','38','30','30','30','37','44','35','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','39','30','30','30','46','41','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','41','30','30','30','46','41','35','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','42','30','30','31','37','37','30','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','43','30','30','31','37','37','35','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','44','30','30','31','46','33','46','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','31','45','30','30','30','31','30','31','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','32','32','30','31','31','34','31','34','0D'}));
            fwrite(obj.serialPort, hex2dec({'02','32','33','30','32','30','31','30','30','0D'}));

        end
        
%         function [regVal] = readRegister(obj, regName)
%             regEnd = obj.registers.getAddressRegister(regName);
%             word = eval(sprintf('hex2dec({''03'',''%x'',''%x'',''0D''})', regEnd));
%             fwrite(obj.serialPort, word);
%             regVal = fread(obj.serialPort);
%             regVal = sprintf('''%02x'',', regVal);
%             regVal(end)=[];
%             regVal = eval(strcat('{', regVal ,'}'));
%             regVal = [regVal{5} regVal{4} regVal{3}];
%         end
%         
%         function writeRegister(obj, regName, regVal)
%             % regVal é uma string de 6 caracteres ASCII
%             regEnd = obj.registers.getAddressRegister(regName);
%             word   = eval(sprintf('hex2dec({''02'', ''%x'', ''%x'',''%x'',''%x'',''%x'',''%x'',''%x'',''%x'',''0D''})', regEnd, regVal));
%             fwrite(obj.serialPort, word);
%         end
        
        function close(obj)
            fclose(obj.serialPort);
        end
        
        function [frequencia] = calculateCardFrequency(obj)
            PRF = 500;
            x = [0:1/PRF:(1/PRF) * obj.nSamples];
            x(1) = []; %retira o zero

            %[thr,sorh,keepapp] = ddencmp('den','wv',obj.led1_aled1); % Den = Decomposição do Sinal; WV = Transf. Wavelet
            %y = wdencmp('gbl',obj.led1_aled1,'db5',5,thr,sorh,keepapp); % retira ruído
            %[amp_pico,pos_pico] = findpeaks(y,'MINPEAKHEIGHT',0.043,'MinPeakDistance', 250);
            [amp_pico,pos_pico] = findpeaks(obj.led1,'MinPeakDistance', 250);

%             figure; hold on; 
%             plot(x, y);
%             plot(x(pos_pico),amp_pico,'k^','markerfacecolor',[1 0 0]);

            timePeaks = x(pos_pico);
            
            timePeaks_1 = [0 timePeaks];
            timePeaks_2 = [ timePeaks 0];
            timePeaks = timePeaks_2 - timePeaks_1;
            timePeaks(1) = [];
            timePeaks(size(timePeaks, 2)) = [];
            timePeaks = timePeaks/60;
            frequencia = 60/mean(timePeaks);
        end
        
        function readAdcData(obj, nSamples, plotData, handles)
            
            flushinput(obj.serialPort); %limpa o buffer
            
            % rejeita as 1000 primeiras amostras
            rejectedSamples = 1000;
            
            % set spi_read
            fwrite(obj.serialPort, hex2dec({'02','30','30','30','30','30','30','30','31','0D'}));
            
            % read samples
            word = sprintf('hex2dec({''01'',''2A'',''%02x'', ''%02x'', ''%02x'', ''%02x'', ''%02x'', ''%02x'', ''%02x'', ''%02x'', ''0D''})', sprintf('%08x', (nSamples + rejectedSamples)));
            fwrite(obj.serialPort, eval(word));
            
            for(i = 1 : rejectedSamples)
                dt = fread(obj.serialPort, 22);
            end
            
            obj.nSamples = nSamples;
            obj.led1 = [];
            obj.led2 = [];
            obj.aled1 = [];
            obj.aled2 = [];
            obj.led1_aled1 = [];
            obj.led2_aled2 = [];
            for(i = 1 : nSamples)
                dt = fread(obj.serialPort, 22);
                package = sprintf('''%02x'',', dt);
                package(end)=[];
                package = eval(strcat('{', package ,'}'));
                obj.led2(i) = hex2dec(strcat(package{5}, package{4}, package{3})) * 5.722676248*(10^(-7));
                obj.aled2(i) = hex2dec(strcat(package{8}, package{7}, package{6})) * 5.722676248*(10^(-7));
                obj.led1(i) = hex2dec(strcat(package{11}, package{10}, package{9})) * 5.722676248*(10^(-7));
                obj.aled1(i) = hex2dec(strcat(package{14}, package{13}, package{12})) * 5.722676248*(10^(-7));
                obj.led2_aled2(i) = hex2dec(strcat(package{17}, package{16}, package{15})) * 5.722676248*(10^(-7));
                obj.led1_aled1(i) = hex2dec(strcat(package{20}, package{19}, package{18})) * 5.722676248*(10^(-7));
            
                if(mod(i, 700) == 0 & i > 0)
                    PRF = 500;
                    %tempo em s da relação da quantidade de amostras -
                    %plotar com os Leds.
                    x = [0:1/PRF:(1/PRF) * size(obj.led1, 2)]; 
                    x(1) = []; %retira o zero

                    %[thr,sorh,keepapp] = ddencmp('den','wv',obj.led1_aled1); % Den = Decomposição do Sinal; WV = Transf. Wavelet
                    %y = wdencmp('gbl',obj.led1_aled1,'db5',5,thr,sorh,keepapp); % retira ruído
                    %[amp_pico,pos_pico] = findpeaks(y,'MINPEAKHEIGHT',0.043,'MinPeakDistance', 250);
                    [amp_pico,pos_pico] = findpeaks(obj.led1,'MinPeakDistance', 250);

                    timePeaks = x(pos_pico);
                    timePeaks_1 = [0 timePeaks];
                    timePeaks_2 = [ timePeaks 0];
                    timePeaks = timePeaks_2 - timePeaks_1;
                    timePeaks(1) = [];
                    timePeaks(size(timePeaks, 2)) = [];
                    
                    frequencia = 60/mean(timePeaks);
                    %mostra frequencia parciais no axes
                    set(handles.vfc_inst, 'String', sprintf('%.1f', frequencia));
                    plot(handles.axes1, obj.led1(1, [length(obj.led1) - 300 : length(obj.led1)]))
                    xlim([0 300]);
                    pause(1/2);
                end
            end
            
            flushinput(obj.serialPort); %limpa o buffer
            fwrite(obj.serialPort, hex2dec({'06','0D'}));
            
            if(plotData)
                %plot led Data;
                PRF = 500;
                x = [0:1/PRF:(1/PRF) * nSamples];
                x(1) = []; %retira o zero
                
                figure; 
                plot(x, led1);
                title('Led1')
                xlabel('Tempo(s)')
                ylabel('Volts')

                figure; 
                plot(x, led2);
                title('Led2')
                xlabel('Tempo(s)')
                ylabel('Volts')

                figure;
                plot(x, aled1);
                title('Ambient Led1')
                xlabel('Tempo(s)')
                ylabel('Volts')

                figure; 
                plot(x, aled2);
                title('Ambient Led2')
                xlabel('Tempo(s)')
                ylabel('Volts')

                figure; 
                plot(x, led1_aled1);
                title('Led1 - Ambient Led1')
                xlabel('Tempo(s)')
                ylabel('Volts')

                figure;
                plot(x, led2_aled2);
                title('Led2 - Ambient Led2')
                xlabel('Tempo(s)')
                ylabel('Volts')
          end
         end
     end
    
end
