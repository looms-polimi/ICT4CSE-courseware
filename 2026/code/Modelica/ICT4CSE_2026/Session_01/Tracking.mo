within ICT4CSE_2026.Session_01;

model Tracking
  "Digital PID in tracking/manual mode and then returned to automatic operation"
  extends Modelica.Icons.Example;
  parameter Real wc = 0.1 "Nominal crossover used for cancellation tuning";
  parameter Real K = 11*wc;
  parameter Real Ti = 11;
  parameter Real Td = 10.0/11.0;
  parameter Real N = 10;
  parameter Real Ts = 0.1;
  parameter Real uMin = 0;
  parameter Real uMax = 1;

  Modelica.Blocks.Sources.RealExpression SP(y = if time < 5 then 0 else 0.8)
    annotation(Placement(transformation(origin={-150,70}, extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanExpression tracking(y = time >= 30 and time < 55)
    annotation(Placement(transformation(origin={-150,10}, extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression trackValue(y = 0.25)
    annotation(Placement(transformation(origin={-150,-30}, extent={{-10,-10},{10,10}})));

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
    hasBias=false,
    hasTracking=true,
    hasLocks=false,
    hasOvrMax=false,
    hasOvrMin=false)
    annotation(Placement(transformation(origin={-30,40}, extent={{-30,-50},{30,50}})));

  Modelica.Blocks.Continuous.TransferFunction P(b={1}, a={10,11,1})
    annotation(Placement(transformation(origin={80,40}, extent={{-20,-20},{20,20}})));

equation
  connect(SP.y,C.SP) annotation(Line(points={{-139,70},{-90,70},{-90,55},{-66,55}}, color={0,0,127}));
  connect(C.CS,P.u) annotation(Line(points={{6,55},{35,55},{35,40},{56,40}}, color={0,0,127}));
  connect(P.y,C.PV) annotation(Line(points={{102,40},{125,40},{125,-70},{-90,-70},{-90,35},{-66,35}}, color={0,0,127}));
  connect(tracking.y,C.TS) annotation(Line(points={{-139,10},{-100,10},{-100,63},{-66,63}}, color={255,0,255}));
  connect(trackValue.y,C.TR) annotation(Line(points={{-139,-30},{-110,-30},{-110,48},{-66,48}}, color={0,0,127}));

annotation(
  Diagram(coordinateSystem(extent={{-180,-100},{150,110}})),
  experiment(StartTime=0, StopTime=90, Tolerance=1e-6, Interval=0.05));
end Tracking;
