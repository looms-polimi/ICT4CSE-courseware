within ICT4CSE_2026.Session_01;

model Tracking
  "Digital PID in tracking/manual mode and then returned to automatic operation"
  extends Modelica.Icons.Example;
  parameter Real wc = 0.5 "Nominal crossover used for cancellation tuning";
  parameter Real K = 11*wc;
  parameter Real Ti = 11;
  parameter Real Td = 10.0/11.0;
  parameter Real N = 10;
  parameter Real Ts = 0.1;
  parameter Real uMin = 0;
  parameter Real uMax = 1;

  Modelica.Blocks.Sources.RealExpression SP(y = if time < 5 then 0 elseif time < 150 then min(0.2,0.01*(time-5)) else 0.1)
    annotation(Placement(transformation(origin={-150,70}, extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanExpression tracking(y = time >= 80 and time < 85)
    annotation(Placement(transformation(origin={-148,42}, extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression trackValue(y = 0.25)
    annotation(Placement(transformation(origin={-152,10}, extent={{-10,-10},{10,10}})));

  ICT4CSE.ControlBlocks.Modulating.Digital.PID_ISA_2dof_bias_tracking_locks_ovr C(
    K=K,
    Ti=Ti,
    Td=Td,
    N=N,
    b=1,
    c=0,
    Ts=Ts,
    CSmin=uMin,
    CSmax=uMax,
    hasBias= false,
    hasTracking=true,
    hasLocks=false,
    hasOvrMax=false,
    hasOvrMin=false)
    annotation(Placement(transformation(origin={-28,30}, extent={{-30,-50},{30,50}})));

  Modelica.Blocks.Continuous.TransferFunction P(b={1}, a={10,11,1})
    annotation(Placement(transformation(origin={84,70}, extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Sources.RealExpression Bias(y = SP.y) annotation(
    Placement(transformation(origin = {-150, 94}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(SP.y,C.SP) annotation(Line(points={{-139,70},{-64, 70}}, color={0,0,127}));
  connect(C.CS,P.u) annotation(Line(points={{8,70},{60, 70}}, color={0,0,127}));
  connect(P.y,C.PV) annotation(Line(points={{106,70},{125,70},{125,-70},{-90,-70},{-90,55.5},{-64,55.5}}, color={0,0,127}));
  connect(tracking.y,C.TS) annotation(Line(points={{-137,42},{-100,42},{-100,41.5},{-64,41.5}}, color={255,0,255}));
  connect(trackValue.y,C.TR) annotation(Line(points={{-141,10},{-110,10},{-110,32},{-64,32}}, color={0,0,127}));
  connect(Bias.y, C.Bias) annotation(
    Line(points = {{-138, 94}, {-28, 94}, {-28, 86}}, color = {0, 0, 127}));

annotation(
  Diagram(coordinateSystem(extent={{-180,-100},{150,110}})),
  experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-06, Interval = 0.05),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end Tracking;