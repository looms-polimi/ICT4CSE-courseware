ICT4CSE 2026 - Session_01 suggested live sequence

1. HelloWorld
   Continuous plant P(s)=1/((1+10s)(1+s)); monolithic digital PI.
   PI tuning by cancellation: Ti=10 cancels the slow process pole. With K=1
   and Ts=0.1, backward Euler gives C(z)=(1.01-z^-1)/(1-z^-1).

2. HelloWorld_sat
   Duplicate HelloWorld, add output saturation, and show the nonminimum IIR
   saturation-management rule: the recursion stores the issued (saturated)
   output, not the unconstrained one.

3. Open the library implementation of PI_ifb_dout and inspect how a reusable
   block is built. NOTE: in the current library snapshot there is no dedicated
   PI_ifb block with a bias input; bias currently appears in the richer
   PID_ISA_2dof_bias* blocks. Decide whether to add the dedicated PI block to
   the library before the lecture.

4. Compare_IFB_IIR
   Same continuous process and same PID law, comparing analogue IFB, digital
   IFB, and digital nonminimum-IIR realisations. The PID law is tuned by
   approximate process-pole cancellation: K=11*wc, Ti=11, Td=10/11.
   The model has a complete diagram annotation for use from OMEdit.

5. Tracking
   Use the full digital 2-dof ISA PID with a genuine nonzero derivative term.
   Tracking is active from t=30 to t=55 with TR=0.25, then automatic operation
   resumes. The model has a complete diagram annotation for use from OMEdit.
