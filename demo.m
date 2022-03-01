clc
clear all
nVar=10;% Dimension of varibales
nPop=50;% Population size
MaxIt=100000;% The maximum number of function evaluations 
LoopMaxIt=30;% The number of runs
VarMax=100.*ones(1,nVar);% The upper limit of varibales
VarMin=-VarMax;% The lower limit of varibales
X=(VarMax-VarMin).*rand(nPop,nVar,1) + VarMin;% Population initialization
fhd=@sphere;% Objective function
BestCost=zeros(LoopMaxIt,MaxIt/nPop);% Save the historical convergence curves
BestValue=inf(1,LoopMaxIt);% Save the historical best solutions
 disp(['EDGNDO is executing optimization task!']);
for i=1:LoopMaxIt
    [BestCost(i,:),BestValue(i)] =EDGNDO(fhd,nPop,nVar,VarMin,VarMax,MaxIt,X);
    disp(['The numerber of iterations is ' num2str(i) ': the current solution = ' num2str((BestValue(i))),',the current best solution = ' num2str(min(BestValue))]);
end
plot(1:MaxIt/nPop*2,mean(BestCost),'r')
xlabel('The number of function evaluations','Fontname','Times New Roma','fontsize',18);
ylabel('The fitness value','Fontname','Times New Roman','fontsize',18);
set(gca,'Fontname','Times New Roman','Fontsize',15)
      

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
