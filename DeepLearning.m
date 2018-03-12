clear;
WorkingDir = [pwd '\EyeData'];
WorkingDir1 = [pwd '\Times'];

TXTNames = dir(fullfile(WorkingDir,'*.xls'));
TXTNames = {TXTNames.name}';

TXTNames1 = dir(fullfile(WorkingDir1,'*.xlsx'));
TXTNames1 = {TXTNames1.name}';

 for T = 1: size(TXTNames,1)


    [Time, a, b] = xlsread([WorkingDir1 '\' TXTNames1{T}]);
    [Num, c, d] = xlsread([WorkingDir '\' TXTNames{T}]);

    %Time in milisecond

    for i = 1: size(Time,1)

        Time(i,5) = Time(i,1)*60000 + Time(i,2)*1000 + Time(i,3);      

    end
     for i = 1: size(Num,1)

        Num(i,7) =Num(i,4)*3600000  + Num(i,5)*60000 + Num(i,6)*1000; 
    %     

     end

     for i = 2: size(Num,1)

          Num(i,7) = Num(i,7) - Num(1,7);

     end
     Num(1,7)= 0;

     count(1:8) = 1;

     for i = 2: 2: size(Time,1)


         while (Num(count(1),7)< Time(i,5))
            count(1) = count(1) + 1;

         end
         count(2)=1;

         for jj = 2:7
             if Time(i,4) == jj 
                 while (Num(count(1),7)< Time(i+1,5))

                    Cluster(jj,count(jj),:)= Num(count(1),1:2);
                    count(jj) = count(jj) + 1; 
                    count(1) = count(1) + 1;
                 end



             end
         end




     end
     
    
    
 
    
    for ii = 2: size(Cluster,2)
        for jj=2:7

                            if Cluster(jj,ii,1)<=1100 && Cluster(jj,ii,2)<=400

                                Deep(ii-1,jj-1,T) =1;

                            elseif Cluster(jj,ii,1)<=1100 && Cluster(jj,ii,2)<=600

                                   Deep(ii-1,jj-1,T)  =2;

                             elseif Cluster(jj,ii,1)>=1100 && Cluster(jj,ii,2)<=400

                                 Deep(ii-1,jj-1,T)  =3;

                             elseif Cluster(jj,ii,1)>=1100 && Cluster(jj,ii,2)<=600

                                Deep(ii-1,jj-1,T)  =4;
                             elseif Cluster(jj,ii,1)>=1100 && Cluster(jj,ii,2)>=600

                                 Deep(ii-1,jj-1,T)  =5;
                                 
                            else     
                                Deep(ii-1,jj-1,T)  =6;
                            end


        end
    end

 end
 
 
Deep(Deep==0)=nan


 for k = 1: 21
       Cell{k,1}= Deep(:,:,k)';
 end
 Y = [1
1
2
3
1
3
1
2
3
1
2
2
3
1
3
1
2
3
1
2
3
];
 Y = categorical(Y);
 for k = 1: 21
       Cell1{k,1}= Deep(1:1000,:,k)';
 end
 
 %making a net 
 
	 inputSize=6;
	outputSize=100
	outputMode='last'
	numClasses=3
	layers=[sequenceInputLayer(inputSize) lstmLayer(outputSize,'OutputMode',outputMode) fullyConnectedLayer(numClasses) softmaxLayer classificationLayer]
	maxEpochs=150;
	miniBatchSize = 100
	options=trainingOptions('sgdm','MaxEpochs',maxEpochs,'MiniBatchSize',miniBatchSize);
	net = trainNetwork(Cell,Y,layers,options)
	
	