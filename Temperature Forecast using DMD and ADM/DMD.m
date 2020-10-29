classdef DMD
    properties
       b;
       phi;
       omega;
       lambda;
       trainData;
       trainTime;
    end
    
    methods
        
        function obj = DMD(trainData,trainTime)
            obj.trainData = trainData;
            obj.trainTime = trainTime;
        end
        
        function obj = train(obj,r)
            %% Initialize
            t = obj.trainTime;
            f = obj.trainData;
            dt = t(2)-t(1);
            X1 = f(:,1:end-1);
            X2 = f(:,2:end);
            %% SVD
            [u,s,v]=svd(X1,'econ');
            
            %% Truncating SVD            
            ur = u(:,1:r);
            sr = s(1:r,1:r);
            vr = v(:,1:r);
            
            %% Build Atilde and DMD modes
            Atilde = ur'*X2*vr/sr;
            [w,d] = eig(Atilde);
            obj.phi = X2*vr/sr*w; % DMD modes
            %% DMD Spectra
            obj.lambda = diag(d);
            obj.omega = log(obj.lambda)/dt; 
            x1 =f(:,1);
            obj.b = obj.phi\x1;

        end
        
        function xdmd = predict(obj,time)
            r=size(obj.phi,2);
            time_dynamics = zeros(r,length(time));
            for iter = 1:length(time)
                time_dynamics(:,iter) = (obj.b .* exp(obj.omega*time(iter)));
            end
            xdmd = obj.phi * time_dynamics;
        end
        
        function plots(obj)
            X1 = obj.trainData(:,1:end-1);
            [~,s,~]=svd(X1,'econ');
            %% SVD Plot
            figure()
            subplot(1,2,1)
            hold on
            grid on
            semilogy(diag(s),'k','LineWidth',2)
            semilogy(diag(s),'ro')
            title('Singular Value plot in log axis')
            subplot(1,2,2)
            hold on
            grid on
            plot(0:length(diag(s)),[0; cumsum(diag(s))/sum(diag(s))],'k','LineWidth',2)
            plot(1:length(diag(s)),[cumsum(diag(s))/sum(diag(s))],'ro')
            title('Cumulative Sum of Singular values')
            %% DMD Spectrum Plot
            figure()
            hold on
            grid on
            plotCircle(0,0,1)
            scatter(real(obj.lambda),imag(obj.lambda),150,'rx','LineWidth',1.5)
            xlabel('Real Values','FontSize',14)
            ylabel('Imaginery Values','FontSize',14)
            title('DMD Spectrum Plot')
            hold off
            
        end
    end
    
end