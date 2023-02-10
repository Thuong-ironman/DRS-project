  properties (SetAccess = protected, Hidden = true)
  %%% var-names.txt
    
  end
  methods
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %%% constructor.txt
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %%% ode.txt
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %%% jacobian-ode.txt
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %%% invariants.txt
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %%% jacobian-invariants.txt
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function plot( self, t, vars__ )
      % extract states
      x = vars__(1);
      y = vars__(2);
      u = vars__(3);
      v = vars__(4);

      tt = 0:pi/30:2*pi;
      xx = self.ell*cos(tt);
      yy = self.ell*sin(tt);
      hold off;
      plot(xx,yy,'LineWidth',2,'Color','red');
      LL = 1-self.ell/hypot(x,y);
      x0 = LL*x;
      y0 = LL*y;
      hold on;
      L = 1.5*self.ell;
      drawLine(-L,0,L,0,'LineWidth',2,'Color','k');
      drawLine(0,-L,0,L,'LineWidth',2,'Color','k');
      drawAxes(2,0.25,1,0,0);
      drawLine(x0,y0,x,y,'LineWidth',8,'Color','b');
      drawCOG( 0.1*self.ell, x0, y0 );
      fillCircle( 'r', x, y, 0.1*self.ell );
      axis([-L L -L L]);
      title(sprintf('time=%5.2f',t));
      axis equal;
    end
  end
end
