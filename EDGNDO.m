
function [BestCost,BestValue]=EDGNDO(fhd,nPop,nVar,VarMin,VarMax,MaxIt,X)

%fhd--------objective function
%nPop-------population size
%nVar-------dimension of problem
%VarMin-----the lower limit of the variables
%VarMax-----the upper limit of the variables
%MaxIt------the maximum number of function evaluations
%BestCost---the record of the convergence curves
%BestValue--the optimal fitness value
%Best-------the optimal solution 

MaxIt=floor(MaxIt/(nPop));
for i=1:nPop
    pop(i).Position=X(i,:);
end
BestSol.Cost = inf;
for i=1:nPop
    pop(i).Cost = fhd(pop(i).Position);
    
    if pop(i).Cost < BestSol.Cost
        BestSol = pop(i);
    end
end
BestCost(1)=BestSol.Cost;
GOT(1)=BestSol;
POT(1)=BestSol;
NP=1;
NG=1;
for it=2:MaxIt
    MEAN=0;
    for i=1:nPop
        MEAN=MEAN+pop(i).Position;
    end
    MEAN=MEAN./nPop;
    BEST = pop(1);
    for i=2:nPop
        if pop(i).Cost < BEST.Cost
            BEST = pop(i);
        end
    end      
    for i=1:nPop
        a=randperm(nPop,1);
        b=randperm(nPop,1);
        c=randperm(nPop,1);
        while a==i | a==b | c==b | c==a |c==i |b==i
            a=randperm(nPop,1);
            b=randperm(nPop,1);
            c=randperm(nPop,1);
        end
        
        if pop(a).Cost<pop(i).Cost
            step=pop(a).Position-pop(i).Position;
        else
            step=pop(i).Position-pop(a).Position;
        end
        if pop(b).Cost<pop(c).Cost
            stepx=pop(b).Position-pop(c).Position;
        else
          stepx=pop(c).Position-pop(b).Position;
        end
     
        if rand<=rand
            a=randperm(length(POT),1);
            b=randperm(length(GOT),1);
            gi=rand;
            if gi<=1/3
                u=1/3*(pop(i).Position+BEST.Position+MEAN);
                deta=sqrt(1/3*((pop(i).Position-u).^2+(BEST.Position-u).^2+(MEAN-u).^2));
            elseif gi>=2/3
                u=1/3*(pop(i).Position+POT(a).Position+MEAN);
                deta=sqrt(1/3*((pop(i).Position-u).^2+(POT(a).Position-u).^2+(MEAN-u).^2));
            else
                u=1/3*(pop(i).Position+GOT(b).Position+MEAN);
                deta=sqrt(1/3*((pop(i).Position-u).^2+(GOT(b).Position-u).^2+(MEAN-u).^2));
            end
            vc1=rand(1,nVar);
            vc2=rand(1,nVar);
            Z1=sqrt(-1*log(vc2)).*cos(2*pi.*vc1);
            Z2=sqrt(-1*log(vc2)).*cos((2*pi.*vc1)+pi);
            if rand<=rand
                newsol.Position = (u+deta.*Z1);
            else
                newsol.Position = (u+deta.*Z2);
            end
        else
            fi=rand;
            gi=1-fi;
            ki=rand;
            a=randperm(length(POT),1);
            b=randperm(length(GOT),1);
            if ki<=1/3
                newsol.Position = pop(i).Position +fi*abs(randn).*step+gi*abs(randn).*stepx;%+rand(1,nVar).*(pop(a).Position-pop(b).Position);
            elseif ki>=2/3
                if POT(a).Cost< pop(i).Cost
                    newsol.Position = pop(i).Position +fi*abs(randn).*(POT(a).Position-pop(i).Position)+gi*abs(randn).*stepx;
                else
                    newsol.Position = pop(i).Position -fi*abs(randn).*(POT(a).Position-pop(i).Position)+gi*abs(randn).*stepx;
                end
            else
                if GOT(b).Cost<pop(i).Cost
                    newsol.Position = pop(i).Position +fi*abs(randn).*(GOT(b).Position-pop(i).Position)+gi*abs(randn).*stepx;
                else
                    newsol.Position = pop(i).Position -fi*abs(randn).*(GOT(b).Position-pop(i).Position)+gi*abs(randn).*stepx;
                end
            end
        end
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        newsol.Cost = fhd(newsol.Position);
        if newsol.Cost<pop(i).Cost
            pop(i) = newsol;
            NP=NP+1;
            if NP<=nPop
                POT(NP)= newsol;
            else
                a=randperm(nPop,1);
                b=randperm(nPop,1);
                while a==b
                    a=randperm(nPop,1);
                    b=randperm(nPop,1);
                end
                if POT(a).Cost<=POT(b).Cost
                    a=b;
                end
                flag=cleardup(POT,newsol);
                if flag==1
                   POT(a)= newsol; 
                end
            end
            if pop(i).Cost < BestSol.Cost
                BestSol = pop(i);
            end
        end
    end
    NG=NG+1;
    if NG<=nPop
        GOT(NG)= BestSol;
    else
        a=randperm(nPop,1);
        b=randperm(nPop,1);
        while a==b
            a=randperm(nPop,1);
            b=randperm(nPop,1);
        end
        if GOT(a).Cost<=GOT(b).Cost
            a=b;
        end
        flag=cleardup(GOT,BestSol);
        if flag==1
            GOT(a)=BestSol;
        end
    end
    
    BestCost(it)=BestSol.Cost;
 %  disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestSol.Cost,15)]);  
end
BestValue=BestSol.Cost;
Best=BEST.Position;

end
function flag=cleardup(POT,X)
n=length(POT);
flag=1;
for i=1:n
    if POT(i).Position==X.Position
        flag=0;
    end
end

end


