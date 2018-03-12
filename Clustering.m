clear;


[Time, a, b] = xlsread('new excel.xlsx');
[Num, c, d] = xlsread('simple test 1.txt.csv.xls');
I = imread(['Images/' 'nasim ppt 2.png']);


for i = 1: size(Time,1)
    
    Time(i,5) = Time(i,1)*60000 + Time(i,2)*1000 + Time(i,3);      

end
 for i = 1: size(Num,1)
     
    Num(i,7) =  + Num(i,5)*60000 + Num(i,6)*1000; 
%     

 end
 
 for i = 2: size(Num,1)
 
      Num(i,7) = Num(i,7) - Num(1,7);
     
 end
 Num(1,7)= 0;
 
 count = 1;
 count2=1;
 count3=1;
 count4=1;
 count5=1;
 count6=1;
 count7=1;
 for i = 2: 2: size(Time,1)
 
     
     while (Num(count,7)< Time(i,5))
        count = count + 1;
         
     end
     count2=1;
    
     if Time(i,4) == 2
         while (Num(count,7)< Time(i+1,5))

            Cluster2(count2,:)= Num(count,1:2);
            count2 = count2 + 1; 
            count = count + 1;
         end
     
     end
     
       if Time(i,4) == 3
         while (Num(count,7)< Time(i+1,5))

            Cluster3(count3,:)= Num(count,1:2);
            count3 = count3 + 1; 
            count = count + 1;
         end
     
       end
     
         if Time(i,4) == 4
         while (Num(count,7)< Time(i+1,5))

            Cluster4(count4,:)= Num(count,1:2);
            count4 = count4 + 1; 
            count = count + 1;
         end
     
         end
     
         
           if Time(i,4) == 5
         while (Num(count,7)< Time(i+1,5))

            Cluster5(count5,:)= Num(count,1:2);
            count5 = count5 + 1; 
            count = count + 1;
         end
     
           end
     
             if Time(i,4) == 6
         while (Num(count,7)< Time(i+1,5))

            Cluster6(count6,:)= Num(count,1:2);
            count6 = count6 + 1; 
            count = count + 1;
         end
     
             end
     
             
               if Time(i,4) == 7
         while (Num(count,7)< Time(i+1,5))

            Cluster7(count7,:)= Num(count,1:2);
            count7 = count7 + 1; 
            count = count + 1;
         end
     
               end
     
     
     
 end
 
%     Num(i,4) = Num(i,4) - Num (1,4);
%     Num(i,5) = Num(i,5) - Num (1,5);
%     Num(i,6) = Num(i,6) - Num (1,6);
%     
% end
% Num(1,4:6)=0;

%imaaaaaaaaaaaaaaaaaaaaaaaaaaage


for  i = 1:size(a,1)
    a = Cluster2; 
    a(i,1) = round(a(i,1));
    a(i,2) = round(a(i,2));

    
end
avg(1)= a(1,1);
avg(2)= a(1,2);

count = 0;

Xthre= 45;
Ythre= 25;
Fixation = 10;
Number = 0;
Img = zeros(1080,1920,3);
Fixed= [0,0];
for  i = 2:size(a,1)
    
    if ((a(i,1)>(avg(1) - Xthre)) && (a(i,1)<(avg(1) + Xthre)) && (a(i,2)>(avg(2) - Ythre)) &&(a(i,2)<(avg(2) + Ythre))) || count == 0 
        
        if count == 0
            
            avg(1) = a(i,1);
              
%             Img(round(a(i,2)),round(a(i,1)),:) = 255;
            avg(2) = a(i,2);
            count = count + 1;
            stack(count,1) =  a(i,1);
            stack(count,2) =  a(i,2);
        else 
            avg(1) = (count*avg(1) + a(i,1))/(count+1);
            avg(2) = (count*avg(2) + a(i,2))/(count+1);
            count = count + 1;
        end 
        
            
    else 
        if count > Fixation
            Number = Number + 1;
            I = insertShape(I,'circle',[round(avg(1)) round(avg(2)) 1.5*count],'LineWidth',5);
            position = [round(avg(1))-15 round(avg(2))-15];
            I = insertText(I,position,num2str(Number),'Font','LucidaBrightRegular','BoxColor','w','FontSize',22);
             Img(round(avg(2)),round(avg(1)),:) = 255;
            Fixed= cat(1,Fixed,stack);
            
            count = 0;
            
        else 
            count = 0;
        end
    end
end
  RGB = insertShape(I,'circle',[round(avg(1)) round(avg(2)) count/10],'LineWidth',5);
imshow(RGB)

for i = 2:size(Fixed,1)
   
    Img(round(Fixed(i,2)),round(Fixed(i,1)),:) = 255;
    
end

 Img = run_antonioGaussian(Img, 25);
 
 
 
%  imshow(I); 
 imshow(Img(:,:,1)); colormap('jet'); freezeColors;

 