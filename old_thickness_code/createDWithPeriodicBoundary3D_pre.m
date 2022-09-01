function [D] = createDWithPeriodicBoundary3D_pre(N1,N2,N3,pixdim1,pixdim2,pixdim3,mask_ind,D1name,D2name,D3name)
% [D,Dp] = createD(N1,N2)
%
% Generates the sparse two-dimensional finite difference (first-order neighborhoods) matrix D
% for an image of dimensions N1xN2 (rows x columns).  The optional output
% argument Dp is the transpose of D.  Also works for vector images if one
% of N1 or N2 is 1.
% Justin Haldar 11/02/2006
if ~exist('pixdim3','var')
    pixdim1=1;pixdim2=1;pixdim3=1;
end

if (not(isreal(N1)&&(N1>0)&&not(N1-floor(N1))&&isreal(N2)&&(N2>0)&&not(N2-floor(N2))))
    error('Inputs must be real positive integers');
end
if ((N1==1)&&(N2==1)&&(N3==1))
    error('Finite difference matrix can''t be generated for a single-pixel image');
end

D1 = [];
D2 = [];
D3 = [];

if (N1 > 1)&&(N2>1)&&(N3>1)
    
    e = ones(N1,1);
    if (numel(e)>2)
        if ~exist(D1name,'file')
            T = spdiags([e,-e],[0,1],N1,N1);
            T(N1,1)=-1;
            E = speye(N2);
            E2 = speye(N3);
            D1 = kron(E2,kron(E,T));
            save(D1name,'D1','-v7.3');
        else
            load(D1name);
        end
        if exist('mask_ind','var')
            D1=D1(mask_ind,mask_ind);
        end
        D = [(1./pixdim1)*D1];clear D1;
    end
    
    e = ones(N2,1);
    if (numel(e)>2)
        if ~exist(D2name,'file')
            T = spdiags([e,-e],[0,1],N2,N2);
            T(N2,1)=-1;
            E = speye(N1);
            E2 = speye(N3);
            D2 =  kron(E2,kron(T,E));
            save(D2name,'D2','-v7.3');
        else
            load(D2name);
        end
        if exist('mask_ind','var')
            D2=D2(mask_ind,mask_ind);
        end
        D=[D;(1./pixdim2)*D2];clear D2;
    end
    
    e = ones(N3,1);
    if (numel(e)>2)
        if ~exist(D3name,'file')
            T = spdiags([e,-e],[0,1],N3,N3);
            T(N3,1)=-1;
            E = speye(N1);
            E2 = speye(N2);
            D3 =  kron(T,kron(E2,E));
            save(D3name,'D3','-v7.3');
        else
            load(D3name);
        end
        if exist('mask_ind','var')
            D3=D3(mask_ind,mask_ind);
        end
        D=[D;(1./pixdim3)*D3];clear D3;
    end
else % Image is a vector of length max(N1,N2)
    error('singleton dimensions not supported');
end

