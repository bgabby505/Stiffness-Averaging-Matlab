clear;clc;close all;
%Gabriella Brown

%% HW 2:Implementing stiffness averaging method
% EML 4327 

% Define elastic constants
E_onx=1.4e9; G_onx=518.5e6; v_onx=0.35;
E_car=60e9; G_car= 6.8e9; v_car=0.33;
p_solid=0.10; p_infill=0.50; p_car=0.3;

% Specimen dimensions[mm]
l=150; w=20; h=5;
h_layer=0.20; d_car=0.5;
N_solid=9*2;N_infill=7;N_total=N_infill+(N_solid);disp(N_total);
% Find area fractions[layersxthicknessxwidth]
A_total=N_total*h_layer*w;disp(A_total);
A_infill = w*h_layer*N_infill;disp(A_infill);
A_car =12*((pi*(d_car^2)/4));disp(A_car);
A_solid = (w*h_layer*N_solid)-A_car;disp(A_solid);

% Calculate Volume Fractions
V_infill=A_infill/A_total;
V_solid=A_solid/A_total;
V_car=A_car/A_total;

%Calculate void
[S_solid,  K_solid]  = sect_matrices(E_onx, G_onx, v_onx, p_solid);
[S_infill, K_infill] = sect_matrices(E_onx, G_onx, v_onx, p_infill);
[S_car,    K_car]     = sect_matrices(E_car, G_car, v_car, p_car);

%calculate kave:𝑉𝑖𝑛𝑓𝑖𝑙𝑙 𝐾𝑖𝑛𝑓𝑖𝑙𝑙 + 𝑉𝑠𝑜𝑙𝑖𝑑 𝐾𝑠𝑜𝑙𝑖𝑑 + 𝑉𝐶𝐹 𝐾𝐶𝐹
K_average = V_infill*K_infill + V_solid*K_solid + V_car*K_car;
S_average = inv(K_average);

%calculate elastic modulus
%ex=1/save11.ey=1/s22,ez=1/s33ave
E_x = 1/S_average(1,1);
E_y = 1/S_average(2,2);
E_z = 1/S_average(3,3);

% Verify averaged stiffness and compliance matrices
disp('Average compliance matrix S_average:');
disp(S_average);
disp('Average stiffness matrix K_average:');
disp(K_average);
disp('Infill Section matrices:');
disp('Compliance matrix S_infill:');
disp(S_infill);
disp('Stiffness matrix K_infill:');
disp(K_infill);
disp('Solid Section matrices: ');
disp('Stiffness matrix K_solid:');
disp(K_solid);
disp(S_solid);
disp('Compliance matrix S_car:');
disp(S_car);
disp('Stiffness matrix K_car:');
disp(K_car);

%Elastic moduli in x,y,z directions
fprintf('Elastic moduli: Ex = %.3e Pa, Ey = %.3e Pa, Ez = %.3e Pa\n', E_x, E_y, E_z);

%% equations used
function[S,K]=sect_matrices(E,G,v,p)
E1 = E * (1 - p);
E2 = E * (1 - p^0.5);
G12 = G * ((1-p)*(1-p^0.5)) / ((1-p) + (1-p^0.5));
G23 = G * (1 - p^0.5);
v12 = v * (1 - p);
v21 = v * (1 - p^0.5);


%Compliance[s] and stiffness[k] matrices
%%[S]
S=[ 1/E1, -v21/E2, -v21/E2, 0, 0, 0; ...
    -v12/E1,  1/E2, -v21/E2, 0, 0, 0; ...
    -v12/E1, -v21/E2,  1/E2, 0, 0, 0; ...
    0, 0, 0, 1/G23, 0, 0; ...
    0, 0, 0, 0, 1/G12, 0; ...
    0, 0, 0, 0, 0, 1/G12];

%calculate stiffness matrix[k]
K = inv(S);
end



