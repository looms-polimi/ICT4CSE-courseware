within ICT4CSE_2026.Session_01;

model Compare_IFB_IIR
  "Same continuous process controlled by the same PID law with different realisations"
  extends Modelica.Icons.Example;
  parameter Real wc = 0.1 "Nominal crossover used for cancellation tuning";
  parameter Real K = 11*wc;
  parameter Real Ti = 11;
  parameter Real Td = 10.0/11.0;
  parameter Real N = 10;
  parameter Real Ts = 0.1;
  parameter Real uMin = 0;
  parameter Real uMax = 0.6;

  Modelica.Blocks.Sources.RealExpression SP(y = if time < 5 then 0 else if time < 45 then 1 else 0.3)
    annotation(Placement(transformation(origin={-160,60}, extent={{-10,-10},{10,10}})));

  ICT4CSE.ControlBlocks.Modulating.Analogue.PID_ifb_derr C_ifb_a(
    K=K, Ti=Ti, Td=Td, N=N, CSmin=uMin, CSmax=uMax)
    annotation(Placement(transformation(origin={-58,100}, extent={{-20,-20},{20,20}})));
  ICT4CSE.ControlBlocks.Modulating.Digital.PID_ifb_derr C_ifb_d(
    K=K, Ti=Ti, Td=Td, N=N, Ts=Ts, CSmin=uMin, CSmax=uMax)
    annotation(Placement(transformation(origin={-60,20}, extent={{-20,-20},{20,20}})));
  ICT4CSE.ControlBlocks.Modulating.Digital.PID_1dof_nonminimum C_iir_d(
    K=K, Ti=Ti, Td=Td, N=N, Ts=Ts, CSmin=uMin, CSmax=uMax)
    annotation(Placement(transformation(origin={-58,-60}, extent={{-20,-20},{20,20}})));

  Modelica.Blocks.Continuous.TransferFunction P_ifb_a(b={1}, a={10,11,1})
    annotation(Placement(transformation(origin={60,100}, extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Continuous.TransferFunction P_ifb_d(b={1}, a={10,11,1})
    annotation(Placement(transformation(origin={60,20}, extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Continuous.TransferFunction P_iir_d(b={1}, a={10,11,1})
    annotation(Placement(transformation(origin={60,-60}, extent={{-20,-20},{20,20}})));

equation
  connect(SP.y,C_ifb_a.SP) annotation(Line(points={{-149,60},{-120,60},{-120,112},{-82,112}}, color={0,0,127}));
  connect(SP.y,C_ifb_d.SP) annotation(Line(points={{-149,60},{-120,60},{-120,32},{-84,32}}, color={0,0,127}));
  connect(SP.y,C_iir_d.SP) annotation(Line(points={{-149,60},{-120,60},{-120,-48},{-82,-48}}, color={0,0,127}));

  connect(C_ifb_a.CS,P_ifb_a.u) annotation(Line(points={{-34, 100},{36,100}}, color={0,0,127}));
  connect(C_ifb_d.CS,P_ifb_d.u) annotation(Line(points={{-36,32},{0,32},{0,20},{36,20}}, color={0,0,127}));
  connect(C_iir_d.CS,P_iir_d.u) annotation(Line(points={{-34, -60},{36,-60}}, color={0,0,127}));

  connect(P_ifb_a.y,C_ifb_a.PV) annotation(Line(points={{82,100},{110,100},{110,70},{-110,70},{-110,88},{-82,88}}, color={0,0,127}));
  connect(P_ifb_d.y,C_ifb_d.PV) annotation(Line(points={{82,20},{110,20},{110,-10},{-110,-10},{-110,24},{-84,24}}, color={0,0,127}));
  connect(P_iir_d.y,C_iir_d.PV) annotation(Line(points={{82,-60},{110,-60},{110,-90},{-110,-90},{-110,-72},{-82,-72}}, color={0,0,127}));

annotation(
  Diagram(coordinateSystem(extent={{-180,-120},{140,140}})),
  experiment(StartTime=0, StopTime=100, Tolerance=1e-6, Interval=0.05));
end Compare_IFB_IIR;