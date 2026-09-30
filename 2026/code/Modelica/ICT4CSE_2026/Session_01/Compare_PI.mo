within ICT4CSE_2026.Session_01;

model Compare_PI
  "Same continuous process controlled by analogue/digital PI blocks with different realisations"
  extends Modelica.Icons.Example;
  parameter Real K = 1;
  parameter Real Ti = 10;
  parameter Real Ts = 0.1;
  parameter Real uMin = 0;
  parameter Real uMax = 0.6;

  Modelica.Blocks.Sources.RealExpression SP(
    y = if time < 5 then 0 else if time < 45 then 1 else 0.3);

  // IFB pair
  ICT4CSE.ControlBlocks.Modulating.Analogue.PI_ifb_dout C_ifb_a(
    K=K, Ti=Ti, CSmin=uMin, CSmax=uMax);
  ICT4CSE.ControlBlocks.Modulating.Digital.PI_ifb_dout C_ifb_d(
    K=K, Ti=Ti, Ts=Ts, CSmin=uMin, CSmax=uMax);

  // MSP/by-actions pair, specialised to PI by setting Td=0
  ICT4CSE.ControlBlocks.Modulating.Analogue.PID_parallel_dout C_msp_a(
    K=K, Ti=Ti, Td=0.01, N=10, CSmin=uMin, CSmax=uMax);
  ICT4CSE.ControlBlocks.Modulating.Digital.PID_parallel_dout C_msp_d(
    K=K, Ti=Ti, Td=0.01, N=10, Ts=Ts, CSmin=uMin, CSmax=uMax);

  Modelica.Blocks.Continuous.TransferFunction P_ifb_a(b={1}, a={10,11,1});
  Modelica.Blocks.Continuous.TransferFunction P_ifb_d(b={1}, a={10,11,1});
  Modelica.Blocks.Continuous.TransferFunction P_msp_a(b={1}, a={10,11,1});
  Modelica.Blocks.Continuous.TransferFunction P_msp_d(b={1}, a={10,11,1});

equation
  connect(SP.y,C_ifb_a.SP);
  connect(SP.y,C_ifb_d.SP);
  connect(SP.y,C_msp_a.SP);
  connect(SP.y,C_msp_d.SP);

  connect(P_ifb_a.y,C_ifb_a.PV);
  connect(P_ifb_d.y,C_ifb_d.PV);
  connect(P_msp_a.y,C_msp_a.PV);
  connect(P_msp_d.y,C_msp_d.PV);

  connect(C_ifb_a.CS,P_ifb_a.u);
  connect(C_ifb_d.CS,P_ifb_d.u);
  connect(C_msp_a.CS,P_msp_a.u);
  connect(C_msp_d.CS,P_msp_d.u);

annotation(
  experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-6, Interval = 0.05));
end Compare_PI;
