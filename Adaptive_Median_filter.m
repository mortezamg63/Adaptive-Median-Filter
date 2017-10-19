function AdaptiveFilter(image,MaxSizeFilter)
%         AdaptiveFilter(image,MaxSizeFilter)
%                 remove noise by changing the size of filter
%                 image : tasvir noisy
%                 MaxSizeFilter : maximum size of filter 
%
%                   AdaptiveFilter start from 3*3 filter
%                   and if noise don't remove,greats size of filter
%                   until MaxSizeFilter and repeat removing noise
global imag;
global imageTemp;
[x,y]=size(image);
imag=double(image);
imag=MedianFilter(MaxSizeFilter);
 
Q=MaxSizeFilter-ceil(MaxSizeFilter/2);%cut image
imag=imag(Q:Q+x-1,Q:Q+y-1);
figure();
imshow(uint8(imag),[]);
end
function output=MedianFilter(MaxSizeFilter)% x: row number and y: col number
global imag;
global imageTemp;
    
[xb,yb]=size(imag);
 
imageTemp=zeros(xb,yb);
imag=Padding(MaxSizeFilter);
 
StartPoint=MaxSizeFilter-floor(MaxSizeFilter/2);%chon tasvir pad shode bayad noqte shoroe tasvire asli
                                                 % baraye mohasebat peyda
                                                 % shavad (be tedade size
                                                 % tasvire asli bayad
                                                 % mohasebat anjam bedim)
                                                %ke markaze panjere filter ast 
for i=StartPoint:StartPoint+(xb-1)
    for j=StartPoint:StartPoint+(yb-1)
               
        Computation(3,MaxSizeFilter,i,j);
               
    end
end
output=imageTemp;
end
 
 
function Computation(FilterSize,MaxFilterSize,i,j)
global imageTemp;
global imag;
 
            Zxy=0;
            
            justification=ceil((FilterSize-1)/2);
            AreaNeighberhood=imag(i-justification:i+justification,j-justification:j+justification);
            sortedArea=sort(AreaNeighberhood(:));
            % obtain variables for computation
            Zmin=sortedArea(1);
            Zmax=sortedArea(end);
            Zmed=median(sortedArea);
            Zxy=imag(i,j);
            
            B1=Zxy-Zmin;
            B2=Zxy-Zmax;
            if(B1>0 && B2<0)
                imageTemp(i,j)=Zxy;
                return;
            else
                A1=Zmed-Zmin;
                A2=Zmed-Zmax;
                if(A1>0 && A2<0)
                    imageTemp(i,j)=Zmed;
                    return;
                else
                    if(FilterSize<MaxFilterSize)
                        FilterSize=FilterSize+2;
                        Computation(FilterSize,MaxFilterSize,i,j);
                        return;
                    else
                        imageTemp(i,j)=Zmed;
                    end
                end
            end
end
 
function output=Padding(maxPadd)
global imag;
 
 counterPadding=floor((maxPadd-1)/2);
 while(counterPadding)
     imag=[imag(:,1) imag imag(:,end)]; % or imag=[imag(:,1,:) imag imag(:,end,:)];
     imag=[imag(1,:);imag;imag(end,:)]; % or imag=[imag(1,:,:);imag;imag(end,:,:)];
     counterPadding=counterPadding-1;
 end
 output=imag;
end
