within ICT4CSE_2026.Session_01;

model HelloWorld
  "Minimal hybrid closed loop: continuous process and digital PI written monolithically"
  extends Modelica.Icons.Example;
  parameter Real Ts = 0.1 "Sampling time";
  parameter Real K = 1 "PI gain";
  parameter Real Ti = 10 "PI integral time; chosen to cancel the slow process pole";

  Real x1(start = 0), x2(start = 0);
  Real y, w;
  discrete Real e, u, u1, e1;

protected
  parameter Real b0 = K*(1 + Ts/Ti);
  parameter Real b1 = -K;

equation
  // P(s) = 1/((1+10s)(1+s))
  x2 + 10*der(x2) = u;
  x1 + der(x1) = x2;
  y = x1;

  // Set point
  w = if time < 5 then 0 else 1;

algorithm
  when sample(0, Ts) then
    e  := w-y;
    u  := u1+b0*e+b1*e1;
    u1 := u;
    e1 := e;
  end when;

initial algorithm
  u1 := 0;
  e1 := 0;

annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-6, Interval = 0.05));
end HelloWorld;
