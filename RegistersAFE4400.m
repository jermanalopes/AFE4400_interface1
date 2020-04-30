classdef RegistersAFE4400 < handle
    %REGISTERSAFE4400 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = private)
        % Defines for Registers
        CONTROL0       = '00';

        % timing registers
        LED2STC        = '01';
        LED2ENDC       = '02';
        LED2LEDSTC     = '03';
        LED2LEDENDC    = '04';
        ALED2STC       = '05';
        ALED2ENDC      = '06';
        LED1STC        = '07';
        LED1ENDC       = '08';
        LED1LEDSTC     = '09';
        LED1LEDENDC    = '0A';
        ALED1STC       = '0B';
        ALED1ENDC      = '0C';
        LED2CONVST     = '0D';
        LED2CONVEND    = '0E';
        ALED2CONVST    = '0F';
        ALED2CONVEND   = '10';
        LED1CONVST     = '11';
        LED1CONVEND    = '12';
        ALED1CONVST    = '13';
        ALED1CONVEND   = '14';
        ADCRSTSTCT0    = '15';
        ADCRSTENDCT0   = '16';
        ADCRSTSTCT1    = '17';
        ADCRSTENDCT1   = '18';
        ADCRSTSTCT2    = '19';
        ADCRSTENDCT2   = '1A';
        ADCRSTSTCT3    = '1B';
        ADCRSTENDCT3   = '1C';
        PRPCOUNT       = '1D';

        CONTROL1       = '1E';
        SPARE1         = '1F';
        TIAGAIN        = '20';
        TIA_AMB_GAIN   = '21';
        LEDCNTRL       = '22';
        CONTROL2       = '23';
        SPARE2         = '24';
        SPARE3         = '25';
        SPARE4         = '26';
        RESERVED1      = '27';
        RESERVED2      = '28';
        ALARM          = '29';
        LED2VAL        = '2A';
        ALED2VAL       = '2B';
        LED1VAL        = '2C';
        ALED1VAL       = '2D';
        LED2_ALED2VAL  = '2E';
        LED1_ALED1VAL  = '2F';
        DIAG           = '30';
    end
    
    methods
        function [regEnd] = getAddressRegister(obj, regName)
            regEnd = eval( strcat('obj.', regName) );
        end
    end
    
end

