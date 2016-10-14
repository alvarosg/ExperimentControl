# ExperimentControl
Software written in MATLAB to manage hardware typically used in an experimental physics setup.

The main purpose is to allow arbitrary scans of translation stages, or any other actuator, while storing information from cameras, pressure reader or any othe acquisition device.
The actuators go through an extra level of abstraction called "uses", which is the actual variable that is modified by the actuator, e.g. a rotation stage with a value set in degrees (actuator) may be used to control intensity (use) from 0 to 100% following a complex formula. 

It is implemented using abstraction so it is easy to add:
* New "acquisition devices", by inheriting from AbstractAcquisitionDevice.
* New "actuators", by inheriting from AbstractStageClass.
* New "uses", by inheriting from AbstractUseClass. 

For more information, see the class diagrams in documentation.

Copyright © 2015 - Alvaro Sanchez Gonzalez
