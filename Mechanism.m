classdef Mechanism < DAC_ODEclass
  properties (SetAccess = protected, Hidden = true)  %% Copying model parameters from var-names.txt
    m
    g
    ell
      end  methods    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    function self = Mechanism(pars)

      n_ODE = 5;
      n_INV = 3;

      self@DAC_ODEclass('Mechanism', n_ODE, n_INV);

      self.m = pars(1);
      self.g = pars(2);
      self.ell = pars(3);

    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    function res__f = f(self, t, vars__)
    
      % States
      x = vars__(1);
      y = vars__(2);
      lambda = vars__(3);
      x__dot = vars__(4);
      y__dot = vars__(5);
    
      % Parameters 
      m = self.m;
      g = self.g;
      ell = self.ell;
    
      % Forces
      %u = 1/2 + 1/2 * sign(t-1); % Opens after 1 second
      %F_c_min = -k_cyl*min(s, 0);
      %F_contact = F_c_min;
    
      % Matrix A
      res__1_1 = 1;
      res__2_2 = 1;
      t1 = x ^ 2;
      t2 = y ^ 2;
      res__3_3 = 0.1e1 / m * (4 * t1 + 4 * t2);
      res__3_4 = -4 * x__dot;
      res__3_5 = -4 * y__dot;
      res__4_4 = m;
      res__5_5 = m;
      
      A = zeros(5,5);
      A(1,1) = res__1_1;
      A(2,2) = res__2_2;
      A(3,3) = res__3_3;
      A(3,4) = res__3_4;
      A(3,5) = res__3_5;
      A(4,4) = res__4_4;
      A(5,5) = res__5_5;
      
      % Vector F
      res__1_1 = x__dot;
      res__2_1 = y__dot;
      t1 = g * m;
      t4 = x * lambda;
      t7 = y * lambda;
      res__3_1 = 0.1e1 / m * (-2 * y__dot * t1 - 8 * x__dot * t4 - 8 * y__dot * t7);
      res__4_1 = -2 * t4;
      res__5_1 = -t1 - 2 * t7;
      
      F = zeros(5,1);
      F(1,1) = res__1_1;
      F(2,1) = res__2_1;
      F(3,1) = res__3_1;
      F(4,1) = res__4_1;
      F(5,1) = res__5_1;
      
      % Solution
      res__f = linsolve(A, F);
    
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    function res__DfDx = DfDx(self, t, vars__)
    
      % States
      x = vars__(1);
      y = vars__(2);
      lambda = vars__(3);
      x__dot = vars__(4);
      y__dot = vars__(5);
    
      % Parameters 
      m = self.m;
      g = self.g;
      ell = self.ell;
    
      % Forces
      %u = 1/2 + 1/2 * sign(t-1); % Opens after 1 second
      %F_c_min = -k_cyl*min(s, 0);
      %F_contact = F_c_min;
    
      % Matrix A
      res__1_1 = 1;
      res__2_2 = 1;
      t1 = x ^ 2;
      t2 = y ^ 2;
      res__3_3 = 0.1e1 / m * (4 * t1 + 4 * t2);
      res__3_4 = -4 * x__dot;
      res__3_5 = -4 * y__dot;
      res__4_4 = m;
      res__5_5 = m;
      
      A = zeros(5,5);
      A(1,1) = res__1_1;
      A(2,2) = res__2_2;
      A(3,3) = res__3_3;
      A(3,4) = res__3_4;
      A(3,5) = res__3_5;
      A(4,4) = res__4_4;
      A(5,5) = res__5_5;
      
      % Vector F
      res__1_1 = x__dot;
      res__2_1 = y__dot;
      t1 = g * m;
      t4 = x * lambda;
      t7 = y * lambda;
      res__3_1 = 0.1e1 / m * (-2 * y__dot * t1 - 8 * x__dot * t4 - 8 * y__dot * t7);
      res__4_1 = -2 * t4;
      res__5_1 = -t1 - 2 * t7;
      
      F = zeros(5,1);
      F(1,1) = res__1_1;
      F(2,1) = res__2_1;
      F(3,1) = res__3_1;
      F(4,1) = res__4_1;
      F(5,1) = res__5_1;
      
      % Solution of the ODE and extraction of eta
      res__f = linsolve(A, F);
      eta1 = res__f(1);
      eta2 = res__f(2);
      eta3 = res__f(3);
      eta4 = res__f(4);
      eta5 = res__f(5);
    
      % Jacobian of eta
      t1 = 0.1e1 / m;
      res__3_1 = 8 * eta3 * t1 * x;
      res__3_2 = 8 * eta3 * t1 * y;
      res__3_4 = -4 * eta4;
      res__3_5 = -4 * eta5;
      
      J_ETA = zeros(5,5);
      J_ETA(3,1) = res__3_1;
      J_ETA(3,2) = res__3_2;
      J_ETA(3,4) = res__3_4;
      J_ETA(3,5) = res__3_5;
      
    
      % Jacobian of F
      res__1_4 = 1;
      res__2_5 = 1;
      t1 = 0.1e1 / m;
      t2 = lambda * t1;
      res__3_1 = -8 * x__dot * t2;
      res__3_2 = -8 * y__dot * t2;
      res__3_3 = t1 * (-8 * x * x__dot - 8 * y * y__dot);
      res__3_4 = -8 * lambda * t1 * x;
      res__3_5 = t1 * (-2 * g * m - 8 * y * lambda);
      res__4_1 = -2 * lambda;
      res__4_3 = -2 * x;
      res__5_2 = res__4_1;
      res__5_3 = -2 * y;
      
      J_F = zeros(5,5);
      J_F(1,4) = res__1_4;
      J_F(2,5) = res__2_5;
      J_F(3,1) = res__3_1;
      J_F(3,2) = res__3_2;
      J_F(3,3) = res__3_3;
      J_F(3,4) = res__3_4;
      J_F(3,5) = res__3_5;
      J_F(4,1) = res__4_1;
      J_F(4,3) = res__4_3;
      J_F(5,2) = res__5_2;
      J_F(5,3) = res__5_3;
      
      % Solution
      res__DfDx = linsolve(A, J_F - J_ETA);
    
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    %% Generating from invariants.txt
    function res__h = h( self, t, vars__ )
      
      % parameters
      m = self.m;
      g = self.g;
      ell = self.ell;


      % extract states
      x = vars__(1);
      y = vars__(2);
      lambda = vars__(3);
      x__dot = vars__(4);
      y__dot = vars__(5);

      % forces definition
      %u = 1/2 + 1/2 * sign(t-1); % Opens after 1 second
      %F_c_min = -k_cyl*min(s, 0);
      %F_contact = F_c_min;

      % evaluate function
      t1 = ell ^ 2;
      t2 = x ^ 2;
      t3 = y ^ 2;
      res__1 = t1 - t2 - t3;
      res__2 = 2 * x * x__dot + 2 * y * y__dot;
      t8 = x__dot ^ 2;
      t9 = y__dot ^ 2;
      res__3 = 0.1e1 / m * (m * (2 * g * y - 2 * t8 - 2 * t9) + 4 * (t2 + t3) * lambda);
      

      % store on output
      res__h = zeros(3,1);
      res__h(1) = res__1;
      res__h(2) = res__2;
      res__h(3) = res__3;

    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    %% Generating from jacobian-invariants.txt
    function res__DhDx = DhDx( self, t, vars__ )
      
      % parameters
      m = self.m;
      g = self.g;
      ell = self.ell;


      % extract states
      x = vars__(1);
      y = vars__(2);
      lambda = vars__(3);
      x__dot = vars__(4);
      y__dot = vars__(5);

      % forces definition
      %u = 1/2 + 1/2 * sign(t-1); % Opens after 1 second
      %F_c_min = -k_cyl*min(s, 0);
      %F_contact = F_c_min;

      % evaluate function
      res__1_1 = -2 * x;
      res__1_2 = -2 * y;
      res__2_1 = 2 * x__dot;
      res__2_2 = 2 * y__dot;
      res__2_4 = 2 * x;
      res__2_5 = 2 * y;
      res__3_1 = 8 * x / m * lambda;
      res__3_2 = (2 * g * m + 8 * y * lambda) / m;
      res__3_3 = (4 * x ^ 2 + 4 * y ^ 2) / m;
      res__3_4 = -4 * x__dot;
      res__3_5 = -4 * y__dot;
      
      % store on output
      res__DhDx = zeros(3,5);
      res__DhDx(1,1) = res__1_1;
      res__DhDx(1,2) = res__1_2;
      res__DhDx(2,1) = res__2_1;
      res__DhDx(2,2) = res__2_2;
      res__DhDx(2,4) = res__2_4;
      res__DhDx(2,5) = res__2_5;
      res__DhDx(3,1) = res__3_1;
      res__DhDx(3,2) = res__3_2;
      res__DhDx(3,3) = res__3_3;
      res__DhDx(3,4) = res__3_4;
      res__DhDx(3,5) = res__3_5;
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    function plot( self, t, vars__ )      % extract states      x = vars__(1);      y = vars__(2);      u = vars__(3);      v = vars__(4);      tt = 0:pi/30:2*pi;      xx = self.ell*cos(tt);      yy = self.ell*sin(tt);      hold off;      plot(xx,yy,'LineWidth',2,'Color','red');      LL = 1-self.ell/hypot(x,y);      x0 = LL*x;      y0 = LL*y;      hold on;      L = 1.5*self.ell;      drawLine(-L,0,L,0,'LineWidth',2,'Color','k');      drawLine(0,-L,0,L,'LineWidth',2,'Color','k');      drawAxes(2,0.25,1,0,0);      drawLine(x0,y0,x,y,'LineWidth',8,'Color','b');      drawCOG( 0.1*self.ell, x0, y0 );      fillCircle( 'r', x, y, 0.1*self.ell );      axis([-L L -L L]);      title(sprintf('time=%5.2f',t));      axis equal;    end  endend