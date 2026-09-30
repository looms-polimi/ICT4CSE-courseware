within ICT4CSE_2026.Session_01;

model HelloWorld_sat
  "HelloWorld with output saturation in the IIR realisation"
  extends Modelica.Icons.Example;
  parameter Real Ts = 0.1 "Sampling time";
  parameter Real K = 1 "PI gain";
  parameter Real Ti = 10 "PI integral time; chosen to cancel the slow process pole";
  parameter Real uMin = 0;
  parameter Real uMax = 0.6;

  Real x1(start = 0), x2(start = 0);
  Real y, w;
  discrete Real e, u, uLin, u1, e1;

protected
  parameter Real b0 = K*(1 + Ts/Ti);
  parameter Real b1 = -K;

equation
  // P(s) = 1/((1+10s)(1+s))
  x2 + 10*der(x2) = u;
  x1 + der(x1) = x2;
  y = x1;

  // Force saturation, then return to the linear region
  w = if time < 5 then 0 else if time < 45 then 1 else 0.3;

algorithm
  when sample(0, Ts) then
    e    := w-y;
    uLin := u1+b0*e+b1*e1;
    u    := max(uMin,min(uMax,uLin));

    // IIR saturation management: the value remembered by the recursion
    // is the value actually issued by the block.
    u1   := u;
    e1   := e;
  end when;

initial algorithm
  u1 := 0;
  e1 := 0;

annotation(
  experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-6, Interval = 0.05));
end HelloWorld_sat;
