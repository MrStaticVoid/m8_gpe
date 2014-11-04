# HTC One (M8) Google Play Edition Automation Tools for Verizon #
This set of automation tools written in Puppet will take a dump of the
Gooogle Play Edition (GPE) build of Android for the HTC One (M8) and
modify it to run on the Verizon edition of the phone.

## Purpose ##
To serve as functional documentation for the process of converting the
GPE build to one that works on Verizon, capturing all of the tools,
processes, and configurations necessary.

To that end, the Puppet code hasn't been made as generic as it possibly
could have been.  There aren't variables and tunables for every little
thing, and a number of paths and URLs are hard-coded.

## Using ##
On any well-equipped Linux system with Puppet, make, wget, tar, zip, GCC,
and Git, run:

    % make

and the result should be a file called `m8_gpe.zip` that can be flashed
with a recovery tool like TWRP.

## Concessions ##
Generally, I would prefer an untouched build, but in this case, the
Torch.apk from the "DigitalHigh" ROM, which is itself modified from
CyanogenMod, works so well, I've included it in this build.  And since
I had to modify the image for that app, I might as well have included
root and busybox support too.  This is done in the least obtrusive,
most transparent way possible.
