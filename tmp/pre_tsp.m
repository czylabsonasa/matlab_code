function Ebest=pre_tsp(inst)
   tdata=json2tsp(inst);

   N=tdata.N;
   dist=tdata.dist;
   pX=tdata.pX;
   pY=tdata.pY;
   opt=tdata.opt;
   comment=tdata.comment;


   norm_fact=1000*max(dist(:));
   dist=dist/norm_fact;

   maxit=10000;
   NL=16;
   T=10^5;
   nmove=32;

   coolit=@(t,s) 0.99*t;
   %coolit=@(t,i) 1/(i+1)^1.3;


   %init
   rng(2222);
   x=randperm(N);
   Ex=E(x);
   Ebest=Ex;
   xbest=x;

   function tsp(x,Ex,run_name)
      it=1;
      while T>0 && it<maxit
         tEbest=Ebest;
         for n=1:NL
            [x1,Ex1]=move_n(x,nmove);
            if Ex1<Ex
               x=x1;
               Ex=Ex1;
               if Ex<tEbest
                  tEbest=Ex;
                  xbest=x;
               end
            else
               if rand()<exp(-(Ex1-Ex)/T)
                  x=x1;
                  Ex=Ex1;
               end
            end
         end % 1:NL
         if tEbest<Ebest
            Ebest=tEbest;
            xbest=x;
            rajz(it,run_name);
         end
   
         T=coolit(T,it);
         it=it+1;
      end
   end
   
   tsp(x,Ex,"első");
   
   Ebest
   % x=xbest;
   % Ex=Ebest;
   % T=10^3;
   % NL=2*32;
   % nmove=2*32;
   % tsp(x,Ex,"második");
   

   Ebest=norm_fact*Ebest;

   function X=move(X)
      I=randi(N,1,2);
      X(I) = X([I(2), I(1)]);
   end

   function [Xb,EXb]=move_n(X,n)
      Xb=zeros(size(X));
      EXb=Inf;
      for k=1:n
         Xt=move(X);
         EXt=E(Xt);
         if EXt<EXb
            Xb=Xt;
            EXb=EXt;
         end
      end
   end


   function Y=E(X)
      Y=0;
      for i=1:N-1
         Y=Y+dist(X(i),X(i+1));
      end
      Y=Y+dist(X(N),X(1));
   end

   function rajz(it,run_name)
      X=[pX(xbest);pX(xbest(1))];
      Y=[pY(xbest);pY(xbest(1))];
      plot(X,Y);
      tmp=norm_fact*Ebest;
      title(sprintf("%s\n%s\ngoodness: %.2f Ebest: %f\n it: %d T: %.4f",run_name,comment,tmp/opt,tmp,it,T));
      drawnow;
   end

end