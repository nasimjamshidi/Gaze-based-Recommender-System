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

     for i = 2: 2: size(Time,1) -1


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



    %imaaaaaaaaaaaaaaaaaaaaaaaaaaage creation

    for kk = 2:7
    I = imread(['Images/' num2str(kk) '.png']);
    a = squeeze(Cluster(kk,:,:)); 
    PageFixations(kk)=size(a(a(:,2)>0),1);

    for  i = 1:size(a,1)

        a(i,1) = round(a(i,1));
        a(i,2) = round(a(i,2));


    end
    avg(1)= a(1,1);
    avg(2)= a(1,2);

    counter = 0;

    Xthre= 45;
    Ythre= 25;
    Fixation = 10;
    Number = 0;
    Img = zeros(1080,1920,3);
    Fixed= [0,0];
    for  i = 2:PageFixations(kk)


        if ((a(i,1)>(avg(1) - Xthre)) && (a(i,1)<(avg(1) + Xthre)) && (a(i,2)>(avg(2) - Ythre)) &&(a(i,2)<(avg(2) + Ythre))) || counter == 0 

            if counter == 0

                avg(1) = a(i,1);
                avg(2) = a(i,2);
                
                counter = counter + 1;
                
                stack(counter,1) =  a(i,1);
                stack(counter,2) =  a(i,2);
                
            else 
                avg(1) = (counter*avg(1) + a(i,1))/(counter+1);
                avg(2) = (counter*avg(2) + a(i,2))/(counter+1);
                counter = counter + 1;
            end 


        else 
            if counter > Fixation
                Number = Number + 1;
                I = insertShape(I,'circle',[round(avg(1)) round(avg(2)) 1.5*counter],'LineWidth',5);
                position = [round(avg(1))-15 round(avg(2))-15];
                 I = insertText(I,position,num2str(Number),'Font','LucidaBrightRegular','BoxColor','w','FontSize',22);
                 Img(round(avg(2)),round(avg(1)),:) = 255;
                Fixed= cat(1,Fixed,stack);

                counter = 0;

            else 
                counter = 0;
            end
        end
    end
      RGB = insertShape(I,'circle',[round(avg(1)) round(avg(2)) counter/10],'LineWidth',5);
     imwrite(RGB,[int2str(T) '_' int2str(kk) '.png']);

    for i = 2:size(Fixed,1)

        Img(round(Fixed(i,2)),round(Fixed(i,1)),:) = 255;

    end

     Img = run_antonioGaussian(Img, 20);
   
%      imshow(Img,cmap);    


%       imagesc(Img(:,:,1))
%     colormap jet
%     axis equal off
%     set(gca,'position',[0 0 1 1],'units','normalized');
%     title('Heatmap of PPSNR values over all frames');
%     saveas(gca, [int2str(T) '_' int2str(kk) '.bmp'], 'bmp')   





%colormap('parula');
%      imsave
     clear a;
    clear Fixed;
    
    end
 end