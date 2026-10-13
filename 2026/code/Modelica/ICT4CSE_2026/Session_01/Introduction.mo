within ICT4CSE_2026.Session_01;

model Introduction "First example created in the class"
  extends Modelica.Icons.Example;
  parameter Real p=0.5;
  parameter Real mu=1;
  parameter Real T=0.4;
  parameter Real Ts=0.5;
  parameter Real ystart=0;
  
  Real x1(start=0);
  Real y(start=ystart);
  Real u;
  
  discrete Real ud,v,v1(start=0);

equation
  y  + T*der(y)  = x1;
  x1 + T*der(x1) = mu*v;
  
  u = 1+0.5*sin(time);

algorithm
  when sample(0,Ts) then
       ud := u;
       v  := p*v1+(1-p)*ud;
       v1 := v;
  end when;


annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.02),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end Introduction;