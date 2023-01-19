In this project the filtered backprojection algorithm is implemented in order to reconstruct
medical images. The method uses the parallel beam projection geometry and it can
manage data from a 180° scan with various number of projections. In order to test and
validate the algorithm, it is used the Shepp-Logan phantom that is a standard test image
created by Larry Shepp and Benjamin F. Logan in 1974. A previous filtration in the
frequency domain is necessary to enhance image resolution and is made by implementing
three different filters: Shepp-Logan filter, Hanning weighted filter and Ram-Lak filter
(also known as ramp filter). Thus, a comparison between these filters is carried out to
show the different results and define the final system. After that, the method is tested on
a clinical image taken from a female patient using a Toshiba scanner at Rigshospitalet.
Lastly, the image reconstruction algorithm is tested by simulating the effect of a missing
detector in the CT scanner.
