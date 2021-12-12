# Assignment 5

For this assignment you will be writing assertions for an AHB-bus arbiter. Such a bus arbiter manages the control of an AHB bus, that can be driven by multiple masters.

![](https://kuleuven-diepenbeek.github.io/cdandverif/img/screenshot_604_ahb_arbiter.png)

When a master wants access to the AHB bus it has to

- raise the request signal
- wait for the grant signal
  - this will come within 16 clock cycles if no other grant is active. The arbiter works Round Robin.
- raise the lock signal if there will be a locked (which signals an indivisible transfer).

The minimum criteria to be asserted (to pass this assignment) are:

- grant can only be given to 1 master
- grant is always given
- grant goes LOW after a ready

More remarks:

- multiple requests can be pending
- only one master can be granted access
- You’ll probably need to Google
